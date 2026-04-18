<?php

use PEAR2\Net\RouterOS;

register_menu(
    'Hotspot Online Users',
    true,
    'hotspot_online_users',
    'AFTER_customer_usage',
    'ion ion-wifi',
    '',
    'success',
    ['Admin', 'SuperAdmin']
);

function hotspot_online_users_format_bytes($bytes, $precision = 2)
{
    $units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
    $bytes = max((int) $bytes, 0);
    $pow = floor(($bytes ? log($bytes) : 0) / log(1024));
    $pow = min($pow, count($units) - 1);
    $bytes /= pow(1024, $pow);

    return round($bytes, $precision) . ' ' . $units[$pow];
}

function hotspot_online_users_norm_name($s)
{
    return strtolower(trim((string) $s));
}

function hotspot_online_users_norm_ip($ip)
{
    $ip = trim((string) $ip);
    if ($ip === '' || !filter_var($ip, FILTER_VALIDATE_IP)) {
        return '';
    }

    return $ip;
}

/**
 * Match Hotspot session user + IP to billing: pppoe_username, username, email, pppoe_ip.
 *
 * @param string[] $sessionUsers Login names from MikroTik /ip/hotspot/active
 * @param string[] $sessionIps Session client IPs
 * @return array{pppoe: array<string,string>, user: array<string,string>, email: array<string,string>, ip: array<string,string>, id_pppoe: array<string,int>, id_user: array<string,int>, id_email: array<string,int>, id_ip: array<string,int>}
 */
function hotspot_online_users_customer_maps(array $sessionUsers, array $sessionIps = [])
{
    $out = [
        'pppoe' => [], 'user' => [], 'email' => [], 'ip' => [],
        'id_pppoe' => [], 'id_user' => [], 'id_email' => [], 'id_ip' => [],
    ];

    $normNames = [];
    foreach ($sessionUsers as $u) {
        $n = hotspot_online_users_norm_name($u);
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
                $k = hotspot_online_users_norm_name($c['pppoe_username'] ?? '');
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
                $k = hotspot_online_users_norm_name($c['username'] ?? '');
                if ($k === '') {
                    continue;
                }
                $out['user'][$k] = $c['fullname'] ?? '';
                $out['id_user'][$k] = (int) $c['id'];
            }
            $custs3 = ORM::for_table('tbl_customers')
                ->where_raw('LOWER(TRIM(IFNULL(email, \'\'))) IN (' . $in . ')', $chunk)
                ->find_many();
            foreach ($custs3 as $c) {
                $k = hotspot_online_users_norm_name($c['email'] ?? '');
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
        $ni = hotspot_online_users_norm_ip($ip);
        if ($ni !== '') {
            $uniqIps[$ni] = true;
        }
    }
    $uniqIps = array_keys($uniqIps);
    foreach (array_chunk($uniqIps, 200) as $chunk) {
        if ($chunk === []) {
            continue;
        }
        $custs4 = ORM::for_table('tbl_customers')
            ->where_in('pppoe_ip', $chunk)
            ->find_many();
        foreach ($custs4 as $c) {
            $pip = hotspot_online_users_norm_ip($c['pppoe_ip'] ?? '');
            if ($pip === '') {
                continue;
            }
            $out['ip'][$pip] = $c['fullname'] ?? '';
            $out['id_ip'][$pip] = (int) $c['id'];
        }
    }

    return $out;
}

function hotspot_online_users_resolve_name($sessionUser, array $maps, $sessionIp = null)
{
    $kn = hotspot_online_users_norm_name($sessionUser);
    if ($kn !== '' && isset($maps['pppoe'][$kn]) && $maps['pppoe'][$kn] !== '') {
        return $maps['pppoe'][$kn];
    }
    if ($kn !== '' && isset($maps['user'][$kn]) && $maps['user'][$kn] !== '') {
        return $maps['user'][$kn];
    }
    if ($kn !== '' && isset($maps['email'][$kn]) && $maps['email'][$kn] !== '') {
        return $maps['email'][$kn];
    }
    $ki = hotspot_online_users_norm_ip($sessionIp);
    if ($ki !== '' && isset($maps['ip'][$ki]) && $maps['ip'][$ki] !== '') {
        return $maps['ip'][$ki];
    }

    return '—';
}

/**
 * @param array{id_pppoe: array<string,int>, id_user: array<string,int>, id_email: array<string,int>, id_ip: array<string,int>} $maps
 */
function hotspot_online_users_resolve_customer_id($sessionUser, array $maps, $sessionIp = null)
{
    $kn = hotspot_online_users_norm_name($sessionUser);
    if ($kn !== '' && isset($maps['id_pppoe'][$kn])) {
        return (int) $maps['id_pppoe'][$kn];
    }
    if ($kn !== '' && isset($maps['id_user'][$kn])) {
        return (int) $maps['id_user'][$kn];
    }
    if ($kn !== '' && isset($maps['id_email'][$kn])) {
        return (int) $maps['id_email'][$kn];
    }
    $ki = hotspot_online_users_norm_ip($sessionIp);
    if ($ki !== '' && isset($maps['id_ip'][$ki])) {
        return (int) $maps['id_ip'][$ki];
    }

    return null;
}

function hotspot_online_users()
{
    global $ui, $routes;
    _admin();
    $ui->assign('_title', Lang::T('Hotspot_Online_Users'));
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
    $ui->assign('hotspot_ou_router', json_encode((string) $router));
    $ui->assign('hotspot_ou_i18n', json_encode([
        'empty' => Lang::T('No_hotspot_users_online'),
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
    .hotspot-live-wrap{height:56px;min-width:140px;max-width:220px;position:relative;margin:0 auto;}
    .hotspot-live-wrap canvas{display:block;}
    #hotspot-online-table td.hotspot-live-cell{vertical-align:middle;}
    #hotspot-online-table tbody tr{cursor:pointer;}
    #hotspot-online-table tbody tr:hover{background-color:#f0f4f8!important;}
    #hotspot-modal-chart-wrap{height:280px;position:relative;}
    </style>
    ');

    $ui->display('hotspot_online_users.tpl');
}

function hotspot_online_users_json()
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
        $hotspotActive = $client->sendSync(new RouterOS\Request('/ip/hotspot/active/print'));

        $namesForLookup = [];
        $ipsForLookup = [];
        foreach ($hotspotActive as $hotspot) {
            $user = $hotspot->getProperty('user');
            if ($user !== '' && $user !== null) {
                $namesForLookup[] = $user;
                $ipsForLookup[] = $hotspot->getProperty('address') ?: '';
            }
        }

        $maps = hotspot_online_users_customer_maps($namesForLookup, $ipsForLookup);

        $userList = [];
        $n = 0;
        foreach ($hotspotActive as $hotspot) {
            $username = $hotspot->getProperty('user') ?: '';
            if ($username === '') {
                continue;
            }
            $n++;
            $address = $hotspot->getProperty('address') ?: '';
            $uptime = $hotspot->getProperty('uptime') ?: '';
            $server = $hotspot->getProperty('server') ?: '';
            $mac = $hotspot->getProperty('mac-address') ?: '';
            $sessionTime = $hotspot->getProperty('session-time-left') ?: '';
            $rxBytes = (int) $hotspot->getProperty('bytes-in');
            $txBytes = (int) $hotspot->getProperty('bytes-out');

            $rosId = $hotspot->getProperty('.id');
            $sessionKey = ($rosId !== '' && $rosId !== null) ? (string) $rosId : ($username . '|' . $mac);
            $cid = hotspot_online_users_resolve_customer_id($username, $maps, $address);

            $userList[] = [
                'row' => $n,
                'fullname' => hotspot_online_users_resolve_name($username, $maps, $address),
                'username' => $username,
                'address' => $address,
                'mac' => $mac,
                'uptime' => $uptime,
                'server' => $server,
                'session_time' => $sessionTime,
                'tx' => hotspot_online_users_format_bytes($txBytes),
                'rx' => hotspot_online_users_format_bytes($rxBytes),
                'total' => hotspot_online_users_format_bytes($txBytes + $rxBytes),
                'tx_bytes' => $txBytes,
                'rx_bytes' => $rxBytes,
                'customer_id' => $cid,
                'session_key' => $sessionKey,
            ];
        }
    } catch (Throwable $e) {
        _log('Hotspot Online Users: ' . $e->getMessage());
        $userList = [];
    }

    echo json_encode($userList);
}
