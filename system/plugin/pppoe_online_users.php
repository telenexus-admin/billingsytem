<?php

use PEAR2\Net\RouterOS;

register_menu(
    'PPPoE Online Users',
    true,
    'pppoe_online_users',
    'AFTER_customer_usage',
    'ion ion-link',
    '',
    'success',
    ['Admin', 'SuperAdmin']
);

/**
 * Format bytes for display (same scale as MikroTik monitor).
 */
function pppoe_online_users_format_bytes($bytes, $precision = 2)
{
    $units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
    $bytes = max((int) $bytes, 0);
    $pow = floor(($bytes ? log($bytes) : 0) / log(1024));
    $pow = min($pow, count($units) - 1);
    $bytes /= pow(1024, $pow);

    return round($bytes, $precision) . ' ' . $units[$pow];
}

function pppoe_online_users_norm_name($s)
{
    return strtolower(trim((string) $s));
}

function pppoe_online_users_norm_ip($ip)
{
    $ip = trim((string) $ip);
    if ($ip === '' || !filter_var($ip, FILTER_VALIDATE_IP)) {
        return '';
    }

    return $ip;
}

/**
 * Build maps: normalized pppoe_username / username / pppoe_ip -> fullname and customer id.
 *
 * @param string[] $sessionNames MikroTik PPPoE session names
 * @param string[] $sessionIps Session IPv4/IPv6 (matches tbl_customers.pppoe_ip when set)
 * @return array{pppoe: array<string,string>, user: array<string,string>, email: array<string,string>, ip: array<string,string>, id_pppoe: array<string,int>, id_user: array<string,int>, id_email: array<string,int>, id_ip: array<string,int>}
 */
function pppoe_online_users_customer_maps(array $sessionNames, array $sessionIps = [])
{
    $out = ['pppoe' => [], 'user' => [], 'email' => [], 'ip' => [], 'id_pppoe' => [], 'id_user' => [], 'id_email' => [], 'id_ip' => []];

    $normNames = [];
    foreach ($sessionNames as $sn) {
        $n = pppoe_online_users_norm_name($sn);
        if ($n !== '') {
            $normNames[$n] = true;
        }
    }
    $uniqNorms = array_keys($normNames);

    if ($uniqNorms !== []) {
        foreach (array_chunk($uniqNorms, 200) as $chunk) {
            $in = implode(',', array_fill(0, count($chunk), '?'));
            $custs = ORM::for_table('tbl_customers')
                ->where_raw('LOWER(TRIM(IFNULL(pppoe_username, \'\'))) IN (' . $in . ')', $chunk)
                ->find_many();
            foreach ($custs as $c) {
                $k = pppoe_online_users_norm_name($c['pppoe_username'] ?? '');
                if ($k === '') {
                    continue;
                }
                $out['pppoe'][$k] = $c['fullname'] ?? '';
                $out['id_pppoe'][$k] = (int) $c['id'];
            }
            $custs2 = ORM::for_table('tbl_customers')
                ->where_raw('LOWER(TRIM(IFNULL(username, \'\'))) IN (' . $in . ')', $chunk)
                ->find_many();
            foreach ($custs2 as $c) {
                $k = pppoe_online_users_norm_name($c['username'] ?? '');
                if ($k === '') {
                    continue;
                }
                $out['user'][$k] = $c['fullname'] ?? '';
                $out['id_user'][$k] = (int) $c['id'];
            }
            $custsE = ORM::for_table('tbl_customers')
                ->where_raw('LOWER(TRIM(IFNULL(email, \'\'))) IN (' . $in . ')', $chunk)
                ->find_many();
            foreach ($custsE as $c) {
                $k = pppoe_online_users_norm_name($c['email'] ?? '');
                if ($k === '') {
                    continue;
                }
                $out['email'][$k] = $c['fullname'] ?? '';
                $out['id_email'][$k] = (int) $c['id'];
            }
        }
    }

    $uniqIps = [];
    foreach ($sessionIps as $ip) {
        $ni = pppoe_online_users_norm_ip($ip);
        if ($ni !== '') {
            $uniqIps[$ni] = true;
        }
    }
    $uniqIps = array_keys($uniqIps);
    foreach (array_chunk($uniqIps, 200) as $chunk) {
        if ($chunk === []) {
            continue;
        }
        $custs3 = ORM::for_table('tbl_customers')
            ->where_in('pppoe_ip', $chunk)
            ->find_many();
        foreach ($custs3 as $c) {
            $pip = pppoe_online_users_norm_ip($c['pppoe_ip'] ?? '');
            if ($pip === '') {
                continue;
            }
            $out['ip'][$pip] = $c['fullname'] ?? '';
            $out['id_ip'][$pip] = (int) $c['id'];
        }
    }

    return $out;
}

function pppoe_online_users_resolve_name($sessionName, array $maps, $sessionIp = null)
{
    $kn = pppoe_online_users_norm_name($sessionName);
    if ($kn !== '' && isset($maps['pppoe'][$kn]) && $maps['pppoe'][$kn] !== '') {
        return $maps['pppoe'][$kn];
    }
    if ($kn !== '' && isset($maps['user'][$kn]) && $maps['user'][$kn] !== '') {
        return $maps['user'][$kn];
    }
    if ($kn !== '' && isset($maps['email'][$kn]) && $maps['email'][$kn] !== '') {
        return $maps['email'][$kn];
    }
    $ki = pppoe_online_users_norm_ip($sessionIp);
    if ($ki !== '' && isset($maps['ip'][$ki]) && $maps['ip'][$ki] !== '') {
        return $maps['ip'][$ki];
    }

    return '—';
}

/**
 * @param array{id_pppoe: array<string,int>, id_user: array<string,int>, id_email: array<string,int>, id_ip: array<string,int>} $maps
 */
function pppoe_online_users_resolve_customer_id($sessionName, array $maps, $sessionIp = null)
{
    $kn = pppoe_online_users_norm_name($sessionName);
    if ($kn !== '' && isset($maps['id_pppoe'][$kn])) {
        return (int) $maps['id_pppoe'][$kn];
    }
    if ($kn !== '' && isset($maps['id_user'][$kn])) {
        return (int) $maps['id_user'][$kn];
    }
    if ($kn !== '' && isset($maps['id_email'][$kn])) {
        return (int) $maps['id_email'][$kn];
    }
    $ki = pppoe_online_users_norm_ip($sessionIp);
    if ($ki !== '' && isset($maps['id_ip'][$ki])) {
        return (int) $maps['id_ip'][$ki];
    }

    return null;
}

function pppoe_online_users()
{
    global $ui, $routes;
    _admin();
    $ui->assign('_title', Lang::T('PPPoE_Online_Users'));
    $admin = Admin::_info();
    $ui->assign('_admin', $admin);

    $routers = ORM::for_table('tbl_routers')->where('enabled', '1')->find_many();
    $router = $routes['2'] ?? '';
    if ($router === '' || $router === null) {
        $router = !empty($routers) ? $routers[0]['id'] : '';
    }
    $ui->assign('routers', $routers);
    $ui->assign('router', $router);
    $ui->assign('routes', $routes);
    $ui->assign('pppoe_ou_router', json_encode((string) $router));
    $ui->assign('pppoe_ou_i18n', json_encode([
        'empty' => Lang::T('No_online_PPPoE_users_found'),
        'online' => Lang::T('Online'),
        'view' => Lang::T('View'),
        'close' => Lang::T('Close'),
        'liveTraffic' => Lang::T('Live_traffic'),
        'noLinkedCustomer' => Lang::T('PPPoE_no_linked_customer'),
        'sessionEnded' => Lang::T('PPPoE_session_ended'),
    ]));

    $ui->assign('xheader', '
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    <style>
    .pppoe-live-wrap{height:56px;min-width:140px;max-width:220px;position:relative;margin:0 auto;}
    .pppoe-live-wrap canvas{display:block;}
    #pppoe-online-table td.pppoe-live-cell{vertical-align:middle;}
    #pppoe-online-table tbody tr{cursor:pointer;}
    #pppoe-online-table tbody tr:hover{background-color:#f0f4f8!important;}
    #pppoe-modal-chart-wrap{height:280px;position:relative;}
    </style>
    ');

    $ui->display('pppoe_online_users.tpl');
}

function pppoe_online_users_json()
{
    global $routes;
    _admin();
    header('Content-Type: application/json; charset=utf-8');

    $router = $routes['2'] ?? '';
    if ($router === '' || $router === null) {
        echo json_encode([]);
        return;
    }

    $mikrotik = ORM::for_table('tbl_routers')->where('enabled', '1')->find_one($router);
    if (!$mikrotik) {
        echo json_encode([]);
        return;
    }

    try {
        $client = Mikrotik::getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);
        $pppUsers = $client->sendSync(new RouterOS\Request('/ppp/active/print'));

        $interfaceTraffic = $client->sendSync(new RouterOS\Request('/interface/print'));
        $interfaceData = [];
        foreach ($interfaceTraffic as $interface) {
            $name = $interface->getProperty('name');
            if ($name === '' || $name === null) {
                continue;
            }
            $interfaceData[$name] = [
                'txBytes' => (int) $interface->getProperty('tx-byte'),
                'rxBytes' => (int) $interface->getProperty('rx-byte'),
            ];
        }

        $rawRows = [];
        $namesForLookup = [];
        $ipsForLookup = [];
        foreach ($pppUsers as $pppUser) {
            $service = strtolower((string) $pppUser->getProperty('service'));
            if ($service !== 'pppoe') {
                continue;
            }
            $username = $pppUser->getProperty('name');
            if ($username === '' || $username === null) {
                continue;
            }
            $namesForLookup[] = $username;
            $ipsForLookup[] = $pppUser->getProperty('address') ?: '';
            $rawRows[] = $pppUser;
        }

        $maps = pppoe_online_users_customer_maps($namesForLookup, $ipsForLookup);

        $userList = [];
        $n = 0;
        foreach ($rawRows as $pppUser) {
            $n++;
            $username = $pppUser->getProperty('name');
            $address = $pppUser->getProperty('address') ?: '';
            $uptime = $pppUser->getProperty('uptime') ?: '';
            $service = $pppUser->getProperty('service') ?: '';
            $callerid = $pppUser->getProperty('caller-id') ?: '';

            $interfaceName = '<pppoe-' . $username . '>';
            if (isset($interfaceData[$interfaceName])) {
                $txBytes = $interfaceData[$interfaceName]['txBytes'];
                $rxBytes = $interfaceData[$interfaceName]['rxBytes'];
            } else {
                $txBytes = 0;
                $rxBytes = 0;
            }

            $cid = pppoe_online_users_resolve_customer_id($username, $maps, $address);
            $userList[] = [
                'row' => $n,
                'fullname' => pppoe_online_users_resolve_name($username, $maps, $address),
                'username' => $username,
                'address' => $address,
                'uptime' => $uptime,
                'service' => $service,
                'caller_id' => $callerid,
                'tx' => pppoe_online_users_format_bytes($txBytes),
                'rx' => pppoe_online_users_format_bytes($rxBytes),
                'total' => pppoe_online_users_format_bytes($txBytes + $rxBytes),
                'tx_bytes' => $txBytes,
                'rx_bytes' => $rxBytes,
                'customer_id' => $cid,
            ];
        }
    } catch (Throwable $e) {
        _log('PPPoE Online Users: ' . $e->getMessage());
        $userList = [];
    }

    echo json_encode($userList);
}
