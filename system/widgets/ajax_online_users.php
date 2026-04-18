<?php
/**
 * AJAX endpoint for online users data
 * Path: /voky/system/widgets/ajax_online_users.php
 */

// Define proper path to init.php - try multiple possibilities
$possible_paths = [
    dirname(dirname(__DIR__)) . '/init.php',
    dirname(__DIR__) . '/init.php',
    '/var/www/html/voky/init.php'
];

$init_loaded = false;
foreach ($possible_paths as $path) {
    if (file_exists($path)) {
        require_once $path;
        $init_loaded = true;
        break;
    }
}

if (!$init_loaded) {
    header('HTTP/1.1 500 Internal Server Error');
    header('Content-Type: application/json');
    echo json_encode(['error' => 'Could not load init.php']);
    exit;
}

header('Content-Type: application/json');
header('Cache-Control: no-cache, must-revalidate');

try {
    // Get router filter from request
    $router_id = isset($_GET['router_id']) ? $_GET['router_id'] : 'all';
    
    // Get online users count (users with active recharges)
    $online_query = ORM::for_table('tbl_user_recharges')
        ->where('status', 'on');
    
    // Apply router filter if not 'all'
    if ($router_id !== 'all' && is_numeric($router_id)) {
        $online_query->where('routers', $router_id);
    }
    $online = $online_query->count();
    
    // Get total users count (all customers)
    $total_users = ORM::for_table('tbl_customers')->count();
    
    // Get router status counts
    $routers_online = ORM::for_table('tbl_routers')
        ->where('status', 'Online')
        ->count();
    
    $routers_total = ORM::for_table('tbl_routers')
        ->where('enabled', 1)
        ->count();
    
    // If no routers found, set defaults
    if ($routers_total == 0) {
        $routers_online = 1;
        $routers_total = 1;
    }
    
    // Return JSON response
    echo json_encode([
        'success' => true,
        'online' => (int)$online,
        'inactive' => (int)$total_users,
        'total_users' => (int)$total_users,
        'hotspot' => (int)$online,
        'routers_online' => (int)$routers_online,
        'routers_total' => (int)$routers_total,
        'status' => 'live',
        'timestamp' => time(),
        'router_filter' => $router_id
    ]);
    
} catch (Exception $e) {
    // Log error and return error response
    error_log('AJAX Online Users Error: ' . $e->getMessage());
    
    echo json_encode([
        'success' => false,
        'online' => 0,
        'inactive' => 0,
        'total_users' => 0,
        'hotspot' => 0,
        'routers_online' => 1,
        'routers_total' => 1,
        'status' => 'error',
        'message' => $e->getMessage(),
        'timestamp' => time()
    ]);
}
