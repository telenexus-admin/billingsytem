{include file="sections/header.tpl"}

<div class="row">
    <div class="col-sm-12">
        <div class="panel panel-hovered mb20 panel-primary">
            <div class="panel-heading">
                <i class="ion ion-android-list"></i> GenieACS Device List
                <div class="pull-right">
                    <a href="{$_url}plugin/genieacs_manager" class="btn btn-primary btn-xs">
                        <i class="fa fa-server"></i> Manage Servers
                    </a>
                    <button class="btn btn-warning btn-xs" onclick="forceSync()" title="Force sync from ACS servers"
                        style="color: #333;">
                        <i class="fa fa-download"></i> Force Sync
                    </button>
                    <button id="refreshButton" class="btn btn-danger btn-xs" onclick="refreshDevices()"
                        title="Refresh Devices">
                        <i class="fa fa-refresh"></i> <span id="refreshButtonText">Refresh Offline</span>
                    </button>
                    <span class="badge badge-info">{$device_count} devices</span>
                </div>
            </div>

            <!-- START: Statistics Cards Section -->
            <div class="panel-body stats-cards-container"
                style="padding: 15px 7.5px; border-bottom: 2px solid #e0e0e0;">
                <div class="row five-cols">
                    <!-- Card 1: Server Select -->
                    <div class="col-md-5ths col-sm-6 col-xs-12">
                        <div class="stats-card card-server">
                            <div class="card-icon">
                                <i class="fa fa-server"></i>
                            </div>
                            <div class="card-content">
                                <div class="card-title">Active Server</div>
                                <div class="card-value server-name">{$current_server->name}</div>
                                <div class="card-status">
                                    {if $current_server->is_connected}
                                        <span class="status-indicator online"></span> Connected
                                    {else}
                                        <span class="status-indicator offline"></span> Disconnected
                                    {/if}
                                </div>
                                <select id="quickServerSwitch" class="form-control input-sm" onchange="changeServer()"
                                    style="margin-top: 5px;">
                                    {foreach $servers as $server}
                                        <option value="{$server->id}" {if $server->id == $selected_server_id}selected{/if}>
                                            {$server->name}
                                        </option>
                                    {/foreach}
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Card 2: Total Devices -->
                    <div class="col-md-5ths col-sm-6 col-xs-12">
                        <div class="stats-card card-total">
                            <div class="card-icon">
                                <i class="fa fa-wifi"></i>
                            </div>
                            <div class="card-content">
                                <div class="card-title">Total Devices</div>
                                <div class="card-value count-up" data-target="{$device_count}">0</div>
                                <div class="progress-bar-container">
                                    <div class="progress-bar-fill" style="width: 100%"></div>
                                </div>
                                <div class="card-subtitle">All registered</div>
                            </div>
                        </div>
                    </div>

                    <!-- Card 3: Online -->
                    <div class="col-md-5ths col-sm-6 col-xs-12">
                        <div class="stats-card card-online">
                            <div class="card-icon">
                                <i class="fa fa-check-circle"></i>
                            </div>
                            <div class="card-content">
                                <div class="card-title">Online</div>
                                <div class="card-value count-up" data-target="{$online_count|default:0}">0</div>
                                <div class="progress-bar-container">
                                    <div class="progress-bar-fill" style="width: {$online_percentage|default:0}%"></div>
                                </div>
                                <div class="card-subtitle">{$online_percentage|default:0}%
                                    active</div>
                            </div>
                        </div>
                    </div>

                    <!-- Card 4: Offline -->
                    <div class="col-md-5ths col-sm-6 col-xs-12">
                        <div class="stats-card card-offline">
                            <div class="card-icon">
                                <i class="fa fa-times-circle"></i>
                            </div>
                            <div class="card-content">
                                <div class="card-title">Offline</div>
                                <div class="card-value count-up" data-target="{$offline_count|default:0}">0</div>
                                <div class="progress-bar-container">
                                    <div class="progress-bar-fill" style="width: {$offline_percentage|default:0}%">
                                    </div>
                                </div>
                                <div class="card-subtitle">{$offline_percentage|default:0}%
                                    inactive</div>
                            </div>
                        </div>
                    </div>

                    <!-- Card 5: Warning -->
                    <div class="col-md-5ths col-sm-6 col-xs-12">
                        <div class="stats-card card-warning">
                            <div class="card-icon">
                                <i class="fa fa-exclamation-triangle"></i>
                            </div>
                            <div class="card-content">
                                <div class="card-title">Warning</div>
                                <div class="card-value count-up" data-target="{$warning_count|default:0}">0</div>
                                <div class="progress-bar-container">
                                    <div class="progress-bar-fill" style="width: {$warning_percentage|default:0}%">
                                    </div>
                                </div>
                                <div class="card-subtitle">RX < -25dBm</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- END: Statistics Cards Section -->
                <div class="panel-body" style="border-bottom: 1px solid #ddd; padding: 10px;">
                    <div class="row">
                        <form method="GET" action="index.php">
                            <input type="hidden" name="_route" value="plugin/genieacs_devices">
                            <div class="col-md-4">
                                <div class="input-group">
                                    <input type="text" id="ajaxSearchInput" name="search" class="form-control"
                                        placeholder="Type to search..." value="{$smarty.get.search|default:''}">
                                    <span class="input-group-btn">
                                        <button class="btn btn-primary" type="submit">
                                            <i class="fa fa-search"></i>
                                        </button>
                                    </span>
                                </div>
                                <small id="searchStatus" class="text-muted"></small>
                            </div>
                            <div class="col-md-2">
                                <select name="status" class="form-control" onchange="this.form.submit()">
                                    <option value="">All Status</option>
                                    <option value="online" {if $smarty.get.status == 'online'}selected{/if}>Online
                                    </option>
                                    <option value="offline" {if $smarty.get.status == 'offline'}selected{/if}>Offline
                                    </option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select name="rx_power" class="form-control" onchange="this.form.submit()">
                                    <option value="">All RX Power</option>
                                    <option value="good" {if $smarty.get.rx_power == 'good'}selected{/if}>🟢 Bagus (≥
                                        -20
                                        dBm)</option>
                                    <option value="fair" {if $smarty.get.rx_power == 'fair'}selected{/if}>🟡 Sedang (-21
                                        to -25 dBm)</option>
                                    <option value="poor" {if $smarty.get.rx_power == 'poor'}selected{/if}>🔴 Buruk (<
                                            -25 dBm)</option>
                                </select>
                            </div>
                            {if $available_locations && count($available_locations) > 0}
                                <div class="col-md-2">
                                    <select name="location" class="form-control" onchange="this.form.submit()">
                                        <option value="">All Locations</option>
                                        {foreach $available_locations as $location}
                                            <option value="{$location}" {if $smarty.get.location == $location}selected{/if}>
                                                {$location}</option>
                                        {/foreach}
                                    </select>
                                </div>
                            {/if}
                            <div class="col-md-2">
                                <a href="javascript:void(0)" onclick="clearAllFilters()" id="clearFiltersBtn"
                                    class="btn btn-danger btn-block"
                                    style="{if !$smarty.get.search && !$smarty.get.status && !$smarty.get.rx_power && !$smarty.get.location}display:none;{/if}">
                                    <i class="fa fa-times"></i> Clear All Filters
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="panel-body">
                    <!-- Mobile View - Dynamic Version -->
                    <div class="visible-xs" id="mobileDeviceList">
                        {foreach $devices as $device}
                            {* Calculate RX Level Category *}
                            {if $device.rx_power == 'N/A'}
                                {assign var="rx_level" value="na"}
                            {elseif strpos($device.rx_power, '-') !== false}
                                {assign var="rx_value" value=floatval($device.rx_power)}
                                {if $rx_value >= -20}
                                    {assign var="rx_level" value="good"}
                                {elseif $rx_value >= -25}
                                    {assign var="rx_level" value="fair"}
                                {else}
                                    {assign var="rx_level" value="poor"}
                                {/if}
                            {else}
                                {assign var="rx_level" value="na"}
                            {/if}

                            <div class="panel panel-default mb-2 device-card" data-username="{$device.pppoe_username}"
                                data-ip="{$device.ip}" data-tags="{$device.tags}" data-lokasi="{$device.lokasi}"
                                data-status="{$device.status}" data-rx-level="{$rx_level}"
                                data-rx-value="{$device.rx_power}">
                                <div class="panel-body">
                                    <div class="row">
                                        <div class="col-xs-1">
                                            <input type="checkbox" class="device-checkbox" data-device-id="{$device.id_raw}"
                                                data-device-status="{$device.status}" onchange="updateRefreshButton()">
                                        </div>
                                        <div class="col-xs-5">
                                            <strong>Status:</strong>
                                            {if $device.status == 'online'}
                                                <span class="label label-success">Online</span>
                                            {else}
                                                <span class="label label-danger">Offline</span>
                                            {/if}
                                        </div>
                                        <div class="col-xs-6">
                                            <strong>PON:</strong>
                                            {assign var="pon_found" value=false}
                                            {foreach $display_params as $param}
                                                {if $param->param_key == 'pon_type'}
                                                    {assign var="pon_value" value=$device.pon_type|default:'N/A'}
                                                    {if $pon_value == 'GPON'}
                                                        <span class="label label-primary">{$pon_value}</span>
                                                    {elseif $pon_value == 'EPON'}
                                                        <span class="label label-info">{$pon_value}</span>
                                                    {else}
                                                        {$pon_value}
                                                    {/if}
                                                    {assign var="pon_found" value=true}
                                                    {break}
                                                {/if}
                                            {/foreach}
                                            {if !$pon_found}N/A{/if}
                                        </div>
                                    </div>
                                    <hr class="mb-2 mt-2">

                                    {* Dynamic Mobile Layout with Intelligent Grouping *}
                                    {assign var="primary_params" value=[]}
                                    {assign var="technical_params" value=[]}
                                    {assign var="network_params" value=[]}
                                    {assign var="shown_params" value=[]}

                                    {* Group parameters by type for mobile layout *}
                                    {foreach $display_params as $param}
                                        {assign var="param_key" value=$param->param_key}
                                        {assign var="param_value" value=$device.$param_key|default:'N/A'}

                                        {* Primary Info Group (Username, Serial) *}
                                        {if in_array($param_key, ['ppp_username', 'pppoe_username', 'device_id', 'serial_number'])}
                                            {if $param_key == 'ppp_username' || $param_key == 'pppoe_username'}
                                                <div class="row mb-1">
                                                    <div class="col-xs-12">
                                                        <strong>{$param->param_label}:</strong> {$param_value}
                                                        {* Try to find serial number to show alongside *}
                                                        {foreach $display_params as $sn_param}
                                                            {if $sn_param->param_key == 'serial_number'}
                                                                <br><small class="text-muted">SN: {$device.serial_number|default:'N/A'}</small>
                                                                {break}
                                                            {/if}
                                                        {/foreach}
                                                    </div>
                                                </div>
                                                {assign var="shown_params" value=$shown_params|array_merge:[$param_key, 'serial_number']}
                                            {/if}

                                            {* Hardware Info Group (Vendor, Model) *}
                                        {elseif in_array($param_key, ['vendor', 'manufacturer'])}
                                            {if !in_array('vendor_model_shown', $shown_params)}
                                                <div class="row mb-1">
                                                    <div class="col-xs-6">
                                                        <strong>{$param->param_label}:</strong> {$param_value}
                                                    </div>
                                                    <div class="col-xs-6">
                                                        <strong>Model:</strong>
                                                        {foreach $display_params as $model_param}
                                                            {if $model_param->param_key == 'model'}
                                                                {$device.model|default:'N/A'}
                                                                {break}
                                                            {/if}
                                                        {/foreach}
                                                    </div>
                                                </div>
                                                {assign var="shown_params" value=$shown_params|array_merge:['vendor_model_shown', 'model']}
                                            {/if}

                                            {* Network Info Group (IP, RX Power) *}
                                        {elseif in_array($param_key, ['pppoe_ip', 'tr069_ip', 'ip'])}
                                            {if !in_array('network_shown', $shown_params)}
                                                <div class="row mb-1">
                                                    <div class="col-xs-6">
                                                        <strong>{$param->param_label}:</strong> <small>{$param_value}</small>
                                                    </div>
                                                    <div class="col-xs-6">
                                                        <strong>RX:</strong>
                                                        {* Find RX Power parameter *}
                                                        {assign var="rx_shown" value=false}
                                                        {foreach $display_params as $rx_param}
                                                            {if $rx_param->param_key == 'rx_power'}
                                                                {assign var="rx_power_val" value=$device.rx_power|default:'N/A'}
                                                                {if $rx_power_val != 'N/A' && $rx_power_val != ''}
                                                                    {assign var="rx_numeric" value=floatval($rx_power_val)}
                                                                    {if $rx_numeric >= -20}
                                                                        <span class="text-success">{$rx_power_val} dBm</span>
                                                                    {elseif $rx_numeric >= -25}
                                                                        <span class="text-warning">{$rx_power_val} dBm</span>
                                                                    {else}
                                                                        <span class="text-danger">{$rx_power_val} dBm</span>
                                                                    {/if}
                                                                {else}
                                                                    <span class="text-muted">N/A</span>
                                                                {/if}
                                                                {assign var="rx_shown" value=true}
                                                                {break}
                                                            {/if}
                                                        {/foreach}
                                                        {if !$rx_shown}N/A{/if}
                                                    </div>
                                                </div>
                                                {assign var="shown_params" value=$shown_params|array_merge:['network_shown', 'rx_power']}
                                            {/if}

                                            {* Uptime and Status Group *}
                                        {elseif in_array($param_key, ['uptime', 'ppp_uptime'])}
                                            {if !in_array('uptime_shown', $shown_params)}
                                                <div class="row mb-1">
                                                    <div class="col-xs-6">
                                                        <strong>{$param->param_label}:</strong> {$param_value}
                                                    </div>
                                                    <div class="col-xs-6">
                                                        <strong>Last:</strong> {$device.last_inform|default:'N/A'}
                                                    </div>
                                                </div>
                                                {assign var="shown_params" value=$shown_params|array_merge:['uptime_shown']}
                                            {/if}

                                            {* Other parameters - show individually if not already shown *}
                                        {elseif !in_array($param_key, $shown_params) && !in_array($param_key, ['model', 'pon_type', 'serial_number'])}
                                            <div class="row mb-1">
                                                <div class="col-xs-6">
                                                    <strong>{$param->param_label}:</strong>
                                                </div>
                                                <div class="col-xs-6">
                                                    {* Apply special formatting *}
                                                    {if strpos($param_value, 'dBm') !== false}
                                                        {assign var="param_numeric" value=floatval($param_value)}
                                                        {if $param_numeric > -20}
                                                            <span class="text-success">{$param_value}</span>
                                                        {elseif $param_numeric > -25}
                                                            <span class="text-warning">{$param_value}</span>
                                                        {else}
                                                            <span class="text-danger">{$param_value}</span>
                                                        {/if}
                                                    {elseif $param_key == 'temperature' && is_numeric($param_value)}
                                                        {$param_value}°C
                                                    {else}
                                                        {$param_value}
                                                    {/if}
                                                </div>
                                            </div>
                                        {/if}
                                    {/foreach}

                                    {* Tags and Location *}
                                    {if $device.tags || $device.lokasi}
                                        <div class="row mb-1">
                                            <div class="col-xs-12">
                                                {if $device.tags}
                                                    <span class="badge badge-user" style="margin-right: 5px;">
                                                        <i class="fa fa-user"></i> {$device.tags}
                                                    </span>
                                                {/if}
                                                {if $device.lokasi}
                                                    <span class="badge badge-location">
                                                        <i class="fa fa-map-marker"></i> {$device.lokasi}
                                                    </span>
                                                {/if}
                                            </div>
                                        </div>
                                    {/if}

                                    <hr class="mb-2 mt-2">
                                    <div class="btn-group btn-group-justified">
                                        <div class="btn-group">
                                            <a href="{$_url}plugin/genieacs_device_detail/{$device.id_raw}"
                                                class="btn btn-primary btn-sm" title="Details">
                                                <i class="fa fa-eye"></i> Details
                                            </a>
                                        </div>
                                    </div>
                                    <div class="btn-group btn-group-justified" style="margin-top: 5px;">
                                        <div class="btn-group">
                                            <button class="btn btn-success btn-xs"
                                                onclick="summonDevice('{$device.device_id|default:$device.id_raw}')"
                                                title="Summon">
                                                <i class="fa fa-bell"></i> Summon
                                            </button>
                                            <button class="btn btn-danger btn-xs"
                                                onclick="rebootDevice('{$device.device_id|default:$device.id_raw}')"
                                                title="Reboot">
                                                <i class="fa fa-power-off"></i> Reboot
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        {/foreach}
                    </div>

                    <!-- Desktop View -->
                    <div class="table-responsive hidden-xs">
                        {* Parameters will be passed from PHP controller *}
                        <table id="deviceTable" class="table table-bordered table-striped table-hover table-condensed">
                            <thead>
                                <tr>
                                    <th width="30">
                                        <input type="checkbox" id="selectAll" onclick="toggleSelectAll()">
                                    </th>
                                    <th style="width: 45px !important; max-width: 45px !important;">Status</th>
                                    {foreach $display_params as $param}
                                        <th {if $param->param_label|strstr:'Serial' || $param->param_label|strstr:'SN'}
                                                style="width: 100px !important; max-width: 100px !important;"
                                            {elseif $param->param_label|strstr:'Manufac' || $param->param_label|strstr:'Vendor'}
                                                style="width: 80px !important; max-width: 80px !important;"
                                            {elseif $param->param_label|strstr:'Model'}
                                                style="width: 50px !important; max-width: 50px !important;"
                                            {elseif $param->param_label == 'PON' || $param->param_label|strstr:'PON'}
                                                style="width: 50px !important; max-width: 50px !important; text-align: center;"
                                            {elseif $param->param_label|strstr:'RX' || $param->param_label|strstr:'Power'}
                                                style="width: 85px !important; max-width: 85px !important;"
                                            {elseif $param->param_label|strstr:'Device ID' || $param->param_label|strstr:'ID'}
                                            style="width: 120px !important; max-width: 120px !important;" {/if}>
                                            {$param->param_label}</th>
                                    {/foreach}
                                    <th width="50">Tag</th>
                                    <th width="60">Lokasi</th>
                                    <th width="70">Last</th>
                                    <th width="60">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach $devices as $device}
                                    <tr>
                                        <td class="text-center">
                                            <input type="checkbox" class="device-checkbox" data-device-id="{$device.id_raw}"
                                                data-device-status="{$device.status}" onchange="updateRefreshButton()">
                                        </td>
                                        <td class="text-center">
                                            {if $device.status == 'online'}
                                                <span class="label label-success">Online</span>
                                            {else}
                                                <span class="label label-danger">Offline</span>
                                            {/if}
                                        </td>
                                        {foreach $display_params as $param}
                                            {assign var="param_key" value=$param->param_key}
                                            {assign var="param_value" value=$device.$param_key|default:'N/A'}

                                            <td {if $param_key == 'pppoe_username' || $param_key == 'pppoe_ip' || $param_key == 'ppp_username' || $param_key == 'ip' || $param_key == 'mac_address' || $param_key == 'ppp_mac' || $param_key == 'serial_number' || $param_key == 'sn'}class="selectable-text"
                                                {/if}
                                                {if $param->param_label|strstr:'Serial' || $param->param_label|strstr:'SN'}
                                                    style="max-width: 100px; word-break: break-all; font-size: 11px; line-height: 1.2;"
                                                {elseif $param->param_label|strstr:'Manufac' || $param->param_label|strstr:'Vendor'}
                                                    style="max-width: 60px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;"
                                                title="{$param_value}" {elseif $param->param_label|strstr:'Model'}
                                                    style="max-width: 60px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;"
                                                title="{$param_value}" {/if}>

                                                {* Format berdasarkan label parameter *}
                                                {if $param->param_label == 'Pon Type' || $param->param_label == 'PON tpe' || $param->param_label == 'Pon Mode'|| $param->param_label == 'PON'}
                                                    {if $param_value == 'GPON'}
                                                        <span class="label label-primary">{$param_value}</span>
                                                    {elseif $param_value == 'EPON'}
                                                        <span class="label label-info">{$param_value}</span>
                                                    {else}
                                                        <small>{$param_value}</small>
                                                    {/if}
                                                {elseif $param_key == 'rx_power'}
                                                    {if $param_value != 'N/A' && $param_value != ''}
                                                        {assign var="rx_value" value=floatval($param_value)}
                                                        {if $rx_value >= -20}
                                                            <span class="text-success" style="white-space: nowrap;">{$param_value}
                                                                dBm</span>
                                                        {elseif $rx_value >= -25}
                                                            <span class="text-warning" style="white-space: nowrap;">{$param_value}
                                                                dBm</span>
                                                        {else}
                                                            <span class="text-danger" style="white-space: nowrap;">{$param_value} dBm</span>
                                                        {/if}
                                                    {else}
                                                        <span class="text-muted">N/A</span>
                                                    {/if}
                                                {elseif $param_key == 'temperature'}
                                                    {if $param_value != 'N/A' && $param_value != ''}
                                                        {$param_value}°C
                                                    {else}
                                                        <span class="text-muted">N/A</span>
                                                    {/if}
                                                {elseif $param->param_label|strstr:'Serial' || $param->param_label|strstr:'Vendor' || $param->param_label|strstr:'Model'}
                                                    <small>{$param_value}</small>
                                                {else}
                                                    {$param_value}
                                                {/if}
                                            </td>
                                        {/foreach}
                                        <td class="text-center">
                                            {if $device.tags}
                                                <span class="badge badge-user">{$device.tags}</span>
                                            {else}
                                                <span class="text-muted">-</span>
                                            {/if}
                                        </td>
                                        <td class="text-center">
                                            {if $device.lokasi}
                                                <span class="badge badge-location">{$device.lokasi}</span>
                                            {else}
                                                <span class="text-muted">-</span>
                                            {/if}
                                        </td>
                                        <td><small>{$device.last_inform}</small></td>
                                        <td class="action-column">
                                            <div class="btn-group">
                                                <button type="button" class="btn btn-primary btn-xs dropdown-toggle"
                                                    data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"
                                                    title="Actions">
                                                    <i class="fa fa-cog"></i> <span class="caret"></span>
                                                </button>
                                                <ul class="dropdown-menu dropdown-menu-right">
                                                    <li><a href="{$_url}plugin/genieacs_device_detail/{$device.id_raw}">
                                                            <i class="fa fa-eye text-primary"></i> View Details</a></li>
                                                    <li class="divider"></li>
                                                    <li><a href="javascript:void(0)"
                                                            onclick="summonDevice('{$device.device_id|default:$device.id_raw}')">
                                                            <i class="fa fa-bell text-success"></i> Summon Device</a></li>
                                                    <li><a href="javascript:void(0)"
                                                            onclick="rebootDevice('{$device.device_id|default:$device.id_raw}')">
                                                            <i class="fa fa-power-off text-danger"></i> Reboot Device</a>
                                                    </li>
                                                </ul>
                                            </div>
                                        </td>
                                    </tr>
                                {/foreach}
                            </tbody>
                        </table>
                    </div>

                    {if $device_count == 0 && !$error}
                        <div class="no-devices-container">
                            <div class="no-devices-box">
                                <div class="no-devices-icon">
                                    <i class="fa fa-wifi"></i>
                                </div>
                                <h3 class="no-devices-title">No Devices Found</h3>
                                <p class="no-devices-text">
                                    There are currently no devices registered in the GenieACS server
                                </p>
                                <div class="no-devices-actions">
                                    <button class="btn btn-danger" onclick="location.reload()">
                                        <i class="fa fa-refresh"></i> Refresh Page
                                    </button>
                                    <button class="btn btn-primary"
                                        onclick="window.location.href='{$_url}plugin/genieacs_manager'">
                                        <i class="fa fa-cog"></i> Check Server
                                    </button>
                                </div>
                            </div>
                        </div>
                    {/if}

                    {if $error}
                        <div class="server-error-container">
                            <div class="server-error-box">
                                <div class="server-error-icon">
                                    <i class="fa fa-plug"></i>
                                    <span class="error-badge">
                                        <i class="fa fa-times"></i>
                                    </span>
                                </div>
                                <h3 class="server-error-title">Connection Failed</h3>
                                <p class="server-error-message">
                                    {if strpos($error, 'Could not connect') !== false}
                                        Unable to establish connection with GenieACS server
                                    {elseif strpos($error, 'port') !== false}
                                        Server is not responding on the configured port
                                    {else}
                                        {$error}
                                    {/if}
                                </p>
                                <div class="server-error-details">
                                    <div class="error-detail-item">
                                        <i class="fa fa-server"></i>
                                        <span>Server: {$current_server->host}:{$current_server->port}</span>
                                    </div>
                                    <div class="error-detail-item">
                                        <i class="fa fa-clock-o"></i>
                                        <span>Timeout: Connection attempt failed</span>
                                    </div>
                                </div>
                                <div class="server-error-actions">
                                    <button class="btn btn-danger" onclick="location.reload()">
                                        <i class="fa fa-refresh"></i> Retry Connection
                                    </button>
                                    <button class="btn btn-primary"
                                        onclick="window.location.href='{$_url}plugin/genieacs_manager'">
                                        <i class="fa fa-wrench"></i> Configure Server
                                    </button>
                                </div>
                            </div>
                        </div>
                    {/if}

                </div>
                <!-- Pagination Section -->
                <div class="panel-footer">
                    <div class="row">
                        <div class="col-sm-4">
                            <div class="pagination-info">
                                {if $devices}
                                    {assign var="start" value=(($current_page-1)*10)+1}
                                    {assign var="end" value=min($current_page*10, $total_devices)}
                                    Showing {$start} to {$end} of {$total_devices} devices
                                    {if $search_term}
                                        <span class="text-info">(Search: "{$search_term}")</span>
                                    {/if}
                                {else}
                                    {if $search_term}
                                        No devices found for search: "{$search_term}"
                                    {else}
                                        No devices found
                                    {/if}
                                {/if}
                            </div>
                        </div>
                        <div class="col-sm-4 text-center">
                            {if isset($sync_warning)}
                                <div class="alert alert-warning"
                                    style="margin: 0; padding: 5px 10px; display: inline-block; animation: pulse 2s infinite;">
                                    <i class="fa fa-exclamation-triangle"></i>
                                    <strong>Warning!</strong> {$sync_warning}
                                    <button class="btn btn-warning btn-xs" onclick="forceSync()" style="margin-left: 10px;">
                                        <i class="fa fa-sync"></i> Sync Now
                                    </button>
                                </div>
                            {/if}
                        </div>
                        <div class="col-sm-4">
                            {if $total_pages > 1}
                                <nav aria-label="Page navigation" class="pull-right">
                                    <ul class="pagination pagination-sm">
                                        {assign var="search_param" value=""}
                                        {if $search_term}
                                            {assign var="search_param" value="&search="|cat:$search_term|urlencode}
                                        {/if}
                                        {if $status_filter}
                                            {assign var="search_param" value=$search_param|cat:"&status="|cat:$status_filter}
                                        {/if}
                                        {if $rx_power_filter}
                                            {assign var="search_param" value=$search_param|cat:"&rx_power="|cat:$rx_power_filter}
                                        {/if}
                                        {if $location_filter}
                                            {assign var="search_param" value=$search_param|cat:"&location="|cat:$location_filter|urlencode}
                                        {/if}

                                        {* First Page Button *}
                                        {if $current_page > 1}
                                            <li><a href="index.php?_route=plugin/genieacs_devices/list/1{$search_param}"
                                                    title="First Page">««</a></li>
                                        {else}
                                            <li class="disabled"><span>««</span></li>
                                        {/if}

                                        {* Previous Page Button *}
                                        {if $current_page > 1}
                                            <li><a href="index.php?_route=plugin/genieacs_devices/list/{$current_page-1}{$search_param}"
                                                    title="Previous">«</a></li>
                                        {else}
                                            <li class="disabled"><span>«</span></li>
                                        {/if}

                                        {* Page Numbers *}
                                        {for $i=max(1,$current_page-2) to min($total_pages,$current_page+2)}
                                            {if $i == $current_page}
                                                <li class="active"><span>{$i}</span></li>
                                            {else}
                                                <li><a
                                                        href="index.php?_route=plugin/genieacs_devices/list/{$i}{$search_param}">{$i}</a>
                                                </li>
                                            {/if}
                                        {/for}

                                        {* Next Page Button *}
                                        {if $current_page < $total_pages}
                                            <li><a href="index.php?_route=plugin/genieacs_devices/list/{$current_page+1}{$search_param}"
                                                    title="Next">»</a></li>
                                        {else}
                                            <li class="disabled"><span>»</span></li>
                                        {/if}

                                        {* Last Page Button *}
                                        {if $current_page < $total_pages}
                                            <li><a href="index.php?_route=plugin/genieacs_devices/list/{$total_pages}{$search_param}"
                                                    title="Last Page">»»</a></li>
                                        {else}
                                            <li class="disabled"><span>»»</span></li>
                                        {/if}
                                    </ul>
                                </nav>
                            {/if}
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>

    <script>
        function showLoading(message) {
            Swal.fire({
                title: message,
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });
        }

        // Toggle select all checkboxes
        function toggleSelectAll() {
            var isChecked = $('#selectAll').prop('checked');
            $('.device-checkbox:visible').prop('checked', isChecked);
            updateRefreshButton();
        }

        // Update refresh button text based on selection
        function updateRefreshButton() {
            var checkedDevices = $('.device-checkbox:checked:visible');
            var button = $('#refreshButton');
            var buttonText = $('#refreshButtonText');

            if (checkedDevices.length > 0) {
                buttonText.text('Refresh Selected (' + checkedDevices.length + ')');
                button.removeClass('btn-danger').addClass('btn-primary');
            } else {
                buttonText.text('Refresh Offline');
                button.removeClass('btn-primary').addClass('btn-danger');
            }
        }

        // Main refresh function
        function refreshDevices() {
            var checkedDevices = $('.device-checkbox:checked:visible');
            var devicesToRefresh = [];

            if (checkedDevices.length > 0) {
                // Refresh selected devices with more info
                checkedDevices.each(function() {
                    var $row = $(this).closest('tr');
                    var username = $row.find('td:contains("@")').text() || // Find PPPoE username
                        $row.find('.badge-user').text() || // Or from tag
                        'Unknown User';
                    var model = $row.find('td').filter(function() {
                        return $(this).text().includes('F663') ||
                            $(this).text().includes('F477') ||
                            $(this).text().includes('GM220') ||
                            $(this).text().includes('ZXHN');
                    }).first().text() || 'Device';

                    devicesToRefresh.push({
                        id: $(this).data('device-id'),
                        status: $(this).data('device-status'),
                        username: username.trim(),
                        model: model.trim()
                    });
                });

                Swal.fire({
                    title: 'Refresh Selected Devices',
                    html: '<div style="text-align: center;">' +
                        '<div style="font-size: 48px; color: #5dade2; margin-bottom: 20px;">' +
                        '<i class="fa fa-refresh"></i>' +
                        '</div>' +
                        '<p style="font-size: 16px; color: #495057;">You are about to refresh <strong style="color: #5dade2;">' +
                        devicesToRefresh.length + '</strong> selected device(s)</p>' +
                        '<p style="font-size: 14px; color: #6c757d; margin-top: 10px;">This will send connection requests to update device status</p>' +
                        '</div>',
                    icon: null,
                    showCancelButton: true,
                    confirmButtonText: 'Refresh Now',
                    cancelButtonText: 'Cancel',
                    confirmButtonColor: '#5dade2',
                    cancelButtonColor: '#6c757d',
                    customClass: {
                        popup: 'modern-swal-popup',
                        confirmButton: 'modern-swal-confirm',
                        cancelButton: 'modern-swal-cancel'
                    }
                }).then((result) => {
                    if (result.isConfirmed) {
                        processDeviceRefresh(devicesToRefresh, 'selected');
                    }
                });
            } else {
                // Get ALL offline devices from database
                Swal.fire({
                    title: 'Checking Devices...',
                    text: 'Please wait',
                    allowOutsideClick: false,
                    didOpen: () => {
                        Swal.showLoading();
                    }
                });

                $.ajax({
                    url: '{$_url}plugin/genieacs_devices/get-offline-devices',
                    type: 'GET',
                    dataType: 'json',
                    success: function(response) {
                        if (response.success && response.devices.length > 0) {
                            var offlineDevices = response.devices;

                            Swal.fire({
                                title: 'Refresh Offline Devices',
                                html: '<div style="text-align: center;">' +
                                    '<div style="font-size: 48px; color: #ec7063; margin-bottom: 20px;">' +
                                    '<i class="fa fa-exclamation-circle"></i>' +
                                    '</div>' +
                                    '<p style="font-size: 16px; color: #495057;">Found <strong style="color: #ec7063;">' +
                                    offlineDevices.length + '</strong> offline device(s)</p>' +
                                    '<p style="font-size: 14px; color: #6c757d; margin-top: 10px;">This will attempt to reconnect and update their status</p>' +
                                    '</div>',
                                icon: null,
                                showCancelButton: true,
                                confirmButtonText: 'Refresh All',
                                cancelButtonText: 'Cancel',
                                confirmButtonColor: '#ec7063',
                                cancelButtonColor: '#6c757d',
                                customClass: {
                                    popup: 'modern-swal-popup',
                                    confirmButton: 'modern-swal-confirm',
                                    cancelButton: 'modern-swal-cancel'
                                }
                            }).then((result) => {
                                if (result.isConfirmed) {
                                    processDeviceRefresh(offlineDevices, 'offline');
                                }
                            });
                        } else {
                            Swal.fire({
                                title: 'No Offline Devices',
                                html: '<div style="text-align: center;">' +
                                    '<div style="font-size: 48px; color: #58d68d; margin-bottom: 20px;">' +
                                    '<i class="fa fa-check-circle"></i>' +
                                    '</div>' +
                                    '<p style="font-size: 16px; color: #495057;">All devices are currently online!</p>' +
                                    '</div>',
                                icon: null,
                                confirmButtonText: 'OK',
                                confirmButtonColor: '#58d68d'
                            });
                        }
                    },
                    error: function() {
                        Swal.fire('Error!', 'Failed to get device list', 'error');
                    }
                });
                return;

                Swal.fire({
                    title: 'Refresh Offline Devices',
                    html: '<div style="text-align: center;">' +
                        '<div style="font-size: 48px; color: #ec7063; margin-bottom: 20px;">' +
                        '<i class="fa fa-exclamation-circle"></i>' +
                        '</div>' +
                        '<p style="font-size: 16px; color: #495057;">Found <strong style="color: #ec7063;">' +
                        offlineDevices.length + '</strong> offline device(s)</p>' +
                        '<p style="font-size: 14px; color: #6c757d; margin-top: 10px;">This will attempt to reconnect and update their status</p>' +
                        '</div>',
                    icon: null,
                    showCancelButton: true,
                    confirmButtonText: 'Refresh All',
                    cancelButtonText: 'Cancel',
                    confirmButtonColor: '#ec7063',
                    cancelButtonColor: '#6c757d',
                    customClass: {
                        popup: 'modern-swal-popup',
                        confirmButton: 'modern-swal-confirm',
                        cancelButton: 'modern-swal-cancel'
                    }
                }).then((result) => {
                    if (result.isConfirmed) {
                        processDeviceRefresh(offlineDevices, 'offline');
                    }
                });
            }
        }

        // Process device refresh with delay
        function processDeviceRefresh(devices, type) {
            var totalDevices = devices.length;
            var currentIndex = 0;
            var successCount = 0;
            var failCount = 0;

            // Show progress
            Swal.fire({
                title: '',
                html: '<div class="refresh-modal-container">' +
                    '<div class="refresh-header">' +
                    '<div class="refresh-icon-spinner">' +
                    '<i class="fa fa-refresh fa-spin"></i>' +
                    '</div>' +
                    '<h3>Refreshing Devices</h3>' +
                    '</div>' +
                    '<div class="refresh-stats">' +
                    '<div class="stat-item">' +
                    '<span class="stat-number" id="current-device">1</span>' +
                    '<span class="stat-label">Current</span>' +
                    '</div>' +
                    '<div class="stat-divider">/</div>' +
                    '<div class="stat-item">' +
                    '<span class="stat-number">' + totalDevices + '</span>' +
                    '<span class="stat-label">Total</span>' +
                    '</div>' +
                    '</div>' +
                    '<div class="progress-container">' +
                    '<div class="progress-bar-modern">' +
                    '<div id="refresh-progress" class="progress-fill" style="width: 0%">' +
                    '<span class="progress-text">0%</span>' +
                    '</div>' +
                    '</div>' +
                    '</div>' +
                    '<div class="device-info">' +
                    '<span class="device-label">Processing:</span>' +
                    '<span class="device-name" id="device-name">Initializing...</span>' +
                    '</div>' +
                    '<div class="refresh-counters">' +
                    '<div class="counter-success">' +
                    '<i class="fa fa-check-circle"></i> <span id="success-count">0</span>' +
                    '</div>' +
                    '<div class="counter-fail">' +
                    '<i class="fa fa-times-circle"></i> <span id="fail-count">0</span>' +
                    '</div>' +
                    '</div>' +
                    '</div>',
                allowOutsideClick: false,
                showConfirmButton: false,
                width: '480px',
                customClass: {
                    popup: 'refresh-modal-popup'
                },
                didOpen: () => {
                    refreshNextDevice();
                }
            });

            function refreshNextDevice() {
                if (currentIndex >= totalDevices) {
                    // All done
                    var statusIcon = successCount > 0 ? 'fa-check-circle' : 'fa-exclamation-circle';
                    var statusColor = successCount > 0 ? '#58d68d' : '#ec7063';

                    Swal.fire({
                        title: '',
                        html: '<div class="refresh-complete-container">' +
                            '<div class="complete-icon" style="color: ' + statusColor + ';">' +
                            '<i class="fa ' + statusIcon + '"></i>' +
                            '</div>' +
                            '<h3>Refresh Complete</h3>' +
                            '<div class="complete-stats">' +
                            '<div class="stat-box success">' +
                            '<i class="fa fa-check"></i>' +
                            '<span class="stat-value">' + successCount + '</span>' +
                            '<span class="stat-label">Success</span>' +
                            '</div>' +
                            '<div class="stat-box fail">' +
                            '<i class="fa fa-times"></i>' +
                            '<span class="stat-value">' + failCount + '</span>' +
                            '<span class="stat-label">Failed</span>' +
                            '</div>' +
                            '</div>' +
                            '<p class="complete-message">Page will reload in 3 seconds...</p>' +
                            '</div>',
                        showConfirmButton: false,
                        timer: 3000,
                        width: '400px',
                        customClass: {
                            popup: 'refresh-complete-popup'
                        }
                    }).then(() => {
                        location.reload();
                    });
                    return;
                }

                var device = devices[currentIndex];
                var progress = Math.round(((currentIndex + 1) / totalDevices) * 100);

                // Use username or model for display
                var deviceDisplay = '';
                if (device.username && device.username !== 'Unknown User') {
                    deviceDisplay = device.username;
                } else if (device.model && device.model !== 'Device') {
                    deviceDisplay = device.model;
                } else {
                    // Fallback to cleaned ID
                    deviceDisplay = device.id;
                    if (deviceDisplay.includes('-')) {
                        var parts = deviceDisplay.split('-');
                        if (parts.length > 1) {
                            deviceDisplay = parts[1]; // Usually the model part
                        }
                    }
                    deviceDisplay = decodeURIComponent(deviceDisplay);
                }

                // Truncate if too long
                if (deviceDisplay.length > 35) {
                    deviceDisplay = deviceDisplay.substring(0, 32) + '...';
                }

                // Update progress
                $('#current-device').text(currentIndex + 1);
                $('#refresh-progress').css('width', progress + '%');
                $('#refresh-progress .progress-text').text(progress + '%');
                $('#device-name').text(deviceDisplay);
                $('#success-count').text(successCount);
                $('#fail-count').text(failCount);

                // Call summon for this device
                $.ajax({
                    url: '{$_url}plugin/genieacs_devices/summon',
                    type: 'GET',
                    data: { device_id: device.id },
                    dataType: 'json',
                    timeout: 10000, // 10 second timeout per device
                    success: function(response) {
                        if (response && response.success) {
                            successCount++;
                        } else {
                            failCount++;
                        }
                        currentIndex++;

                        // Add delay before next device (2 seconds)
                        setTimeout(function() {
                            refreshNextDevice();
                        }, 2000);
                    },
                    error: function() {
                        failCount++;
                        currentIndex++;

                        // Add delay before next device even on error
                        setTimeout(function() {
                            refreshNextDevice();
                        }, 2000);
                    }
                });
            }
        }

        // Update checkbox state after filter/pagination
        function updateCheckboxState() {
            // Reset select all checkbox
            $('#selectAll').prop('checked', false);

            // Check if all visible devices are selected
            var visibleCheckboxes = $('.device-checkbox:visible');
            var checkedVisible = $('.device-checkbox:checked:visible');

            if (visibleCheckboxes.length > 0 && visibleCheckboxes.length === checkedVisible.length) {
                $('#selectAll').prop('checked', true);
            }

            updateRefreshButton();
        }

        function summonDevice(deviceId) {
            Swal.fire({
                title: 'Panggil Perangkat?',
                text: 'Sistem akan menghubungi perangkat dan memperbarui data terbaru',
                icon: 'question',
                showCancelButton: true,
                confirmButtonText: 'Ya, panggil!',
                cancelButtonText: 'Batal'
            }).then((result) => {
                if (result.isConfirmed) {
                    executeSummonSequence(deviceId);
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
                        data: { device_id: deviceId },
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

        // REMOVED auto refresh - now fully manual
    </script>

    <script>
        // Global variable for realtime search  
        var searchTimer;

        // Store device data on load
        $(document).ready(function() {
            // Animate count-up numbers
            animateCountUp();

            // Setup event handlers for filters - now submit form to server
            $('#searchInput').on('keyup', function(e) {
                if (e.keyCode === 13) { // Enter key
                    applyServerFilters();
                }
            });

            // Setup realtime search handler - LANGSUNG AKTIF
            $('#ajaxSearchInput').on('keyup', function(e) {
                // Skip Enter key
                if (e.keyCode === 13) {
                    $(this).closest('form').submit();
                    return;
                }

                clearTimeout(searchTimer);
                var searchValue = $(this).val().trim();

                // Show/hide clear button based on search value
                if (searchValue !== '') {
                    $('#clearFiltersBtn').show();
                } else {
                    $('#clearFiltersBtn').hide();
                }

                // Jika search kosong, reload halaman
                if (searchValue === '' || searchValue.length === 0) {
                    searchTimer = setTimeout(function() {
                        window.location.href = 'index.php?_route=plugin/genieacs_devices';
                    }, 500);
                    return;
                }

                searchTimer = setTimeout(function() {
                    performAjaxSearch(searchValue);
                }, 500);
            });

            // Tambah fungsi clearAllFilters
            function clearAllFilters() {
                $('#ajaxSearchInput').val('');
                $('#statusFilter').val('');
                $('#rxPowerFilter').val('');
                if ($('#locationFilter').length > 0) {
                    $('#locationFilter').val('');
                }
                window.location.href = 'index.php?_route=plugin/genieacs_devices';
            }

            $('#statusFilter').on('change', function() {
                applyServerFilters();
            });

            $('#rxPowerFilter').on('change', function() {
                applyServerFilters();
            });

            // Check if location filter exists
            if ($('#locationFilter').length > 0) {
                $('#locationFilter').on('change', function() {
                    applyServerFilters();
                });
            }
        }); // Penutup document.ready yang benar

        // Perform AJAX search
        function performAjaxSearch(searchTerm) {
            $('#searchStatus').text('Searching...');

            $.ajax({
                url: 'index.php?_route=plugin/genieacs_devices/ajax-search',
                type: 'GET',
                data: {
                    q: searchTerm,
                    page: 1
                },
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        if (response.display_params) {
                            window.searchDisplayParams = response.display_params;
                        }

                        // Update both desktop and mobile without reload
                        updateDeviceTable(response.devices);
                        updateMobileView(response.devices); // Tambah update mobile specific

                        $('#searchStatus').text('Found ' + response.total + ' devices');

                        if (response.total_pages > 1) {
                            updatePagination(response.page, response.total_pages, searchTerm);
                        } else {
                            $('#pagination-controls').empty();
                        }
                    }
                },
                error: function() {
                    $('#searchStatus').text('Search failed');
                }
            });
        }

        // Tambah function khusus mobile
        function updateMobileView(devices) {
            // Find mobile container (adjust selector based on your template)
            var mobileContainer = $('.visible-xs .table tbody, .mobile-device-list, #mobileDeviceTable tbody');

            if (mobileContainer.length === 0) return;

            mobileContainer.empty();

            if (devices.length === 0) {
                mobileContainer.append('<tr><td class="text-center">No devices found</td></tr>');
                return;
            }

            devices.forEach(function(device) {
                var mobileRow = '<tr>';
                mobileRow += '<td>';
                mobileRow += '<strong>' + (device.pppoe_username || device.device_id) + '</strong><br>';
                mobileRow += 'IP: ' + (device.pppoe_ip || 'N/A') + '<br>';
                mobileRow += 'Status: ' + (device.status === 'online' ?
                    '<span class="label label-success">Online</span>' :
                    '<span class="label label-danger">Offline</span>') + '<br>';
                if (device.rx_power) {
                    mobileRow += 'RX: ' + device.rx_power + ' dBm<br>';
                }
                mobileRow += '<a href="index.php?_route=plugin/genieacs_device_detail/' + device.device_id +
                    '" class="btn btn-xs btn-primary">View</a>';
                mobileRow += '</td>';
                mobileRow += '</tr>';

                mobileContainer.append(mobileRow);
            });
        }

        // Update table with search results
        function updateDeviceTable(devices) {
            var tbody = $('#deviceTable tbody');
            tbody.empty();

            if (devices.length === 0) {
                tbody.append('<tr><td colspan="20" class="text-center">No devices found</td></tr>');
                return;
            }

            // Use display params dari server
            var paramsToUse = window.searchDisplayParams || [];

            devices.forEach(function(device) {
                var row = '<tr>';

                // Checkbox
                row +=
                    '<td class="text-center"><input type="checkbox" class="device-checkbox" data-device-id="' +
                    device.device_id + '" data-device-status="' + device.status + '"></td>';

                // Status
                if (device.status === 'online') {
                    row += '<td class="text-center"><span class="label label-success">Online</span></td>';
                } else {
                    row += '<td class="text-center"><span class="label label-danger">Offline</span></td>';
                }

                // Dynamic columns dari display params
                paramsToUse.forEach(function(param) {
                    var value = device[param.key] || '';

                    // Special formatting
                    if (param.key === 'rx_power' && value !== '') {
                        var rxValue = parseFloat(value);
                        if (rxValue >= -20) {
                            row += '<td><span class="text-success">' + value + ' dBm</span></td>';
                        } else if (rxValue >= -25) {
                            row += '<td><span class="text-warning">' + value + ' dBm</span></td>';
                        } else {
                            row += '<td><span class="text-danger">' + value + ' dBm</span></td>';
                        }
                    } else if (param.key === 'temperature' && value !== '') {
                        row += '<td>' + value + '°C</td>';
                    } else if (param.label.includes('PON') && value !== '') {
                        if (value === 'GPON') {
                            row += '<td><span class="label label-primary">' + value + '</span></td>';
                        } else if (value === 'EPON') {
                            row += '<td><span class="label label-info">' + value + '</span></td>';
                        } else {
                            row += '<td>' + value + '</td>';
                        }
                    } else {
                        row += '<td>' + (value || 'N/A') + '</td>';
                    }
                });

                // Tags & Lokasi
                if (device.tags) {
                    row += '<td class="text-center"><span class="badge badge-user">' + device.tags +
                        '</span></td>';
                } else {
                    row += '<td class="text-center">-</td>';
                }

                if (device.lokasi) {
                    row += '<td class="text-center"><span class="badge badge-location">' + device.lokasi +
                        '</span></td>';
                } else {
                    row += '<td class="text-center">-</td>';
                }

                // Last & Actions
                row += '<td><small>' + (device.last_inform || 'Never') + '</small></td>';
                row += '<td class="action-column">';
                row += '<div class="btn-group">';
                row +=
                    '<button type="button" class="btn btn-primary btn-xs dropdown-toggle" data-toggle="dropdown">';
                row += '<i class="fa fa-cog"></i> <span class="caret"></span></button>';
                row += '<ul class="dropdown-menu dropdown-menu-right">';
                row += '<li><a href="index.php?_route=plugin/genieacs_device_detail/' + device.device_id +
                    '"><i class="fa fa-eye"></i> View Details</a></li>';
                row += '<li><a href="javascript:void(0)" onclick="summonDevice(\'' + device.device_id +
                    '\')"><i class="fa fa-bell"></i> Summon</a></li>';
                row += '<li><a href="javascript:void(0)" onclick="rebootDevice(\'' + device.device_id +
                    '\')"><i class="fa fa-power-off"></i> Reboot</a></li>';
                row += '</ul></div></td>';
                row += '</tr>';

                tbody.append(row);
            });

            updateCheckboxState();
        }

        // Update pagination for AJAX results
        function updatePagination(currentPage, totalPages, searchTerm) {
            var paginationHtml = '';

            if (currentPage > 1) {
                paginationHtml += '<li><a href="javascript:void(0)" onclick="performAjaxSearchPage(\'' + searchTerm +
                    '\', ' + (currentPage - 1) + ')">«</a></li>';
            } else {
                paginationHtml += '<li class="disabled"><span>«</span></li>';
            }

            for (var i = 1; i <= totalPages; i++) {
                if (i === currentPage) {
                    paginationHtml += '<li class="active"><span>' + i + '</span></li>';
                } else {
                    paginationHtml += '<li><a href="javascript:void(0)" onclick="performAjaxSearchPage(\'' +
                        searchTerm + '\', ' + i + ')">' + i + '</a></li>';
                }
            }

            if (currentPage < totalPages) {
                paginationHtml += '<li><a href="javascript:void(0)" onclick="performAjaxSearchPage(\'' + searchTerm +
                    '\', ' + (currentPage + 1) + ')">»</a></li>';
            } else {
                paginationHtml += '<li class="disabled"><span>»</span></li>';
            }

            $('#pagination-controls').html(paginationHtml);
        }

        // Search with specific page
        function performAjaxSearchPage(searchTerm, page) {
            $.ajax({
                url: 'index.php?_route=plugin/genieacs_devices/ajax-search',
                type: 'GET',
                data: {
                    q: searchTerm,
                    page: page
                },
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        updateDeviceTable(response.devices);
                        updatePagination(response.page, response.total_pages, searchTerm);
                    }
                }
            });
        }

        // Make table rows clickable with text selection support
        $(document).on('click', '#deviceTable tbody tr', function(e) {
            // Don't trigger if clicking on checkbox, button, or dropdown
            if ($(e.target).closest('.device-checkbox, .btn, .dropdown-menu, .action-column').length) {
                return;
            }

            // Check if user is selecting text
            var selection = window.getSelection().toString();
            if (selection.length > 0) {
                return; // User is selecting text, don't navigate
            }

            // Get device ID from checkbox in same row
            var deviceId = $(this).find('.device-checkbox').data('device-id');
            if (deviceId) {
                window.location.href = 'index.php?_route=plugin/genieacs_device_detail/' + deviceId;
            }
        });

        // Dynamic dropdown direction based on position
        $(document).on('click', '.action-column .dropdown-toggle', function() {
            var $button = $(this);
            var $dropdown = $button.parent();

            // Calculate position
            var buttonOffset = $button.offset().top;
            var windowHeight = $(window).height();
            var dropdownHeight = 150; // Approximate height

            // If near bottom, make it dropup
            if ((windowHeight - buttonOffset) < dropdownHeight + 50) {
                $dropdown.removeClass('dropdown').addClass('dropup');
            } else {
                $dropdown.removeClass('dropup').addClass('dropdown');
            }
        });

        // Function to view device detail
        function viewDeviceDetail(deviceId) {
            window.location.href = 'index.php?_route=plugin/genieacs_device_detail/' + deviceId;
        }

        // Count-up animation function
        function animateCountUp() {
            $('.count-up').each(function() {
                var $this = $(this);
                var target = parseInt($this.data('target'));
                var duration = 1500; // 1.5 seconds
                var steps = 60;
                var stepDuration = duration / steps;
                var increment = target / steps;
                var current = 0;

                var timer = setInterval(function() {
                    current += increment;
                    if (current >= target) {
                        current = target;
                        clearInterval(timer);
                    }
                    $this.text(Math.floor(current));
                }, stepDuration);
            });

            // Animate progress bars
            setTimeout(function() {
                $('.progress-bar-fill').css('transition', 'width 1.5s ease-in-out');
            }, 100);
        }

        function forceSync() {
            Swal.fire({
                title: 'Force Sync',
                text: 'This will sync all devices from ACS servers. Continue?',
                icon: 'question',
                showCancelButton: true,
                confirmButtonText: 'Yes, sync now!'
            }).then((result) => {
                if (result.isConfirmed) {
                    Swal.fire({
                        title: 'Syncing...',
                        text: 'Please wait while syncing devices',
                        allowOutsideClick: false,
                        didOpen: () => {
                            Swal.showLoading();
                        }
                    });

                    $.ajax({
                        url: '{$_url}plugin/genieacs_devices/force-sync',
                        type: 'GET',
                        dataType: 'json',
                        timeout: 120000,
                        success: function(response) {
                            if (response.success) {
                                Swal.fire('Success!', response.message || 'Devices synced.', 'success')
                                    .then(() => {
                                        location.reload();
                                    });
                            } else {
                                Swal.fire('Error!', response.error || 'Sync failed', 'error');
                            }
                        },
                        error: function(xhr) {
                            var msg = (xhr.responseJSON && xhr.responseJSON.error) ? xhr.responseJSON.error : 'Failed to communicate with server';
                            if (xhr.status === 0 || xhr.status === 408) msg = 'Request timed out. Try again.';
                            Swal.fire('Error!', msg, 'error');
                        }
                    });
                }
            });
        }

        function clearSearch() {
            $('#searchInput').val('');
            applyFilters();
        }

        function clearAllFilters() {
            // Clear semua input
            $('#ajaxSearchInput').val('');
            $('#searchInput').val('');
            $('#statusFilter').val('');
            $('#rxPowerFilter').val('');
            if ($('#locationFilter').length > 0) {
                $('#locationFilter').val('');
            }

            // Langsung reload ke halaman awal tanpa filter
            window.location.href = 'index.php?_route=plugin/genieacs_devices';
        }

        // ===== FUNGSI SEQUENCE PANGGIL PERANGKAT =====
        function executeSummonSequence(deviceId) {
            console.log('Memulai sequence panggil perangkat:', deviceId);

            Swal.fire({
                title: 'Menghubungi Perangkat...',
                text: 'Mohon tunggu, sedang mengirim permintaan koneksi ke perangkat',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });

            $.ajax({
                url: 'index.php?_route=plugin/genieacs_devices/summon',
                type: 'GET',
                data: { device_id: deviceId },
                dataType: 'json',
                timeout: 15000,
                success: function(response) {
                    if (response && response.success) {
                        console.log('Panggil perangkat berhasil, memulai refresh data...');

                        // BERHASIL - lanjut ke refresh dengan delay 5 detik
                        Swal.fire({
                            title: 'Memperbarui Data Perangkat...',
                            text: 'Sistem mengambil informasi terbaru dalam 5 detik',
                            timer: 5000,
                            timerProgressBar: true,
                            allowOutsideClick: false,
                            didOpen: () => {
                                Swal.showLoading();
                            }
                        }).then(() => {
                            executeAutoRefresh(deviceId);
                        });
                    } else {
                        var errorMsg = 'Gagal menghubungi perangkat';
                        if (response && response.error) {
                            errorMsg = response.error;
                        }
                        Swal.fire('Gagal!', errorMsg, 'error');
                    }
                },
                error: function(xhr) {
                    console.error('Panggil perangkat AJAX Error:', xhr);

                    let errorMessage = 'Gagal berkomunikasi dengan server';
                    if (xhr.status === 0) {
                        errorMessage = 'Error jaringan - periksa koneksi internet Anda';
                    } else if (xhr.status === 404) {
                        errorMessage = 'Endpoint tidak ditemukan';
                    } else if (xhr.status === 500) {
                        errorMessage = 'Terjadi error pada server';
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

        function executeAutoRefresh(deviceId) {
            console.log('Menjalankan auto refresh untuk perangkat:', deviceId);

            Swal.fire({
                title: 'Sinkronisasi Data Terbaru...',
                text: 'Mohon tunggu, sedang menyinkronkan informasi perangkat',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });

            $.ajax({
                url: 'index.php?_route=plugin/genieacs_devices/refresh',
                type: 'GET',
                data: { device_id: deviceId },
                dataType: 'json',
                success: function(response) {
                    if (response && response.success) {
                        console.log('Auto refresh berhasil, menyelesaikan sequence...');

                        Swal.fire('Berhasil!',
                            'Perangkat berhasil dipanggil dan data telah diperbarui! Halaman akan dimuat ulang.',
                            'success').then(() => {

                            // ===== MUAT ULANG HALAMAN DENGAN DELAY =====
                            Swal.fire({
                                title: 'Memuat Ulang Halaman...',
                                text: 'Mohon tunggu, sedang memperbarui dengan data terbaru',
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
                        // Warning tapi tetap reload
                        var errorMsg = 'Sinkronisasi gagal';
                        if (response && response.error) {
                            errorMsg = response.error;
                        }
                        console.error('Auto refresh gagal:', errorMsg);

                        Swal.fire('Peringatan!', 'Panggil perangkat berhasil tetapi sinkronisasi gagal: ' +
                            errorMsg +
                            '. Halaman akan dimuat ulang.', 'warning').then(() => {

                            Swal.fire({
                                title: 'Memuat Ulang Halaman...',
                                text: 'Mohon tunggu, sedang memperbarui data',
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
                    console.error('Auto refresh AJAX Error:', xhr);

                    Swal.fire('Peringatan!',
                        'Panggil perangkat berhasil tetapi sinkronisasi gagal. Halaman akan dimuat ulang.',
                        'warning').then(() => {

                        Swal.fire({
                            title: 'Memuat Ulang Halaman...',
                            text: 'Mohon tunggu, sedang memperbarui data',
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

        function changeServer() {
            // Get value from whichever selector triggered the change
            var serverId = $('#quickServerSwitch').val() || $('#serverSelector').val();

            // Reset pagination when changing server
            currentPage = 1;

            // Show loading indicator
            Swal.fire({
                title: 'Switching Server...',
                text: 'Please wait',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });

            // Set server via AJAX then reload
            $.ajax({
                url: 'index.php?_route=plugin/genieacs_devices/set-server',
                type: 'POST',
                data: { server_id: serverId },
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        window.location.href = 'index.php?_route=plugin/genieacs_devices';
                    }
                },
                error: function() {
                    window.location.href = 'index.php?_route=plugin/genieacs_devices';
                }
            });
        }
    </script>

    <style>
        /* RX Power Filter Option Styling */
        #rxPowerFilter option {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* Dark mode support for RX filter */
        .dark-mode #rxPowerFilter,
        body.dark-mode #rxPowerFilter,
        [data-theme="dark"] #rxPowerFilter {
            background-color: #34495e !important;
            color: #ecf0f1 !important;
            border-color: #4a5f7a !important;
        }

        .dark-mode #rxPowerFilter option,
        body.dark-mode #rxPowerFilter option,
        [data-theme="dark"] #rxPowerFilter option {
            background-color: #34495e !important;
            color: #ecf0f1 !important;
        }

        /* ===== 5 COLUMN LAYOUT ===== */
        .five-cols {
            margin-left: -7.5px;
            margin-right: -7.5px;
        }

        .col-md-5ths {
            position: relative;
            min-height: 1px;
            padding-right: 7.5px;
            padding-left: 7.5px;
        }

        /* Desktop - 5 columns */
        @media (min-width: 992px) {
            .col-md-5ths {
                width: 20%;
                float: left;
            }
        }

        /* Tablet - 3 columns */
        @media (min-width: 768px) and (max-width: 991px) {
            .col-md-5ths {
                width: 33.33333%;
                float: left;
            }

            .col-md-5ths:nth-child(4),
            .col-md-5ths:nth-child(5) {
                width: 50%;
            }
        }

        /* Mobile - 2 columns */
        @media (min-width: 480px) and (max-width: 767px) {
            .col-md-5ths {
                width: 50%;
                float: left;
            }
        }

        /* Small Mobile - 1 column */
        @media (max-width: 479px) {
            .col-md-5ths {
                width: 100%;
                float: none;
            }
        }

        /* Checkbox styles */
        .device-checkbox {
            cursor: pointer;
        }

        #selectAll {
            cursor: pointer;
        }

        /* Progress bar in Swal */
        .progress {
            height: 20px;
            margin-bottom: 0;
            overflow: hidden;
            background-color: #f5f5f5;
            border-radius: 4px;
            box-shadow: inset 0 1px 2px rgba(0, 0, 0, .1);
        }

        .progress-bar {
            float: left;
            width: 0;
            height: 100%;
            font-size: 12px;
            line-height: 20px;
            color: #fff;
            text-align: center;
            background-color: #337ab7;
            box-shadow: inset 0 -1px 0 rgba(0, 0, 0, .15);
            transition: width .6s ease;
        }

        .progress-bar-striped {
            background-image: linear-gradient(45deg, rgba(255, 255, 255, .15) 25%, transparent 25%, transparent 50%, rgba(255, 255, 255, .15) 50%, rgba(255, 255, 255, .15) 75%, transparent 75%, transparent);
            background-size: 40px 40px;
        }

        .progress-bar.active {
            animation: progress-bar-stripes 2s linear infinite;
        }

        @keyframes progress-bar-stripes {
            from {
                background-position: 40px 0;
            }

            to {
                background-position: 0 0;
            }
        }

        /* Pagination styles */
        .pagination-info {
            padding: 10px 0;
            color: #666;
            font-size: 14px;
        }

        .pagination {
            margin: 0;
        }

        .pagination>li>a,
        .pagination>li>span {
            padding: 5px 10px;
            font-size: 12px;
        }

        .panel-footer {
            background-color: #f5f5f5;
            border-top: 1px solid #ddd;
        }

        /* Mobile responsive */
        @media (max-width: 767px) {
            .pagination-info {
                text-align: center;
                margin-bottom: 10px;
                font-size: 12px;
            }

            nav[aria-label="Page navigation"] {
                text-align: center;
            }

            .pagination {
                display: inline-block;
            }

            .panel-footer {
                padding: 10px;
            }
        }

        @media (max-width: 480px) {

            .pagination>li>a,
            .pagination>li>span {
                padding: 3px 6px;
                font-size: 11px;
            }

            .pagination-info {
                font-size: 11px;
            }
        }

        /* Table column width optimization */
        #deviceTable th:nth-child(1) {
            width: 60px;
        }

        /* Status */
        #deviceTable th:nth-child(2) {
            width: 150px;
        }

        /* Device ID */
        #deviceTable th:nth-child(3) {
            width: 120px;
        }

        /* PPPoE Username */
        #deviceTable th:nth-child(4) {
            width: 80px;
        }

        /* Username Tag */
        #deviceTable th:nth-child(5) {
            width: 100px;
        }

        /* Lokasi */
        #deviceTable th:nth-child(6) {
            width: 120px;
        }

        /* Model */
        #deviceTable th:nth-child(7) {
            width: 100px;
        }

        /* Manufacturer */
        #deviceTable th:nth-child(8) {
            width: 70px;
        }

        /* PON Type */
        #deviceTable th:nth-child(9) {
            width: 80px;
        }

        /* RX Power */
        #deviceTable th:nth-child(10) {
            width: 100px;
        }

        /* IP Address */
        #deviceTable th:nth-child(11) {
            width: 100px;
        }

        /* Uptime */
        #deviceTable th:nth-child(12) {
            width: 80px;
        }

        /* Last Inform */
        #deviceTable th:nth-child(13) {
            width: 150px;
        }

        /* Actions */

        /* Custom badge styles */
        .badge-user {
            background-color: #e3f2fd;
            color: #1565c0;
            border: 1px solid #90caf9;
            font-size: 11px;
            padding: 3px 6px;
            border-radius: 3px;
            font-weight: 600;
        }

        .badge-location {
            background-color: #fff3e0;
            color: #e65100;
            border: 1px solid #ffcc80;
            font-size: 11px;
            padding: 3px 6px;
            border-radius: 3px;
            font-weight: 600;
        }

        /* Dark mode badge styles */
        .dark-mode .badge-user,
        body.dark-mode .badge-user {
            background-color: #1e3a5f;
            color: #90caf9;
            border-color: #42a5f5;
        }

        .dark-mode .badge-location,
        body.dark-mode .badge-location {
            background-color: #4a3c28;
            color: #ffb74d;
            border-color: #ff9800;
        }

        /* Mobile optimization */
        @media (max-width: 767px) {
            .panel-body {
                padding: 10px;
            }

            .mb-1 {
                margin-bottom: 5px;
            }

            .mb-2 {
                margin-bottom: 10px;
            }

            .mt-2 {
                margin-top: 10px;
            }
        }

        /* Responsive Panel Header */
        @media (max-width: 991px) {
            .panel-heading {
                padding: 10px 15px;
            }

            .panel-heading .pull-right {
                float: none !important;
                margin-top: 10px;
                display: flex;
                flex-wrap: wrap;
                gap: 5px;
                justify-content: flex-start;
            }

            .panel-heading .pull-right .btn {
                flex: 1;
                min-width: 120px;
            }

            .panel-heading .pull-right .badge {
                width: 100%;
                display: block;
                margin-top: 5px;
                padding: 5px 10px;
            }
        }

        @media (max-width: 576px) {
            .panel-heading {
                text-align: center;
            }

            .panel-heading>i {
                display: block;
                margin-bottom: 5px;
            }

            .panel-heading .pull-right {
                justify-content: center;
            }

            .panel-heading .pull-right .btn {
                font-size: 12px;
                padding: 5px 10px;
            }

            #refreshButtonText {
                display: inline !important;
            }
        }

        /* Responsive Filter Section */
        @media (max-width: 991px) {
            .panel-body .row>[class*='col-'] {
                margin-bottom: 10px;
            }

            #searchResult {
                display: block;
                text-align: center;
                margin-top: 10px;
            }
        }

        /* Mobile Device Cards Optimization */
        @media (max-width: 767px) {
            .device-card {
                margin-bottom: 10px !important;
            }

            .device-card .panel-body {
                padding: 10px !important;
            }

            .device-card .row {
                margin-left: 0;
                margin-right: 0;
            }

            .device-card [class*='col-'] {
                padding-left: 5px;
                padding-right: 5px;
            }

            .device-card strong {
                font-size: 12px;
            }

            .device-card small {
                font-size: 11px;
            }

            .device-card .label {
                font-size: 10px;
                padding: 2px 4px;
            }

            .device-card hr {
                margin: 8px 0;
            }

            .device-card .btn-group-justified .btn {
                font-size: 12px;
                padding: 5px;
            }
        }

        @media (max-width: 480px) {
            .device-card .panel-body {
                padding: 8px !important;
            }

            .device-card .btn-group-justified {
                display: flex;
                gap: 5px;
            }

            .device-card .btn-group {
                flex: 1;
                display: flex;
                gap: 5px;
            }

            .device-card .btn-group .btn {
                flex: 1;
            }
        }

        @media (max-width: 360px) {
            .device-card {
                font-size: 11px;
            }

            .device-card strong {
                font-size: 11px;
            }

            .device-card .btn-xs {
                font-size: 10px;
                padding: 3px 5px;
            }

            .badge-user,
            .badge-location {
                font-size: 9px !important;
                padding: 2px 4px !important;
            }
        }

        @media (max-width: 768px) {
            .panel-body .row {
                margin: 0 -5px;
            }

            .panel-body .row>[class*='col-'] {
                padding: 0 5px;
            }

            .input-group {
                width: 100%;
            }

            select.form-control {
                font-size: 14px;
            }
        }

        @media (max-width: 576px) {
            .panel-body {
                padding: 10px 5px;
            }

            .input-group input {
                font-size: 14px;
            }

            .btn-block {
                font-size: 14px;
            }
        }
    </style>
    <style>
        /* Dark Mode Support for AdminLTE */
        .dark-mode .panel {
            background-color: #2c3e50;
            border-color: #34495e;
        }

        .dark-mode .panel-heading {
            background-color: #34495e;
            border-color: #2c3e50;
            color: #ecf0f1;
        }

        .dark-mode .panel-body {
            background-color: #2c3e50;
            color: #ecf0f1;
        }

        .dark-mode .table {
            background-color: #34495e;
            color: #ecf0f1;
        }

        .dark-mode .table-bordered {
            border-color: #4a5f7a;
        }

        .dark-mode .table-striped>tbody>tr:nth-of-type(odd) {
            background-color: #2c3e50;
        }

        .dark-mode .table-hover>tbody>tr:hover {
            background-color: #4a5f7a;
        }

        .dark-mode .form-control {
            background-color: #34495e;
            border-color: #4a5f7a;
            color: #ecf0f1;
        }

        .dark-mode .form-control:focus {
            background-color: #34495e;
            border-color: #5a8db8;
            color: #ecf0f1;
            box-shadow: 0 0 0 0.2rem rgba(90, 141, 184, 0.25);
        }

        .dark-mode .btn-default {
            background-color: #34495e;
            border-color: #4a5f7a;
            color: #ecf0f1;
        }

        .dark-mode .btn-default:hover {
            background-color: #4a5f7a;
            border-color: #5a8db8;
            color: #fff;
        }

        .dark-mode .alert-info {
            background-color: #34495e;
            border-color: #4a5f7a;
            color: #ecf0f1;
        }

        .dark-mode .modal-content {
            background-color: #2c3e50;
            color: #ecf0f1;
        }

        .dark-mode .modal-header {
            border-bottom-color: #34495e;
        }

        .dark-mode .modal-footer {
            border-top-color: #34495e;
        }

        .dark-mode .dropdown-menu {
            background-color: #34495e;
            border-color: #4a5f7a;
        }

        .dark-mode .dropdown-menu>li>a {
            color: #ecf0f1;
        }

        .dark-mode .dropdown-menu>li>a:hover {
            background-color: #4a5f7a;
            color: #fff;
        }

        .dark-mode select.form-control {
            background-color: #34495e;
            color: #ecf0f1;
        }

        .dark-mode select.form-control option {
            background-color: #34495e;
            color: #ecf0f1;
        }

        /* Label colors in dark mode */
        .dark-mode .label {
            opacity: 0.9;
        }

        .dark-mode .badge {
            opacity: 0.9;
        }

        /* Input group in dark mode */
        .dark-mode .input-group-btn .btn {
            background-color: #34495e;
            border-color: #4a5f7a;
            color: #ecf0f1;
        }

        .dark-mode .help-block {
            color: #95a5a6;
        }

        /* ===== STATISTICS CARDS STYLES ===== */
        .stats-cards-container {
            background: #f8f9fa;
            margin: 0;
        }

        .stats-card {
            background: white;
            border-radius: 8px;
            padding: 12px;
            margin-bottom: 15px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            min-height: 145px;
        }

        .stats-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
        }

        .stats-card .card-icon {
            position: absolute;
            right: 12px;
            top: 12px;
            font-size: 28px;
            opacity: 0.3;
        }

        .stats-card .card-content {
            position: relative;
            z-index: 1;
        }

        .stats-card .card-title {
            font-size: 12px;
            text-transform: uppercase;
            color: #6c757d;
            margin-bottom: 5px;
            font-weight: 600;
        }

        .stats-card .card-value {
            font-size: 28px;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }

        .stats-card .card-subtitle {
            font-size: 11px;
            color: #6c757d;
            margin-top: 5px;
        }

        .stats-card .card-status {
            font-size: 12px;
            margin-top: 5px;
            display: flex;
            align-items: center;
        }

        .status-indicator {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            display: inline-block;
            margin-right: 5px;
            animation: pulse 2s infinite;
        }

        .status-indicator.online {
            background-color: #28a745;
        }

        .status-indicator.offline {
            background-color: #dc3545;
        }

        @keyframes pulse {
            0% {
                opacity: 1;
            }

            50% {
                opacity: 0.5;
            }

            100% {
                opacity: 1;
            }
        }

        /* Progress bar styles */
        .progress-bar-container {
            width: 100%;
            height: 6px;
            background-color: #e9ecef;
            border-radius: 3px;
            overflow: hidden;
            margin: 10px 0;
        }

        .progress-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, #007bff, #0056b3);
            border-radius: 3px;
            transition: width 1.5s ease-in-out;
        }

        /* Card specific colors */
        .card-server {
            border-left: 4px solid #6f42c1;
        }

        .card-server .card-icon {
            color: #6f42c1;
        }

        .card-server .progress-bar-fill {
            background: linear-gradient(90deg, #6f42c1, #5a32a3);
        }

        .card-total {
            border-left: 4px solid #007bff;
        }

        .card-total .card-icon {
            color: #007bff;
        }

        .card-online {
            border-left: 4px solid #28a745;
        }

        .card-online .card-icon {
            color: #28a745;
        }

        .card-online .progress-bar-fill {
            background: linear-gradient(90deg, #28a745, #1e7e34);
        }

        .card-offline {
            border-left: 4px solid #dc3545;
        }

        .card-offline .card-icon {
            color: #dc3545;
        }

        .card-offline .progress-bar-fill {
            background: linear-gradient(90deg, #dc3545, #bd2130);
        }

        .card-warning {
            border-left: 4px solid #ffc107;
        }

        .card-warning .card-icon {
            color: #ffc107;
        }

        .card-warning .progress-bar-fill {
            background: linear-gradient(90deg, #ffc107, #e0a800);
        }

        /* Server name styling */
        .server-name {
            font-size: 16px !important;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            line-height: 1.2;
        }

        /* Smaller select for server card */
        #quickServerSwitch {
            font-size: 11px;
            padding: 3px 5px;
            height: 26px;
        }

        /* Dark Mode Support for Stats Cards */
        .dark-mode .stats-cards-container,
        body.dark-mode .stats-cards-container,
        [data-theme="dark"] .stats-cards-container {
            background: #343a40 !important;
        }

        .dark-mode .stats-card,
        body.dark-mode .stats-card,
        [data-theme="dark"] .stats-card {
            background: #495057 !important;
            border: 1px solid #6c757d !important;
        }

        /* Fix icon colors in dark mode */
        .dark-mode .stats-card .card-icon,
        body.dark-mode .stats-card .card-icon,
        [data-theme="dark"] .stats-card .card-icon {
            opacity: 0.6 !important;
        }

        .dark-mode .card-server .card-icon,
        body.dark-mode .card-server .card-icon,
        [data-theme="dark"] .card-server .card-icon {
            color: #a78bfa !important;
        }

        .dark-mode .card-total .card-icon,
        body.dark-mode .card-total .card-icon,
        [data-theme="dark"] .card-total .card-icon {
            color: #60a5fa !important;
        }

        .dark-mode .card-online .card-icon,
        body.dark-mode .card-online .card-icon,
        [data-theme="dark"] .card-online .card-icon {
            color: #4ade80 !important;
        }

        .dark-mode .card-offline .card-icon,
        body.dark-mode .card-offline .card-icon,
        [data-theme="dark"] .card-offline .card-icon {
            color: #f87171 !important;
        }

        .dark-mode .card-warning .card-icon,
        body.dark-mode .card-warning .card-icon,
        [data-theme="dark"] .card-warning .card-icon {
            color: #fbbf24 !important;
        }

        .dark-mode .stats-card .card-value,
        body.dark-mode .stats-card .card-value,
        [data-theme="dark"] .stats-card .card-value {
            color: #f8f9fa !important;
        }

        .dark-mode .stats-card .card-title,
        body.dark-mode .stats-card .card-title,
        [data-theme="dark"] .stats-card .card-title {
            color: #adb5bd !important;
        }

        .dark-mode .stats-card .card-subtitle,
        body.dark-mode .stats-card .card-subtitle,
        [data-theme="dark"] .stats-card .card-subtitle {
            color: #adb5bd !important;
        }

        .dark-mode .stats-card .card-status,
        body.dark-mode .stats-card .card-status,
        [data-theme="dark"] .stats-card .card-status {
            color: #dee2e6 !important;
        }

        .dark-mode .progress-bar-container,
        body.dark-mode .progress-bar-container,
        [data-theme="dark"] .progress-bar-container {
            background-color: #343a40 !important;
        }

        .dark-mode #quickServerSwitch,
        body.dark-mode #quickServerSwitch,
        [data-theme="dark"] #quickServerSwitch {
            background-color: #343a40 !important;
            color: #f8f9fa !important;
            border-color: #6c757d !important;
        }

        /* Responsive adjustments */
        @media (max-width: 991px) {
            .stats-card {
                margin-bottom: 10px;
                min-height: 130px;
            }

            .stats-card .card-value {
                font-size: 22px;
            }

            .stats-card .card-icon {
                font-size: 24px;
            }

            .server-name {
                font-size: 14px !important;
            }
        }

        /* No Devices Found Styling */
        .no-devices-container {
            padding: 60px 20px;
            text-align: center;
        }

        .no-devices-box {
            max-width: 400px;
            margin: 0 auto;
        }

        .no-devices-icon {
            width: 100px;
            height: 100px;
            margin: 0 auto 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            animation: pulse 2s infinite;
        }

        .no-devices-icon i {
            font-size: 48px;
            color: white;
        }

        .no-devices-title {
            font-size: 24px;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
        }

        .no-devices-text {
            font-size: 16px;
            color: #666;
            margin-bottom: 30px;
        }

        .no-devices-actions {
            display: flex;
            gap: 10px;
            justify-content: center;
        }

        @keyframes pulse {
            0% {
                box-shadow: 0 0 0 0 rgba(102, 126, 234, 0.7);
            }

            70% {
                box-shadow: 0 0 0 20px rgba(102, 126, 234, 0);
            }

            100% {
                box-shadow: 0 0 0 0 rgba(102, 126, 234, 0);
            }
        }

        /* Dark mode support for no devices */
        .dark-mode .no-devices-title,
        body.dark-mode .no-devices-title {
            color: #fff;
        }

        .dark-mode .no-devices-text,
        body.dark-mode .no-devices-text {
            color: #adb5bd;
        }

        /* Responsive no devices */
        @media (max-width: 480px) {
            .no-devices-actions {
                flex-direction: column;
            }

            .no-devices-actions .btn {
                width: 100%;
            }
        }

        /* Server Error Styling */
        .server-error-container {
            padding: 60px 20px;
            text-align: center;
        }

        .server-error-box {
            max-width: 500px;
            margin: 0 auto;
        }

        .server-error-icon {
            width: 100px;
            height: 100px;
            margin: 0 auto 20px;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            animation: pulse 2s infinite;
        }

        .server-error-icon i.fa-plug {
            font-size: 48px;
            color: white;
        }

        .error-badge {
            position: absolute;
            top: -5px;
            right: -5px;
            width: 35px;
            height: 35px;
            background: #dc3545;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 3px solid #fff;
        }

        .error-badge i {
            color: white;
            font-size: 16px;
        }

        .server-error-title {
            font-size: 24px;
            font-weight: 600;
            color: #dc3545;
            margin-bottom: 10px;
        }

        .server-error-message {
            font-size: 16px;
            color: #666;
            margin-bottom: 20px;
        }

        .server-error-details {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 30px;
            text-align: left;
        }

        .error-detail-item {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
            color: #666;
            font-size: 14px;
        }

        .error-detail-item:last-child {
            margin-bottom: 0;
        }

        .error-detail-item i {
            color: #dc3545;
            width: 20px;
        }

        .server-error-actions {
            display: flex;
            gap: 10px;
            justify-content: center;
        }

        /* Dark mode support for server error */
        .dark-mode .server-error-title,
        body.dark-mode .server-error-title {
            color: #f87171;
        }

        .dark-mode .server-error-message,
        body.dark-mode .server-error-message {
            color: #adb5bd;
        }

        .dark-mode .server-error-details,
        body.dark-mode .server-error-details {
            background: #2c3139;
        }

        .dark-mode .error-detail-item,
        body.dark-mode .error-detail-item {
            color: #adb5bd;
        }

        .dark-mode .error-badge,
        body.dark-mode .error-badge {
            border-color: #2c3139;
        }

        /* Responsive server error */
        @media (max-width: 480px) {
            .server-error-actions {
                flex-direction: column;
            }

            .server-error-actions .btn {
                width: 100%;
            }

            .server-error-details {
                font-size: 12px;
            }
        }


        @media (max-width: 768px) {
            .stats-cards-container {
                padding: 10px !important;
            }

            .stats-card {
                min-height: 110px;
                padding: 10px;
            }

            .stats-card .card-icon {
                font-size: 22px;
                right: 10px;
                top: 10px;
            }

            .stats-card .card-value {
                font-size: 20px;
                margin-bottom: 5px;
            }

            .stats-card .card-title {
                font-size: 11px;
            }

            .stats-card .card-subtitle {
                font-size: 10px;
            }

            .progress-bar-container {
                height: 4px;
                margin: 5px 0;
            }

            #quickServerSwitch {
                font-size: 10px;
                padding: 2px 4px;
                height: 22px;
            }

            .server-name {
                font-size: 13px !important;
            }
        }

        @media (max-width: 479px) {
            .stats-card {
                min-height: 100px;
                padding: 8px;
            }

            .stats-cards-container {
                padding: 8px 5px !important;
            }

            .stats-card .card-value {
                font-size: 18px;
            }

            .stats-card .card-icon {
                font-size: 20px;
            }

            .five-cols {
                margin-left: -5px;
                margin-right: -5px;
            }

            .col-md-5ths {
                padding-right: 5px;
                padding-left: 5px;
            }
        }

        /* Table container without breaking layout */
        .table-responsive {
            overflow-x: auto;
        }

        /* Table borders for better visibility */
        #deviceTable {
            border: 1px solid #dee2e6;
        }

        #deviceTable th,
        #deviceTable td {
            border: 1px solid #dee2e6;
        }

        /* Sticky header with better contrast */
        #deviceTable thead th {
            position: sticky;
            top: 0;
            z-index: 10;
            background: #e9ecef;
            color: #495057;
            border: 1px solid #dee2e6;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12);
        }

        /* Dark mode table */
        .dark-mode #deviceTable,
        body.dark-mode #deviceTable {
            border-color: #30363d;
        }

        .dark-mode #deviceTable th,
        body.dark-mode #deviceTable th,
        .dark-mode #deviceTable td,
        body.dark-mode #deviceTable td {
            border-color: #30363d;
        }

        .dark-mode #deviceTable thead th,
        body.dark-mode #deviceTable thead th {
            background: #0d1117;
            color: #e6edf3;
            border-color: #30363d;
        }

        /* Ensure header stays on top in scrollable container */
        #deviceTable thead {
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .dark-mode #deviceTable thead th,
        body.dark-mode #deviceTable thead th {
            background: #0d1117;
            box-shadow: 0 2px 2px -1px rgba(0, 0, 0, 0.3);
        }

        /* Clickable Rows with better visual feedback */
        /* Clickable Rows - Force no animation */
        #deviceTable tbody tr {
            cursor: pointer;
            transition: none !important;
        }

        #deviceTable tbody tr * {
            transition: none !important;
        }

        #deviceTable tbody tr:hover {
            background-color: #f0f8ff !important;
            transition: none !important;
        }

        .dark-mode #deviceTable tbody tr:hover,
        body.dark-mode #deviceTable tbody tr:hover {
            background-color: #1c2128 !important;
            transition: none !important;
        }

        .dark-mode #deviceTable tbody tr:hover td:first-child,
        body.dark-mode #deviceTable tbody tr:hover td:first-child {
            border-left: 3px solid #58a6ff;
        }

        /* Exclude action column from click */
        #deviceTable tbody tr td.action-column {
            cursor: default;
        }

        /* Action dropdown styling */
        .action-column .btn-group {
            display: flex;
        }

        .action-column .dropdown-menu {
            min-width: 150px;
        }

        .action-column .dropdown-menu>li>a {
            padding: 8px 15px;
            cursor: pointer;
        }

        .action-column .dropdown-menu>li>a:hover {
            background-color: #f8f9fa;
        }

        .dark-mode .action-column .dropdown-menu,
        body.dark-mode .action-column .dropdown-menu {
            background: #161b22;
            border-color: #30363d;
        }

        .dark-mode .action-column .dropdown-menu>li>a,
        body.dark-mode .action-column .dropdown-menu>li>a {
            color: #e6edf3;
        }

        .dark-mode .action-column .dropdown-menu>li>a:hover,
        body.dark-mode .action-column .dropdown-menu>li>a:hover {
            background: #21262d;
        }

        /* Default - rows are clickable */
        #deviceTable tbody tr {
            cursor: pointer;
        }

        #deviceTable tbody tr td {
            -webkit-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            user-select: none;
        }

        /* Allow text selection ONLY for specific important columns */
        #deviceTable tbody tr td.selectable-text {
            -webkit-user-select: text;
            -moz-user-select: text;
            -ms-user-select: text;
            user-select: text;
            cursor: auto;
        }

        /* Modern SweetAlert2 Custom Styles */
        .modern-swal-popup {
            border-radius: 12px !important;
            padding: 20px !important;
        }

        .modern-swal-confirm {
            padding: 10px 24px !important;
            font-weight: 600 !important;
            border-radius: 6px !important;
            transition: all 0.2s !important;
        }

        .modern-swal-cancel {
            padding: 10px 24px !important;
            font-weight: 600 !important;
            border-radius: 6px !important;
            transition: all 0.2s !important;
        }

        .swal2-popup {
            font-family: inherit !important;
        }

        /* Refresh Modal Styles */
        .refresh-modal-container {
            padding: 20px;
            text-align: center;
        }

        .refresh-header {
            margin-bottom: 25px;
        }

        .refresh-icon-spinner {
            font-size: 48px;
            color: #5dade2;
            margin-bottom: 15px;
        }

        .refresh-header h3 {
            margin: 0;
            font-size: 20px;
            color: #495057;
            font-weight: 600;
        }

        .refresh-stats {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
        }

        .stat-item {
            display: flex;
            flex-direction: column;
        }

        .stat-number {
            font-size: 32px;
            font-weight: bold;
            color: #5dade2;
        }

        .stat-label {
            font-size: 12px;
            color: #6c757d;
            text-transform: uppercase;
            margin-top: 5px;
        }

        .stat-divider {
            font-size: 28px;
            color: #dee2e6;
            margin: 0 10px;
        }

        .progress-container {
            margin: 25px 0;
        }

        .progress-bar-modern {
            height: 30px;
            background: #e9ecef;
            border-radius: 15px;
            overflow: hidden;
            position: relative;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #5dade2, #3498db);
            border-radius: 15px;
            transition: width 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .progress-text {
            color: white;
            font-weight: 600;
            font-size: 14px;
        }

        .device-info {
            margin: 20px 0;
            padding: 12px;
            background: #f8f9fa;
            border-radius: 8px;
        }

        .device-label {
            color: #6c757d;
            font-size: 13px;
            margin-right: 8px;
        }

        .device-name {
            color: #495057;
            font-weight: 600;
            font-size: 14px;
        }

        .refresh-counters {
            display: flex;
            justify-content: center;
            gap: 30px;
            margin-top: 20px;
        }

        .counter-success {
            color: #58d68d;
            font-size: 16px;
            font-weight: 600;
        }

        .counter-fail {
            color: #ec7063;
            font-size: 16px;
            font-weight: 600;
        }

        /* Complete Modal */
        .refresh-complete-container {
            padding: 20px;
            text-align: center;
        }

        .complete-icon {
            font-size: 64px;
            margin-bottom: 20px;
        }

        .refresh-complete-container h3 {
            margin: 0 0 25px 0;
            font-size: 22px;
            color: #495057;
            font-weight: 600;
        }

        .complete-stats {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-bottom: 20px;
        }

        .stat-box {
            padding: 15px 25px;
            border-radius: 8px;
            min-width: 100px;
        }

        .stat-box.success {
            background: #d4edda;
            color: #155724;
        }

        .stat-box.fail {
            background: #f8d7da;
            color: #721c24;
        }

        .stat-box .stat-value {
            display: block;
            font-size: 24px;
            font-weight: bold;
            margin: 8px 0;
        }

        .complete-message {
            color: #6c757d;
            font-size: 14px;
            margin-top: 20px;
        }

        /* RX Power Filter Dropdown Width */
        #rxPowerFilter {
            min-width: 180px;
        }

        /* Warning Alert Animation */
        @keyframes pulse {
            0% {
                box-shadow: 0 0 0 0 rgba(255, 193, 7, 0.7);
            }

            50% {
                box-shadow: 0 0 0 10px rgba(255, 193, 7, 0);
            }

            100% {
                box-shadow: 0 0 0 0 rgba(255, 193, 7, 0);
            }
        }

        .alert-warning {
            border: 2px solid #ffc107;
            background: linear-gradient(135deg, #fff3cd, #ffeaa7);
        }

        @media (max-width: 991px) {
            #rxPowerFilter {
                min-width: 100%;
            }
        }
    </style>
{include file="sections/footer.tpl"}