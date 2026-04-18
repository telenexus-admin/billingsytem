
<?php
/**
 * File: system/plugin/customer_usage.php
 **/

// Check if we're in the correct environment
if (!defined('PLUJS_VERSION') && !function_exists('register_menu')) {
    // Fallback for plugin system
    if (!function_exists('register_menu')) {
        function register_menu($title, $public, $route, $position, $icon, $label, $color, $roles) {
            // Fallback function
            return true;
        }
    }
}

// 1) Register the menu item
register_menu(
  "Client Usage", true, "customer_usage",
  'AFTER_SERVICES', 'ion ion-stats-bars', '', '', array('Admin','SuperAdmin')
);

// Function to create required database tables
function createUsageTables() {
    try {
        // Check if ORM is available
        if (!class_exists('ORM')) {
            return false;
        }
        
        // Check if tables exist, if not create them
        $db = ORM::get_db();
        
        // Create tbl_usage_sessions table
        $sessionTableExists = $db->query("SHOW TABLES LIKE 'tbl_usage_sessions'")->fetch();
        if (!$sessionTableExists) {
            $sessionTableSQL = "CREATE TABLE `tbl_usage_sessions` (
              `id` int(11) NOT NULL AUTO_INCREMENT,
              `router_id` int(11) NOT NULL,
              `username` varchar(64) NOT NULL,
              `interface` varchar(20) NOT NULL DEFAULT 'hotspot',
              `session_id` varchar(64) NOT NULL,
              `last_rx` bigint(20) DEFAULT 0,
              `last_tx` bigint(20) DEFAULT 0,
              `session_rx` bigint(20) DEFAULT 0,
              `session_tx` bigint(20) DEFAULT 0,
              `start_time` datetime NOT NULL,
              `ip_address` varchar(45) DEFAULT NULL COMMENT 'User IP address',
              `mac_address` varchar(17) DEFAULT NULL COMMENT 'User MAC address',
              `connection_type` varchar(20) DEFAULT 'hotspot' COMMENT 'hotspot or pppoe',
              `uptime_seconds` int DEFAULT 0 COMMENT 'Session duration in seconds',
              PRIMARY KEY (`id`),
              UNIQUE KEY `unique_session` (`router_id`,`username`,`session_id`),
              KEY `idx_router_username` (`router_id`,`username`),
              KEY `idx_ip_address` (`ip_address`),
              KEY `idx_mac_address` (`mac_address`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci";
            
            $db->exec($sessionTableSQL);
            if (function_exists('_log')) {
                _log('Created table: tbl_usage_sessions', 'System', 1);
            }
        } else {
            // Add session tracking columns if they don't exist (for existing installations)
            try {
                $columns = $db->query("SHOW COLUMNS FROM tbl_usage_sessions LIKE 'session_rx'")->fetch();
                if (!$columns) {
                    $db->exec("ALTER TABLE `tbl_usage_sessions` ADD COLUMN `session_rx` bigint(20) DEFAULT 0");
                    $db->exec("ALTER TABLE `tbl_usage_sessions` ADD COLUMN `session_tx` bigint(20) DEFAULT 0");
                    if (function_exists('_log')) {
                        _log('Added session usage tracking columns to tbl_usage_sessions', 'System', 1);
                    }
                }
                
                // Add new local session tracking columns
                $ip_column = $db->query("SHOW COLUMNS FROM tbl_usage_sessions LIKE 'ip_address'")->fetch();
                if (!$ip_column) {
                    $db->exec("ALTER TABLE `tbl_usage_sessions` ADD COLUMN `ip_address` varchar(45) DEFAULT NULL COMMENT 'User IP address'");
                    $db->exec("ALTER TABLE `tbl_usage_sessions` ADD COLUMN `mac_address` varchar(17) DEFAULT NULL COMMENT 'User MAC address'");
                    $db->exec("ALTER TABLE `tbl_usage_sessions` ADD COLUMN `connection_type` varchar(20) DEFAULT 'hotspot' COMMENT 'hotspot or pppoe'");
                    $db->exec("ALTER TABLE `tbl_usage_sessions` ADD COLUMN `uptime_seconds` int DEFAULT 0 COMMENT 'Session duration in seconds'");
                    
                    // Add indexes for better performance
                    $db->exec("ALTER TABLE `tbl_usage_sessions` ADD INDEX `idx_online_status` (`username`, `last_seen`)");
                    $db->exec("ALTER TABLE `tbl_usage_sessions` ADD INDEX `idx_ip_address` (`ip_address`)");
                    $db->exec("ALTER TABLE `tbl_usage_sessions` ADD INDEX `idx_mac_address` (`mac_address`)");
                    
                    // Update connection_type from interface column
                    $db->exec("UPDATE `tbl_usage_sessions` SET `connection_type` = `interface` WHERE `connection_type` IS NULL OR `connection_type` = 'hotspot'");
                    
                    if (function_exists('_log')) {
                        _log('Added local session tracking columns to tbl_usage_sessions', 'System', 1);
                    }
                }
            } catch (Exception $e) {
                if (function_exists('_log')) {
                    _log('Error adding session columns: ' . $e->getMessage(), 'System', 3);
                }
            }
        }
        
        // Create tbl_usage_records table
        $recordsTableExists = $db->query("SHOW TABLES LIKE 'tbl_usage_records'")->fetch();
        if (!$recordsTableExists) {
            $recordsTableSQL = "CREATE TABLE `tbl_usage_records` (
              `id` int(11) NOT NULL AUTO_INCREMENT,
              `router_id` int(11) NOT NULL,
              `username` varchar(64) NOT NULL,
              `interface` varchar(20) NOT NULL DEFAULT 'hotspot',
              `tx_bytes` bigint(20) DEFAULT 0,
              `rx_bytes` bigint(20) DEFAULT 0,
              `last_seen` datetime NOT NULL,
              `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
              `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
              PRIMARY KEY (`id`),
              UNIQUE KEY `unique_user_router` (`router_id`,`username`,`interface`),
              KEY `idx_username` (`username`),
              KEY `idx_last_seen` (`last_seen`),
              KEY `idx_router` (`router_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci";
            
            $db->exec($recordsTableSQL);
            if (function_exists('_log')) {
                _log('Created table: tbl_usage_records', 'System', 1);
            }
        }
        
        return true;
    } catch (Exception $e) {
        if (function_exists('_log')) {
            _log('Error creating usage tables: ' . $e->getMessage(), 'System', 1);
        }
        error_log('Usage Tables Error: ' . $e->getMessage());
        return false;
    }
}

// Helper function to format bytes to MB/GB
function formatBytes($bytes) {
    if (!is_numeric($bytes) || $bytes < 0) {
        return '0.00 MB';
    }
    
    $mb = $bytes / (1024 * 1024);

    if ($mb >= 1000) {
        $gb = $mb / 1024;
        return number_format($gb, 2) . ' GB';
    } else {
        return number_format($mb, 2) . ' MB';
    }
}

// Helper function to calculate session time remaining based on plan expiration
function calculateSessionTimeLeft($username) {
    try {
        if (!class_exists('ORM')) {
            return 'Unlimited';
        }
        
        // Get user's active plan (status 'on', not expired)
        $now = time();
        $active_package = ORM::for_table('tbl_user_recharges')
            ->where('username', $username)
            ->where('status', 'on')
            ->order_by_desc('recharged_on')
            ->find_one();
            
        if (!$active_package) {
            return 'No Active Plan';
        }
        
        // Calculate expiration timestamp
        $expiry_ts = strtotime($active_package['expiration'] . ' ' . $active_package['time']);
        
        if ($expiry_ts <= $now) {
            return 'Expired';
        }
        
        // Calculate time remaining
        $seconds_left = $expiry_ts - $now;
        
        if ($seconds_left <= 0) {
            return 'Expired';
        }
        
        // Format time remaining
        $days = floor($seconds_left / 86400);
        $hours = floor(($seconds_left % 86400) / 3600);
        $minutes = floor(($seconds_left % 3600) / 60);
        
        $time_parts = array();
        if ($days > 0) $time_parts[] = $days . 'd';
        if ($hours > 0) $time_parts[] = $hours . 'h';
        if ($minutes > 0) $time_parts[] = $minutes . 'm';
        
        if (empty($time_parts)) {
            return '< 1m';
        }
        
        return implode(' ', $time_parts);
        
    } catch (Exception $e) {
        if (function_exists('_log')) {
            _log('Error calculating session time left for ' . $username . ': ' . $e->getMessage(), 'System', 1);
        }
        return 'Unknown';
    }
}

// 2) Define the handler function
function customer_usage() {
    // Check if we're in admin context
    if (function_exists('_admin')) {
        _admin();            // ensure only admins
    }
    
    // Check for required globals
    global $ui, $admin;
    
    if (!isset($ui) || !is_object($ui)) {
        die('Template system not available');
    }

    // Create tables if they don't exist
    $tablesCreated = createUsageTables();
    if (!$tablesCreated && !class_exists('ORM')) {
        die('Database system not available');
    }

    $ui->assign('_title','Customer Usage');
    if (isset($admin)) {
        $ui->assign('_admin', $admin);
    }

    // Pagination parameters with validation
    $page = isset($_GET['page']) ? max(1, intval($_GET['page'])) : 1;
    $limit = isset($_GET['limit']) ? max(10, min(100, intval($_GET['limit']))) : 25;
    $offset = ($page - 1) * $limit;

// Define "active" threshold (last 1 minute for fast response)
            $threshold = date('Y-m-d H:i:s', strtotime('-1 minute'));    // Initialize default values
    $hasData = 0;
    $all_time = array();
    $active = array();
    $station_labels = array();
    $station_values = array();
    $top5_labels = array();
    $top5_values = array();
    $total_users = 0;

    // Check if usage records table has data, if not show message
    try {
        if (class_exists('ORM')) {
            $hasData = ORM::for_table('tbl_usage_records')->count();
        }
    } catch (Exception $e) {
        // Table doesn't exist yet, show empty state
        $hasData = 0;
        if (function_exists('_log')) {
            _log('Error checking usage data: ' . $e->getMessage(), 'System', 1);
        }
    }
    
    if ($hasData == 0) {
        // Show empty state
        $ui->assign('all_time', $all_time);
        $ui->assign('active', $active);
        $ui->assign('station_labels', $station_labels);
        $ui->assign('station_values', $station_values);
        $ui->assign('top5_labels', $top5_labels);
        $ui->assign('top5_values', $top5_values);
        $ui->assign('current_page', 1);
        $ui->assign('total_pages', 1);
        $ui->assign('total_users', 0);
        $ui->assign('limit', $limit);
        $ui->assign('start_record', 0);
        $ui->assign('end_record', 0);
        $ui->assign('pagination', array());
        $ui->assign('no_data', true);
        $ui->display('customer_usage.tpl');
        return;
    }

    try {
        if (class_exists('ORM')) {
            // 1) All‑time totals per user with pagination
            $all_time_query = ORM::for_table('tbl_usage_records')
                ->select_expr('username','username')
                ->select_expr('SUM(tx_bytes)','tx_total')
                ->select_expr('SUM(rx_bytes)','rx_total')
                ->group_by('username')
                ->order_by_desc('tx_total');

            // Get total count for pagination
            $total_users_result = ORM::for_table('tbl_usage_records')
                ->select_expr('COUNT(DISTINCT username)', 'count')
                ->find_one();
            $total_users = $total_users_result ? intval($total_users_result['count']) : 0;

            // Apply pagination to all-time query
            $all_time = $all_time_query
                ->limit($limit)
                ->offset($offset)
                ->find_array();

            // Format bytes for all-time data
            if (is_array($all_time)) {
                foreach ($all_time as &$user) {
                    $user['tx_total_formatted'] = formatBytes($user['tx_total']);
                    $user['rx_total_formatted'] = formatBytes($user['rx_total']);
                    $user['total_formatted'] = formatBytes($user['tx_total'] + $user['rx_total']);
                }
            }

            // 2) Active users - use 1-minute threshold for fast response
            $active = ORM::for_table('tbl_usage_sessions')->table_alias('s')
                ->where_gte('s.last_seen', date('Y-m-d H:i:s', strtotime('-1 minute')))
                ->select('s.username','username')
                ->select('s.session_rx','rx')
                ->select('s.session_tx','tx')
                ->select('s.ip_address','ip_address')
                ->select('s.mac_address','mac_address')
                ->select('s.connection_type','connection_type')
                ->select('s.start_time','start_time')
                ->select('r.name','station')
                ->join('tbl_routers','r.id = s.router_id','r')
                ->order_by_desc('s.start_time')
                ->find_array();

            // Format bytes for active users and calculate status
            if (is_array($active)) {
                foreach ($active as &$user) {
                    $user['tx_formatted'] = formatBytes(isset($user['tx']) ? $user['tx'] : 0);
                    $user['rx_formatted'] = formatBytes(isset($user['rx']) ? $user['rx'] : 0);
                    $user['total_formatted'] = formatBytes((isset($user['tx']) ? $user['tx'] : 0) + (isset($user['rx']) ? $user['rx'] : 0));

                    // Calculate uptime from start_time
                    if (isset($user['start_time'])) {
                        $start_time = strtotime($user['start_time']);
                        $now = time();
                        $uptime_seconds = $now - $start_time;
                        
                        $days = floor($uptime_seconds / 86400);
                        $hours = floor(($uptime_seconds % 86400) / 3600);
                        $minutes = floor(($uptime_seconds % 3600) / 60);
                        
                        $uptime_parts = array();
                        if ($days > 0) $uptime_parts[] = $days . 'd';
                        if ($hours > 0) $uptime_parts[] = $hours . 'h';
                        if ($minutes > 0) $uptime_parts[] = $minutes . 'm';
                        
                        $user['uptime'] = empty($uptime_parts) ? '< 1m' : implode(' ', $uptime_parts);
                    } else {
                        $user['uptime'] = 'Unknown';
                    }
                    
                    // Calculate session time remaining based on plan expiration
                    $user['session_time_left'] = calculateSessionTimeLeft($user['username']);

                    // Online status: if user has session record, they are online
                    $user['status'] = 'online';
                    
                    // Format session details
                    $user['ip_address'] = $user['ip_address'] ?: 'Unknown';
                    $user['mac_address'] = $user['mac_address'] ?: 'Unknown';
                    $user['connection_type'] = ucfirst($user['connection_type'] ?: 'hotspot');
                }
            }

            // 3) Analytics: count of active users per station
            $station_counts = array();
            if (is_array($active)) {
                foreach ($active as $row) {
                    $station_name = isset($row['station']) && !empty($row['station']) ? $row['station'] : 'Unknown';
                    $station_counts[$station_name] = isset($station_counts[$station_name]) ? $station_counts[$station_name] + 1 : 1;
                }
            }
            $station_labels = array_keys($station_counts);
            $station_values = array_values($station_counts);

            // 4) Analytics: top 5 all‑time uploaders (separate query for charts)
            $top5 = ORM::for_table('tbl_usage_records')
                ->select_expr('username','username')
                ->select_expr('SUM(tx_bytes)','tx_total')
                ->group_by('username')
                ->order_by_desc('tx_total')
                ->limit(5)
                ->find_array();

            if (is_array($top5)) {
                $top5_labels = array_column($top5, 'username');
                $top5_values = array_column($top5, 'tx_total');
            }
        }

    } catch (Exception $e) {
        // Handle database errors gracefully
        $all_time = array();
        $active = array();
        $station_labels = array();
        $station_values = array();
        $top5_labels = array();
        $top5_values = array();
        $total_users = 0;
        
        if (function_exists('_log')) {
            _log('Error querying usage data: ' . $e->getMessage(), 'System', 1);
        }
        error_log('Customer Usage Query Error: ' . $e->getMessage());
    }

    // Calculate pagination info
    $total_pages = $total_users > 0 ? ceil($total_users / $limit) : 1;
    $start_record = $offset + 1;
    $end_record = min($offset + $limit, $total_users);

    // Pagination URLs
    $pagination = array();
    $base_url = '?route=plugin/customer_usage';

    // Previous page
    if ($page > 1) {
        $pagination['prev'] = $base_url . '&page=' . ($page - 1) . '&limit=' . $limit;
    }

    // Next page
    if ($page < $total_pages) {
        $pagination['next'] = $base_url . '&page=' . ($page + 1) . '&limit=' . $limit;
    }

    // Page numbers (show 5 pages around current)
    $start_page = max(1, $page - 2);
    $end_page = min($total_pages, $page + 2);

    $pagination['pages'] = array();
    for ($i = $start_page; $i <= $end_page; $i++) {
        $pagination['pages'][] = array(
            'number' => $i,
            'url' => $base_url . '&page=' . $i . '&limit=' . $limit,
            'current' => ($i == $page)
        );
    }

    // Pass data to Smarty template
    $ui->assign('all_time',       $all_time);
    $ui->assign('active',         $active);
    $ui->assign('station_labels', $station_labels);
    $ui->assign('station_values', $station_values);
    $ui->assign('top5_labels',    $top5_labels);
    $ui->assign('top5_values',    $top5_values);

    // Pagination data
    $ui->assign('current_page',   $page);
    $ui->assign('total_pages',    $total_pages);
    $ui->assign('total_users',    $total_users);
    $ui->assign('limit',          $limit);
    $ui->assign('start_record',   $start_record);
    $ui->assign('end_record',     $end_record);
    $ui->assign('pagination',     $pagination);
    $ui->assign('no_data',        ($hasData == 0));

    // Render template
    try {
        $ui->display('customer_usage.tpl');
    } catch (Exception $e) {
        echo '<div class="alert alert-danger">Template Error: ' . htmlspecialchars($e->getMessage()) . '</div>';
        if (function_exists('_log')) {
            _log('Template error in customer_usage: ' . $e->getMessage(), 'System', 1);
        }
    }
}



