<?php

use PEAR2\Net\RouterOS;
use PEAR2\Net\RouterOS\Client;
use PEAR2\Net\RouterOS\Request;
use PEAR2\Net\RouterOS\Response;

register_menu('MikroMon', true, 'mikrotik_monitor_ui', 'AFTER_SETTINGS', 'ion ion-wifi', '', 'info', []);

function mikrotik_monitor_ui()
{
    global $ui, $routes;
    _admin();
    $ui->assign('_title', 'MikroMon — MikroTik Network Monitor');
    $ui->assign('_system_menu', 'MikroMon');
    $admin = Admin::_info();
    $ui->assign('_admin', $admin);
    $routers = ORM::for_table('tbl_routers')->where('enabled', '1')->find_many();
    $router = $routes['2'];
    if (empty($router)) {
        $router = $routers[0]['id'];
    }
    $ui->assign('xheader', '
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.11.3/css/jquery.dataTables.min.css">
    <style>
        .card-container {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
        }
        .card {
            flex: 1 1 calc(33.333% - 1rem);
            margin-bottom: 1rem;
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .card-header-bg-info {
            background-color: #0d6efd; /* Bootstrap primary color */
            color: #fff;
            padding: 15px;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
        }
        .card-header-bg-success {
            background-color: #009174; /* Bootstrap primary color */
            color: #fff;
            padding: 15px;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
        }
        .card-header-bg-warning {
            background-color: #d0d414; /* Bootstrap primary color */
            color: #fff;
            padding: 15px;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
        }
        .card-header-bg-danger {
            background-color: #12b9bd; /* Bootstrap primary color */
            color: #fff;
            padding: 15px;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
        }
        .card-body {
            padding: 15px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th,
        td {
            padding: 8px;
            border: 1px solid #ddd;
            text-align: left;
        }
        th.custom-class {
            background-color: #f2f2f2;
            color: #000;
            font-weight: bold;
        }
        tr.even-row {
            background-color: #f2f2f2;
        }
        tr.custom-class {
            color: blue;
            font-weight: bold;
        }
        #ppp-table th,
        #ppp-table td {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            width: 100px;
        }
        .chart-canvas {
            width: 100px;
            height: 80px;
        }
        @media only screen and (max-width: 768px) {
            .card {
                flex: 1 1 calc(100% - 1rem);
            }
        }
        @media only screen and (min-width: 769px) {
            .card {
                flex: 1 1 calc(33.333% - 1rem);
            }
        }
    </style>');

    $ui->assign('routers', $routers);
    $ui->assign('router', $router);
    $interfaces = mikrotik_monitor_get_interfaces_list();
    $ui->assign('interfaces', $interfaces);
    $ui->display('mikrotik_monitor.tpl');
}

function mikrotik_monitor_get_wlan()
{
    global $routes;
    $router = $routes['2'];
    $mikrotik = ORM::for_table('tbl_routers')->where('enabled', '1')->find_one($router);
    $client = Mikrotik::getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);
    $wlan = $client->sendSync(new RouterOS\Request('/interface/wireless/registration-table/print'));

    $signalList = [];
    foreach ($wlan as $signal) {
        if ($signal->getType() !== Response::TYPE_DATA) {
            continue;
        }
        $interface = $signal->getProperty('interface');
        $mac_address = $signal->getProperty('mac-address');
        $uptime = $signal->getProperty('uptime');
        $last_ip = $signal->getProperty('last-ip');
        $last_activity = $signal->getProperty('last-activity');
        $signal_strength = $signal->getProperty('signal-strength');
        $tx_ccq = $signal->getProperty('tx-ccq');
        $rx_ccq = $signal->getProperty('rx-ccq');
        $rx_rate = $signal->getProperty('rx-rate');
        $tx_rate = $signal->getProperty('tx-rate');


        $signalList[] = [
            'interface' => $interface,
            'mac_address' => $mac_address,
            'uptime' => $uptime,
            'last_ip' => $last_ip,
            'last_activity' => $last_activity,
            'signal_strength' => $signal_strength,
            'tx_ccq' => $tx_ccq,
            'rx_ccq' => $rx_ccq,
            'rx_rate' => $rx_rate,
            'tx_rate' => $tx_rate,
        ];
    }

    header('Content-Type: application/json');
    echo json_encode($signalList);
}

function mikrotik_monitor_get_resources()
{
    global $routes;
    $router = $routes['2'];
    $mikrotik = ORM::for_table('tbl_routers')->where('enabled', '1')->find_one($router);
    $client = Mikrotik::getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);
    $health = $client->sendSync(new RouterOS\Request('/system health print'));
    $res = $client->sendSync(new RouterOS\Request('/system resource print'));
    // Function to round the value and append the appropriate unit
    function mikrotik_monitor_formatSize($size)
    {
        $units = ['B', 'KB', 'MB', 'GB'];
        $unitIndex = 0;
        while ($size >= 1024 && $unitIndex < count($units) - 1) {
            $size /= 1024;
            $unitIndex++;
        }
        return round($size, 2) . ' ' . $units[$unitIndex];
    }


    $table = '
<style>
    .column-card-container {
        display: flex;
        flex-wrap: wrap;
        justify-content: space-between;
        margin-top: 20px;
    }

    .column-card {
        flex-basis: calc(50% - 20px); /* Dua kartu per baris di layar kecil */
        background-color: #fff;
        border: 1px solid #ddd;
        border-radius: 5px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        margin-bottom: 20px;
    }

    .column-card-header {
        background-color: #009879;
        color: #fff;
        padding: 10px;
        border-radius: 5px 5px 0 0;
    }

    .column-card-content {
        padding: 15px;
    }

    .column-card-content table {
        width: 100%;
        border-collapse: collapse;
    }

    .column-card-content th,
    .column-card-content td {
        padding: 8px;
        border-bottom: 1px solid #ddd;
    }

    .column-card-content th {
        text-align: left;
        background-color: #f2f2f2;
    }

    .column-card-content td {
        text-align: right;
    }

    @media only screen and (max-width: 768px) {
        .column-card {
            flex-basis: calc(100% - 20px); /* Satu kartu per baris di layar kecil */
        }
    }

    @media only screen and (min-width: 769px) {
        .column-card {
            flex-basis: calc(33.33% - 20px); /* Tiga kartu per baris di layar desktop */
        }
    }
    /* Progress Bar Style */
    .column-card-header_progres {
        background-color: #009879;
        color: #fff;
        padding: 10px;
        border-radius: 5px 5px 0 0;
        font-size: 14px; /* Mengatur ukuran font lebih kecil */
    }

    /* Styles lainnya */
    .progress {
        margin-top: 5px;
        display: flex;
        flex-direction: row;
        justify-content: space-between;
        width: 100%;
    }

    .progress-bar {
        background-color: rgb(192, 192, 192);
        height: 20px;
        border-radius: 10px;
        margin-bottom: 5px;
        width: 100%;
        position: relative;
    }

    .progress-bar-container {
        background-color: rgb(116, 194, 92);
        color: white;
        padding: 0.25%;
        text-align: right;
        font-size: 14px;
        border-radius: 10px;
        width: 100%;
    }

    .progress-value {
        position: absolute;
        top: 0;
        right: 5px;
        transform: translateY(-50%);
        color: white;
        font-weight: bold;
    }
</style>

<div class="column-card-container">
    <div class="column-card">
        <div class="column-card-header">Platform Information</div>
        <div class="column-card-content">
            <table>
                <tbody>
                    <tr>
                        <th>Platform</th>
                        <td>' . $res->getProperty('platform') . '</td>
                    </tr>
                    <tr>
                        <th>Board</th>
                        <td>' . $res->getProperty('board-name') . '</td>
                    </tr>
                    <tr>
                        <th>Arch</th>
                        <td>' . $res->getProperty('architecture-name') . '</td>
                    </tr>
                    <tr>
                        <th>Version</th>
                        <td>' . $res->getProperty('version') . '</td>
                    </tr>
                    <tr>
                        <th>Mem used/free</th>
                        <td>' . mikrotik_monitor_formatSize($res->getProperty('total-memory') - $res->getProperty('free-memory')) . ' / ' . mikrotik_monitor_formatSize($res->getProperty('free-memory')) . '</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <div class="column-card">
        <div class="column-card-header">System Information</div>
        <div class="column-card-content">
            <table>
                <tbody>
                    <tr>
                        <th>Uptime</th>
                        <td>' . $res->getProperty('uptime') . '</td>
                    </tr>
                    <tr>
                        <th>Build time</th>
                        <td>' . $res->getProperty('build-time') . '</td>
                    </tr>
                    <tr>
                        <th>Factory Software</th>
                        <td>' . $res->getProperty('factory-software') . '</td>
                    </tr>
                    <tr>
                        <th>Free Hdd Space</th>
                        <td>' . mikrotik_monitor_formatSize($res->getProperty('free-hdd-space')) . '</td>
                    </tr>
                    <tr>
                        <th>Total Memory</th>
                        <td>' . mikrotik_monitor_formatSize($res->getProperty('total-memory')) . '</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    <div class="column-card">
        <div class="column-card-header">Hardware Information</div>
        <div class="column-card-content">
            <table>
                <tbody>
                    <tr>
                        <th>CPU</th>
                        <td>' . $res->getProperty('cpu') . '</td>
                    </tr>
                    <tr>
                        <th>CPU count/freq/load</th>
                        <td>' . $res->getProperty('cpu-count') . '/' . $res->getProperty('cpu-frequency') . '/' . $res->getProperty('cpu-load') . '</td>
                    </tr>
                    <tr>
                        <th>Hdd</th>
                        <td>' . mikrotik_monitor_formatSize($res->getProperty('free-hdd-space')) . ' / ' . mikrotik_monitor_formatSize($res->getProperty('total-hdd-space')) . '</td>
                    </tr>
                    <tr>
                        <th>Write Total</th>
                        <td>' . $res->getProperty('write-sect-total') . '</td>
                    </tr>
                    <tr>
                        <th>Write Since Reboot</th>
                        <td>' . $res->getProperty('write-sect-since-reboot') . '</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>
';
    echo $table;
}

function mikrotik_monitor_get_interfaces_list()
{
    global $routes;
    $router = $routes['2'];
    $mikrotik = ORM::for_table('tbl_routers')->where('enabled', '1')->find_one($router);
    $client = Mikrotik::getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);
    
    try {
        $interfaces = $client->sendSync(new RouterOS\Request('/interface/print'));
        $interfaceList = [];
        foreach ($interfaces as $interface) {
            if ($interface->getType() !== Response::TYPE_DATA) {
                continue;
            }
            $name = $interface->getProperty('name');
            if (!empty($name)) {
                // Escape HTML characters
                $safeName = htmlspecialchars($name, ENT_QUOTES, 'UTF-8');
                $interfaceList[] = $safeName;
            }
        }
        return $interfaceList;
    } catch (Exception $e) {
        _log('Mikrotik Monitor Error fetching interface list: ' . $e->getMessage());
        sendTelegram('Mikrotik Monitor Error fetching interface list: ' . $e->getMessage());
        return [];
    }
}

function mikrotik_monitor_get_traffic()
{
    global $routes;
    $router = $routes['2'];
    $mikrotik = ORM::for_table('tbl_routers')->where('enabled', '1')->find_one($router);
    $client = Mikrotik::getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);
    $traffic = $client->sendSync(new RouterOS\Request('/interface/print'));

    $interfaceData = [];
    foreach ($traffic as $interface) {
        if ($interface->getType() !== Response::TYPE_DATA) {
            continue;
        }
        $name = $interface->getProperty('name');
        // Skip interfaces with missing names
        if (empty($name)) {
            continue;
        }

        $txBytes = intval($interface->getProperty('tx-byte'));
        $rxBytes = intval($interface->getProperty('rx-byte'));
        $name = htmlspecialchars($name, ENT_QUOTES, 'UTF-8');
        $interfaceData[] = [
            'name' => $name,
            'status' => $interface->getProperty('running') === 'true' ? '
<small class="label bg-green">up</small>' : '
<small class="label bg-red">down</small>',
            'tx' => mikrotik_monitor_formatBytes($txBytes),
            'rx' => mikrotik_monitor_formatBytes($rxBytes),
            'total' => mikrotik_monitor_formatBytes($txBytes + $rxBytes)
        ];
    }

    header('Content-Type: application/json');
    echo json_encode($interfaceData);
}

// Function to format bytes into KB, MB, GB or TB
function mikrotik_monitor_formatBytes($bytes, $precision = 2)
{
    $units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
    $bytes = max($bytes, 0);
    $pow = floor(($bytes ? log($bytes) : 0) / log(1024));
    $pow = min($pow, count($units) - 1);
    $bytes /= pow(1024, $pow);
    return round($bytes, $precision) . ' ' . $units[$pow];
}

function mikrotik_monitor_get_ppp_online_users()
{
    global $routes;
    $router = $routes['2'];
    $mikrotik = ORM::for_table('tbl_routers')->where('enabled', '1')->find_one($router);
    $client = Mikrotik::getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);
    $pppUsers = $client->sendSync(new RouterOS\Request('/ppp/active/print'));

    $interfaceTraffic = $client->sendSync(new RouterOS\Request('/interface/print'));
    $interfaceData = [];
    foreach ($interfaceTraffic as $interface) {
        if ($interface->getType() !== Response::TYPE_DATA) {
            continue;
        }
        $name = $interface->getProperty('name');
        // Skip interfaces with missing names
        if (empty($name)) {
            continue;
        }

        $interfaceData[$name] = [
            'txBytes' => intval($interface->getProperty('tx-byte')),
            'rxBytes' => intval($interface->getProperty('rx-byte')),
        ];
    }

    $userList = [];
    foreach ($pppUsers as $pppUser) {
        if ($pppUser->getType() !== Response::TYPE_DATA) {
            continue;
        }
        $service = strtolower((string) $pppUser->getProperty('service'));
        if ($service !== 'pppoe') {
            continue;
        }
        $username = $pppUser->getProperty('name');
        if ($username === '' || $username === null) {
            continue;
        }
        $address = $pppUser->getProperty('address');
        $uptime = $pppUser->getProperty('uptime');
        $callerid = $pppUser->getProperty('caller-id');

        $ifBracket = '<pppoe-' . $username . '>';
        $ifPlain = 'pppoe-' . $username;
        if (isset($interfaceData[$ifBracket])) {
            $trafficData = $interfaceData[$ifBracket];
        } elseif (isset($interfaceData[$ifPlain])) {
            $trafficData = $interfaceData[$ifPlain];
        } else {
            $trafficData = null;
        }
        if ($trafficData) {
            $txBytes = $trafficData['txBytes'];
            $rxBytes = $trafficData['rxBytes'];
        } else {
            $txBytes = 0;
            $rxBytes = 0;
        }

        $userList[] = [
            'username' => $username,
            'address' => $address,
            'uptime' => $uptime,
            'service' => 'pppoe',
            'caller_id' => $callerid,
            'tx' => mikrotik_monitor_formatBytes($txBytes),
            'rx' => mikrotik_monitor_formatBytes($rxBytes),
            'total' => mikrotik_monitor_formatBytes($txBytes + $rxBytes),
        ];
    }
    //  var_dump(isset($interfaceData[$interfaceName]));

    // Return the PPP online user list as JSON
    header('Content-Type: application/json');
    echo json_encode($userList);
}



function mikrotik_monitor_get_hotspot_online_users()
{
    global $routes;
    $router = $routes['2'];
    $mikrotik = ORM::for_table('tbl_routers')->where('enabled', '1')->find_one($router);
    $client = Mikrotik::getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);
    $hotspotActive = $client->sendSync(new RouterOS\Request('/ip/hotspot/active/print'));

    $hotspotList = [];
    foreach ($hotspotActive as $hotspot) {
        if ($hotspot->getType() !== Response::TYPE_DATA) {
            continue;
        }
        $username = $hotspot->getProperty('user') ?: '';
        if ($username === '') {
            continue;
        }
        $address = $hotspot->getProperty('address') ?: '';
        $uptime = $hotspot->getProperty('uptime') ?: '';
        $server = $hotspot->getProperty('server') ?: '';
        $mac = $hotspot->getProperty('mac-address') ?: '';
        $sessionTime = $hotspot->getProperty('session-time-left') ?: '';
        $rxBytes = (int) $hotspot->getProperty('bytes-in');
        $txBytes = (int) $hotspot->getProperty('bytes-out');

        $hotspotList[] = [
            'username' => $username,
            'address' => $address,
            'uptime' => $uptime,
            'server' => $server,
            'mac' => $mac,
            'session_time' => $sessionTime,
            'rx_bytes' => mikrotik_monitor_formatBytes($rxBytes),
            'tx_bytes' => mikrotik_monitor_formatBytes($txBytes),
            'total' => mikrotik_monitor_formatBytes($txBytes + $rxBytes),
        ];
    }

    // Return the Hotspot online user list as JSON
    header('Content-Type: application/json');
    echo json_encode($hotspotList);
}

function mikrotik_monitor_disconnect_online_user($router, $username, $userType)
{
    // Check if the form was submitted
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        // Retrieve the form data
        $router = $_POST['router'];
        $username = $_POST['username'];
        $userType = $_POST['userType'];

        $mikrotik = ORM::for_table('tbl_routers')->where('enabled', '1')->find_one($router);

        if (!$mikrotik) {
            // Handle the error response or redirection
            return;
        }

        try {
            $client = Mikrotik::getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);

            if ($userType == 'hotspot') {
                Mikrotik::removeHotspotActiveUser($client, $username);
                // Handle the success response or redirection
            } elseif ($userType == 'pppoe') {
                Mikrotik::removePpoeActive($client, $username);
                // Handle the success response or redirection
            } else {
                // Handle the error response or redirection
                return;
            }
        } catch (Exception $e) {
            // Handle the error response or redirection
        } finally {
            // Disconnect from the MikroTik router
            if (isset($client)) {
                $client->disconnect();
            }
        }
    }
}

function mikrotik_monitor_traffic_update()
{
    $interface  = $_GET["interface"];
    global $routes;
    $router = $routes['2'];
    $mikrotik = ORM::for_table('tbl_routers')->where('enabled', '1')->find_one($router);
    $client = Mikrotik::getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);

    try {
        $results = $client->sendSync(
            (new RouterOS\Request('/interface/monitor-traffic'))
                ->setArgument('interface', $interface)
                ->setArgument('once', '')
        );

        $rows = array();
        $rows2 = array();
        $labels = array();

        foreach ($results as $result) {
            $ftx = $result->getProperty('tx-bits-per-second');
            $frx = $result->getProperty('rx-bits-per-second');

            $rows[] = $ftx;
            $rows2[] = $frx;
            $labels[] = date('H:i:s');
        }

        $result = array(
            'labels' => $labels,
            'rows' => array(
                'tx' => $rows,
                'rx' => $rows2
            )
        );
    } catch (Exception $e) {
        $result = array('error' => $e->getMessage());
    }

    // Return the result as JSON
    header('Content-Type: application/json');
    echo json_encode($result);
}

/**
 * Parse /system health print for RouterOS 6 (legacy row) and 7+ (sensor rows).
 *
 * @return array{0: float|null, 1: string|float|null}
 */
function mikrotik_monitor_parse_health_rows($healthCollection)
{
    $temp = null;
    $volt = null;
    foreach ($healthCollection as $row) {
        if ($row->getType() !== Response::TYPE_DATA) {
            continue;
        }
        $legacyT = $row->getProperty('temperature');
        if ($legacyT !== null && $legacyT !== '' && is_numeric($legacyT)) {
            $temp = (float) $legacyT;
        }
        $legacyV = $row->getProperty('voltage');
        if ($legacyV !== null && $legacyV !== '') {
            $volt = is_numeric($legacyV) ? (float) $legacyV : $legacyV;
        }
        $name = (string) $row->getProperty('name');
        $val = $row->getProperty('value');
        if ($name !== '' && $val !== null && $val !== '') {
            if (preg_match('/temperature|temp|cpu-temp/i', $name) && is_numeric($val)) {
                $temp = (float) $val;
            }
            if (preg_match('/voltage/i', $name)) {
                $volt = is_numeric($val) ? (float) $val : $val;
            }
        }
    }

    return [$temp, $volt];
}

function mikrotik_monitor_get_resources_json()
{
    global $routes;
    header('Content-Type: application/json; charset=utf-8');

    $data = [
        'cpu_load' => 0,
        'temperature' => null,
        'temperature_display' => '—',
        'temperature_bar' => 0,
        'voltage' => null,
        'voltage_display' => '—',
        'voltage_bar' => 0,
        'memory_percent' => 0,
        'memory_used_text' => '—',
        'memory_total_text' => '—',
        'uptime' => '—',
        'ppp_secrets_total' => 0,
        'pppoe_online' => 0,
        'hotspot_online' => 0,
    ];

    $router = $routes['2'] ?? '';
    if ($router === '' || $router === null) {
        echo json_encode($data);
        return;
    }

    $mikrotik = ORM::for_table('tbl_routers')->where('enabled', '1')->find_one($router);
    if (!$mikrotik) {
        echo json_encode($data);
        return;
    }

    try {
        $client = Mikrotik::getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);

        $res = $client->sendSync(new RouterOS\Request('/system resource print'));
        foreach ($res as $row) {
            if ($row->getType() !== Response::TYPE_DATA) {
                continue;
            }
            $cpu = $row->getProperty('cpu-load');
            if ($cpu !== null && $cpu !== '') {
                $data['cpu_load'] = max(0, min(100, (int) $cpu));
            }
            $totalMem = (int) $row->getProperty('total-memory');
            $freeMem = (int) $row->getProperty('free-memory');
            if ($totalMem > 0) {
                $usedMem = max(0, $totalMem - $freeMem);
                $data['memory_percent'] = (int) round(($usedMem / $totalMem) * 100);
                $data['memory_used_text'] = mikrotik_monitor_formatBytes($usedMem);
                $data['memory_total_text'] = mikrotik_monitor_formatBytes($totalMem);
            }
            $up = $row->getProperty('uptime');
            if ($up !== null && $up !== '') {
                $data['uptime'] = $up;
            }
            break;
        }

        try {
            $health = $client->sendSync(new RouterOS\Request('/system health print'));
            list($t, $v) = mikrotik_monitor_parse_health_rows($health);
            if ($t !== null) {
                $data['temperature'] = round($t, 1);
                $data['temperature_display'] = $data['temperature'] . '°C';
                $data['temperature_bar'] = (int) max(0, min(100, ($t / 85) * 100));
            }
            if ($v !== null && $v !== '') {
                if (is_numeric($v)) {
                    $vf = (float) $v;
                    $data['voltage'] = round($vf, 2);
                    $data['voltage_display'] = $data['voltage'] . ' V';
                    $data['voltage_bar'] = (int) max(0, min(100, ($vf / 15) * 100));
                } else {
                    $data['voltage_display'] = (string) $v;
                }
            }
        } catch (Throwable $e) {
            // No health sensors (CHR, some VMs, etc.)
        }

        try {
            $secrets = $client->sendSync(new RouterOS\Request('/ppp/secret/print'));
            $nSec = 0;
            foreach ($secrets as $row) {
                if ($row->getType() === Response::TYPE_DATA) {
                    $nSec++;
                }
            }
            $data['ppp_secrets_total'] = $nSec;
        } catch (Throwable $e) {
        }

        $ppp = $client->sendSync(new RouterOS\Request('/ppp active print'));
        foreach ($ppp as $row) {
            if ($row->getType() !== Response::TYPE_DATA) {
                continue;
            }
            if (strtolower((string) $row->getProperty('service')) === 'pppoe') {
                $data['pppoe_online']++;
            }
        }

        $hs = $client->sendSync(new RouterOS\Request('/ip/hotspot/active/print'));
        foreach ($hs as $row) {
            if ($row->getType() !== Response::TYPE_DATA) {
                continue;
            }
            $u = $row->getProperty('user');
            if ($u !== null && $u !== '') {
                $data['hotspot_online']++;
            }
        }
    } catch (Throwable $e) {
        _log('mikrotik_monitor_get_resources_json: ' . $e->getMessage());
    }

    echo json_encode($data);
}
function mikrotik_monitor_fetchLogs($routerId)
{
    if (!$routerId) {
        return [];
    }

    try {
        $mikrotik = ORM::for_table('tbl_routers')->where('enabled', '1')->find_one($routerId);
        if (!$mikrotik) {
            return [];
        }

        $client = Mikrotik::getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);
        $request = new Request('/log/print');
        $response = $client->sendSync($request);

        $logs = [];
        foreach ($response as $entry) {
            $logs[] = $entry->getIterator()->getArrayCopy();
        }
        return $logs;
    } catch (Exception $e) {
        _log('Error fetching logs: ' . $e->getMessage());
        sendTelegram('Mikrotik Monitor Error fetching logs.\nReport: ' . $e->getMessage());
        return [];
    }
}

function mikrotik_monitor_getLogs()
{
    header('Content-Type: application/json');
    $routerId = $_GET['routerId'] ?? null;

    $logs = mikrotik_monitor_fetchLogs($routerId);
    echo json_encode($logs);
}
