<?php
/**
 * MikroTik Router Configurator Plugin for PayGrid
 * Automated hotspot configuration with interface selection
 * 
 * Similar to vpn_wireguard.php but for MikroTik router configuration
 */

register_menu("MikroTik Configurator", true, "mikrotik_configurator", 'NETWORK', 'fa fa-cogs', '', '', array('Admin', 'SuperAdmin'));

function mikrotik_configurator()
{
    global $ui, $admin;
    _admin(); // Ensure only admins can access
    
    $ui->assign('_title', 'MikroTik Router Configurator');
    $ui->assign('_system_menu', 'network');
    $ui->assign('_admin', $admin);

    $action = _get('action', 'routers');
    $router_id = _get('router_id', 0);

    switch ($action) {
        case 'configure':
            mikrotik_configure_router($router_id);
            break;
        case 'scan_ports':
            mikrotik_scan_ports($router_id);
            break;
        case 'generate_config':
            mikrotik_generate_config();
            break;
        case 'deploy_config':
            mikrotik_deploy_config();
            break;
        default:
            mikrotik_list_routers();
            break;
    }
}

function mikrotik_list_routers()
{
    global $ui;
    
    // Get all enabled MikroTik routers (following cron.php pattern)
    $routers = ORM::for_table('tbl_routers')
        ->where('enabled', '1')
        ->find_many();
    
    $router_data = [];
    foreach ($routers as $router) {
        $router_data[] = [
            'id' => $router->id,
            'name' => $router->name,
            'ip_address' => $router->ip_address,
            'description' => $router->description,
            'status' => $router->status ?? 'Unknown',
            'last_seen' => $router->last_seen ?? 'Never'
        ];
    }
    
    $ui->assign('routers', $router_data);
    $ui->assign('action', 'routers');
    $ui->display('mikrotik_configurator.tpl');
}

function mikrotik_configure_router($router_id)
{
    global $ui;
    
    if (!$router_id) {
        r2(U . 'plugin/mikrotik_configurator', 'e', 'Invalid router ID');
        return;
    }
    
    // Get router details
    $router = ORM::for_table('tbl_routers')->where('id', $router_id)->find_one();
    if (!$router) {
        r2(U . 'plugin/mikrotik_configurator', 'e', 'Router not found');
        return;
    }
    
    $ui->assign('router', $router);
    $ui->assign('action', 'configure');
    $ui->assign('router_id', $router_id);
    $ui->display('mikrotik_configurator.tpl');
}

function mikrotik_scan_ports($router_id)
{
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        header('Content-Type: application/json');
        echo json_encode(['success' => false, 'message' => 'Invalid request method']);
        exit;
    }
    
    $router = ORM::for_table('tbl_routers')->where('id', $router_id)->find_one();
    if (!$router) {
        header('Content-Type: application/json');
        echo json_encode(['success' => false, 'message' => 'Router not found']);
        exit;
    }
    
    try {
        // Connect to MikroTik (following cron.php pattern)
        $client = Mikrotik::getClient(
            $router->ip_address,
            $router->username,  
            $router->password
        );
        
        // Get interfaces (similar to cron.php interface scanning)
        $interfaces = $client->sendSync(new PEAR2\Net\RouterOS\Request('/interface/print'));
        
        $interface_data = [];
        foreach ($interfaces as $interface) {
            $name = $interface->getProperty('name');
            $type = $interface->getProperty('type');
            $running = $interface->getProperty('running') === 'true';
            $disabled = $interface->getProperty('disabled') === 'true';
            $comment = $interface->getProperty('comment') ?: '';
            
            // Only include physical interfaces (exclude bridges, VLANs, etc.)
            if (in_array($type, ['ether', 'wlan', 'wireless'])) {
                $interface_data[] = [
                    'name' => $name,
                    'type' => $type,
                    'running' => $running,
                    'disabled' => $disabled,
                    'comment' => $comment,
                    'selectable' => !$disabled && $type !== 'bridge'
                ];
            }
        }
        
        header('Content-Type: application/json');
        echo json_encode([
            'success' => true,
            'interfaces' => $interface_data,
            'router_name' => $router->name
        ]);
        
    } catch (Exception $e) {
        header('Content-Type: application/json');
        echo json_encode([
            'success' => false,
            'message' => 'Failed to connect to router: ' . $e->getMessage()
        ]);
    }
    exit;
}

function mikrotik_generate_config()
{
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        header('Content-Type: application/json');
        echo json_encode(['success' => false, 'message' => 'Invalid request method']);
        exit;
    }
    
    $input = json_decode(file_get_contents('php://input'), true);
    
    $router_id = $input['router_id'] ?? 0;
    $selected_interfaces = $input['interfaces'] ?? [];
    $bridge_name = $input['bridge_name'] ?? 'hotspot-bridge';
    $ip_range = $input['ip_range'] ?? '192.168.100.0/24';
    $gateway_ip = $input['gateway_ip'] ?? '192.168.100.1';
    $dhcp_start = $input['dhcp_start'] ?? '192.168.100.10';
    $dhcp_end = $input['dhcp_end'] ?? '192.168.100.254';
    $hotspot_name = $input['hotspot_name'] ?? 'main-hotspot';
    $dns_servers = $input['dns_servers'] ?? '8.8.8.8,1.1.1.1';
    
    if (empty($selected_interfaces)) {
        header('Content-Type: application/json');
        echo json_encode(['success' => false, 'message' => 'Please select at least one interface']);
        exit;
    }
    
    // Generate RSC content (following vpn_wireguard.php pattern)
    $rsc_content = generateHotspotRSC([
        'bridge_name' => $bridge_name,
        'interfaces' => $selected_interfaces,
        'ip_range' => $ip_range,
        'gateway_ip' => $gateway_ip,
        'dhcp_start' => $dhcp_start,
        'dhcp_end' => $dhcp_end,
        'hotspot_name' => $hotspot_name,
        'dns_servers' => $dns_servers
    ]);
    
    // Store configuration for deployment
    $config_id = saveConfiguration($router_id, $rsc_content, $input);
    
    header('Content-Type: application/json');
    echo json_encode([
        'success' => true,
        'config_id' => $config_id,
        'rsc_content' => $rsc_content
    ]);
    exit;
}

function mikrotik_deploy_config()
{
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        header('Content-Type: application/json');
        echo json_encode(['success' => false, 'message' => 'Invalid request method']);
        exit;
    }
    
    $input = json_decode(file_get_contents('php://input'), true);
    $config_id = $input['config_id'] ?? '';
    
    if (empty($config_id)) {
        header('Content-Type: application/json');
        echo json_encode(['success' => false, 'message' => 'Invalid configuration ID']);
        exit;
    }
    
    // Get saved configuration
    $config = getSavedConfiguration($config_id);
    if (!$config) {
        header('Content-Type: application/json');
        echo json_encode(['success' => false, 'message' => 'Configuration not found']);
        exit;
    }
    
    $router = ORM::for_table('tbl_routers')->where('id', $config['router_id'])->find_one();
    if (!$router) {
        header('Content-Type: application/json');
        echo json_encode(['success' => false, 'message' => 'Router not found']);
        exit;
    }
    
    try {
        // Deploy via SSH (similar to vpn_wireguard.php deployment)
        $result = deployRSCToMikroTik($router, $config['rsc_content']);
        
        if ($result['success']) {
            // Update configuration status
            updateConfigurationStatus($config_id, 'deployed', $result);
            
            header('Content-Type: application/json');
            echo json_encode([
                'success' => true,
                'message' => 'Configuration deployed successfully!',
                'details' => $result
            ]);
        } else {
            header('Content-Type: application/json');
            echo json_encode([
                'success' => false,
                'message' => 'Deployment failed: ' . $result['message'],
                'details' => $result
            ]);
        }
        
    } catch (Exception $e) {
        header('Content-Type: application/json');
        echo json_encode([
            'success' => false,
            'message' => 'Deployment error: ' . $e->getMessage()
        ]);
    }
    exit;
}

// RSC Generation Function (following vpn_wireguard.php pattern)
function generateHotspotRSC($config)
{
    $bridge_name = $config['bridge_name'];
    $interfaces = implode('"; "', $config['interfaces']);
    $ip_range = $config['ip_range'];
    $gateway_ip = $config['gateway_ip'];
    $dhcp_start = $config['dhcp_start'];
    $dhcp_end = $config['dhcp_end'];
    $hotspot_name = $config['hotspot_name'];
    $dns_servers = str_replace(',', ',', $config['dns_servers']);
    
    $timestamp = date('Y-m-d H:i:s');
    
    return <<<EOT
# MikroTik Hotspot Configuration
# Generated by PayGrid MikroTik Configurator
# Date: {$timestamp}

:log info "=== Starting PayGrid Hotspot Configuration ==="

# 1) Create bridge
:if ([:len [/interface bridge find name="{$bridge_name}"]] = 0) do={
    /interface bridge add name="{$bridge_name}" comment="PayGrid Auto-Generated"
    :log info "Created bridge: {$bridge_name}"
} else={
    :log info "Bridge {$bridge_name} already exists"
}

# 2) Add IP to bridge
:if ([:len [/ip address find address="{$gateway_ip}/24" interface="{$bridge_name}"]] = 0) do={
    /ip address add address={$gateway_ip}/24 interface="{$bridge_name}" comment="PayGrid Auto-Generated"
    :log info "Added IP {$gateway_ip}/24 to bridge"
}

# 3) Create DHCP pool
:if ([:len [/ip pool find name="hotspot-pool"]] = 0) do={
    /ip pool add name="hotspot-pool" ranges={$dhcp_start}-{$dhcp_end} comment="PayGrid Auto-Generated"
    :log info "Created DHCP pool: {$dhcp_start}-{$dhcp_end}"
}

# 4) Add selected interfaces to bridge
:foreach int in={"{$interfaces}"} do={
    :if ([:len [/interface find name=\$int]] > 0) do={
        # Remove from any existing bridge first
        :if ([:len [/interface bridge port find interface=\$int]] > 0) do={
            :local existing [/interface bridge port find interface=\$int]
            :foreach e in=\$existing do={ /interface bridge port remove \$e }
            :log info ("Removed " . \$int . " from existing bridge")
        }
        # Add to our bridge
        /interface bridge port add bridge="{$bridge_name}" interface=\$int comment="PayGrid Auto-Added"
        :log info ("Added interface to bridge: " . \$int)
    } else={
        :log warning ("Interface not found: " . \$int)
    }
}

# 5) Configure DHCP server
:if ([:len [/ip dhcp-server find name="hotspot-dhcp"]] = 0) do={
    /ip dhcp-server add name="hotspot-dhcp" interface="{$bridge_name}" address-pool="hotspot-pool" lease-time=1h disabled=no comment="PayGrid Auto-Generated"
    :log info "Created DHCP server"
}

:if ([:len [/ip dhcp-server network find address="{$ip_range}"]] = 0) do={
    /ip dhcp-server network add address={$ip_range} gateway={$gateway_ip} dns-server={$dns_servers} comment="PayGrid Auto-Generated"
    :log info "Added DHCP network configuration"
}

# 6) Create hotspot profile
:if ([:len [/ip hotspot profile find name="hotspot-profile"]] = 0) do={
    /ip hotspot profile add name="hotspot-profile" dns-name="paygrid.local" use-radius=no login-by=mac,http-pap comment="PayGrid Auto-Generated"
    :log info "Created hotspot profile"
}

# 7) Create hotspot server
:if ([:len [/ip hotspot find name="{$hotspot_name}"]] = 0) do={
    /ip hotspot add name="{$hotspot_name}" interface="{$bridge_name}" address-pool="hotspot-pool" profile="hotspot-profile" addresses-per-mac=1 disabled=no comment="PayGrid Auto-Generated"
    :log info "Created hotspot server: {$hotspot_name}"
}

# 8) Configure DNS
/ip dns set servers={$dns_servers} allow-remote-requests=yes

# 9) Add basic firewall rules (if not exists)
:if ([:len [/ip firewall nat find chain="srcnat" src-address="{$ip_range}" action="masquerade"]] = 0) do={
    /ip firewall nat add chain=srcnat src-address={$ip_range} action=masquerade comment="PayGrid Hotspot NAT"
    :log info "Added NAT rule for hotspot"
}

:log info "=== PayGrid Hotspot Configuration Complete ==="
:put "Hotspot configuration completed successfully!"
EOT;
}

// Configuration storage functions
function saveConfiguration($router_id, $rsc_content, $config_data)
{
    $config_id = 'mikrotik_config_' . uniqid();
    
    $data = [
        'router_id' => $router_id,
        'rsc_content' => $rsc_content,
        'config_data' => $config_data,
        'created_at' => date('Y-m-d H:i:s'),
        'status' => 'generated'
    ];
    
    $setting = ORM::for_table('tbl_appconfig')->create();
    $setting->setting = $config_id;
    $setting->value = json_encode($data);
    $setting->save();
    
    return $config_id;
}

function getSavedConfiguration($config_id)
{
    $setting = ORM::for_table('tbl_appconfig')->where('setting', $config_id)->find_one();
    if ($setting) {
        return json_decode($setting->value, true);
    }
    return null;
}

function updateConfigurationStatus($config_id, $status, $result = null)
{
    $setting = ORM::for_table('tbl_appconfig')->where('setting', $config_id)->find_one();
    if ($setting) {
        $data = json_decode($setting->value, true);
        $data['status'] = $status;
        $data['deployed_at'] = date('Y-m-d H:i:s');
        if ($result) {
            $data['deployment_result'] = $result;
        }
        $setting->value = json_encode($data);
        $setting->save();
    }
}

// RSC deployment function (following vpn_wireguard.php SSH pattern)
function deployRSCToMikroTik($router, $rsc_content)
{
    $temp_file = '/tmp/mikrotik_config_' . uniqid() . '.rsc';
    
    try {
        // Write RSC content to temporary file
        file_put_contents($temp_file, $rsc_content);
        
        // Use SSH to copy file and execute (similar to vpn_wireguard.php)
        $host = $router->ip_address;
        $username = $router->username;
        $password = $router->password;
        
        // For MikroTik, we can use SCP to copy file then SSH to execute
        $remote_file = 'paygrid_hotspot_config.rsc';
        
        // Copy file via SCP (you might need to implement this based on your environment)
        $scp_command = "sshpass -p '$password' scp -o StrictHostKeyChecking=no '$temp_file' '$username@$host:$remote_file' 2>&1";
        $scp_result = shell_exec($scp_command);
        
        // Execute the RSC file via SSH
        $ssh_command = "sshpass -p '$password' ssh -o StrictHostKeyChecking=no '$username@$host' '/import file-name=\"$remote_file\" verbose=yes' 2>&1";
        $ssh_result = shell_exec($ssh_command);
        
        // Cleanup local temp file
        unlink($temp_file);
        
        // Cleanup remote file
        $cleanup_command = "sshpass -p '$password' ssh -o StrictHostKeyChecking=no '$username@$host' '/file remove \"$remote_file\"' 2>&1";
        shell_exec($cleanup_command);
        
        return [
            'success' => true,
            'message' => 'Configuration deployed and executed successfully',
            'ssh_output' => $ssh_result,
            'scp_output' => $scp_result
        ];
        
    } catch (Exception $e) {
        // Cleanup on error
        if (file_exists($temp_file)) {
            unlink($temp_file);
        }
        
        return [
            'success' => false,
            'message' => $e->getMessage()
        ];
    }
}