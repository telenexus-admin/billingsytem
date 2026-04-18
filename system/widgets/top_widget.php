<?php
/**
 * top_widget.php - Dashboard widget for displaying real-time statistics
 * Includes separate counters for Hotspot and PPPoE users
 */

class top_widget
{
    /**
     * Main widget display method
     * @return string Rendered HTML
     */
    public function getWidget()
    {
        global $ui, $current_date, $start_date, $_c, $config, $UPLOAD_PATH, $CACHE_PATH, $WIDGET_PATH;

        // Get today's sales
        $iday = ORM::for_table('tbl_transactions')
            ->where('recharged_on', $current_date)
            ->where_not_equal('method', 'Customer - Balance')
            ->where_not_equal('method', 'Recharge Balance - Administrator')
            ->where_not_equal('method', 'Voucher')
            ->sum('price');

        if ($iday == '') {
            $iday = '0.00';
        }
        $ui->assign('iday', $iday);

        // Get monthly sales
        $imonth = ORM::for_table('tbl_transactions')
            ->where_not_equal('method', 'Customer - Balance')
            ->where_not_equal('method', 'Recharge Balance - Administrator')
            ->where_not_equal('method', 'Voucher')
            ->where_gte('recharged_on', $start_date)
            ->where_lte('recharged_on', $current_date)
            ->sum('price');
            
        if ($imonth == '') {
            $imonth = '0.00';
        }
        $ui->assign('imonth', $imonth);

        // Get online users data from local database
        try {
            $online_data = $this->getOnlineUsersFromLocal(true);
            
            // Total online users
            $u_act = $online_data['online'];
            
            // Total active accounts (with active packages)
            $u_all = $online_data['total_active_accounts'];
            
            // Separate counts by connection type
            $hotspot_online = $online_data['hotspot_online'] ?? 0;
            $pppoe_online = $online_data['pppoe_online'] ?? 0;
            
            // List of active but not online users (for debugging)
            $active_but_not_online = $online_data['active_but_not_online'] ?? [];
            
        } catch (Exception $e) {
            // Fallback to active recharges only
            $u_act = 0;
            $u_all = ORM::for_table('tbl_user_recharges')->where('status', 'on')->count();
            $hotspot_online = 0;
            $pppoe_online = 0;
            $active_but_not_online = [];
            
            $online_data = [
                'online' => $u_act,
                'hotspot_online' => 0,
                'pppoe_online' => 0,
                'offline' => $u_all,
                'total_tracked' => $u_all,
                'total_active_accounts' => $u_all,
                'cached' => false,
                'timestamp' => time(),
                'status' => 'fallback',
                'source' => 'Active Accounts Fallback',
                'active_but_not_online' => []
            ];
        }
        
        // Active accounts for display
        $active_accounts = $online_data['total_active_accounts'] ?? $u_all;
        
        // Assign all values to template
        $ui->assign('u_act', $u_act);                          // Total online users
        $ui->assign('u_all', $u_all);                          // Total active accounts
        $ui->assign('active_accounts', $active_accounts);      // For Active Accounts display
        $ui->assign('active_but_not_online', $active_but_not_online);
        $ui->assign('hotspot_online', $hotspot_online);        // Hotspot only
        $ui->assign('pppoe_online', $pppoe_online);            // PPPoE only
        
        // Status information
        $ui->assign('online_cached', $online_data['cached'] ?? false);
        $ui->assign('online_source', $online_data['source'] ?? 'Local Database');
        $ui->assign('online_status', $online_data['status'] ?? 'live');
        $ui->assign('last_update', $online_data['timestamp'] ?? time());
        $ui->assign('total_tracked', $online_data['total_tracked'] ?? 0);
        
        // Data source indicator class
        $data_source_class = '';
        switch($online_data['source'] ?? '') {
            case 'Local Usage Database':
                $data_source_class = 'success';
                break;
            case 'Active Accounts Fallback':
                $data_source_class = 'secondary';
                break;
            default:
                $data_source_class = 'warning';
        }
        $ui->assign('data_source_class', $data_source_class);

        // Get total customers count
        $c_all = ORM::for_table('tbl_customers')->count();
        if (empty($c_all)) {
            $c_all = '0';
        }
        $ui->assign('c_all', $c_all);
        
        // Get routers list for filter dropdown
        $routers = ORM::for_table('tbl_routers')
            ->where('enabled', 1)
            ->order_by_asc('name')
            ->find_many();
        $ui->assign('routers', $routers);
        
        // Get online routers count
        $online_routers = ORM::for_table('tbl_routers')
            ->where('status', 'Online')
            ->where('enabled', 1)
            ->count();
        $ui->assign('online_routers', $online_routers);
        
        // Get current timestamp
        $ui->assign('now', time());
        $ui->assign('dashboard_router_ajax_url', Text::url('dashboard'));

        return $ui->fetch('widget/top_widget.tpl');
    }

    /**
     * Whether tbl_transactions has a routers column (for per-router revenue).
     */
    private static function transactionsHasRoutersColumn()
    {
        static $cached = null;
        if ($cached !== null) {
            return $cached;
        }
        try {
            $row = ORM::for_table('tbl_transactions')->raw_query(
                "SELECT 1 AS ok FROM information_schema.COLUMNS " .
                "WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'tbl_transactions' AND COLUMN_NAME = 'routers' LIMIT 1"
            )->find_one();
            $cached = $row && (isset($row['ok']) || (is_object($row) && isset($row->ok)));
        } catch (Throwable $e) {
            $cached = false;
        }
        return $cached;
    }

    /**
     * Usernames with an active recharge on the given router location name.
     *
     * @return string[]
     */
    private static function usernamesWithRechargeOnRouter($routerName)
    {
        if ($routerName === null || $routerName === '') {
            return [];
        }
        $rows = ORM::for_table('tbl_user_recharges')
            ->distinct()
            ->select('username')
            ->where('routers', $routerName)
            ->where('status', 'on')
            ->find_array();
        return array_values(array_unique(array_filter(array_column($rows, 'username'))));
    }

    /**
     * Get online/offline users from local customer usage database
     * Separates Hotspot and PPPoE users
     * 
     * @param bool $withList Whether to return list of offline users
     * @param int|null $router_id Filter by specific router ID
     * @return array Statistics array
     */
    private function getOnlineUsersFromLocal($withList = false, $router_id = null)
    {
        try {
            // Define threshold for "online" status (last 2 minutes)
            $threshold = date('Y-m-d H:i:s', strtotime('-2 minutes'));
            
            // Get total active accounts (have active packages)
            $total_active_accounts = ORM::for_table('tbl_user_recharges')
                ->where('status', 'on')
                ->count();
            
            // Initialize counters
            $online_count = 0;
            $hotspot_online = 0;
            $pppoe_online = 0;
            $active_but_not_online = [];
            
            try {
                // Check if usage sessions table exists
                $table_check = ORM::for_table('tbl_usage_sessions')
                    ->raw_query("SHOW TABLES LIKE 'tbl_usage_sessions'")
                    ->find_one();
                
                if ($table_check) {
                    // Build query for online users
                    $query = "
                        SELECT username, interface, MAX(last_seen) as last_seen
                        FROM tbl_usage_sessions
                        WHERE last_seen >= :threshold
                    ";
                    
                    $params = ['threshold' => $threshold];
                    
                    // Filter by router ID if specified
                    if ($router_id !== null && $router_id !== 'all') {
                        $query .= " AND router_id = :router_id";
                        $params['router_id'] = $router_id;
                    }
                    
                    $query .= " GROUP BY username, interface";
                    
                    // Get all online users with their interface types
                    $online_users = ORM::for_table('tbl_usage_sessions')
                        ->raw_query($query, $params)
                        ->find_array();
                    
                    // Count by interface type
                    $online_count = count($online_users);
                    
                    // Separate counters
                    foreach ($online_users as $user) {
                        if ($user['interface'] == 'hotspot') {
                            $hotspot_online++;
                        } elseif ($user['interface'] == 'pppoe') {
                            $pppoe_online++;
                        }
                    }
                    
                    // If we need the list of active but not online users
                    if ($withList && $online_count > 0) {
                        // Get all usernames that are online
                        $online_usernames = array_column($online_users, 'username');
                        
                        // Get all active accounts
                        $active_accounts = ORM::for_table('tbl_user_recharges')
                            ->select('username')
                            ->where('status', 'on')
                            ->find_array();
                        
                        // Find which active accounts are not online
                        foreach ($active_accounts as $account) {
                            if (!in_array($account['username'], $online_usernames)) {
                                $active_but_not_online[] = $account['username'];
                            }
                        }
                        
                        // Limit the list to prevent huge arrays
                        $active_but_not_online = array_slice($active_but_not_online, 0, 100);
                    }
                } else {
                    // Table doesn't exist yet
                    throw new Exception("Usage sessions table does not exist");
                }
            } catch (Exception $e) {
                // Log error but don't crash
                error_log("Error in getOnlineUsersFromLocal: " . $e->getMessage());
                throw $e;
            }
            
            // Calculate inactive users
            $inactive_count = max(0, $total_active_accounts - $online_count);
            
            $source_text = $router_id ? "Router-Specific Data" : "Local Usage Database";
            
            return [
                'online' => $online_count,
                'hotspot_online' => $hotspot_online,
                'pppoe_online' => $pppoe_online,
                'offline' => $inactive_count,
                'total_tracked' => $total_active_accounts,
                'total_active_accounts' => $total_active_accounts,
                'cached' => false,
                'timestamp' => time(),
                'status' => 'live',
                'source' => $source_text,
                'threshold_minutes' => 2,
                'active_but_not_online' => $active_but_not_online,
                'filtered_router_id' => $router_id
            ];
            
        } catch (Exception $e) {
            // Return error state
            return [
                'online' => 0,
                'hotspot_online' => 0,
                'pppoe_online' => 0,
                'offline' => 0,
                'total_tracked' => 0,
                'total_active_accounts' => 0,
                'cached' => false,
                'timestamp' => time(),
                'status' => 'error',
                'source' => 'Error: ' . $e->getMessage(),
                'threshold_minutes' => 2,
                'active_but_not_online' => []
            ];
        }
    }

    /**
     * Get fresh online users data for AJAX requests
     * 
     * @param int|null $router_id Filter by specific router
     * @return array Online users statistics
     */
    public function getOnlineUsersAjax($router_id = null)
    {
        return $this->getOnlineUsersFromLocal(false, $router_id);
    }
    
    /**
     * Static method for AJAX endpoint
     * 
     * @return array Online users statistics
     */
    public static function ajaxGetOnlineUsers()
    {
        $widget = new self();
        return $widget->getOnlineUsersAjax();
    }
    
    /**
     * Get filtered data for a specific router (AJAX endpoint)
     * Now uses router ID for proper filtering
     * 
     * @param int $router_id Router ID to filter by
     * @return array Filtered statistics
     */
    public static function ajaxGetFilteredData($router_id)
    {
        global $config;

        $reset_day = !empty($config['reset_day']) ? $config['reset_day'] : 1;
        if (date('d') >= $reset_day) {
            $start_date = date('Y-m-' . $reset_day);
        } else {
            $start_date = date('Y-m-' . $reset_day, strtotime('-1 MONTH'));
        }
        $current_date = date('Y-m-d');

        $response = [];

        try {
            // Get router info if specific router selected
            $router_name = null;
            $router = null;
            
            if ($router_id != 'all') {
                $router = ORM::for_table('tbl_routers')->find_one($router_id);
                if ($router) {
                    $router_name = $router->name;
                } else {
                    // Router not found, return error
                    $response['success'] = false;
                    $response['error'] = 'Router not found';
                    return $response;
                }
            }
            
            // Get today's sales - try to filter by router name first
            $today_sales = 0;
            $monthly_sales = 0;
            
            if ($router_name !== null) {
                $baseToday = ORM::for_table('tbl_transactions')
                    ->where('recharged_on', $current_date)
                    ->where_not_equal('method', 'Customer - Balance')
                    ->where_not_equal('method', 'Recharge Balance - Administrator')
                    ->where_not_equal('method', 'Voucher');

                $baseMonth = ORM::for_table('tbl_transactions')
                    ->where_gte('recharged_on', $start_date)
                    ->where_lte('recharged_on', $current_date)
                    ->where_not_equal('method', 'Customer - Balance')
                    ->where_not_equal('method', 'Recharge Balance - Administrator')
                    ->where_not_equal('method', 'Voucher');

                if (self::transactionsHasRoutersColumn()) {
                    $today_sales = (float) (ORM::for_table('tbl_transactions')
                        ->where('recharged_on', $current_date)
                        ->where_not_equal('method', 'Customer - Balance')
                        ->where_not_equal('method', 'Recharge Balance - Administrator')
                        ->where_not_equal('method', 'Voucher')
                        ->where('routers', $router_name)
                        ->sum('price') ?: 0);
                    $monthly_sales = (float) (ORM::for_table('tbl_transactions')
                        ->where_gte('recharged_on', $start_date)
                        ->where_lte('recharged_on', $current_date)
                        ->where_not_equal('method', 'Customer - Balance')
                        ->where_not_equal('method', 'Recharge Balance - Administrator')
                        ->where_not_equal('method', 'Voucher')
                        ->where('routers', $router_name)
                        ->sum('price') ?: 0);
                } else {
                    $today_sales = (float) ($baseToday->sum('price') ?: 0);
                    $monthly_sales = (float) ($baseMonth->sum('price') ?: 0);
                }

                // Older rows may have empty routers but customers are on this location — attribute by username
                if ($today_sales == 0 || $monthly_sales == 0) {
                    $users = self::usernamesWithRechargeOnRouter($router_name);
                    if (count($users) > 0) {
                        if ($today_sales == 0) {
                            $today_sales = (float) (ORM::for_table('tbl_transactions')
                                ->where('recharged_on', $current_date)
                                ->where_not_equal('method', 'Customer - Balance')
                                ->where_not_equal('method', 'Recharge Balance - Administrator')
                                ->where_not_equal('method', 'Voucher')
                                ->where_in('username', $users)
                                ->sum('price') ?: 0);
                        }
                        if ($monthly_sales == 0) {
                            $monthly_sales = (float) (ORM::for_table('tbl_transactions')
                                ->where_gte('recharged_on', $start_date)
                                ->where_lte('recharged_on', $current_date)
                                ->where_not_equal('method', 'Customer - Balance')
                                ->where_not_equal('method', 'Recharge Balance - Administrator')
                                ->where_not_equal('method', 'Voucher')
                                ->where_in('username', $users)
                                ->sum('price') ?: 0);
                        }
                    }
                }
            } else {
                // All routers - total sales
                $today_sales = (float)(ORM::for_table('tbl_transactions')
                    ->where('recharged_on', $current_date)
                    ->where_not_equal('method', 'Customer - Balance')
                    ->where_not_equal('method', 'Recharge Balance - Administrator')
                    ->where_not_equal('method', 'Voucher')
                    ->sum('price') ?: 0);
                    
                $monthly_sales = (float)(ORM::for_table('tbl_transactions')
                    ->where_gte('recharged_on', $start_date)
                    ->where_lte('recharged_on', $current_date)
                    ->where_not_equal('method', 'Customer - Balance')
                    ->where_not_equal('method', 'Recharge Balance - Administrator')
                    ->where_not_equal('method', 'Voucher')
                    ->sum('price') ?: 0);
            }
            
            $response['today_sales'] = $today_sales;
            $response['monthly_sales'] = $monthly_sales;
            
            // Get online users data filtered by router ID
            $widget = new self();
            $online_data = $widget->getOnlineUsersFromLocal(false, $router_id == 'all' ? null : (int)$router_id);
            
            $response['online_users'] = $online_data['online'];
            $response['hotspot_online'] = $online_data['hotspot_online'];
            $response['pppoe_online'] = $online_data['pppoe_online'];
            $response['active_accounts'] = $online_data['total_active_accounts'];
            
            // Show which router we're filtering for in the source
            if ($router_id != 'all' && $router) {
                $response['data_source'] = 'Router: ' . $router->name . ' (filtered)';
            } else {
                $response['data_source'] = $online_data['source'];
            }
            
            // Get router counts (global stats, not filtered by selected router)
            $response['online_routers'] = ORM::for_table('tbl_routers')
                ->where('status', 'Online')
                ->where('enabled', 1)
                ->count();
            
            $response['total_routers'] = ORM::for_table('tbl_routers')
                ->where('enabled', 1)
                ->count();
            
            $response['total_users'] = ORM::for_table('tbl_customers')->count();
            $response['success'] = true;
            
            // Add debug info if needed
            $response['debug'] = [
                'router_id' => $router_id,
                'router_name' => $router_name,
                'filter_applied' => $router_name !== null
            ];
            
        } catch (Exception $e) {
            $response['success'] = false;
            $response['error'] = $e->getMessage();
            $response['debug'] = [
                'router_id' => $router_id,
                'exception' => $e->getMessage()
            ];
        }
        
        return $response;
    }
}
?>