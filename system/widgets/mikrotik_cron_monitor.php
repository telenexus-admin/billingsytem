<?php

class mikrotik_cron_monitor
{
    private static $offlineTimeColumnEnsured = false;

    /**
     * Widget expects tbl_routers.offline_time (see system/updates.json); older DBs may lack it.
     */
    private function ensureOfflineTimeColumn()
    {
        if (self::$offlineTimeColumnEnsured) {
            return;
        }
        self::$offlineTimeColumnEnsured = true;
        try {
            $col = ORM::for_table('tbl_routers')
                ->raw_query("SHOW COLUMNS FROM tbl_routers LIKE 'offline_time'")
                ->find_one();
            if (!$col) {
                ORM::for_table('tbl_routers')->raw_execute(
                    'ALTER TABLE `tbl_routers` ADD COLUMN `offline_time` DATETIME NULL DEFAULT NULL AFTER `last_seen`'
                );
            }
        } catch (Throwable $e) {
            error_log('mikrotik_cron_monitor: ensure offline_time column: ' . $e->getMessage());
        }
    }

    public function getWidget()
    {
        global $config, $ui;

        $this->ensureOfflineTimeColumn();

        if ($config['router_check']) {
            // Check for router status changes first
            $this->checkRouterStatusChanges();
            
            // Get offline routers for display
            $routeroffs = ORM::for_table('tbl_routers')
                ->select_many(['id', 'name', 'last_seen', 'status', 'ip_address', 'offline_time'])
                ->where('status', 'Offline')
                ->where('enabled', '1')
                ->order_by_desc('name')
                ->find_array();
            
            $ui->assign('routeroffs', $routeroffs);
        }

        return $ui->fetch('widget/mikrotik_cron_monitor.tpl');
    }
    
    private function checkRouterStatusChanges()
    {
        global $config;
        
        // Get all enabled routers
        $routers = ORM::for_table('tbl_routers')
            ->where('enabled', '1')
            ->find_many();
        
        if (!$routers) {
            return;
        }

        $offlineRouters = [];
        $onlineRouters = [];
        $errors = [];

        foreach ($routers as $router) {
            $previous_status = $router->status;
            $previous_last_seen = $router->last_seen;
            $offline_time = $router->offline_time; // Get stored offline time
            
            // Check current status
            $current_status = $this->checkRouterStatus($router);
            $current_time = date('Y-m-d H:i:s');
            
            if ($previous_status != $current_status) {
                // Status changed
                if ($current_status == 'Offline') {
                    // Store offline time
                    $router->offline_time = $current_time;
                    $router->save();
                    $offlineRouters[] = $router;
                    $this->logEvent("Router {$router->name} went OFFLINE at " . $current_time);
                } else if ($current_status == 'Online') {
                    // Calculate downtime
                    $downtime = $this->calculateDowntime($router->offline_time, $current_time);
                    $onlineRouters[] = [
                        'router' => $router,
                        'downtime' => $downtime,
                        'offline_start' => $router->offline_time
                    ];
                    $this->logEvent("Router {$router->name} came ONLINE at " . $current_time . " Downtime: $downtime");
                    
                    // Clear offline time
                    $router->offline_time = null;
                    $router->save();
                }
                
                // Update router status in database
                $router->status = $current_status;
                if ($current_status == 'Online') {
                    $router->last_seen = $current_time;
                }
                $router->save();
            } else if ($current_status == 'Online') {
                // Update last seen for online routers
                $router->last_seen = $current_time;
                $router->save();
            } else if ($current_status == 'Offline') {
                // If router is still offline and we have no offline_time, set it now
                if (empty($router->offline_time)) {
                    $router->offline_time = $current_time;
                    $router->save();
                    $this->logEvent("Router {$router->name} is OFFLINE (recorded offline time)");
                }
            }
        }
        
        // Log status changes only; SMS is sent from system/cron.php to avoid duplicates and ensure sendSms is defined.
        $this->sendStatusNotifications($offlineRouters, $onlineRouters);
    }
    
    private function calculateDowntime($offline_time, $online_time)
    {
        if (empty($offline_time)) {
            return "0s (immediate recovery)";
        }
        
        $offline = strtotime($offline_time);
        $online = strtotime($online_time);
        $diff = $online - $offline;
        
        if ($diff < 0) {
            return "0s (immediate recovery)";
        }
        
        if ($diff == 0) {
            return "0s (immediate recovery)";
        }
        
        $days = floor($diff / 86400);
        $hours = floor(($diff % 86400) / 3600);
        $minutes = floor(($diff % 3600) / 60);
        $seconds = $diff % 60;
        
        $parts = [];
        if ($days > 0) $parts[] = "{$days}d";
        if ($hours > 0) $parts[] = "{$hours}h";
        if ($minutes > 0) $parts[] = "{$minutes}m";
        if ($seconds > 0) $parts[] = "{$seconds}s";
        
        // If all parts are empty (shouldn't happen), show 0s
        if (empty($parts)) {
            return "0s";
        }
        
        return implode(", ", $parts);
    }
    
    private function checkRouterStatus($router)
    {
        $ip_address = $router->ip_address;
        $port = 8728; // Default MikroTik API port
        
        // Check if port is specified in IP address
        if (strpos($ip_address, ':') !== false) {
            list($ip_address, $port) = explode(':', $ip_address);
        }
        
        try {
            $timeout = 5;
            
            // Try fsockopen first
            if (function_exists('fsockopen')) {
                $fsock = @fsockopen($ip_address, $port, $errno, $errstr, $timeout);
                if ($fsock) {
                    fclose($fsock);
                    return 'Online';
                }
            }
            
            // Try stream_socket_client as fallback
            if (function_exists('stream_socket_client')) {
                $connection = @stream_socket_client(
                    "$ip_address:$port", 
                    $errno, 
                    $errstr, 
                    $timeout
                );
                if ($connection) {
                    fclose($connection);
                    return 'Online';
                }
            }
            
            // If both methods fail, try a simple ping as last resort
            $ping = @exec("ping -c 1 -W 1 " . escapeshellarg($ip_address) . " 2>&1", $output, $return_var);
            if ($return_var === 0) {
                return 'Online';
            }
            
        } catch (Exception $e) {
            $this->logEvent("Error checking router {$router->name}: " . $e->getMessage());
        }
        
        return 'Offline';
    }
    
    private function sendStatusNotifications($offlineRouters, $onlineRouters)
    {
        global $config;
        
        // Log offline transitions (SMS: see cron.php router_check when cron runs)
        if (!empty($offlineRouters)) {
            foreach ($offlineRouters as $router) {
                $timestamp = date('Y-m-d H:i:s');
                $message = "[{$router->name}] Router {$router->name} ({$router->ip_address}) is OFFLINE at {$timestamp}.";

                $this->logMessage('Router Alert', $message, 'Offline');
                
                // Also log to console if running via CLI
                if (php_sapi_name() === 'cli') {
                    echo "{$message}\n";
                }
            }
        }
        
        // Log online transitions (SMS: see cron.php router_check when cron runs)
        if (!empty($onlineRouters)) {
            foreach ($onlineRouters as $data) {
                $router = $data['router'];
                $downtime = $data['downtime'];
                $timestamp = date('Y-m-d H:i:s');
                $message = "[{$router->name}] Router {$router->name} ({$router->ip_address}) is ONLINE at {$timestamp}. Downtime: {$downtime}.";

                $this->logMessage('Router Alert', $message, 'Online');
                
                // Also log to console if running via CLI
                if (php_sapi_name() === 'cli') {
                    echo "{$message}\n";
                }
            }
        }
    }
    
    private function logMessage($type, $message, $status = 'Info')
    {
        try {
            $log = ORM::for_table('tbl_message_logs')->create();
            $log->message_type = $type;
            $log->recipient = 'System';
            $log->message_content = $message;
            $log->status = $status;
            $log->sent_at = date('Y-m-d H:i:s');
            $log->save();
        } catch (Exception $e) {
            // Silently fail if logging fails
        }
    }
    
    private function logEvent($message)
    {
        try {
            // Try to log to tbl_logs if available
            if (class_exists('ORM')) {
                // Check if tbl_logs table exists and has required columns
                $log = ORM::for_table('tbl_logs')->create();
                $log->date = date('Y-m-d H:i:s');
                $log->type = 'Router Monitor';
                $log->description = $message;
                $log->userid = 0;
                $log->ip = 'CLI';
                $log->save();
            }
        } catch (Exception $e) {
            // If logging fails, just echo for CLI
            if (php_sapi_name() === 'cli') {
                echo date('Y-m-d H:i:s') . " - $message\n";
            }
        }
    }
}