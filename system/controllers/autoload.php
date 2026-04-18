<?php

 

/**
 * used for ajax
 **/

_admin();
$ui->assign('_title', Lang::T('Network'));
$ui->assign('_system_menu', 'network');

$action = $routes['1'];
$ui->assign('_admin', $admin);

switch ($action) {
    case 'pool':
        $routers = _get('routers');
        if (empty($routers)) {
            $d = ORM::for_table('tbl_pool')->find_many();
        } else {
            $d = ORM::for_table('tbl_pool')->where('routers', $routers)->find_many();
        }
        $ui->assign('routers', $routers);
        $ui->assign('d', $d);
        $ui->display('admin/autoload/pool.tpl');
        break;
    case 'bw_name':
        $bw = ORM::for_table('tbl_bandwidth')->select("name_bw")->find_one($routes['2']);
        echo $bw['name_bw'];
        die();
    case 'balance':
        $balance = ORM::for_table('tbl_customers')->select("balance")->find_one($routes['2'])['balance'];
        if ($routes['3'] == '1') {
            echo Lang::moneyFormat($balance);
        } else {
            echo $balance;
        }
        die();
    case 'server':
        $d = ORM::for_table('tbl_routers')->where('enabled', '1')->find_many();
        $ui->assign('d', $d);

        $ui->display('admin/autoload/server.tpl');
        break;
    case 'pppoe_ip_used':
        if (!empty(_get('ip'))) {
            $cs = ORM::for_table('tbl_customers')
                ->select("username")
                ->where_not_equal('id', _get('id'))
                ->where("pppoe_ip", _get('ip'))
                ->findArray();
            if (count($cs) > 0) {
                $c = array_column($cs, 'username');
                die(Lang::T("IP has been used by") . ' : ' . implode(", ", $c));
            }
        }
        die();
    case 'pppoe_username_used':
        if (!empty(_get('u'))) {
            $cs = ORM::for_table('tbl_customers')
                ->select("username")
                ->where_not_equal('id', _get('id'))
                ->where("pppoe_username", _get('u'))
                ->findArray();
            if (count($cs) > 0) {
                $c = array_column($cs, 'username');
                die(Lang::T("Username has been used by") . ' : ' . implode(", ", $c));
            }
        }
        die();
    case 'plan':
        $server = _post('server');
        $jenis = _post('jenis');
        if (in_array($admin['user_type'], array('SuperAdmin', 'Admin'))) {
            switch ($server) {
                case 'radius':
                    $d = ORM::for_table('tbl_plans')->where('is_radius', 1)->where('type', $jenis)->find_many();
                    break;
                case '':
                    break;
                default:
                    $d = ORM::for_table('tbl_plans')->where('routers', $server)->where('type', $jenis)->find_many();
                    break;
            }
        } else {
            switch ($server) {
                case 'radius':
                    $d = ORM::for_table('tbl_plans')->where('is_radius', 1)->where('type', $jenis)->find_many();
                    break;
                case '':
                    break;
                default:
                    $d = ORM::for_table('tbl_plans')->where('routers', $server)->where('type', $jenis)->find_many();
                    break;
            }
        }
        $ui->assign('d', $d);

        $ui->display('admin/autoload/plan.tpl');
        break;
    case 'customer_is_active':
        if ($config['check_customer_online'] == 'yes') {
            $c = ORM::for_table('tbl_customers')->where('username', $routes['2'])->find_one();
            $p = ORM::for_table('tbl_plans')->find_one($routes['3']);
            if (!$c || !$p) {
                echo '<span class="label label-default">' . Lang::T('N/A') . '</span>';
                break;
            }
            $dvc = Package::getDevice($p);
            if ($_app_stage != 'Demo') {
                if (file_exists($dvc)) {
                    require_once $dvc;
                    try {
                        ini_set('default_socket_timeout', 5);
                        if ((new $p['device'])->online_customer($c, $p['routers'])) {
                            echo '<span class="label label-success">' . Lang::T('Online') . '</span>';
                        } else {
                            echo '<span class="label label-warning">' . Lang::T('Offline') . '</span>';
                        }
                    } catch (Exception $e) {
                        $em = htmlspecialchars($e->getMessage(), ENT_QUOTES, 'UTF-8');
                        echo '<span class="label label-danger" title="' . $em . '">' . Lang::T('Error') . '</span>';
                    }
                } else {
                    echo '<span class="label label-default">' . Lang::T('N/A') . '</span>';
                }
            } else {
                echo '<span class="label label-default">Demo</span>';
            }
        } else {
            echo '<span class="label label-default" title="' . htmlspecialchars(Lang::T('Enable in Settings'), ENT_QUOTES, 'UTF-8') . '">—</span>';
        }
        break;
    case 'plan_is_active':
        $ds = ORM::for_table('tbl_user_recharges')->where('customer_id', $routes['2'])->find_array();
        if ($ds) {
            $ps = [];
            foreach ($ds as $d) {
                if ($d['status'] == 'on') {
                    $ps[] = ('<span class="label label-primary m-1" style="display:inline-block;margin:2px 0;" title="Expires ' . Lang::dateAndTimeFormat($d['expiration'], $d['time']) . '">' . htmlspecialchars($d['namebp'], ENT_QUOTES, 'UTF-8') . '</span>');
                } else {
                    $ps[] = ('<span class="label label-danger m-1" title="Expired ' . Lang::dateAndTimeFormat($d['expiration'], $d['time']) . '">' . htmlspecialchars($d['namebp'], ENT_QUOTES, 'UTF-8') . '</span>');
                }
            }
            echo implode("<br>", $ps);
        } else {
            die('');
        }
        break;
    case 'customer_list_connection':
        $cid = isset($routes['2']) ? (int) $routes['2'] : 0;
        if ($cid < 1) {
            echo '';
            break;
        }
        $c = ORM::for_table('tbl_customers')->find_one($cid);
        if (!$c) {
            echo '';
            break;
        }
        if ($c['status'] !== 'Active') {
            echo '<span class="label label-default">' . htmlspecialchars(Lang::T($c['status']), ENT_QUOTES, 'UTF-8') . '</span>';
            break;
        }
        $activePackages = ORM::for_table('tbl_user_recharges')
            ->where('customer_id', $cid)
            ->where('status', 'on')
            ->count();
        if ($activePackages < 1) {
            echo '<span class="label label-default" title="' . htmlspecialchars(Lang::T('No active package'), ENT_QUOTES, 'UTF-8') . '">' . Lang::T('Offline') . '</span>';
            break;
        }
        if ($config['check_customer_online'] !== 'yes') {
            echo '<span class="label label-default" title="' . htmlspecialchars(Lang::T('Live session check is disabled in settings'), ENT_QUOTES, 'UTF-8') . '">—</span>';
            break;
        }
        try {
            $online_session = ORM::for_table('tbl_usage_sessions')
                ->where('username', $c['username'])
                ->where_gte('last_seen', date('Y-m-d H:i:s', strtotime('-1 minute')))
                ->find_one();
        } catch (Exception $e) {
            echo '<span class="label label-default">' . Lang::T('N/A') . '</span>';
            break;
        }
        if ($online_session) {
            $ts = htmlspecialchars($online_session['last_seen'], ENT_QUOTES, 'UTF-8');
            echo '<span class="label label-success" title="' . htmlspecialchars(Lang::T('Last seen'), ENT_QUOTES, 'UTF-8') . ': ' . $ts . '">' . Lang::T('Online') . '</span>';
        } else {
            echo '<span class="label label-warning" title="' . htmlspecialchars(Lang::T('No session activity in the last minute'), ENT_QUOTES, 'UTF-8') . '">' . Lang::T('Offline') . '</span>';
        }
        break;
    case 'customer_select2':

        $s = addslashes(_get('s'));
        if (empty($s)) {
            $c = ORM::for_table('tbl_customers')->limit(30)->find_many();
        } else {
            $c = ORM::for_table('tbl_customers')->where_raw("(`username` LIKE '%$s%' OR `fullname` LIKE '%$s%' OR `phonenumber` LIKE '%$s%' OR `email` LIKE '%$s%')")->limit(30)->find_many();
        }
        header('Content-Type: application/json');
        foreach ($c as $cust) {
            $json[] = [
                'id' => $cust['id'],
                'text' => $cust['username'] . ' - ' . $cust['fullname'] . ' - ' . $cust['email']
            ];
        }
        echo json_encode(['results' => $json]);
        die();
    default:
        $ui->display('admin/404.tpl');
}
