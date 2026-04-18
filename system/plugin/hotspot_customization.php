<?php

/**
 * Hotspot Customization Plugin
 * Upload login.html themes as ZIPs and push them to MikroTik via FTP + RouterOS API
 */

register_menu("Hotspot Customization", true, "hotspot_customization", 'AFTER_SETTINGS', 'fa fa-paint-brush');

function hotspot_customization()
{
    global $ui;
    _admin();
    $admin = Admin::_info();
    $ui->assign('_admin', $admin);

    if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin'])) {
        $action = $_GET['action'] ?? '';
        if ($action === 'browse') {
            header('Content-Type: application/json');
            echo json_encode(['error' => 'Access denied']);
            exit;
        }
        r2(U . "dashboard", 'e', Lang::T("You Do Not Have Access"));
    }

    $action = $_GET['action'] ?? '';

    switch ($action) {
        case 'browse':
            _hc_browse();
            break;
        case 'delete':
            _hc_delete();
            break;
        default:
            if ($_SERVER['REQUEST_METHOD'] === 'POST') {
                $postAction = $_POST['_action'] ?? '';
                if ($postAction === 'upload') {
                    _hc_upload();
                } elseif ($postAction === 'apply') {
                    _hc_apply();
                } else {
                    _hc_main();
                }
            } else {
                _hc_main();
            }
    }
}

// ── DB helper ─────────────────────────────────────────────────────────────────

function _hc_db()
{
    global $db_host, $db_name, $db_user, $db_pass;
    static $conn = null;
    if ($conn === null) {
        $conn = new PDO("mysql:host=$db_host;dbname=$db_name;charset=utf8mb4", $db_user, $db_pass);
        $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $conn->exec("CREATE TABLE IF NOT EXISTS tbl_hotspot_themes (
            id          INT AUTO_INCREMENT PRIMARY KEY,
            name        VARCHAR(100)  NOT NULL,
            slug        VARCHAR(100)  NOT NULL UNIQUE,
            description TEXT,
            preview_img VARCHAR(255)  DEFAULT '',
            created_at  DATETIME      DEFAULT CURRENT_TIMESTAMP
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");
    }
    return $conn;
}

function _hc_themes_dir()
{
    $root = realpath(dirname(dirname(dirname(__FILE__))));
    $dir  = $root . DIRECTORY_SEPARATOR . 'upload' . DIRECTORY_SEPARATOR . 'hotspot_themes';
    if (!is_dir($dir)) {
        mkdir($dir, 0755, true);
    }
    return $dir;
}

// ── Main display ──────────────────────────────────────────────────────────────

function _hc_main()
{
    global $ui;
    $conn = _hc_db();

    $ui->assign('_title', 'Hotspot Customization');
    $ui->assign('_system_menu', 'settings');

    $routers = ORM::for_table('tbl_routers')->where('enabled', 1)->find_array();
    $ui->assign('routers', $routers);

    $themes = $conn->query("SELECT * FROM tbl_hotspot_themes ORDER BY created_at DESC")->fetchAll(PDO::FETCH_ASSOC);
    $ui->assign('themes', $themes);

    $saved = $conn->query("SELECT value FROM tbl_appconfig WHERE setting = 'hc_router_id'")->fetch(PDO::FETCH_ASSOC);
    $ui->assign('selected_router_id', $saved ? $saved['value'] : '');

    $ui->display('[plugin]hotspot_customization.tpl');
}

// ── Upload ZIP ────────────────────────────────────────────────────────────────

function _hc_upload()
{
    $conn = _hc_db();

    if (empty($_FILES['theme_zip']['tmp_name']) || $_FILES['theme_zip']['error'] !== UPLOAD_ERR_OK) {
        r2(U . "plugin/hotspot_customization", 'e', "No valid ZIP file uploaded");
    }

    $name = trim($_POST['theme_name'] ?? '');
    $desc = trim($_POST['theme_desc'] ?? '');

    if ($name === '') {
        r2(U . "plugin/hotspot_customization", 'e', "Theme name is required");
    }

    $slug    = preg_replace('/[^a-z0-9]+/', '_', strtolower($name));
    $destDir = _hc_themes_dir() . DIRECTORY_SEPARATOR . $slug;

    $zip = new ZipArchive();
    if ($zip->open($_FILES['theme_zip']['tmp_name']) !== true) {
        r2(U . "plugin/hotspot_customization", 'e', "Could not open ZIP file");
    }

    // Require login.html inside the ZIP
    $hasLogin = false;
    for ($i = 0; $i < $zip->numFiles; $i++) {
        if (basename($zip->statIndex($i)['name']) === 'login.html') {
            $hasLogin = true;
            break;
        }
    }
    if (!$hasLogin) {
        $zip->close();
        r2(U . "plugin/hotspot_customization", 'e', "ZIP must contain login.html");
    }

    if (!is_dir($destDir)) {
        mkdir($destDir, 0755, true);
    }
    $zip->extractTo($destDir);
    $zip->close();

    // Auto-detect preview image
    $preview = '';
    foreach (['preview.png', 'preview.jpg', 'screenshot.png', 'screenshot.jpg'] as $img) {
        if (file_exists($destDir . DIRECTORY_SEPARATOR . $img)) {
            $preview = $img;
            break;
        }
    }

    // Upsert theme record
    $exists = $conn->prepare("SELECT id FROM tbl_hotspot_themes WHERE slug = ?");
    $exists->execute([$slug]);
    if ($exists->fetch()) {
        $conn->prepare("UPDATE tbl_hotspot_themes SET name=?, description=?, preview_img=? WHERE slug=?")
             ->execute([$name, $desc, $preview, $slug]);
    } else {
        $conn->prepare("INSERT INTO tbl_hotspot_themes (name, slug, description, preview_img) VALUES (?,?,?,?)")
             ->execute([$name, $slug, $desc, $preview]);
    }

    r2(U . "plugin/hotspot_customization", 's', "Theme '$name' uploaded successfully");
}

// ── Apply theme to MikroTik ───────────────────────────────────────────────────

function _hc_apply()
{
    $conn = _hc_db();

    $router_id = intval($_POST['router_id'] ?? 0);
    $theme_id  = intval($_POST['theme_id']  ?? 0);
    $profile   = trim($_POST['hs_profile']  ?? 'default');

    if (!$router_id || !$theme_id) {
        r2(U . "plugin/hotspot_customization", 'e', "Select both a router and a theme");
    }

    $router = ORM::for_table('tbl_routers')->find_one($router_id);
    if (!$router) {
        r2(U . "plugin/hotspot_customization", 'e', "Router not found");
    }

    $themeRow = $conn->prepare("SELECT * FROM tbl_hotspot_themes WHERE id = ?");
    $themeRow->execute([$theme_id]);
    $theme = $themeRow->fetch(PDO::FETCH_ASSOC);
    if (!$theme) {
        r2(U . "plugin/hotspot_customization", 'e', "Theme not found");
    }

    $user     = $router['username'];
    $pass     = $router['password'];
    $localDir = _hc_themes_dir() . DIRECTORY_SEPARATOR . $theme['slug'];
    $remotDir = 'hotspot/' . $theme['slug'];

    // ── RouterOS API: push files via /tool/fetch then set html-directory ──────
    try {
        $client = Mikrotik::getClient($router['ip_address'], $user, $pass);

        // Upload every file — router fetches each one from the billing server
        $iter = new RecursiveIteratorIterator(
            new RecursiveDirectoryIterator($localDir, FilesystemIterator::SKIP_DOTS)
        );
        $uploaded = 0;
        foreach ($iter as $file) {
            $local    = $file->getPathname();
            $relative = ltrim(str_replace($localDir, '', $local), DIRECTORY_SEPARATOR . '/');
            $relative = str_replace(DIRECTORY_SEPARATOR, '/', $relative);
            $fileUrl  = APP_URL . '/upload/hotspot_themes/' . $theme['slug'] . '/' . $relative;
            $dstPath  = $remotDir . '/' . $relative;
            Mikrotik::fetchFile($client, $fileUrl, $dstPath);
            $uploaded++;
        }

        // Point the hotspot profile at the new theme directory
        Mikrotik::setHotspotHtmlDir($client, $profile, $remotDir);

    } catch (Exception $e) {
        r2(U . "plugin/hotspot_customization", 'e',
            "Router API error: " . $e->getMessage() . ". Check API port 8728 is open and credentials are correct.");
    }

    // Save last-used router
    $hasSetting = $conn->query("SELECT COUNT(*) FROM tbl_appconfig WHERE setting='hc_router_id'")->fetchColumn();
    if ($hasSetting) {
        $conn->prepare("UPDATE tbl_appconfig SET value=? WHERE setting='hc_router_id'")->execute([$router_id]);
    } else {
        $conn->prepare("INSERT INTO tbl_appconfig (setting,value) VALUES ('hc_router_id',?)")->execute([$router_id]);
    }

    r2(U . "plugin/hotspot_customization", 's',
        "Theme '{$theme['name']}' applied to router '{$router['name']}' (profile: $profile)");
}

// ── AJAX: browse router files ─────────────────────────────────────────────────

function _hc_browse()
{
    header('Content-Type: application/json');
    $router_id = intval($_GET['router_id'] ?? 0);
    if (!$router_id) {
        echo json_encode(['error' => 'No router selected']);
        exit;
    }
    $router = ORM::for_table('tbl_routers')->find_one($router_id);
    if (!$router) {
        echo json_encode(['error' => 'Router not found']);
        exit;
    }
    try {
        $client   = Mikrotik::getClient($router['ip_address'], $router['username'], $router['password']);
        $files    = Mikrotik::listFiles($client);
        $profiles = Mikrotik::getHotspotProfiles($client);
        echo json_encode(['files' => $files, 'profiles' => $profiles]);
    } catch (Exception $e) {
        echo json_encode(['error' => $e->getMessage()]);
    }
    exit;
}

// ── Delete theme ──────────────────────────────────────────────────────────────

function _hc_delete()
{
    $conn = _hc_db();
    $id   = intval($_GET['id'] ?? 0);

    $stmt = $conn->prepare("SELECT * FROM tbl_hotspot_themes WHERE id = ?");
    $stmt->execute([$id]);
    $theme = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$theme) {
        r2(U . "plugin/hotspot_customization", 'e', "Theme not found");
    }

    $dir = _hc_themes_dir() . DIRECTORY_SEPARATOR . $theme['slug'];
    if (is_dir($dir)) {
        _hc_rmdir($dir);
    }

    $conn->prepare("DELETE FROM tbl_hotspot_themes WHERE id = ?")->execute([$id]);
    r2(U . "plugin/hotspot_customization", 's', "Theme deleted");
}

function _hc_rmdir($dir)
{
    foreach (scandir($dir) as $item) {
        if ($item === '.' || $item === '..') {
            continue;
        }
        $path = $dir . DIRECTORY_SEPARATOR . $item;
        is_dir($path) ? _hc_rmdir($path) : unlink($path);
    }
    rmdir($dir);
}
