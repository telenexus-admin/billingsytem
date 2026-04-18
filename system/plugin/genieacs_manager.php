<?php
// File: system/plugin/genieacs_manager.php

// Register menu - check admin only when function is called
if (function_exists('register_menu')) {
    // Use a hook or check if admin is logged in before registering
    register_menu("GenieACS Manager", true, "genieacs_manager", 'AFTER_PLANS', 'ion ion-cloud');
}

function genieacs_manager()
{
    global $ui, $routes;
    
    // Enable error reporting for debugging
    error_reporting(E_ALL);
    ini_set('display_errors', 1);
    
    try {
        _admin();
        $ui->assign('_title', 'GenieACS Manager');
        $ui->assign('_system_menu', 'genieacs_manager');
        $admin = Admin::_info();
        $ui->assign('_admin', $admin);

        // Check user type for access - only Admin and SuperAdmin allowed
        if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin'])) {
            _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
            exit;
        }

        $action = isset($routes['2']) ? $routes['2'] : '';

    switch ($action) {
        case 'add-server':
            genieacs_add_server();
            break;
        case 'edit-server':
            genieacs_edit_server();
            break;
        case 'test-connection-temp':
            genieacs_test_connection_temp();
            break;
        case 'delete-server':
            genieacs_delete_server();
            break;
        case 'test-connection':
            genieacs_test_connection_ajax();
            break;
        case 'get-server':
            genieacs_get_server_ajax();
            break;
        case 'toggle-priority':
            genieacs_toggle_priority();
            break;
        case 'test-all':
            genieacs_test_all_connections();
            break;
        case 'get-statistics':
            genieacs_get_statistics();
            break;
        case 'get-local-stats':
            genieacs_get_local_stats_ajax();
            break;
        case 'get-device-count':
            genieacs_get_device_count_ajax();
            break;
        case 'batch-device-counts-optimized':
            genieacs_batch_device_counts_optimized();
            break;
        case 'clean-cache':
            clean_expired_cache();
            echo json_encode(['success' => true]);
            exit;
            break;
        case 'get-device-mappings':
            genieacs_get_device_mappings();
            break;
        case 'delete-device-mapping':
            genieacs_delete_device_mapping();
            break;
        case 'clear-all-mappings':
            genieacs_clear_all_mappings();
            break;
        case 'uninstall':
            genieacs_run_uninstall();
            break;
        case 'check-update':
            genieacs_check_update();
            break;
        case 'run-update':
            genieacs_run_update();
            break;
        default:
            genieacs_dashboard();
            break;
    }
    } catch (Throwable $e) {
        // Show error instead of blank page
        if (isset($ui) && is_object($ui)) {
            $ui->assign('error_message', 'GenieACS Manager Error: ' . htmlspecialchars($e->getMessage()) . '<br><br><pre>' . htmlspecialchars($e->getTraceAsString()) . '</pre>');
            $ui->assign('error_title', 'GenieACS Manager - Error');
            $ui->display('admin/error.tpl');
        } else {
            die('GenieACS Manager Error: ' . $e->getMessage() . '<br>File: ' . $e->getFile() . '<br>Line: ' . $e->getLine());
        }
    } catch (Exception $e) {
        // Show error instead of blank page
        if (isset($ui) && is_object($ui)) {
            $ui->assign('error_message', 'GenieACS Manager Error: ' . htmlspecialchars($e->getMessage()) . '<br><br><pre>' . htmlspecialchars($e->getTraceAsString()) . '</pre>');
            $ui->assign('error_title', 'GenieACS Manager - Error');
            $ui->display('admin/error.tpl');
        } else {
            die('GenieACS Manager Error: ' . $e->getMessage() . '<br>File: ' . $e->getFile() . '<br>Line: ' . $e->getLine());
        }
    }
}

/**
 * Create GenieACS tables if they do not exist (auto-setup so Manage Server works without a separate installer).
 */
function genieacs_ensure_tables()
{
    $tables_sql = [
        'tbl_acs_servers' => "CREATE TABLE IF NOT EXISTS `tbl_acs_servers` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `name` varchar(255) NOT NULL,
            `host` varchar(255) NOT NULL,
            `port` int(11) NOT NULL DEFAULT 7557,
            `username` varchar(255) NOT NULL,
            `password` varchar(255) NOT NULL,
            `use_ssl` tinyint(1) NOT NULL DEFAULT 0,
            `status` varchar(32) NOT NULL DEFAULT 'active',
            `is_connected` tinyint(1) NOT NULL DEFAULT 0,
            `last_check` datetime DEFAULT NULL,
            `last_response_time` decimal(12,2) DEFAULT NULL,
            `is_priority` tinyint(1) NOT NULL DEFAULT 0,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
        'tbl_acs_devices' => "CREATE TABLE IF NOT EXISTS `tbl_acs_devices` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `server_id` int(11) NOT NULL,
            `device_id` varchar(255) NOT NULL,
            `device_data` longtext,
            `last_sync` datetime DEFAULT NULL,
            `status` varchar(32) DEFAULT 'offline',
            `last_inform` datetime DEFAULT NULL,
            PRIMARY KEY (`id`),
            UNIQUE KEY `server_device` (`server_id`,`device_id`),
            KEY `server_id` (`server_id`),
            KEY `status` (`status`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
        'tbl_acs_cache' => "CREATE TABLE IF NOT EXISTS `tbl_acs_cache` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `server_id` int(11) NOT NULL,
            `cache_key` varchar(128) NOT NULL,
            `cache_value` longtext,
            `expires_at` datetime NOT NULL,
            `created_at` datetime DEFAULT NULL,
            PRIMARY KEY (`id`),
            KEY `server_key` (`server_id`,`cache_key`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
        'tbl_acs_parameters' => "CREATE TABLE IF NOT EXISTS `tbl_acs_parameters` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `param_key` varchar(128) NOT NULL,
            `param_label` varchar(255) NOT NULL,
            `param_path` varchar(512) DEFAULT NULL,
            `param_type` varchar(32) NOT NULL DEFAULT 'display',
            `param_category` varchar(64) NOT NULL DEFAULT 'basic',
            `is_required` tinyint(1) NOT NULL DEFAULT 0,
            `display_order` int(11) NOT NULL DEFAULT 0,
            PRIMARY KEY (`id`),
            UNIQUE KEY `param_key` (`param_key`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
        'tbl_acs_password_history' => "CREATE TABLE IF NOT EXISTS `tbl_acs_password_history` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `device_id` varchar(255) NOT NULL,
            `admin_username` varchar(128) DEFAULT NULL,
            `changed_at` datetime DEFAULT NULL,
            PRIMARY KEY (`id`),
            KEY `device_id` (`device_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
        'tbl_acs_webadmin_history' => "CREATE TABLE IF NOT EXISTS `tbl_acs_webadmin_history` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `device_id` varchar(255) NOT NULL,
            `admin_username` varchar(128) DEFAULT NULL,
            `changed_at` datetime DEFAULT NULL,
            PRIMARY KEY (`id`),
            KEY `device_id` (`device_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
        'tbl_device_mapping' => "CREATE TABLE IF NOT EXISTS `tbl_device_mapping` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `server_id` int(11) NOT NULL,
            `device_id` varchar(255) NOT NULL,
            `username` varchar(128) NOT NULL,
            `last_updated` datetime DEFAULT NULL,
            PRIMARY KEY (`id`),
            KEY `server_id` (`server_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
    ];
    foreach ($tables_sql as $table => $sql) {
        try {
            ORM::raw_execute($sql);
        } catch (Exception $e) {
            error_log("GenieACS ensure table {$table}: " . $e->getMessage());
        }
    }
    // Add status/last_inform to tbl_acs_devices if table already existed without them
    try {
        ORM::raw_execute("ALTER TABLE `tbl_acs_devices` ADD COLUMN `status` varchar(32) DEFAULT 'offline'");
    } catch (Exception $e) {
        // Column may already exist
    }
    try {
        ORM::raw_execute("ALTER TABLE `tbl_acs_devices` ADD COLUMN `last_inform` datetime DEFAULT NULL");
    } catch (Exception $e) {
        // Column may already exist
    }
}

function genieacs_dashboard()
{
    global $ui;

    // Auto-create tables if missing so Manage Server works without a separate installer
    genieacs_ensure_tables();

    try {
        ORM::for_table('tbl_acs_servers')->count();
    } catch (Exception $e) {
        $ui->assign('_title', 'GenieACS Manager - Error');
        $ui->assign('error_message', 'GenieACS tables could not be created or accessed. Please check database permissions.<br><br>Error: ' . htmlspecialchars($e->getMessage()));
        $ui->display('admin/error.tpl');
        return;
    }

    // Pagination parameters with validation
    $page = isset($_GET['page']) ? intval($_GET['page']) : 1;
    if ($page < 1) $page = 1;

    $per_page = isset($_GET['per_page']) ? intval($_GET['per_page']) : 10;
    if ($per_page < 10) $per_page = 10;
    if ($per_page > 100) $per_page = 100;

    $offset = ($page - 1) * $per_page;

    // Get total count for pagination
    try {
        $total_servers = ORM::for_table('tbl_acs_servers')
            ->where('status', 'active')
            ->count();
    } catch (Exception $e) {
        $total_servers = 0;
    }

    // Load servers with pagination
    try {
        $servers = ORM::for_table('tbl_acs_servers')
            ->where('status', 'active')
            ->order_by_desc('is_priority')
            ->order_by_asc('name')
            ->limit($per_page)
            ->offset($offset)
            ->find_many();
    } catch (Exception $e) {
        $servers = [];
    }

    // Calculate pagination info
    $total_pages = ceil($total_servers / $per_page);
    $ui->assign('current_page', $page);
    $ui->assign('total_pages', $total_pages);
    $ui->assign('per_page', $per_page);

    // Calculate statistics (without device count for now)
    $online_servers = 0;
    $offline_servers = 0;
    $total_response_time = 0;
    $servers_with_response = 0;

    // Enhanced server data WITHOUT device count (will load async)
    $enhanced_servers = [];

    foreach ($servers as $server) {
        // Count online/offline
        if ($server->is_connected) {
            $online_servers++;
        } else {
            $offline_servers++;
        }

        // Calculate response time if available
        if ($server->last_response_time > 0) {
            $total_response_time += $server->last_response_time;
            $servers_with_response++;
        }

        // Set device_count as loading placeholder
        $server->device_count = 'loading';
        $enhanced_servers[] = $server;
    }

    // Calculate average response time
    $avg_response_time = $servers_with_response > 0
        ? round($total_response_time / $servers_with_response, 2)
        : 0;

    // Assign all statistics
    $ui->assign('servers', $enhanced_servers);
    $ui->assign('server_count', $total_servers);
    $ui->assign('online_servers', $online_servers);
    $ui->assign('offline_servers', $offline_servers);
    $ui->assign('total_devices', 0); // Will be calculated client-side
    $ui->assign('avg_response_time', $avg_response_time);

    // Calculate percentages for charts
    $online_percentage = $total_servers > 0
        ? round(($online_servers / $total_servers) * 100, 1)
        : 0;
    $ui->assign('online_percentage', $online_percentage);

    // Get local server stats
    try {
        $local_stats = get_local_server_stats();
        $ui->assign('local_stats', $local_stats);
    } catch (Exception $e) {
        // If get_local_server_stats fails, use empty stats
        $ui->assign('local_stats', []);
    }

    // Display template
    try {
        $ui->display('genieacs_manager.tpl');
    } catch (Exception $e) {
        // If template not found, show helpful error
        $ui->assign('error_message', 'GenieACS Manager template not found.<br><br>Please ensure the installation completed successfully.<br>Error: ' . htmlspecialchars($e->getMessage()));
        $ui->assign('error_title', 'GenieACS Manager - Template Error');
        if (file_exists(__DIR__ . '/ui/genieacs_manager.tpl')) {
            $ui->assign('error_message', 'Template exists but cannot be loaded. Error: ' . htmlspecialchars($e->getMessage()));
        }
        $ui->display('admin/error.tpl');
    }
}
// Get local server statistics
function get_local_server_stats()
{
    $stats = [];

    // CPU Load Average - Windows compatible
    if (function_exists('sys_getloadavg')) {
        $load = @sys_getloadavg();
        if ($load !== false && is_array($load)) {
            $stats['load_1min'] = round($load[0], 2);
            $stats['load_5min'] = round($load[1], 2);
            $stats['load_15min'] = round($load[2], 2);
        } else {
            $stats['load_1min'] = 0;
            $stats['load_5min'] = 0;
            $stats['load_15min'] = 0;
        }
    } else {
        // Windows doesn't have sys_getloadavg
        $stats['load_1min'] = 0;
        $stats['load_5min'] = 0;
        $stats['load_15min'] = 0;
    }

    // CPU Cores count
    $cpu_cores = 1;
    if (is_file('/proc/cpuinfo')) {
        $cpuinfo = file_get_contents('/proc/cpuinfo');
        preg_match_all('/^processor/m', $cpuinfo, $matches);
        $cpu_cores = count($matches[0]);
    } elseif (PHP_OS_FAMILY === 'Windows') {
        // Windows: Get CPU cores from environment
        $cpu_cores = (int)shell_exec('echo %NUMBER_OF_PROCESSORS%');
        if ($cpu_cores < 1) $cpu_cores = 1;
    }
    $stats['cpu_cores'] = $cpu_cores;
    $stats['cpu_usage'] = $stats['load_1min'] > 0 ? min(100, round(($stats['load_1min'] / $cpu_cores) * 100, 1)) : 0;

    // Memory Info - Initialize defaults
    $stats['mem_total'] = 0;
    $stats['mem_used'] = 0;
    $stats['mem_available'] = 0;
    $stats['mem_usage'] = 0;
    $stats['mem_total_gb'] = 0;
    $stats['mem_used_gb'] = 0;
    $stats['mem_available_gb'] = 0;
    
    if (PHP_OS_FAMILY === 'Linux') {
        $free = shell_exec('free -b');
        if ($free) {
            $free_lines = explode("\n", trim($free));
            $mem_line = preg_split('/\s+/', $free_lines[1]);

            $stats['mem_total'] = isset($mem_line[1]) ? intval($mem_line[1]) : 0;
            $stats['mem_used'] = isset($mem_line[2]) ? intval($mem_line[2]) : 0;
            $stats['mem_free'] = isset($mem_line[3]) ? intval($mem_line[3]) : 0;
            $stats['mem_available'] = isset($mem_line[6]) ? intval($mem_line[6]) : $stats['mem_free'];
            $stats['mem_usage'] = $stats['mem_total'] > 0
                ? round(($stats['mem_used'] / $stats['mem_total']) * 100, 1)
                : 0;

            // Convert to human readable
            $stats['mem_total_gb'] = round($stats['mem_total'] / 1073741824, 2);
            $stats['mem_used_gb'] = round($stats['mem_used'] / 1073741824, 2);
            $stats['mem_available_gb'] = round($stats['mem_available'] / 1073741824, 2);
        }
    }

    // Disk Usage - Windows compatible
    $disk_root = PHP_OS_FAMILY === 'Windows' ? 'C:\\' : '/';
    $disk_free = @disk_free_space($disk_root);
    $disk_total = @disk_total_space($disk_root);
    $disk_used = ($disk_total && $disk_free) ? ($disk_total - $disk_free) : 0;

    $stats['disk_total'] = $disk_total;
    $stats['disk_used'] = $disk_used;
    $stats['disk_free'] = $disk_free;
    $stats['disk_usage'] = round(($disk_used / $disk_total) * 100, 1);
    $stats['disk_total_gb'] = round($disk_total / 1073741824, 2);
    $stats['disk_used_gb'] = round($disk_used / 1073741824, 2);
    $stats['disk_free_gb'] = round($disk_free / 1073741824, 2);

    // System Uptime - Windows compatible
    $uptime_str = 'Unknown';
    if (is_file('/proc/uptime')) {
        $uptime = file_get_contents('/proc/uptime');
        $uptime_seconds = (float) explode(' ', $uptime)[0];
        $days = (int) floor($uptime_seconds / 86400);
        $hours = (int) floor(fmod($uptime_seconds, 86400) / 3600);
        $minutes = (int) floor(fmod($uptime_seconds, 3600) / 60);

        $uptime_str = '';
        if ($days > 0) $uptime_str .= $days . 'd ';
        if ($hours > 0) $uptime_str .= $hours . 'h ';
        $uptime_str .= $minutes . 'm';

        $stats['uptime_seconds'] = $uptime_seconds;
        $stats['uptime_string'] = trim($uptime_str);
    } elseif (PHP_OS_FAMILY === 'Windows') {
        // Windows: Try to get uptime (not always available)
        $stats['uptime_string'] = 'N/A (Windows)';
        $stats['uptime_seconds'] = 0;
    } else {
        $stats['uptime_string'] = $uptime_str;
        $stats['uptime_seconds'] = 0;
    }

    // Server Info - Fix for LXC/Container
    $stats['hostname'] = gethostname();

    // Check if running in container (skip if /proc/1/environ not readable - e.g. permission denied)
    if (file_exists('/proc/1/environ') && is_readable('/proc/1/environ')) {
        $environ = @file_get_contents('/proc/1/environ');
        if ($environ !== false && (strpos($environ, 'container=lxc') !== false || file_exists('/.dockerenv'))) {
            // Get container hostname properly
            if (file_exists('/etc/hostname')) {
                $stats['hostname'] = trim(file_get_contents('/etc/hostname'));
            }
            $stats['container'] = 'LXC/Container';
        }
    }

    // Get OS info from /etc/os-release if available
    if (file_exists('/etc/os-release')) {
        $os_info = parse_ini_file('/etc/os-release');
        $stats['os'] = isset($os_info['PRETTY_NAME']) ? $os_info['PRETTY_NAME'] : PHP_OS_FAMILY;
    } else {
        $stats['os'] = PHP_OS_FAMILY;
    }

    $stats['php_version'] = PHP_VERSION;

    return $stats;
}
// AJAX handler for local server stats
function genieacs_get_local_stats_ajax()
{
    header('Content-Type: application/json');

    $stats = get_local_server_stats();

    echo json_encode([
        'success' => true,
        'stats' => $stats,
        'timestamp' => time()
    ]);
    exit;
}
// ============================================
// CACHE FUNCTIONS - NEW
// ============================================

// Get cache data
function get_cache($server_id, $key)
{
    $cache = ORM::for_table('tbl_acs_cache')
        ->where('server_id', $server_id)
        ->where('cache_key', $key)
        ->where_gt('expires_at', date('Y-m-d H:i:s'))
        ->find_one();

    if ($cache) {
        return json_decode($cache->cache_value, true);
    }
    return null;
}

// Set cache data
function set_cache($server_id, $key, $value, $ttl = 300)
{
    // Delete old cache
    ORM::for_table('tbl_acs_cache')
        ->where('server_id', $server_id)
        ->where('cache_key', $key)
        ->delete_many();

    // Insert new cache
    $cache = ORM::for_table('tbl_acs_cache')->create();
    $cache->server_id = $server_id;
    $cache->cache_key = $key;
    $cache->cache_value = json_encode($value);
    $cache->expires_at = date('Y-m-d H:i:s', time() + $ttl);
    $cache->created_at = date('Y-m-d H:i:s');
    $cache->save();
}
// Clear specific cache or all cache for a server (GenieACS cache)
function clear_acs_cache($server_id = null, $cache_key = null)
{
    if ($server_id && $cache_key) {
        // Clear specific cache
        ORM::for_table('tbl_acs_cache')
            ->where('server_id', $server_id)
            ->where('cache_key', $cache_key)
            ->delete_many();
    } elseif ($server_id) {
        // Clear all cache for a server
        ORM::for_table('tbl_acs_cache')
            ->where('server_id', $server_id)
            ->delete_many();
    } else {
        // Clear all cache
        ORM::for_table('tbl_acs_cache')->delete_many();
    }
}

// Force refresh device count (bypass cache)
function force_refresh_device_count($server_id)
{
    // Clear existing cache
    clear_acs_cache($server_id, 'device_count');

    // Get fresh count
    $config = load_genieacs_config($server_id);
    if (!$config || empty($config['host'])) {
        return 0;
    }

    // Get only IDs for counting
    $result = genieacs_api_call('devices?projection=_id', 'GET', null, $server_id);

    if ($result['success'] && isset($result['data'])) {
        $count = is_array($result['data']) ? count($result['data']) : 0;

        // Cache with shorter TTL (10 minutes for fresh data)
        set_cache($server_id, 'device_count', $count, 600);

        return $count;
    }

    return 0;
}

/**
 * Sync devices from GenieACS API into tbl_acs_devices for a given server.
 * Used by cron_acs_sync.php (CLI) and by Force Sync (web). Returns result array.
 *
 * @param int $server_id ACS server ID
 * @return array { success: bool, total: int, inserted: int, updated: int, deleted: int, error?: string }
 */
function genieacs_sync_devices_for_server($server_id)
{
    $server_id = (int) $server_id;
    $out = ['success' => false, 'total' => 0, 'inserted' => 0, 'updated' => 0, 'deleted' => 0];

    if ($server_id <= 0) {
        $out['error'] = 'Invalid server ID';
        return $out;
    }

    $config = load_genieacs_config($server_id);
    if (!$config || empty($config['host'])) {
        $out['error'] = 'Server not configured or not found';
        return $out;
    }

    $result = genieacs_api_call('devices', 'GET', null, $server_id);
    if (!$result['success']) {
        $out['error'] = $result['error'] ?? 'GenieACS API error';
        return $out;
    }

    $devices = $result['data'];
    if (!is_array($devices)) {
        $devices = [];
    }

    $now = date('Y-m-d H:i:s');
    $inserted = 0;
    $updated = 0;

    foreach ($devices as $device) {
        $device_id = isset($device['_id']) ? $device['_id'] : null;
        if ($device_id === null || $device_id === '') {
            continue;
        }
        $device_data = json_encode($device);
        $status = 'offline';
        $last_inform = null;
        if (isset($device['_lastInform'])) {
            $last_inform = $device['_lastInform'];
            $ts = is_numeric($last_inform) ? (int)$last_inform : strtotime($last_inform);
            if ($ts && (time() - $ts) <= 300) {
                $status = 'online';
            }
        }

        $row = ORM::for_table('tbl_acs_devices')
            ->where('server_id', $server_id)
            ->where('device_id', $device_id)
            ->find_one();

        if ($row) {
            $row->device_data = $device_data;
            $row->last_sync = $now;
            $row->status = $status;
            $row->last_inform = $last_inform ? date('Y-m-d H:i:s', is_numeric($last_inform) ? $last_inform : strtotime($last_inform)) : null;
            $row->save();
            $updated++;
        } else {
            $new = ORM::for_table('tbl_acs_devices')->create();
            $new->server_id = $server_id;
            $new->device_id = $device_id;
            $new->device_data = $device_data;
            $new->last_sync = $now;
            $new->status = $status;
            $new->last_inform = $last_inform ? date('Y-m-d H:i:s', is_numeric($last_inform) ? $last_inform : strtotime($last_inform)) : null;
            $new->save();
            $inserted++;
        }
    }

    $synced_ids = array_values(array_filter(array_map(function ($d) {
        return isset($d['_id']) ? $d['_id'] : null;
    }, $devices)));
    $deleted = 0;
    if (count($synced_ids) > 0) {
        $deleted = ORM::for_table('tbl_acs_devices')
            ->where('server_id', $server_id)
            ->where_not_in('device_id', $synced_ids)
            ->delete_many();
    }

    $out['success'] = true;
    $out['total'] = count($devices);
    $out['inserted'] = $inserted;
    $out['updated'] = $updated;
    $out['deleted'] = $deleted;
    return $out;
}

// Clean expired cache
function clean_expired_cache()
{
    ORM::for_table('tbl_acs_cache')
        ->where_lt('expires_at', date('Y-m-d H:i:s'))
        ->delete_many();
}

// ============================================
// ASYNC DEVICE COUNT FUNCTIONS - NEW
// ============================================

// Async function to get device count for a single server
function genieacs_get_device_count_ajax()
{
    header('Content-Type: application/json');

    $server_id = intval($_GET['server_id'] ?? 0);
    $force_refresh = isset($_GET['force']) && $_GET['force'] == 'true';

    if ($server_id <= 0) {
        echo json_encode(['success' => false, 'count' => 0]);
        exit;
    }

    // Force refresh if requested
    if ($force_refresh) {
        $count = force_refresh_device_count($server_id);
        echo json_encode(['success' => true, 'count' => $count, 'cached' => false]);
        exit;
    }

    // Check cache with intelligent TTL
    $cached = get_cache($server_id, 'device_count');
    if ($cached !== null) {
        // Check cache age
        $cache_data = ORM::for_table('tbl_acs_cache')
            ->where('server_id', $server_id)
            ->where('cache_key', 'device_count')
            ->find_one();

        if ($cache_data) {
            $cache_age = time() - strtotime($cache_data->created_at);

            // If cache is less than 5 minutes old, use it
            if ($cache_age < 300) {
                echo json_encode(['success' => true, 'count' => $cached, 'cached' => true, 'age' => $cache_age]);
                exit;
            }

            // If cache is 5-30 minutes old, return cached but trigger background refresh
            if ($cache_age < 1800) {
                echo json_encode(['success' => true, 'count' => $cached, 'cached' => true, 'stale' => true]);

                // Trigger async refresh (non-blocking)
                // This will update cache for next request
                force_refresh_device_count($server_id);
                exit;
            }
        }
    }

    // Cache expired or not found, get fresh data
    $count = force_refresh_device_count($server_id);
    echo json_encode(['success' => true, 'count' => $count, 'cached' => false]);
    exit;
}

// Batch get device counts
function genieacs_batch_device_counts()
{
    header('Content-Type: application/json');

    $server_ids = isset($_POST['server_ids']) ? $_POST['server_ids'] : [];
    $results = [];

    foreach ($server_ids as $server_id) {
        $server_id = intval($server_id);

        // Check cache first
        $cached = get_cache($server_id, 'device_count');
        if ($cached !== null) {
            $results[$server_id] = ['count' => $cached, 'cached' => true];
            continue;
        }

        // For non-cached, return placeholder
        $results[$server_id] = ['count' => 'pending', 'cached' => false];
    }

    echo json_encode(['success' => true, 'results' => $results]);
    exit;
}
// Optimized batch device count with parallel curl
function genieacs_batch_device_counts_optimized()
{
    header('Content-Type: application/json');

    $server_ids = isset($_POST['server_ids']) ? $_POST['server_ids'] : [];
    if (empty($server_ids)) {
        echo json_encode(['success' => false, 'results' => []]);
        exit;
    }

    $results = [];
    $multi_handle = curl_multi_init();
    $curl_handles = [];

    // Setup parallel requests
    foreach ($server_ids as $server_id) {
        $server_id = intval($server_id);

        // Check cache first
        $cached = get_cache($server_id, 'device_count');
        if ($cached !== null) {
            $results[$server_id] = ['count' => $cached, 'cached' => true];
            continue;
        }

        // Setup curl for non-cached servers
        $config = load_genieacs_config($server_id);
        if ($config && !empty($config['host'])) {
            $url = get_genieacs_api_url($config, 'devices?projection=_id');

            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, $url);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_TIMEOUT, 5);
            curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 2);
            curl_setopt($ch, CURLOPT_USERPWD, $config['username'] . ':' . $config['password']);
            curl_setopt($ch, CURLOPT_HTTPHEADER, ['Accept: application/json']);

            if (!is_ip_address($config['host'])) {
                curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
                curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
            }

            curl_multi_add_handle($multi_handle, $ch);
            $curl_handles[$server_id] = $ch;
        }
    }

    // Execute parallel requests
    $running = null;
    do {
        curl_multi_exec($multi_handle, $running);
        curl_multi_select($multi_handle);
    } while ($running > 0);

    // Process results
    foreach ($curl_handles as $server_id => $ch) {
        $response = curl_multi_getcontent($ch);
        $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);

        if ($http_code == 200) {
            $data = json_decode($response, true);
            $count = is_array($data) ? count($data) : 0;

            // Cache result
            set_cache($server_id, 'device_count', $count, 1800);
            $results[$server_id] = ['count' => $count, 'cached' => false];
        } else {
            $results[$server_id] = ['count' => 0, 'error' => true];
        }

        curl_multi_remove_handle($multi_handle, $ch);
        curl_close($ch);
    }

    curl_multi_close($multi_handle);

    echo json_encode(['success' => true, 'results' => $results]);
    exit;
}

// Add new helper function for API call with timeout
function genieacs_api_call_with_timeout($endpoint, $method = 'GET', $data = null, $server_id = null, $timeout = 5)
{
    $config = load_genieacs_config($server_id);

    if (!$config || empty($config['host'])) {
        return ['success' => false, 'error' => 'Server not configured'];
    }

    $url = get_genieacs_api_url($config, $endpoint);

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_TIMEOUT, $timeout);
    curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, $timeout);
    curl_setopt($ch, CURLOPT_USERPWD, $config['username'] . ':' . $config['password']);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Content-Type: application/json',
        'Accept: application/json'
    ]);

    if (!is_ip_address($config['host'])) {
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
    }

    if ($method === 'POST' && $data) {
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
    }

    $response = curl_exec($ch);
    $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $response_time = curl_getinfo($ch, CURLINFO_TOTAL_TIME);
    curl_close($ch);

    // Update response time in database
    if ($server_id) {
        $server = ORM::for_table('tbl_acs_servers')->find_one($server_id);
        if ($server) {
            $server->last_response_time = $response_time * 1000; // Convert to ms
            $server->save();
        }
    }

    return [
        'success' => ($http_code >= 200 && $http_code < 300),
        'data' => json_decode($response, true),
        'response_time' => $response_time
    ];
}
// ADD NEW SERVER
function genieacs_add_server()
{
    header('Content-Type: application/json');

    if (!$_POST) {
        echo json_encode(['success' => false, 'message' => 'No data received']);
        exit;
    }

    $name = trim($_POST['name'] ?? '');
    $host = trim($_POST['host'] ?? '');
    $port = intval($_POST['port'] ?? 7557);
    $username = trim($_POST['username'] ?? '');
    $password = trim($_POST['password'] ?? '');

    // Validation
    if (empty($name) || empty($host) || empty($username) || empty($password)) {
        echo json_encode(['success' => false, 'message' => 'All fields are required']);
        exit;
    }

    // Check if domain or IP
    $use_ssl = !filter_var($host, FILTER_VALIDATE_IP);

    try {
        $server = ORM::for_table('tbl_acs_servers')->create();
        $server->name = $name;
        $server->host = $host;
        $server->port = $port;
        $server->username = $username;
        $server->password = $password;
        $server->use_ssl = $use_ssl ? 1 : 0;
        $server->status = 'active';
        $server->save();

        echo json_encode(['success' => true, 'message' => 'Server added successfully']);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    }
    exit;
}

// EDIT SERVER
function genieacs_edit_server()
{
    header('Content-Type: application/json');

    if (!$_POST) {
        echo json_encode(['success' => false, 'message' => 'No data received']);
        exit;
    }

    $id = intval($_POST['id'] ?? 0);
    $name = trim($_POST['name'] ?? '');
    $host = trim($_POST['host'] ?? '');
    $port = intval($_POST['port'] ?? 7557);
    $username = trim($_POST['username'] ?? '');
    $password = trim($_POST['password'] ?? '');

    if ($id <= 0) {
        echo json_encode(['success' => false, 'message' => 'Invalid server ID']);
        exit;
    }

    // Validation
    if (empty($name) || empty($host) || empty($username) || empty($password)) {
        echo json_encode(['success' => false, 'message' => 'All fields are required']);
        exit;
    }

    try {
        $server = ORM::for_table('tbl_acs_servers')->find_one($id);

        if (!$server) {
            echo json_encode(['success' => false, 'message' => 'Server not found']);
            exit;
        }

        // Check if domain or IP
        $use_ssl = !filter_var($host, FILTER_VALIDATE_IP);

        $server->name = $name;
        $server->host = $host;
        $server->port = $port;
        $server->username = $username;
        $server->password = $password;
        $server->use_ssl = $use_ssl ? 1 : 0;
        $server->save();

        echo json_encode(['success' => true, 'message' => 'Server updated successfully']);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    }
    exit;
}

// DELETE SERVER
function genieacs_delete_server()
{
    header('Content-Type: application/json');

    $id = intval($_GET['id'] ?? 0);

    if ($id <= 0) {
        echo json_encode(['success' => false, 'message' => 'Invalid server ID']);
        exit;
    }

    try {
        $server = ORM::for_table('tbl_acs_servers')->find_one($id);

        if (!$server) {
            echo json_encode(['success' => false, 'message' => 'Server not found']);
            exit;
        }

        // Count devices that will be deleted
        $device_count = ORM::for_table('tbl_acs_devices')
            ->where('server_id', $id)
            ->count();

        // Delete all devices associated with this server
        ORM::for_table('tbl_acs_devices')
            ->where('server_id', $id)
            ->delete_many();

        // Delete all cache associated with this server
        ORM::for_table('tbl_acs_cache')
            ->where('server_id', $id)
            ->delete_many();

        // Delete all device mappings associated with this server
        ORM::for_table('tbl_device_mapping')
            ->where('server_id', $id)
            ->delete_many();

        // Delete the server
        $server_name = $server->name;
        $server->delete();

        echo json_encode([
            'success' => true, 
            'message' => "Server '{$server_name}' deleted successfully. {$device_count} devices removed.",
            'deleted_devices' => $device_count
        ]);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    }
    exit;
}
function genieacs_toggle_priority()
{
    header('Content-Type: application/json');

    if (!$_POST) {
        echo json_encode(['success' => false, 'message' => 'No data received']);
        exit;
    }

    $server_id = intval($_POST['server_id'] ?? 0);

    if ($server_id <= 0) {
        echo json_encode(['success' => false, 'message' => 'Invalid server ID']);
        exit;
    }

    try {
        $server = ORM::for_table('tbl_acs_servers')->find_one($server_id);

        if (!$server) {
            echo json_encode(['success' => false, 'message' => 'Server not found']);
            exit;
        }

        // Toggle priority status
        $server->is_priority = $server->is_priority ? 0 : 1;
        $server->save();

        echo json_encode([
            'success' => true,
            'is_priority' => $server->is_priority,
            'message' => $server->is_priority ? 'Server marked as priority' : 'Priority removed'
        ]);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    }
    exit;
}
// Batch test all connections
function genieacs_test_all_connections()
{
    header('Content-Type: application/json');

    $servers = ORM::for_table('tbl_acs_servers')
        ->where('status', 'active')
        ->find_many();

    $results = [];
    $online_count = 0;
    $offline_count = 0;

    foreach ($servers as $server) {
        $config = [
            'host' => $server->host,
            'port' => $server->port,
            'username' => $server->username,
            'password' => $server->password
        ];

        // Use optimized health check
        $is_online = genieacs_health_check($config, $server->id);

        $server->is_connected = $is_online ? 1 : 0;
        $server->last_check = date('Y-m-d H:i:s');
        $server->save();

        if ($is_online) {
            $online_count++;
        } else {
            $offline_count++;
        }

        $results[] = [
            'id' => $server->id,
            'name' => $server->name,
            'success' => $is_online,
            'message' => $is_online ? 'Online' : 'Offline'
        ];
    }

    echo json_encode([
        'success' => true,
        'results' => $results,
        'summary' => [
            'total' => count($servers),
            'online' => $online_count,
            'offline' => $offline_count
        ]
    ]);
    exit;
}

// Get server statistics
function genieacs_get_statistics()
{
    header('Content-Type: application/json');

    $servers = ORM::for_table('tbl_acs_servers')
        ->where('status', 'active')
        ->find_many();

    $total_devices = 0;
    $total_online = 0;
    $total_offline = 0;
    $avg_response_time = 0;
    $response_times = [];

    foreach ($servers as $server) {
        if ($server->is_connected) {
            $total_online++;

            // Quick device count
            $result = genieacs_api_call_with_timeout('devices', 'GET', null, $server->id, 2);
            if ($result['success'] && isset($result['data'])) {
                $device_count = is_array($result['data']) ? count($result['data']) : 0;
                $total_devices += $device_count;
            }
        } else {
            $total_offline++;
        }

        if ($server->last_response_time > 0) {
            $response_times[] = $server->last_response_time;
        }
    }

    if (count($response_times) > 0) {
        $avg_response_time = array_sum($response_times) / count($response_times);
    }

    echo json_encode([
        'success' => true,
        'stats' => [
            'total_servers' => count($servers),
            'online_servers' => $total_online,
            'offline_servers' => $total_offline,
            'total_devices' => $total_devices,
            'avg_response_time' => round($avg_response_time, 2)
        ]
    ]);
    exit;
}

// GET SERVER DATA FOR EDIT
function genieacs_get_server_ajax()
{
    header('Content-Type: application/json');

    $id = intval($_GET['id'] ?? 0);

    if ($id <= 0) {
        echo json_encode(['success' => false, 'message' => 'Invalid server ID']);
        exit;
    }

    try {
        $server = ORM::for_table('tbl_acs_servers')->find_one($id);

        if (!$server) {
            echo json_encode(['success' => false, 'message' => 'Server not found']);
            exit;
        }

        echo json_encode([
            'success' => true,
            'server' => [
                'id' => $server->id,
                'name' => $server->name,
                'host' => $server->host,
                'port' => $server->port,
                'username' => $server->username,
                'password' => $server->password
            ]
        ]);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    }
    exit;
}

function genieacs_test_connection_ajax()
{
    header('Content-Type: application/json');

    $id = intval($_GET['id'] ?? 0);
    $silent = isset($_GET['silent']) && $_GET['silent'] == 'true';

    if ($id <= 0) {
        echo json_encode(['success' => false, 'message' => 'Invalid server ID']);
        exit;
    }

    try {
        $server = ORM::for_table('tbl_acs_servers')->find_one($id);

        if (!$server) {
            echo json_encode(['success' => false, 'message' => 'Server not found']);
            exit;
        }

        // Test connection with shorter timeout for auto-check
        $config = [
            'host' => $server->host,
            'port' => $server->port,
            'username' => $server->username,
            'password' => $server->password
        ];

        // Use shorter timeout for silent/auto checks
        if ($silent) {
            $result = test_genieacs_api_connection_quick($config);
        } else {
            $result = test_genieacs_api_connection($config);
        }

        // Update connection status AND response time
        $server->is_connected = $result['success'] ? 1 : 0;
        $server->last_check = date('Y-m-d H:i:s');

        // Update response time if available
        if (isset($result['response_time']) && $result['response_time'] > 0) {
            $server->last_response_time = $result['response_time'];
        }

        $server->save();

        if ($result['success']) {
            echo json_encode([
                'success' => true,
                'message' => 'Connection successful!',
                'response_time' => $result['response_time'] ?? 0
            ]);
        } else {
            echo json_encode([
                'success' => false,
                'message' => 'Connection failed: ' . $result['error']
            ]);
        }
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }
    exit;
}

// Add quick test function with shorter timeout
function test_genieacs_api_connection_quick($config)
{
    $url = get_genieacs_api_url($config, 'devices?limit=1');

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_NOBODY, true); // HEAD request
    curl_setopt($ch, CURLOPT_TIMEOUT, 5);
    curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 3);
    curl_setopt($ch, CURLOPT_USERPWD, $config['username'] . ':' . $config['password']);

    // Optimize
    curl_setopt($ch, CURLOPT_DNS_CACHE_TIMEOUT, 3600);
    curl_setopt($ch, CURLOPT_IPRESOLVE, CURL_IPRESOLVE_V4);

    if (!is_ip_address($config['host'])) {
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
    }

    curl_exec($ch);
    $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $total_time = curl_getinfo($ch, CURLINFO_TOTAL_TIME); // Get response time
    $curl_error = curl_error($ch);
    curl_close($ch);

    if ($curl_error) {
        return [
            'success' => false,
            'error' => 'Connection error: ' . $curl_error,
            'response_time' => 0
        ];
    }

    if ($http_code === 200 || $http_code === 405 || $http_code === 204) {
        return [
            'success' => true,
            'device_count' => 0,
            'response_time' => round($total_time * 1000) // Convert to ms
        ];
    } elseif ($http_code === 401) {
        return [
            'success' => false,
            'error' => 'Authentication failed',
            'response_time' => round($total_time * 1000)
        ];
    } else {
        return [
            'success' => false,
            'error' => 'HTTP Error ' . $http_code,
            'response_time' => round($total_time * 1000)
        ];
    }
}
// Debug function to analyze response time
function debug_connection_time($config)
{
    $url = get_genieacs_api_url($config, 'devices?limit=1');

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_NOBODY, true);
    curl_setopt($ch, CURLOPT_TIMEOUT, 10);
    curl_setopt($ch, CURLOPT_USERPWD, $config['username'] . ':' . $config['password']);

    if (!is_ip_address($config['host'])) {
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
    }

    curl_exec($ch);

    // Get detailed timing
    $info = curl_getinfo($ch);
    curl_close($ch);

    return [
        'total_time' => round($info['total_time'] * 1000, 2),
        'namelookup_time' => round($info['namelookup_time'] * 1000, 2),
        'connect_time' => round($info['connect_time'] * 1000, 2),
        'pretransfer_time' => round($info['pretransfer_time'] * 1000, 2),
        'starttransfer_time' => round($info['starttransfer_time'] * 1000, 2),
        'redirect_time' => round($info['redirect_time'] * 1000, 2)
    ];
}

function genieacs_save_config()
{
    global $ui;

    if ($_POST) {
        $host = trim($_POST['host']);
        $port = intval($_POST['port']);
        $username = trim($_POST['username']);
        $password = trim($_POST['password']);

        // Validate inputs
        if (empty($host) || empty($username) || empty($password)) {
            r2(U . 'plugin/genieacs_manager', 'e', 'All fields are required!');
            return;
        }

        if ($port <= 0 || $port > 65535) {
            r2(U . 'plugin/genieacs_manager', 'e', 'Invalid port number!');
            return;
        }

        $config = [
            'host' => $host,
            'port' => $port,
            'username' => $username,
            'password' => $password,
            'updated_at' => date('Y-m-d H:i:s')
        ];

        if (save_genieacs_config($config)) {
            r2(U . 'plugin/genieacs_manager', 's', 'Configuration saved successfully!');
        } else {
            r2(U . 'plugin/genieacs_manager', 'e', 'Failed to save configuration!');
        }
    }
}

function genieacs_test_connection()
{
    global $ui;

    $config = load_genieacs_config();

    if (!$config || empty($config['host'])) {
        r2(U . 'plugin/genieacs_manager', 'e', 'Please configure GenieACS connection first!');
        return;
    }

    $result = test_genieacs_api_connection($config);

    if ($result['success']) {
        $message = 'Connection successful! Found ' . $result['device_count'] . ' devices.';
        r2(U . 'plugin/genieacs_manager', 's', $message);
    } else {
        r2(U . 'plugin/genieacs_manager', 'e', 'Connection failed: ' . $result['error']);
    }
}

// Config management functions
function load_genieacs_config($server_id = null)
{
    // If server_id provided, load specific server
    if ($server_id) {
        $server = ORM::for_table('tbl_acs_servers')->find_one($server_id);

        if ($server) {
            return [
                'host' => $server->host,
                'port' => $server->port,
                'username' => $server->username,
                'password' => $server->password,
                'use_ssl' => $server->use_ssl
            ];
        }
    }

    // Load first active server as default
    $server = ORM::for_table('tbl_acs_servers')
        ->where('status', 'active')
        ->order_by_asc('id')
        ->find_one();

    if ($server) {
        return [
            'host' => $server->host,
            'port' => $server->port,
            'username' => $server->username,
            'password' => $server->password,
            'use_ssl' => $server->use_ssl
        ];
    }

    // Return default if no server found
    return get_default_genieacs_config();
}

function save_genieacs_config($config)
{
    $config_file = 'system/plugin/data/genieacs_config.json';
    $dir = dirname($config_file);

    if (!file_exists($dir)) {
        mkdir($dir, 0755, true);
    }

    return file_put_contents($config_file, json_encode($config, JSON_PRETTY_PRINT));
}

function get_default_genieacs_config()
{
    return [
        'host' => '192.168.20.6',
        'port' => 7557,
        'username' => 'egik',
        'password' => 'egik',
        'updated_at' => null
    ];
}

// Helper function to check if host is IP address
function is_ip_address($host)
{
    return filter_var($host, FILTER_VALIDATE_IP) !== false;
}

// GenieACS API functions
function get_genieacs_api_url($config, $endpoint = '')
{
    $host = $config['host'];
    $port = $config['port'];

    // Tentukan protocol dan port berdasarkan jenis host
    if (is_ip_address($host)) {
        // Jika IP address (apapun), gunakan HTTP dengan port custom
        $protocol = 'http';
        $port_string = ':' . $port;
    } else {
        // Jika domain, gunakan HTTPS tanpa port (default 443)
        $protocol = 'https';
        $port_string = '';
    }

    $base_url = $protocol . '://' . $host . $port_string;

    // Langsung ke endpoint tanpa /api/
    return $base_url . '/' . ltrim($endpoint, '/');
}
// Global cURL handle keeper for connection reuse
global $curl_handles;
$curl_handles = [];

// Get or create persistent cURL handle
function get_persistent_curl_handle($server_id)
{
    global $curl_handles;

    if (!isset($curl_handles[$server_id])) {
        $curl_handles[$server_id] = curl_init();
    }

    return $curl_handles[$server_id];
}

// Optimized health check - just test if server responds
function genieacs_health_check($config, $server_id = null)
{
    // Try simpler endpoint first
    $url = get_genieacs_api_url($config, 'faults?limit=1');

    $ch = $server_id ? get_persistent_curl_handle($server_id) : curl_init();

    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_NOBODY, true); // HEAD only
    curl_setopt($ch, CURLOPT_TIMEOUT, 3);
    curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 2);
    curl_setopt($ch, CURLOPT_USERPWD, $config['username'] . ':' . $config['password']);

    // Speed optimizations
    curl_setopt($ch, CURLOPT_FRESH_CONNECT, false);
    curl_setopt($ch, CURLOPT_FORBID_REUSE, false);
    curl_setopt($ch, CURLOPT_DNS_CACHE_TIMEOUT, 3600);
    curl_setopt($ch, CURLOPT_IPRESOLVE, CURL_IPRESOLVE_V4);
    curl_setopt($ch, CURLOPT_TCP_NODELAY, 1); // Disable Nagle's algorithm

    if (!is_ip_address($config['host'])) {
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
        curl_setopt($ch, CURLOPT_SSL_SESSIONID_CACHE, true);
    }

    curl_exec($ch);
    $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);

    // Don't close if using persistent handle
    if (!$server_id) {
        curl_close($ch);
    }

    // Any 2xx or 405 (HEAD not allowed) is success
    return ($http_code >= 200 && $http_code < 300) || $http_code == 405;
}


function test_genieacs_api_connection($config)
{
    // Use limit=1 to avoid downloading all devices
    $url = get_genieacs_api_url($config, 'devices?limit=1');

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_TIMEOUT, 10);
    curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 5);
    curl_setopt($ch, CURLOPT_USERPWD, $config['username'] . ':' . $config['password']);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Content-Type: application/json',
        'Accept: application/json'
    ]);
    // Add header function to capture response headers
    curl_setopt($ch, CURLOPT_HEADER, true);

    // Jika menggunakan HTTPS (domain), set SSL options
    if (!is_ip_address($config['host'])) {
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
    }

    $response = curl_exec($ch);
    $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $header_size = curl_getinfo($ch, CURLINFO_HEADER_SIZE);
    $curl_error = curl_error($ch);
    curl_close($ch);

    if ($curl_error) {
        return [
            'success' => false,
            'error' => 'Connection error: ' . $curl_error
        ];
    }

    if ($http_code === 200) {
        // Parse headers to get total count
        $headers = substr($response, 0, $header_size);
        $body = substr($response, $header_size);

        // Try to get total count from headers
        $device_count = 0;
        if (preg_match('/X-Total-Count:\s*(\d+)/i', $headers, $matches)) {
            $device_count = intval($matches[1]);
        } else {
            // Fallback: parse body but it's only 1 device
            $devices = json_decode($body, true);
            $device_count = is_array($devices) ? 1 : 0; // We know it's limited to 1
        }

        return [
            'success' => true,
            'device_count' => $device_count,
            'response' => null // Don't return full device data
        ];
    } elseif ($http_code === 401) {
        return [
            'success' => false,
            'error' => 'Authentication failed. Check username/password.'
        ];
    } else {
        return [
            'success' => false,
            'error' => 'HTTP Error ' . $http_code
        ];
    }
}

function get_genieacs_version($config)
{
    $url = get_genieacs_api_url($config, 'config');

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_TIMEOUT, 5);
    curl_setopt($ch, CURLOPT_USERPWD, $config['username'] . ':' . $config['password']);
    curl_setopt($ch, CURLOPT_HTTPHEADER, ['Accept: application/json']);

    // Jika menggunakan HTTPS (domain), set SSL options
    if (!is_ip_address($config['host'])) {
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
    }

    $response = curl_exec($ch);
    $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    if ($http_code === 200) {
        // GenieACS version detection logic can be added here
        return 'Unknown';
    }

    return null;
}

// Utility function for API calls
function genieacs_api_call($endpoint, $method = 'GET', $data = null, $server_id = null)
{
    // Get server_id from session if not provided
    if (!$server_id) {
        $server_id = $_SESSION['selected_acs_server'] ?? null;
    }

    $config = load_genieacs_config($server_id);

    if (!$config || empty($config['host'])) {
        return ['success' => false, 'error' => 'GenieACS not configured'];
    }

    $url = get_genieacs_api_url($config, $endpoint);

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_TIMEOUT, 30);
    curl_setopt($ch, CURLOPT_USERPWD, $config['username'] . ':' . $config['password']);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Content-Type: application/json',
        'Accept: application/json'
    ]);

    // Jika menggunakan HTTPS (domain), set SSL options
    if (!is_ip_address($config['host'])) {
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
    }

    if ($method === 'POST') {
        curl_setopt($ch, CURLOPT_POST, true);
        if ($data) {
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
        }
    }

    $response = curl_exec($ch);
    $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $curl_error = curl_error($ch);
    curl_close($ch);

    if ($curl_error) {
        return ['success' => false, 'error' => $curl_error];
    }

    $decoded_response = json_decode($response, true);

    return [
        'success' => ($http_code >= 200 && $http_code < 300),
        'http_code' => $http_code,
        'data' => $decoded_response,
        'raw_response' => $response
    ];
}


// Additional helper functions for WiFi management
function genieacs_validate_ssid($ssid)
{
    if (empty($ssid)) {
        return false;
    }

    // SSID length should be between 1-32 characters
    if (strlen($ssid) > 32) {
        return false;
    }

    // Check for invalid characters (basic validation)
    if (preg_match('/[<>"\']/', $ssid)) {
        return false;
    }

    return true;
}

function genieacs_validate_wifi_password($password)
{
    if (empty($password)) {
        return false;
    }

    // Password should be at least 8 characters for WPA2
    if (strlen($password) < 8) {
        return false;
    }

    // Password should not exceed 63 characters
    if (strlen($password) > 63) {
        return false;
    }

    return true;
}

function genieacs_get_device_wifi_parameters($device_id)
{
    $encoded_device_id = urlencode($device_id);

    // Get specific WiFi parameters
    $projection = [
        'InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.SSID',
        'InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.SSID',
        'InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.PreSharedKey.1.KeyPassphrase',
        'InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.KeyPassphrase',
        'InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.TotalAssociations',
        'InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.TotalAssociations',
        'InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.Enable',
        'InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.Enable'
    ];

    $query_string = 'projection=' . urlencode(implode(',', $projection));

    return genieacs_api_call("devices/{$encoded_device_id}?{$query_string}", 'GET');
}

function genieacs_send_wifi_update_task($device_id, $ssid_2g, $ssid_5g, $password)
{
    $encoded_device_id = urlencode($device_id);

    // Create comprehensive task for WiFi update
    $task = [
        'name' => 'setParameterValues',
        'parameterValues' => [
            // Update SSIDs
            ['InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.SSID', $ssid_2g],
            ['InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.SSID', $ssid_5g],

            // Update passwords for both bands
            ['InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.PreSharedKey.1.KeyPassphrase', $password],
            ['InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.KeyPassphrase', $password],
            ['InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.PreSharedKey.1.KeyPassphrase', $password],
            ['InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.KeyPassphrase', $password]
        ]
    ];

    // Send the task
    $result = genieacs_api_call("devices/{$encoded_device_id}/tasks", 'POST', $task);

    if ($result['success']) {
        // Send connection request to apply changes immediately
        genieacs_api_call("devices/{$encoded_device_id}/tasks?connection_request", 'POST', []);
    }

    return $result;
}

function genieacs_log_wifi_change($device_id, $admin_username, $old_ssid, $new_ssid, $action_type = 'wifi_update')
{
    // Simple logging function - you can enhance this based on your logging system
    $log_entry = [
        'timestamp' => date('Y-m-d H:i:s'),
        'device_id' => $device_id,
        'admin' => $admin_username,
        'action' => $action_type,
        'old_ssid' => $old_ssid,
        'new_ssid' => $new_ssid
    ];

    $log_file = 'system/plugin/data/genieacs_wifi_changes.log';
    $log_dir = dirname($log_file);

    if (!file_exists($log_dir)) {
        mkdir($log_dir, 0755, true);
    }

    file_put_contents($log_file, json_encode($log_entry) . "\n", FILE_APPEND | LOCK_EX);
}

function genieacs_get_device_host_list($device_id)
{
    $encoded_device_id = urlencode($device_id);

    // Get all host information
    $projection = [
        'InternetGatewayDevice.LANDevice.1.Hosts.Host.*.HostName',
        'InternetGatewayDevice.LANDevice.1.Hosts.Host.*.IPAddress',
        'InternetGatewayDevice.LANDevice.1.Hosts.Host.*.MACAddress',
        'InternetGatewayDevice.LANDevice.1.Hosts.Host.*.InterfaceType',
        'InternetGatewayDevice.LANDevice.1.Hosts.Host.*.Active'
    ];

    $query_string = 'projection=' . urlencode(implode(',', $projection));

    return genieacs_api_call("devices/{$encoded_device_id}?{$query_string}", 'GET');
}

function genieacs_refresh_device_data($device_id)
{
    $encoded_device_id = urlencode($device_id);

    // Create refresh task for specific parameters
    $refresh_tasks = [
        [
            'name' => 'refreshObject',
            'objectName' => 'InternetGatewayDevice.LANDevice.1.WLANConfiguration'
        ],
        [
            'name' => 'refreshObject',
            'objectName' => 'InternetGatewayDevice.LANDevice.1.Hosts'
        ]
    ];

    $results = [];
    foreach ($refresh_tasks as $task) {
        $result = genieacs_api_call("devices/{$encoded_device_id}/tasks?connection_request", 'POST', $task);
        $results[] = $result;
    }

    return $results;
}

function genieacs_check_device_capabilities($device_data)
{
    $capabilities = [
        'has_wifi_2g' => false,
        'has_wifi_5g' => false,
        'supports_dual_band' => false,
        'wifi_management_supported' => false
    ];

    // Check if device has 2.4GHz WiFi
    if (isset($device_data['InternetGatewayDevice']['LANDevice']['1']['WLANConfiguration']['1'])) {
        $capabilities['has_wifi_2g'] = true;
        $capabilities['wifi_management_supported'] = true;
    }

    // Check if device has 5GHz WiFi
    if (isset($device_data['InternetGatewayDevice']['LANDevice']['1']['WLANConfiguration']['5'])) {
        $capabilities['has_wifi_5g'] = true;
    }

    // Check if device supports dual band
    if ($capabilities['has_wifi_2g'] && $capabilities['has_wifi_5g']) {
        $capabilities['supports_dual_band'] = true;
    }

    return $capabilities;
}
// Test connection without saving
function genieacs_test_connection_temp()
{
    header('Content-Type: application/json');

    if (!$_POST) {
        echo json_encode(['success' => false, 'message' => 'No data received']);
        exit;
    }

    $host = trim($_POST['host'] ?? '');
    $port = intval($_POST['port'] ?? 7557);
    $username = trim($_POST['username'] ?? '');
    $password = trim($_POST['password'] ?? '');

    // Validation
    if (empty($host) || empty($username) || empty($password)) {
        echo json_encode(['success' => false, 'message' => 'Host, username, and password are required']);
        exit;
    }

    // Create temporary config
    $config = [
        'host' => $host,
        'port' => $port,
        'username' => $username,
        'password' => $password
    ];

    // Test connection
    $result = test_genieacs_api_connection($config);

    if ($result['success']) {
        echo json_encode([
            'success' => true,
            'message' => 'Connection successful! Found ' . $result['device_count'] . ' devices'
        ]);
    } else {
        echo json_encode([
            'success' => false,
            'message' => $result['error']
        ]);
    }
    exit;
}

// ============================================
// DEVICE MAPPING MANAGEMENT FUNCTIONS - NEW
// ============================================

function genieacs_get_device_mappings()
{
    header('Content-Type: application/json');

    try {
        // Get pagination parameters
        $page = intval($_GET['page'] ?? 1);
        $per_page = 10; // Fixed 10 per page
        $search = trim($_GET['search'] ?? '');
        $server_filter = intval($_GET['server_filter'] ?? 0);
        
        if ($page < 1) $page = 1;
        $offset = ($page - 1) * $per_page;

        // Build query
        $query = ORM::for_table('tbl_device_mapping')
            ->select('tbl_device_mapping.*')
            ->select('tbl_acs_servers.name', 'server_name')
            ->left_outer_join('tbl_acs_servers', array('tbl_device_mapping.server_id', '=', 'tbl_acs_servers.id'));

        // Apply filters
        if (!empty($search)) {
            $query->where_like('username', '%' . $search . '%');
        }
        
        if ($server_filter > 0) {
            $query->where('tbl_device_mapping.server_id', $server_filter);
        }

        // Get total count for pagination
        $total_count = $query->count();
        
        // Get paginated results
        $mappings = $query->order_by_desc('tbl_device_mapping.last_updated')
            ->limit($per_page)
            ->offset($offset)
            ->find_many();

        $result = [];
        foreach ($mappings as $mapping) {
            $vendor = get_vendor_from_device_id($mapping->device_id);
            $result[] = [
                'id' => $mapping->id,
                'username' => $mapping->username,
                'device_id' => $mapping->device_id,
                'vendor' => $vendor,
                'server_id' => $mapping->server_id,
                'server_name' => $mapping->server_name ?: 'Server ' . $mapping->server_id,
                'last_updated' => $mapping->last_updated
            ];
        }

        // Get server list for filter
        $servers = ORM::for_table('tbl_acs_servers')
            ->select('id')
            ->select('name')
            ->where('status', 'active')
            ->find_many();

        $server_list = [];
        foreach ($servers as $server) {
            $server_list[] = [
                'id' => $server->id,
                'name' => $server->name
            ];
        }

        echo json_encode([
            'success' => true,
            'mappings' => $result,
            'pagination' => [
                'current_page' => $page,
                'total_pages' => ceil($total_count / $per_page),
                'total_count' => $total_count,
                'per_page' => $per_page
            ],
            'servers' => $server_list
        ]);
    } catch (Exception $e) {
        echo json_encode([
            'success' => false,
            'error' => 'Database error: ' . $e->getMessage()
        ]);
    }
    exit;
}

function genieacs_delete_device_mapping()
{
    header('Content-Type: application/json');

    if (!$_POST) {
        echo json_encode(['success' => false, 'error' => 'No data received']);
        exit;
    }

    $id = intval($_POST['id'] ?? 0);

    if ($id <= 0) {
        echo json_encode(['success' => false, 'error' => 'Invalid mapping ID']);
        exit;
    }

    try {
        $mapping = ORM::for_table('tbl_device_mapping')->find_one($id);

        if (!$mapping) {
            echo json_encode(['success' => false, 'error' => 'Mapping not found']);
            exit;
        }

        $username = $mapping->username;
        $mapping->delete();

        echo json_encode([
            'success' => true,
            'message' => 'Device mapping for "' . $username . '" deleted successfully'
        ]);
    } catch (Exception $e) {
        echo json_encode([
            'success' => false,
            'error' => 'Database error: ' . $e->getMessage()
        ]);
    }
    exit;
}

function genieacs_clear_all_mappings()
{
    header('Content-Type: application/json');

    try {
        $count = ORM::for_table('tbl_device_mapping')->count();
        
        ORM::for_table('tbl_device_mapping')->delete_many();

        echo json_encode([
            'success' => true,
            'message' => 'All ' . $count . ' device mappings cleared successfully'
        ]);
    } catch (Exception $e) {
        echo json_encode([
            'success' => false,
            'error' => 'Database error: ' . $e->getMessage()
        ]);
    }
    exit;
}

// ============================================
// VENDOR DETECTION FUNCTIONS - NEW
// ============================================

function get_vendor_from_device_id($device_id)
{
    // Extract OUI (first 6 characters)
    $oui = strtoupper(substr(str_replace([':', '-', '%2D'], '', $device_id), 0, 6));
    
    // Common OUI to vendor mapping
    $vendors = [
        '000755' => 'ZTE Corporation',
        '00259E' => 'Huawei Technologies', 
        'F4F26D' => 'Zyxel Communications',
        '001E46' => 'Fiberhome Telecommunication',
        'D4EE07' => 'Ubiquiti Networks',
        '44D9E7' => 'Shenzhen Four Seas Global Link',
        'E8DE27' => 'Tp-Link Technologies',
        '6CAB31' => 'Sagemcom Broadband SAS',
        '00907F' => 'Intracom Telecom',
        '2CAB25' => 'Netgear',
        '00A0C5' => 'Zyxel Communications',
        '001346' => 'Zte Corporation',
        '70B3D5' => 'Unifi',
        'C83A35' => 'Tenda Technology',
        '001D0F' => 'Dasan Zhone Solutions'
    ];
    
    return isset($vendors[$oui]) ? $vendors[$oui] : null;
}

// ============================================
// UNINSTALL FUNCTION
// ============================================

/**
 * Recursively delete directory for uninstall
 */
function genieacs_uninstall_delete_directory($dir)
{
    if (!is_dir($dir)) return true;
    
    $files = array_diff(scandir($dir), ['.', '..']);
    foreach ($files as $file) {
        $path = $dir . '/' . $file;
        is_dir($path) ? genieacs_uninstall_delete_directory($path) : unlink($path);
    }
    return rmdir($dir);
}

/**
 * Run complete uninstallation
 */
function genieacs_run_uninstall()
{
    global $admin;
    
    // Only SuperAdmin can uninstall
    if ($admin['user_type'] !== 'SuperAdmin') {
        header('Content-Type: application/json');
        echo json_encode(['success' => false, 'message' => 'Only SuperAdmin can uninstall this plugin']);
        exit;
    }
    
    header('Content-Type: application/json');
    
    $result = [
        'success' => false,
        'message' => '',
        'details' => []
    ];
    
    try {
        $plugin_dir = __DIR__;
        $system_dir = realpath($plugin_dir . '/../');
        $root_dir = realpath($plugin_dir . '/../../');
        $ui_dir = $root_dir . '/ui';
        
        // ========== STEP 1: Drop all tables ==========
        $tables = [
            'tbl_acs_servers',
            'tbl_acs_devices', 
            'tbl_acs_cache',
            'tbl_acs_parameters',
            'tbl_acs_password_history',
            'tbl_acs_webadmin_history',
            'tbl_device_mapping'
        ];
        
        foreach ($tables as $table) {
            try {
                ORM::raw_execute("DROP TABLE IF EXISTS `{$table}`");
                $result['details'][] = "✓ Dropped table: {$table}";
            } catch (Exception $e) {
                $result['details'][] = "⚠ Failed to drop table: {$table}";
            }
        }
        
        // ========== STEP 2: Delete config from tbl_appconfig ==========
        try {
            ORM::for_table('tbl_appconfig')->where('setting', 'genieacs_version')->delete_many();
            ORM::for_table('tbl_appconfig')->where('setting', 'genieacs_installed_at')->delete_many();
            $result['details'][] = "✓ Removed plugin configuration";
        } catch (Exception $e) {
            $result['details'][] = "⚠ Failed to remove config";
        }
        
        // ========== STEP 3: Delete .env file ==========
        $env_file = $root_dir . '/.env';
        if (file_exists($env_file)) {
            if (unlink($env_file)) {
                $result['details'][] = "✓ Removed environment file (.env)";
            }
        }
        
        // ========== STEP 4: Delete cron file ==========
        $cron_file = $system_dir . '/cron_acs_sync.php';
        if (file_exists($cron_file)) {
            if (unlink($cron_file)) {
                $result['details'][] = "✓ Removed cron file (system/cron_acs_sync.php)";
            }
        }
        
        // ========== STEP 5: Delete UI Custom folders ==========
        $ui_custom_paths = [
            $ui_dir . '/ui_custom/admin/customers',
            $ui_dir . '/ui_custom/customer'
        ];
        
        foreach ($ui_custom_paths as $path) {
            if (is_dir($path)) {
                if (genieacs_uninstall_delete_directory($path)) {
                    $result['details'][] = "✓ Removed: " . basename(dirname($path)) . '/' . basename($path);
                }
            }
        }
        
        // ========== STEP 6: Delete TPL files ==========
        $tpl_files = [
            'genieacs_manager.tpl',
            'genieacs_devices.tpl',
            'genieacs_device_detail.tpl',
            'genieacs_parameters.tpl'
        ];
        
        foreach ($tpl_files as $tpl) {
            $tpl_path = $plugin_dir . '/ui/' . $tpl;
            if (file_exists($tpl_path)) {
                unlink($tpl_path);
            }
        }
        $result['details'][] = "✓ Removed template files";
        
        // ========== STEP 7: Delete PHP files (except this one - delete last) ==========
        $php_files = [
            'genieacs_devices.php',
            'genieacs_device_detail.php',
            'genieacs_parameters.php',
            'ui_router_menu.php'
        ];
        
        foreach ($php_files as $php) {
            $php_path = $plugin_dir . '/' . $php;
            if (file_exists($php_path)) {
                unlink($php_path);
            }
        }
        $result['details'][] = "✓ Removed plugin PHP files";
        
        // ========== STEP 8: Delete ui folder if empty ==========
        $ui_plugin_dir = $plugin_dir . '/ui';
        if (is_dir($ui_plugin_dir)) {
            $remaining = array_diff(scandir($ui_plugin_dir), ['.', '..']);
            if (empty($remaining)) {
                rmdir($ui_plugin_dir);
            }
        }
        
        $result['success'] = true;
        $result['message'] = 'GenieACS Manager has been uninstalled successfully!';
        $result['details'][] = "✓ Uninstallation completed";
        $result['redirect'] = true;
        
        // ========== FINAL: Delete this file (self-destruct) ==========
        $self_file = $plugin_dir . '/genieacs_manager.php';
        
        // Send response first
        echo json_encode($result);
        
        // Flush output
        if (ob_get_level() > 0) {
            ob_end_flush();
        }
        flush();
        
        // Now delete self
        if (file_exists($self_file)) {
            @unlink($self_file);
        }
        
        exit;
        
    } catch (Exception $e) {
        $result['success'] = false;
        $result['message'] = 'Uninstall error: ' . $e->getMessage();
        echo json_encode($result);
        exit;
    }
}
// ============================================
// UPDATE FUNCTIONS
// ============================================

/**
 * Get GitHub token from database
 */
function genieacs_get_github_token()
{
    $config = ORM::for_table('tbl_appconfig')->where('setting', 'github_token')->find_one();
    return $config ? $config->value : null;
}

/**
 * Check for updates from GitHub (Private Repo)
 */
function genieacs_check_update()
{
    header('Content-Type: application/json');
    
    $result = [
        'success' => false,
        'has_update' => false,
        'current_version' => '',
        'latest_version' => '',
        'changelog' => [],
        'message' => ''
    ];
    
    try {
        // Get GitHub token
        $github_token = genieacs_get_github_token();
        if (empty($github_token)) {
            // Return graceful response instead of throwing exception
            $result['success'] = false;
            $result['message'] = 'GitHub token not configured. Update checking is disabled. This is optional - configure GitHub authentication in Settings > General Settings if you need automatic updates.';
            $result['token_required'] = true; // Flag to indicate this is a token issue
            echo json_encode($result);
            exit;
        }
        
        // Get current version from database
        $config = ORM::for_table('tbl_appconfig')->where('setting', 'genieacs_version')->find_one();
        $current_version = $config ? $config->value : '1.0.0';
        $result['current_version'] = $current_version;
        
        // Fetch version.json from GitHub API (Private Repo)
        $api_url = 'https://api.github.com/repos/ExodiaForb-Plugin/GenieACS-Manager/contents/version.json?ref=main';
        
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $api_url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_TIMEOUT, 30);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'Authorization: token ' . $github_token,
            'Accept: application/vnd.github.v3+json',
            'User-Agent: PHPNuxBill-GenieACS-Manager'
        ]);
        
        $response = curl_exec($ch);
        $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
        
        if ($http_code === 401) {
            throw new Exception('GitHub authentication failed. Please check your token.');
        }
        
        if ($http_code === 404) {
            throw new Exception('version.json not found in repository.');
        }
        
        if ($http_code !== 200 || empty($response)) {
            throw new Exception('Failed to fetch version info (HTTP ' . $http_code . ')');
        }
        
        $api_data = json_decode($response, true);
        if (!$api_data || !isset($api_data['content'])) {
            throw new Exception('Invalid response from GitHub API');
        }
        
        // Decode base64 content
        $version_content = base64_decode($api_data['content']);
        $version_data = json_decode($version_content, true);
        
        if (!$version_data || !isset($version_data['version'])) {
            throw new Exception('Invalid version.json format');
        }
        
        $latest_version = $version_data['version'];
        $result['latest_version'] = $latest_version;
        $result['changelog'] = $version_data['changelog'] ?? [];
        $result['release_date'] = $version_data['release_date'] ?? '';
        
        // Compare versions
        if (version_compare($latest_version, $current_version, '>')) {
            $result['has_update'] = true;
            $result['message'] = "Update available: v{$latest_version}";
        } else {
            $result['has_update'] = false;
            $result['message'] = "You are using the latest version";
        }
        
        $result['success'] = true;
        
    } catch (Exception $e) {
        $result['success'] = false;
        $result['message'] = $e->getMessage();
    }
    
    echo json_encode($result);
    exit;
}

/**
 * Run the update process (Private Repo)
 */
function genieacs_run_update()
{
    global $admin;
    
    // Only SuperAdmin can update
    if ($admin['user_type'] !== 'SuperAdmin') {
        header('Content-Type: application/json');
        echo json_encode(['success' => false, 'message' => 'Only SuperAdmin can update this plugin']);
        exit;
    }
    
    header('Content-Type: application/json');
    
    $result = [
        'success' => false,
        'message' => '',
        'details' => []
    ];
    
    try {
        // Get GitHub token
        $github_token = genieacs_get_github_token();
        if (empty($github_token)) {
            $result['success'] = false;
            $result['message'] = 'GitHub token not configured. To enable automatic updates, configure GitHub authentication in Settings > General Settings > Authentication section.';
            echo json_encode($result);
            exit;
        }
        
        $plugin_dir = __DIR__;
        $system_dir = realpath($plugin_dir . '/../');
        $root_dir = realpath($plugin_dir . '/../../');
        $ui_dir = $root_dir . '/ui';
        $temp_dir = $plugin_dir . '/_update_temp';
        
        // ========== STEP 1: Fetch version info ==========
        $api_url = 'https://api.github.com/repos/ExodiaForb-Plugin/GenieACS-Manager/contents/version.json?ref=main';
        
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $api_url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_TIMEOUT, 30);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'Authorization: token ' . $github_token,
            'Accept: application/vnd.github.v3+json',
            'User-Agent: PHPNuxBill-GenieACS-Manager'
        ]);
        
        $response = curl_exec($ch);
        curl_close($ch);
        
        $api_data = json_decode($response, true);
        $version_content = base64_decode($api_data['content']);
        $version_data = json_decode($version_content, true);
        
        $new_version = $version_data['version'];
        $result['details'][] = "✓ Fetched update info (v{$new_version})";
        
        // ========== STEP 2: Download ZIP from Private Repo ==========
        $zip_file = $plugin_dir . '/_update.zip';
        $download_url = 'https://api.github.com/repos/ExodiaForb-Plugin/GenieACS-Manager/zipball/main';
        
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $download_url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
        curl_setopt($ch, CURLOPT_TIMEOUT, 120);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'Authorization: token ' . $github_token,
            'Accept: application/vnd.github.v3+json',
            'User-Agent: PHPNuxBill-GenieACS-Manager'
        ]);
        
        $zip_content = curl_exec($ch);
        $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
        
        if ($http_code !== 200 || empty($zip_content)) {
            throw new Exception('Failed to download update package (HTTP ' . $http_code . ')');
        }
        
        file_put_contents($zip_file, $zip_content);
        $result['details'][] = "✓ Downloaded update package";
        
        // ========== STEP 3: Extract ZIP ==========
        $zip = new ZipArchive();
        if ($zip->open($zip_file) !== true) {
            throw new Exception('Failed to open update package');
        }
        
        // Create temp directory
        if (!is_dir($temp_dir)) {
            mkdir($temp_dir, 0755, true);
        }
        
        $zip->extractTo($temp_dir);
        $zip->close();
        
        // Find extracted folder (GitHub format: OrgName-RepoName-CommitHash)
        $extracted_folders = glob($temp_dir . '/*', GLOB_ONLYDIR);
        if (empty($extracted_folders)) {
            throw new Exception('Invalid update package structure');
        }
        $extracted_dir = $extracted_folders[0];
        
        $result['details'][] = "✓ Extracted update package";
        
        // ========== STEP 4: Update PHP files ==========
        $php_source = $extracted_dir . '/_genieacs_php';
        if (is_dir($php_source)) {
            $php_files = glob($php_source . '/*.php');
            foreach ($php_files as $file) {
                $filename = basename($file);
                $dest = $plugin_dir . '/' . $filename;
                copy($file, $dest);
            }
            $result['details'][] = "✓ Updated PHP modules (" . count($php_files) . " files)";
        }
        
        // ========== STEP 5: Update TPL files ==========
        $tpl_source = $extracted_dir . '/_genieacs_ui';
        if (is_dir($tpl_source)) {
            $tpl_files = glob($tpl_source . '/*.tpl');
            $ui_dest = $plugin_dir . '/ui';
            foreach ($tpl_files as $file) {
                $filename = basename($file);
                $dest = $ui_dest . '/' . $filename;
                copy($file, $dest);
            }
            $result['details'][] = "✓ Updated UI templates (" . count($tpl_files) . " files)";
        }
        
        // ========== STEP 6: Update Cron file ==========
        $cron_source = $extracted_dir . '/_genieacs_cron/cron_acs_sync.php';
        if (file_exists($cron_source)) {
            $cron_dest = $system_dir . '/cron_acs_sync.php';
            copy($cron_source, $cron_dest);
            $result['details'][] = "✓ Updated cron sync file";
        }
        
        // ========== STEP 7: Update UI Custom ==========
        $ui_custom_source = $extracted_dir . '/_genieacs_ui_custom';
        $ui_custom_dest = $ui_dir . '/ui_custom';
        if (is_dir($ui_custom_source)) {
            genieacs_update_copy_directory($ui_custom_source, $ui_custom_dest);
            $result['details'][] = "✓ Updated custom UI components";
        }
        
        // ========== STEP 8: Update version in database ==========
        $config = ORM::for_table('tbl_appconfig')->where('setting', 'genieacs_version')->find_one();
        if (!$config) {
            $config = ORM::for_table('tbl_appconfig')->create();
            $config->setting = 'genieacs_version';
        }
        $config->value = $new_version;
        $config->save();
        
        $config_date = ORM::for_table('tbl_appconfig')->where('setting', 'genieacs_updated_at')->find_one();
        if (!$config_date) {
            $config_date = ORM::for_table('tbl_appconfig')->create();
            $config_date->setting = 'genieacs_updated_at';
        }
        $config_date->value = date('Y-m-d H:i:s');
        $config_date->save();
        
        $result['details'][] = "✓ Updated version to v{$new_version}";
        
        // ========== STEP 9: Cleanup ==========
        @unlink($zip_file);
        genieacs_update_delete_directory($temp_dir);
        
        $result['details'][] = "✓ Cleaned up temporary files";
        
        $result['success'] = true;
        $result['message'] = "Successfully updated to v{$new_version}";
        $result['new_version'] = $new_version;
        
    } catch (Exception $e) {
        // Cleanup on error
        if (isset($zip_file) && file_exists($zip_file)) {
            @unlink($zip_file);
        }
        if (isset($temp_dir) && is_dir($temp_dir)) {
            genieacs_update_delete_directory($temp_dir);
        }
        
        $result['success'] = false;
        $result['message'] = 'Update failed: ' . $e->getMessage();
    }
    
    echo json_encode($result);
    exit;
}

/**
 * Recursively copy directory for update
 */
function genieacs_update_copy_directory($source, $dest)
{
    if (!is_dir($dest)) {
        mkdir($dest, 0755, true);
    }
    
    $dir = opendir($source);
    while (($file = readdir($dir)) !== false) {
        if ($file == '.' || $file == '..') continue;
        
        $src_path = $source . '/' . $file;
        $dst_path = $dest . '/' . $file;
        
        if (is_dir($src_path)) {
            genieacs_update_copy_directory($src_path, $dst_path);
        } else {
            copy($src_path, $dst_path);
        }
    }
    closedir($dir);
}

/**
 * Recursively delete directory for update cleanup
 */
function genieacs_update_delete_directory($dir)
{
    if (!is_dir($dir)) return true;
    
    $files = array_diff(scandir($dir), ['.', '..']);
    foreach ($files as $file) {
        $path = $dir . '/' . $file;
        is_dir($path) ? genieacs_update_delete_directory($path) : unlink($path);
    }
    return rmdir($dir);
}
