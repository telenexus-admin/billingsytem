<?php

_admin();
$ui->assign('_title', Lang::T('Dashboard'));
$ui->assign('_admin', $admin);

// ===== AJAX ENDPOINT FOR FILTERED DATA =====
// This must be placed BEFORE any HTML output
if (isset($_GET['_route']) && $_GET['_route'] == 'dashboard' && isset($_GET['router_id'])) {
    header('Content-Type: application/json');

    // Ensure widget class is loaded
    require_once $WIDGET_PATH . DIRECTORY_SEPARATOR . "top_widget.php";

    $router_id = $_GET['router_id'];
    $data = top_widget::ajaxGetFilteredData($router_id);

    echo json_encode($data);
    exit;
}
// ===== END AJAX ENDPOINT =====

// ===== LIVE PPPOE SYNC ENDPOINT =====
// Called periodically from dashboard JS to sync PPPoE status directly from router
if (isset($_GET['_route']) && $_GET['_route'] == 'dashboard' && ($_GET['action'] ?? '') === 'pppoe_sync') {
    header('Content-Type: application/json');
    $result = ['synced' => 0, 'routers' => [], 'error' => null];
    try {
        $routers = ORM::for_table('tbl_routers')->where('enabled', 1)->find_array();
        $now = date('Y-m-d H:i:s');

        foreach ($routers as $router) {
            try {
                $client = Mikrotik::getClient($router['ip_address'], $router['username'], $router['password']);
                $pppActive = $client->sendSync(new PEAR2\Net\RouterOS\Request('/ppp/active/print'));

                $activeNames = [];
                foreach ($pppActive as $entry) {
                    $username = $entry->getProperty('name');
                    $address  = $entry->getProperty('address') ?? '';
                    $sid      = $entry->getProperty('.id') ?? '';
                    if (!$username) continue;

                    $activeNames[] = $username;

                    // Upsert last_seen so the 2-min threshold sees this user as online
                    $exists = ORM::for_table('tbl_usage_sessions')
                        ->where('username', $username)
                        ->where('interface', 'pppoe')
                        ->where('router_id', $router['id'])
                        ->find_one();

                    if ($exists) {
                        $exists->last_seen  = $now;
                        $exists->ip_address = $address;
                        $exists->save();
                    } else {
                        $sess = ORM::for_table('tbl_usage_sessions')->create();
                        $sess->username   = $username;
                        $sess->interface  = 'pppoe';
                        $sess->router_id  = $router['id'];
                        $sess->session_id = $sid;
                        $sess->ip_address = $address;
                        $sess->last_seen  = $now;
                        $sess->save();
                    }
                    $result['synced']++;
                }

                // Mark gone users as stale by setting last_seen to >2 minutes ago
                if (!empty($activeNames)) {
                    $placeholders = implode(',', array_fill(0, count($activeNames), '?'));
                    ORM::raw_execute(
                        "UPDATE tbl_usage_sessions
                         SET last_seen = DATE_SUB(NOW(), INTERVAL 5 MINUTE)
                         WHERE interface = 'pppoe'
                           AND router_id = ?
                           AND username NOT IN ($placeholders)",
                        array_merge([$router['id']], $activeNames)
                    );
                } else {
                    // No PPPoE users online — expire all for this router
                    ORM::raw_execute(
                        "UPDATE tbl_usage_sessions
                         SET last_seen = DATE_SUB(NOW(), INTERVAL 5 MINUTE)
                         WHERE interface = 'pppoe' AND router_id = ?",
                        [$router['id']]
                    );
                }

                $result['routers'][] = ['id' => $router['id'], 'name' => $router['name'], 'ok' => true];
            } catch (Exception $e) {
                $result['routers'][] = ['id' => $router['id'], 'name' => $router['name'], 'ok' => false, 'error' => $e->getMessage()];
            }
        }
    } catch (Exception $e) {
        $result['error'] = $e->getMessage();
    }
    echo json_encode($result);
    exit;
}
// ===== END LIVE PPPOE SYNC ENDPOINT =====

if (isset($_GET['refresh'])) {
    r2(getUrl('dashboard'), 's', 'Dashboard Refreshed');
}

$tipeUser = _req("user");
if (empty($tipeUser)) {
    $tipeUser = 'Admin';
}
$ui->assign('tipeUser', $tipeUser);

$reset_day = $config['reset_day'];
if (empty($reset_day)) {
    $reset_day = 1;
}
//first day of month
if (date("d") >= $reset_day) {
    $start_date = date('Y-m-' . $reset_day);
} else {
    $start_date = date('Y-m-' . $reset_day, strtotime("-1 MONTH"));
}

$current_date = date('Y-m-d');
$ui->assign('start_date', $start_date);
$ui->assign('current_date', $current_date);

$tipeUser = $admin['user_type'];
if (in_array($tipeUser, ['SuperAdmin', 'Admin'])) {
    $tipeUser = 'Admin';
}

$widgets = ORM::for_table('tbl_widgets')->where("enabled", 1)->where('user', $tipeUser)->order_by_asc("orders")->findArray();
$count = count($widgets);
for ($i = 0; $i < $count; $i++) {
    try{
        if(file_exists($WIDGET_PATH . DIRECTORY_SEPARATOR . $widgets[$i]['widget'].".php")){
            require_once $WIDGET_PATH . DIRECTORY_SEPARATOR . $widgets[$i]['widget'].".php";
            $widgets[$i]['content'] = (new $widgets[$i]['widget'])->getWidget($widgets[$i]);
        }else{
            $widgets[$i]['content'] = "Widget not found";
        }
    } catch (Throwable $e) {
        $widgets[$i]['content'] = $e->getMessage();
    }
}

$ui->assign('widgets', $widgets);
run_hook('view_dashboard'); #HOOK
$ui->display('admin/dashboard.tpl');
