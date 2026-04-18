{include file="sections/header.tpl"}

<div class="row">
    <div class="col-sm-12">
        <!-- Main Header Card -->
        <div class="device-header">
            <div class="header-content">
                <div class="header-info">
                    <h2 class="device-title">
                        <i class="fa fa-wifi"></i>
                        {$device.pppoe_username}
                        {if $device.status == 'online'}
                            <span class="status-badge online">● Online</span>
                        {else}
                            <span class="status-badge offline">● Offline</span>
                        {/if}
                    </h2>
                    <div class="breadcrumb-nav">
                        <a href="{$_url}plugin/genieacs_devices">Devices</a>
                        <span>/</span>
                        <span>Detail</span>
                    </div>
                </div>

                <!-- Desktop Actions -->
                <div class="header-actions hidden-xs">
                    <div class="action-buttons-group">
                        <button class="btn-action-modern btn-refresh" onclick="refreshDevice('{$device_id}')"
                            title="Refresh device data">
                            <i class="fa fa-refresh"></i>
                            <span>Refresh</span>
                        </button>
                        <button class="btn-action-modern btn-summon" onclick="summonDevice('{$device_id}')"
                            title="Send connection request">
                            <i class="fa fa-bell"></i>
                            <span>Summon</span>
                        </button>
                        <button class="btn-action-modern btn-reboot" onclick="rebootDevice('{$device_id}')"
                            title="Reboot device">
                            <i class="fa fa-power-off"></i>
                            <span>Reboot</span>
                        </button>
                        <a href="{$_url}plugin/genieacs_devices" class="btn-action-modern btn-back"
                            title="Back to device list">
                            <i class="fa fa-arrow-left"></i>
                            <span>Back</span>
                        </a>
                    </div>
                </div>

                <!-- Mobile Menu -->
                <div class="mobile-menu-btn visible-xs">
                    <button class="btn-mobile-menu" data-toggle="dropdown">
                        <i class="fa fa-ellipsis-v"></i>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-right">
                        <li><a href="javascript:void(0)" onclick="refreshDevice('{$device_id}')">
                                <i class="fa fa-refresh"></i> Refresh Device</a></li>
                        <li><a href="javascript:void(0)" onclick="summonDevice('{$device_id}')">
                                <i class="fa fa-bell"></i> Summon Device</a></li>
                        <li class="divider"></li>
                        <li><a href="javascript:void(0)" onclick="rebootDevice('{$device_id}')">
                                <i class="fa fa-power-off"></i> Reboot Device</a></li>
                        <li class="divider"></li>
                        <li><a href="{$_url}plugin/genieacs_devices">
                                <i class="fa fa-arrow-left"></i> Back to List</a></li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Device Information Card -->
        <div class="info-card">
            <div class="card-header">
                <i class="fa fa-info-circle"></i> Device Information
            </div>
            <div class="card-body">
                <!-- Desktop Grid View -->
                <div class="info-grid hidden-xs">
                    {foreach $device as $key => $value}
                        {if !in_array($key, ['status', 'id_raw', 'tags', 'lokasi', 'last_inform', 'wifi_ssid_2g', 'wifi_ssid_5g'])}
                            <div class="info-item">
                                <div class="info-icon">
                                    <i
                                        class="fa {if $key == 'rx_power'}fa-signal{elseif $key == 'ppp_uptime'}fa-clock-o{elseif $key == 'pon_type'}fa-plug{elseif $key == 'pppoe_ip'}fa-globe{elseif $key == 'ppp_mac'}fa-barcode{elseif $key == 'ppp_username'}fa-user{elseif $key == 'model'}fa-cube{elseif $key == 'vendor'}fa-building{elseif $key == 'serial_number'}fa-key{else}fa-info{/if}"></i>
                                </div>
                                <div class="info-content">
                                    <label>{if isset($device_info_labels[$key])}{$device_info_labels[$key]}{else}{$key|replace:'_':' '|ucwords}{/if}</label>
                                    <span
                                        class="{if $key == 'rx_power' && $value != 'N/A'}{assign var="rx_val" value=floatval($value)}{if $rx_val > -20}text-success{elseif $rx_val > -25}text-warning{else}text-danger{/if}{/if}">
                                        {$value|default:'N/A'}
                                    </span>
                                </div>
                            </div>
                        {/if}
                    {/foreach}
                    <div class="info-item">
                        <div class="info-icon">
                            <i class="fa fa-calendar"></i>
                        </div>
                        <div class="info-content">
                            <label>Last Inform</label>
                            <span>{$device.last_inform}</span>
                        </div>
                    </div>
                    {if $device.tags}
                        <div class="info-item">
                            <div class="info-icon">
                                <i class="fa fa-tag"></i>
                            </div>
                            <div class="info-content">
                                <label>Tags</label>
                                <span>{$device.tags}</span>
                            </div>
                        </div>
                    {/if}
                </div>

                <!-- Mobile Compact View -->
                <div class="mobile-info visible-xs">
                    {foreach $device as $key => $value}
                        {if !in_array($key, ['status', 'id_raw', 'tags', 'lokasi', 'last_inform', 'wifi_ssid_2g', 'wifi_ssid_5g'])}
                            <div class="mobile-info-row">
                                <span class="info-label">{if isset($device_info_labels[$key])}{$device_info_labels[$key]}{else}{$key|replace:'_':' '|ucwords}{/if}:</span>
                                <span
                                    class="info-value {if $key == 'rx_power' && $value != 'N/A'}{assign var="rx_val" value=floatval($value)}{if $rx_val > -20}text-success{elseif $rx_val > -25}text-warning{else}text-danger{/if}{/if}">
                                    {$value|default:'N/A'}
                                </span>
                            </div>
                        {/if}
                    {/foreach}
                    <div class="mobile-info-row">
                        <span class="info-label">Last Inform:</span>
                        <span class="info-value">{$device.last_inform}</span>
                    </div>
                    {if $device.tags}
                        <div class="mobile-info-row">
                            <span class="info-label">Tags:</span>
                            <span class="info-value">{$device.tags}</span>
                        </div>
                    {/if}
                </div>
            </div>
        </div>

        <!-- WiFi Section -->
        <div class="row">
            <!-- WiFi Information -->
            <div class="col-md-6">
                <div class="info-card">
                    <div class="card-header wifi-header">
                        <i class="fa fa-wifi"></i> WiFi Information
                    </div>
                    <div class="card-body">
                        {foreach $wifi_info as $wifi_key => $wifi_value}
                            {if !in_array($wifi_key, ['wifi_2g_enabled', 'wifi_5g_enabled'])}
                                <div class="wifi-row">
                                    <span class="wifi-label">{if isset($wifi_info_labels[$wifi_key])}{$wifi_info_labels[$wifi_key]}{else}{$wifi_key|replace:'_':' '|ucwords}{/if}:</span>
                                    {if strpos($wifi_key, 'password') !== false}
                                        <div class="password-group">
                                            <span id="wifi-password" style="display: none;">{$wifi_value|default:'N/A'}</span>
                                            <span id="wifi-password-hidden">••••••••</span>
                                            <button class="btn-eye" onclick="togglePassword()">
                                                <i class="fa fa-eye" id="password-icon"></i>
                                            </button>
                                        </div>
                                    {elseif strpos($wifi_key, 'total') !== false || strpos($wifi_key, 'connected') !== false}
                                        <span class="device-badge">{$wifi_value|default:0} devices</span>
                                    {else}
                                        <span class="wifi-value">{$wifi_value|default:'N/A'}</span>
                                    {/if}
                                </div>
                            {/if}
                        {/foreach}
                    </div>
                </div>

                <!-- Tags Management Card -->
                <div class="info-card" style="margin-top: 20px;">
                    <div class="card-header tags-header">
                        <i class="fa fa-tags"></i> Device Tags
                        <button class="btn-refresh-small pull-right" onclick="toggleTagsEdit()">
                            <i class="fa fa-edit"></i>
                        </button>
                    </div>
                    <div class="card-body">
                        <!-- Display existing tags -->
                        <div id="tags-display">
                            <div class="tags-container">
                                {* Use all_tags if available, fallback to tags *}
                                {assign var="tags_to_display" value=$device.all_tags|default:$device.tags}

                                {if $tags_to_display && $tags_to_display != 'N/A'}
                                    {if strpos($tags_to_display, ', ') !== false}
                                        {* Comma with space *}
                                        {assign var="tags_array" value=", "|explode:$tags_to_display}
                                    {elseif strpos($tags_to_display, ',') !== false}
                                        {* Just comma *}
                                        {assign var="tags_array" value=","|explode:$tags_to_display}
                                    {else}
                                        {* Single tag or use both tags and lokasi *}
                                        {if $device.lokasi && $device.lokasi != 'N/A'}
                                            {assign var="tags_array" value=[$device.tags, $device.lokasi]}
                                        {else}
                                            {assign var="tags_array" value=[$tags_to_display]}
                                        {/if}
                                    {/if}

                                    {foreach $tags_array as $tag}
                                        {if $tag|trim != ''}
                                            <span class="tag-badge">
                                                <i class="fa fa-tag"></i> {$tag|trim}
                                            </span>
                                        {/if}
                                    {/foreach}
                                {else}
                                    <span class="no-tags">No tags assigned</span>
                                {/if}
                            </div>
                        </div>

                        <!-- Edit tags form (hidden by default) -->
                        <div id="tags-edit-form" style="display: none;">
                            <form id="tags-form">
                                <div class="form-group">
                                    <label><i class="fa fa-user" style="color: #5bc0de;"></i> Username Tag <span
                                            class="required"></span></label>
                                    <input type="text" id="tag1" name="tag1" class="form-control modern-input"
                                        placeholder="Enter customer username" value="">
                                    <small class="help-text">Customer or username identifier</small>
                                </div>
                                <div class="form-group">
                                    <label><i class="fa fa-map-marker" style="color: #f0ad4e;"></i> Location Tag</label>
                                    <input type="text" id="tag2" name="tag2" class="form-control modern-input"
                                        placeholder="Enter location or area" value="">
                                    <small class="help-text">Location identifier</small>
                                </div>
                                <div class="tags-button-group">
                                    <button type="submit" class="btn-tags-save">
                                        <i class="fa fa-save"></i> Save
                                    </button>
                                    <button type="button" class="btn-tags-cancel" onclick="cancelTagsEdit()">
                                        <i class="fa fa-times"></i> Cancel
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- WiFi Settings -->
            <div class="col-md-6">
                <div class="info-card">
                    <div class="card-header settings-header">
                        <i class="fa fa-cog"></i> WiFi Settings
                    </div>
                    <div class="card-body">
                        <form id="wifi-form">
                            <div class="form-group">
                                <label>New SSID <span class="required">*</span></label>
                                {assign var="ssid_value" value=""}
                                {foreach $wifi_info as $k => $v}
                                    {if strpos($k, 'ssid') !== false && strpos($k, '2g') !== false}
                                        {assign var="ssid_value" value=$v}
                                        {break}
                                    {/if}
                                {/foreach}
                                <input type="text" name="ssid" class="form-control modern-input" value="{$ssid_value}"
                                    required>
                                <small class="help-text">5GHz will automatically add "-5G" suffix</small>
                            </div>

                            <div class="form-group">
                                <label>New Password</label>
                                <div class="password-input-group">
                                    <input type="password" name="password" id="wifi-password-input"
                                        class="form-control modern-input" placeholder="Leave empty to keep current"
                                        minlength="8">
                                    <button type="button" class="btn-show-password" onclick="toggleWifiPasswordInput()">
                                        <i class="fa fa-eye" id="wifi-password-input-icon"></i>
                                    </button>
                                </div>
                                <small class="help-text">Min 8 chars, leave empty to keep current</small>
                            </div>

                            <div class="form-group">
                                <label>Force WPA/WPA2 Security</label>
                                <div class="toggle-switch-container">
                                    <label class="toggle-switch">
                                        <input type="checkbox" id="force_security" name="force_security">
                                        <span class="toggle-slider"></span>
                                    </label>
                                    <span class="toggle-label">Enable to force WPA/WPA2 security mode</span>
                                </div>
                                <small class="help-text">Turn ON if device is using Basic/Open security. This will
                                    change security to WPA/WPA2 before updating password.</small>
                            </div>

                            <button type="submit" class="btn-submit">
                                <i class="fa fa-save"></i> Update WiFi Settings
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Web Admin Section -->
        <div class="info-card">
            <div class="card-header admin-header">
                <i class="fa fa-lock"></i> Web Admin Credentials
                <div class="pull-right">
                    <button class="btn-refresh-small" onclick="refreshWebAdmin()">
                        <i class="fa fa-refresh"></i>
                    </button>
                    <button class="btn-refresh-small" onclick="toggleAdminEdit()">
                        <i class="fa fa-edit"></i>
                    </button>
                </div>
            </div>
            <div class="card-body">
                <div id="admin-display">
                    <div class="admin-info-grid">
                        <div class="admin-info-item">
                            <label>Super Admin Username</label>
                            <span>{$web_admin.super_username}</span>
                        </div>
                        <div class="admin-info-item">
                            <label>Super Admin Password</label>
                            <div class="password-display-group">
                                <span id="super-pass-display" style="display: none;">{$web_admin.super_password}</span>
                                <span
                                    id="super-pass-hidden">{if $web_admin.super_password}••••••••{else}(empty){/if}</span>
                                {if $web_admin.super_password}
                                    <button class="btn-eye-small" onclick="toggleSuperPassDisplay()">
                                        <i class="fa fa-eye" id="super-pass-icon"></i>
                                    </button>
                                {/if}
                            </div>
                        </div>
                        <div class="admin-info-item">
                            <label>User Username</label>
                            <span>{$web_admin.user_username}</span>
                        </div>
                        <div class="admin-info-item">
                            <label>User Password</label>
                            <div class="password-display-group">
                                <span id="user-pass-display" style="display: none;">{$web_admin.user_password}</span>
                                <span
                                    id="user-pass-hidden">{if $web_admin.user_password}••••••••{else}(empty){/if}</span>
                                {if $web_admin.user_password}
                                    <button class="btn-eye-small" onclick="toggleUserPassDisplay()">
                                        <i class="fa fa-eye" id="user-pass-icon"></i>
                                    </button>
                                {/if}
                            </div>
                        </div>
                    </div>
                </div>

                <div id="admin-edit-form" class="admin-edit-container" style="display: none;">
                    <form id="admin-credentials-form">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>Super Admin Username</label>
                                    <input type="text" id="super_username" name="super_username"
                                        class="form-control modern-input"
                                        value="{$web_admin.super_username|default:'admin'}">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>Super Admin Password</label>
                                    <div class="password-input-group">
                                        <input type="password" id="super_password" name="super_password"
                                            class="form-control modern-input" placeholder="Enter password"
                                            value="{$web_admin.super_password}">
                                        <button type="button" class="btn-show-password" onclick="toggleSuperPassword()">
                                            <i class="fa fa-eye" id="super-password-icon"></i>
                                        </button>
                                    </div>
                                    <small class="help-text">Current from database</small>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>User Username</label>
                                    <input type="text" id="user_username" name="user_username"
                                        class="form-control modern-input"
                                        value="{$web_admin.user_username|default:'user'}">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>User Password</label>
                                    <div class="password-input-group">
                                        <input type="password" id="user_password" name="user_password"
                                            class="form-control modern-input" placeholder="Enter password"
                                            value="{$web_admin.user_password}">
                                        <button type="button" class="btn-show-password" onclick="toggleUserPassword()">
                                            <i class="fa fa-eye" id="user-password-icon"></i>
                                        </button>
                                    </div>
                                    <small class="help-text">Current from database</small>
                                </div>
                            </div>
                        </div>

                        <div class="form-group" style="margin-top: 20px;">
                            <button type="submit" class="btn btn-success">
                                <i class="fa fa-save"></i> Update Credentials
                            </button>
                            <button type="button" class="btn btn-danger" onclick="cancelAdminEdit()">
                                <i class="fa fa-times"></i> Cancel
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Connected Users -->
        <div class="info-card">
            <div class="card-header users-header">
                <i class="fa fa-users"></i> Connected Users
                <span class="count-badge">{count($connected_users)}</span>
                <button class="btn-refresh-small pull-right" onclick="refreshUsers()">
                    <i class="fa fa-refresh"></i>
                </button>
            </div>
            <div class="card-body">
                {if count($connected_users) > 0}
                    <!-- Desktop Table -->
                    <div class="table-responsive hidden-xs">
                        <table class="modern-table">
                            <thead>
                                <tr>
                                    <th>Device Name</th>
                                    <th>IP Address</th>
                                    <th>MAC Address</th>
                                    <th>Connection</th>
                                    <th>Interface</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach $connected_users as $user}
                                    <tr>
                                        <td>{if $user.hostname && $user.hostname != ''}{$user.hostname}{else}Unknown Device{/if}
                                        </td>
                                        <td>{$user.ip}</td>
                                        <td class="mono">{$user.mac}</td>
                                        <td>
                                            {if $user.connection_type == 'WiFi 2.4GHz'}
                                                <span class="conn-badge wifi2">2.4GHz</span>
                                            {elseif $user.connection_type == 'WiFi 5GHz'}
                                                <span class="conn-badge wifi5">5GHz</span>
                                            {elseif $user.connection_type == 'Ethernet'}
                                                <span class="conn-badge lan">LAN</span>
                                            {else}
                                                <span class="conn-badge">{$user.connection_type}</span>
                                            {/if}
                                        </td>
                                        <td>{$user.interface}</td>
                                    </tr>
                                {/foreach}
                            </tbody>
                        </table>
                    </div>

                    <!-- Mobile Cards -->
                    <div class="visible-xs">
                        {foreach $connected_users as $user}
                            <div class="user-card-mobile">
                                <div class="user-card-header">
                                    <strong>{if $user.hostname && $user.hostname != ''}{$user.hostname}
                                        {else}Unknown
                                        Device{/if}</strong>
                                    {if $user.connection_type == 'WiFi 2.4GHz'}
                                        <span class="conn-badge wifi2">2.4G</span>
                                    {elseif $user.connection_type == 'WiFi 5GHz'}
                                        <span class="conn-badge wifi5">5G</span>
                                    {elseif $user.connection_type == 'Ethernet'}
                                        <span class="conn-badge lan">LAN</span>
                                    {else}
                                        <span class="conn-badge">{$user.connection_type}</span>
                                    {/if}
                                </div>
                                <div class="user-card-body">
                                    <div class="user-info-row">
                                        <span>IP:</span> {$user.ip}
                                    </div>
                                    <div class="user-info-row">
                                        <span>MAC:</span> {$user.mac}
                                    </div>
                                </div>
                            </div>
                        {/foreach}
                    </div>
                {else}
                    <div class="empty-state">
                        <i class="fa fa-user-times"></i>
                        <p>No connected users found</p>
                    </div>
                {/if}
            </div>
        </div>
    </div>
</div>

<style>
    

    /* Professional Design System */
    .device-header {
        background: #ffffff;
        border: 1px solid #dee2e6;
        border-radius: 8px;
        padding: 20px;
        margin-bottom: 20px;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
    }

    .header-content {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .device-title {
        margin: 0;
        font-size: 24px;
        font-weight: 600;
        color: #212529;
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .device-title i {
        color: #0056b3;
    }

    .status-badge {
        font-size: 13px;
        padding: 4px 10px;
        border-radius: 4px;
        font-weight: 500;
    }

    .status-badge.online {
        background: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
    }

    .status-badge.offline {
        background: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
    }

    .breadcrumb-nav {
        font-size: 13px;
        color: #6c757d;
        margin-top: 5px;
    }

    .breadcrumb-nav a {
        color: #0056b3;
        text-decoration: none;
    }

    .breadcrumb-nav a:hover {
        text-decoration: underline;
    }

    /* Professional Glass Action Buttons - Both Light & Dark */
    .action-buttons-group {
        display: flex;
        gap: 10px;
        align-items: center;
    }

    .btn-action-modern {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        padding: 9px 16px;
        border: 1px solid;
        border-radius: 5px;
        font-size: 14px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.2s ease;
        text-decoration: none !important;
        backdrop-filter: blur(10px);
        -webkit-backdrop-filter: blur(10px);
    }

    .btn-action-modern i {
        font-size: 14px;
    }

    .btn-action-modern:hover {
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    }

    /* Override old styles - Light mode Glass effect */
    .btn-action-modern.btn-refresh {
        background: rgba(255, 255, 255, 0.7) !important;
        color: #5dade2 !important;
        border-color: #5dade2 !important;
    }

    .btn-action-modern.btn-refresh:hover {
        background: #5dade2 !important;
        color: white !important;
        border-color: #3498db !important;
    }

    .btn-action-modern.btn-summon {
        background: rgba(255, 255, 255, 0.7) !important;
        color: #58d68d !important;
        border-color: #58d68d !important;
    }

    .btn-action-modern.btn-summon:hover {
        background: #58d68d !important;
        color: white !important;
        border-color: #2ecc71 !important;
    }

    .btn-action-modern.btn-reboot {
        background: rgba(255, 255, 255, 0.7) !important;
        color: #ec7063 !important;
        border-color: #ec7063 !important;
    }

    .btn-action-modern.btn-reboot:hover {
        background: #ec7063 !important;
        color: white !important;
        border-color: #e74c3c !important;
    }

    .btn-action-modern.btn-back {
        background: rgba(255, 255, 255, 0.7) !important;
        color: #95a5a6 !important;
        border-color: #95a5a6 !important;
    }

    .btn-action-modern.btn-back:hover {
        background: #95a5a6 !important;
        color: white !important;
        border-color: #7f8c8d !important;
    }

    /* Dark mode - Same glass effect */
    .dark-mode .btn-action-modern,
    body.dark-mode .btn-action-modern {
        backdrop-filter: blur(10px);
        -webkit-backdrop-filter: blur(10px);
    }

    .dark-mode .btn-action-modern.btn-refresh,
    body.dark-mode .btn-action-modern.btn-refresh {
        background: rgba(44, 62, 80, 0.7) !important;
        color: #5dade2 !important;
        border-color: #5dade2 !important;
    }

    .dark-mode .btn-action-modern.btn-refresh:hover,
    body.dark-mode .btn-action-modern.btn-refresh:hover {
        background: #5dade2 !important;
        color: white !important;
        border-color: #3498db !important;
    }

    .dark-mode .btn-action-modern.btn-summon,
    body.dark-mode .btn-action-modern.btn-summon {
        background: rgba(44, 62, 80, 0.7) !important;
        color: #58d68d !important;
        border-color: #58d68d !important;
    }

    .dark-mode .btn-action-modern.btn-summon:hover,
    body.dark-mode .btn-action-modern.btn-summon:hover {
        background: #58d68d !important;
        color: white !important;
        border-color: #2ecc71 !important;
    }

    .dark-mode .btn-action-modern.btn-reboot,
    body.dark-mode .btn-action-modern.btn-reboot {
        background: rgba(44, 62, 80, 0.7) !important;
        color: #ec7063 !important;
        border-color: #ec7063 !important;
    }

    .dark-mode .btn-action-modern.btn-reboot:hover,
    body.dark-mode .btn-action-modern.btn-reboot:hover {
        background: #ec7063 !important;
        color: white !important;
        border-color: #e74c3c !important;
    }

    .dark-mode .btn-action-modern.btn-back,
    body.dark-mode .btn-action-modern.btn-back {
        background: rgba(44, 62, 80, 0.7) !important;
        color: #95a5a6 !important;
        border-color: #95a5a6 !important;
    }

    .dark-mode .btn-action-modern.btn-back:hover,
    body.dark-mode .btn-action-modern.btn-back:hover {
        background: #95a5a6 !important;
        color: white !important;
        border-color: #7f8c8d !important;
    }

    /* Keep original mobile menu style */
    .btn-mobile-menu {
        background: white;
        border: 1px solid #dee2e6;
        border-radius: 4px;
        padding: 8px 12px;
        cursor: pointer;
        color: #495057;
        transition: all 0.2s;
    }

    .btn-mobile-menu:hover {
        background: #f8f9fa;
        border-color: #adb5bd;
    }

    .dark-mode .btn-mobile-menu,
    body.dark-mode .btn-mobile-menu {
        background: #2c3e50;
        border-color: #495a6b;
        color: #ecf0f1;
    }

    .dark-mode .btn-mobile-menu:hover,
    body.dark-mode .btn-mobile-menu:hover {
        background: #34495e;
        border-color: #5a6c7d;
    }

    /* Responsive adjustments */
    @media (max-width: 991px) {
        .btn-action-modern {
            padding: 7px 12px;
            font-size: 13px;
        }

        .btn-action-modern i {
            font-size: 13px;
        }
    }

    .btn-refresh {
        background: #0056b3;
        border-color: #0056b3;
        color: white;
    }

    .btn-refresh:hover {
        background: #004494;
        border-color: #004494;
    }

    .btn-summon {
        background: #ffc107;
        border-color: #ffc107;
        color: #212529;
    }

    .btn-summon:hover {
        background: #e0a800;
        border-color: #d39e00;
    }

    .btn-reboot {
        background: #dc3545;
        border-color: #dc3545;
        color: white;
    }

    .btn-reboot:hover {
        background: #c82333;
        border-color: #bd2130;
    }

    .btn-back {
        background: #6c757d;
        border-color: #6c757d;
        color: white;
    }

    .btn-back:hover {
        background: #5a6268;
        border-color: #545b62;
        color: white;
    }

    .btn-mobile-menu {
        background: white;
        border: 1px solid #dee2e6;
        border-radius: 4px;
        padding: 8px 12px;
        cursor: pointer;
    }

    /* Info Cards */
    .info-card {
        background: #ffffff;
        border: 1px solid #dee2e6;
        border-radius: 8px;
        margin-bottom: 20px;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        overflow: hidden;
    }

    .card-header {
        padding: 15px 20px;
        background: #f8f9fa;
        color: #495057;
        font-weight: 600;
        font-size: 15px;
        display: flex;
        align-items: center;
        gap: 10px;
        border-bottom: 1px solid #dee2e6;
    }

    .wifi-header {
        background: #e7f3ff;
        color: #004085;
        border-bottom: 1px solid #b8daff;
    }

    .settings-header {
        background: #e7f3ff;
        color: #004085;
        border-bottom: 1px solid #b8daff;
    }

    .dark-mode .settings-header,
    body.dark-mode .settings-header {
        background: #161b22;
        color: #58a6ff !important;
        border-bottom: 1px solid #30363d;
    }

    .users-header {
        background: #d1ecf1;
        color: #0c5460;
        border-bottom: 1px solid #bee5eb;
    }

    /* Web Admin Section Styles */
    .admin-header {
        background: #e7f3ff;
        color: #004085;
        border-bottom: 1px solid #b8daff;
    }

    .dark-mode .admin-header,
    body.dark-mode .admin-header {
        background: #161b22;
        color: #58a6ff !important;
        border-bottom: 1px solid #30363d;
    }

    .admin-info-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
        gap: 15px;
    }

    .admin-info-item {
        padding: 10px;
        background: #f8f9fa;
        border: 1px solid #e9ecef;
        border-radius: 4px;
    }

    .password-display-group {
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .btn-eye-small {
        background: transparent;
        border: 1px solid #dee2e6;
        border-radius: 4px;
        padding: 2px 6px;
        cursor: pointer;
        font-size: 12px;
        color: #495057;
        transition: all 0.2s;
    }

    .btn-eye-small:hover {
        background: #f8f9fa;
    }

    /* Dark mode support */
    .dark-mode .btn-eye-small,
    body.dark-mode .btn-eye-small {
        border-color: #30363d;
        color: #8b949e;
    }

    .dark-mode .btn-eye-small:hover,
    body.dark-mode .btn-eye-small:hover {
        background: #21262d;
    }

    .admin-info-item label {
        display: block;
        font-size: 11px;
        color: #6c757d;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        margin-bottom: 5px;
    }

    .admin-info-item span {
        font-size: 14px;
        font-weight: 600;
        color: #212529;
    }

    .admin-edit-container {
        padding: 15px;
        background: #f8f9fa;
        border-radius: 6px;
        margin-top: 15px;
    }

    /* Dark mode for Web Admin */
    .dark-mode .admin-info-item,
    body.dark-mode .admin-info-item {
        background: #0d1117;
        border-color: #30363d;
    }

    .dark-mode .admin-info-item label,
    body.dark-mode .admin-info-item label {
        color: #8b949e;
    }

    .dark-mode .admin-info-item span,
    body.dark-mode .admin-info-item span {
        color: #e6edf3;
    }

    .dark-mode .admin-edit-container,
    body.dark-mode .admin-edit-container {
        background: #161b22;
    }

    .dark-mode #admin-edit-form .modern-input,
    body.dark-mode #admin-edit-form .modern-input {
        background: #0d1117 !important;
        border-color: #30363d !important;
        color: #e6edf3 !important;
    }

    .dark-mode #admin-edit-form .modern-input:focus,
    body.dark-mode #admin-edit-form .modern-input:focus {
        background: #0d1117 !important;
        border-color: #58a6ff !important;
        color: #e6edf3 !important;
    }

    .card-body {
        padding: 20px;
    }

    /* Info Grid */
    .info-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
        gap: 15px;
    }

    .info-item {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 12px;
        background: #f8f9fa;
        border: 1px solid #e9ecef;
        border-radius: 6px;
        transition: all 0.2s;
    }

    .info-item:hover {
        background: #e9ecef;
        border-color: #dee2e6;
    }

    .info-icon {
        width: 36px;
        height: 36px;
        background: #0056b3;
        border-radius: 6px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
    }

    .info-content label {
        display: block;
        font-size: 11px;
        color: #6c757d;
        margin-bottom: 2px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    /* Fix overflow text */
    .info-content span {
        font-size: 14px;
        font-weight: 600;
        color: #212529;
        word-break: break-all;
        display: block;
    }

    .wan-info-item span {
        font-size: 14px;
        font-weight: 600;
        color: #212529;
        word-break: break-all;
        display: block;
        max-width: 100%;
    }

    /* Mobile Info */
    .mobile-info {
        display: none;
    }

    .mobile-info-row {
        display: flex;
        justify-content: space-between;
        padding: 10px 0;
        border-bottom: 1px solid #e9ecef;
    }

    .mobile-info-row:last-child {
        border-bottom: none;
    }

    .info-label {
        font-weight: 600;
        color: #6c757d;
        font-size: 13px;
    }

    .info-value {
        color: #212529;
        font-size: 13px;
        text-align: right;
    }

    /* WiFi Styles */
    .wifi-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 10px 0;
        border-bottom: 1px solid #e9ecef;
    }

    .wifi-row:last-child {
        border-bottom: none;
    }

    .wifi-label {
        font-weight: 600;
        color: #6c757d;
        font-size: 13px;
    }

    .wifi-value {
        color: #212529;
        font-size: 13px;
    }

    .password-group {
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .btn-eye {
        background: white;
        border: 1px solid #dee2e6;
        border-radius: 4px;
        padding: 4px 8px;
        cursor: pointer;
        color: #495057;
        transition: all 0.2s;
    }

    .btn-eye:hover {
        background: #f8f9fa;
    }

    .device-badge {
        background: #007bff;
        color: white;
        padding: 3px 10px;
        border-radius: 12px;
        font-size: 12px;
    }

    /* Form Styles */
    .modern-input {
        border: 1px solid #ced4da;
        border-radius: 4px;
        padding: 8px 12px;
        transition: all 0.2s;
    }

    .modern-input:focus {
        border-color: #80bdff;
        box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
        outline: none;
    }

    .help-text {
        color: #6c757d;
        font-size: 12px;
        margin-top: 5px;
    }

    .btn-submit {
        width: 100%;
        padding: 10px;
        background: #28a745;
        color: white;
        border: 1px solid #28a745;
        border-radius: 4px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s;
    }

    .btn-submit:hover {
        background: #218838;
        border-color: #1e7e34;
    }

    /* Table Styles */
    .modern-table {
        width: 100%;
        border-collapse: collapse;
    }

    .modern-table thead {
        background: #f8f9fa;
    }

    .modern-table th {
        padding: 12px;
        text-align: left;
        font-size: 13px;
        color: #6c757d;
        font-weight: 600;
        border-bottom: 2px solid #dee2e6;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .modern-table td {
        padding: 12px;
        border-bottom: 1px solid #e9ecef;
        font-size: 13px;
        color: #212529;
    }

    .modern-table tr:hover {
        background: #f8f9fa;
    }

    .conn-badge {
        padding: 3px 8px;
        border-radius: 4px;
        font-size: 11px;
        font-weight: 600;
        color: white;
    }

    .conn-badge.wifi2 {
        background: #17a2b8;
    }

    .conn-badge.wifi5 {
        background: #007bff;
    }

    .conn-badge.lan {
        background: #28a745;
    }

    /* Mobile User Cards */
    .user-card-mobile {
        background: #f8f9fa;
        border: 1px solid #e9ecef;
        border-radius: 6px;
        padding: 12px;
        margin-bottom: 10px;
    }

    .user-card-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 8px;
    }

    .user-card-body {
        font-size: 12px;
        color: #6c757d;
    }

    .user-info-row {
        margin-bottom: 3px;
    }

    /* Utilities */
    .count-badge {
        background: rgba(0, 0, 0, 0.1);
        padding: 2px 8px;
        border-radius: 10px;
        font-size: 12px;
        margin-left: auto;
    }

    .btn-refresh-small {
        background: transparent;
        border: 1px solid rgba(0, 0, 0, 0.1);
        color: inherit;
        padding: 4px 8px;
        border-radius: 4px;
        cursor: pointer;
    }

    .btn-refresh-small:hover {
        background: rgba(0, 0, 0, 0.05);
    }

    .empty-state {
        text-align: center;
        padding: 40px;
        color: #6c757d;
    }

    .empty-state i {
        font-size: 48px;
        opacity: 0.3;
        margin-bottom: 10px;
    }

    .required {
        color: #dc3545;
    }

    .mono {
        font-family: 'Courier New', monospace;
        font-size: 12px;
    }

    .text-success {
        color: #28a745;
    }

    .text-warning {
        color: #ffc107;
    }

    .text-danger {
        color: #dc3545;
    }

    /* Dark Mode Support */
    .dark-mode .device-header,
    body.dark-mode .device-header,
    .dark-mode .info-card,
    body.dark-mode .info-card {
        background: #1a1d21;
        border-color: #30363d;
    }

    .dark-mode .device-title,
    body.dark-mode .device-title {
        color: #e6edf3;
    }

    .dark-mode .breadcrumb-nav,
    body.dark-mode .breadcrumb-nav {
        color: #8b949e;
    }

    .dark-mode .breadcrumb-nav a,
    body.dark-mode .breadcrumb-nav a {
        color: #58a6ff;
    }

    .dark-mode .status-badge.online,
    body.dark-mode .status-badge.online {
        background: #1b2f23;
        color: #3fb950;
        border-color: #238636;
    }

    .dark-mode .status-badge.offline,
    body.dark-mode .status-badge.offline {
        background: #2d1f20;
        color: #f85149;
        border-color: #da3633;
    }

    .dark-mode .btn-mobile-menu,
    body.dark-mode .btn-mobile-menu {
        background: #21262d;
        border-color: #30363d;
        color: #e6edf3;
    }

    .dark-mode .dropdown-menu,
    body.dark-mode .dropdown-menu {
        background: #161b22;
        border-color: #30363d;
    }

    .dark-mode .dropdown-menu>li>a,
    body.dark-mode .dropdown-menu>li>a {
        color: #e6edf3;
    }

    .dark-mode .dropdown-menu>li>a:hover,
    body.dark-mode .dropdown-menu>li>a:hover {
        background: #21262d;
    }

    .dark-mode .card-header,
    body.dark-mode .card-header {
        background: #161b22;
        border-color: #30363d;
        color: #e6edf3;
    }

    .dark-mode .wifi-header,
    body.dark-mode .wifi-header {
        background: #161b22;
        color: #58a6ff;
    }

    .dark-mode .settings-header,
    body.dark-mode .settings-header {
        background: #161b22;
        color: #d29922;
    }

    .dark-mode .users-header,
    body.dark-mode .users-header {
        background: #161b22;
        color: #79c0ff;
    }

    .dark-mode .card-body,
    body.dark-mode .card-body {
        background: #1a1d21;
    }

    .dark-mode .info-item,
    body.dark-mode .info-item {
        background: #0d1117;
        border-color: #30363d;
    }

    .dark-mode .info-item:hover,
    body.dark-mode .info-item:hover {
        background: #161b22;
    }

    .dark-mode .info-icon,
    body.dark-mode .info-icon {
        background: #1f6feb;
    }

    .dark-mode .info-content label,
    body.dark-mode .info-content label {
        color: #8b949e;
    }

    .dark-mode .info-content span,
    body.dark-mode .info-content span,
    .dark-mode .info-value,
    body.dark-mode .info-value,
    .dark-mode .wifi-value,
    body.dark-mode .wifi-value {
        color: #e6edf3;
    }

    .dark-mode .mobile-info-row,
    body.dark-mode .mobile-info-row,
    .dark-mode .wifi-row,
    body.dark-mode .wifi-row {
        border-color: #30363d;
    }

    .dark-mode .btn-eye,
    body.dark-mode .btn-eye {
        background: #21262d;
        border-color: #30363d;
        color: #e6edf3;
    }

    .dark-mode .btn-eye:hover,
    body.dark-mode .btn-eye:hover {
        background: #30363d;
    }

    .dark-mode .modern-input,
    body.dark-mode .modern-input {
        background: #0d1117;
        border-color: #30363d;
        color: #e6edf3;
    }

    .dark-mode .modern-input:focus,
    body.dark-mode .modern-input:focus {
        border-color: #58a6ff;
        box-shadow: 0 0 0 0.2rem rgba(88, 166, 255, 0.25);
    }

    .dark-mode .modern-table thead,
    body.dark-mode .modern-table thead {
        background: #0d1117;
        /* Darker background, same as body */
        border-bottom: 2px solid #30363d;
    }

    /* Fix specific for first column (Device Name) background */
    .dark-mode .modern-table thead th:first-child,
    body.dark-mode .modern-table thead th:first-child {
        background: #0d1117 !important;
        /* Force dark background */
    }

    /* Also ensure tbody first column matches */
    .dark-mode .modern-table tbody td:first-child,
    body.dark-mode .modern-table tbody td:first-child {
        background: #0d1117 !important;
        /* Same dark background */
    }

    .dark-mode .modern-table th,
    body.dark-mode .modern-table th {
        color: #8b949e;
        border-color: #30363d;
    }

    .dark-mode .modern-table td,
    body.dark-mode .modern-table td {
        border-color: #30363d;
        color: #e6edf3 !important;
        /* Force white text */
        background-color: transparent;
    }

    /* Specific fix for device name column */
    .dark-mode .modern-table tbody td:first-child,
    body.dark-mode .modern-table tbody td:first-child {
        color: #e6edf3 !important;
        /* Ensure device name is white */
        font-weight: 500;
    }

    .dark-mode .modern-table tr:hover,
    body.dark-mode .modern-table tr:hover {
        background: #161b22;
    }

    .dark-mode .user-card-mobile,
    body.dark-mode .user-card-mobile {
        background: #0d1117;
        border-color: #30363d;
        color: #e6edf3;
    }

    .dark-mode .empty-state,
    body.dark-mode .empty-state {
        color: #8b949e;
    }

    .dark-mode .help-text,
    body.dark-mode .help-text {
        color: #8b949e;
    }

    .dark-mode .wan-info-item label,
    body.dark-mode .wan-info-item label {
        color: #8b949e;
    }

    .dark-mode .wan-info-item span,
    body.dark-mode .wan-info-item span {
        color: #e6edf3;
    }

    /* Responsive untuk mobile */
    @media (max-width: 768px) {
        .wan-info-grid {
            grid-template-columns: 1fr;
        }
    }

    .wan-info-item {
        padding: 10px;
        background: #f8f9fa;
        border: 1px solid #e9ecef;
        border-radius: 4px;
    }

    /* Tags Management Styles */
    .tags-header {
        background: #e7f3ff;
        color: #004085;
        border-bottom: 1px solid #b8daff;
    }

    .dark-mode .tags-header,
    body.dark-mode .tags-header {
        background: #161b22;
        color: #58a6ff !important;
        border-bottom: 1px solid #30363d;
    }

    .tags-container {
        display: flex;
        flex-wrap: wrap;
        gap: 8px;
        min-height: 30px;
        align-items: center;
    }

    .tag-badge {
        display: inline-block;
        padding: 5px 12px;
        background: #0056b3;
        color: white;
        border-radius: 16px;
        font-size: 13px;
        font-weight: 500;
    }

    .tag-badge i {
        margin-right: 4px;
        font-size: 11px;
    }

    .no-tags {
        color: #6c757d;
        font-style: italic;
        font-size: 13px;
    }

    .dark-mode .tag-badge,
    body.dark-mode .tag-badge {
        background: #1f6feb;
        color: white;
    }

    .dark-mode .no-tags,
    body.dark-mode .no-tags {
        color: #8b949e;
    }

    /* Tags Form Buttons */
    .btn-tags-save {
        padding: 8px 20px;
        background-color: #28a745;
        color: white;
        border: none;
        border-radius: 4px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: background-color 0.2s;
        margin-right: 10px;
    }

    .btn-tags-save:hover {
        background-color: #218838;
    }

    .btn-tags-save:active {
        transform: translateY(1px);
    }

    .btn-tags-cancel {
        padding: 8px 20px;
        background-color: #dc3545;
        color: white;
        border: none;
        border-radius: 4px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: background-color 0.2s;
    }

    .btn-tags-cancel:hover {
        background-color: #c82333;
    }

    .btn-tags-cancel:active {
        transform: translateY(1px);
    }

    /* Dark mode support for tags buttons */
    .dark-mode .btn-tags-save,
    body.dark-mode .btn-tags-save {
        background-color: #28a745;
        color: white;
        border: 1px solid #28a745;
    }

    .dark-mode .btn-tags-save:hover,
    body.dark-mode .btn-tags-save:hover {
        background-color: #218838;
        border-color: #1e7e34;
    }

    .dark-mode .btn-tags-cancel,
    body.dark-mode .btn-tags-cancel {
        background-color: #dc3545;
        color: white;
        border: 1px solid #dc3545;
    }

    .dark-mode .btn-tags-cancel:hover,
    body.dark-mode .btn-tags-cancel:hover {
        background-color: #c82333;
        border-color: #bd2130;
    }

    /* Tags Button Group Layout */
    .tags-button-group {
        display: flex;
        gap: 10px;
        margin-top: 20px;
        padding-top: 15px;
        border-top: 1px solid #e9ecef;
    }

    .tags-button-group button {
        flex: 1;
        min-width: 80px;
        max-width: 120px;
    }

    /* Dark mode for button group */
    .dark-mode .tags-button-group,
    body.dark-mode .tags-button-group {
        border-top-color: #30363d;
    }

    /* Mobile responsive for tags buttons */
    @media (max-width: 480px) {
        .tags-button-group {
            flex-direction: row;
            gap: 8px;
        }

        .tags-button-group button {
            flex: 1;
            max-width: none;
            font-size: 13px;
            padding: 7px 15px;
        }
    }

    /* Responsive */
    @media (max-width: 767px) {
        .visible-xs {
            display: block !important;
        }

        .hidden-xs {
            display: none !important;
        }

        .mobile-info {
            display: block;
        }

        .header-content {
            position: relative;
        }

        .mobile-menu-btn {
            position: absolute;
            right: 0;
            top: 0;
        }

        .device-title {
            font-size: 18px;
            flex-wrap: wrap;
        }

        .card-body {
            padding: 15px;
        }
    }

    /* Toggle Switch Styles */
    .toggle-switch-container {
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .toggle-switch {
        position: relative;
        display: inline-block;
        width: 50px;
        height: 26px;
    }

    .toggle-switch input {
        opacity: 0;
        width: 0;
        height: 0;
    }

    .toggle-slider {
        position: absolute;
        cursor: pointer;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-color: #ccc;
        transition: .4s;
        border-radius: 26px;
    }

    .toggle-slider:before {
        position: absolute;
        content: "";
        height: 20px;
        width: 20px;
        left: 3px;
        bottom: 3px;
        background-color: white;
        transition: .4s;
        border-radius: 50%;
    }

    .toggle-switch input:checked+.toggle-slider {
        background-color: #28a745;
    }

    .toggle-switch input:checked+.toggle-slider:before {
        transform: translateX(24px);
    }

    .toggle-label {
        font-size: 14px;
        color: #495057;
    }

    /* Dark mode for toggle */
    .dark-mode .toggle-slider,
    body.dark-mode .toggle-slider {
        background-color: #30363d;
    }

    .dark-mode .toggle-switch input:checked+.toggle-slider,
    body.dark-mode .toggle-switch input:checked+.toggle-slider {
        background-color: #238636;
    }

    .dark-mode .toggle-label,
    body.dark-mode .toggle-label {
        color: #e6edf3;
    }

    /* Mobile Dropdown Menu Enhancement */
    .mobile-menu-btn .dropdown-menu {
        border: none;
        border-radius: 8px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
        padding: 8px;
        min-width: 200px;
        margin-top: 10px;
    }

    .mobile-menu-btn .dropdown-menu>li>a {
        padding: 10px 15px;
        border-radius: 6px;
        margin-bottom: 4px;
        transition: all 0.2s;
        font-size: 14px;
        font-weight: 500;
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .mobile-menu-btn .dropdown-menu>li>a i {
        width: 20px;
        text-align: center;
        font-size: 16px;
    }

    /* Refresh option */
    .mobile-menu-btn .dropdown-menu>li:nth-child(1)>a {
        color: #5dade2;
    }

    .mobile-menu-btn .dropdown-menu>li:nth-child(1)>a:hover {
        background: #5dade2;
        color: white;
    }

    /* Summon option */
    .mobile-menu-btn .dropdown-menu>li:nth-child(2)>a {
        color: #58d68d;
    }

    .mobile-menu-btn .dropdown-menu>li:nth-child(2)>a:hover {
        background: #58d68d;
        color: white;
    }

    /* Reboot option */
    .mobile-menu-btn .dropdown-menu>li:nth-child(4)>a {
        color: #ec7063;
    }

    .mobile-menu-btn .dropdown-menu>li:nth-child(4)>a:hover {
        background: #ec7063;
        color: white;
    }

    /* Back option */
    .mobile-menu-btn .dropdown-menu>li:nth-child(6)>a {
        color: #95a5a6;
    }

    .mobile-menu-btn .dropdown-menu>li:nth-child(6)>a:hover {
        background: #95a5a6;
        color: white;
    }

    /* Divider style */
    .mobile-menu-btn .dropdown-menu .divider {
        margin: 8px 0;
        border-top: 1px solid #e9ecef;
    }

    /* Dark mode dropdown */
    .dark-mode .mobile-menu-btn .dropdown-menu,
    body.dark-mode .mobile-menu-btn .dropdown-menu {
        background: #2c3e50;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
    }

    .dark-mode .mobile-menu-btn .dropdown-menu>li>a,
    body.dark-mode .mobile-menu-btn .dropdown-menu>li>a {
        color: #ecf0f1;
    }

    .dark-mode .mobile-menu-btn .dropdown-menu>li:nth-child(1)>a,
    body.dark-mode .mobile-menu-btn .dropdown-menu>li:nth-child(1)>a {
        color: #5dade2;
    }

    .dark-mode .mobile-menu-btn .dropdown-menu>li:nth-child(1)>a:hover,
    body.dark-mode .mobile-menu-btn .dropdown-menu>li:nth-child(1)>a:hover {
        background: #5dade2 !important;
        color: white !important;
    }

    .dark-mode .mobile-menu-btn .dropdown-menu>li:nth-child(2)>a,
    body.dark-mode .mobile-menu-btn .dropdown-menu>li:nth-child(2)>a {
        color: #58d68d;
    }

    .dark-mode .mobile-menu-btn .dropdown-menu>li:nth-child(2)>a:hover,
    body.dark-mode .mobile-menu-btn .dropdown-menu>li:nth-child(2)>a:hover {
        background: #58d68d !important;
        color: white !important;
    }

    .dark-mode .mobile-menu-btn .dropdown-menu>li:nth-child(4)>a,
    body.dark-mode .mobile-menu-btn .dropdown-menu>li:nth-child(4)>a {
        color: #ec7063;
    }

    .dark-mode .mobile-menu-btn .dropdown-menu>li:nth-child(4)>a:hover,
    body.dark-mode .mobile-menu-btn .dropdown-menu>li:nth-child(4)>a:hover {
        background: #ec7063 !important;
        color: white !important;
    }

    .dark-mode .mobile-menu-btn .dropdown-menu>li:nth-child(6)>a,
    body.dark-mode .mobile-menu-btn .dropdown-menu>li:nth-child(6)>a {
        color: #95a5a6;
    }

    .dark-mode .mobile-menu-btn .dropdown-menu>li:nth-child(6)>a:hover,
    body.dark-mode .mobile-menu-btn .dropdown-menu>li:nth-child(6)>a:hover {
        background: #95a5a6 !important;
        color: white !important;
    }

    /* Animation for dropdown */
    .mobile-menu-btn .dropdown-menu {
        animation: slideDown 0.2s ease;
    }

    @keyframes slideDown {
        from {
            opacity: 0;
            transform: translateY(-10px);
        }

        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
</style>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script>
    function togglePassword() {
        var passwordSpan = document.getElementById('wifi-password');
        var hiddenSpan = document.getElementById('wifi-password-hidden');
        var icon = document.getElementById('password-icon');

        if (passwordSpan.style.display === 'none') {
            passwordSpan.style.display = 'inline';
            hiddenSpan.style.display = 'none';
            icon.className = 'fa fa-eye-slash';
        } else {
            passwordSpan.style.display = 'none';
            hiddenSpan.style.display = 'inline';
            icon.className = 'fa fa-eye';
        }
    }

    function toggleWifiPasswordInput() {
        var passwordInput = document.getElementById('wifi-password-input');
        var icon = document.getElementById('wifi-password-input-icon');

        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            icon.className = 'fa fa-eye-slash';
        } else {
            passwordInput.type = 'password';
            icon.className = 'fa fa-eye';
        }
    }

    // Semua fungsi lainnya tetap sama persis seperti file original
    $('#wifi-form').on('submit', function(e) {
        e.preventDefault();

        var ssid = $('input[name="ssid"]').val().trim();
        var password = $('input[name="password"]').val().trim();
        var forceSecurity = $('#force_security').is(':checked');

        if (!ssid) {
            Swal.fire('Error!', 'SSID is required', 'error');
            return;
        }

        if (password && password.length < 8) {
            Swal.fire('Error!',
                'Password must be at least 8 characters (or leave empty to keep current)', 'error');
            return;
        }

        var confirmHTML = '<strong>New 2.4GHz SSID:</strong> ' + ssid + '<br>';
        confirmHTML += '<strong>New 5GHz SSID:</strong> ' + ssid + '-5G<br>';

        if (password) {
            confirmHTML += '<strong>New Password:</strong> ' + password;
        } else {
            confirmHTML += '<strong>Password:</strong> <em>(unchanged)</em>';
        }

        if (forceSecurity) {
            confirmHTML += '<br><strong>Security:</strong> Will be set to WPA/WPA2';
        }

        Swal.fire({
            title: 'Update WiFi Settings?',
            html: confirmHTML,
            icon: 'question',
            showCancelButton: true,
            confirmButtonText: 'Yes, update',
            cancelButtonText: 'Cancel'
        }).then((result) => {
            if (result.isConfirmed) {
                updateWifiSettings(ssid, password, forceSecurity);
            }
        });
    });

    function updateWifiSettings(ssid, password, forceSecurity) {
        console.log('Starting WiFi update...');
        console.log('Force Security:', forceSecurity);

        Swal.fire({
            title: 'Updating WiFi Settings...',
            text: 'Please wait while the router is updated via admin panel',
            allowOutsideClick: false,
            didOpen: () => {
                Swal.showLoading();
            }
        });

        $.ajax({
            url: '{$_url}plugin/genieacs_device_detail/{$device_id_raw}/update-wifi',
            type: 'POST',
            data: {
                ssid: ssid,
                password: password,
                force_security: forceSecurity ? 1 : 0
            },
            dataType: 'json',
            timeout: 30000,
            success: function(response) {
                console.log('Admin update response:', response);

                if (response && response.success) {
                    Swal.fire('Success!',
                        'WiFi settings updated via admin. The system will refresh device data automatically.',
                        'success').then(() => {

                        console.log('Starting auto summon in 5 seconds...');

                        Swal.fire({
                            title: 'Refreshing Device Data...',
                            text: 'Contacting device in 5 seconds',
                            timer: 10000,
                            timerProgressBar: true,
                            allowOutsideClick: false,
                            didOpen: () => {
                                Swal.showLoading();
                            }
                        }).then(() => {
                            console.log('Running summon...');
                            executeAdminAutoSummon();
                        });
                    });
                } else {
                    var errorMsg = 'An unknown error occurred';
                    if (response && response.error) {
                        errorMsg = response.error;
                    }
                    Swal.fire('Error!', errorMsg, 'error');
                }
            },
            error: function(xhr, status, error) {
                console.error('Admin Update AJAX Error:', {
                    status: status,
                    error: error,
                    responseText: xhr.responseText,
                    xhr: xhr
                });

                let errorMessage = 'Failed to communicate with server';
                if (xhr.status === 0) {
                    errorMessage = 'Network error - check your connection';
                } else if (xhr.status === 404) {
                    errorMessage = 'Admin update endpoint not found';
                } else if (xhr.status === 500) {
                    errorMessage = 'Server error occurred';
                } else {
                    try {
                        let response = JSON.parse(xhr.responseText);
                        if (response.error) {
                            errorMessage = response.error;
                        }
                    } catch (e) {
                        errorMessage = 'Server admin memberikan response: ' + xhr.responseText;
                    }
                }
                Swal.fire('Error!', errorMessage, 'error');
            }
        });
    }

    // Semua fungsi lainnya tetap identik dengan original
    function refreshUsers() {
        Swal.fire({
            title: 'Refreshing Users...',
            allowOutsideClick: false,
            didOpen: () => {
                Swal.showLoading();
            }
        });

        $.ajax({
            url: '{$_url}plugin/genieacs_device_detail/{$device_id}/get-users',
            type: 'GET',
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    Swal.fire('Success!', 'User list refreshed', 'success').then(() => {
                        location.reload();
                    });
                } else {
                    Swal.fire('Error!', response.error, 'error');
                }
            },
            error: function(xhr) {
                console.error('AJAX Error:', xhr);
                Swal.fire('Error!', 'Failed to refresh users', 'error');
            }
        });
    }

    function refreshDevice(deviceId) {
        Swal.fire({
            title: 'Refresh Device?',
            text: 'This will refresh all device parameters',
            icon: 'question',
            showCancelButton: true,
            confirmButtonText: 'Yes, refresh!'
        }).then((result) => {
            if (result.isConfirmed) {
                showLoading('Refreshing device...');

                $.ajax({
                    url: '{$_url}plugin/genieacs_devices/refresh',
                    type: 'GET',
                    data: { device_id: '{$device_id_raw}' },
                    dataType: 'json',
                    success: function(response) {
                        if (response.success) {
                            Swal.fire('Success!', response.message, 'success').then(() => {
                                setTimeout(() => {
                                    location.reload();
                                }, 2000);
                            });
                        } else {
                            Swal.fire('Error!', response.error, 'error');
                        }
                    },
                    error: function(xhr) {
                        console.error('AJAX Error:', xhr);
                        Swal.fire('Error!', 'Failed to communicate with server', 'error');
                    }
                });
            }
        });
    }

    function summonDevice(deviceId) {
        Swal.fire({
            title: 'Summon Device?',
            text: 'The system will contact the device and refresh its data',
            icon: 'question',
            showCancelButton: true,
            confirmButtonText: 'Yes, summon',
            cancelButtonText: 'Cancel'
        }).then((result) => {
            if (result.isConfirmed) {
                executeDetailSummonSequence();
            }
        });
    }

    function rebootDevice(deviceId) {
        Swal.fire({
            title: 'Reboot Device?',
            text: 'This will restart the device. Are you sure?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            confirmButtonText: 'Yes, reboot!'
        }).then((result) => {
            if (result.isConfirmed) {
                showLoading('Rebooting device...');

                $.ajax({
                    url: '{$_url}plugin/genieacs_devices/reboot',
                    type: 'GET',
                    data: { device_id: '{$device_id_raw}' },
                    dataType: 'json',
                    success: function(response) {
                        if (response.success) {
                            Swal.fire('Success!', response.message, 'success');
                        } else {
                            Swal.fire('Error!', response.error, 'error');
                        }
                    },
                    error: function(xhr) {
                        console.error('AJAX Error:', xhr);
                        Swal.fire('Error!', 'Failed to communicate with server', 'error');
                    }
                });
            }
        });
    }

    function showLoading(message) {
        Swal.fire({
            title: message,
            allowOutsideClick: false,
            didOpen: () => {
                Swal.showLoading();
            }
        });
    }

    // Semua fungsi auto summon tetap sama persis
    function executeAdminAutoSummon(retryCount = 0) {
        const maxRetries = 2;
        const attempt = retryCount + 1;

        let message = 'Admin menghubungi perangkat untuk data terkini';
        if (retryCount > 0) {
            message = 'Retrying to contact device... (' + attempt + '/3)';
        }

        console.log('Admin: Running auto summon... Attempt:', attempt);

        Swal.fire({
            title: 'Refreshing Device Data...',
            text: message,
            allowOutsideClick: false,
            didOpen: () => {
                Swal.showLoading();
            }
        });

        $.ajax({
            url: '{$_url}plugin/genieacs_devices/summon',
            type: 'GET',
            data: { device_id: '{$device_id_raw}' },
            dataType: 'json',
            timeout: 15000,
            success: function(response) {
                if (response && response.success) {
                    console.log('Admin: Auto summon success on attempt:', attempt);

                    Swal.fire({
                        title: 'Syncing Latest Data...',
                        text: 'Syncing device information in 8 seconds',
                        timer: 8000,
                        timerProgressBar: true,
                        allowOutsideClick: false,
                        didOpen: () => {
                            Swal.showLoading();
                        }
                    }).then(() => {
                        executeAdminAutoRefresh();
                    });
                } else {
                    console.error('Admin: Auto summon failed on attempt:', attempt);
                    handleAdminSummonFailure(retryCount, maxRetries);
                }
            },
            error: function(xhr) {
                console.error('Admin: Auto summon AJAX Error on attempt:', attempt, xhr);
                handleAdminSummonFailure(retryCount, maxRetries);
            }
        });
    }

    function handleAdminSummonFailure(retryCount, maxRetries) {
        if (retryCount < maxRetries) {
            const nextAttempt = retryCount + 2;

            Swal.fire({
                title: 'Admin Mencoba Ulang...',
                text: 'Menunggu 5 detik sebelum percobaan ' + nextAttempt + '/3',
                timer: 5000,
                timerProgressBar: true,
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            }).then(() => {
                executeAdminAutoSummon(retryCount + 1);
            });
        } else {
            console.log('Admin: Max retry reached, fallback to direct refresh');

            Swal.fire({
                title: 'Admin Syncing...',
                text: 'Melanjutkan tanpa panggilan perangkat',
                timer: 3000,
                timerProgressBar: true,
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            }).then(() => {
                executeAdminAutoRefresh();
            });
        }
    }

    function executeAdminAutoRefresh() {
        console.log('Admin: Menjalankan auto refresh...');

        Swal.fire({
            title: 'Syncing Latest Data...',
            text: 'Menyinkronkan informasi perangkat melalui admin',
            allowOutsideClick: false,
            didOpen: () => {
                Swal.showLoading();
            }
        });

        $.ajax({
            url: '{$_url}plugin/genieacs_devices/refresh',
            type: 'GET',
            data: { device_id: '{$device_id_raw}' },
            dataType: 'json',
            success: function(response) {
                if (response && response.success) {
                    console.log('Admin: Auto refresh success, done!');

                    Swal.fire('Admin Selesai!',
                        'WiFi updated and admin data synced successfully! Page will reload.',
                        'success').then(() => {

                        Swal.fire({
                            title: 'Reloading Page...',
                            text: 'Please wait while data is refreshed',
                            allowOutsideClick: false,
                            allowEscapeKey: false,
                            allowEnterKey: false,
                            showConfirmButton: false,
                            didOpen: () => {
                                Swal.showLoading();
                            }
                        });

                        setTimeout(() => {
                            window.location.reload(true);
                        }, 1500);
                    });
                } else {
                    var errorMsg = 'Sync failed';
                    if (response && response.error) {
                        errorMsg = response.error;
                    }
                    console.error('Admin: Auto refresh failed:', errorMsg);

                    Swal.fire('Warning', 'Sync failed: ' + errorMsg +
                            '. WiFi update succeeded. Page will reload.', 'warning')
                        .then(() => {

                            Swal.fire({
                                title: 'Reloading Page...',
                                text: 'Please wait while data is refreshed',
                                allowOutsideClick: false,
                                allowEscapeKey: false,
                                allowEnterKey: false,
                                showConfirmButton: false,
                                didOpen: () => {
                                    Swal.showLoading();
                                }
                            });

                            setTimeout(() => {
                                window.location.reload(true);
                            }, 1500);
                        });
                }
            },
            error: function(xhr) {
                console.error('Admin: Auto refresh AJAX Error:', xhr);

                Swal.fire('Warning',
                        'Sync failed, but WiFi update succeeded. Page will reload.',
                        'warning')
                    .then(() => {

                        Swal.fire({
                            title: 'Reloading Page...',
                            text: 'Please wait while data is refreshed',
                            allowOutsideClick: false,
                            allowEscapeKey: false,
                            allowEnterKey: false,
                            showConfirmButton: false,
                            didOpen: () => {
                                Swal.showLoading();
                            }
                        });

                        setTimeout(() => {
                            window.location.reload(true);
                        }, 1500);
                    });
            }
        });
    }

    function executeDetailSummonSequence() {
        console.log('Detail: Starting summon sequence');

        Swal.fire({
            title: 'Contacting Device...',
            text: 'Please wait, sending connection request to device',
            allowOutsideClick: false,
            didOpen: () => {
                Swal.showLoading();
            }
        });

        $.ajax({
            url: '{$_url}plugin/genieacs_devices/summon',
            type: 'GET',
            data: { device_id: '{$device_id_raw}' },
            dataType: 'json',
            timeout: 15000,
            success: function(response) {
                if (response && response.success) {
                    console.log('Detail: Summon success, starting refresh...');

                    Swal.fire({
                        title: 'Refreshing Device Data...',
                        text: 'Sistem mengambil informasi terbaru dalam 5 detik',
                        timer: 5000,
                        timerProgressBar: true,
                        allowOutsideClick: false,
                        didOpen: () => {
                            Swal.showLoading();
                        }
                    }).then(() => {
                        executeDetailAutoRefresh();
                    });
                } else {
                    var errorMsg = 'Failed to contact device';
                    if (response && response.error) {
                        errorMsg = response.error;
                    }
                    Swal.fire('Failed!', errorMsg, 'error');
                }
            },
            error: function(xhr) {
                console.error('Detail: Panggil perangkat AJAX Error:', xhr);

                let errorMessage = 'Failed to communicate with server';
                if (xhr.status === 0) {
                    errorMessage = 'Network error - check your connection';
                } else if (xhr.status === 404) {
                    errorMessage = 'Endpoint not found';
                } else if (xhr.status === 500) {
                    errorMessage = 'Server error occurred';
                } else {
                    try {
                        let response = JSON.parse(xhr.responseText);
                        if (response.error) {
                            errorMessage = response.error;
                        }
                    } catch (e) {
                        errorMessage = 'Server memberikan response: ' + xhr.responseText;
                    }
                }
                Swal.fire('Error!', errorMessage, 'error');
            }
        });
    }

    function executeDetailAutoRefresh() {
        console.log('Detail: Running auto refresh');

        Swal.fire({
            title: 'Syncing Latest Data...',
            text: 'Please wait while device information is synced',
            allowOutsideClick: false,
            didOpen: () => {
                Swal.showLoading();
            }
        });

        $.ajax({
            url: '{$_url}plugin/genieacs_devices/refresh',
            type: 'GET',
            data: { device_id: '{$device_id_raw}' },
            dataType: 'json',
            success: function(response) {
                if (response && response.success) {
                    console.log('Detail: Auto refresh success');

                    Swal.fire('Success!',
                        'Device contacted and data updated! Page will reload.',
                        'success').then(() => {

                        Swal.fire({
                            title: 'Reloading Page...',
                            text: 'Please wait while data is refreshed',
                            allowOutsideClick: false,
                            allowEscapeKey: false,
                            allowEnterKey: false,
                            showConfirmButton: false,
                            didOpen: () => {
                                Swal.showLoading();
                            }
                        });

                        setTimeout(() => {
                            window.location.reload(true);
                        }, 1500);
                    });
                } else {
                    var errorMsg = 'Sync failed';
                    if (response && response.error) {
                        errorMsg = response.error;
                    }

                    Swal.fire('Warning', 'Device was contacted but sync failed: ' +
                        errorMsg +
                        '. Page will reload.', 'warning').then(() => {

                        setTimeout(() => {
                            window.location.reload(true);
                        }, 1500);
                    });
                }
            },
            error: function(xhr) {
                Swal.fire('Warning',
                    'Device was contacted but sync failed. Page will reload.',
                    'warning').then(() => {

                    setTimeout(() => {
                        window.location.reload(true);
                    }, 1500);
                });
            }
        });
    }

    // Web Admin Functions
    function toggleAdminEdit() {
        $('#admin-display').toggle();
        $('#admin-edit-form').toggle();
    }

    function refreshWebAdmin() {
        Swal.fire({
            title: 'Refreshing Web Admin Parameters',
            html: '<div class="swal-progress"><i class="fa fa-spinner fa-spin"></i> Connecting to device...</div>',
            allowOutsideClick: false,
            showConfirmButton: false,
            timer: 15000,
            timerProgressBar: true
        });

        // Step 1: Summon device
        $.ajax({
            url: '{$_url}plugin/genieacs_device_detail/{$device_id_raw}/summon',
            type: 'GET',
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    // Update dialog
                    Swal.update({
                        html: '<div class="swal-progress"><i class="fa fa-check text-success"></i> Device connected<br><i class="fa fa-spinner fa-spin"></i> Waiting 5 seconds...</div>'
                    });

                    // Wait 5 seconds
                    setTimeout(function() {
                        // Update dialog
                        Swal.update({
                            html: '<div class="swal-progress"><i class="fa fa-check text-success"></i> Device connected<br><i class="fa fa-spinner fa-spin"></i> Refreshing Web Admin parameters...</div>'
                        });

                        // Step 2: Refresh Web Admin params
                        $.ajax({
                            url: '{$_url}plugin/genieacs_device_detail/{$device_id_raw}/refresh-webadmin',
                            type: 'GET',
                            dataType: 'json',
                            success: function(response) {
                                if (response.success) {
                                    // Update dialog
                                    Swal.update({
                                        html: '<div class="swal-progress"><i class="fa fa-check text-success"></i> Device connected<br><i class="fa fa-check text-success"></i> Web Admin parameters refreshed<br><i class="fa fa-spinner fa-spin"></i> Waiting 3 seconds...</div>'
                                    });

                                    // Wait 3 seconds then reload
                                    setTimeout(function() {
                                        Swal.fire({
                                            title: 'Success!',
                                            text: 'Web Admin parameters refreshed successfully',
                                            icon: 'success',
                                            timer: 1500,
                                            showConfirmButton: false
                                        }).then(() => {
                                            location.reload();
                                        });
                                    }, 3000);
                                } else {
                                    Swal.fire('Error!', response.error ||
                                        'Failed to refresh parameters', 'error');
                                }
                            },
                            error: function() {
                                Swal.fire('Error!',
                                    'Failed to refresh Web Admin parameters',
                                    'error');
                            }
                        });
                    }, 5000);
                } else {
                    Swal.fire('Error!', response.error || 'Failed to connect to device', 'error');
                }
            },
            error: function() {
                Swal.fire('Error!', 'Failed to summon device', 'error');
            }
        });
    }

    function cancelAdminEdit() {
        $('#admin-display').show();
        $('#admin-edit-form').hide();
        $('#admin-credentials-form')[0].reset();
    }

    function toggleSuperPassword() {
        var passwordInput = document.getElementById('super_password');
        var icon = document.getElementById('super-password-icon');

        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            icon.className = 'fa fa-eye-slash';
        } else {
            passwordInput.type = 'password';
            icon.className = 'fa fa-eye';
        }
    }

    function toggleUserPassword() {
        var passwordInput = document.getElementById('user_password');
        var icon = document.getElementById('user-password-icon');

        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            icon.className = 'fa fa-eye-slash';
        } else {
            passwordInput.type = 'password';
            icon.className = 'fa fa-eye';
        }
    }

    // Web Admin Form Submit
    $('#admin-credentials-form').on('submit', function(e) {
        e.preventDefault();

        var super_username = $('#super_username').val().trim();
        var super_password = $('#super_password').val();
        var user_username = $('#user_username').val().trim();
        var user_password = $('#user_password').val();

        if (!super_username || !user_username) {
            Swal.fire('Error!', 'Usernames cannot be empty', 'error');
            return;
        }

        Swal.fire({
            title: 'Update Web Admin Credentials?',
            text: 'This will change router login credentials',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: 'Yes, update!'
        }).then((result) => {
            if (result.isConfirmed) {
                updateAdminCredentials(super_username, super_password, user_username, user_password);
            }
        });
    });

    function updateAdminCredentials(super_user, super_pass, user_user, user_pass) {
        Swal.fire({
            title: 'Updating Admin Credentials...',
            text: 'Please wait',
            allowOutsideClick: false,
            didOpen: () => {
                Swal.showLoading();
            }
        });

        $.ajax({
            url: '{$_url}plugin/genieacs_device_detail/{$device_id_raw}/update-admin',
            type: 'POST',
            data: {
                super_username: super_user,
                super_password: super_pass,
                user_username: user_user,
                user_password: user_pass
            },
            dataType: 'json',
            success: function(response) {
                if (response && response.success) {
                    Swal.fire('Success!', 'Admin credentials updated', 'success').then(() => {
                        location.reload();
                    });
                } else {
                    Swal.fire('Error!', response.error || 'Failed to update credentials', 'error');
                }
            },
            error: function(xhr) {
                Swal.fire('Error!', 'Failed to communicate with server', 'error');
            }
        });
    }

    function toggleSuperPassDisplay() {
        var passDisplay = document.getElementById('super-pass-display');
        var passHidden = document.getElementById('super-pass-hidden');
        var icon = document.getElementById('super-pass-icon');

        if (passDisplay.style.display === 'none') {
            passDisplay.style.display = 'inline';
            passHidden.style.display = 'none';
            icon.className = 'fa fa-eye-slash';
        } else {
            passDisplay.style.display = 'none';
            passHidden.style.display = 'inline';
            icon.className = 'fa fa-eye';
        }
    }

    function toggleUserPassDisplay() {
        var passDisplay = document.getElementById('user-pass-display');
        var passHidden = document.getElementById('user-pass-hidden');
        var icon = document.getElementById('user-pass-icon');

        if (passDisplay.style.display === 'none') {
            passDisplay.style.display = 'inline';
            passHidden.style.display = 'none';
            icon.className = 'fa fa-eye-slash';
        } else {
            passDisplay.style.display = 'none';
            passHidden.style.display = 'inline';
            icon.className = 'fa fa-eye';
        }
    }


    // Tags Management Functions
    function toggleTagsEdit() {
        var tagsDisplay = $('#tags-display');
        var tagsEditForm = $('#tags-edit-form');

        if (tagsEditForm.is(':visible')) {
            tagsEditForm.hide();
            tagsDisplay.show();
        } else {
            // Use all_tags if available, otherwise combine tags and lokasi
            var allTags = '{$device.all_tags|default:""}';
            var tag1Value = '{$device.tags|default:""}';
            var tag2Value = '{$device.lokasi|default:""}';

            var existingTags = [];

            // Check if all_tags exists and use it
            if (allTags && allTags !== 'N/A' && allTags !== '') {
                existingTags = allTags.split(',');
                for (var i = 0; i < existingTags.length; i++) {
                    existingTags[i] = existingTags[i].trim();
                }
            } else {
                // Fallback to individual tags
                if (tag1Value && tag1Value !== 'N/A') {
                    existingTags.push(tag1Value);
                }
                if (tag2Value && tag2Value !== 'N/A') {
                    existingTags.push(tag2Value);
                }
            }

            // Populate form fields
            if (existingTags.length > 0 && existingTags[0]) {
                $('#tag1').val(existingTags[0]);
            } else {
                $('#tag1').val('');
            }

            if (existingTags.length > 1 && existingTags[1]) {
                $('#tag2').val(existingTags[1]);
            } else {
                $('#tag2').val('');
            }

            tagsDisplay.hide();
            tagsEditForm.show();
        }
    }

    function cancelTagsEdit() {
        $('#tags-display').show();
        $('#tags-edit-form').hide();
        $('#tags-form')[0].reset();
    }

    // Tags Form Submit
    $('#tags-form').on('submit', function(e) {
        e.preventDefault();

        var tag1 = $('#tag1').val().trim();
        var tag2 = $('#tag2').val().trim();

        // Validation
        if (!tag1) {
            Swal.fire('Error!', 'Username tag is required', 'error');
            return;
        }

        // Get current tags for comparison
        var currentTag1 = '';
        var currentTag2 = '';
        var allTags = '{$device.all_tags|default:""}';
        var tag1Value = '{$device.tags|default:""}';
        var tag2Value = '{$device.lokasi|default:""}';

        if (allTags && allTags !== 'N/A') {
            var existingTags = allTags.split(',');
            if (existingTags.length > 0) currentTag1 = existingTags[0].trim();
            if (existingTags.length > 1) currentTag2 = existingTags[1].trim();
        } else {
            if (tag1Value && tag1Value !== 'N/A') currentTag1 = tag1Value;
            if (tag2Value && tag2Value !== 'N/A') currentTag2 = tag2Value;
        }

        // Build tags array
        var tags = [tag1];
        if (tag2) {
            tags.push(tag2);
        }

        // Build confirmation HTML like WiFi update
        var confirmHTML = '';

        // Username change
        if (currentTag1 !== tag1) {
            confirmHTML += '<strong>Username Tag:</strong><br>';
            if (currentTag1) {
                confirmHTML += '<span style="color: #dc3545;">Old: ' + currentTag1 + '</span><br>';
            }
            confirmHTML += '<span style="color: #28a745;">New: ' + tag1 + '</span><br><br>';
        } else {
            confirmHTML += '<strong>Username Tag:</strong> ' + tag1 + ' <em>(unchanged)</em><br><br>';
        }

        // Location change
        if (tag2) {
            if (currentTag2 !== tag2) {
                confirmHTML += '<strong>Location Tag:</strong><br>';
                if (currentTag2) {
                    confirmHTML += '<span style="color: #dc3545;">Old: ' + currentTag2 + '</span><br>';
                }
                confirmHTML += '<span style="color: #28a745;">New: ' + tag2 + '</span>';
            } else {
                confirmHTML += '<strong>Location Tag:</strong> ' + tag2 + ' <em>(unchanged)</em>';
            }
        } else {
            if (currentTag2) {
                confirmHTML += '<strong>Location Tag:</strong><br>';
                confirmHTML += '<span style="color: #dc3545;">Old: ' + currentTag2 + '</span><br>';
                confirmHTML += '<span style="color: #6c757d;"><em>Will be removed</em></span>';
            } else {
                confirmHTML += '<strong>Location Tag:</strong> <em>(none)</em>';
            }
        }

        // Confirmation
        Swal.fire({
            title: 'Update Device Tags?',
            html: confirmHTML,
            icon: 'question',
            showCancelButton: true,
            confirmButtonText: 'Yes, update',
            cancelButtonText: 'Cancel'
        }).then((result) => {
            if (result.isConfirmed) {
                updateDeviceTags(tags);
            }
        });
    });

    function updateDeviceTags(tags) {
        Swal.fire({
            title: 'Updating Tags...',
            text: 'Please wait while updating device tags',
            allowOutsideClick: false,
            didOpen: () => {
                Swal.showLoading();
            }
        });

        $.ajax({
            url: '{$_url}plugin/genieacs_device_detail/{$device_id_raw}/update-tags',
            type: 'POST',
            data: {
                tags: tags
            },
            dataType: 'json',
            success: function(response) {
                if (response && response.success) {
                    Swal.fire('Success!', 'Device tags updated successfully', 'success').then(() => {
                        location.reload();
                    });
                } else {
                    Swal.fire('Error!', response.error || 'Failed to update tags', 'error');
                }
            },
            error: function(xhr) {
                console.error('Tags Update Error:', xhr);
                Swal.fire('Error!', 'Failed to communicate with server', 'error');
            }
        });
    }
</script>

{include file="sections/footer.tpl"}