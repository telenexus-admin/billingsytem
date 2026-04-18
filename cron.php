does it work for production  wher to find this <?php

include __DIR__ . "/../init.php";

// Better lock file handling with PID tracking - using dynamic path
$lockFile = $CACHE_PATH . "/router_monitor.lock";
$pidFile = $CACHE_PATH . "/router_monitor.pid";

// Ensure cache directory exists
if (!is_dir($CACHE_PATH)) {
    mkdir($CACHE_PATH, 0755, true);
    if (function_exists('chown')) {
        chown($CACHE_PATH, "www-data");
    }
}

// Check for stale processes using PID file
if (file_exists($pidFile)) {
    $oldPid = file_get_contents($pidFile);
    if (function_exists('posix_kill') && posix_kill((int)$oldPid, 0)) {
        // Process is still running
        echo "Process with PID $oldPid is still running. Exiting...\n";
        exit;
    } else {
        // Stale PID file - process is dead
        echo "Removing stale PID file (process $oldPid is not running)\n";
        @unlink($pidFile);
    }
}

// Check for stale lock file (older than 5 minutes)
if (file_exists($lockFile) && (time() - filemtime($lockFile)) > 300) {
    echo "Removing stale lock file (older than 5 minutes)\n";
    @unlink($lockFile);
}

// Write current PID
file_put_contents($pidFile, getmypid());

// Try to acquire lock
$lock = fopen($lockFile, 'c');

if ($lock === false) {
    echo "Failed to open lock file. Exiting...\n";
    @unlink($pidFile);
    exit;
}

if (!flock($lock, LOCK_EX | LOCK_NB)) {
    echo "Script is already running (lock held). Exiting...\n";
    fclose($lock);
    @unlink($pidFile);
    exit;
}

// Register shutdown function to clean up
register_shutdown_function(function() use ($lock, $lockFile, $pidFile) {
    if (is_resource($lock)) {
        flock($lock, LOCK_UN);
        fclose($lock);
    }
    if (file_exists($lockFile)) {
        @unlink($lockFile);
    }
    if (file_exists($pidFile)) {
        @unlink($pidFile);
    }
    echo "Lock and PID files cleaned up.\n";
});

$isCli = true;
if (php_sapi_name() !== 'cli') {
    $isCli = false;
    echo "<pre>";
}
echo "PHP Time\t" . date('Y-m-d H:i:s') . "\n";
$res = ORM::raw_execute('SELECT NOW() AS WAKTU;');
$statement = ORM::get_last_statement();
$rows = [];
while ($row = $statement->fetch(PDO::FETCH_ASSOC)) {
    echo "MYSQL Time\t" . $row['WAKTU'] . "\n";
}

$_c = $config;

// Helper function to remove all hotspot cookies for a specific username on a given router client
if (!function_exists('removeHotspotCookies')) {
    function removeHotspotCookies($client, $username) {
        try {
            $cookieRequest = new PEAR2\Net\RouterOS\Request('/ip/hotspot/cookie/print');
            $cookies = $client->sendSync($cookieRequest);
            $removed = 0;
            foreach ($cookies as $cookie) {
                if ($cookie->getProperty('user') == $username) {
                    $removeCookie = new PEAR2\Net\RouterOS\Request('/ip/hotspot/cookie/remove');
                    $removeCookie->setArgument('numbers', $cookie->getProperty('.id'));
                    $client->sendSync($removeCookie);
                    $removed++;
                }
            }
            if ($removed > 0) {
                echo "? Removed $removed hotspot cookie(s) for $username\n";
            }
            return $removed;
        } catch (Exception $e) {
            echo "? Failed to remove cookies for $username: " . $e->getMessage() . "\n";
            return 0;
        }
    }
}

if (!function_exists('getAdminPhoneNumbers')) {
    function getAdminPhoneNumbers()
    {
        $phones = [];

        $admins = ORM::for_table('tbl_users')
            ->where('user_type', 'SuperAdmin')
            ->where('status', 'Active')
            ->find_many();

        foreach ($admins as $admin) {
            if (!empty($admin->phone)) {
                $phone = $admin->phone;
                if (strlen($phone) == 9) {
                    $phone = '254' . $phone;
                } elseif (strlen($phone) == 10 && $phone[0] == '0') {
                    $phone = '254' . substr($phone, 1);
                }
                $phones[] = $phone;
            }
        }

        $adminPhone = ORM::for_table('tbl_appconfig')
            ->where('setting', 'admin_phone')
            ->find_one();

        if ($adminPhone && !empty($adminPhone->value)) {
            $phone = $adminPhone->value;
            if (strlen($phone) == 9) {
                $phone = '254' . $phone;
            } elseif (strlen($phone) == 10 && $phone[0] == '0') {
                $phone = '254' . substr($phone, 1);
            }
            $phones[] = $phone;
        }

        return array_values(array_unique($phones));
    }
}

if (!function_exists('sendSms')) {
    function sendSms($phone, $message)
    {
        try {
            global $config;

            if (isset($config['sms_gateway_type']) && $config['sms_gateway_type'] == 'url' && !empty($config['sms_url'])) {
                $cleanMessage = preg_replace('/[^\x20-\x7E]/', '', $message);
                $cleanMessage = trim($cleanMessage);
                $cleanMessage = substr($cleanMessage, 0, 160);

                $smsUrl = str_replace('[number]', urlencode($phone), $config['sms_url']);
                $smsUrl = str_replace('[text]', urlencode($cleanMessage), $smsUrl);

                $ch = curl_init();
                curl_setopt($ch, CURLOPT_URL, $smsUrl);
                curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
                curl_setopt($ch, CURLOPT_TIMEOUT, 30);
                $response = curl_exec($ch);
                $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
                curl_close($ch);

                $trimmedResponse = trim($response);
                $isSuccess = ($httpCode == 200 && strpos($trimmedResponse, 'OK') === 0);

                $log = ORM::for_table('tbl_message_logs')->create();
                $log->message_type = 'Router Alert SMS';
                $log->recipient = $phone;
                $log->message_content = $cleanMessage;
                $log->status = $isSuccess ? 'Success' : 'Error';
                $log->error_message = $response;
                $log->sent_at = date('Y-m-d H:i:s');
                $log->save();

                return $isSuccess;
            }

            return false;
        } catch (Exception $e) {
            $log = ORM::for_table('tbl_message_logs')->create();
            $log->message_type = 'Router Alert SMS Error';
            $log->recipient = $phone;
            $log->message_content = $message;
            $log->status = 'Error';
            $log->error_message = $e->getMessage();
            $log->sent_at = date('Y-m-d H:i:s');
            $log->save();

            return false;
        }
    }
}

$textExpired = Lang::getNotifText('expired');

echo "Checking expirations up to: " . date("Y-m-d H:i:s") . "\n";
$d = ORM::for_table('tbl_user_recharges')
    ->where('status', 'on')
    // Compare full expiration datetime to avoid any early disconnections.
    ->where_raw(
        "STR_TO_DATE(CONCAT(`expiration`, ' ', IFNULL(`time`, '00:00:00')), '%Y-%m-%d %H:%i:%s') <= ?",
        [date("Y-m-d H:i:s")]
    )
    ->find_many();
echo "Found " . count($d) . " expired user(s)\n";

// Check for users on router with no active recharge (orphaned users)
$router = ORM::for_table('tbl_routers')->where('enabled', '1')->find_one();
if ($router) {
    try {
        $client = Mikrotik::getClient($router['ip_address'], $router['username'], $router['password']);
        
        // Check HOTSPOT active users
        $hotspotActive = $client->sendSync(new PEAR2\Net\RouterOS\Request('/ip/hotspot/active/print'));
        
        foreach ($hotspotActive as $activeUser) {
            $activeUsername = $activeUser->getProperty('user');
            $activeRecharge = ORM::for_table('tbl_user_recharges')
                ->where('username', $activeUsername)
                ->where('status', 'on')
                ->find_one();
            
            if (!$activeRecharge && !empty($activeUsername)) {
                // Only force disconnect if latest known package is actually expired.
                $latestRecharge = ORM::for_table('tbl_user_recharges')
                    ->where('username', $activeUsername)
                    ->order_by_desc('id')
                    ->find_one();
                if ($latestRecharge) {
                    $latestExpiryTs = strtotime(trim(($latestRecharge['expiration'] ?? '') . ' ' . ($latestRecharge['time'] ?? '00:00:00')));
                    if ($latestExpiryTs !== false && time() < $latestExpiryTs) {
                        echo "?? Hotspot user $activeUsername has future expiry; skip disconnect\n";
                        continue;
                    }
                }
                echo "?? Hotspot user $activeUsername is on router but has no active recharge! Forcing disconnect...\n";
                try {
                    $removeRequest = new PEAR2\Net\RouterOS\Request('/ip/hotspot/active/remove');
                    $removeRequest->setArgument('numbers', $activeUser->getProperty('.id'));
                    $client->sendSync($removeRequest);
                    
                    // Also remove from host table
                    $hostRequest = new PEAR2\Net\RouterOS\Request('/ip/hotspot/host/print');
                    $hosts = $client->sendSync($hostRequest);
                    foreach ($hosts as $host) {
                        if ($host->getProperty('user') == $activeUsername) {
                            $removeHost = new PEAR2\Net\RouterOS\Request('/ip/hotspot/host/remove');
                            $removeHost->setArgument('numbers', $host->getProperty('.id'));
                            $client->sendSync($removeHost);
                            echo "? Cleared host entry for $activeUsername\n";
                        }
                    }
                    
                    // FIX: Remove hotspot cookies so user is redirected to sign-in page immediately
                    removeHotspotCookies($client, $activeUsername);
                    
                    echo "? Force disconnected hotspot user $activeUsername and cleared host entry and cookies\n";
                } catch (Exception $e) {
                    echo "? Failed to force disconnect $activeUsername: " . $e->getMessage() . "\n";
                }
            }
        }
        
        // Check PPPoE active users (unchanged)
        $pppActive = $client->sendSync(new PEAR2\Net\RouterOS\Request('/ppp/active/print'));
        
        foreach ($pppActive as $activePPPUser) {
            $activeUsername = $activePPPUser->getProperty('name');
            $activeRecharge = ORM::for_table('tbl_user_recharges')
                ->where('username', $activeUsername)
                ->where('status', 'on')
                ->find_one();
            
            if (!$activeRecharge && !empty($activeUsername)) {
                // Only force disconnect if latest known package is actually expired.
                $latestRecharge = ORM::for_table('tbl_user_recharges')
                    ->where('username', $activeUsername)
                    ->order_by_desc('id')
                    ->find_one();
                if ($latestRecharge) {
                    $latestExpiryTs = strtotime(trim(($latestRecharge['expiration'] ?? '') . ' ' . ($latestRecharge['time'] ?? '00:00:00')));
                    if ($latestExpiryTs !== false && time() < $latestExpiryTs) {
                        echo "?? PPPoE user $activeUsername has future expiry; skip disconnect\n";
                        continue;
                    }
                }
                echo "?? PPPoE user $activeUsername is on router but has no active recharge! Forcing disconnect...\n";
                try {
                    $removeRequest = new PEAR2\Net\RouterOS\Request('/ppp/active/remove');
                    $removeRequest->setArgument('numbers', $activePPPUser->getProperty('.id'));
                    $client->sendSync($removeRequest);
                    echo "? Force disconnected PPPoE user $activeUsername\n";
                    
                    // Also disable the PPPoE secret temporarily to prevent reconnection
                    $secretRequest = new PEAR2\Net\RouterOS\Request('/ppp/secret/print');
                    $secretRequest->setArgument('?name', $activeUsername);
                    $secrets = $client->sendSync($secretRequest);
                    
                    foreach ($secrets as $secret) {
                        $disableSecret = new PEAR2\Net\RouterOS\Request('/ppp/secret/disable');
                        $disableSecret->setArgument('numbers', $secret->getProperty('.id'));
                        $client->sendSync($disableSecret);
                        echo "? Disabled PPPoE secret for $activeUsername\n";
                    }
                } catch (Exception $e) {
                    echo "? Failed to force disconnect PPPoE user $activeUsername: " . $e->getMessage() . "\n";
                }
            }
        }
    } catch (Exception $e) {
        echo "Router check for orphaned connections failed: " . $e->getMessage() . "\n";
    }
}

run_hook('cronjob'); #HOOK

// === NEW: SYNC PPPoE USERS FROM DATABASE TO MIKROTIK ===
echo "\n=== Starting PPPoE User Sync ===\n";

function syncPPPoEUsersToMikrotik() {
    try {
        // Get all active PPPoE users from database
        $pppoeUsers = ORM::for_table('tbl_customers')
            ->where('service_type', 'PPPoE')
            ->where('status', 'Active')
            ->where_not_equal('pppoe_username', '')
            ->find_many();
        
        echo "Found " . count($pppoeUsers) . " active PPPoE users in database\n";
        
        // Group users by router
        $usersByRouter = [];
        foreach ($pppoeUsers as $user) {
            if (!empty($user->router_id)) {
                $routerIds = explode(',', $user->router_id);
                foreach ($routerIds as $rid) {
                    $usersByRouter[$rid][] = $user;
                }
            }
        }
        
        // Get all enabled routers
        $routers = ORM::for_table('tbl_routers')
            ->where('enabled', '1')
            ->find_many();
        
        foreach ($routers as $router) {
            echo "\n-- Syncing router: {$router->name} ({$router->ip_address}) --\n";
            
            if (!isset($usersByRouter[$router->id])) {
                echo "No PPPoE users assigned to this router\n";
                continue;
            }
            
            try {
                $client = Mikrotik::getClient($router->ip_address, $router->username, $router->password);
                
                // Get existing PPP secrets from MikroTik
                $existingSecrets = [];
                $secrets = $client->sendSync(new PEAR2\Net\RouterOS\Request('/ppp/secret/print'));
                foreach ($secrets as $secret) {
                    $name = $secret->getProperty('name');
                    if ($name) {
                        $existingSecrets[$name] = $secret;
                    }
                }
                
                echo "Found " . count($existingSecrets) . " existing PPP secrets on router\n";
                
                // Get pool information
                $pools = [];
                $poolList = $client->sendSync(new PEAR2\Net\RouterOS\Request('/ip/pool/print'));
                foreach ($poolList as $pool) {
                    $pools[$pool->getProperty('name')] = $pool;
                }
                
                // Sync each user
                foreach ($usersByRouter[$router->id] as $user) {
                    $pppoeUser = $user->pppoe_username;
                    $pppoePass = $user->pppoe_password;
                    
                    echo "  Processing: {$pppoeUser}... ";
                    
                    // Get user's active plan for pool assignment
                    $activePlan = ORM::for_table('tbl_user_recharges')
                        ->where('username', $user->username)
                        ->where('status', 'on')
                        ->where('type', 'PPPOE')
                        ->find_one();
                    
                    $poolName = null;
                    if ($activePlan) {
                        $plan = ORM::for_table('tbl_plans')->find_one($activePlan->plan_id);
                        if ($plan && !empty($plan->pool)) {
                            $poolName = $plan->pool;
                        }
                    }
                    
                    if (isset($existingSecrets[$pppoeUser])) {
                        // Update existing user if password changed
                        $secret = $existingSecrets[$pppoeUser];
                        $currentPass = $secret->getProperty('password');
                        
                        if ($currentPass != $pppoePass) {
                            $updateReq = new PEAR2\Net\RouterOS\Request('/ppp/secret/set');
                            $updateReq->setArgument('numbers', $secret->getProperty('.id'));
                            $updateReq->setArgument('password', $pppoePass);
                            if ($poolName) {
                                $updateReq->setArgument('remote-address', $poolName);
                            }
                            $client->sendSync($updateReq);
                            echo "UPDATED password\n";
                        } else {
                            echo "OK (exists)\n";
                        }
                        
                        // Ensure user is enabled
                        if ($secret->getProperty('disabled') == 'true') {
                            $enableReq = new PEAR2\Net\RouterOS\Request('/ppp/secret/enable');
                            $enableReq->setArgument('numbers', $secret->getProperty('.id'));
                            $client->sendSync($enableReq);
                            echo "  ? Enabled user\n";
                        }
                    } else {
                        // Create new user
                        $addReq = new PEAR2\Net\RouterOS\Request('/ppp/secret/add');
                        $addReq->setArgument('name', $pppoeUser);
                        $addReq->setArgument('password', $pppoePass);
                        $addReq->setArgument('service', 'pppoe');
                        $addReq->setArgument('profile', 'default');
                        
                        if ($poolName && isset($pools[$poolName])) {
                            $addReq->setArgument('remote-address', $poolName);
                        }
                        
                        $client->sendSync($addReq);
                        echo "CREATED\n";
                    }
                }
                
                // Check for orphaned PPP secrets (users in MikroTik but not in database)
                $dbUsernames = array_map(function($u) { return $u->pppoe_username; }, $usersByRouter[$router->id]);
                
                foreach ($existingSecrets as $name => $secret) {
                    // Skip system users
                    if (in_array($name, ['admin', 'api', 'test'])) {
                        continue;
                    }
                    
                    if (!in_array($name, $dbUsernames)) {
                        // Check if this user has any active sessions
                        $activeCheck = $client->sendSync(new PEAR2\Net\RouterOS\Request('/ppp/active/print'));
                        $hasActive = false;
                        foreach ($activeCheck as $active) {
                            if ($active->getProperty('name') == $name) {
                                $hasActive = true;
                                break;
                            }
                        }
                        
                        if (!$hasActive) {
                            echo "  Removing orphaned PPP secret: {$name}\n";
                            $removeReq = new PEAR2\Net\RouterOS\Request('/ppp/secret/remove');
                            $removeReq->setArgument('numbers', $secret->getProperty('.id'));
                            $client->sendSync($removeReq);
                        } else {
                            echo "  Warning: Orphaned user {$name} has active session - not removing\n";
                        }
                    }
                }
                
            } catch (Exception $e) {
                echo "ERROR syncing router {$router->name}: " . $e->getMessage() . "\n";
            }
        }
        
        echo "=== PPPoE User Sync Completed ===\n";
        
    } catch (Exception $e) {
        echo "PPP Sync Error: " . $e->getMessage() . "\n";
    }
}

// Run PPPoE sync (can be commented out if not needed every run)
// Run it every 5th execution to reduce load
$syncCounter = $CACHE_PATH . "/pppoe_sync_counter.txt";
$runSync = true;
if (file_exists($syncCounter)) {
    $counter = intval(file_get_contents($syncCounter));
    if ($counter < 5) {
        $runSync = false;
        file_put_contents($syncCounter, $counter + 1);
    } else {
        file_put_contents($syncCounter, 1);
    }
} else {
    file_put_contents($syncCounter, 1);
}

if ($runSync) {
    syncPPPoEUsersToMikrotik();
} else {
    echo "Skipping full PPPoE sync (running every 5th cron execution)\n";
}
// === END PPPoE SYNC ===

// === MIKROTIK USAGE MONITORING ===
echo "=== Starting MikroTik Usage Monitor ===\n";

function createUsageTablesIfNeeded() {
    try {
        $db = ORM::get_db();
        
        $sessionTableExists = $db->query("SHOW TABLES LIKE 'tbl_usage_sessions'")->fetch();
        if (!$sessionTableExists) {
            $sessionTableSQL = "CREATE TABLE `tbl_usage_sessions` (
              `id` int(11) NOT NULL AUTO_INCREMENT,
              `router_id` int(11) NOT NULL,
              `username` varchar(64) NOT NULL,
              `interface` varchar(20) NOT NULL DEFAULT 'hotspot',
              `session_id` varchar(64) NOT NULL,
              `ip_address` varchar(45) DEFAULT NULL,
              `mac_address` varchar(17) DEFAULT NULL,
              `last_rx` bigint(20) DEFAULT 0,
              `last_tx` bigint(20) DEFAULT 0,
              `session_rx` bigint(20) DEFAULT 0,
              `session_tx` bigint(20) DEFAULT 0,
              `start_time` datetime NOT NULL,
              `last_seen` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
              PRIMARY KEY (`id`),
              UNIQUE KEY `unique_session` (`router_id`,`username`,`session_id`),
              KEY `idx_router_username` (`router_id`,`username`),
              KEY `idx_last_seen` (`last_seen`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci";
            
            $db->exec($sessionTableSQL);
            echo "Created table: tbl_usage_sessions\n";
        }
        
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
            echo "Created table: tbl_usage_records\n";
        }
        
        return true;
    } catch (Exception $e) {
        echo "Error creating usage tables: " . $e->getMessage() . "\n";
        return false;
    }
}

function formatUsageBytes($bytes, $precision = 2) {
    $units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
    $bytes = max($bytes, 0);
    $pow = floor(($bytes ? log($bytes) : 0) / log(1024));
    $pow = min($pow, count($units) - 1);
    $bytes /= pow(1024, $pow);
    return round($bytes, $precision) . ' ' . $units[$pow];
}

function processUserSession($router_id, $username, $interface, $session_id, $current_rx, $current_tx, $now, $ip_address = null, $mac_address = null) {
    try {
        $session = ORM::for_table('tbl_usage_sessions')
            ->where('router_id', $router_id)
            ->where('username', $username)
            ->where('session_id', $session_id)
            ->find_one();

        $inc_rx = 0;
        $inc_tx = 0;

        if ($session) {
            $inc_rx = max(0, $current_rx - $session->last_rx);
            $inc_tx = max(0, $current_tx - $session->last_tx);

            $session->last_rx = $current_rx;
            $session->last_tx = $current_tx;
            $session->session_rx += $inc_rx;
            $session->session_tx += $inc_tx;
            $session->last_seen = $now;
            
            if ($ip_address !== null && filter_var($ip_address, FILTER_VALIDATE_IP)) {
                $session->ip_address = $ip_address;
            }
            if ($mac_address !== null && preg_match('/^[0-9A-Fa-f]{2}[:-][0-9A-Fa-f]{2}[:-][0-9A-Fa-f]{2}[:-][0-9A-Fa-f]{2}[:-][0-9A-Fa-f]{2}[:-][0-9A-Fa-f]{2}$/', $mac_address)) {
                $session->mac_address = strtoupper($mac_address);
            }
            $session->save();

            echo "    SESSION UPDATE: {$username} | +RX: " . formatUsageBytes($inc_rx) . " +TX: " . formatUsageBytes($inc_tx) . "\n";
        } else {
            $inc_rx = $current_rx;
            $inc_tx = $current_tx;
            
            $session = ORM::for_table('tbl_usage_sessions')->create();
            $session->router_id = $router_id;
            $session->username = $username;
            $session->interface = $interface;
            $session->session_id = $session_id;
            
            if ($ip_address !== null && filter_var($ip_address, FILTER_VALIDATE_IP)) {
                $session->ip_address = $ip_address;
            }
            if ($mac_address !== null && preg_match('/^[0-9A-Fa-f]{2}[:-][0-9A-Fa-f]{2}[:-][0-9A-Fa-f]{2}[:-][0-9A-Fa-f]{2}[:-][0-9A-Fa-f]{2}[:-][0-9A-Fa-f]{2}$/', $mac_address)) {
                $session->mac_address = strtoupper($mac_address);
            }
            $session->last_rx = $current_rx;
            $session->last_tx = $current_tx;
            $session->session_rx = $current_rx;
            $session->session_tx = $current_tx;
            $session->start_time = $now;
            $session->last_seen = $now;
            $session->save();

            echo "    NEW SESSION: {$username} | Session Data: RX=" . formatUsageBytes($current_rx) . " TX=" . formatUsageBytes($current_tx) . "\n";
        }

        $rec = ORM::for_table('tbl_usage_records')
            ->where('router_id', $router_id)
            ->where('username', $username)
            ->where('interface', $interface)
            ->find_one();

        if ($rec) {
            if ($inc_tx > 0 || $inc_rx > 0) {
                $rec->tx_bytes += $inc_tx;
                $rec->rx_bytes += $inc_rx;
                $rec->last_seen = $now;
                $rec->save();
                
                echo "    USAGE RECORD: {$username} | Lifetime Total: RX=" . formatUsageBytes($rec->rx_bytes) . " TX=" . formatUsageBytes($rec->tx_bytes) . "\n";
            } else {
                $rec->last_seen = $now;
                $rec->save();
            }
        } else {
            $rec = ORM::for_table('tbl_usage_records')->create();
            $rec->router_id = $router_id;
            $rec->username = $username;
            $rec->interface = $interface;
            $rec->tx_bytes = $inc_tx;
            $rec->rx_bytes = $inc_rx;
            $rec->last_seen = $now;
            $rec->save();
            
            echo "    NEW USER RECORD: {$username} | Initial: RX=" . formatUsageBytes($inc_rx) . " TX=" . formatUsageBytes($inc_tx) . "\n";
        }

    } catch (Exception $e) {
        echo "    ERROR processing {$username}: " . $e->getMessage() . "\n";
    }
}

if (!createUsageTablesIfNeeded()) {
    echo "Failed to create usage database tables - skipping usage monitoring\n";
} else {
    $usage_routers = ORM::for_table('tbl_routers')->where('enabled', '1')->find_many();
    echo "Found " . count($usage_routers) . " enabled router(s) for usage monitoring.\n";

    $now = date('Y-m-d H:i:s');
    $enabled_router_ids = [];
    
    foreach ($usage_routers as $router) {
        $enabled_router_ids[] = $router->id;
    }

    foreach ($usage_routers as $router) {
        $rid = $router->id;
        echo "-- Usage Monitor Router {$rid} ({$router->ip_address}) --\n";
        
        try {
            $client = Mikrotik::getClient($router->ip_address, $router->username, $router->password);
            echo "Connected to router successfully for usage monitoring\n";
        } catch (Exception $e) {
            echo "Usage monitoring connection failed: " . $e->getMessage() . "\n";
            continue;
        }

        echo "Marking old sessions as inactive for router {$rid}...\n";
        $old_sessions = ORM::for_table('tbl_usage_sessions')
            ->where('router_id', $rid)
            ->where_lt('last_seen', date('Y-m-d H:i:s', strtotime('-2 minutes')))
            ->find_many();
        
        $inactive_count = count($old_sessions);
        foreach ($old_sessions as $session) {
            $session->delete();
        }
        echo "Cleaned {$inactive_count} old sessions (older than 2 minutes)\n";
        
        try {
            echo "Fetching hotspot active users...\n";
            $hotspotActive = $client->sendSync(new PEAR2\Net\RouterOS\Request('/ip/hotspot/active/print'));
            $hotspotCount = count($hotspotActive);
            echo "Found {$hotspotCount} active hotspot users\n";

            foreach ($hotspotActive as $hotspot) {
                $username = $hotspot->getProperty('user');
                $address = $hotspot->getProperty('address');
                $mac = $hotspot->getProperty('mac-address');
                $session_id = $hotspot->getProperty('.id');
                
                $rxBytes = intval($hotspot->getProperty('bytes-in'));
                $txBytes = intval($hotspot->getProperty('bytes-out'));
                
                if ($username && $session_id) {
                    processUserSession($rid, $username, 'hotspot', $session_id, $rxBytes, $txBytes, $now, $address, $mac);
                    echo "  HOTSPOT: {$username} ({$address}) [{$mac}] | RX: " . formatUsageBytes($rxBytes) . " TX: " . formatUsageBytes($txBytes) . "\n";
                }
            }
        } catch (Exception $e) {
            echo "Error fetching hotspot users: " . $e->getMessage() . "\n";
        }

        try {
            echo "Fetching PPPoE active users...\n";
            $pppUsers = $client->sendSync(new PEAR2\Net\RouterOS\Request('/ppp/active/print'));
            $pppCount = count($pppUsers);
            echo "Found {$pppCount} active PPPoE users\n";

            $interfaceTraffic = $client->sendSync(new PEAR2\Net\RouterOS\Request('/interface/print'));
            $interfaceData = [];
            foreach ($interfaceTraffic as $interface) {
                $name = $interface->getProperty('name');
                if (!empty($name)) {
                    $interfaceData[$name] = [
                        'txBytes' => intval($interface->getProperty('tx-byte')),
                        'rxBytes' => intval($interface->getProperty('rx-byte')),
                    ];
                }
            }

            foreach ($pppUsers as $pppUser) {
                $username = $pppUser->getProperty('name');
                $address = $pppUser->getProperty('address');
                $session_id = $pppUser->getProperty('.id');
                $callerId = $pppUser->getProperty('caller-id'); // MAC address for PPPoE

                $interfaceName = "<pppoe-$username>";
                if (isset($interfaceData[$interfaceName])) {
                    $trafficData = $interfaceData[$interfaceName];
                    $txBytes = $trafficData['txBytes'];
                    $rxBytes = $trafficData['rxBytes'];
                } else {
                    $txBytes = 0;
                    $rxBytes = 0;
                }

                if ($username && $session_id) {
                    processUserSession($rid, $username, 'pppoe', $session_id, $txBytes, $rxBytes, $now, $address, $callerId);
                    echo "  PPPOE: {$username} ({$address}) [{$callerId}] | RX: " . formatUsageBytes($rxBytes) . " TX: " . formatUsageBytes($txBytes) . "\n";
                }
            }
        } catch (Exception $e) {
            echo "Error fetching PPPoE users: " . $e->getMessage() . "\n";
        }

        echo "Finished processing usage for router {$rid}\n";
    }
}

try {
    $recentSessions = ORM::for_table('tbl_usage_sessions')
        ->where_gte('last_seen', date('Y-m-d H:i:s', time() - 300))
        ->limit(10)
        ->find_many();
    
    if (count($recentSessions) > 0) {
        echo "\n=== Recent Session Data (Last 5 minutes) ===\n";
        foreach ($recentSessions as $s) {
            $ip_info = $s->ip_address ? " IP: {$s->ip_address}" : " IP: N/A";
            $mac_info = $s->mac_address ? " MAC: {$s->mac_address}" : " MAC: N/A";
            echo "  {$s->username} ({$s->interface}){$ip_info}{$mac_info} | RX: " . formatUsageBytes($s->session_rx) . " TX: " . formatUsageBytes($s->session_tx) . "\n";
        }
    } else {
        echo "\n=== No recent sessions found in last 5 minutes ===\n";
    }
} catch (Exception $e) {
    echo "Error displaying session data: " . $e->getMessage() . "\n";
}

if (!empty($enabled_router_ids)) {
    try {
        $disabled_sessions = ORM::for_table('tbl_usage_sessions')
            ->where_not_in('router_id', $enabled_router_ids)
            ->find_many();
        $disabled_count = count($disabled_sessions);
        if ($disabled_count > 0) {
            foreach ($disabled_sessions as $disabled_session) {
                $disabled_session->delete();
            }
            echo "Cleaned {$disabled_count} sessions from disabled routers\n";
        }
    } catch (Exception $e) {
        echo "Error cleaning disabled router sessions: " . $e->getMessage() . "\n";
    }
} else {
    echo "No enabled routers found for cleanup\n";
}

echo "=== MikroTik Usage Monitor Finished ===\n";

// === EXISTING USER EXPIRY HANDLING ===
foreach ($d as $ds) {
    try {
        $date_now = strtotime(date("Y-m-d H:i:s"));
        $expiration_time = $ds['time'] ?? '00:00:00';
        $expiration = strtotime($ds['expiration'] . ' ' . $expiration_time);
        
        echo $ds['expiration'] . " " . $expiration_time . " : " . ($isCli ? $ds['username'] : Lang::maskText($ds['username']));

        if ($date_now >= $expiration) {
            echo " : EXPIRED \r\n";

            $u = ORM::for_table('tbl_user_recharges')->where('id', $ds['id'])->find_one();
            if (!$u) {
                throw new Exception("User recharge record not found for ID: " . $ds['id']);
            }

            $c = ORM::for_table('tbl_customers')->where('id', $ds['customer_id'])->find_one();
            if (!$c) {
                $c = $u;
            }

            $p = ORM::for_table('tbl_plans')->where('id', $u['plan_id'])->find_one();
            if (!$p) {
                throw new Exception("Plan not found for ID: " . $u['plan_id']);
            }

            $dvc = Package::getDevice($p);
            if ($_app_stage != 'demo') {
                if (file_exists($dvc)) {
                    require_once $dvc;
                    echo "Disconnecting user {$c['username']} using device {$p['device']}...\n";
                    try {
                        (new $p['device'])->remove_customer($c, $p);
                        echo "? Disconnect command executed for {$c['username']}\n";
                        
                        // FIX: After device removal, ensure hotspot cookies are removed for this user
                        // Get the router(s) associated with this plan
                        $routerIds = explode(',', $p['routers']);
                        foreach ($routerIds as $rid) {
                            $router = ORM::for_table('tbl_routers')->where('id', $rid)->find_one();
                            if ($router) {
                                try {
                                    $client = Mikrotik::getClient($router['ip_address'], $router['username'], $router['password']);
                                    removeHotspotCookies($client, $c['username']);
                                } catch (Exception $e) {
                                    echo "? Cookie removal on router {$router['name']} failed: " . $e->getMessage() . "\n";
                                }
                            }
                        }
                    } catch (Exception $e) {
                        echo "? Error disconnecting {$c['username']}: " . $e->getMessage() . "\n";
                        
                        echo "Attempting direct router disconnection for {$c['username']}...\n";
                        try {
                            $router = ORM::for_table('tbl_routers')->where('name', $p['routers'])->find_one();
                            if ($router) {
                                $client = Mikrotik::getClient($router['ip_address'], $router['username'], $router['password']);
                                
                                // For PPPoE users
                                if ($p['type'] == 'PPPOE') {
                                    // Remove from PPP active
                                    $pppRequest = new PEAR2\Net\RouterOS\Request('/ppp/active/print');
                                    $pppActive = $client->sendSync($pppRequest);
                                    foreach ($pppActive as $active) {
                                        if ($active->getProperty('name') == $c['username'] || 
                                            $active->getProperty('name') == $c['pppoe_username']) {
                                            $removeRequest = new PEAR2\Net\RouterOS\Request('/ppp/active/remove');
                                            $removeRequest->setArgument('numbers', $active->getProperty('.id'));
                                            $client->sendSync($removeRequest);
                                            echo "? Removed {$c['username']} from PPP active sessions\n";
                                            break;
                                        }
                                    }
                                    
                                    // Also disable the secret temporarily
                                    $secretRequest = new PEAR2\Net\RouterOS\Request('/ppp/secret/print');
                                    $secretRequest->setArgument('?name', $c['pppoe_username'] ?: $c['username']);
                                    $secrets = $client->sendSync($secretRequest);
                                    foreach ($secrets as $secret) {
                                        $disableSecret = new PEAR2\Net\RouterOS\Request('/ppp/secret/disable');
                                        $disableSecret->setArgument('numbers', $secret->getProperty('.id'));
                                        $client->sendSync($disableSecret);
                                        echo "? Disabled PPP secret for {$c['username']}\n";
                                    }
                                } else {
                                    // For hotspot users
                                    $request = new PEAR2\Net\RouterOS\Request('/ip/hotspot/active/print');
                                    $activeUsers = $client->sendSync($request);
                                    
                                    foreach ($activeUsers as $user) {
                                        if ($user->getProperty('user') == $c['username']) {
                                            $removeRequest = new PEAR2\Net\RouterOS\Request('/ip/hotspot/active/remove');
                                            $removeRequest->setArgument('numbers', $user->getProperty('.id'));
                                            $client->sendSync($removeRequest);
                                            echo "? Removed {$c['username']} from active sessions\n";
                                            break;
                                        }
                                    }
                                    
                                    // Also remove from host table
                                    $hostRequest = new PEAR2\Net\RouterOS\Request('/ip/hotspot/host/print');
                                    $hosts = $client->sendSync($hostRequest);
                                    
                                    foreach ($hosts as $host) {
                                        if ($host->getProperty('user') == $c['username']) {
                                            $removeHost = new PEAR2\Net\RouterOS\Request('/ip/hotspot/host/remove');
                                            $removeHost->setArgument('numbers', $host->getProperty('.id'));
                                            $client->sendSync($removeHost);
                                            echo "? Cleared host entry for {$c['username']}\n";
                                        }
                                    }

                                    // FIX: Remove hotspot cookies so user is redirected to sign-in page instantly
                                    removeHotspotCookies($client, $c['username']);
                                }
                            }
                        } catch (Exception $e2) {
                            echo "? Direct disconnection failed: " . $e2->getMessage() . "\n";
                        }
                    }
                } else {
                    throw new Exception("Cron error: Devices " . $p['device'] . " not found, cannot disconnect ".$c['username']."\n");
                }
            }

            try {
                echo Message::sendPackageNotification(
                    $c,
                    $u['namebp'],
                    $p['price'],
                    Message::getMessageType($p['type'], $textExpired),
                    $config['user_notification_expired']
                ) . "\n";
                
                // Send SMS notification to admin for expired user
                $adminPhoneNumbers = getAdminPhoneNumbers();
                $smsMessage = "USER EXPIRED: {$c['username']} - {$u['namebp']} at " . date('H:i:s');
                if (empty($adminPhoneNumbers)) {
                    echo "      !! Admin SMS skipped (no SuperAdmin phone or admin_phone).\n";
                } elseif (!isset($config['sms_gateway_type']) || $config['sms_gateway_type'] != 'url' || empty($config['sms_url'])) {
                    echo "      !! Admin SMS skipped (sms_gateway_type/url not configured).\n";
                } else {
                    foreach ($adminPhoneNumbers as $phone) {
                        echo "      Attempting to send SMS to admin $phone... ";
                        $result = sendSms($phone, $smsMessage);
                        echo $result ? "Sent\n" : "Failed\n";
                    }
                }
                
                $u->status = 'off';
                $u->save();
                echo "? User {$c['username']} status set to 'off' in database\n";
            } catch (Throwable $e) {
                _log($e->getMessage());
                echo "Error sending notification: " . $e->getMessage() . "\n";
                $u->status = 'off';
                $u->save();
            }

            if ($config['enable_balance'] == 'yes' && isset($c['auto_renewal']) && $c['auto_renewal']) {
                [$bills, $add_cost] = User::getBills($ds['customer_id']);
                if ($add_cost != 0) {
                    $p['price'] += $add_cost;
                }

                if ($p && $c['balance'] >= $p['price']) {
                    if (Package::rechargeUser($ds['customer_id'], $ds['routers'], $p['id'], 'Customer', 'Balance')) {
                        Balance::min($ds['customer_id'], $p['price']);
                        echo "Auto-renewal: plan enabled for {$c['username']}\n";
                    } else {
                        echo "Auto-renewal failed for {$c['username']}\n";
                    }
                } else {
                    echo "No auto-renewal for {$c['username']}: insufficient balance\n";
                }
            } else {
                echo "Auto-renewal not enabled for {$c['username']}\n";
            }
        } else {
            echo " : ACTIVE \r\n";
        }
    } catch (Throwable $e) {
        _log($e->getMessage());
        echo "Unexpected Error processing user: " . $e->getMessage() . "\n";
    }
}

// === EXISTING RADIUS ACCOUNTING CODE ===
if (isset($config['frrest_interim_update']) && $config['frrest_interim_update'] != 0) {
    $r_a = ORM::for_table('rad_acct')
        ->whereRaw("BINARY acctstatustype = 'Start' OR acctstatustype = 'Interim-Update'")
        ->where_lte('dateAdded', date("Y-m-d H:i:s"))->find_many();

    foreach ($r_a as $ra) {
        $interval = $_c['frrest_interim_update'] * 60;
        $timeUpdate = strtotime($ra['dateAdded']) + $interval;
        $timeNow = strtotime(date("Y-m-d H:i:s"));
        if ($timeNow >= $timeUpdate) {
            $ra->acctstatustype = 'Stop';
            $ra->save();
        }
    }
}

// === EXISTING ROUTER STATUS CHECK ===
if (isset($config['router_check']) && $config['router_check']) {
    echo "?? Checking router status...\n";
    $routers = ORM::for_table('tbl_routers')->where('enabled', '1')->find_many();
    if (!$routers) {
        echo "No active routers found in the database.\n";
        flock($lock, LOCK_UN);
        fclose($lock);
        @unlink($lockFile);
        exit;
    }

    $offlineRouters = [];
    $onlineRouters = [];
    $errors = [];

    foreach ($routers as $router) {
        $previous_status = $router->status;
        $previous_last_seen = $router->last_seen;
        
        echo "Checking router {$router->name} ({$router->ip_address})... ";
        
        if (strpos($router->ip_address, ':') === false) {
            $ip = $router->ip_address;
            $port = 8728;
        } else {
            [$ip, $port] = explode(':', $router->ip_address);
        }
        $isOnline = false;

        try {
            $timeout = 5;
            if (is_callable('fsockopen') && false === stripos(ini_get('disable_functions'), 'fsockopen')) {
                $fsock = @fsockopen($ip, $port, $errno, $errstr, $timeout);
                if ($fsock) {
                    fclose($fsock);
                    $isOnline = true;
                } else {
                    throw new Exception("Unable to connect to $ip on port $port using fsockopen: $errstr ($errno)");
                }
            } elseif (is_callable('stream_socket_client') && false === stripos(ini_get('disable_functions'), 'stream_socket_client')) {
                $connection = @stream_socket_client("$ip:$port", $errno, $errstr, $timeout);
                if ($connection) {
                    fclose($connection);
                    $isOnline = true;
                } else {
                    throw new Exception("Unable to connect to $ip on port $port using stream_socket_client: $errstr ($errno)");
                }
            } else {
                throw new Exception("Neither fsockopen nor stream_socket_client are enabled on the server.");
            }
        } catch (Exception $e) {
            _log($e->getMessage());
            $errors[] = "Error with router $ip: " . $e->getMessage();
        }

        if ($isOnline) {
            echo "? Online\n";
            $router->last_seen = date('Y-m-d H:i:s');
            $router->status = 'Online';
            
            if ($previous_status == 'Offline') {
                $onlineRouters[] = $router;
                echo "   ? Router {$router->name} came ONLINE! (was offline since {$previous_last_seen})\n";
            }
        } else {
            echo "? Offline\n";
            $router->status = 'Offline';
            if ($previous_status == 'Online') {
                $offlineRouters[] = $router;
                echo "   ? Router {$router->name} went OFFLINE!\n";
            }
        }

        $router->save();
    }
    
    // Send notifications for offline routers (SMS only)
    if (!empty($offlineRouters)) {
        $routerNames = implode(", ", array_map(function ($r) {
            return $r->name . "(" . $r->ip_address . ")";
        }, $offlineRouters));

        $smsMessage = "ROUTER OFFLINE: " . $routerNames . " at " . date('H:i:s');

        echo "Sending offline SMS notifications...\n";

        $adminPhoneNumbers = getAdminPhoneNumbers();
        if (empty($adminPhoneNumbers)) {
            echo "      !! Skipped: no admin phone (active SuperAdmin phone or admin_phone setting).\n";
            _log('Router offline SMS skipped: no admin phone numbers.');
        } elseif (!isset($config['sms_gateway_type']) || $config['sms_gateway_type'] != 'url' || empty($config['sms_url'])) {
            echo "      !! Skipped: SMS URL gateway not configured (sms_gateway_type=url and sms_url).\n";
            _log('Router offline SMS skipped: SMS URL gateway not configured.');
        } else {
            foreach ($adminPhoneNumbers as $phone) {
                echo "      Sending SMS to: $phone... ";
                $result = sendSms($phone, $smsMessage);
                echo $result ? "Sent\n" : "Failed\n";
            }
        }
    }

    // Send notifications for online routers (SMS only)
    if (!empty($onlineRouters)) {
        $routerNames = implode(", ", array_map(function ($r) {
            return $r->name . "(" . $r->ip_address . ")";
        }, $onlineRouters));

        $smsMessage = "ROUTER ONLINE: " . $routerNames . " at " . date('H:i:s');

        echo "Sending online SMS notifications...\n";

        $adminPhoneNumbers = getAdminPhoneNumbers();
        if (empty($adminPhoneNumbers)) {
            echo "      !! Skipped: no admin phone (active SuperAdmin phone or admin_phone setting).\n";
            _log('Router online SMS skipped: no admin phone numbers.');
        } elseif (!isset($config['sms_gateway_type']) || $config['sms_gateway_type'] != 'url' || empty($config['sms_url'])) {
            echo "      !! Skipped: SMS URL gateway not configured (sms_gateway_type=url and sms_url).\n";
            _log('Router online SMS skipped: SMS URL gateway not configured.');
        } else {
            foreach ($adminPhoneNumbers as $phone) {
                echo "      Sending SMS to: $phone... ";
                $result = sendSms($phone, $smsMessage);
                echo $result ? "Sent\n" : "Failed\n";
            }
        }
    }

    if (!empty($errors)) {
        $errorMessage = "Router Monitoring Errors:\n" . implode("\n", $errors);
        // Log errors but don't send notifications
        error_log($errorMessage);
    }
    echo "Router monitoring finished checking.\n";
}

// Clean old cache files
$cache_cleaned = 0;
if (is_dir($CACHE_PATH)) {
    $json_files = glob($CACHE_PATH . '/*.json');
    foreach ($json_files as $file) {
        if (file_exists($file) && (time() - filemtime($file)) > 600) {
            if (unlink($file)) {
                $cache_cleaned++;
            }
        }
    }
    if ($cache_cleaned > 0) {
        echo "Cleaned $cache_cleaned old dashboard cache files.\n";
    }
}

flock($lock, LOCK_UN);
fclose($lock);
@unlink($lockFile);
@unlink($pidFile);

$timestampFile = "$UPLOAD_PATH/cron_last_run.txt";
file_put_contents($timestampFile, time());

run_hook('cronjob_end'); #HOOK
echo "Cron job finished and completed successfully at " . date('Y-m-d H:i:s') . "\n";
?>