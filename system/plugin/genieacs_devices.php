<?php
// File: system/plugin/genieacs_devices.php

// Check admin user type before registering menu - only Agent allowed
$admin = Admin::_info();
if ($admin['user_type'] === 'Agent') {
    register_menu("GenieACS Devices", true, "genieacs_devices", 'AFTER_PLANS', 'ion ion-android-list');
}

function genieacs_devices()
{
    global $ui, $routes;
    _admin();
    $ui->assign('_title', 'GenieACS Devices');
    $ui->assign('_system_menu', 'genieacs_devices');
    $admin = Admin::_info();
    $ui->assign('_admin', $admin);

    $action = $routes['2'] ?? '';

    switch ($action) {
        case 'refresh':
            genieacs_refresh_device();
            break;
        case 'summon':
            genieacs_summon_device();
            break;
        case 'reboot':
            genieacs_reboot_device();
            break;
        case 'find-by-tag':
            genieacs_find_by_tag();
            break;
        case 'force-sync':
            genieacs_force_sync();
            break;
        case 'get-offline-devices':
            genieacs_get_offline_devices();
            break;
        case 'ajax-search':
            genieacs_ajax_search();
            break;
        case 'set-server':
            // Handle AJAX request to set server
            if (isset($_POST['server_id'])) {
                $_SESSION['selected_acs_server'] = intval($_POST['server_id']);
                echo json_encode(['success' => true]);
            } else {
                echo json_encode(['success' => false]);
            }
            exit;
            break;
        case '':
        default:
            genieacs_device_list();
            break;
    }
}

function genieacs_device_list()
{
    global $ui, $routes;

    // Get all available servers
    $servers = ORM::for_table('tbl_acs_servers')
        ->where('status', 'active')
        ->order_by_asc('name')
        ->find_many();

    if (count($servers) == 0) {
        r2(U . 'plugin/genieacs_manager', 'e', 'Please configure at least one ACS server first!');
        return;
    }

    // Get selected server - check session first, then use first server
    $selected_server_id = $_SESSION['selected_acs_server'] ?? $servers[0]->id;

    // Validate selected server exists
    $server_exists = false;
    $current_server = null;
    foreach ($servers as $server) {
        if ($server->id == $selected_server_id) {
            $server_exists = true;
            $current_server = $server;
            break;
        }
    }

    // If selected server doesn't exist, use first server
    if (!$server_exists) {
        $selected_server_id = $servers[0]->id;
        $current_server = $servers[0];
    }

    // Save to session
    $_SESSION['selected_acs_server'] = $selected_server_id;

    // Get page number from URL route OR GET parameter
    if (isset($routes['3']) && is_numeric($routes['3'])) {
        $page = intval($routes['3']);
    } else {
        $page = isset($_GET['page']) ? intval($_GET['page']) : 1;
    }
    if ($page < 1) $page = 1;

    // Items per page - CHANGED TO 10
    $per_page = 10;
    $offset = ($page - 1) * $per_page;

    // Get search and filter parameters
    $search = isset($_GET['search']) ? trim($_GET['search']) : '';
    $status_filter = isset($_GET['status']) ? trim($_GET['status']) : '';
    $rx_power_filter = isset($_GET['rx_power']) ? trim($_GET['rx_power']) : '';
    $location_filter = isset($_GET['location']) ? trim($_GET['location']) : '';

    // Get unique locations for filter dropdown (before applying filters)
    $locations_query = ORM::for_table('tbl_acs_devices')
        ->select_expr('DISTINCT JSON_UNQUOTE(JSON_EXTRACT(device_data, "$.lokasi")) as lokasi')
        ->where('server_id', $selected_server_id)
        ->where_raw('JSON_EXTRACT(device_data, "$.lokasi") IS NOT NULL')
        ->where_raw('JSON_EXTRACT(device_data, "$.lokasi") != ""')
        ->where_raw('JSON_EXTRACT(device_data, "$.lokasi") != "null"');

    $locations_result = $locations_query->find_array();
    $available_locations = [];
    foreach ($locations_result as $loc) {
        if (!empty($loc['lokasi']) && $loc['lokasi'] != 'null') {
            $available_locations[] = $loc['lokasi'];
        }
    }
    sort($available_locations);

    // BUILD QUERY FROM LOCAL DATABASE
    $query = ORM::for_table('tbl_acs_devices')
        ->where('server_id', $selected_server_id);

    // Apply search if provided
    if (!empty($search)) {
        $search_term = '%' . $search . '%';
        $query->where_raw(
            '(device_id LIKE ? OR 
         JSON_EXTRACT(device_data, "$.pppoe_ip") LIKE ? OR 
         JSON_EXTRACT(device_data, "$.tr069_ip") LIKE ? OR 
         JSON_EXTRACT(device_data, "$.ppp_username") LIKE ? OR 
         JSON_EXTRACT(device_data, "$.pppoe_username") LIKE ? OR 
         JSON_EXTRACT(device_data, "$.tags") LIKE ? OR 
         JSON_EXTRACT(device_data, "$.lokasi") LIKE ?)',
            [$search_term, $search_term, $search_term, $search_term, $search_term, $search_term, $search_term]
        );
    }

    // Apply status filter if provided
    if (!empty($status_filter)) {
        $query->where('status', $status_filter);
    }

    // Apply RX Power filter if provided
    if (!empty($rx_power_filter)) {
        if ($rx_power_filter == 'good') {
            // -20 atau lebih besar (termasuk -20.00)
            $query->where_raw("CAST(JSON_UNQUOTE(JSON_EXTRACT(device_data, '$.rx_power')) AS DOUBLE) >= -20");
        } elseif ($rx_power_filter == 'fair') {
            // -20.01 sampai -25.00
            $query->where_raw("CAST(JSON_UNQUOTE(JSON_EXTRACT(device_data, '$.rx_power')) AS DOUBLE) < -20");
            $query->where_raw("CAST(JSON_UNQUOTE(JSON_EXTRACT(device_data, '$.rx_power')) AS DOUBLE) >= -25");
        } elseif ($rx_power_filter == 'poor') {
            // Kurang dari -25.00 (termasuk -25.01, -25.22, dst)
            $query->where_raw("CAST(JSON_UNQUOTE(JSON_EXTRACT(device_data, '$.rx_power')) AS DOUBLE) < -25");
        }
    }

    // Apply location filter if provided
    if (!empty($location_filter)) {
        $query->where_raw('JSON_UNQUOTE(JSON_EXTRACT(device_data, "$.lokasi")) = ?', [$location_filter]);
    }

    // Get total count for pagination
    $total_devices = $query->count();

    // Get devices with pagination (order by last inform time; fallback to last_sync if no last_inform column)
    $db_devices = $query
        ->limit($per_page)
        ->offset($offset)
        ->order_by_desc('last_sync')
        ->find_many();

    // Device list columns come from tbl_acs_parameters: param_key, param_label, param_path (TR-069 path),
    // param_category=basic, param_type display/both, display_order. Add/edit via Admin → GenieACS Parameters.
    $devices = [];
    $display_params = ORM::for_table('tbl_acs_parameters')
        ->where_raw('(param_type = ? OR param_type = ?)', ['display', 'both'])
        ->where('param_category', 'basic')
        ->order_by_asc('display_order')
        ->find_many();

    foreach ($db_devices as $db_device) {
        $device_data = json_decode($db_device->device_data, true);
        if (!is_array($device_data)) {
            $device_data = [];
        }

        // Build device array using param_path (same as API flow) so values come from nested JSON
        $device = [];
        foreach ($display_params as $param) {
            $value = !empty($param->param_path)
                ? get_dynamic_parameter_value($device_data, $param->param_path)
                : ($device_data[$param->param_key] ?? 'N/A');
            switch ($param->param_key) {
                case 'rx_power':
                    if ($value !== 'N/A' && $value !== '' && is_numeric($value)) {
                        $value = $value . ' dBm';
                    }
                    break;
                case 'uptime':
                    if ($value !== 'N/A' && $value !== '') {
                        $value = format_uptime($value);
                    }
                    break;
                case 'pon_type':
                    $value = $value !== 'N/A' ? strtoupper($value) : $value;
                    break;
                case 'temperature':
                    if ($value !== 'N/A' && $value !== '' && is_numeric($value)) {
                        $value = $value . '°C';
                    }
                    break;
            }
            $device[$param->param_key] = $value;
        }

        $device['id_raw'] = $db_device->device_id;
        $device['device_id'] = $db_device->device_id;
        $device['status'] = (isset($db_device->status) && $db_device->status !== null && $db_device->status !== '')
            ? $db_device->status
            : determine_device_status($device_data, $device);
        $device['tags'] = '';
        $device['lokasi'] = '';
        if (isset($device_data['_tags']) && is_array($device_data['_tags'])) {
            if (isset($device_data['_tags'][0])) {
                $device['tags'] = $device_data['_tags'][0];
            }
            if (isset($device_data['_tags'][1])) {
                $device['lokasi'] = $device_data['_tags'][1];
            }
        }
        if (isset($db_device->last_inform) && $db_device->last_inform) {
            $device['last_inform'] = format_last_inform($db_device->last_inform);
        } else {
            $device['last_inform'] = isset($device_data['_lastInform'])
                ? format_last_inform($device_data['_lastInform'])
                : 'Never';
        }

        $devices[] = $device;
    }

    // Calculate statistics from ALL devices (not just current page)
    $stats_query = ORM::for_table('tbl_acs_devices')
        ->where('server_id', $selected_server_id);

    $online_count = clone $stats_query;
    $online_count = $online_count->where('status', 'online')->count();

    $offline_count = clone $stats_query;
    $offline_count = $offline_count->where('status', 'offline')->count();

    $total = $online_count + $offline_count;

    // Location query already done above, remove this duplicate

    // Calculate warning count from ALL devices in database (RX < -25)
    $warning_query = ORM::for_table('tbl_acs_devices')
        ->where('server_id', $selected_server_id)
        ->where_raw("CAST(JSON_UNQUOTE(JSON_EXTRACT(device_data, '$.rx_power')) AS DOUBLE) < -25")
        ->count();

    $warning_count = $warning_query;

    // Check last sync time
    $last_sync = ORM::for_table('tbl_acs_devices')
        ->where('server_id', $selected_server_id)
        ->max('last_sync');

    if ($last_sync) {
        $sync_age = time() - strtotime($last_sync);
        if ($sync_age > 600) { // More than 10 minutes
            $minutes_ago = floor($sync_age / 60);
            $ui->assign('sync_warning', "Data is {$minutes_ago} minutes old. Last sync: " . date('H:i:s', strtotime($last_sync)));
        }
    }

    // Pagination info
    $total_pages = ceil($total_devices / $per_page);

    $ui->assign('current_page', $page);
    $ui->assign('total_pages', $total_pages);
    $ui->assign('per_page', $per_page);
    $ui->assign('total_devices', $total_devices);
    $ui->assign('search_term', $search);
    $ui->assign('status_filter', $status_filter);
    $ui->assign('rx_power_filter', $rx_power_filter);
    $ui->assign('location_filter', $location_filter);

    // Assign to template
    $ui->assign('available_locations', $available_locations);
    $ui->assign('devices', $devices);
    $ui->assign('device_count', $total_devices);
    $ui->assign('online_count', $online_count);
    $ui->assign('offline_count', $offline_count);
    $ui->assign('warning_count', $warning_count);

    // Calculate percentages
    $ui->assign('online_percentage', $total > 0 ? round(($online_count / $total) * 100, 1) : 0);
    $ui->assign('offline_percentage', $total > 0 ? round(($offline_count / $total) * 100, 1) : 0);
    $ui->assign('warning_percentage', $total > 0 ? round(($warning_count / $total) * 100, 1) : 0);

    // Load display parameters for template
    $ui->assign('display_params', $display_params);
    $ui->assign('servers', $servers);
    $ui->assign('selected_server_id', $selected_server_id);
    $ui->assign('current_server', $current_server);
    $ui->display('genieacs_devices.tpl');
}

function genieacs_get_devices()
{
    // Get all devices without projection first to see full data structure
    return genieacs_api_call('devices', 'GET');
}

function process_device_data($devices)
{
    $processed = [];

    // Load dynamic parameters from database - ONLY basic category untuk device info
    $parameters = ORM::for_table('tbl_acs_parameters')
        ->where_raw('(param_type = ? OR param_type = ?)', ['display', 'both'])
        ->where('param_category', 'basic')  // Only basic parameters for device info
        ->order_by_asc('display_order')
        ->find_many();

    foreach ($devices as $device) {
        $processed_device = [];

        // Process each parameter dynamically
        foreach ($parameters as $param) {
            $value = get_dynamic_parameter_value($device, $param->param_path);

            // Special formatting for certain parameters
            switch ($param->param_key) {
                case 'rx_power':
                    if ($value !== 'N/A' && is_numeric($value)) {
                        $value = $value . ' dBm';
                    }
                    break;
                case 'uptime':
                    if ($value !== 'N/A') {
                        $value = format_uptime($value);
                    }
                    break;
                case 'last_inform':
                    if ($value !== 'N/A') {
                        $value = format_last_inform($value);
                    }
                    break;
                case 'pon_type':
                    $value = strtoupper($value);
                    break;
                case 'temperature':
                    if ($value !== 'N/A' && is_numeric($value)) {
                        $value = $value . '°C';
                    }
                    break;
            }

            $processed_device[$param->param_key] = $value;
        }

        // Add raw device ID for links
        $processed_device['id_raw'] = $processed_device['device_id'] ?? $device['_id'] ?? 'Unknown';

        // Get Tags separately (not from parameters)
        $processed_device['tags'] = '';
        $processed_device['lokasi'] = '';
        if (isset($device['_tags']) && is_array($device['_tags'])) {
            if (isset($device['_tags'][0])) {
                $processed_device['tags'] = $device['_tags'][0];
            }
            if (isset($device['_tags'][1])) {
                $processed_device['lokasi'] = $device['_tags'][1];
            }
        }

        // Determine Status (special logic)
        $processed_device['status'] = determine_device_status($device, $processed_device);

        // Add last inform if not in parameters
        if (!isset($processed_device['last_inform'])) {
            $processed_device['last_inform'] = isset($device['_lastInform']) ? format_last_inform($device['_lastInform']) : 'Never';
        }

        $processed[] = $processed_device;
    }

    return $processed;
}

function get_dynamic_parameter_value($device_data, $param_path)
{
    // Check if multiple paths (comma separated) - PINDAH KE ATAS
    if (strpos($param_path, ',') !== false) {
        $paths = explode(',', $param_path);
        foreach ($paths as $path) {
            $path = trim($path);

            // Try each path with the full logic
            $value = get_dynamic_parameter_value($device_data, $path); // Recursive call

            // Return first valid value found
            if ($value !== null && $value !== 'N/A' && $value !== '' && $value !== false) {
                return $value;
            }
        }
        return 'N/A';
    }

    // Special case untuk model - pakai fallback dari hardcode lama
    if (
        $param_path === 'VirtualParameters.getModel' ||
        $param_path === 'VirtualParameters.deviceModel' ||
        $param_path === '_deviceId._ProductClass'
    ) {
        // ... model handling code tetap sama ...
        if (isset($device_data['_deviceId']['_ProductClass'])) {
            return $device_data['_deviceId']['_ProductClass'];
        }
        if (isset($device_data['InternetGatewayDevice']['DeviceInfo']['ModelName']['_value'])) {
            return $device_data['InternetGatewayDevice']['DeviceInfo']['ModelName']['_value'];
        }
        if (isset($device_data['Device']['DeviceInfo']['ModelName']['_value'])) {
            return $device_data['Device']['DeviceInfo']['ModelName']['_value'];
        }
        return 'N/A';
    }

    // Handle different path types (existing code)
    if (strpos($param_path, 'VirtualParameters.') === 0) {
        // Virtual parameter
        $vp_name = str_replace('VirtualParameters.', '', $param_path);
        return $device_data['VirtualParameters'][$vp_name]['_value'] ?? 'N/A';
    } elseif ($param_path === '_id') {
        // Device ID
        return $device_data['_id'] ?? 'N/A';
    } elseif ($param_path === '_lastInform') {
        // Last Inform
        return $device_data['_lastInform'] ?? 'N/A';
    } elseif (strpos($param_path, '_deviceId.') === 0) {
        // Device ID properties
        $property = str_replace('_deviceId.', '', $param_path);
        return $device_data['_deviceId'][$property] ?? 'N/A';
    } else {
        // Single standard path
        return get_single_path_value($device_data, $param_path);
    }
}
function get_single_path_value($device_data, $path)
{
    $path_parts = explode('.', $path);
    $value = $device_data;

    foreach ($path_parts as $part) {
        if (isset($value[$part])) {
            $value = $value[$part];
        } else {
            return 'N/A';
        }
    }

    return isset($value['_value']) ? $value['_value'] : ($value ?? 'N/A');
}

// New helper function for determining device status
function determine_device_status($device, $processed_device)
{
    $status = 'offline';

    // Check berbagai kemungkinan nama key untuk IP
    $ip = $processed_device['tr069_ip'] ?? $processed_device['pppoe_ip'] ?? $processed_device['ip'] ?? 'N/A';

    // Primary check: last inform time (paling akurat)
    if (isset($device['_lastInform'])) {
        $last_inform_time = strtotime($device['_lastInform']);
        $current_time = time();
        $diff_minutes = ($current_time - $last_inform_time) / 60;

        if ($diff_minutes <= 5) {
            return 'online';
        }

        // Jika lebih dari 5 menit, device offline
        if ($diff_minutes > 5) {
            return 'offline';
        }
    }

    // Secondary check: active IP (tidak reliable, hapus saja)
    // Karena IP bisa ada tapi device offline

    // Check Events.Inform
    if (isset($device['Events']) && isset($device['Events']['Inform'])) {
        $inform_time = strtotime($device['Events']['Inform']);
        $current_time = time();
        $diff_minutes = ($current_time - $inform_time) / 60;

        if ($diff_minutes <= 5) {
            return 'online';
        }
    }

    return 'offline'; // Default offline
}
// Remove these unused functions as we're handling it directly in process_device_data
// They were causing issues with the data extraction

function format_uptime($uptime)
{
    if (!$uptime || $uptime === 'N/A') {
        return 'N/A';
    }

    // Jika uptime sudah dalam format string (dari virtual parameter)
    if (strpos($uptime, 'd ') !== false || strpos($uptime, ':') !== false) {
        return $uptime;
    }

    // Jika uptime dalam seconds
    $seconds = intval($uptime);
    if ($seconds == 0) {
        return 'N/A';
    }

    $days = floor($seconds / 86400);
    $rem = $seconds % 86400;
    $hours = floor($rem / 3600);
    $rem = $rem % 3600;
    $minutes = floor($rem / 60);
    $secs = $rem % 60;

    // Format dengan leading zeros
    $hours = str_pad($hours, 2, '0', STR_PAD_LEFT);
    $minutes = str_pad($minutes, 2, '0', STR_PAD_LEFT);
    $secs = str_pad($secs, 2, '0', STR_PAD_LEFT);

    return "{$days}d {$hours}:{$minutes}:{$secs}";
}

function format_last_inform($timestamp)
{
    if (!$timestamp) {
        return 'Never';
    }

    $time = strtotime($timestamp);
    $diff = time() - $time;

    if ($diff < 60) {
        return 'Just now';
    } elseif ($diff < 3600) {
        $minutes = floor($diff / 60);
        return "{$minutes}m ago";
    } elseif ($diff < 86400) {
        $hours = floor($diff / 3600);
        return "{$hours}h ago";
    } else {
        $days = floor($diff / 86400);
        return "{$days}d ago";
    }
}

function genieacs_refresh_device()
{
    $device_id = $_GET['device_id'] ?? '';

    if (empty($device_id)) {
        echo json_encode(['success' => false, 'error' => 'Device ID required']);
        exit;
    }

    // URL encode device ID untuk API call
    $encoded_device_id = urlencode($device_id);

    // Create task array untuk refresh
    $tasks = [
        [
            'name' => 'refreshObject',
            'objectName' => 'InternetGatewayDevice'
        ]
    ];

    $result = genieacs_api_call("devices/{$encoded_device_id}/tasks?connection_request", 'POST', $tasks);

    if ($result['success']) {
        echo json_encode(['success' => true, 'message' => 'Refresh command sent successfully']);
    } else {
        $error_msg = 'Failed to refresh device';
        if (isset($result['raw_response'])) {
            $error_msg .= ': ' . $result['raw_response'];
        }
        echo json_encode(['success' => false, 'error' => $error_msg]);
    }
    exit;
}

function genieacs_summon_device()
{
    $device_id = $_GET['device_id'] ?? '';

    if (empty($device_id)) {
        echo json_encode(['success' => false, 'error' => 'Device ID required']);
        exit;
    }

    // URL encode device ID untuk API call
    $encoded_device_id = urlencode($device_id);

    // For summon, send empty array (not string)
    $empty_tasks = array();

    $result = genieacs_api_call("devices/{$encoded_device_id}/tasks?connection_request", 'POST', $empty_tasks);

    if ($result['success']) {
        echo json_encode(['success' => true, 'message' => 'Connection request sent successfully']);
    } else {
        $error_msg = 'Failed to send connection request';
        if (isset($result['raw_response'])) {
            $error_msg .= ': ' . $result['raw_response'];
        }
        echo json_encode(['success' => false, 'error' => $error_msg]);
    }
    exit;
}

function genieacs_reboot_device()
{
    $device_id = $_GET['device_id'] ?? '';

    if (empty($device_id)) {
        echo json_encode(['success' => false, 'error' => 'Device ID required']);
        exit;
    }

    // URL encode device ID
    $encoded_device_id = urlencode($device_id);

    // GenieACS v1.2+ format - single object
    $reboot_task = ['name' => 'reboot'];

    // Send task without connection_request parameter first
    $result = genieacs_api_call("devices/{$encoded_device_id}/tasks", 'POST', $reboot_task);

    if ($result['success']) {
        echo json_encode(['success' => true, 'message' => 'Reboot command queued. Waiting for device to connect...']);

        // Now trigger connection request to execute the task
        $empty_array = [];
        genieacs_api_call("devices/{$encoded_device_id}/tasks?connection_request", 'POST', $empty_array);
    } else {
        // Try with connection_request directly
        $result2 = genieacs_api_call("devices/{$encoded_device_id}/tasks?connection_request", 'POST', $reboot_task);

        if ($result2['success']) {
            echo json_encode(['success' => true, 'message' => 'Reboot command sent successfully']);
        } else {
            // Debug info
            $debug_info = "HTTP Code: " . ($result2['http_code'] ?? 'N/A') . "\n";
            $debug_info .= "Response: " . ($result2['raw_response'] ?? 'No response');

            echo json_encode([
                'success' => false,
                'error' => 'Reboot failed. Device may not support remote reboot.',
                'debug' => $debug_info
            ]);
        }
    }
    exit;
}
function genieacs_find_by_tag()
{
    $tag = $_GET['tag'] ?? '';

    if (empty($tag)) {
        echo json_encode(['success' => false, 'error' => 'Tag parameter required']);
        exit;
    }

    // Check if GenieACS is configured
    $config = load_genieacs_config();
    if (!$config || empty($config['host'])) {
        echo json_encode(['success' => false, 'error' => 'GenieACS not configured']);
        exit;
    }

    // STEP 1: Cari di database lokal dulu (paling cepat)
    $db_device = ORM::for_table('tbl_acs_devices')
        ->where_raw('JSON_UNQUOTE(JSON_EXTRACT(device_data, "$.tags")) = ?', [$tag])
        ->find_one();
    
    if ($db_device) {
        // Verifikasi ke GenieACS API bahwa device masih ada
        $filter = json_encode(['_id' => $db_device->device_id]);
        $verify_result = genieacs_api_call('devices?query=' . urlencode($filter), 'GET');
        
        if ($verify_result['success'] && !empty($verify_result['data'])) {
            $device = $verify_result['data'][0];
            echo json_encode([
                'success' => true,
                'device_id' => $device['_id'],
                'device_tags' => $device['_tags'] ?? [$tag],
                'message' => 'Device found'
            ]);
            exit;
        }
    }
    
    // STEP 2: Query GenieACS dengan filter tag (lebih efisien dari ambil semua)
    // GenieACS mendukung query berdasarkan tag: {"_tags": "tagname"}
    $filter = json_encode(['_tags' => $tag]);
    $devices_result = genieacs_api_call('devices?query=' . urlencode($filter), 'GET');
    
    if ($devices_result['success'] && !empty($devices_result['data'])) {
        $device = $devices_result['data'][0];
        echo json_encode([
            'success' => true,
            'device_id' => $device['_id'],
            'device_tags' => $device['_tags'] ?? [],
            'message' => 'Device found'
        ]);
        exit;
    }
    
    // STEP 3: Fallback - Cari dengan regex untuk case insensitive
    $filter_regex = json_encode(['_tags' => ['$regex' => $tag, '$options' => 'i']]);
    $devices_result = genieacs_api_call('devices?query=' . urlencode($filter_regex), 'GET');
    
    if ($devices_result['success'] && !empty($devices_result['data'])) {
        // Cari yang exact match (case insensitive)
        foreach ($devices_result['data'] as $device) {
            if (isset($device['_tags']) && is_array($device['_tags'])) {
                foreach ($device['_tags'] as $device_tag) {
                    if (strtolower(trim($device_tag)) === strtolower(trim($tag))) {
                        echo json_encode([
                            'success' => true,
                            'device_id' => $device['_id'],
                            'device_tags' => $device['_tags'],
                            'message' => 'Device found'
                        ]);
                        exit;
                    }
                }
            }
        }
    }

    // Device not found
    echo json_encode([
        'success' => false,
        'error' => 'No device found with tag: ' . $tag,
        'searched_tag' => $tag
    ]);
    exit;
}

function genieacs_force_sync()
{
    header('Content-Type: application/json');

    // Check if admin
    _admin();

    $server_id = (int) ($_SESSION['selected_acs_server'] ?? 0);

    if ($server_id <= 0) {
        echo json_encode(['success' => false, 'error' => 'No server selected']);
        exit;
    }

    if (!function_exists('genieacs_sync_devices_for_server')) {
        echo json_encode(['success' => false, 'error' => 'GenieACS plugin not loaded']);
        exit;
    }

    // Run sync in this request (works on Windows/Laragon and Linux; no shell needed)
    set_time_limit(120);
    $result = genieacs_sync_devices_for_server($server_id);

    if (!$result['success']) {
        echo json_encode([
            'success' => false,
            'error' => $result['error'] ?? 'Sync failed'
        ]);
        exit;
    }

    $total = (int) $result['total'];
    $msg = $total === 0
        ? 'No devices found on this GenieACS server.'
        : "Synced {$total} device(s): {$result['inserted']} new, {$result['updated']} updated, {$result['deleted']} removed.";
    echo json_encode([
        'success' => true,
        'message' => $msg,
        'server_id' => $server_id,
        'total' => $total,
        'inserted' => (int) $result['inserted'],
        'updated' => (int) $result['updated'],
        'deleted' => (int) $result['deleted']
    ]);
    exit;
}

function genieacs_get_offline_devices()
{
    header('Content-Type: application/json');

    $server_id = $_SESSION['selected_acs_server'] ?? 0;

    if (!$server_id) {
        echo json_encode(['success' => false, 'error' => 'No server selected']);
        exit;
    }

    // Get ALL offline devices from database
    $offline_devices = ORM::for_table('tbl_acs_devices')
        ->select('device_id')
        ->select_expr('JSON_UNQUOTE(JSON_EXTRACT(device_data, "$.pppoe_username")) as username')
        ->select_expr('JSON_UNQUOTE(JSON_EXTRACT(device_data, "$.model")) as model')
        ->where('server_id', $server_id)
        ->where('status', 'offline')
        ->find_array();

    $devices = [];
    foreach ($offline_devices as $device) {
        $devices[] = [
            'id' => $device['device_id'],
            'status' => 'offline',
            'username' => $device['username'] ?: 'Unknown User',
            'model' => $device['model'] ?: 'Device'
        ];
    }

    echo json_encode([
        'success' => true,
        'devices' => $devices,
        'count' => count($devices)
    ]);
    exit;
}

function genieacs_ajax_search()
{
    header('Content-Type: application/json');
    
    $server_id = $_SESSION['selected_acs_server'] ?? 0;
    $search = isset($_GET['q']) ? trim($_GET['q']) : '';
    $page = isset($_GET['page']) ? intval($_GET['page']) : 1;
    
    if (!$server_id) {
        echo json_encode(['success' => false, 'error' => 'No server selected']);
        exit;
    }
    
    // GET DISPLAY PARAMETERS - GUNAKAN QUERY YANG SAMA DENGAN MAIN FUNCTION
    $display_params = ORM::for_table('tbl_acs_parameters')
        ->where_raw('(param_type = ? OR param_type = ?)', ['display', 'both'])
        ->where('param_category', 'basic')
        ->order_by_asc('display_order')
        ->find_many();
    
    $per_page = 10;
    $offset = ($page - 1) * $per_page;
    
    // Build query
    $query = ORM::for_table('tbl_acs_devices')
        ->where('server_id', $server_id);
    
    // Apply search if provided
    if (!empty($search)) {
        $search_term = '%' . $search . '%';
        $query->where_raw(
            '(device_id LIKE ? OR 
             JSON_EXTRACT(device_data, "$.pppoe_ip") LIKE ? OR 
             JSON_EXTRACT(device_data, "$.ppp_username") LIKE ? OR 
             JSON_EXTRACT(device_data, "$.tags") LIKE ? OR 
             JSON_EXTRACT(device_data, "$.lokasi") LIKE ?)',
            [$search_term, $search_term, $search_term, $search_term, $search_term]
        );
    }
    
    // Get total for pagination
    $total = $query->count();
    
    // Get devices
    $devices_raw = $query
        ->limit($per_page)
        ->offset($offset)
        ->order_by_desc('last_inform')
        ->find_array();
    
    // Process devices - FULL DYNAMIC
    $result_devices = [];
    foreach ($devices_raw as $device) {
        $data = json_decode($device['device_data'], true) ?: [];
        
        // Base device info
        $processed_device = [
            'device_id' => $device['device_id'],
            'status' => $device['status'],
            'last_inform' => $device['last_inform'] ?? 'Never'
        ];
        
        // Process each display parameter dynamically
        foreach ($display_params as $param) {
            $param_key = $param->param_key;
            $paths = explode(',', $param->param_path);
            $value = '';
            
            // Special handling untuk common variations
            if ($param_key === 'pppoe_username' && isset($data['ppp_username'])) {
                $value = $data['ppp_username'];
            } elseif ($param_key === 'pppoe_ip' && isset($data['pppoe_ip'])) {
                $value = $data['pppoe_ip'];
            } elseif ($param_key === 'mac_address' && isset($data['ppp_mac'])) {
                $value = $data['ppp_mac'];
            } else {
                // Try each path until we find a value
                foreach ($paths as $path) {
                    $path = trim($path);
                    $clean_path = str_replace('VirtualParameters.', '', $path);
                    
                    if (isset($data[$clean_path]) && !empty($data[$clean_path])) {
                        $value = $data[$clean_path];
                        break;
                    } elseif (isset($data[$param_key]) && !empty($data[$param_key])) {
                        $value = $data[$param_key];
                        break;
                    }
                }
            }
            
            $processed_device[$param_key] = $value ?: '';
        }
        
        // Add special fields
        $processed_device['tags'] = $data['tags'] ?? '';
        $processed_device['lokasi'] = $data['lokasi'] ?? '';
        
        // Special handling for router
        if (isset($processed_device['router']) && empty($processed_device['router']) && !empty($data['model'])) {
            $processed_device['router'] = $data['model'];
        }
        
        $result_devices[] = $processed_device;
    }
    
    // Pass display params for JavaScript
    $display_params_array = [];
    foreach ($display_params as $param) {
        $display_params_array[] = [
            'key' => $param->param_key,
            'label' => $param->param_label
        ];
    }
    
    echo json_encode([
        'success' => true,
        'devices' => $result_devices,
        'display_params' => $display_params_array,
        'total' => $total,
        'page' => $page,
        'total_pages' => ceil($total / $per_page)
    ]);
    exit;
}
