<?php

/**
 * Log verbose customer/session debug only when not in Live (avoid noisy server logs in production).
 */
function customers_debug_log($message)
{
    if (function_exists('app_is_live') && !app_is_live()) {
        error_log($message);
    }
}

_admin();
$ui->assign('_title', Lang::T('Customer'));
$ui->assign('_system_menu', 'customers');

$action = $routes['1'];
$ui->assign('_admin', $admin);

if (empty($action)) {
    $action = 'list';
}

$leafletpickerHeader = <<<EOT
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.3/dist/leaflet.css">
EOT;

// Function to get user session data from LOCAL DATABASE ONLY (no external API calls)
function getUserLiveSession($username) {
    $userSession = [
        'online' => false,
        'type' => '',
        'ip' => '',
        'mac' => '',
        'uptime' => '',
        'session_time_left' => '',
        'upload' => '0 B',
        'download' => '0 B', 
        'total' => '0 B',
        'router' => '',
        'error' => false
    ];
    
    try {
        // First check for active session (online user)
        $active_session = ORM::for_table('tbl_usage_sessions')
            ->where('username', $username)
            ->where_gte('last_seen', date('Y-m-d H:i:s', strtotime('-1 minute')))
            ->order_by_desc('start_time')
            ->find_one();
        
        // If no active session, get the most recent session (for historical data)
        $session = $active_session ?: ORM::for_table('tbl_usage_sessions')
            ->where('username', $username)
            ->order_by_desc('last_seen')
            ->find_one();
        
        if ($session) {
            $is_online = ($active_session !== null);
            $router = ORM::for_table('tbl_routers')->find_one($session->router_id);
            
            // Calculate uptime (session duration)
            if ($is_online) {
                // For online users: time since session started
                $start_time = strtotime($session->start_time);
                $current_time = time();
                $uptime_seconds = $current_time - $start_time;
            } else {
                // For offline users: show last session duration
                $start_time = strtotime($session->start_time);
                $end_time = strtotime($session->last_seen);
                $uptime_seconds = $end_time - $start_time;
            }
            
            // Format uptime properly
            if ($uptime_seconds <= 0) {
                $uptime = '< 1m';
            } else if ($uptime_seconds < 60) {
                $uptime = $uptime_seconds . 's';
            } else {
                $days = floor($uptime_seconds / 86400);
                $hours = floor(($uptime_seconds % 86400) / 3600);
                $minutes = floor(($uptime_seconds % 3600) / 60);
                $uptime_parts = [];
                if ($days > 0) $uptime_parts[] = $days . 'd';
                if ($hours > 0) $uptime_parts[] = $hours . 'h';
                if ($minutes > 0) $uptime_parts[] = $minutes . 'm';
                $uptime = empty($uptime_parts) ? '< 1m' : implode(' ', $uptime_parts);
            }
            
            // Calculate time remaining from active plan expiration (like recharge history)
            $session_time_left = 'Unlimited';
            try {
                $active_plan = ORM::for_table('tbl_user_recharges')
                    ->where('username', $username)
                    ->where('status', 'on')
                    ->order_by_desc('recharged_on')
                    ->find_one();
                    
                if ($active_plan) {
                    $expiry_string = trim($active_plan['expiration'] . ' ' . $active_plan['time']);
                    $expiry_ts = strtotime($expiry_string);
                    $now = time();
                    $seconds_left = $expiry_ts - $now;
                    
                    // Debug logging
                    customers_debug_log("DEBUG SESSION: User $username - Expiry String: '$expiry_string', Expiry TS: $expiry_ts, Now: $now, Seconds Left: $seconds_left");
                    
                    if ($expiry_ts === false || $seconds_left <= 0) {
                        $session_time_left = 'Expired';
                    } else {
                        $days = floor($seconds_left / 86400);
                        $hours = floor(($seconds_left % 86400) / 3600);
                        $minutes = floor(($seconds_left % 3600) / 60);
                        
                        $time_parts = array();
                        if ($days > 0) $time_parts[] = $days . 'd';
                        if ($hours > 0) $time_parts[] = $hours . 'h';  
                        if ($minutes > 0) $time_parts[] = $minutes . 'm';
                        
                        $session_time_left = empty($time_parts) ? '< 1m' : implode(' ', $time_parts);
                    }
                } else {
                    $session_time_left = 'No Active Plan';
                }
            } catch (Exception $e) {
                $session_time_left = 'Unknown';
            }
            
            if ($is_online) {
                // Online users: show current session data
                $userSession = [
                    'online' => true,
                    'type' => ucfirst($session->interface), // 'hotspot' or 'pppoe'
                    'ip' => $session->ip_address ?: 'Unknown',
                    'mac' => $session->mac_address ?: 'Unknown', 
                    'uptime' => $uptime,
                    'session_time_left' => $session_time_left,
                    'download' => formatBytes($session->session_rx ?: 0),
                    'upload' => formatBytes($session->session_tx ?: 0),
                    'total' => formatBytes(($session->session_rx ?: 0) + ($session->session_tx ?: 0)),
                    'router' => $router ? $router->name : 'Unknown',
                    'error' => false
                ];
            } else {
                // Offline users: show total lifetime data from tbl_usage_records
                $total_upload = ORM::for_table('tbl_usage_records')
                    ->where('username', $username)
                    ->sum('tx_bytes') ?: 0;
                $total_download = ORM::for_table('tbl_usage_records')
                    ->where('username', $username)
                    ->sum('rx_bytes') ?: 0;
                
                // Debug logging to check if data exists
                customers_debug_log("DEBUG: User $username (offline) - Total Upload: $total_upload, Total Download: $total_download");
                
                $userSession = [
                    'online' => false,
                    'type' => 'User Offline',
                    'ip' => '', // Blank for offline users
                    'mac' => '', // Blank for offline users
                    'uptime' => $uptime, // Show last session uptime
                    'session_time_left' => $session_time_left,
                    'download' => formatBytes($total_download), // Total lifetime download
                    'upload' => formatBytes($total_upload), // Total lifetime upload  
                    'total' => formatBytes($total_upload + $total_download), // Total lifetime usage
                    'router' => 'Total Usage',
                    'error' => false
                ];
            }
        } else {
            // No session data found - check historical records
            $total_upload = ORM::for_table('tbl_usage_records')
                ->where('username', $username)
                ->sum('tx_bytes') ?: 0;
            $total_download = ORM::for_table('tbl_usage_records')
                ->where('username', $username)
                ->sum('rx_bytes') ?: 0;
            
            // Debug logging to check if data exists
            customers_debug_log("DEBUG: User $username (no sessions) - Total Upload: $total_upload, Total Download: $total_download");
            
            $userSession = [
                'online' => false,
                'type' => 'No Session',
                'ip' => '',  // Blank for expired users
                'mac' => '', // Blank for expired users
                'uptime' => 'No Session',
                'session_time_left' => 'No Active Plan',
                'download' => formatBytes($total_download),
                'upload' => formatBytes($total_upload),
                'total' => formatBytes($total_upload + $total_download),
                'router' => 'Historical Data',
                'error' => false
            ];
        }
        
    } catch (Exception $e) {
        // Return offline status on any error
        $userSession['error'] = false;
    }
    
    return $userSession;
}

// Function to format bytes (fallback if not available)
if (!function_exists('formatBytes')) {
    function formatBytes($size, $precision = 2) {
        if ($size <= 0) return '0 B';
        $base = log($size, 1024);
        $suffixes = array('B', 'KB', 'MB', 'GB', 'TB');
        $suffix_index = floor($base);
        if ($suffix_index >= count($suffixes)) {
            $suffix_index = count($suffixes) - 1;
        }
        return round(pow(1024, $base - $suffix_index), $precision) . ' ' . $suffixes[$suffix_index];
    }
}

/**
 * Delete one customer and related recharges (same behavior as customers/delete).
 *
 * @param int $id Customer primary key
 * @return bool True if the customer row existed and was removed
 */
function customers_delete_customer_record($id)
{
    global $_app_stage;
    $id = (int) $id;
    if ($id <= 0) {
        return false;
    }
    $c = ORM::for_table('tbl_customers')->find_one($id);
    if (!$c) {
        return false;
    }
    ORM::for_table('tbl_customers_fields')->where('customer_id', $id)->delete_many();
    $turs = ORM::for_table('tbl_user_recharges')->where('username', $c['username'])->find_many();
    foreach ($turs as $tur) {
        $p = ORM::for_table('tbl_plans')->find_one($tur['plan_id']);
        if ($p) {
            $dvc = Package::getDevice($p);
            if (!app_is_demo_restricted()) {
                if (file_exists($dvc)) {
                    require_once $dvc;
                    $p['plan_expired'] = 0;
                    (new $p['device'])->remove_customer($c, $p);
                } else {
                    new Exception(Lang::T("Devices Not Found"));
                }
            }
        }
        try {
            $tur->delete();
        } catch (Exception $e) {
        }
    }
    try {
        $c->delete();
        return true;
    } catch (Exception $e) {
        return false;
    }
}

switch ($action) {
    case 'csv':
        if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin'])) {
            _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
        }
        $csrf_token = _req('token');
        if (!Csrf::check($csrf_token)) {
            r2(getUrl('customers'), 'e', Lang::T('Invalid or Expired CSRF Token') . ".");
        }

        $cs = ORM::for_table('tbl_customers')
            ->select('tbl_customers.id', 'id')
            ->select('tbl_customers.username', 'username')
            ->select('fullname')
            ->select('address')
            ->select('phonenumber')
            ->select('email')
            ->select('balance')
            ->select('service_type')
            ->order_by_asc('tbl_customers.id')
            ->find_array();

        $h = false;
        set_time_limit(-1);
        header('Pragma: public');
        header('Expires: 0');
        header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
        header("Content-type: text/csv");
        header('Content-Disposition: attachment;filename="phpnuxbill_customers_' . date('Y-m-d_H_i') . '.csv"');
        header('Content-Transfer-Encoding: binary');

        $headers = [
            'id',
            'username',
            'fullname',
            'address',
            'phonenumber',
            'email',
            'balance',
            'service_type',
        ];

        if (!$h) {
            echo '"' . implode('","', $headers) . "\"\n";
            $h = true;
        }

        foreach ($cs as $c) {
            $row = [
                $c['id'],
                $c['username'],
                $c['fullname'],
                $c['address'],
                $c['phonenumber'],
                $c['email'],
                $c['balance'],
                $c['service_type'],
            ];
            echo '"' . implode('","', $row) . "\"\n";
        }
        break;
        //case csv-prepaid can be moved later to (plan.php)  php file dealing with prepaid users
    case 'csv-prepaid':
        if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin'])) {
            _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
        }

        $cs = ORM::for_table('tbl_customers')
            ->select('tbl_customers.id', 'id')
            ->select('tbl_customers.username', 'username')
            ->select('fullname')
            ->select('address')
            ->select('phonenumber')
            ->select('email')
            ->select('balance')
            ->select('service_type')
            ->select('namebp')
            ->select('routers')
            ->select('status')
            ->select('method', 'Payment')
            ->left_outer_join('tbl_user_recharges', array('tbl_customers.id', '=', 'tbl_user_recharges.customer_id'))
            ->order_by_asc('tbl_customers.id')
            ->find_array();

        $h = false;
        set_time_limit(-1);
        header('Pragma: public');
        header('Expires: 0');
        header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
        header("Content-type: text/csv");
        header('Content-Disposition: attachment;filename="phpnuxbill_prepaid_users' . date('Y-m-d_H_i') . '.csv"');
        header('Content-Transfer-Encoding: binary');

        $headers = [
            'id',
            'username',
            'fullname',
            'address',
            'phonenumber',
            'email',
            'balance',
            'service_type',
            'namebp',
            'routers',
            'status',
            'Payment'
        ];

        if (!$h) {
            echo '"' . implode('","', $headers) . "\"\n";
            $h = true;
        }

        foreach ($cs as $c) {
            $row = [
                $c['id'],
                $c['username'],
                $c['fullname'],
                $c['address'],
                $c['phonenumber'],
                $c['email'],
                $c['balance'],
                $c['service_type'],
                $c['namebp'],
                $c['routers'],
                $c['status'],
                $c['Payment']
            ];
            echo '"' . implode('","', $row) . "\"\n";
        }
        break;
    case 'add':
        if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin', 'Agent', 'Sales'])) {
            _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
        }
        $ui->assign('xheader', $leafletpickerHeader);
        run_hook('view_add_customer'); #HOOK
        $plans = ORM::for_table('tbl_plans')
            ->where('enabled', 1)
            ->where_in('type', ['Hotspot', 'PPPOE'])
            ->order_by_asc('name_plan')
            ->find_many();
        $ui->assign('plans', $plans);
        $ui->assign('csrf_token',  Csrf::generateAndStoreToken());
        $ui->display('admin/customers/add.tpl');
        break;
    case 'recharge':
        if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin', 'Agent', 'Sales'])) {
            _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
        }
        $id_customer = $routes['2'];
        $plan_id = $routes['3'];
        $csrf_token = _req('token');
        if (!Csrf::check($csrf_token)) {
            r2(getUrl('customers/view/') . $id_customer, 'e', Lang::T('Invalid or Expired CSRF Token') . ".");
        }
        $b = ORM::for_table('tbl_user_recharges')->where('customer_id', $id_customer)->where('plan_id', $plan_id)->find_one();
        if ($b) {
            $gateway = 'Recharge';
            $channel = $admin['fullname'];
            $cust = User::_info($id_customer);
            $plan = ORM::for_table('tbl_plans')->find_one($b['plan_id']);
            $add_inv = User::getAttribute("Invoice", $id_customer);
            if (!empty($add_inv)) {
                $plan['price'] = $add_inv;
            }
            $tax_enable = isset($config['enable_tax']) ? $config['enable_tax'] : 'no';
            $tax_rate_setting = isset($config['tax_rate']) ? $config['tax_rate'] : null;
            $custom_tax_rate = isset($config['custom_tax_rate']) ? (float)$config['custom_tax_rate'] : null;
            if ($tax_rate_setting === 'custom') {
                $tax_rate = $custom_tax_rate;
            } else {
                $tax_rate = $tax_rate_setting;
            }
            if ($tax_enable === 'yes') {
                $tax = Package::tax($plan['price'], $tax_rate);
            } else {
                $tax = 0;
            }
            list($bills, $add_cost) = User::getBills($id_customer);
            if ($using == 'balance' && $config['enable_balance'] == 'yes') {
                if (!$cust) {
                    r2(getUrl('plan/recharge'), 'e', Lang::T('Customer not found'));
                }
                if (!$plan) {
                    r2(getUrl('plan/recharge'), 'e', Lang::T('Plan not found'));
                }
                if ($cust['balance'] < ($plan['price'] + $add_cost + $tax)) {
                    r2(getUrl('plan/recharge'), 'e', Lang::T('insufficient balance'));
                }
                $gateway = 'Recharge Balance';
            }
            if ($using == 'zero') {
                $zero = 1;
                $gateway = 'Recharge Zero';
            }
            $usings = explode(',', $config['payment_usings']);
            $usings = array_filter(array_unique($usings));
            if (count($usings) == 0) {
                $usings[] = Lang::T('Cash');
            }
            $abills = User::getAttributes("Bill");
            if ($tax_enable === 'yes') {
                $ui->assign('tax', $tax);
            }
            $ui->assign('usings', $usings);
            $ui->assign('abills', $abills);
            $ui->assign('bills', $bills);
            $ui->assign('add_cost', $add_cost);
            $ui->assign('cust', $cust);
            $ui->assign('gateway', $gateway);
            $ui->assign('channel', $channel);
            $ui->assign('server', $b['routers']);
            $ui->assign('plan', $plan);
            $ui->assign('add_inv', $add_inv);
            $ui->assign('csrf_token',  Csrf::generateAndStoreToken());
            $ui->display('admin/plan/recharge-confirm.tpl');
        } else {
            r2(getUrl('customers/view/') . $id_customer, 'e', 'Cannot find active plan');
        }
        break;
    case 'deactivate':
        if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin'])) {
            _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
        }
        $id_customer = $routes['2'];
        $plan_id = $routes['3'];
        $csrf_token = _req('token');
        if (!Csrf::check($csrf_token)) {
            r2(getUrl('customers/view/') . $id_customer, 'e', Lang::T('Invalid or Expired CSRF Token') . ".");
        }
        $b = ORM::for_table('tbl_user_recharges')->where('customer_id', $id_customer)->where('plan_id', $plan_id)->find_one();
        if ($b) {
            $p = ORM::for_table('tbl_plans')->where('id', $b['plan_id'])->find_one();
            if ($p) {
                $p = ORM::for_table('tbl_plans')->where('id', $b['plan_id'])->find_one();
                $c = User::_info($id_customer);
                $dvc = Package::getDevice($p);
                if (!app_is_demo_restricted()) {
                    if (file_exists($dvc)) {
                        require_once $dvc;
                        (new $p['device'])->remove_customer($c, $p);
                    } else {
                        new Exception(Lang::T("Devices Not Found"));
                    }
                }
                $b->status = 'off';
                $b->expiration = date('Y-m-d');
                $b->time = date('H:i:s');
                $b->save();
                _log('Admin ' . $admin['username'] . ' Deactivate ' . $b['namebp'] . ' for ' . $b['username'], 'User', $b['customer_id']);
                Message::sendTelegram('Admin ' . $admin['username'] . ' Deactivate ' . $b['namebp'] . ' for u' . $b['username']);
                r2(getUrl('customers/view/') . $id_customer, 's', 'Success deactivate customer to Mikrotik');
            }
        }
        r2(getUrl('customers/view/') . $id_customer, 'e', 'Cannot find active plan');
        break;
    case 'sync':
        $id_customer = $routes['2'];
        
        // Convert username to customer ID if needed (minimal fix for sync issue)
        if (!is_numeric($id_customer)) {
            $customer_lookup = ORM::for_table('tbl_customers')->where('username', $id_customer)->find_one();
            if ($customer_lookup) {
                $actual_customer_id = $customer_lookup->id;
            } else {
                r2(getUrl('customers/view/') . $id_customer, 'e', 'Customer not found');
                break;
            }
        } else {
            $actual_customer_id = $id_customer;
        }
        
        $csrf_token = _req('token');
        if (!Csrf::check($csrf_token)) {
            r2(getUrl('customers/view/') . $id_customer, 'e', Lang::T('Invalid or Expired CSRF Token') . ".");
        }
        
        // Use original PHPNuxBill sync approach: sync ALL plans with status 'on'
        $bs = ORM::for_table('tbl_user_recharges')->where('customer_id', $actual_customer_id)->where('status', 'on')->findMany();
        if ($bs) {
            $routers = [];
            foreach ($bs as $b) {
                $c = ORM::for_table('tbl_customers')->find_one($actual_customer_id);
                $p = ORM::for_table('tbl_plans')->where('id', $b['plan_id'])->find_one();
                if ($p) {
                    $routers[] = $b['routers'];
                    $dvc = Package::getDevice($p);
                    if (!app_is_demo_restricted()) {
                        if (file_exists($dvc)) {
                            require_once $dvc;
                            // Try sync_customer method first, then fallback to add_customer (original behavior)
                            if (method_exists($dvc, 'sync_customer')) {
                                (new $p['device'])->sync_customer($c, $p);
                            } else {
                                (new $p['device'])->add_customer($c, $p);
                            }
                        } else {
                            new Exception(Lang::T("Devices Not Found"));
                        }
                    }
                }
            }
            r2(getUrl('customers/view/') . $id_customer, 's', 'Sync success to ' . implode(", ", $routers));
        }
        r2(getUrl('customers/view/') . $id_customer, 'e', 'Cannot find active plan');
        break;
    case 'login':
        if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin'])) {
            _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
        }
        $id = $routes['2'];
        $csrf_token = _req('token');
        if (!Csrf::check($csrf_token)) {
            r2(getUrl('customers/view/') . $id, 'e', Lang::T('Invalid or Expired CSRF Token') . ".");
        }
        $customer = ORM::for_table('tbl_customers')->find_one($id);
        if ($customer) {
            $_SESSION['uid'] = $id;
            User::setCookie($id);
            _alert('You are logging in as ' . htmlspecialchars($customer['fullname'], ENT_QUOTES, 'UTF-8') . ",<br>don't logout just close tab.", 'info', "home", 10);
        }
        _alert(Lang::T('Customer not found'), 'danger', "customers");
        break;
    case 'viewu':
        $customer = ORM::for_table('tbl_customers')->where('username', $routes['2'])->find_one();
        if (!$customer) {
            r2(getUrl('customers/list'), 'e', Lang::T('Account Not Found'));
        }
        // Fall through to view case with ID
        $id = $customer->id;
    case 'view':
        if (!isset($id)) {
            $id = $routes['2'];
        }
        
        // If ID is not numeric, try to find by username
        if (!is_numeric($id)) {
            $customer = ORM::for_table('tbl_customers')->where('username', $id)->find_one();
            if ($customer) {
                $id = $customer->id;
            } else {
                r2(getUrl('customers/list'), 'e', Lang::T('Account Not Found'));
            }
        }
        
        run_hook('view_customer'); #HOOK
        $customer = ORM::for_table('tbl_customers')->find_one($id);
        
        if ($customer) {
            // --- Active Package Status & Time Info ---
            $active_package = null;
            $active_since = '';
            $time_remaining = '';
            $package_status = 'offline';
            $now = time();
            // Find latest active package (status 'on', not expired)
            $packages = User::_billing($customer['id']);
            foreach ($packages as $pkg) {
                // Check if package is active (status 'on' and not expired)
                // Handle both date+time and datetime formats with proper timezone
                $expiry_string = trim($pkg['expiration'] . ' ' . $pkg['time']);
                
                // Use DateTime for better timezone handling
                try {
                    $expiry_dt = new DateTime($expiry_string);
                    $now_dt = new DateTime();
                    $expiry_ts = $expiry_dt->getTimestamp();
                    $now_ts = $now_dt->getTimestamp();
                } catch (Exception $e) {
                    // Fallback to strtotime if DateTime fails
                    $expiry_ts = strtotime($expiry_string);
                    $now_ts = time();
                }
                
                // Debug logging for troubleshooting
                customers_debug_log("DEBUG: Package {$pkg['namebp']} - Status: {$pkg['status']}, Expiry: '$expiry_string', ExpTS: $expiry_ts, NowTS: $now_ts, Diff: " . ($expiry_ts - $now_ts) . "s");
                
                if ($pkg['status'] == 'on' && $expiry_ts !== false && $expiry_ts > $now_ts) {
                    $active_package = $pkg;
                    break;
                }
            }
            if ($active_package) {
                // Active since = recharged_on + recharged_time
                $active_since_ts = strtotime($active_package['recharged_on'] . ' ' . $active_package['recharged_time']);
                $active_since = date('d M Y H:i', $active_since_ts);
                // Time remaining = expiration + time - now
                $expiry_ts = strtotime($active_package['expiration'] . ' ' . $active_package['time']);
                $seconds_left = $expiry_ts - $now;
                if ($seconds_left > 0) {
                    $days = floor($seconds_left / 86400);
                    $hours = floor(($seconds_left % 86400) / 3600);
                    $minutes = floor(($seconds_left % 3600) / 60);
                    $time_remaining = ($days > 0 ? $days.'d ' : '') . ($hours > 0 ? $hours.'h ' : '') . $minutes.'m';
                } else {
                    $time_remaining = 'Expired';
                }
                // Online/offline/expired status with session validation
                if ($time_remaining === 'Expired') {
                    // Even if expired, check if user has recent session (within 1 minute)
                    $recent_session = ORM::for_table('tbl_usage_sessions')
                        ->where('username', $customer['username'])
                        ->where_gte('last_seen', date('Y-m-d H:i:s', strtotime('-1 minute')))
                        ->find_one();
                    $package_status = $recent_session ? 'online' : 'expired';
                } else {
                    // Check if user is online using 1-minute threshold for fast response
                    $online_session = ORM::for_table('tbl_usage_sessions')
                        ->where('username', $customer['username'])
                        ->where_gte('last_seen', date('Y-m-d H:i:s', strtotime('-1 minute')))
                        ->find_one();
                    $package_status = $online_session ? 'online' : 'offline';
                }
            } else {
                // No active package, but check if user is online using 1-minute threshold for fast response
                $online_session = ORM::for_table('tbl_usage_sessions')
                    ->where('username', $customer['username'])
                    ->where_gte('last_seen', date('Y-m-d H:i:s', strtotime('-1 minute')))
                    ->find_one();
                if ($online_session) {
                    // Try to find the most recent package (even if expired)
                    if (!empty($packages)) {
                        $recent_pkg = $packages[0];
                        $active_package = $recent_pkg;
                        $active_since_ts = strtotime($recent_pkg['recharged_on'] . ' ' . $recent_pkg['recharged_time']);
                        $active_since = date('d M Y H:i', $active_since_ts);
                        $expiry_ts = strtotime($recent_pkg['expiration'] . ' ' . $recent_pkg['time']);
                        $seconds_left = $expiry_ts - $now;
                        $time_remaining = ($seconds_left > 0) ? ($seconds_left.'s') : 'Expired';
                        $package_status = 'online';
                    } else {
                        $package_status = 'online';
                    }
                }
            }
            $customer['active_package'] = $active_package;
            $customer['active_since'] = $active_since;
            $customer['time_remaining'] = $time_remaining;
            $customer['package_status'] = $package_status;
            
            // Get real-time user session data
            $userSession = getUserLiveSession($customer['username']);
            
            // Fetch the Customers Attributes values from the tbl_customers_fields table
            $customFields = ORM::for_table('tbl_customers_fields')
                ->where('customer_id', $customer['id'])
                ->find_many();
            
            $v = $routes['3'];
            if (empty($v)) {
                $v = 'activation';
            }
            switch ($v) {
                case 'order':
                    $v = 'order';
                    $query = ORM::for_table('tbl_payment_gateway')->where('user_id', $customer['id'])->order_by_desc('id');
                    $order = Paginator::findMany($query);
                    if (empty($order) || $order < 5) {
                        $query = ORM::for_table('tbl_payment_gateway')->where('username', $customer['username'])->order_by_desc('id');
                        $order = Paginator::findMany($query);
                    }
                    $ui->assign('order', $order);
                    break;
                case 'activation':
                    $query = ORM::for_table('tbl_transactions')->where('user_id', $customer['id'])->order_by_desc('id');
                    $activation = Paginator::findMany($query);
                    if (empty($activation) || $activation < 5) {
                        $query = ORM::for_table('tbl_transactions')->where('username', $customer['username'])->order_by_desc('id');
                        $activation = Paginator::findMany($query);
                    }
                    $ui->assign('activation', $activation);
                    break;
            }
            // --- Data Usage Section (like customer_usage.php) ---
            $username = $customer['username'];
            // Current session: get latest from tbl_usage_sessions
            $session = ORM::for_table('tbl_usage_sessions')
                ->where('username', $username)
                ->order_by_desc('start_time')
                ->find_one();
            if ($session) {
                $customer['current_session_upload'] = isset($session->session_tx) ? (int)$session->session_tx : 0;
                $customer['current_session_download'] = isset($session->session_rx) ? (int)$session->session_rx : 0;
            } else {
                $customer['current_session_upload'] = 0;
                $customer['current_session_download'] = 0;
            }
            // Total data used: sum all tx_bytes and rx_bytes from tbl_usage_records
            $total_upload = ORM::for_table('tbl_usage_records')
                ->where('username', $username)
                ->sum('tx_bytes');
            $total_download = ORM::for_table('tbl_usage_records')
                ->where('username', $username)
                ->sum('rx_bytes');
            $customer['total_data_used'] = ($total_upload ? (int)$total_upload : 0) + ($total_download ? (int)$total_download : 0);
            // Format for display (reuse formatBytes from plugin if available)
            if (function_exists('formatBytes')) {
                $customer['current_session_upload_formatted'] = formatBytes($customer['current_session_upload']);
                $customer['current_session_download_formatted'] = formatBytes($customer['current_session_download']);
                $customer['total_data_used_formatted'] = formatBytes($customer['total_data_used']);
            } else {
                $customer['current_session_upload_formatted'] = $customer['current_session_upload'];
                $customer['current_session_download_formatted'] = $customer['current_session_download'];
                $customer['total_data_used_formatted'] = $customer['total_data_used'];
            }
            // --- End Data Usage Section ---
            $ui->assign('packages', User::_billing($customer['id']));
            $ui->assign('userSession', $userSession);
            $ui->assign('v', $v);
            $ui->assign('d', $customer);
            $ui->assign('customFields', $customFields);
            $ui->assign('xheader', $leafletpickerHeader);
            $ui->assign('csrf_token',  Csrf::generateAndStoreToken());
            $ui->display('admin/customers/view.tpl');
        } else {
            r2(getUrl('customers/list'), 'e', Lang::T('Account Not Found'));
        }
        break;
    case 'edit':
        if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin'])) {
            _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
        }
        $id = $routes['2'];
        
        // If ID is not numeric, try to find by username
        if (!is_numeric($id)) {
            $customer = ORM::for_table('tbl_customers')->where('username', $id)->find_one();
            if ($customer) {
                $id = $customer->id;
            } else {
                r2(getUrl('customers/list'), 'e', Lang::T('Account Not Found'));
            }
        }
        
        run_hook('edit_customer'); #HOOK
        $d = ORM::for_table('tbl_customers')->find_one($id);
        // Fetch the Customers Attributes values from the tbl_customers_fields table
        $customFields = ORM::for_table('tbl_customers_fields')
            ->where('customer_id', $id)
            ->find_many();
        if ($d) {
            if (isset($routes['3']) && $routes['3'] == 'deletePhoto') {
                if ($d['photo'] != '' && strpos($d['photo'], 'default') === false) {
                    if (file_exists($UPLOAD_PATH . $d['photo']) && strpos($d['photo'], 'default') === false) {
                        unlink($UPLOAD_PATH . $d['photo']);
                        if (file_exists($UPLOAD_PATH . $d['photo'] . '.thumb.jpg')) {
                            unlink($UPLOAD_PATH . $d['photo'] . '.thumb.jpg');
                        }
                    }
                    $d->photo = '/user.default.jpg';
                    $d->save();
                    $ui->assign('notify_t', 's');
                    $ui->assign('notify', 'You have successfully deleted the photo');
                } else {
                    $ui->assign('notify_t', 'e');
                    $ui->assign('notify', 'No photo found to delete');
                }
            }
            $ui->assign('d', $d);
            $ui->assign('statuses', ORM::for_table('tbl_customers')->getEnum("status"));
            $ui->assign('customFields', $customFields);
            $ui->assign('xheader', $leafletpickerHeader);
            $ui->assign('csrf_token',  Csrf::generateAndStoreToken());
            $ui->display('admin/customers/edit.tpl');
        } else {
            r2(getUrl('customers/list'), 'e', Lang::T('Account Not Found'));
        }
        break;

    case 'delete':
        if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin'])) {
            _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
        }
        $id = $routes['2'];
        $csrf_token = _req('token');
        if (!Csrf::check($csrf_token)) {
            r2(getUrl('customers/view/') . $id, 'e', Lang::T('Invalid or Expired CSRF Token') . ".");
        }
        run_hook('delete_customer'); #HOOK
        if (customers_delete_customer_record($id)) {
            r2(getUrl('customers/list'), 's', Lang::T('User deleted Successfully'));
        }
        r2(getUrl('customers/list'), 'e', Lang::T('Account Not Found'));
        break;

    case 'delete-selected':
        if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin'])) {
            _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
        }
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            r2(getUrl('customers/list'), 'e', Lang::T('Invalid request'));
        }
        $csrf_token = _post('csrf_token');
        if (!Csrf::check($csrf_token)) {
            r2(getUrl('customers/list'), 'e', Lang::T('Invalid or Expired CSRF Token') . ".");
        }
        $ids = _post('customer_ids', []);
        if (!is_array($ids)) {
            $ids = [];
        }
        $ids = array_values(array_unique(array_filter(array_map('intval', $ids), function ($cid) {
            return $cid > 0;
        })));
        if (empty($ids)) {
            r2(getUrl('customers/list'), 'w', Lang::T('No_customers_selected_for_deletion'));
        }
        $deleted = 0;
        foreach ($ids as $cid) {
            run_hook('delete_customer'); #HOOK
            if (customers_delete_customer_record($cid)) {
                $deleted++;
            }
        }
        if ($deleted === 0) {
            r2(getUrl('customers/list'), 'w', Lang::T('Account Not Found'));
        }
        $msg = str_replace(':count', (string) $deleted, Lang::T('Bulk_customers_deleted'));
        r2(getUrl('customers/list'), 's', $msg);
        break;

    case 'add-post':

        $csrf_token = _post('csrf_token');
        if (!Csrf::check($csrf_token)) {
            r2(getUrl('customers/add'), 'e', Lang::T('Invalid or Expired CSRF Token') . ".");
        }
        $username = alphanumeric(_post('username'), ":+_.@-");
        $fullname = _post('fullname');
        $password = trim(_post('password'));
        $pppoe_username = trim(_post('pppoe_username'));
        $pppoe_password = trim(_post('pppoe_password'));
        $pppoe_ip = trim(_post('pppoe_ip'));
        $email = _post('email');
        $address = _post('address');
        $phonenumber = _post('phonenumber');
        $service_type = _post('service_type');
        $account_type = _post('account_type');
        //post Customers Attributes
        $custom_field_names = (array) $_POST['custom_field_name'];
        $custom_field_values = (array) $_POST['custom_field_value'];
        //additional information
        $city = _post('city');
        $district = _post('district');
        $state = _post('state');
        $zip = _post('zip');

        run_hook('add_customer'); #HOOK
        $msg = '';
        if (Validator::Length($username, 55, 2) == false) {
            $msg .= 'Username should be between 3 to 54 characters' . '<br>';
        }
        if (Validator::Length($fullname, 36, 1) == false) {
            $msg .= 'Full Name should be between 2 to 25 characters' . '<br>';
        }
        if (!Validator::Length($password, 36, 2)) {
            $msg .= 'Password should be between 3 to 35 characters' . '<br>';
        }

        $d = ORM::for_table('tbl_customers')->where('username', $username)->find_one();
        if ($d) {
            $msg .= Lang::T('Account already axist') . '<br>';
        }
        if ($msg == '') {
            $d = ORM::for_table('tbl_customers')->create();
            $d->username = $username;
            $d->password = $password;
            $d->pppoe_username = $pppoe_username;
            $d->pppoe_password = $pppoe_password;
            $d->pppoe_ip = $pppoe_ip;
            $d->email = $email;
            $d->account_type = $account_type;
            $d->fullname = $fullname;
            $d->address = $address;
            $d->created_by = $admin['id'];
            $d->phonenumber = Lang::phoneFormat($phonenumber);
            $d->service_type = $service_type;
            $d->city = $city;
            $d->district = $district;
            $d->state = $state;
            $d->zip = $zip;
            $d->save();

            // Retrieve the customer ID of the newly created customer
            $customerId = $d->id();
            // Save Customers Attributes details
            if (!empty($custom_field_names) && !empty($custom_field_values)) {
                $totalFields = min(count($custom_field_names), count($custom_field_values));
                for ($i = 0; $i < $totalFields; $i++) {
                    $name = $custom_field_names[$i];
                    $value = $custom_field_values[$i];

                    if (!empty($name)) {
                        $customField = ORM::for_table('tbl_customers_fields')->create();
                        $customField->customer_id = $customerId;
                        $customField->field_name = $name;
                        $customField->field_value = $value;
                        $customField->save();
                    }
                }
            }

            // Send welcome message
            if (isset($_POST['send_welcome_message']) && $_POST['send_welcome_message'] == true) {
                $welcomeMessage = Lang::getNotifText('welcome_message', $planToRecharge['type'] ?? null);
                $welcomeMessage = str_replace('[[company]]', $config['CompanyName'], $welcomeMessage);
                $welcomeMessage = str_replace('[[name]]', $d['fullname'], $welcomeMessage);
                $welcomeMessage = str_replace('[[username]]', $d['username'], $welcomeMessage);
                $welcomeMessage = str_replace('[[password]]', $d['password'], $welcomeMessage);
                $welcomeMessage = str_replace('[[url]]', APP_URL . '/?_route=login', $welcomeMessage);

                $emailSubject = "Welcome to " . $config['CompanyName'];

                $channels = [
                    'sms' => [
                        'enabled' => isset($_POST['sms']),
                        'callable' => ['Message', 'sendSMS'],
                        'args' => [$d['phonenumber'], $welcomeMessage]
                    ],
                    'whatsapp' => [
                        'enabled' => isset($_POST['wa']),
                        'callable' => ['Message', 'sendWhatsapp'],
                        'args' => [$d['phonenumber'], $welcomeMessage]
                    ],
                    'email' => [
                        'enabled' => isset($_POST['mail']),
                        'callable' => ['Message', 'sendEmail'],
                        'args' => [$d['email'], $emailSubject, $welcomeMessage]
                    ]
                ];

                foreach ($channels as $channel => $message) {
                    if ($message['enabled']) {
                        try {
                            call_user_func_array($message['callable'], $message['args']);
                        } catch (Throwable $e) {
                            _log("Failed to send welcome message via $channel: " . $e->getMessage());
                        }
                    }
                }
            }
            r2(getUrl('customers/list'), 's', Lang::T('Account Created Successfully'));
        } else {
            r2(getUrl('customers/add'), 'e', $msg);
        }
        break;

    case 'edit-post':
        $id = _post('id');
        $csrf_token = _post('csrf_token');
        if (!Csrf::check($csrf_token)) {
            r2(getUrl('customers/edit/') . $id, 'e', Lang::T('Invalid or Expired CSRF Token') . ".");
        }
        $username = alphanumeric(_post('username'), ":+_.@-");
        $fullname = _post('fullname');
        $account_type = _post('account_type');
        $password = trim(_post('password'));
        $pppoe_username = trim(_post('pppoe_username'));
        $pppoe_password = trim(_post('pppoe_password'));
        $pppoe_ip = trim(_post('pppoe_ip'));
        $email = _post('email');
        $address = _post('address');
        $phonenumber = Lang::phoneFormat(_post('phonenumber'));
        $service_type = _post('service_type');
        $status = _post('status');
        //additional information
        $city = _post('city');
        $district = _post('district');
        $state = _post('state');
        $zip = _post('zip');
        run_hook('edit_customer'); #HOOK
        $msg = '';
        if (Validator::Length($username, 55, 2) == false) {
            $msg .= 'Username should be between 3 to 54 characters' . '<br>';
        }
        if (Validator::Length($fullname, 36, 1) == false) {
            $msg .= 'Full Name should be between 2 to 25 characters' . '<br>';
        }

        $c = ORM::for_table('tbl_customers')->find_one($id);

        if (!$c) {
            $msg .= Lang::T('Data Not Found') . '<br>';
        }

        //lets find user Customers Attributes using id
        $customFields = ORM::for_table('tbl_customers_fields')
            ->where('customer_id', $id)
            ->find_many();

        $oldusername = $c['username'];
        $oldPppoeUsername = $c['pppoe_username'];
        $oldPppoePassword = $c['pppoe_password'];
        $oldPppoeIp = $c['pppoe_ip'];
        $oldPassPassword = $c['password'];
        $userDiff = false;
        $pppoeDiff = false;
        $passDiff = false;
        $pppoeIpDiff = false;
        if ($oldusername != $username) {
            if (ORM::for_table('tbl_customers')->where('username', $username)->find_one()) {
                $msg .= Lang::T('Username already used by another customer') . '<br>';
            }
            if (ORM::for_table('tbl_customers')->where('pppoe_username', $username)->find_one()) {
                $msg .= Lang::T('Username already used by another pppoe username customer') . '<br>';
            }
            $userDiff = true;
        }
        if ($oldPppoeUsername != $pppoe_username) {
            // if(!empty($pppoe_username)){
            //     if(ORM::for_table('tbl_customers')->where('pppoe_username', $pppoe_username)->find_one()){
            //         $msg.= Lang::T('PPPoE Username already used by another customer') . '<br>';
            //     }
            //     if(ORM::for_table('tbl_customers')->where('username', $pppoe_username)->find_one()){
            //         $msg.= Lang::T('PPPoE Username already used by another customer') . '<br>';
            //     }
            // }
            $pppoeDiff = true;
        }

        if ($oldPppoeIp != $pppoe_ip) {
            $pppoeIpDiff = true;
        }
        if ($password != '' && $oldPassPassword != $password) {
            $passDiff = true;
        }

        if ($msg == '') {
            if (!empty($_FILES['photo']['name']) && file_exists($_FILES['photo']['tmp_name'])) {
                if (function_exists('imagecreatetruecolor')) {
                    $hash = md5_file($_FILES['photo']['tmp_name']);
                    $subfolder = substr($hash, 0, 2);
                    $folder = $UPLOAD_PATH . DIRECTORY_SEPARATOR . 'photos' . DIRECTORY_SEPARATOR;
                    if (!file_exists($folder)) {
                        mkdir($folder);
                    }
                    $folder = $UPLOAD_PATH . DIRECTORY_SEPARATOR . 'photos' . DIRECTORY_SEPARATOR . $subfolder . DIRECTORY_SEPARATOR;
                    if (!file_exists($folder)) {
                        mkdir($folder);
                    }
                    $imgPath = $folder . $hash . '.jpg';
                    if (!file_exists($imgPath)) {
                        File::resizeCropImage($_FILES['photo']['tmp_name'], $imgPath, 1600, 1600, 100);
                    }
                    if (!file_exists($imgPath . '.thumb.jpg')) {
                        if (_post('faceDetect') == 'yes') {
                            try {
                                $detector = new svay\FaceDetector();
                                $detector->setTimeout(5000);
                                $detector->faceDetect($imgPath);
                                $detector->cropFaceToJpeg($imgPath . '.thumb.jpg', false);
                            } catch (Exception $e) {
                                File::makeThumb($imgPath, $imgPath . '.thumb.jpg', 200);
                            } catch (Throwable $e) {
                                File::makeThumb($imgPath, $imgPath . '.thumb.jpg', 200);
                            }
                        } else {
                            File::makeThumb($imgPath, $imgPath . '.thumb.jpg', 200);
                        }
                    }
                    if (file_exists($imgPath)) {
                        if ($c['photo'] != '' && strpos($c['photo'], 'default') === false) {
                            if (file_exists($UPLOAD_PATH . $c['photo'])) {
                                unlink($UPLOAD_PATH . $c['photo']);
                                if (file_exists($UPLOAD_PATH . $c['photo'] . '.thumb.jpg')) {
                                    unlink($UPLOAD_PATH . $c['photo'] . '.thumb.jpg');
                                }
                            }
                        }
                        $c->photo = '/photos/' . $subfolder . '/' . $hash . '.jpg';
                    }
                    if (file_exists($_FILES['photo']['tmp_name'])) unlink($_FILES['photo']['tmp_name']);
                } else {
                    r2(getUrl('settings/app'), 'e', 'PHP GD is not installed');
                }
            }
            if ($userDiff) {
                $c->username = $username;
            }
            if ($password != '') {
                $c->password = $password;
            }
            $c->pppoe_username = $pppoe_username;
            $c->pppoe_password = $pppoe_password;
            $c->pppoe_ip = $pppoe_ip;
            $c->fullname = $fullname;
            $c->email = $email;
            $c->account_type = $account_type;
            $c->address = $address;
            $c->status = $status;
            $c->phonenumber = $phonenumber;
            $c->service_type = $service_type;
            $c->city = $city;
            $c->district = $district;
            $c->state = $state;
            $c->zip = $zip;
            $c->save();


            // Update Customers Attributes values in tbl_customers_fields table
            foreach ($customFields as $customField) {
                $fieldName = $customField['field_name'];
                if (isset($_POST['custom_fields'][$fieldName])) {
                    $customFieldValue = $_POST['custom_fields'][$fieldName];
                    $customField->set('field_value', $customFieldValue);
                    $customField->save();
                }
            }

            // Custom fields functionality removed

            if ($userDiff || $pppoeDiff || $pppoeIpDiff || $passDiff) {
                $turs = ORM::for_table('tbl_user_recharges')->where('customer_id', $c['id'])->findMany();
                foreach ($turs as $tur) {
                    $p = ORM::for_table('tbl_plans')->find_one($tur['plan_id']);
                    $dvc = Package::getDevice($p);
                    if (!app_is_demo_restricted()) {
                        // if has active package
                        if ($tur['status'] == 'on') {
                            if (file_exists($dvc)) {
                                require_once $dvc;
                                if ($userDiff) {
                                    (new $p['device'])->change_username($p, $oldusername, $username);
                                }
                                if ($pppoeDiff && $tur['type'] == 'PPPOE') {
                                    if (empty($oldPppoeUsername) && !empty($pppoe_username)) {
                                        // admin just add pppoe username
                                        (new $p['device'])->change_username($p, $username, $pppoe_username);
                                    } else if (empty($pppoe_username) && !empty($oldPppoeUsername)) {
                                        // admin want to use customer username
                                        (new $p['device'])->change_username($p, $oldPppoeUsername, $username);
                                    } else {
                                        // regular change pppoe username
                                        (new $p['device'])->change_username($p, $oldPppoeUsername, $pppoe_username);
                                    }
                                }
                                (new $p['device'])->add_customer($c, $p);
                            } else {
                                new Exception(Lang::T("Devices Not Found"));
                            }
                        }
                    }
                    $tur->username = $username;
                    $tur->save();
                }
            }
            r2(getUrl('customers/view/') . $id, 's', 'User Updated Successfully');
        } else {
            r2(getUrl('customers/edit/') . $id, 'e', $msg);
        }
        break;

    default:
        run_hook('list_customers'); #HOOK
        $search = _req('search');
        $order = _req('order', 'username');
        $filter = _req('filter', 'Active');
        $orderby = _req('orderby', 'asc');
        $statuses = ORM::for_table('tbl_customers')->getEnum("status");
        if (!in_array($filter, $statuses, true)) {
            $filter = in_array('Active', $statuses, true) ? 'Active' : ($statuses[0] ?? 'Active');
        }
        $order_pos = [
            'username' => 0,
            'created_at' => 8,
            'balance' => 3,
            'status' => 7
        ];

        $append_url = "&order=" . urlencode($order) . "&filter=" . urlencode($filter) . "&orderby=" . urlencode($orderby);

        $query = ORM::for_table('tbl_customers');
        if ($search != '') {
            $like = '%' . addcslashes($search, '%_\\') . '%';
            $query->where_raw(
                '(username LIKE ? OR fullname LIKE ? OR address LIKE ? OR phonenumber LIKE ? OR email LIKE ?) AND status = ?',
                [$like, $like, $like, $like, $like, $filter]
            );
        } else {
            $query->where("status", $filter);
        }
        if ($order == 'lastname') {
            $query->order_by_expr("SUBSTR(fullname, INSTR(fullname, ' ')) $orderby");
        } else {
            if ($orderby == 'asc') {
                $query->order_by_asc($order);
            } else {
                $query->order_by_desc($order);
            }
        }
        if (_post('export', '') == 'csv') {
            $csrf_token = _post('csrf_token');
            if (!Csrf::check($csrf_token)) {
                r2(getUrl('customers'), 'e', Lang::T('Invalid or Expired CSRF Token') . ".");
            }
            $d = $query->findMany();
            $h = false;
            set_time_limit(-1);
            header('Pragma: public');
            header('Expires: 0');
            header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
            header("Content-type: text/csv");
            header('Content-Disposition: attachment;filename="phpnuxbill_customers_' . $filter . '_' . date('Y-m-d_H_i') . '.csv"');
            header('Content-Transfer-Encoding: binary');

            $headers = [
                'id',
                'username',
                'fullname',
                'address',
                'phonenumber',
                'email',
                'balance',
                'service_type',
            ];
            $fp = fopen('php://output', 'wb');
            if (!$h) {
                fputcsv($fp, $headers, ";");
                $h = true;
            }
            foreach ($d as $c) {
                $row = [
                    $c['id'],
                    $c['username'],
                    $c['fullname'],
                    str_replace("\n", " ", $c['address']),
                    $c['phonenumber'],
                    $c['email'],
                    $c['balance'],
                    $c['service_type'],
                ];
                fputcsv($fp, $row, ";");
            }
            fclose($fp);
            die();
        }
        $d = Paginator::findMany($query, ['search' => $search], 30, $append_url);
        $ui->assign('d', $d);
        $ui->assign('statuses', $statuses);
        $ui->assign('filter', $filter);
        $ui->assign('search', $search);
        $ui->assign('order', $order);
        $ui->assign('order_pos', $order_pos[$order] ?? 0);
        $ui->assign('orderby', $orderby);
        $ui->assign('csrf_token',  Csrf::generateAndStoreToken());
        $ui->display('admin/customers/list.tpl');
        break;
}