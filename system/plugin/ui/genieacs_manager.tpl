{include file="sections/header.tpl"}

<!-- Loading Overlay -->
<div id="loading-overlay" style="display: none;">
    <div class="loading-content">
        <div class="spinner"></div>
        <div class="loading-text">Processing...</div>
    </div>
</div>

<!-- Notification Container -->
<div id="notification-container"></div>

<!-- Statistics Cards Section -->
<div class="row" id="stats-cards">
    <!-- Total Servers Card -->
    <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
        <div class="info-box">
            <span class="info-box-icon bg-aqua">
                <i class="fa fa-hdd-o"></i>
            </span>
            <div class="info-box-content">
                <span class="info-box-text">Total Servers</span>
                <span class="info-box-number">{$server_count}</span>
                <div class="progress">
                    <div class="progress-bar bg-aqua" style="width: 100%"></div>
                </div>
                <span class="progress-description">
                    All configured ACS servers
                </span>
            </div>
        </div>
    </div>

    <!-- Online Servers Card -->
    <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
        <div class="info-box">
            <span class="info-box-icon bg-green">
                <i class="ion ion-checkmark-circled"></i>
            </span>
            <div class="info-box-content">
                <span class="info-box-text">Online Servers</span>
                <span class="info-box-number">{$online_servers}</span>
                <div class="progress">
                    <div class="progress-bar bg-green" style="width: {$online_percentage}%"></div>
                </div>
                <span class="progress-description">
                    {$online_percentage}% servers connected
                </span>
            </div>
        </div>
    </div>

    <!-- Offline Servers Card -->
    <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
        <div class="info-box">
            <span class="info-box-icon bg-red">
                <i class="ion ion-close-circled"></i>
            </span>
            <div class="info-box-content">
                <span class="info-box-text">Offline Servers</span>
                <span class="info-box-number">{$offline_servers}</span>
                <div class="progress">
                    <div class="progress-bar bg-red" style="width: {100-$online_percentage}%"></div>
                </div>
                <span class="progress-description">
                    {100-$online_percentage|round:1}% servers disconnected
                </span>
            </div>
        </div>
    </div>

    <!-- Total Devices Card -->
    <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
        <div class="info-box">
            <span class="info-box-icon bg-yellow">
                <i class="ion ion-android-phone-portrait"></i>
            </span>
            <div class="info-box-content">
                <span class="info-box-text">Total Devices</span>
                <span class="info-box-number" id="total-devices-count">{$total_devices}</span>
                <div class="progress">
                    <div class="progress-bar bg-yellow" style="width: 100%"></div>
                </div>
                <span class="progress-description">
                    From all servers combined
                </span>
            </div>
        </div>
    </div>
</div>

<!-- Quick Actions, Server Health & Activity Row -->
<div class="row" style="margin-top: 15px;">
    <!-- Quick Actions Panel -->
    <div class="col-md-4">
        <div class="box box-primary uniform-box">
            <div class="box-header with-border">
                <h3 class="box-title"><i class="fa fa-bolt"></i> Quick Actions</h3>
            </div>
            <div class="box-body" style="min-height: 200px; padding: 15px;">
                <div class="quick-action-compact">
                    <!-- Add Server Button -->
                    <button class="btn quick-action-btn action-add" onclick="showAddServerModal()">
                        <div class="action-icon">
                            <i class="fa fa-plus-circle"></i>
                        </div>
                        <div class="action-content">
                            <span class="action-title">Add Server</span>
                            <span class="action-desc">Configure new ACS</span>
                        </div>
                        <div class="action-arrow">
                            <i class="fa fa-chevron-right"></i>
                        </div>
                    </button>

                    <!-- Test All Button -->
                    <button class="btn quick-action-btn action-test" onclick="testAllConnections()">
                        <div class="action-icon">
                            <i class="fa fa-plug"></i>
                        </div>
                        <div class="action-content">
                            <span class="action-title">Test All</span>
                            <span class="action-desc">Check connections</span>
                        </div>
                        <div class="action-arrow">
                            <i class="fa fa-chevron-right"></i>
                        </div>
                    </button>

                    <!-- Parameters Button -->
                    <button class="btn quick-action-btn action-params"
                        onclick="window.location.href='{$_url}plugin/genieacs_parameters'">
                        <div class="action-icon">
                            <i class="fa fa-cogs"></i>
                        </div>
                        <div class="action-content">
                            <span class="action-title">Parameters</span>
                            <span class="action-desc">Configure params</span>
                        </div>
                        <div class="action-arrow">
                            <i class="fa fa-chevron-right"></i>
                        </div>
                    </button>

                    <!-- Device Mapping Button -->
                    <button class="btn quick-action-btn action-mapping" onclick="showDeviceMappingModal()">
                        <div class="action-icon">
                            <i class="fa fa-database"></i>
                        </div>
                        <div class="action-content">
                            <span class="action-title">Device Cache</span>
                            <span class="action-desc">Manage mappings</span>
                        </div>
                        <div class="action-arrow">
                            <i class="fa fa-chevron-right"></i>
                        </div>
                    </button>

                    <!-- Uninstall Button -->
                    <button class="btn quick-action-btn action-uninstall" onclick="showUninstallModal()">
                        <div class="action-icon">
                            <i class="fa fa-trash"></i>
                        </div>
                        <div class="action-content">
                            <span class="action-title">Uninstall</span>
                            <span class="action-desc">Remove plugin</span>
                        </div>
                        <div class="action-arrow">
                            <i class="fa fa-chevron-right"></i>
                        </div>
                    </button>

                    <!-- Update Button -->
                    <button class="btn quick-action-btn action-update" id="btn-check-update" onclick="checkForUpdate()">
                        <div class="action-icon">
                            <i class="fa fa-refresh"></i>
                        </div>
                        <div class="action-content">
                            <span class="action-title">Check Update</span>
                            <span class="action-desc" id="update-status">Click to check</span>
                        </div>
                        <div class="action-arrow">
                            <i class="fa fa-chevron-right"></i>
                        </div>
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Local Server Health with Gauges Only -->
    <div class="col-md-4">
        <div class="box box-info uniform-box">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i class="fa fa-server"></i> Host Server
                </h3>
                <div class="box-tools pull-right">
                    <button class="btn btn-box-tool" onclick="refreshLocalStats()">
                        <i class="fa fa-refresh" id="local-refresh-icon"></i>
                    </button>
                </div>
            </div>
            <div class="box-body uniform-box-body">
                <!-- Gauge Charts Row -->
                <div class="row text-center gauge-row-compact">
                    <div class="col-xs-4">
                        <canvas id="cpuGauge" width="70" height="70"></canvas>
                        <div class="gauge-label-compact">
                            <span class="gauge-title">CPU</span>
                            <span class="gauge-value-compact" id="cpu-text">{$local_stats.cpu_usage}%</span>
                        </div>
                    </div>
                    <div class="col-xs-4">
                        <canvas id="memGauge" width="70" height="70"></canvas>
                        <div class="gauge-label-compact">
                            <span class="gauge-title">RAM</span>
                            <span class="gauge-value-compact" id="mem-text">{$local_stats.mem_usage}%</span>
                            <small class="gauge-detail-compact"
                                id="mem-detail">{$local_stats.mem_used_gb}/{$local_stats.mem_total_gb}GB</small>
                        </div>
                    </div>
                    <div class="col-xs-4">
                        <canvas id="diskGauge" width="70" height="70"></canvas>
                        <div class="gauge-label-compact">
                            <span class="gauge-title">Disk</span>
                            <span class="gauge-value-compact" id="disk-text">{$local_stats.disk_usage}%</span>
                            <small class="gauge-detail-compact"
                                id="disk-detail">{$local_stats.disk_used_gb}/{$local_stats.disk_total_gb}GB</small>
                        </div>
                    </div>
                </div>

                <!-- Info Footer Compact -->
                <div class="server-info-footer-compact">
                    <div class="info-item-compact">
                        <i class="fa fa-tachometer text-info"></i>
                        <span id="load-info">Load: {$local_stats.load_1min}</span>
                    </div>
                    <div class="info-item-compact">
                        <i class="fa fa-clock-o text-success"></i>
                        <span id="uptime-info">{$local_stats.uptime_string}</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Activity Feed -->
    <div class="col-md-4">
        <div class="box box-warning uniform-box">
            <div class="box-header with-border">
                <h3 class="box-title"><i class="fa fa-clock-o"></i> Recent Activity</h3>
                <div class="box-tools pull-right">
                    <button class="btn btn-box-tool" onclick="refreshActivity()">
                        <i class="fa fa-refresh"></i>
                    </button>
                </div>
            </div>
            <div class="box-body" id="activity-feed" style="min-height: 200px; max-height: 200px; overflow-y: auto;">
                <div class="activity-list">
                    <!-- Activity items will be loaded here -->
                    <div class="activity-item">
                        <i class="fa fa-check text-success"></i>
                        <span class="activity-text">Loading activities...</span>
                        <span class="activity-time">now</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Search and Filter Bar -->
<div class="row" style="margin-top: 15px;">
    <div class="col-md-12">
        <div class="box box-default">
            <div class="box-header with-border">
                <h3 class="box-title"><i class="fa fa-filter"></i> Search & Filters</h3>
                <!-- Removed collapse button -->
            </div>
            <div class="box-body">
                <div class="row">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label>Search Server:</label>
                            <div class="input-group">
                                <span class="input-group-addon"><i class="fa fa-search"></i></span>
                                <input type="text" class="form-control" id="serverSearch"
                                    placeholder="Search by name, host, or IP...">
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="form-group">
                            <label>Status:</label>
                            <select class="form-control" id="statusFilter">
                                <option value="">All Status</option>
                                <option value="online">Online Only</option>
                                <option value="offline">Offline Only</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="form-group">
                            <label>Protocol:</label>
                            <select class="form-control" id="protocolFilter">
                                <option value="">All Protocols</option>
                                <option value="https">HTTPS</option>
                                <option value="http">HTTP</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="form-group">
                            <label>Priority:</label>
                            <select class="form-control" id="priorityFilter">
                                <option value="">All Servers</option>
                                <option value="priority">Priority Only</option>
                                <option value="normal">Normal Only</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="form-group">
                            <label>&nbsp;</label>
                            <button class="btn btn-danger btn-block" id="clearFiltersBtn" onclick="clearFilters()">
                                <i class="fa fa-times"></i> Clear Filters
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Performance Monitoring -->
<div class="row" style="margin-top: 15px;">
    <div class="col-md-12">
        <div class="alert alert-info" id="performance-alert" style="display: none;">
            <button type="button" class="close" onclick="$(this).parent().hide()">×</button>
            <i class="fa fa-info-circle"></i> <span id="performance-message"></span>
        </div>
    </div>
</div>

<!-- Main Panel with Table -->
<div class="row" style="margin-top: 15px;">
    <div class="col-sm-12">
        <div class="panel panel-hovered mb20 panel-primary">
            <div class="panel-heading">
                <i class="ion ion-cloud"></i> GenieACS Server Manager
                <div class="pull-right">
                    <span class="badge badge-info">{$server_count} servers</span>
                </div>
            </div>
            <div class="panel-body">
                <!-- Server List Table - Desktop -->
                <div class="table-responsive hidden-xs">
                    <table class="table table-bordered table-striped table-hover">
                        <thead>
                            <tr>
                                <th width="3%">
                                    <i class="fa fa-star-o" title="Priority"></i>
                                </th>
                                <th width="5%">ID</th>
                                <th width="18%">Server Name</th>
                                <th width="20%">Host</th>
                                <th width="8%">Port</th>
                                <th width="8%">Protocol</th>
                                <th width="10%">Status</th>
                                <th width="8%">Devices</th>
                                <th width="8%">Response</th>
                                <th width="12%">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach $servers as $server}
                                <tr class="server-row {if $server->is_priority}priority-server{/if}"
                                    data-server-id="{$server->id}">
                                    <td class="text-center">
                                        <i class="fa {if $server->is_priority}fa-star text-yellow{else}fa-star-o{/if} priority-toggle"
                                            data-server-id="{$server->id}" onclick="togglePriority({$server->id})"
                                            style="cursor: pointer;"></i>
                                    </td>
                                    <td>{$server->id}</td>
                                    <td>
                                        <strong>{$server->name}</strong>
                                        {if $server->is_priority}
                                            <span class="label label-warning pull-right">
                                                <i class="fa fa-star"></i> Priority
                                            </span>
                                        {/if}
                                    </td>
                                    <td>
                                        <i class="fa fa-globe text-muted"></i> {$server->host}
                                    </td>
                                    <td>
                                        {if $server->use_ssl}
                                            <span class="text-muted">443</span>
                                        {else}
                                            {$server->port}
                                        {/if}
                                    </td>
                                    <td>
                                        {if $server->use_ssl}
                                            <span class="label label-success">
                                                <i class="fa fa-lock"></i> HTTPS
                                            </span>
                                        {else}
                                            <span class="label label-info">
                                                <i class="fa fa-unlock"></i> HTTP
                                            </span>
                                        {/if}
                                    </td>
                                    <td id="status-{$server->id}" class="text-center">
                                        {if $server->is_connected}
                                            <div class="status-indicator online">
                                                <span class="pulse-dot pulse-green"></span>
                                                <span class="label label-success">Online</span>
                                            </div>
                                        {else}
                                            <div class="status-indicator offline">
                                                <span class="pulse-dot pulse-red"></span>
                                                <span class="label label-danger">Offline</span>
                                            </div>
                                        {/if}
                                    </td>
                                    <td class="text-center">
                                        <span class="badge bg-blue device-count-badge" id="device-count-{$server->id}"
                                            style="cursor: pointer;" onclick="refreshDeviceCount({$server->id})"
                                            title="Click to refresh">
                                            <i class="fa fa-spinner fa-spin"></i>
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <span class="response-time" id="response-time-{$server->id}">
                                            {if $server->last_response_time > 0}
                                                {$server->last_response_time|round:0}ms
                                            {else}
                                                -
                                            {/if}
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <div class="btn-group">
                                            <button class="btn btn-primary btn-xs" onclick="testConnection({$server->id})"
                                                title="Test Connection">
                                                <i class="fa fa-plug"></i>
                                            </button>
                                            <button class="btn btn-warning btn-xs" onclick="editServer({$server->id})"
                                                title="Edit">
                                                <i class="fa fa-edit"></i>
                                            </button>
                                            <button class="btn btn-danger btn-xs" onclick="deleteServer({$server->id})"
                                                title="Delete">
                                                <i class="fa fa-trash"></i>
                                            </button>
                                            <button class="btn btn-info btn-xs" onclick="viewServerDevices({$server->id})"
                                                title="View Devices">
                                                <i class="fa fa-list"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            {/foreach}
                        </tbody>
                    </table>
                </div> <!-- End of table-responsive -->

                <!-- Server List Cards - Mobile -->
                <div class="mobile-cards-container visible-xs">
                    {foreach $servers as $server}
                        <div class="mobile-server-card {if $server->is_priority}priority-card-mobile{/if}" data-server-id="{$server->id}">
                            <div class="mobile-card-header">
                                <div class="mobile-card-title">
                                    <i class="fa {if $server->is_priority}fa-star text-yellow{else}fa-star-o text-muted{/if} priority-toggle"
                                        data-server-id="{$server->id}" onclick="togglePriority({$server->id})"
                                        style="cursor: pointer;"></i>
                                    <strong>{$server->name}</strong>
                                </div>
                                <div class="mobile-card-status" id="status-mobile-{$server->id}">
                                    {if $server->is_connected}
                                        <span class="label label-success"><i class="fa fa-check"></i> Online</span>
                                    {else}
                                        <span class="label label-danger"><i class="fa fa-times"></i> Offline</span>
                                    {/if}
                                </div>
                            </div>
                            <div class="mobile-card-body">
                                <div class="mobile-card-row">
                                    <span class="mobile-card-label"><i class="fa fa-globe"></i> Host</span>
                                    <span class="mobile-card-value">{$server->host}</span>
                                </div>
                                <div class="mobile-card-row">
                                    <span class="mobile-card-label"><i class="fa fa-plug"></i> Port</span>
                                    <span class="mobile-card-value">
                                        {if $server->use_ssl}443{else}{$server->port}{/if}
                                    </span>
                                </div>
                                <div class="mobile-card-row">
                                    <span class="mobile-card-label"><i class="fa fa-lock"></i> Protocol</span>
                                    <span class="mobile-card-value">
                                        {if $server->use_ssl}
                                            <span class="label label-success">HTTPS</span>
                                        {else}
                                            <span class="label label-info">HTTP</span>
                                        {/if}
                                    </span>
                                </div>
                                <div class="mobile-card-row">
                                    <span class="mobile-card-label"><i class="fa fa-hdd-o"></i> Devices</span>
                                    <span class="mobile-card-value">
                                        <span class="badge bg-blue device-count-badge" id="device-count-mobile-{$server->id}"
                                            onclick="refreshDeviceCount({$server->id})">
                                            <i class="fa fa-spinner fa-spin"></i>
                                        </span>
                                    </span>
                                </div>
                                <div class="mobile-card-row">
                                    <span class="mobile-card-label"><i class="fa fa-tachometer"></i> Response</span>
                                    <span class="mobile-card-value response-time" id="response-time-mobile-{$server->id}">
                                        {if $server->last_response_time > 0}
                                            {$server->last_response_time|round:0}ms
                                        {else}
                                            -
                                        {/if}
                                    </span>
                                </div>
                            </div>
                            <div class="mobile-card-actions">
                                <button class="btn btn-primary" onclick="testConnection({$server->id})" title="Test">
                                    <i class="fa fa-plug"></i>
                                </button>
                                <button class="btn btn-warning" onclick="editServer({$server->id})" title="Edit">
                                    <i class="fa fa-edit"></i>
                                </button>
                                <button class="btn btn-danger" onclick="deleteServer({$server->id})" title="Delete">
                                    <i class="fa fa-trash"></i>
                                </button>
                                <button class="btn btn-info" onclick="viewServerDevices({$server->id})" title="Devices">
                                    <i class="fa fa-list"></i>
                                </button>
                            </div>
                        </div>
                    {/foreach}
                </div> <!-- End of mobile-cards-container -->

                <!-- Integrated Pagination Footer -->
                <div class="table-footer-controls">
                    <div class="footer-left">
                        <div class="dataTables_info">
                            Showing {($current_page-1)*$per_page+1} to {if $current_page*$per_page > $server_count}{$server_count}{else}{$current_page*$per_page}{/if} of
                            {$server_count} servers
                        </div>
                        <div class="dataTables_length">
                            <label>
                                Show
                                <select id="perPageSelector" class="form-control input-sm">
                                    <option value="10" {if $per_page == 10}selected{/if}>10</option>
                                    <option value="20" {if $per_page == 20}selected{/if}>20</option>
                                    <option value="50" {if $per_page == 50}selected{/if}>50</option>
                                    <option value="100" {if $per_page == 100}selected{/if}>100</option>
                                </select>
                                entries
                            </label>
                        </div>
                    </div>
                    <div class="footer-right">
                        <div class="dataTables_paginate paging_simple_numbers">
                            <ul class="pagination">
                                {if $current_page > 1}
                                    <li class="paginate_button previous">
                                        <a
                                            href="{$_url}plugin/genieacs_manager?page={$current_page-1}&per_page={$per_page}">Previous</a>
                                    </li>
                                {/if}

                                {for $i=1 to $total_pages}
                                    {if $i <= 3 || $i > $total_pages - 3 || ($i >= $current_page - 1 && $i <= $current_page + 1)}
                                        <li class="paginate_button {if $i == $current_page}active{/if}">
                                            <a href="{$_url}plugin/genieacs_manager?page={$i}&per_page={$per_page}">{$i}</a>
                                        </li>
                                    {elseif $i == 4 || $i == $total_pages - 3}
                                        <li class="paginate_button disabled"><a>...</a></li>
                                    {/if}
                                {/for}

                                {if $current_page < $total_pages}
                                    <li class="paginate_button next">
                                        <a
                                            href="{$_url}plugin/genieacs_manager?page={$current_page+1}&per_page={$per_page}">Next</a>
                                    </li>
                                {/if}
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</div>

<!-- Add/Edit Server Modal -->
<div class="modal fade" id="serverModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-md" role="document">
        <div class="modal-content">
            <div class="modal-header bg-primary">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="serverModalTitle">
                    <i class="fa fa-server"></i> Add ACS Server
                </h4>
            </div>
            <div class="modal-body">
                <form id="serverForm" class="form-horizontal">
                    <input type="hidden" id="server_id" name="id" value="0">

                    <!-- Server Name -->
                    <div class="form-group">
                        <label class="col-sm-3 control-label">
                            Name <span class="text-danger">*</span>
                        </label>
                        <div class="col-sm-9">
                            <div class="input-group">
                                <span class="input-group-addon">
                                    <i class="fa fa-tag"></i>
                                </span>
                                <input type="text" class="form-control modal-input" id="server_name" name="name"
                                    required placeholder="Main ACS Server">
                            </div>
                            <small class="help-block">Friendly name to identify this server</small>
                        </div>
                    </div>

                    <!-- Host/IP -->
                    <div class="form-group">
                        <label class="col-sm-3 control-label">
                            Host <span class="text-danger">*</span>
                        </label>
                        <div class="col-sm-9">
                            <div class="input-group">
                                <span class="input-group-addon">
                                    <i class="fa fa-globe"></i>
                                </span>
                                <input type="text" class="form-control modal-input" id="server_host" name="host"
                                    required placeholder="192.168.1.1 or acs.example.com">
                            </div>
                            <small class="help-block">IP address or domain name</small>
                        </div>
                    </div>

                    <!-- Port -->
                    <div class="form-group">
                        <label class="col-sm-3 control-label">
                            Port <span class="text-danger">*</span>
                        </label>
                        <div class="col-sm-9">
                            <div class="input-group">
                                <span class="input-group-addon">
                                    <i class="fa fa-plug"></i>
                                </span>
                                <input type="number" class="form-control modal-input" id="server_port" name="port"
                                    value="7557" required min="1" max="65535">
                            </div>
                            <small class="help-block">Default: 7557 (HTTP) or 443 (HTTPS)</small>
                        </div>
                    </div>

                    <!-- Divider -->
                    <hr style="margin: 20px 0; border-top: 1px solid #f4f4f4;">

                    <!-- Authentication Section -->
                    <div class="form-group">
                        <div class="col-sm-12">
                            <h5 style="margin-bottom: 15px; color: #666;">
                                <i class="fa fa-shield"></i> Authentication
                            </h5>
                        </div>
                    </div>

                    <!-- Username -->
                    <div class="form-group">
                        <label class="col-sm-3 control-label">
                            Username <span class="text-danger">*</span>
                        </label>
                        <div class="col-sm-9">
                            <div class="input-group">
                                <span class="input-group-addon">
                                    <i class="fa fa-user"></i>
                                </span>
                                <input type="text" class="form-control modal-input" id="server_username" name="username"
                                    required placeholder="admin">
                            </div>
                            <small class="help-block">GenieACS admin username</small>
                        </div>
                    </div>

                    <!-- Password -->
                    <div class="form-group">
                        <label class="col-sm-3 control-label">
                            Password <span class="text-danger">*</span>
                        </label>
                        <div class="col-sm-9">
                            <div class="input-group">
                                <span class="input-group-addon">
                                    <i class="fa fa-lock"></i>
                                </span>
                                <input type="password" class="form-control modal-input" id="server_password"
                                    name="password" required placeholder="••••••••">
                                <span class="input-group-btn">
                                    <button class="btn btn-default" type="button" onclick="togglePassword()"
                                        title="Show/Hide Password">
                                        <i class="fa fa-eye" id="password-toggle-icon"></i>
                                    </button>
                                </span>
                            </div>
                            <small class="help-block">GenieACS admin password</small>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default btn-flat" data-dismiss="modal">
                    <i class="fa fa-times"></i> Cancel
                </button>
                <button type="button" class="btn btn-success btn-flat" onclick="testAndSaveServer()">
                    <i class="fa fa-check"></i> Test Connection
                </button>
                <button type="button" class="btn btn-primary btn-flat" onclick="saveServer()">
                    <i class="fa fa-save"></i> Save Server
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Device Mapping Modal -->
<div class="modal fade" id="deviceMappingModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg modal-responsive" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title">
                    <i class="fa fa-database text-primary"></i> Device Cache Management
                </h4>
            </div>
            <div class="modal-body">
                <!-- Search and Filter Bar -->
                <div class="row mapping-controls">
                    <div class="col-md-6 col-sm-6">
                        <div class="form-group">
                            <div class="input-group">
                                <span class="input-group-addon"><i class="fa fa-search"></i></span>
                                <input type="text" class="form-control" id="mappingSearch"
                                    placeholder="Search username...">
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 col-sm-4">
                        <div class="form-group">
                            <select class="form-control" id="serverFilter">
                                <option value="">All Servers</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-2 col-sm-2">
                        <button class="btn btn-default btn-block" onclick="clearMappingFilters()">
                            <i class="fa fa-times"></i> Clear
                        </button>
                    </div>
                </div>

                <!-- Table -->
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead>
                            <tr>
                                <th class="hidden-xs" width="5%">ID</th>
                                <th width="35%">User</th>
                                <th width="45%">Device</th>
                                <th class="hidden-xs" width="15%">Server</th>
                                <th class="hidden-xs" width="15%">Updated</th>
                                <th width="20%">Action</th>
                            </tr>
                        </thead>
                        <tbody id="mappingTableBody">
                            <tr>
                                <td colspan="6" class="text-center hidden-xs">
                                    <i class="fa fa-spinner fa-spin"></i> Loading mappings...
                                </td>
                                <td colspan="3" class="text-center visible-xs">
                                    <i class="fa fa-spinner fa-spin"></i> Loading...
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <div class="mapping-pagination">
                    <div class="row">
                        <div class="col-sm-6">
                            <div class="dataTables_info" id="mappingInfo">
                                Showing 0 to 0 of 0 entries
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="dataTables_paginate paging_simple_numbers" id="mappingPagination">
                                <ul class="pagination">
                                    <!-- Pagination will be generated by JS -->
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default btn-flat" data-dismiss="modal">
                    <i class="fa fa-times"></i> Close
                </button>
                <button type="button" class="btn btn-danger btn-flat" onclick="clearAllMappings()">
                    <i class="fa fa-trash"></i> Clear All Cache
                </button>
                <button type="button" class="btn btn-primary btn-flat" onclick="loadDeviceMappings()">
                    <i class="fa fa-refresh"></i> Refresh
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Modern Uninstall Modal -->
<div class="modal-overlay" id="uninstallModalOverlay" style="display: none;">
    <div class="modal-container uninstall-modal">
        <div class="modal-header-danger">
            <h4 id="uninstallModalTitle"><i class="fa fa-exclamation-triangle"></i> Uninstall GenieACS Manager</h4>
            <button class="modal-close-btn" onclick="closeUninstallModal()">&times;</button>
        </div>
        <div class="modal-body-new">
            <!-- Warning Section -->
            <div class="warning-box-new">
                <div class="warning-icon">
                    <i class="fa fa-exclamation-circle"></i>
                </div>
                <div class="warning-content">
                    <strong>Peringatan!</strong>
                    <p>Tindakan ini akan menghapus GenieACS Manager secara permanen beserta semua datanya dan tidak dapat dibatalkan.</p>
                </div>
            </div>
            
            <!-- Delete List Section -->
            <div class="form-section-new">
                <div class="form-section-header-new">
                    <i class="fa fa-trash"></i>
                    <span>Yang Akan Dihapus</span>
                </div>
                
                <div class="delete-list-grid">
                    <div class="delete-item">
                        <i class="fa fa-server text-danger"></i>
                        <span>Semua konfigurasi ACS server</span>
                    </div>
                    <div class="delete-item">
                        <i class="fa fa-mobile text-danger"></i>
                        <span>Semua data & mapping device</span>
                    </div>
                    <div class="delete-item">
                        <i class="fa fa-sliders text-danger"></i>
                        <span>Semua konfigurasi parameter</span>
                    </div>
                    <div class="delete-item">
                        <i class="fa fa-key text-danger"></i>
                        <span>History password & WebAdmin</span>
                    </div>
                    <div class="delete-item">
                        <i class="fa fa-file-code-o text-danger"></i>
                        <span>File environment (.env)</span>
                    </div>
                    <div class="delete-item">
                        <i class="fa fa-clock-o text-danger"></i>
                        <span>File cron synchronization</span>
                    </div>
                    <div class="delete-item">
                        <i class="fa fa-code text-danger"></i>
                        <span>Semua file plugin & template</span>
                    </div>
                    <div class="delete-item">
                        <i class="fa fa-paint-brush text-danger"></i>
                        <span>Custom UI modifications</span>
                    </div>
                </div>
            </div>
            
            <!-- Confirmation Section -->
            <div class="form-section-new">
                <div class="form-section-header-new">
                    <i class="fa fa-check-circle"></i>
                    <span>Konfirmasi</span>
                </div>
                
                <div class="form-group-new">
                    <label>Ketik <code class="confirm-code">UNINSTALL</code> untuk konfirmasi</label>
                    <input type="text" class="form-control-new" id="uninstall_confirm" 
                        placeholder="Ketik UNINSTALL disini" autocomplete="off">
                </div>
            </div>
            
            <!-- Progress Log (Hidden initially) -->
            <div class="form-section-new" id="uninstall-progress-section" style="display: none;">
                <div class="form-section-header-new">
                    <i class="fa fa-terminal"></i>
                    <span>Progress Uninstall</span>
                </div>
                <div class="progress-log-container" id="uninstall-log-content">
                </div>
            </div>
        </div>
        <div class="modal-footer-new">
            <button type="button" class="btn-cancel-new" onclick="closeUninstallModal()" id="btn-cancel-uninstall">
                <i class="fa fa-times"></i> Batal
            </button>
            <button type="button" class="btn-danger-new" onclick="runUninstall()" id="btn-run-uninstall">
                <i class="fa fa-trash"></i> Uninstall Plugin
            </button>
        </div>
    </div>
</div>

<!-- Update Modal -->
<div class="modal-overlay" id="updateModalOverlay" style="display: none;">
    <div class="modal-container update-modal">
        <div class="modal-header-update">
            <h4><i class="fa fa-download"></i> <span id="update-modal-title">Update Available</span></h4>
            <button class="modal-close-btn" onclick="closeUpdateModal()">&times;</button>
        </div>
        <div class="modal-body-new">
            <!-- Version Info -->
            <div class="update-version-box">
                <div class="version-current">
                    <span class="version-label">Current Version</span>
                    <span class="version-number" id="current-version">v1.0.0</span>
                </div>
                <div class="version-arrow">
                    <i class="fa fa-arrow-right"></i>
                </div>
                <div class="version-new">
                    <span class="version-label">New Version</span>
                    <span class="version-number" id="new-version">v1.0.1</span>
                </div>
            </div>
            
            <!-- Changelog Section -->
            <div class="form-section-new">
                <div class="form-section-header-new">
                    <i class="fa fa-list-ul"></i>
                    <span>What's New</span>
                </div>
                <div class="changelog-list" id="changelog-list">
                    <!-- Changelog items will be inserted here -->
                </div>
            </div>
            
            <!-- Progress Log (Hidden initially) -->
            <div class="form-section-new" id="update-progress-section" style="display: none;">
                <div class="form-section-header-new">
                    <i class="fa fa-terminal"></i>
                    <span>Update Progress</span>
                </div>
                <div class="progress-log-container" id="update-log-content">
                </div>
            </div>
        </div>
        <div class="modal-footer-new">
            <button type="button" class="btn-cancel-new" onclick="closeUpdateModal()" id="btn-cancel-update">
                <i class="fa fa-times"></i> Later
            </button>
            <button type="button" class="btn-update-new" onclick="runUpdate()" id="btn-run-update">
                <i class="fa fa-download"></i> Update Now
            </button>
        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script>
    var editMode = false;

    function showAddServerModal() {
        editMode = false;
        $('#serverModalTitle').text('Add ACS Server');
        $('#serverForm')[0].reset();
        $('#server_id').val(0);
        $('#serverModal').modal('show');
    }

    function editServer(id) {
        editMode = true;
        $('#serverModalTitle').text('Edit ACS Server');

        // Load server data
        $.ajax({
            url: '{$_url}plugin/genieacs_manager/get-server',
            type: 'GET',
            data: { id: id },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    $('#server_id').val(response.server.id);
                    $('#server_name').val(response.server.name);
                    $('#server_host').val(response.server.host);
                    $('#server_port').val(response.server.port);
                    $('#server_username').val(response.server.username);
                    $('#server_password').val(response.server.password);
                    $('#serverModal').modal('show');
                } else {
                    Swal.fire('Error!', response.message, 'error');
                }
            },
            error: function() {
                Swal.fire('Error!', 'Failed to load server data', 'error');
            }
        });
    }

    function saveServer() {
        var formData = $('#serverForm').serialize();
        var url = editMode ? '{$_url}plugin/genieacs_manager/edit-server' : '{$_url}plugin/genieacs_manager/add-server';

        $.ajax({
            url: url,
            type: 'POST',
            data: formData,
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    $('#serverModal').modal('hide');
                    Swal.fire('Success!', response.message, 'success').then(() => {
                        location.reload();
                    });
                } else {
                    Swal.fire('Error!', response.message, 'error');
                }
            },
            error: function() {
                Swal.fire('Error!', 'Failed to save server', 'error');
            }
        });
    }

    function deleteServer(id) {
        Swal.fire({
            title: 'Delete Server?',
            text: 'This will remove the server and all related data!',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            confirmButtonText: 'Yes, delete it!'
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: '{$_url}plugin/genieacs_manager/delete-server',
                    type: 'GET',
                    data: { id: id },
                    dataType: 'json',
                    success: function(response) {
                        if (response.success) {
                            Swal.fire('Deleted!', response.message, 'success').then(() => {
                                location.reload();
                            });
                        } else {
                            Swal.fire('Error!', response.message, 'error');
                        }
                    },
                    error: function() {
                        Swal.fire('Error!', 'Failed to delete server', 'error');
                    }
                });
            }
        });
    }

    function testConnection(id) {
        Swal.fire({
            title: 'Testing Connection...',
            allowOutsideClick: false,
            didOpen: () => {
                Swal.showLoading();
            }
        });

        $.ajax({
            url: '{$_url}plugin/genieacs_manager/test-connection',
            type: 'GET',
            data: { id: id },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    $('#status-' + id).html('<span class="label label-success">Connected</span>');
                    Swal.fire('Success!', response.message, 'success');
                } else {
                    $('#status-' + id).html('<span class="label label-danger">Disconnected</span>');
                    Swal.fire('Failed!', response.message, 'error');
                }
            },
            error: function() {
                Swal.fire('Error!', 'Failed to test connection', 'error');
            }
        });
    }

    function viewServerDevices(serverId) {
        // Set server via AJAX then redirect
        $.ajax({
            url: '{$_url}plugin/genieacs_devices/set-server',
            type: 'POST',
            data: { server_id: serverId },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    window.location.href = '{$_url}plugin/genieacs_devices';
                } else {
                    Swal.fire('Error!', 'Failed to set server', 'error');
                }
            },
            error: function() {
                Swal.fire('Error!', 'Failed to communicate with server', 'error');
            }
        });
    }

    // Lazy load device counts
    function loadDeviceCounts() {
        var serverIds = [];
        $('.server-row:visible').each(function() {
            var serverId = $(this).data('server-id');
            if (serverId) {
                serverIds.push(serverId);
            }
        });

        // Also check mobile cards
        $('.mobile-server-card:visible').each(function() {
            var serverId = $(this).data('server-id');
            if (serverId && serverIds.indexOf(serverId) === -1) {
                serverIds.push(serverId);
            }
        });

        if (serverIds.length === 0) return;

        // Use optimized batch endpoint
        $.ajax({
            url: '{$_url}plugin/genieacs_manager/batch-device-counts-optimized',
            type: 'POST',
            data: { server_ids: serverIds },
            dataType: 'json',
            timeout: 15000, // 15 second timeout for batch
            success: function(response) {
                if (response.success) {
                    for (var serverId in response.results) {
                        var result = response.results[serverId];
                        $('#device-count-' + serverId).text(result.count || '-');
                        $('#device-count-mobile-' + serverId).text(result.count || '-');
                    }
                    updateTotalDevicesCount();
                }
            },
            error: function() {
                // On error, load individually as fallback
                serverIds.forEach(function(serverId) {
                    loadSingleDeviceCount(serverId);
                });
            }
        });
    }

    // Load single device count
    function loadSingleDeviceCount(serverId) {
        $.ajax({
            url: '{$_url}plugin/genieacs_manager/get-device-count',
            type: 'GET',
            data: { server_id: serverId },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    // Update table view
                    $('#device-count-' + serverId).text(response.count);
                    // Update mobile view
                    $('#device-count-mobile-' + serverId).text(response.count);

                    // Update total devices count
                    updateTotalDevicesCount();
                } else {
                    $('#device-count-' + serverId).text('-');
                    $('#device-count-mobile-' + serverId).text('-');
                }
            },
            error: function() {
                $('#device-count-' + serverId).text('-');
                $('#device-count-mobile-' + serverId).text('-');
            }
        });
    }

    // Manual refresh device count for single server
    function refreshDeviceCount(serverId) {
        // Show loading
        $('#device-count-' + serverId).html('<i class="fa fa-spinner fa-spin"></i>');
        $('#device-count-grid-' + serverId).html('<i class="fa fa-spinner fa-spin"></i>');

        $.ajax({
            url: '{$_url}plugin/genieacs_manager/get-device-count',
            type: 'GET',
            data: {
                server_id: serverId,
                force: true // Force refresh, bypass cache
            },
            dataType: 'json',
            timeout: 10000,
            success: function(response) {
                if (response.success) {
                    $('#device-count-' + serverId).text(response.count);
                    $('#device-count-grid-' + serverId).text(response.count);

                    // Show toast notification
                    showNotification('Device count refreshed: ' + response.count, 'success');

                    // Update total
                    updateTotalDevicesCount();
                } else {
                    $('#device-count-' + serverId).text('-');
                    $('#device-count-grid-' + serverId).text('-');
                }
            },
            error: function() {
                $('#device-count-' + serverId).text('Error');
                $('#device-count-grid-' + serverId).text('Error');
                showNotification('Failed to refresh device count', 'error');
            }
        });
    }

    // Add auto-refresh on Add Device action (if you have it)
    function onDeviceAdded(serverId) {
        // Clear cache and refresh count
        refreshDeviceCount(serverId);
    }

    // Update total devices count
    function updateTotalDevicesCount() {
        var total = 0;
        var counted = [];

        $('.device-count-badge:visible').each(function() {
            var text = $(this).text().trim();
            // Skip if still loading
            if (text === '' || $(this).find('.fa-spinner').length > 0) {
                return;
            }

            var count = parseInt(text);
            if (!isNaN(count)) {
                // Avoid double counting
                var id = $(this).attr('id');
                if (counted.indexOf(id) === -1) {
                    total += count;
                    counted.push(id);
                }
            }
        });

        $('#total-devices-count').text(total);
    }

    // Status tracking object to prevent flapping
    var serverStatusHistory = {};
    var statusUpdatePending = {};

    // Auto-check server status with batching and debouncing
    function autoCheckServerStatus() {
        var servers = [];
        $('.server-row:visible').each(function() {
            servers.push($(this).data('server-id'));
        });

        // Process in batches of 3 (reduced from 5)
        var batchSize = 3;
        var index = 0;

        function processBatch() {
            var batch = servers.slice(index, index + batchSize);

            batch.forEach(function(serverId) {
                checkServerStatus(serverId);
            });

            index += batchSize;

            if (index < servers.length) {
                setTimeout(processBatch, 2000); // Increased to 2 seconds between batches
            }
        }

        processBatch();
    }

    function checkServerStatus(serverId) {
        // Skip if update is already pending for this server
        if (statusUpdatePending[serverId]) {
            return;
        }

        statusUpdatePending[serverId] = true;

        $.ajax({
            url: '{$_url}plugin/genieacs_manager/test-connection',
            type: 'GET',
            data: { id: serverId, silent: true },
            dataType: 'json',
            timeout: 8000,
            success: function(response) {
                handleStatusResponse(serverId, response.success);

                // Update response time display if available
                if (response.response_time !== undefined && response.response_time > 0) {
                    $('#response-time-' + serverId).text(response.response_time + 'ms');
                    $('#response-time-mobile-' + serverId).text(response.response_time + 'ms');
                }

                statusUpdatePending[serverId] = false;
            },
            error: function() {
                handleStatusResponse(serverId, false);
                $('#response-time-' + serverId).text('-');
                statusUpdatePending[serverId] = false;
            }
        });
    }

    function handleStatusResponse(serverId, isOnline) {
        // Initialize history if not exists
        if (!serverStatusHistory[serverId]) {
            serverStatusHistory[serverId] = {
                current: null,
                previous: null,
                changeCount: 0,
                lastChange: Date.now()
            };
        }

        var history = serverStatusHistory[serverId];
        var currentStatus = isOnline ? 'online' : 'offline';

        // Get current displayed status
        var displayedStatus = $('#status-' + serverId).find('.label-success').length > 0 ? 'online' : 'offline';

        // If this is a status change
        if (currentStatus !== displayedStatus) {
            // If status changed from what we last recorded
            if (currentStatus !== history.current) {
                history.previous = history.current;
                history.current = currentStatus;
                history.changeCount++;

                var timeSinceLastChange = Date.now() - history.lastChange;

                // Only update if:
                // 1. Status has been consistent for at least 10 seconds, OR
                // 2. This is the 3rd consecutive same status reading
                if (timeSinceLastChange > 10000 || history.changeCount >= 3) {
                    updateServerStatus(serverId, isOnline);
                    history.changeCount = 0;
                    history.lastChange = Date.now();
                }
            }
        } else {
            // Status is same as displayed, reset counter
            history.changeCount = 0;
            history.current = currentStatus;
        }
    }

    function updateServerStatus(serverId, isOnline) {
        // Desktop status
        var statusHtml = isOnline ?
            '<div class="status-indicator online">' +
            '<span class="pulse-dot pulse-green"></span>' +
            '<span class="label label-success">Online</span>' +
            '</div>' :
            '<div class="status-indicator offline">' +
            '<span class="pulse-dot pulse-red"></span>' +
            '<span class="label label-danger">Offline</span>' +
            '</div>';

        $('#status-' + serverId).html(statusHtml);

        // Mobile status
        var mobileStatusHtml = isOnline ?
            '<span class="label label-success"><i class="fa fa-check"></i> Online</span>' :
            '<span class="label label-danger"><i class="fa fa-times"></i> Offline</span>';

        $('#status-mobile-' + serverId).html(mobileStatusHtml);
    }
    // Update document ready
    $(document).ready(function() {
        // Load device counts after page load
        setTimeout(function() {
            loadDeviceCounts();
        }, 500);

        // Check server status in batches with delay
        setTimeout(function() {
            autoCheckServerStatus();
        }, 2000); // Increased initial delay

        // Auto-refresh device counts every 10 minutes (increased from 5)
        setInterval(function() {
            loadDeviceCounts();
        }, 600000);

        // Auto-check status every 2 minutes (increased from 30 seconds)
        setInterval(function() {
            // Only check if page is visible/active
            if (!document.hidden) {
                autoCheckServerStatus();
            }
        }, 120000);

        // Add visibility change handler to pause checks when tab is not active
        document.addEventListener('visibilitychange', function() {
            if (document.hidden) {
                // Clear any pending status updates when tab becomes hidden
                for (var serverId in statusUpdatePending) {
                    statusUpdatePending[serverId] = false;
                }
            }
        });

        // Per page selector dengan seamless transition
        $('#perPageSelector').on('change', function() {
            var perPage = $(this).val();

            // Show loading overlay
            showLoading('Changing page size to ' + perPage + ' entries...');

            // Small delay untuk smooth transition
            setTimeout(function() {
                var baseUrl = '{$_url}plugin/genieacs_manager';
                var separator = baseUrl.indexOf('?') !== -1 ? '&' : '?';
                window.location.href = baseUrl + separator + 'page=1&per_page=' + perPage;
            }, 300);
        });

        // Make pagination links seamless
        $(document).on('click', '.pagination a', function(e) {
            e.preventDefault();
            var url = $(this).attr('href');

            // Show loading
            showLoading('Loading page...');

            // Navigate after small delay
            setTimeout(function() {
                window.location.href = url;
            }, 200);
        });

        // Clean cache periodically
        setInterval(function() {
            $.get('{$_url}plugin/genieacs_manager/clean-cache');
        }, 600000); // Every 10 minutes
    });
    // Local Server Stats Functions
    function refreshLocalStats() {
        // Animate refresh icon
        $('#local-refresh-icon').addClass('fa-spin');

        $.ajax({
            url: '{$_url}plugin/genieacs_manager/get-local-stats',
            type: 'GET',
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    updateLocalStats(response.stats);
                }
                $('#local-refresh-icon').removeClass('fa-spin');
            },
            error: function() {
                $('#local-refresh-icon').removeClass('fa-spin');
                showNotification('Failed to get server stats', 'error');
            }
        });
    }
    // Initialize Gauge Charts
    function initServerGauges() {
        // CPU Gauge
        var cpuCanvas = document.getElementById('cpuGauge');
        if (cpuCanvas) {
            var ctx = cpuCanvas.getContext('2d');
            drawGauge(ctx, {$local_stats.cpu_usage}, 70);
        }

        // Memory Gauge  
        var memCanvas = document.getElementById('memGauge');
        if (memCanvas) {
            var ctx = memCanvas.getContext('2d');
            drawGauge(ctx, {$local_stats.mem_usage}, 70);
        }

        // Disk Gauge
        var diskCanvas = document.getElementById('diskGauge');
        if (diskCanvas) {
            var ctx = diskCanvas.getContext('2d');
            drawGauge(ctx, {$local_stats.disk_usage}, 70);
        }
    }

    // Draw Gauge Function with Dark Mode Support
    function drawGauge(ctx, value, size) {
        var centerX = size / 2;
        var centerY = size / 2;
        var radius = size / 2 - 10;

        // Clear canvas
        ctx.clearRect(0, 0, size, size);

        // Check if dark mode is active
        var isDarkMode = $('body').hasClass('dark-mode') ||
            $('body').hasClass('dark') ||
            $('[data-theme="dark"]').length > 0;

        // Background arc
        ctx.beginPath();
        ctx.arc(centerX, centerY, radius, Math.PI * 0.7, Math.PI * 2.3);
        ctx.lineWidth = 8;
        ctx.strokeStyle = isDarkMode ? '#495057' : '#e0e0e0';
        ctx.stroke();

        // Value arc
        var color = value < 60 ? '#00a65a' : value < 80 ? '#f39c12' : '#dd4b39';
        var endAngle = Math.PI * 0.7 + (Math.PI * 1.6 * value / 100);

        ctx.beginPath();
        ctx.arc(centerX, centerY, radius, Math.PI * 0.7, endAngle);
        ctx.lineWidth = 8;
        ctx.strokeStyle = color;
        ctx.lineCap = 'round';
        ctx.stroke();

        // Center text - FIX DARK MODE COLOR
        ctx.fillStyle = isDarkMode ? '#ffffff' : '#333333';
        ctx.font = 'bold 18px Arial';
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        ctx.fillText(Math.round(value) + '%', centerX, centerY);
    }

    // Refresh Local Stats Function
    function refreshLocalStats() {
        $('#local-refresh-icon').addClass('fa-spin');

        $.ajax({
            url: '{$_url}plugin/genieacs_manager/get-local-stats',
            type: 'GET',
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    var stats = response.stats;

                    // Update gauges with proper size
                    var cpuCtx = document.getElementById('cpuGauge').getContext('2d');
                    drawGauge(cpuCtx, stats.cpu_usage, 70);
                    $('#cpu-text').text(stats.cpu_usage + '%');

                    var memCtx = document.getElementById('memGauge').getContext('2d');
                    drawGauge(memCtx, stats.mem_usage, 70);
                    $('#mem-text').text(stats.mem_usage + '%');
                    $('#mem-detail').text(stats.mem_used_gb + '/' + stats.mem_total_gb + ' GB');

                    var diskCtx = document.getElementById('diskGauge').getContext('2d');
                    drawGauge(diskCtx, stats.disk_usage, 70);
                    $('#disk-text').text(stats.disk_usage + '%');
                    $('#disk-detail').text(stats.disk_used_gb + '/' + stats.disk_total_gb + ' GB');

                    // Update info
                    $('#load-info').text('Load: ' + stats.load_1min + ' / ' + stats.load_5min + ' / ' +
                        stats.load_15min);
                    $('#uptime-info').text('Up: ' + stats.uptime_string);
                    $('#server-hostname').text(stats.hostname);
                }
                $('#local-refresh-icon').removeClass('fa-spin');
            },
            error: function() {
                $('#local-refresh-icon').removeClass('fa-spin');
            }
        });
    }

    // Listen for dark mode toggle to redraw gauges
    $(document).on('click', '.dark-mode-toggle, [data-toggle="dark-mode"]', function() {
        setTimeout(function() {
            initServerGauges();
        }, 100);
    });

    // Initialize on ready
    $(document).ready(function() {
        // Initialize gauges
        initServerGauges();

        // Auto refresh every 10 seconds
        setInterval(function() {
            refreshLocalStats();
        }, 10000);

        // Detect dark mode changes
        var observer = new MutationObserver(function(mutations) {
            mutations.forEach(function(mutation) {
                if (mutation.attributeName === 'class') {
                    // Redraw gauges when dark mode toggles
                    setTimeout(function() {
                        initServerGauges();
                    }, 100);
                }
            });
        });

        // Observe body class changes
        observer.observe(document.body, {
            attributes: true,
            attributeFilter: ['class']
        });
    });

    function updateLocalStats(stats) {
        // Update CPU
        $('#cpu-usage').text(stats.cpu_usage);
        $('#cpu-progress')
            .css('width', stats.cpu_usage + '%')
            .removeClass('progress-bar-success progress-bar-warning progress-bar-danger')
            .addClass(stats.cpu_usage < 60 ? 'progress-bar-success' :
                stats.cpu_usage < 80 ? 'progress-bar-warning' : 'progress-bar-danger');

        // Update Memory
        $('#mem-usage').text(stats.mem_usage);
        $('#mem-progress')
            .css('width', stats.mem_usage + '%')
            .removeClass('progress-bar-success progress-bar-warning progress-bar-danger')
            .addClass(stats.mem_usage < 60 ? 'progress-bar-success' :
                stats.mem_usage < 80 ? 'progress-bar-warning' : 'progress-bar-danger');

        // Update Disk
        $('#disk-usage').text(stats.disk_usage);
        $('#disk-progress')
            .css('width', stats.disk_usage + '%')
            .removeClass('progress-bar-success progress-bar-warning progress-bar-danger')
            .addClass(stats.disk_usage < 60 ? 'progress-bar-success' :
                stats.disk_usage < 80 ? 'progress-bar-warning' : 'progress-bar-danger');

        // Update Load & Uptime
        $('#load-avg').text(stats.load_1min + ' / ' + stats.load_5min + ' / ' + stats.load_15min);
        $('#uptime').text(stats.uptime_string);

        // Update memory and disk details
        $('#mem-usage').next('small').text('(' + stats.mem_used_gb + '/' + stats.mem_total_gb + ' GB)');
        $('#disk-usage').next('small').text('(' + stats.disk_used_gb + '/' + stats.disk_total_gb + ' GB)');
    }

    // Auto refresh every 10 seconds
    setInterval(function() {
        refreshLocalStats();
    }, 10000);


    // Refresh all stats
    function refreshAllStats() {
        location.reload();
    }

    // Toggle view (will implement in next segment)
    function toggleView() {
        // To be implemented in Segment 3
        Swal.fire('Info', 'Grid view will be implemented in next update', 'info');
    }

    // Initialize chart on document ready
    $(document).ready(function() {
        // initServerHealthChart(); // Removed - not needed anymore
        // Auto refresh local stats on load
        setTimeout(function() {
            refreshLocalStats();
        }, 1000);
    });
    // Toggle Priority
    function togglePriority(serverId) {
        $.ajax({
            url: '{$_url}plugin/genieacs_manager/toggle-priority',
            type: 'POST',
            data: { server_id: serverId },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    // Update star icon
                    var star = $('.priority-toggle[data-server-id="' + serverId + '"]');
                    if (response.is_priority) {
                        star.removeClass('fa-star-o').addClass('fa-star text-yellow');
                        $('.server-row[data-server-id="' + serverId + '"]').addClass('priority-server');
                    } else {
                        star.removeClass('fa-star text-yellow').addClass('fa-star-o');
                        $('.server-row[data-server-id="' + serverId + '"]').removeClass('priority-server');
                    }

                    // Reload to reorder if needed
                    setTimeout(function() {
                        location.reload();
                    }, 500);
                }
            }
        });
    }

    // Enhanced test connection with animation
    var originalTestConnection = testConnection;
    testConnection = function(id) {
        // Animate the status cell
        var statusCell = $('#status-' + id);
        statusCell.html('<i class="fa fa-spinner fa-spin"></i> Testing...');

        originalTestConnection(id);
    }

    // Initialize on page load
    $(document).ready(function() {
        // Sort priority servers to top
        sortPriorityServers();
    });

    // Sort priority servers
    function sortPriorityServers() {
        var tbody = $('#deviceTable tbody');
        var rows = tbody.find('tr').toArray();

        rows.sort(function(a, b) {
            var aPriority = $(a).hasClass('priority-server') ? 0 : 1;
            var bPriority = $(b).hasClass('priority-server') ? 0 : 1;
            return aPriority - bPriority;
        });

        tbody.empty();
        $.each(rows, function(index, row) {
            tbody.append(row);
        });
    }
    // Search and Filter Functions
    function applyFilters() {
        var searchTerm = $('#serverSearch').val().toLowerCase();
        var statusFilter = $('#statusFilter').val();
        var protocolFilter = $('#protocolFilter').val();
        var priorityFilter = $('#priorityFilter').val();

        var visibleCount = 0;
        var totalCount = 0;

        // Filter table rows (Desktop)
        $('.server-row').each(function() {
            totalCount++;
            var $row = $(this);
            var serverName = $row.find('td:eq(2)').text().toLowerCase();
            var serverHost = $row.find('td:eq(3)').text().toLowerCase();
            var isOnline = $row.find('.label-success').length > 0;
            var isHttps = $row.find('td:eq(5)').text().indexOf('HTTPS') > -1;
            var isPriority = $row.hasClass('priority-server');

            var matchSearch = !searchTerm ||
                serverName.indexOf(searchTerm) > -1 ||
                serverHost.indexOf(searchTerm) > -1;

            var matchStatus = !statusFilter ||
                (statusFilter === 'online' && isOnline) ||
                (statusFilter === 'offline' && !isOnline);

            var matchProtocol = !protocolFilter ||
                (protocolFilter === 'https' && isHttps) ||
                (protocolFilter === 'http' && !isHttps);

            var matchPriority = !priorityFilter ||
                (priorityFilter === 'priority' && isPriority) ||
                (priorityFilter === 'normal' && !isPriority);

            if (matchSearch && matchStatus && matchProtocol && matchPriority) {
                $row.show();
                visibleCount++;
            } else {
                $row.hide();
            }
        });

        // Filter mobile cards
        $('.mobile-server-card').each(function() {
            var $card = $(this);
            var serverName = $card.find('.mobile-card-title strong').text().toLowerCase();
            var serverHost = $card.find('.mobile-card-value:eq(0)').text().toLowerCase();
            var isOnline = $card.find('.mobile-card-status .label-success').length > 0;
            var isHttps = $card.find('.mobile-card-body .label-success').length > 0;
            var isPriority = $card.hasClass('priority-card-mobile');

            var matchSearch = !searchTerm ||
                serverName.indexOf(searchTerm) > -1 ||
                serverHost.indexOf(searchTerm) > -1;

            var matchStatus = !statusFilter ||
                (statusFilter === 'online' && isOnline) ||
                (statusFilter === 'offline' && !isOnline);

            var matchProtocol = !protocolFilter ||
                (protocolFilter === 'https' && isHttps) ||
                (protocolFilter === 'http' && !isHttps);

            var matchPriority = !priorityFilter ||
                (priorityFilter === 'priority' && isPriority) ||
                (priorityFilter === 'normal' && !isPriority);

            if (matchSearch && matchStatus && matchProtocol && matchPriority) {
                $card.show();
            } else {
                $card.hide();
            }
        });

        // Show filter results
        showFilterResults(visibleCount, totalCount);
    }

    function clearFilters() {
        // Show loading overlay
        showLoading('Clearing filters...');

        // Clear input values dengan slight delay untuk visual effect
        setTimeout(function() {
            $('#serverSearch').val('');
            $('#statusFilter').val('');
            $('#protocolFilter').val('');
            $('#priorityFilter').val('');

            // Clear from localStorage
            localStorage.removeItem('acs_filters');

            // Apply filters
            applyFilters();

            // Change loading text
            $('#loading-overlay .loading-text').text('Clear Filter...');

            // Reload page
            setTimeout(function() {
                location.reload();
            }, 500);
        }, 400);
    }

    function showFilterResults(visible, total) {
        // Remove existing badge
        $('.filter-results-badge').remove();

        if (visible < total) {
            var badge = $('<div class="filter-results-badge show">' +
                'Showing ' + visible + ' of ' + total + ' servers ' +
                '<button class="btn btn-xs btn-default" onclick="clearFilters()" style="margin-left: 10px;">' +
                '<i class="fa fa-times"></i> Clear</button>' +
                '</div>');
            $('body').append(badge);

            setTimeout(function() {
                badge.removeClass('show');
                setTimeout(function() {
                    badge.remove();
                }, 300);
            }, 5000);
        }
    }

    // Activity Feed Functions
    var activityLog = [];

    function logActivity(type, message, serverId) {
        var activity = {
            type: type,
            message: message,
            serverId: serverId,
            timestamp: new Date()
        };

        activityLog.unshift(activity);
        if (activityLog.length > 50) {
            activityLog.pop();
        }

        // Save to localStorage
        localStorage.setItem('acs_activity_log', JSON.stringify(activityLog));

        // Update display
        updateActivityFeed();
    }

    function loadActivityLog() {
        var saved = localStorage.getItem('acs_activity_log');
        if (saved) {
            activityLog = JSON.parse(saved);
            // Convert timestamp strings back to Date objects
            activityLog.forEach(function(item) {
                item.timestamp = new Date(item.timestamp);
            });
        }
    }

    function updateActivityFeed() {
        var html = '';
        var displayCount = Math.min(activityLog.length, 5);

        if (displayCount === 0) {
            html = '<div class="activity-item">' +
                '<i class="fa fa-info text-muted"></i>' +
                '<span class="activity-text">No recent activity</span>' +
                '<span class="activity-time">-</span>' +
                '</div>';
        } else {
            for (var i = 0; i < displayCount; i++) {
                var activity = activityLog[i];
                var icon = getActivityIcon(activity.type);
                var timeAgo = getTimeAgo(activity.timestamp);

                html += '<div class="activity-item">' +
                    icon +
                    '<span class="activity-text">' + activity.message + '</span>' +
                    '<span class="activity-time">' + timeAgo + '</span>' +
                    '</div>';
            }
        }

        $('#activity-feed .activity-list').html(html);
    }

    function getActivityIcon(type) {
        switch (type) {
            case 'success':
                return '<i class="fa fa-check text-success"></i>';
            case 'error':
                return '<i class="fa fa-times text-danger"></i>';
            case 'warning':
                return '<i class="fa fa-exclamation text-warning"></i>';
            case 'info':
                return '<i class="fa fa-info text-info"></i>';
            default:
                return '<i class="fa fa-circle-o text-muted"></i>';
        }
    }

    function getTimeAgo(date) {
        var seconds = Math.floor((new Date() - date) / 1000);

        if (seconds < 60) return 'just now';
        if (seconds < 3600) return Math.floor(seconds / 60) + 'm ago';
        if (seconds < 86400) return Math.floor(seconds / 3600) + 'h ago';
        if (seconds < 604800) return Math.floor(seconds / 86400) + 'd ago';

        return date.toLocaleDateString();
    }

    function refreshActivity() {
        updateActivityFeed();

        // Animate refresh button
        var btn = $('#activity-feed').prev().find('.fa-refresh');
        btn.addClass('fa-spin');
        setTimeout(function() {
            btn.removeClass('fa-spin');
        }, 500);
    }

    // Update existing testConnection to add logging
    var originalTestConnection2 = testConnection;
    testConnection = function(id) {
        var serverName = $('.server-row[data-server-id="' + id + '"] td:eq(2)').text();
        logActivity('info', 'Testing connection to ' + serverName, id);

        var statusCell = $('#status-' + id);
        statusCell.html('<i class="fa fa-spinner fa-spin"></i> Testing...');

        $.ajax({
            url: '{$_url}plugin/genieacs_manager/test-connection',
            type: 'GET',
            data: { id: id },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    statusCell.html('<div class="status-indicator online">' +
                        '<span class="pulse-dot pulse-green"></span>' +
                        '<span class="label label-success">Online</span>' +
                        '</div>');
                    logActivity('success', serverName + ' is online', id);
                    // Timeline call removed
                } else {
                    statusCell.html('<div class="status-indicator offline">' +
                        '<span class="pulse-dot pulse-red"></span>' +
                        '<span class="label label-danger">Offline</span>' +
                        '</div>');
                    logActivity('error', serverName + ' is offline: ' + response.message, id);
                    // Timeline call removed
                }
            },
            error: function() {
                statusCell.html('<div class="status-indicator offline">' +
                    '<span class="pulse-dot pulse-red"></span>' +
                    '<span class="label label-danger">Offline</span>' +
                    '</div>');
                logActivity('error', 'Failed to test ' + serverName, id);
                // Timeline call removed
            }
        });
    }

    // Initialize on document ready
    $(document).ready(function() {
        // Load activity log
        loadActivityLog();
        updateActivityFeed();

        // Auto-refresh activity every 30 seconds
        setInterval(function() {
            updateActivityFeed();
        }, 30000);

        // Initialize collapsible boxes - FIXED VERSION
        $(document).on('click', '[data-widget="collapse"]', function(e) {
            e.preventDefault();
            e.stopPropagation();

            var box = $(this).closest('.box');
            var body = box.find('.box-body').first();
            var icon = $(this).find('i');

            if (box.hasClass('collapsed-box')) {
                // Box is collapsed, so expand it
                body.slideDown(300, function() {
                    box.removeClass('collapsed-box');
                });
                icon.removeClass('fa-plus').addClass('fa-minus');
            } else {
                // Box is expanded, so collapse it
                body.slideUp(300, function() {
                    box.addClass('collapsed-box');
                });
                icon.removeClass('fa-minus').addClass('fa-plus');
            }

            return false;
        });
    });
    // Performance & Polish Functions

    // Show loading overlay
    function showLoading(message) {
        $('#loading-overlay .loading-text').text(message || 'Processing...');
        $('#loading-overlay').fadeIn(200);
    }

    // Hide loading overlay
    function hideLoading() {
        $('#loading-overlay').fadeOut(200);
    }

    // Show notification
    function showNotification(message, type) {
        type = type || 'info';

        var notification = $('<div class="notification ' + type + ' fade-in">' +
            '<span class="notification-close" onclick="$(this).parent().remove()">×</span>' +
            '<i class="fa ' + getNotificationIcon(type) + '"></i> ' +
            message +
            '</div>');

        $('#notification-container').append(notification);

        // Auto remove after 5 seconds
        setTimeout(function() {
            notification.fadeOut(300, function() {
                $(this).remove();
            });
        }, 5000);
    }

    function getNotificationIcon(type) {
        switch (type) {
            case 'success':
                return 'fa-check-circle';
            case 'error':
                return 'fa-times-circle';
            case 'warning':
                return 'fa-exclamation-triangle';
            default:
                return 'fa-info-circle';
        }
    }

    // Enhanced test all connections
    function testAllConnections() {
        showLoading('Testing all server connections...');

        // Log activity start
        logActivity('info', 'Started testing all connections', null);

        $.ajax({
            url: '{$_url}plugin/genieacs_manager/test-all',
            type: 'GET',
            dataType: 'json',
            success: function(response) {
                hideLoading();

                if (response.success) {
                    var summary = response.summary;
                    showNotification(
                        'Tested ' + summary.total + ' servers: ' +
                        summary.online + ' online, ' + summary.offline + ' offline',
                        summary.offline > 0 ? 'warning' : 'success'
                    );

                    // Log activity result
                    var resultType = summary.offline > 0 ? 'warning' : 'success';
                    var resultMsg = 'Test completed: ' + summary.online + '/' + summary.total + ' online';
                    logActivity(resultType, resultMsg, null);

                    // Update UI
                    response.results.forEach(function(result) {
                        var statusCell = $('#status-' + result.id);
                        if (result.success) {
                            statusCell.html('<div class="status-indicator online">' +
                                '<span class="pulse-dot pulse-green"></span>' +
                                '<span class="label label-success">Online</span>' +
                                '</div>');
                        } else {
                            statusCell.html('<div class="status-indicator offline">' +
                                '<span class="pulse-dot pulse-red"></span>' +
                                '<span class="label label-danger">Offline</span>' +
                                '</div>');
                        }
                    });

                    // Optional: Refresh statistics cards
                    setTimeout(function() {
                        location.reload();
                    }, 2000);
                }
            },
            error: function() {
                hideLoading();
                showNotification('Failed to test connections', 'error');
                logActivity('error', 'Failed to test all connections', null);
            }
        });
    }

    // Animate number changes
    function animateNumber(selector, newValue) {
        var element = $(selector);
        var currentValue = parseInt(element.text()) || 0;

        if (currentValue === newValue) return;

        var increment = newValue > currentValue ? 1 : -1;
        var steps = Math.abs(newValue - currentValue);
        var duration = Math.min(1000, steps * 50);
        var stepDuration = duration / steps;

        var counter = currentValue;
        var timer = setInterval(function() {
            counter += increment;
            element.text(counter);

            if (counter === newValue) {
                clearInterval(timer);
                element.addClass('shake');
                setTimeout(function() {
                    element.removeClass('shake');
                }, 500);
            }
        }, stepDuration);
    }


    // Keyboard shortcuts
    $(document).keydown(function(e) {
        // Alt + A: Add server
        if (e.altKey && e.keyCode === 65) {
            e.preventDefault();
            showAddServerModal();
        }
        // Alt + T: Test all
        if (e.altKey && e.keyCode === 84) {
            e.preventDefault();
            testAllConnections();
        }
        // Escape: Close modals
        if (e.keyCode === 27) {
            $('.modal').modal('hide');
        }
    });

    // Auto-save and auto-apply filters
    $('#serverSearch, #statusFilter, #protocolFilter, #priorityFilter').on('change', function() {
        var filters = {
            search: $('#serverSearch').val(),
            status: $('#statusFilter').val(),
            protocol: $('#protocolFilter').val(),
            priority: $('#priorityFilter').val()
        };

        // Check if all filters are empty
        var hasActiveFilter = filters.search || filters.status || filters.protocol || filters.priority;

        if (hasActiveFilter) {
            // Save only if there are active filters
            localStorage.setItem('acs_filters', JSON.stringify(filters));
        } else {
            // Remove from localStorage if all empty
            localStorage.removeItem('acs_filters');
        }

        // Auto apply filters when changed
        applyFilters();
    });

    // Also apply on keyup for search field
    $('#serverSearch').on('keyup', function() {
        applyFilters();
    });

    // Load saved filters
    function loadSavedFilters() {
        var saved = localStorage.getItem('acs_filters');
        if (saved) {
            try {
                var filters = JSON.parse(saved);

                // Validate that filters have actual values
                var hasValidFilter = false;

                if (filters.search && filters.search.trim() !== '') {
                    $('#serverSearch').val(filters.search);
                    hasValidFilter = true;
                }

                if (filters.status && filters.status !== '') {
                    $('#statusFilter').val(filters.status);
                    hasValidFilter = true;
                }

                if (filters.protocol && filters.protocol !== '') {
                    $('#protocolFilter').val(filters.protocol);
                    hasValidFilter = true;
                }

                if (filters.priority && filters.priority !== '') {
                    $('#priorityFilter').val(filters.priority);
                    hasValidFilter = true;
                }

                // If no valid filters, clear localStorage
                if (!hasValidFilter) {
                    localStorage.removeItem('acs_filters');
                } else {
                    applyFilters();
                }
            } catch (e) {
                // If JSON parse fails, clear the corrupted data
                localStorage.removeItem('acs_filters');
                console.error('Failed to load filters:', e);
            }
        }
    }

    // Performance monitoring
    var performanceTimer;

    function monitorPerformance() {
        var start = performance.now();

        // Check if page is responsive
        setTimeout(function() {
            var loadTime = performance.now() - start;
            if (loadTime > 3000) {
                $('#performance-alert').show();
                $('#performance-message').text(
                    'Page loading slowly. Consider reducing the number of servers or enabling pagination.');
            }
        }, 100);
    }

    // Initialize everything
    $(document).ready(function() {
        // Load saved filters
        loadSavedFilters();

        // Monitor performance
        monitorPerformance();

        // Show welcome message for first-time users
        if (!localStorage.getItem('acs_welcomed')) {
            showNotification('Welcome to GenieACS Manager! Use Alt+H for keyboard shortcuts.', 'info');
            localStorage.setItem('acs_welcomed', 'true');
        }

        // Lazy load images
        $('img[data-src]').each(function() {
            $(this).attr('src', $(this).data('src'));
        });

        // Enable tooltips
        $('[title]').tooltip({
            container: 'body',
            placement: 'auto'
        });
    });

    // Clean up on page unload
    $(window).on('beforeunload', function() {
        // Save current state
        var state = {
            view: localStorage.getItem('acs_view_mode'),
            filters: localStorage.getItem('acs_filters'),
            activity: localStorage.getItem('acs_activity_log')
        };

        // Could save to server if needed
    });

    // Improved error handling
    window.onerror = function(msg, url, line, col, error) {
        console.error('Error:', msg, 'at', url + ':' + line);
        showNotification('An error occurred. Please refresh the page.', 'error');
        return false;
    };
    // Toggle password visibility
    function togglePassword() {
        var passwordInput = $('#server_password');
        var icon = $('#password-toggle-icon');

        if (passwordInput.attr('type') === 'password') {
            passwordInput.attr('type', 'text');
            icon.removeClass('fa-eye').addClass('fa-eye-slash');
        } else {
            passwordInput.attr('type', 'password');
            icon.removeClass('fa-eye-slash').addClass('fa-eye');
        }
    }
    // Test connection before save
    function testAndSaveServer() {
        var formData = $('#serverForm').serialize();

        showLoading('Testing connection...');

        $.ajax({
            url: '{$_url}plugin/genieacs_manager/test-connection-temp',
            type: 'POST',
            data: formData,
            dataType: 'json',
            success: function(response) {
                hideLoading();
                if (response.success) {
                    Swal.fire({
                        title: 'Connection Successful!',
                        text: response.message,
                        icon: 'success',
                        showCancelButton: true,
                        confirmButtonText: 'Save Server',
                        cancelButtonText: 'Cancel'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            saveServer();
                        }
                    });
                } else {
                    Swal.fire('Connection Failed!', response.message, 'error');
                }
            },
            error: function() {
                hideLoading();
                Swal.fire('Error!', 'Connection test failed', 'error');
            }
        });
    }

    // Device Mapping Functions
    var mappingCurrentPage = 1;
    var mappingSearch = '';
    var mappingServerFilter = '';

    function showDeviceMappingModal() {
        $('#deviceMappingModal').modal('show');
        loadDeviceMappings(1);
    }

    function loadDeviceMappings(page) {
        page = page || mappingCurrentPage;
        mappingCurrentPage = page;

        var loadingHtml =
            '<tr><td colspan="6" class="text-center hidden-xs"><i class="fa fa-spinner fa-spin"></i> Loading mappings...</td><td colspan="3" class="text-center visible-xs"><i class="fa fa-spinner fa-spin"></i> Loading...</td></tr>';
        $('#mappingTableBody').html(loadingHtml);

        var params = {
            page: page,
            search: mappingSearch,
            server_filter: mappingServerFilter
        };

        $.ajax({
            url: '{$_url}plugin/genieacs_manager/get-device-mappings',
            type: 'GET',
            data: params,
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    updateMappingTable(response.mappings);
                    updateMappingPagination(response.pagination);
                    updateServerFilter(response.servers);
                } else {
                    var errorHtml =
                        '<tr><td colspan="6" class="text-center text-danger hidden-xs">Failed to load mappings</td><td colspan="3" class="text-center text-danger visible-xs">Failed to load</td></tr>';
                    $('#mappingTableBody').html(errorHtml);
                }
            },
            error: function() {
                var errorHtml =
                    '<tr><td colspan="6" class="text-center text-danger hidden-xs">Error loading mappings</td><td colspan="3" class="text-center text-danger visible-xs">Error loading</td></tr>';
                $('#mappingTableBody').html(errorHtml);
            }
        });
    }

    function updateServerFilter(servers) {
        var select = $('#serverFilter');
        var currentValue = select.val();

        select.empty().append('<option value="">All Servers</option>');

        servers.forEach(function(server) {
            select.append('<option value="' + server.id + '">' + server.name + '</option>');
        });

        if (currentValue) {
            select.val(currentValue);
        }
    }

    function updateMappingPagination(pagination) {
        // Update info
        var start = (pagination.current_page - 1) * pagination.per_page + 1;
        var end = Math.min(pagination.current_page * pagination.per_page, pagination.total_count);
        $('#mappingInfo').text('Showing ' + start + ' to ' + end + ' of ' + pagination.total_count + ' entries');

        // Update pagination
        var html = '';

        if (pagination.total_pages > 1) {
            // Previous
            if (pagination.current_page > 1) {
                html += '<li><a href="#" onclick="loadDeviceMappings(' + (pagination.current_page - 1) +
                    ')">Previous</a></li>';
            }

            // Pages
            for (var i = 1; i <= pagination.total_pages; i++) {
                if (i === pagination.current_page) {
                    html += '<li class="active"><a href="#">' + i + '</a></li>';
                } else {
                    html += '<li><a href="#" onclick="loadDeviceMappings(' + i + ')">' + i + '</a></li>';
                }
            }

            // Next
            if (pagination.current_page < pagination.total_pages) {
                html += '<li><a href="#" onclick="loadDeviceMappings(' + (pagination.current_page + 1) +
                    ')">Next</a></li>';
            }
        }

        $('#mappingPagination .pagination').html(html);
    }

    // Search and Filter
    $('#mappingSearch').on('keyup', function() {
        mappingSearch = $(this).val();
        loadDeviceMappings(1);
    });

    $('#serverFilter').on('change', function() {
        mappingServerFilter = $(this).val();
        loadDeviceMappings(1);
    });

    function clearMappingFilters() {
        $('#mappingSearch').val('');
        $('#serverFilter').val('');
        mappingSearch = '';
        mappingServerFilter = '';
        loadDeviceMappings(1);
    }

    function updateMappingTable(mappings) {
        var html = '';

        if (mappings.length === 0) {
            html = '<tr><td colspan="6" class="text-center text-muted hidden-xs">No device mappings found</td>' +
                '<td colspan="3" class="text-center text-muted visible-xs">No mappings found</td></tr>';
        } else {
            mappings.forEach(function(mapping) {
                var serverName = mapping.server_name || 'Server ' + mapping.server_id;
                var lastUpdated = new Date(mapping.last_updated).toLocaleString();

                // Show vendor if available, otherwise show device ID
                var deviceDisplay = '';
                if (mapping.vendor) {
                    var deviceIdShort = mapping.device_id.length > 20 ?
                        mapping.device_id.substring(0, 20) + '...' :
                        mapping.device_id;
                    deviceDisplay = '<strong class="text-success">' + mapping.vendor + '</strong><br>' +
                        '<small class="text-muted">' + deviceIdShort + '</small>';
                } else {
                    var deviceIdShort = mapping.device_id.length > 30 ?
                        mapping.device_id.substring(0, 30) + '...' :
                        mapping.device_id;
                    deviceDisplay = '<span class="text-muted">' + deviceIdShort + '</span>';
                }

                html += '<tr>' +
                    '<td class="hidden-xs text-muted">' + mapping.id + '</td>' +
                    '<td>' +
                    '<div class="visible-xs mobile-user-info">' +
                    '<div class="mobile-username">' +
                    '<strong class="text-primary">' + mapping.username + '</strong>' +
                    '<span class="mobile-server-badge">' + serverName + '</span>' +
                    '</div>' +
                    '</div>' +
                    '<div class="hidden-xs">' +
                    '<strong class="text-primary">' + mapping.username + '</strong>' +
                    '</div>' +
                    '</td>' +
                    '<td title="' + mapping.device_id + '">' + deviceDisplay + '</td>' +
                    '<td class="hidden-xs"><span class="label label-default">' + serverName + '</span></td>' +
                    '<td class="hidden-xs text-muted"><small>' + lastUpdated + '</small></td>' +
                    '<td class="text-center">' +
                    '<button class="btn btn-danger btn-xs" onclick="deleteMapping(' + mapping.id +
                    ')" title="Delete mapping">' +
                    '<i class="fa fa-trash"></i>' +
                    '</button>' +
                    '</td>' +
                    '</tr>';
            });
        }

        $('#mappingTableBody').html(html);
    }

    function deleteMapping(id) {
        Swal.fire({
            title: 'Delete Mapping?',
            text: 'This will clear the device cache for this user',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            confirmButtonText: 'Yes, delete it!'
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: '{$_url}plugin/genieacs_manager/delete-device-mapping',
                    type: 'POST',
                    data: { id: id },
                    dataType: 'json',
                    success: function(response) {
                        if (response.success) {
                            Swal.fire('Deleted!', response.message, 'success');
                            loadDeviceMappings(); // Reload table
                        } else {
                            Swal.fire('Error!', response.message, 'error');
                        }
                    },
                    error: function() {
                        Swal.fire('Error!', 'Failed to delete mapping', 'error');
                    }
                });
            }
        });
    }

    function clearAllMappings() {
        Swal.fire({
            title: 'Clear All Mappings?',
            text: 'This will delete ALL device cache entries. Users will need to re-discover their devices.',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            confirmButtonText: 'Yes, clear all!'
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: '{$_url}plugin/genieacs_manager/clear-all-mappings',
                    type: 'POST',
                    dataType: 'json',
                    success: function(response) {
                        if (response.success) {
                            Swal.fire('Cleared!', response.message, 'success');
                            loadDeviceMappings(); // Reload table
                        } else {
                            Swal.fire('Error!', response.message, 'error');
                        }
                    },
                    error: function() {
                        Swal.fire('Error!', 'Failed to clear mappings', 'error');
                    }
                });
            }
        });
    }

    // ============================================
    // UNINSTALL FUNCTIONS
    // ============================================
    
    function showUninstallModal() {
        $('#uninstall_confirm').val('');
        $('#uninstall-progress-section').hide();
        $('#uninstall-log-content').html('');
        $('#btn-run-uninstall').prop('disabled', false).html('<i class="fa fa-trash"></i> Uninstall Plugin');
        $('#btn-cancel-uninstall').show();
        $('#uninstallModalOverlay').fadeIn(200);
        $('body').css('overflow', 'hidden');
    }
    
    function closeUninstallModal() {
        $('#uninstallModalOverlay').fadeOut(200);
        $('body').css('overflow', '');
    }
    
    // Close modal on overlay click
    $(document).on('click', '#uninstallModalOverlay', function(e) {
        if (e.target === this) {
            closeUninstallModal();
        }
    });
    
    // Close modal on Escape key
    $(document).on('keydown', function(e) {
        if (e.key === 'Escape' && $('#uninstallModalOverlay').is(':visible')) {
            closeUninstallModal();
        }
    });
    
    function runUninstall() {
        var confirmText = $('#uninstall_confirm').val().trim();
        
        if (confirmText !== 'UNINSTALL') {
            Swal.fire({
                title: 'Konfirmasi Diperlukan',
                text: 'Silakan ketik UNINSTALL untuk melanjutkan',
                icon: 'warning'
            });
            return;
        }
        
        // Double confirmation
        Swal.fire({
            title: 'Konfirmasi Terakhir',
            html: '<p>Apakah Anda yakin?</p><p><strong>Tindakan ini tidak dapat dibatalkan!</strong></p>',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#dc2626',
            confirmButtonText: 'Ya, Uninstall Sekarang!',
            cancelButtonText: 'Batal'
        }).then((result) => {
            if (result.isConfirmed) {
                executeUninstall();
            }
        });
    }
    
    function executeUninstall() {
        // Disable buttons
        $('#btn-run-uninstall').prop('disabled', true).html('<i class="fa fa-spinner fa-spin"></i> Uninstalling...');
        $('#btn-cancel-uninstall').hide();
        
        // Show progress log
        $('#uninstall-progress-section').slideDown(300);
        addUninstallLog('Memulai proses uninstall...', 'info');
        
        $.ajax({
            url: '{$_url}plugin/genieacs_manager/uninstall',
            type: 'POST',
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    // Show all details with animation
                    if (response.details) {
                        response.details.forEach(function(detail, index) {
                            setTimeout(function() {
                                addUninstallLog(detail, 'success');
                            }, index * 300);
                        });
                    }
                    
                    // Show success and redirect
                    var totalDelay = (response.details ? response.details.length * 300 : 0) + 1000;
                    setTimeout(function() {
                        closeUninstallModal();
                        Swal.fire({
                            title: 'Berhasil!',
                            text: response.message,
                            icon: 'success',
                            confirmButtonText: 'Ke Dashboard'
                        }).then(() => {
                            window.location.href = '{$_url}dashboard';
                        });
                    }, totalDelay);
                } else {
                    addUninstallLog('Error: ' + response.message, 'error');
                    $('#btn-run-uninstall').prop('disabled', false).html('<i class="fa fa-trash"></i> Coba Lagi');
                    $('#btn-cancel-uninstall').show();
                    
                    Swal.fire('Error!', response.message, 'error');
                }
            },
            error: function(xhr, status, error) {
                addUninstallLog('Koneksi error: ' + error, 'error');
                $('#btn-run-uninstall').prop('disabled', false).html('<i class="fa fa-trash"></i> Coba Lagi');
                $('#btn-cancel-uninstall').show();
                
                Swal.fire('Error!', 'Gagal terhubung ke server', 'error');
            }
        });
    }
    
    function addUninstallLog(message, type) {
        var iconClass = type === 'success' ? 'fa-check' : 
                        type === 'error' ? 'fa-times' : 
                        'fa-circle-o-notch fa-spin';
        
        var html = '<div class="log-item ' + type + '">' +
                   '<i class="fa ' + iconClass + '"></i> ' +
                   '<span>' + message + '</span>' +
                   '</div>';
        
        $('#uninstall-log-content').append(html);
        $('#uninstall-log-content').scrollTop($('#uninstall-log-content')[0].scrollHeight);
    }

    // ============================================
    // UPDATE FUNCTIONS
    // ============================================
    
    var updateData = null;
    
    function checkForUpdate() {
        var btn = $('#btn-check-update');
        var statusText = $('#update-status');
        var iconEl = btn.find('.action-icon i');
        
        // Show loading
        iconEl.removeClass('fa-refresh').addClass('fa-spinner fa-spin');
        statusText.text('Checking...');
        
        $.ajax({
            url: '{$_url}plugin/genieacs_manager/check-update',
            type: 'GET',
            dataType: 'json',
            success: function(response) {
                iconEl.removeClass('fa-spinner fa-spin').addClass('fa-refresh');
                
                if (response.success) {
                    if (response.has_update) {
                        // Has update available
                        updateData = response;
                        btn.addClass('has-update');
                        statusText.text('v' + response.latest_version + ' available!');
                        
                        // Show update modal
                        showUpdateModal(response);
                    } else {
                        // Already latest
                        btn.removeClass('has-update');
                        statusText.text('Up to date ✓');
                        showNotification('You are using the latest version (v' + response.current_version + ')', 'success');
                        
                        // Reset text after 5 seconds
                        setTimeout(function() {
                            statusText.text('Click to check');
                        }, 5000);
                    }
                } else {
                    // Check if it's a GitHub token issue - show as info instead of error
                    if (response.token_required || (response.message && response.message.indexOf('GitHub token') !== -1)) {
                        statusText.text('Not configured');
                        // Only show notification if user manually clicked, not on auto-check
                        if (arguments.length > 0 && arguments[0] !== 'auto') {
                            showNotification('Update checking requires GitHub token. Configure in Settings > General Settings > Authentication.', 'info');
                        }
                    } else {
                        statusText.text('Check failed');
                        showNotification(response.message, 'error');
                    }
                }
            },
            error: function() {
                iconEl.removeClass('fa-spinner fa-spin').addClass('fa-refresh');
                statusText.text('Check failed');
                showNotification('Failed to check for updates', 'error');
            }
        });
    }
    
    function showUpdateModal(data) {
        // Set versions
        $('#current-version').text('v' + data.current_version);
        $('#new-version').text('v' + data.latest_version);
        
        // Set changelog
        var changelogHtml = '';
        if (data.changelog && data.changelog.length > 0) {
            data.changelog.forEach(function(item) {
                changelogHtml += '<div class="changelog-item"><i class="fa fa-check-circle"></i><span>' + item + '</span></div>';
            });
        } else {
            changelogHtml = '<div class="changelog-item"><i class="fa fa-info-circle"></i><span>No changelog available</span></div>';
        }
        $('#changelog-list').html(changelogHtml);
        
        // Reset UI
        $('#update-progress-section').hide();
        $('#update-log-content').html('');
        $('#btn-run-update').prop('disabled', false).html('<i class="fa fa-download"></i> Update Now');
        $('#btn-cancel-update').show();
        
        // Show modal
        $('#updateModalOverlay').fadeIn(200);
        $('body').css('overflow', 'hidden');
    }
    
    function closeUpdateModal() {
        $('#updateModalOverlay').fadeOut(200);
        $('body').css('overflow', '');
    }
    
    // Close modal on overlay click
    $(document).on('click', '#updateModalOverlay', function(e) {
        if (e.target === this) {
            closeUpdateModal();
        }
    });
    
    function runUpdate() {
        // Disable buttons
        $('#btn-run-update').prop('disabled', true).html('<i class="fa fa-spinner fa-spin"></i> Updating...');
        $('#btn-cancel-update').hide();
        
        // Show progress
        $('#update-progress-section').slideDown(300);
        addUpdateLog('Starting update process...', 'info');
        
        $.ajax({
            url: '{$_url}plugin/genieacs_manager/run-update',
            type: 'POST',
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    // Show all details with animation
                    if (response.details) {
                        response.details.forEach(function(detail, index) {
                            setTimeout(function() {
                                addUpdateLog(detail, 'success');
                            }, index * 300);
                        });
                    }
                    
                    // Show success and reload
                    var totalDelay = (response.details ? response.details.length * 300 : 0) + 1000;
                    setTimeout(function() {
                        closeUpdateModal();
                        Swal.fire({
                            title: 'Update Complete!',
                            text: response.message,
                            icon: 'success',
                            confirmButtonText: 'Reload Page'
                        }).then(() => {
                            location.reload();
                        });
                    }, totalDelay);
                } else {
                    addUpdateLog('Error: ' + response.message, 'error');
                    $('#btn-run-update').prop('disabled', false).html('<i class="fa fa-download"></i> Retry');
                    $('#btn-cancel-update').show();
                    
                    Swal.fire('Update Failed', response.message, 'error');
                }
            },
            error: function(xhr, status, error) {
                addUpdateLog('Connection error: ' + error, 'error');
                $('#btn-run-update').prop('disabled', false).html('<i class="fa fa-download"></i> Retry');
                $('#btn-cancel-update').show();
                
                Swal.fire('Error', 'Failed to connect to server', 'error');
            }
        });
    }
    
    function addUpdateLog(message, type) {
        var iconClass = type === 'success' ? 'fa-check' : 
                        type === 'error' ? 'fa-times' : 
                        'fa-circle-o-notch fa-spin';
        
        var html = '<div class="log-item ' + type + '">' +
                   '<i class="fa ' + iconClass + '"></i> ' +
                   '<span>' + message + '</span>' +
                   '</div>';
        
        $('#update-log-content').append(html);
        $('#update-log-content').scrollTop($('#update-log-content')[0].scrollHeight);
    }
    
    // Auto-check for updates on page load (only if GitHub token might be configured)
    $(document).ready(function() {
        // Only auto-check if we think token might be configured (check silently)
        // We'll suppress the notification for auto-checks
        setTimeout(function() {
            // Silent auto-check - won't show notification if token is missing
            checkForUpdateSilent();
        }, 3000);
    });
    
    // Silent version that doesn't show notifications for missing token
    function checkForUpdateSilent() {
        var btn = $('#btn-check-update');
        var statusText = $('#update-status');
        var iconEl = btn.find('.action-icon i');
        
        // Show loading
        iconEl.removeClass('fa-refresh').addClass('fa-spinner fa-spin');
        
        $.ajax({
            url: '{$_url}plugin/genieacs_manager/check-update',
            type: 'GET',
            dataType: 'json',
            success: function(response) {
                iconEl.removeClass('fa-spinner fa-spin').addClass('fa-refresh');
                
                if (response.success) {
                    if (response.has_update) {
                        updateData = response;
                        btn.addClass('has-update');
                        statusText.text('v' + response.latest_version + ' available!');
                        showUpdateModal(response);
                    } else {
                        btn.removeClass('has-update');
                        statusText.text('Up to date ✓');
                        setTimeout(function() {
                            statusText.text('Click to check');
                        }, 5000);
                    }
                } else {
                    // For auto-check, only update status text, don't show notification
                    if (response.token_required || (response.message && response.message.indexOf('GitHub token') !== -1)) {
                        statusText.text('Click to check');
                    } else {
                        statusText.text('Check failed');
                    }
                }
            },
            error: function() {
                iconEl.removeClass('fa-spinner fa-spin').addClass('fa-refresh');
                statusText.text('Click to check');
            }
        });
    }
</script>

<style>
    /* Fix sharp corners at bottom */
    .panel-primary {
        overflow: hidden;
        border-top: 3px solid #605ca8;
        /* Purple to match other cards */
    }

    .panel-primary>.panel-body {
        padding-bottom: 0;
    }

    /* Footer controls should match panel radius */
    .table-footer-controls {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 15px;
        background-color: #f8f9fa;
        border-top: 1px solid #dee2e6;
        margin: 0 -15px -10px -15px;
        /* Negative margin to align with panel edges */
        border-bottom-left-radius: 3px;
        border-bottom-right-radius: 3px;
    }

    /* Ensure no overflow from table */
    .table-responsive {
        overflow-x: auto;
        overflow-y: hidden;
        margin-bottom: 0;
    }

    /* Dark mode */
    .dark-mode .table-footer-controls,
    body.dark-mode .table-footer-controls {
        background-color: #2c3139;
        border-top-color: #495057;
    }

    /* Remove any conflicting radius */
    .panel-body .table-responsive:last-child .table {
        border-bottom-left-radius: 0;
        border-bottom-right-radius: 0;
    }

    /* Integrated Table Footer */
    .table-footer-controls {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 15px;
        background-color: #f8f9fa;
        border-top: 1px solid #dee2e6;
        margin: 0 -1px -1px -1px;
    }

    .footer-left {
        display: flex;
        align-items: center;
        gap: 20px;
    }

    .footer-right {
        display: flex;
        align-items: center;
    }

    .dataTables_length {
        display: flex;
        align-items: center;
    }

    .dataTables_length label {
        margin: 0;
        display: flex;
        align-items: center;
        gap: 5px;
    }

    .dataTables_length select {
        width: auto !important;
        display: inline-block !important;
        margin: 0 5px;
    }

    /* Remove margins from pagination */
    .table-footer-controls .pagination {
        margin: 0;
    }

    /* Dark Mode */
    .dark-mode .table-footer-controls,
    body.dark-mode .table-footer-controls {
        background-color: #2c3139;
        border-top-color: #495057;
        color: #b8c7ce;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .table-footer-controls {
            flex-direction: column;
            gap: 15px;
            padding: 10px;
        }

        .footer-left {
            flex-direction: column;
            align-items: center;
            gap: 10px;
            width: 100%;
            text-align: center;
        }

        .dataTables_info {
            font-size: 12px;
            padding: 5px 0;
        }

        .dataTables_length {
            display: flex;
            justify-content: center;
            width: 100%;
        }

        .dataTables_length label {
            font-size: 12px;
        }

        .dataTables_length select {
            width: 70px !important;
            font-size: 12px;
            padding: 5px 8px;
            height: auto !important;
            line-height: 1.4;
        }

        .footer-right {
            width: 100%;
            justify-content: center;
        }

        .pagination {
            font-size: 12px;
        }

        .pagination>li>a,
        .pagination>li>span {
            padding: 5px 8px;
            font-size: 11px;
        }
    }

    @media (max-width: 480px) {
        .dataTables_info {
            font-size: 11px;
        }

        .pagination>li>a,
        .pagination>li>span {
            padding: 4px 6px;
            font-size: 10px;
        }

        /* Hide ellipsis on very small screens */
        .pagination>li.disabled:not(:first-child):not(:last-child) {
            display: none;
        }
    }

    /* Server Health Gauge Styles */
    .gauge-label {
        margin-top: 8px;
        font-size: 12px;
        color: #666;
        font-weight: 600;
    }

    .gauge-value {
        display: block;
        font-size: 16px;
        font-weight: bold;
        color: #333;
        margin-top: 3px;
    }

    .gauge-detail {
        display: block;
        font-size: 10px;
        color: #999;
        font-weight: normal;
        margin-top: 2px;
    }

    .server-info-footer {
        display: flex;
        justify-content: space-around;
        padding-top: 15px;
        border-top: 1px solid #f0f0f0;
        margin-top: 10px;
    }

    .info-item {
        font-size: 12px;
        color: #666;
        text-align: center;
    }

    .info-item i {
        margin-right: 5px;
    }

    /* Dark mode support with better contrast */
    .dark-mode .gauge-label,
    body.dark-mode .gauge-label,
    [data-theme="dark"] .gauge-label {
        color: #adb5bd !important;
    }

    .dark-mode .gauge-value,
    body.dark-mode .gauge-value,
    [data-theme="dark"] .gauge-value {
        color: #ffffff !important;
    }

    .dark-mode .gauge-detail,
    body.dark-mode .gauge-detail,
    [data-theme="dark"] .gauge-detail {
        color: #8c959d !important;
    }

    .dark-mode .server-info-footer,
    body.dark-mode .server-info-footer,
    [data-theme="dark"] .server-info-footer {
        border-top-color: #495057 !important;
    }

    .dark-mode .info-item,
    body.dark-mode .info-item,
    [data-theme="dark"] .info-item {
        color: #adb5bd !important;
    }

    /* Canvas text color fix for dark mode */
    .dark-mode canvas,
    body.dark-mode canvas {
        color: #ffffff !important;
    }

    /* Responsive */
    @media (max-width: 480px) {

        #cpuGauge,
        #memGauge,
        #diskGauge {
            width: 70px !important;
            height: 70px !important;
        }

        .gauge-label {
            font-size: 11px;
        }

        .gauge-value {
            font-size: 14px;
        }

        .gauge-detail {
            font-size: 9px;
        }
    }

    @media (max-width: 768px) {
        .server-info-footer {
            flex-direction: column;
            gap: 8px;
        }

        .info-item {
            text-align: left;
        }
    }

    /* Modern Quick Action Buttons */
    .quick-action-compact {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 8px;
        height: 100%;
        align-content: center;
        padding: 5px 0;
    }

    /* Mobile: kembali ke 1 kolom */
    @media (max-width: 992px) {
        .quick-action-compact {
            grid-template-columns: 1fr;
            gap: 5px;
        }
    }

    .quick-action-btn {
        width: 100%;
        height: 40px;
        padding: 0;
        border: 2px solid transparent;
        border-radius: 6px;
        background: #fff;
        display: flex;
        align-items: center;
        justify-content: space-between;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        overflow: hidden;
        position: relative;
    }

    .quick-action-btn:hover {
        transform: translateX(5px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    }

    .action-icon {
        width: 40px;
        /* Match dengan height tombol */
        height: 40px;
        /* Match dengan height tombol */
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 16px;
        /* Kurangi font size */
        flex-shrink: 0;
    }

    .action-content {
        flex: 1;
        text-align: left;
        padding: 0 12px;
        /* Kurangi dari 15px */
    }

    .action-title {
        display: block;
        font-size: 14px;
        /* Kurangi dari 15px */
        font-weight: 600;
        color: #333;
        margin-bottom: 1px;
        /* Kurangi dari 2px */
    }

    .action-desc {
        display: block;
        font-size: 11px;
        /* Kurangi dari 12px */
        color: #777;
    }

    .action-arrow {
        width: 35px;
        /* Kurangi dari 40px */
        display: flex;
        align-items: center;
        justify-content: center;
        color: #999;
        font-size: 12px;
        /* Kurangi dari 14px */
        transition: transform 0.3s;
    }

    .quick-action-btn:hover .action-arrow {
        transform: translateX(3px);
    }

    /* Button Colors */
    .action-add {
        border-left: 4px solid #00a65a;
    }

    .action-add .action-icon {
        background: linear-gradient(135deg, #00a65a 0%, #00c068 100%);
        color: white;
    }

    .action-add:hover {
        border-color: #00a65a;
        background: linear-gradient(to right, #fff 0%, rgba(0, 166, 90, 0.05) 100%);
    }

    .action-test {
        border-left: 4px solid #00c0ef;
    }

    .action-test .action-icon {
        background: linear-gradient(135deg, #00c0ef 0%, #00d9ff 100%);
        color: white;
    }

    .action-test:hover {
        border-color: #00c0ef;
        background: linear-gradient(to right, #fff 0%, rgba(0, 192, 239, 0.05) 100%);
    }

    .action-params {
        border-left: 4px solid #f39c12;
    }

    .action-params .action-icon {
        background: linear-gradient(135deg, #f39c12 0%, #ffb347 100%);
        color: white;
    }

    .action-params:hover {
        border-color: #f39c12;
        background: linear-gradient(to right, #fff 0%, rgba(243, 156, 18, 0.05) 100%);
    }

    .action-mapping {
        border-left: 4px solid #9b59b6;
    }

    .action-mapping .action-icon {
        background: linear-gradient(135deg, #9b59b6 0%, #c774e8 100%);
        color: white;
    }

    .action-mapping:hover {
        border-color: #9b59b6;
        background: linear-gradient(to right, #fff 0%, rgba(155, 89, 182, 0.05) 100%);
    }

    /* Uninstall Button */
    .action-uninstall {
        border-left: 4px solid #e74c3c;
    }

    .action-uninstall .action-icon {
        background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
        color: white;
    }

    .action-uninstall:hover {
        border-color: #e74c3c;
        background: linear-gradient(to right, #fff 0%, rgba(231, 76, 60, 0.05) 100%);
    }

    /* ==========================================
       MODERN UNINSTALL MODAL STYLES
       ========================================== */
    
    /* Modal Overlay */
    .modal-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.6);
        backdrop-filter: blur(4px);
        z-index: 99999;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 20px;
        box-sizing: border-box;
        animation: fadeIn 0.2s ease;
    }

    @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }

    /* Modal Container */
    .modal-container {
        background: #fff;
        border-radius: 16px;
        width: 100%;
        max-width: 520px;
        max-height: 90vh;
        overflow: hidden;
        box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
        animation: slideUp 0.3s ease;
        display: flex;
        flex-direction: column;
    }

    @keyframes slideUp {
        from {
            opacity: 0;
            transform: translateY(20px) scale(0.95);
        }
        to {
            opacity: 1;
            transform: translateY(0) scale(1);
        }
    }

    .uninstall-modal {
        max-width: 500px;
    }

    /* Modal Header - Danger Style */
    .modal-header-danger {
        background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
        color: #fff;
        padding: 18px 24px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: none;
    }

    .modal-header-danger h4 {
        margin: 0;
        font-size: 18px;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .modal-header-danger h4 i {
        font-size: 20px;
    }

    .modal-close-btn {
        background: rgba(255, 255, 255, 0.2);
        border: none;
        color: #fff;
        width: 32px;
        height: 32px;
        border-radius: 8px;
        font-size: 20px;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.2s ease;
        line-height: 1;
    }

    .modal-close-btn:hover {
        background: rgba(255, 255, 255, 0.3);
        transform: rotate(90deg);
    }

    /* Modal Body */
    .modal-body-new {
        padding: 24px;
        overflow-y: auto;
        flex: 1;
    }

    /* Warning Box - Modern Style */
    .warning-box-new {
        background: linear-gradient(135deg, #fff5f5 0%, #fed7d7 100%);
        border: 1px solid #fc8181;
        border-radius: 12px;
        padding: 16px;
        display: flex;
        gap: 14px;
        margin-bottom: 20px;
    }

    .warning-icon {
        flex-shrink: 0;
        width: 44px;
        height: 44px;
        background: linear-gradient(135deg, #e53e3e 0%, #c53030 100%);
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #fff;
        font-size: 20px;
    }

    .warning-content {
        flex: 1;
    }

    .warning-content strong {
        color: #c53030;
        font-size: 15px;
        display: block;
        margin-bottom: 4px;
    }

    .warning-content p {
        margin: 0;
        color: #742a2a;
        font-size: 13px;
        line-height: 1.5;
    }

    /* Form Section */
    .form-section-new {
        background: #f8fafc;
        border: 1px solid #e2e8f0;
        border-radius: 12px;
        padding: 16px;
        margin-bottom: 16px;
    }

    .form-section-header-new {
        display: flex;
        align-items: center;
        gap: 8px;
        margin-bottom: 14px;
        padding-bottom: 10px;
        border-bottom: 1px solid #e2e8f0;
        color: #475569;
        font-weight: 600;
        font-size: 14px;
    }

    .form-section-header-new i {
        color: #64748b;
    }

    /* Delete List Grid */
    .delete-list-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 10px;
    }

    .delete-item {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 10px 12px;
        background: #fff;
        border: 1px solid #e2e8f0;
        border-radius: 8px;
        font-size: 12px;
        color: #475569;
        transition: all 0.2s ease;
    }

    .delete-item:hover {
        border-color: #fca5a5;
        background: #fef2f2;
    }

    .delete-item i {
        font-size: 14px;
        width: 16px;
        text-align: center;
    }

    .delete-item span {
        flex: 1;
        line-height: 1.3;
    }

    /* Form Group */
    .form-group-new {
        margin-bottom: 0;
    }

    .form-group-new label {
        display: block;
        font-size: 13px;
        font-weight: 500;
        color: #475569;
        margin-bottom: 8px;
    }

    .confirm-code {
        background: #fee2e2;
        color: #dc2626;
        padding: 2px 8px;
        border-radius: 4px;
        font-weight: 600;
        font-size: 13px;
    }

    .form-control-new {
        width: 100%;
        padding: 12px 14px;
        border: 2px solid #e2e8f0;
        border-radius: 10px;
        font-size: 14px;
        transition: all 0.2s ease;
        background: #fff;
        box-sizing: border-box;
    }

    .form-control-new:focus {
        outline: none;
        border-color: #3b82f6;
        box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
    }

    .form-control-new::placeholder {
        color: #94a3b8;
    }

    /* Progress Log */
    .progress-log-container {
        background: #1e293b;
        border-radius: 8px;
        padding: 14px;
        max-height: 180px;
        overflow-y: auto;
        font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
        font-size: 12px;
        line-height: 1.6;
    }

    .progress-log-container .log-item {
        display: flex;
        align-items: flex-start;
        gap: 8px;
        margin-bottom: 6px;
        color: #94a3b8;
    }

    .progress-log-container .log-item.success {
        color: #4ade80;
    }

    .progress-log-container .log-item.error {
        color: #f87171;
    }

    .progress-log-container .log-item i {
        margin-top: 2px;
    }

    /* Modal Footer */
    .modal-footer-new {
        padding: 16px 24px;
        background: #f8fafc;
        border-top: 1px solid #e2e8f0;
        display: flex;
        justify-content: flex-end;
        gap: 12px;
    }

    .btn-cancel-new {
        padding: 10px 20px;
        border: 1px solid #e2e8f0;
        background: #fff;
        color: #64748b;
        border-radius: 10px;
        font-size: 14px;
        font-weight: 500;
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 8px;
        transition: all 0.2s ease;
    }

    .btn-cancel-new:hover {
        background: #f1f5f9;
        border-color: #cbd5e1;
    }

    .btn-danger-new {
        padding: 10px 20px;
        border: none;
        background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
        color: #fff;
        border-radius: 10px;
        font-size: 14px;
        font-weight: 500;
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 8px;
        transition: all 0.2s ease;
        box-shadow: 0 2px 4px rgba(220, 38, 38, 0.3);
    }

    .btn-danger-new:hover {
        background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(220, 38, 38, 0.4);
    }

    .btn-danger-new:disabled {
        opacity: 0.7;
        cursor: not-allowed;
        transform: none;
    }

    /* Dark Mode for Uninstall Modal */
    .dark-mode .modal-container,
    body.dark-mode .modal-container {
        background: #1e293b;
    }

    .dark-mode .modal-body-new,
    body.dark-mode .modal-body-new {
        background: #1e293b;
    }

    .dark-mode .warning-box-new,
    body.dark-mode .warning-box-new {
        background: linear-gradient(135deg, #450a0a 0%, #7f1d1d 100%);
        border-color: #991b1b;
    }

    .dark-mode .warning-content strong,
    body.dark-mode .warning-content strong {
        color: #fca5a5;
    }

    .dark-mode .warning-content p,
    body.dark-mode .warning-content p {
        color: #fecaca;
    }

    .dark-mode .form-section-new,
    body.dark-mode .form-section-new {
        background: #0f172a;
        border-color: #334155;
    }

    .dark-mode .form-section-header-new,
    body.dark-mode .form-section-header-new {
        color: #e2e8f0;
        border-bottom-color: #334155;
    }

    .dark-mode .delete-item,
    body.dark-mode .delete-item {
        background: #1e293b;
        border-color: #334155;
        color: #cbd5e1;
    }

    .dark-mode .delete-item:hover,
    body.dark-mode .delete-item:hover {
        background: #7f1d1d;
        border-color: #991b1b;
    }

    .dark-mode .form-group-new label,
    body.dark-mode .form-group-new label {
        color: #e2e8f0;
    }

    .dark-mode .confirm-code,
    body.dark-mode .confirm-code {
        background: #7f1d1d;
        color: #fca5a5;
    }

    .dark-mode .form-control-new,
    body.dark-mode .form-control-new {
        background: #0f172a;
        border-color: #334155;
        color: #f1f5f9;
    }

    .dark-mode .form-control-new:focus,
    body.dark-mode .form-control-new:focus {
        border-color: #3b82f6;
    }

    .dark-mode .form-control-new::placeholder,
    body.dark-mode .form-control-new::placeholder {
        color: #64748b;
    }

    .dark-mode .modal-footer-new,
    body.dark-mode .modal-footer-new {
        background: #0f172a;
        border-top-color: #334155;
    }

    .dark-mode .btn-cancel-new,
    body.dark-mode .btn-cancel-new {
        background: #1e293b;
        border-color: #334155;
        color: #cbd5e1;
    }

    .dark-mode .btn-cancel-new:hover,
    body.dark-mode .btn-cancel-new:hover {
        background: #334155;
    }

    /* Responsive - Tablet */
    @media (max-width: 768px) {
        .modal-overlay {
            padding: 16px;
        }

        .modal-container {
            max-height: 85vh;
        }

        .modal-header-danger {
            padding: 14px 18px;
        }

        .modal-header-danger h4 {
            font-size: 16px;
        }

        .modal-body-new {
            padding: 18px;
        }

        .delete-list-grid {
            grid-template-columns: 1fr;
        }

        .delete-item {
            padding: 12px;
        }

        .modal-footer-new {
            padding: 14px 18px;
            flex-direction: column-reverse;
        }

        .btn-cancel-new,
        .btn-danger-new {
            width: 100%;
            justify-content: center;
        }
    }

    /* Responsive - Mobile */
    @media (max-width: 480px) {
        .modal-overlay {
            padding: 10px;
        }

        .modal-container {
            border-radius: 12px;
            max-height: 90vh;
        }

        .modal-header-danger {
            padding: 12px 16px;
        }

        .modal-header-danger h4 {
            font-size: 15px;
        }

        .modal-header-danger h4 i {
            font-size: 16px;
        }

        .modal-close-btn {
            width: 28px;
            height: 28px;
            font-size: 18px;
        }

        .modal-body-new {
            padding: 14px;
        }

        .warning-box-new {
            padding: 12px;
            gap: 12px;
        }

        .warning-icon {
            width: 36px;
            height: 36px;
            font-size: 16px;
        }

        .warning-content strong {
            font-size: 14px;
        }

        .warning-content p {
            font-size: 12px;
        }

        .form-section-new {
            padding: 12px;
            margin-bottom: 12px;
        }

        .form-section-header-new {
            font-size: 13px;
            margin-bottom: 12px;
            padding-bottom: 8px;
        }

        .delete-item {
            padding: 10px;
            font-size: 11px;
        }

        .delete-item i {
            font-size: 12px;
        }

        .form-group-new label {
            font-size: 12px;
        }

        .form-control-new {
            padding: 10px 12px;
            font-size: 13px;
        }

        .modal-footer-new {
            padding: 12px 14px;
            gap: 10px;
        }

        .btn-cancel-new,
        .btn-danger-new {
            padding: 10px 16px;
            font-size: 13px;
        }
    }

    /* SweetAlert z-index fix - harus di atas modal overlay */
    .swal2-container {
        z-index: 999999 !important;
    }

    .swal2-popup {
        z-index: 999999 !important;
    }

    /* Update Button */
    .action-update {
        border-left: 4px solid #3b82f6;
    }

    .action-update .action-icon {
        background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
        color: white;
    }

    .action-update:hover {
        border-color: #3b82f6;
        background: linear-gradient(to right, #fff 0%, rgba(59, 130, 246, 0.05) 100%);
    }

    .action-update.has-update {
        border-left-color: #10b981;
        animation: pulse-update 2s infinite;
    }

    .action-update.has-update .action-icon {
        background: linear-gradient(135deg, #10b981 0%, #059669 100%);
    }

    .action-update.has-update .action-desc {
        color: #10b981;
        font-weight: 600;
    }

    @keyframes pulse-update {
        0%, 100% { box-shadow: 0 0 0 0 rgba(16, 185, 129, 0.4); }
        50% { box-shadow: 0 0 0 8px rgba(16, 185, 129, 0); }
    }

    /* Update Modal Header */
    .modal-header-update {
        background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
        color: #fff;
        padding: 18px 24px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: none;
    }

    .modal-header-update h4 {
        margin: 0;
        font-size: 18px;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .update-modal {
        max-width: 480px;
    }

    /* Version Box */
    .update-version-box {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 20px;
        padding: 20px;
        background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
        border: 1px solid #93c5fd;
        border-radius: 12px;
        margin-bottom: 20px;
    }

    .version-current,
    .version-new {
        text-align: center;
    }

    .version-label {
        display: block;
        font-size: 11px;
        color: #64748b;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        margin-bottom: 4px;
    }

    .version-number {
        display: block;
        font-size: 24px;
        font-weight: 700;
        color: #1e40af;
    }

    .version-new .version-number {
        color: #059669;
    }

    .version-arrow {
        color: #94a3b8;
        font-size: 20px;
    }

    /* Changelog List */
    .changelog-list {
        max-height: 150px;
        overflow-y: auto;
    }

    .changelog-item {
        display: flex;
        align-items: flex-start;
        gap: 10px;
        padding: 10px 12px;
        background: #fff;
        border: 1px solid #e2e8f0;
        border-radius: 8px;
        margin-bottom: 8px;
        font-size: 13px;
        color: #475569;
    }

    .changelog-item:last-child {
        margin-bottom: 0;
    }

    .changelog-item i {
        color: #10b981;
        margin-top: 2px;
    }

    /* Update Button */
    .btn-update-new {
        padding: 10px 20px;
        border: none;
        background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
        color: #fff;
        border-radius: 10px;
        font-size: 14px;
        font-weight: 500;
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 8px;
        transition: all 0.2s ease;
        box-shadow: 0 2px 4px rgba(37, 99, 235, 0.3);
    }

    .btn-update-new:hover {
        background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(37, 99, 235, 0.4);
    }

    .btn-update-new:disabled {
        opacity: 0.7;
        cursor: not-allowed;
        transform: none;
    }

    /* Dark Mode Update */
    .dark-mode .update-version-box,
    body.dark-mode .update-version-box {
        background: linear-gradient(135deg, #1e3a5f 0%, #1e40af 100%);
        border-color: #3b82f6;
    }

    .dark-mode .version-label,
    body.dark-mode .version-label {
        color: #94a3b8;
    }

    .dark-mode .version-number,
    body.dark-mode .version-number {
        color: #93c5fd;
    }

    .dark-mode .version-new .version-number,
    body.dark-mode .version-new .version-number {
        color: #4ade80;
    }

    .dark-mode .changelog-item,
    body.dark-mode .changelog-item {
        background: #1e293b;
        border-color: #334155;
        color: #cbd5e1;
    }

    .dark-mode .modal-header-update,
    body.dark-mode .modal-header-update {
        background: linear-gradient(135deg, #1e3a5f 0%, #1e40af 100%);
    }

    .dark-mode .action-update.has-update .action-desc,
    body.dark-mode .action-update.has-update .action-desc {
        color: #4ade80;
    }

    /* Dark Mode Support */
    .dark-mode .quick-action-btn,
    body.dark-mode .quick-action-btn {
        background: #2c3139;
        border-color: transparent;
    }

    .dark-mode .quick-action-btn:hover,
    body.dark-mode .quick-action-btn:hover {
        background: #343a40;
    }

    .dark-mode .action-title,
    body.dark-mode .action-title {
        color: #fff;
    }

    .dark-mode .action-desc,
    body.dark-mode .action-desc {
        color: #adb5bd;
    }

    .dark-mode .action-arrow,
    body.dark-mode .action-arrow {
        color: #6c757d;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .action-desc {
            display: none;
        }

        .quick-action-btn {
            height: 50px;
            /* Kurangi dari 60px */
        }

        .action-icon {
            width: 50px;
            /* Kurangi dari 60px */
            height: 50px;
            /* Kurangi dari 60px */
            font-size: 18px;
            /* Kurangi dari 20px */
        }
    }

    /* Panel Table Dark Mode Fix */
    .dark-mode .panel-primary,
    body.dark-mode .panel-primary {
        background-color: #343a40;
        border-color: #495057;
    }

    .dark-mode .panel-primary>.panel-heading,
    body.dark-mode .panel-primary>.panel-heading {
        background-color: #2c3139;
        background-image: none;
        border-color: #495057;
        color: #fff;
    }

    .dark-mode .panel-hovered,
    body.dark-mode .panel-hovered {
        background-color: #343a40;
        border-color: #495057;
    }

    .dark-mode .panel-body,
    body.dark-mode .panel-body {
        background-color: #343a40;
        color: #e1e5ea;
    }

    /* Table Dark Mode Consistency */
    .dark-mode .table,
    body.dark-mode .table {
        background-color: #2c3139;
    }

    .dark-mode .table-bordered,
    body.dark-mode .table-bordered {
        border-color: #495057;
    }

    .dark-mode .table-bordered>thead>tr>th,
    .dark-mode .table-bordered>tbody>tr>td,
    body.dark-mode .table-bordered>thead>tr>th,
    body.dark-mode .table-bordered>tbody>tr>td {
        border-color: #495057;
    }

    .dark-mode .table-striped>tbody>tr:nth-of-type(odd),
    body.dark-mode .table-striped>tbody>tr:nth-of-type(odd) {
        background-color: rgba(0, 0, 0, 0.2);
    }

    .dark-mode .table-hover>tbody>tr:hover,
    body.dark-mode .table-hover>tbody>tr:hover {
        background-color: rgba(255, 255, 255, 0.05);
    }

    /* Remove blue tint from panel-primary in dark mode */
    .dark-mode .panel-primary,
    body.dark-mode .panel-primary {
        border-top: 3px solid #495057;
    }

    /* Badge in panel heading */
    .dark-mode .panel-heading .badge,
    body.dark-mode .panel-heading .badge {
        background-color: #495057;
        color: #fff;
    }

    /* Uniform Card Heights */
    .box.uniform-height {
        min-height: 250px;
        height: 250px;
    }

    .box.uniform-height .box-body {
        min-height: 200px;
        max-height: 200px;
        overflow-y: auto;
    }

    /* Compact Gauge Styling */
    .gauge-row-compact {
        margin-bottom: 10px !important;
    }

    .gauge-label-compact {
        margin-top: 5px;
    }

    .gauge-title {
        display: block;
        font-size: 11px;
        font-weight: 600;
        color: #666;
        margin-bottom: 2px;
    }

    .gauge-value-compact {
        display: block;
        font-size: 14px;
        font-weight: bold;
        color: #333;
    }

    .gauge-detail-compact {
        display: block;
        font-size: 9px;
        color: #999;
        margin-top: 1px;
    }

    /* Compact Footer */
    .server-info-footer-compact {
        display: flex;
        justify-content: space-around;
        padding-top: 8px;
        border-top: 1px solid #f0f0f0;
        margin-top: auto;
    }

    .info-item-compact {
        font-size: 11px;
        color: #666;
    }

    .info-item-compact i {
        font-size: 12px;
        margin-right: 3px;
    }

    /* Dark Mode Support */
    .dark-mode .gauge-title,
    body.dark-mode .gauge-title {
        color: #adb5bd;
    }

    .dark-mode .gauge-value-compact,
    body.dark-mode .gauge-value-compact {
        color: #fff;
    }

    .dark-mode .gauge-detail-compact,
    body.dark-mode .gauge-detail-compact {
        color: #8c959d;
    }

    .dark-mode .server-info-footer-compact,
    body.dark-mode .server-info-footer-compact {
        border-top-color: #495057;
    }

    .dark-mode .info-item-compact,
    body.dark-mode .info-item-compact {
        color: #adb5bd;
    }

    /* Responsive */
    @media (max-width: 991px) {
        .uniform-box {
            min-height: auto !important;
            max-height: none !important;
            height: auto !important;
            margin-bottom: 15px;
        }

        .uniform-box-body {
            min-height: 150px !important;
            max-height: none !important;
            height: auto !important;
        }
    }

    @media (max-width: 480px) {

        #cpuGauge,
        #memGauge,
        #diskGauge {
            width: 60px !important;
            height: 60px !important;
        }
    }

    /* Center content in boxes */
    .box-body.centered-content {
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
    }

    /* Responsive adjustments */
    @media (max-width: 991px) {
        .box.uniform-height {
            min-height: auto;
            height: auto;
            margin-bottom: 15px;
        }

        .box.uniform-height .box-body {
            min-height: 150px;
            max-height: none;
        }
    }

    /* Modal Styling - Clean & Modern */
    .modal-content {
        border: none;
        border-radius: 8px;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
    }

    .modal-header {
        border-radius: 8px 8px 0 0;
        padding: 15px 20px;
    }

    .modal-header.bg-primary {
        background: linear-gradient(135deg, #3c8dbc 0%, #357ca5 100%);
        color: white;
    }

    .modal-header .close {
        color: white;
        opacity: 0.8;
        font-size: 24px;
        font-weight: normal;
        text-shadow: none;
    }

    .modal-header .close:hover {
        opacity: 1;
    }

    .modal-title i {
        margin-right: 8px;
    }

    .modal-body {
        padding: 20px 30px;
    }

    .form-horizontal .control-label {
        text-align: right;
        padding-top: 7px;
        font-weight: 600;
        color: #555;
    }

    .form-horizontal .control-label i {
        margin-right: 5px;
    }

    /* Modal Input Styling */
    .modal-input {
        border-radius: 4px;
        border: 1px solid #d2d6de;
        padding: 8px 12px;
        font-size: 14px;
        transition: all 0.3s;
    }

    .modal-input:focus {
        border-color: #3c8dbc;
        box-shadow: 0 0 0 2px rgba(60, 141, 188, 0.1);
    }

    .help-block {
        margin-top: 5px;
        margin-bottom: 0;
        color: #737373;
        font-size: 12px;
        font-style: italic;
    }

    .modal-footer {
        padding: 15px 20px;
        border-top: 1px solid #f4f4f4;
        border-radius: 0 0 8px 8px;
    }

    /* Dark Mode Modal - Subtle & Professional */
    .dark-mode .modal-content,
    body.dark-mode .modal-content {
        background-color: #2d3238;
        color: #e1e5ea;
    }

    .dark-mode .modal-header.bg-primary,
    body.dark-mode .modal-header.bg-primary {
        background: linear-gradient(135deg, #2c5282 0%, #2a4e7c 100%);
    }

    .dark-mode .modal-header,
    body.dark-mode .modal-header {
        border-bottom: 1px solid #3e444c;
    }

    .dark-mode .modal-footer,
    body.dark-mode .modal-footer {
        background-color: #272b30;
        border-top: 1px solid #3e444c;
    }

    .dark-mode .form-horizontal .control-label,
    body.dark-mode .form-horizontal .control-label {
        color: #b8c7ce;
    }

    /* Dark Mode Input Fix - CRITICAL */
    .dark-mode .modal-input,
    body.dark-mode .modal-input {
        background-color: #1e2226 !important;
        border: 1px solid #3e444c !important;
        color: #ffffff !important;
    }

    .dark-mode .modal-input:focus,
    body.dark-mode .modal-input:focus {
        background-color: #252a2e !important;
        border-color: #4a90e2 !important;
        color: #ffffff !important;
        box-shadow: 0 0 0 2px rgba(74, 144, 226, 0.2) !important;
    }

    .dark-mode .modal-input::placeholder,
    body.dark-mode .modal-input::placeholder {
        color: #6c757d !important;
    }

    .dark-mode .help-block,
    body.dark-mode .help-block {
        color: #8b959e;
    }

    .dark-mode .input-group-btn .btn,
    body.dark-mode .input-group-btn .btn {
        background-color: #3e444c;
        border-color: #3e444c;
        color: #b8c7ce;
    }

    .dark-mode .input-group-btn .btn:hover,
    body.dark-mode .input-group-btn .btn:hover {
        background-color: #4e555e;
        border-color: #4e555e;
        color: #fff;
    }

    /* Buttons in Modal */
    .btn-flat {
        border-radius: 4px;
        box-shadow: none;
        border: 1px solid transparent;
        transition: all 0.3s;
    }

    .dark-mode .btn-default.btn-flat,
    body.dark-mode .btn-default.btn-flat {
        background-color: #3e444c;
        border-color: #3e444c;
        color: #b8c7ce;
    }

    .dark-mode .btn-default.btn-flat:hover,
    body.dark-mode .btn-default.btn-flat:hover {
        background-color: #4e555e;
        border-color: #4e555e;
        color: #fff;
    }

    .dark-mode .btn-primary.btn-flat,
    body.dark-mode .btn-primary.btn-flat {
        background-color: #4a90e2;
        border-color: #4a90e2;
    }

    .dark-mode .btn-primary.btn-flat:hover,
    body.dark-mode .btn-primary.btn-flat:hover {
        background-color: #357abd;
        border-color: #357abd;
    }

    /* Remove autofill white background in dark mode */
    .dark-mode input:-webkit-autofill,
    body.dark-mode input:-webkit-autofill {
        -webkit-box-shadow: 0 0 0 30px #1e2226 inset !important;
        -webkit-text-fill-color: #ffffff !important;
    }

    /* DARK MODE FOCUS FIX - MAXIMUM SPECIFICITY */
    body.dark-mode #serverModal input,
    body.dark-mode #serverModal input:focus,
    body.dark-mode #serverModal input:active,
    body.dark-mode #serverModal input:hover,
    body.dark-mode #serverModal .form-control,
    body.dark-mode #serverModal .form-control:focus,
    body.dark-mode #serverModal .modal-input,
    body.dark-mode #serverModal .modal-input:focus,
    .dark-mode #serverModal input,
    .dark-mode #serverModal input:focus,
    .dark-mode #serverModal .form-control,
    .dark-mode #serverModal .form-control:focus {
        background-color: #1e2226 !important;
        background-image: none !important;
        color: #ffffff !important;
        border-color: #4a90e2 !important;
        -webkit-box-shadow: none !important;
        -moz-box-shadow: none !important;
        box-shadow: none !important;
        outline: none !important;
        outline-width: 0 !important;
        outline-style: none !important;
    }

    /* Override Bootstrap focus glow */
    body.dark-mode #serverModal .form-control:focus,
    .dark-mode #serverModal .form-control:focus {
        border-color: #4a90e2 !important;
        outline: 0 !important;
        -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075), 0 0 0 2px rgba(74, 144, 226, 0.2) !important;
        box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075), 0 0 0 2px rgba(74, 144, 226, 0.2) !important;
    }

    /* Remove ALL focus highlights */
    body.dark-mode #serverModal *:focus {
        outline: none !important;
        outline-offset: 0 !important;
    }
</style>
<style>
    /* Local Server Stats Styling */
    .local-server-stats {
        padding: 5px;
    }

    .stat-row {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 8px 0;
        border-bottom: 1px solid #f0f0f0;
    }

    .stat-row.no-border {
        border-bottom: none;
    }

    .stat-label {
        font-weight: 600;
        color: #666;
        font-size: 13px;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .stat-label i {
        width: 16px;
        text-align: center;
        color: #00c0ef;
    }

    .stat-value {
        font-size: 13px;
        font-weight: bold;
        color: #333;
    }

    .stat-value small {
        font-weight: normal;
        color: #999;
        font-size: 11px;
    }

    .progress.progress-xs {
        height: 4px;
        margin-top: 5px;
        margin-bottom: 0;
    }

    /* Dark mode support */
    .dark-mode .stat-row,
    body.dark-mode .stat-row {
        border-bottom-color: #495057;
    }

    .dark-mode .stat-label,
    body.dark-mode .stat-label {
        color: #adb5bd;
    }

    .dark-mode .stat-value,
    body.dark-mode .stat-value {
        color: #fff;
    }

    .dark-mode .stat-value small,
    body.dark-mode .stat-value small {
        color: #8c959d;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .stat-value small {
            display: block;
            margin-top: 2px;
        }
    }

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

    /* Light mode form controls - EXPLICIT */
    .form-control {
        background-color: #fff !important;
        border: 1px solid #d2d6de !important;
        color: #555 !important;
    }

    .form-control:focus {
        background-color: #fff !important;
        border-color: #3c8dbc !important;
        color: #555 !important;
        box-shadow: none !important;
    }

    /* Select dropdowns light mode */
    select.form-control {
        background-color: #fff !important;
        color: #555 !important;
    }

    select.form-control:focus {
        background-color: #fff !important;
        color: #555 !important;
    }

    /* Dark mode form controls - KEEP WITH HIGHER SPECIFICITY */
    .dark-mode .form-control,
    body.dark-mode .form-control,
    [data-theme="dark"] .form-control {
        background-color: #34495e !important;
        border-color: #4a5f7a !important;
        color: #ecf0f1 !important;
    }

    /* FIX: Dark mode focus state */
    .dark-mode .form-control:focus,
    body.dark-mode .form-control:focus,
    [data-theme="dark"] .form-control:focus,
    .dark-mode input.form-control:focus,
    body.dark-mode input.form-control:focus {
        background-color: #2c3e50 !important;
        /* Darker background on focus */
        border-color: #5a8db8 !important;
        color: #ffffff !important;
        /* White text */
        box-shadow: 0 0 0 0.2rem rgba(90, 141, 184, 0.25) !important;
    }

    /* Specific fix for search input */
    .dark-mode #serverSearch:focus,
    body.dark-mode #serverSearch:focus,
    [data-theme="dark"] #serverSearch:focus {
        background-color: #2c3e50 !important;
        color: #ffffff !important;
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

    /* Light mode select styling - ADDED */
    select.form-control {
        background-color: #fff;
        color: #333;
        border: 1px solid #d2d6de;
    }

    select.form-control option {
        background-color: #fff;
        color: #333;
    }

    select.form-control option:hover,
    select.form-control option:focus,
    select.form-control option:checked {
        background-color: #3c8dbc;
        color: #fff;
    }

    /* Dark mode select styling - KEEP EXISTING */
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

    /* Statistics Cards Styling */
    .info-box {
        display: block;
        min-height: 90px;
        background: #fff;
        width: 100%;
        box-shadow: 0 1px 1px rgba(0, 0, 0, 0.1);
        border-radius: 2px;
        margin-bottom: 15px;
    }

    .info-box-icon {
        border-top-left-radius: 2px;
        border-top-right-radius: 0;
        border-bottom-right-radius: 0;
        border-bottom-left-radius: 2px;
        display: block;
        float: left;
        height: 90px;
        width: 90px;
        text-align: center;
        font-size: 45px;
        line-height: 90px;
        background: rgba(0, 0, 0, 0.2);
    }

    .info-box-icon i {
        color: #fff;
    }

    .info-box-content {
        padding: 5px 10px;
        margin-left: 90px;
    }

    .info-box-text {
        text-transform: uppercase;
        font-weight: bold;
        font-size: 14px;
    }

    .info-box-number {
        display: block;
        font-weight: bold;
        font-size: 18px;
    }

    .progress {
        height: 5px;
        margin: 5px 0;
        background: #f4f4f4;
    }

    .progress-bar {
        height: 5px;
    }

    .progress-description {
        font-size: 12px;
        color: #777;
    }

    /* Background colors */
    .bg-aqua {
        background-color: #00c0ef !important;
    }

    .bg-green {
        background-color: #00a65a !important;
    }

    .bg-red {
        background-color: #dd4b39 !important;
    }

    .bg-yellow {
        background-color: #f39c12 !important;
    }

    /* Box styling */
    .box {
        position: relative;
        border-radius: 3px;
        background: #ffffff;
        border-top: 3px solid #d2d6de;
        margin-bottom: 20px;
        width: 100%;
        box-shadow: 0 1px 1px rgba(0, 0, 0, 0.1);
    }

    .box-primary {
        border-top-color: #3c8dbc;
    }

    .box-info {
        border-top-color: #00c0ef;
    }

    .box-header {
        color: #444;
        display: block;
        padding: 10px;
        position: relative;
    }

    .box-header.with-border {
        border-bottom: 1px solid #f4f4f4;
    }

    .box-title {
        display: inline-block;
        font-size: 18px;
        margin: 0;
        line-height: 1;
    }

    .box-tools {
        position: absolute;
        right: 10px;
        top: 5px;
    }

    .box-body {
        padding: 10px;
    }

    /* Pulse animation for online status */
    @keyframes pulse {
        0% {
            box-shadow: 0 0 0 0 rgba(0, 166, 90, 0.7);
        }

        70% {
            box-shadow: 0 0 0 10px rgba(0, 166, 90, 0);
        }

        100% {
            box-shadow: 0 0 0 0 rgba(0, 166, 90, 0);
        }
    }

    .status-online {
        animation: pulse 2s infinite;
    }

    /* ADMINLTE DARK MODE SUPPORT */
    .dark-mode .info-box,
    body.dark-mode .info-box,
    [data-theme="dark"] .info-box {
        background-color: #343a40 !important;
        border: 1px solid #495057 !important;
        color: #fff !important;
    }

    .dark-mode .info-box-content,
    body.dark-mode .info-box-content,
    [data-theme="dark"] .info-box-content {
        color: #fff !important;
    }

    .dark-mode .info-box-text,
    body.dark-mode .info-box-text,
    [data-theme="dark"] .info-box-text {
        color: #adb5bd !important;
    }

    .dark-mode .progress-description,
    body.dark-mode .progress-description,
    [data-theme="dark"] .progress-description {
        color: #adb5bd !important;
    }

    .dark-mode .progress,
    body.dark-mode .progress,
    [data-theme="dark"] .progress {
        background: #495057 !important;
    }

    .dark-mode .box,
    body.dark-mode .box,
    [data-theme="dark"] .box {
        background-color: #343a40 !important;
        border-top-color: #6c757d !important;
        color: #fff !important;
    }

    .dark-mode .box-header.with-border,
    body.dark-mode .box-header.with-border,
    [data-theme="dark"] .box-header.with-border {
        border-bottom-color: #495057 !important;
    }

    .dark-mode .box-title,
    body.dark-mode .box-title,
    [data-theme="dark"] .box-title {
        color: #fff !important;
    }

    /* Enhanced Table Styles */
    .server-row {
        transition: all 0.3s ease;
    }

    .server-row:hover {
        background-color: rgba(0, 123, 255, 0.05);
    }

    .priority-server {
        background-color: rgba(255, 193, 7, 0.05) !important;
    }

    .priority-toggle {
        transition: all 0.3s ease;
    }

    .priority-toggle:hover {
        transform: scale(1.2);
    }

    /* Status Indicator with Pulse */
    .status-indicator {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        /* Jarak antara dot dan label */
        position: relative;
    }

    .pulse-dot {
        width: 10px;
        height: 10px;
        border-radius: 50%;
        display: inline-block;
        position: relative;
        margin-right: 5px;
        /* Fallback untuk browser lama */
    }

    .pulse-dot.pulse-green {
        background-color: #00a65a;
        animation: pulse-animation-green 2s infinite;
    }

    .pulse-dot.pulse-red {
        background-color: #dd4b39;
        animation: pulse-animation-red 2s infinite;
    }

    .pulse-dot-small {
        width: 8px;
        height: 8px;
        background-color: #00a65a;
        border-radius: 50%;
        display: inline-block;
        animation: pulse-animation-green 2s infinite;
    }

    @keyframes pulse-animation-green {
        0% {
            box-shadow: 0 0 0 0 rgba(0, 166, 90, 0.7);
        }

        70% {
            box-shadow: 0 0 0 10px rgba(0, 166, 90, 0);
        }

        100% {
            box-shadow: 0 0 0 0 rgba(0, 166, 90, 0);
        }
    }

    @keyframes pulse-animation-red {
        0% {
            box-shadow: 0 0 0 0 rgba(221, 75, 57, 0.7);
        }

        70% {
            box-shadow: 0 0 0 10px rgba(221, 75, 57, 0);
        }

        100% {
            box-shadow: 0 0 0 0 rgba(221, 75, 57, 0);
        }
    }

    /* Remove offline-dot as we don't need it anymore */
    .offline-dot {
        width: 10px;
        height: 10px;
        background-color: #dd4b39;
        border-radius: 50%;
        display: inline-block;
        animation: pulse-animation-red 2s infinite;
    }

    /* Device Count Badge */
    .device-count-badge {
        font-size: 14px;
        padding: 4px 8px;
        min-width: 30px;
    }

    /* Response Time Styling */
    .response-time {
        font-weight: bold;
        font-size: 12px;
    }

    /* DARK MODE SUPPORT - Enhanced Table */
    .dark-mode .server-row:hover,
    body.dark-mode .server-row:hover,
    [data-theme="dark"] .server-row:hover {
        background-color: rgba(255, 255, 255, 0.05) !important;
    }

    .dark-mode .priority-server,
    body.dark-mode .priority-server,
    [data-theme="dark"] .priority-server {
        background-color: rgba(255, 193, 7, 0.1) !important;
    }

    /* Search and Filter Styles */
    .collapsed-box .box-body {
        display: none;
    }

    .box-tools {
        position: absolute;
        right: 10px;
        top: 8px;
    }

    .input-group-addon {
        background-color: #f4f4f4;
        border: 1px solid #d2d6de;
    }

    /* Activity Feed Styles */
    .activity-list {
        padding: 0;
    }

    .activity-item {
        padding: 8px 0;
        border-bottom: 1px solid #f0f0f0;
        display: flex;
        align-items: center;
        gap: 10px;
        transition: background 0.3s;
    }

    .activity-item:hover {
        background: rgba(0, 0, 0, 0.02);
    }

    .activity-item:last-child {
        border-bottom: none;
    }

    .activity-item i {
        width: 20px;
        text-align: center;
    }

    .activity-text {
        flex: 1;
        font-size: 13px;
    }

    .activity-time {
        font-size: 11px;
        color: #999;
        white-space: nowrap;
    }

    /* Filter Results Badge */
    .filter-results-badge {
        position: fixed;
        top: 70px;
        right: 20px;
        z-index: 1000;
        background: #3c8dbc;
        color: white;
        padding: 10px 15px;
        border-radius: 4px;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        display: none;
    }

    .filter-results-badge.show {
        display: block;
        animation: slideIn 0.3s ease;
    }

    @keyframes slideIn {
        from {
            transform: translateX(100%);
            opacity: 0;
        }

        to {
            transform: translateX(0);
            opacity: 1;
        }
    }

    /* Health Legend */
    .health-legend {
        margin-top: 10px;
        text-align: center;
    }

    .health-legend i {
        margin: 0 5px;
    }

    /* DARK MODE SUPPORT - Search, Filter & Activity */
    .dark-mode .input-group-addon,
    body.dark-mode .input-group-addon,
    [data-theme="dark"] .input-group-addon {
        background-color: #495057 !important;
        border-color: #6c757d !important;
        color: #fff !important;
    }

    .dark-mode .activity-item,
    body.dark-mode .activity-item,
    [data-theme="dark"] .activity-item {
        border-bottom-color: #495057 !important;
    }

    .dark-mode .activity-item:hover,
    body.dark-mode .activity-item:hover,
    [data-theme="dark"] .activity-item:hover {
        background: rgba(255, 255, 255, 0.05) !important;
    }

    .dark-mode .activity-text,
    body.dark-mode .activity-text,
    [data-theme="dark"] .activity-text {
        color: #fff !important;
    }

    .dark-mode .activity-time,
    body.dark-mode .activity-time,
    [data-theme="dark"] .activity-time {
        color: #adb5bd !important;
    }

    .dark-mode .filter-results-badge,
    body.dark-mode .filter-results-badge,
    [data-theme="dark"] .filter-results-badge {
        background: #495057 !important;
    }

    /* Loading Overlay */
    #loading-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.7);
        z-index: 9999;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .loading-content {
        text-align: center;
        color: white;
    }

    .spinner {
        border: 4px solid rgba(255, 255, 255, 0.3);
        border-top: 4px solid #fff;
        border-radius: 50%;
        width: 50px;
        height: 50px;
        animation: spin 1s linear infinite;
        margin: 0 auto 20px;
    }

    @keyframes spin {
        0% {
            transform: rotate(0deg);
        }

        100% {
            transform: rotate(360deg);
        }
    }

    .loading-text {
        font-size: 18px;
        font-weight: bold;
    }

    /* Notification Styles */
    #notification-container {
        position: fixed;
        top: 60px;
        right: 20px;
        z-index: 9998;
        max-width: 350px;
    }

    .notification {
        background: #fff;
        border-left: 4px solid #3c8dbc;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        margin-bottom: 10px;
        padding: 15px;
        border-radius: 4px;
        animation: slideInRight 0.3s ease;
        position: relative;
    }

    .notification.success {
        border-left-color: #00a65a;
    }

    .notification.error {
        border-left-color: #dd4b39;
    }

    .notification.warning {
        border-left-color: #f39c12;
    }

    .notification.info {
        border-left-color: #00c0ef;
    }

    @keyframes slideInRight {
        from {
            transform: translateX(100%);
            opacity: 0;
        }

        to {
            transform: translateX(0);
            opacity: 1;
        }
    }

    .notification-close {
        position: absolute;
        top: 5px;
        right: 10px;
        cursor: pointer;
        color: #999;
    }

    .notification-close:hover {
        color: #333;
    }

    /* Performance Optimizations */
    .table-responsive {
        overflow-x: auto;
        -webkit-overflow-scrolling: touch;
    }

    /* Smooth transitions */
    * {
        transition: background-color 0.3s ease, color 0.3s ease;
    }

    /* Mobile Optimizations */
    @media (max-width: 768px) {
        .info-box {
            margin-bottom: 10px;
        }

        .box {
            margin-bottom: 15px;
        }

        .quick-stats-bar {
            justify-content: center;
        }

        .stat-item {
            flex: 0 0 45%;
            margin-bottom: 10px;
        }

        #notification-container {
            left: 10px;
            right: 10px;
            max-width: none;
        }

        .filter-results-badge {
            top: auto;
            bottom: 60px;
            right: 10px;
        }

        .table-responsive {
            border: none;
        }

        /* Hide less important columns on mobile */
        @media (max-width: 576px) {
            .hidden-xs-custom {
                display: none !important;
            }
        }
    }

    /* Print Styles */
    @media print {

        .btn,
        .box-tools,
        #notification-container {
            display: none !important;
        }

        .box {
            border: 1px solid #000 !important;
            page-break-inside: avoid;
        }
    }

    /* DARK MODE FINAL POLISH */
    .dark-mode #loading-overlay,
    body.dark-mode #loading-overlay,
    [data-theme="dark"] #loading-overlay {
        background: rgba(0, 0, 0, 0.9) !important;
    }

    .dark-mode .notification,
    body.dark-mode .notification,
    [data-theme="dark"] .notification {
        background: #343a40 !important;
        color: #fff !important;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.5) !important;
    }

    /* Animation Classes */
    .fade-in {
        animation: fadeIn 0.5s ease;
    }

    @keyframes fadeIn {
        from {
            opacity: 0;
        }

        to {
            opacity: 1;
        }
    }

    .shake {
        animation: shake 0.5s;
    }

    @keyframes shake {

        0%,
        100% {
            transform: translateX(0);
        }

        25% {
            transform: translateX(-10px);
        }

        75% {
            transform: translateX(10px);
        }
    }

    /* FINAL DARK MODE FOCUS OVERRIDE - Must be at the end */
    .dark-mode input:focus,
    .dark-mode textarea:focus,
    .dark-mode select:focus,
    body.dark-mode input:focus,
    body.dark-mode textarea:focus,
    body.dark-mode select:focus,
    [data-theme="dark"] input:focus,
    [data-theme="dark"] textarea:focus,
    [data-theme="dark"] select:focus {
        background-color: #2c3e50 !important;
        color: #ffffff !important;
        border-color: #5a8db8 !important;
    }

    /* Prevent white background on autofill in dark mode */
    .dark-mode input:-webkit-autofill,
    .dark-mode input:-webkit-autofill:hover,
    .dark-mode input:-webkit-autofill:focus,
    .dark-mode input:-webkit-autofill:active,
    body.dark-mode input:-webkit-autofill,
    body.dark-mode input:-webkit-autofill:hover,
    body.dark-mode input:-webkit-autofill:focus,
    body.dark-mode input:-webkit-autofill:active {
        -webkit-box-shadow: 0 0 0 30px #2c3e50 inset !important;
        -webkit-text-fill-color: #ffffff !important;
        box-shadow: 0 0 0 30px #2c3e50 inset !important;
    }

    /* Device Mapping Modal Clean Styling */
    .mapping-info-header {
        background: #f8f9fa;
        border: 1px solid #e9ecef;
        border-radius: 4px;
        padding: 12px 15px;
        margin-bottom: 20px;
    }

    .mapping-info-header p {
        margin: 0;
        font-size: 14px;
        line-height: 1.4;
    }

    .mapping-info-header i {
        margin-right: 8px;
    }

    /* Dark mode support */
    .dark-mode .mapping-info-header,
    body.dark-mode .mapping-info-header {
        background: #2c3139;
        border-color: #495057;
        color: #e1e5ea;
    }

    .dark-mode .mapping-info-header p,
    body.dark-mode .mapping-info-header p {
        color: #e1e5ea;
    }

    /* Mapping Controls Styling */
    .mapping-controls {
        margin-bottom: 20px;
        padding-bottom: 15px;
        border-bottom: 1px solid #e9ecef;
    }

    .mapping-controls .form-group {
        margin-bottom: 0;
    }

    .mapping-pagination {
        margin-top: 15px;
        padding-top: 15px;
        border-top: 1px solid #e9ecef;
    }

    .mapping-pagination .pagination {
        margin: 0;
        float: right;
    }

    .mapping-pagination .dataTables_info {
        padding-top: 8px;
    }

    /* Responsive Table */
    @media (max-width: 767px) {
        .mapping-controls .col-md-2 {
            margin-top: 10px;
        }

        .mapping-pagination .pagination {
            float: none;
            text-align: center;
        }

        .mapping-pagination .dataTables_info {
            text-align: center;
            margin-bottom: 10px;
        }
    }

    /* Dark mode */
    .dark-mode .mapping-controls,
    .dark-mode .mapping-pagination,
    body.dark-mode .mapping-controls,
    body.dark-mode .mapping-pagination {
        border-color: #495057;
    }

    /* Light Mode Modal Styling - Enhanced */
    #deviceMappingModal .modal-content {
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        border: 1px solid #e9ecef;
    }

    #deviceMappingModal .modal-header {
        background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        border-bottom: 1px solid #dee2e6;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
    }

    #deviceMappingModal .modal-body {
        background: #ffffff;
        border-left: 1px solid #f1f3f4;
        border-right: 1px solid #f1f3f4;
    }

    #deviceMappingModal .modal-footer {
        background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        border-top: 1px solid #dee2e6;
        box-shadow: 0 -2px 4px rgba(0, 0, 0, 0.05);
    }

    /* Light Mode Controls Styling */
    .mapping-controls {
        background: #f8f9fa;
        border: 1px solid #e9ecef;
        border-radius: 6px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        padding: 15px;
        margin-bottom: 20px;
    }

    /* Light Mode Table Styling */
    #deviceMappingModal .table {
        background: #ffffff;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        border: 1px solid #e9ecef;
        border-radius: 6px;
        overflow: hidden;
    }

    #deviceMappingModal .table thead {
        background: linear-gradient(135deg, #f1f3f4 0%, #e9ecef 100%);
        border-bottom: 2px solid #dee2e6;
    }

    #deviceMappingModal .table thead th {
        border-bottom: 2px solid #dee2e6;
        border-right: 1px solid #e9ecef;
        font-weight: 600;
        color: #495057;
        text-transform: uppercase;
        font-size: 11px;
        letter-spacing: 0.5px;
    }

    #deviceMappingModal .table thead th:last-child {
        border-right: none;
    }

    #deviceMappingModal .table tbody td {
        border-right: 1px solid #f1f3f4;
        vertical-align: middle;
    }

    #deviceMappingModal .table tbody td:last-child {
        border-right: none;
    }

    #deviceMappingModal .table tbody tr {
        border-bottom: 1px solid #dee2e6;
        transition: all 0.2s ease;
    }

    #deviceMappingModal .table tbody tr:hover {
        background: #f8f9fa;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
    }

    #deviceMappingModal .table tbody tr:last-child {
        border-bottom: none;
    }

    /* Light Mode Form Controls */
    #deviceMappingModal .form-control {
        border: 1px solid #ced4da;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
        transition: all 0.2s ease;
    }

    #deviceMappingModal .form-control:focus {
        border-color: #4a90e2;
        box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1), 0 2px 4px rgba(0, 0, 0, 0.1);
    }

    #deviceMappingModal .input-group-addon {
        background: linear-gradient(135deg, #f1f3f4 0%, #e9ecef 100%);
        border: 1px solid #ced4da;
        color: #6c757d;
    }

    /* Light Mode Pagination */
    .mapping-pagination {
        background: #f8f9fa;
        border: 1px solid #e9ecef;
        border-radius: 6px;
        padding: 15px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
    }

    .mapping-pagination .pagination>li>a {
        border: 1px solid #dee2e6;
        background: #ffffff;
        box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
        transition: all 0.2s ease;
    }

    .mapping-pagination .pagination>li>a:hover {
        background: #e9ecef;
        transform: translateY(-1px);
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }

    .mapping-pagination .pagination>.active>a {
        background: #4a90e2;
        border-color: #4a90e2;
        box-shadow: 0 2px 4px rgba(74, 144, 226, 0.3);
    }

    /* Light Mode Buttons */
    #deviceMappingModal .btn {
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        border: 1px solid transparent;
        transition: all 0.2s ease;
    }

    #deviceMappingModal .btn:hover {
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
    }

    #deviceMappingModal .btn-danger {
        background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
    }

    #deviceMappingModal .btn-primary {
        background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
    }

    #deviceMappingModal .btn-default {
        background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        border-color: #ced4da;
    }

    /* Light Mode Labels and Badges */
    #deviceMappingModal .label {
        box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
    }

    /* Dark Mode Modal Input Fix - CRITICAL */
    .dark-mode #deviceMappingModal input,
    .dark-mode #deviceMappingModal select,
    .dark-mode #deviceMappingModal .form-control,
    body.dark-mode #deviceMappingModal input,
    body.dark-mode #deviceMappingModal select,
    body.dark-mode #deviceMappingModal .form-control {
        background-color: #2c3139 !important;
        border: 1px solid #495057 !important;
        color: #ffffff !important;
    }

    /* Dark Mode Focus State */
    .dark-mode #deviceMappingModal input:focus,
    .dark-mode #deviceMappingModal select:focus,
    .dark-mode #deviceMappingModal .form-control:focus,
    body.dark-mode #deviceMappingModal input:focus,
    body.dark-mode #deviceMappingModal select:focus,
    body.dark-mode #deviceMappingModal .form-control:focus {
        background-color: #1e2226 !important;
        border-color: #4a90e2 !important;
        color: #ffffff !important;
        box-shadow: 0 0 0 2px rgba(74, 144, 226, 0.2) !important;
        outline: none !important;
    }

    /* Dark Mode Placeholder */
    .dark-mode #deviceMappingModal input::placeholder,
    body.dark-mode #deviceMappingModal input::placeholder {
        color: #6c757d !important;
        opacity: 1;
    }

    /* Dark Mode Select Options */
    .dark-mode #deviceMappingModal select option,
    body.dark-mode #deviceMappingModal select option {
        background-color: #2c3139 !important;
        color: #ffffff !important;
    }

    /* Dark Mode Input Group Addon */
    .dark-mode #deviceMappingModal .input-group-addon,
    body.dark-mode #deviceMappingModal .input-group-addon {
        background-color: #495057 !important;
        border-color: #495057 !important;
        color: #ffffff !important;
    }

    /* Override any conflicting styles */
    body.dark-mode #mappingSearch,
    body.dark-mode #serverFilter,
    .dark-mode #mappingSearch,
    .dark-mode #serverFilter {
        background-color: #2c3139 !important;
        color: #ffffff !important;
        border-color: #495057 !important;
    }

    body.dark-mode #mappingSearch:focus,
    body.dark-mode #serverFilter:focus,
    .dark-mode #mappingSearch:focus,
    .dark-mode #serverFilter:focus {
        background-color: #1e2226 !important;
        color: #ffffff !important;
        border-color: #4a90e2 !important;
        box-shadow: 0 0 0 2px rgba(74, 144, 226, 0.2) !important;
    }

    /* Remove autofill white background */
    .dark-mode #deviceMappingModal input:-webkit-autofill,
    body.dark-mode #deviceMappingModal input:-webkit-autofill {
        -webkit-box-shadow: 0 0 0 30px #2c3139 inset !important;
        -webkit-text-fill-color: #ffffff !important;
    }

    /* Mobile Responsive Modal - CRITICAL FIX */
    @media (max-width: 767px) {
        .modal-responsive {
            width: 95% !important;
            max-width: none !important;
            margin: 10px auto !important;
        }

        .modal-responsive .modal-content {
            margin: 0 !important;
            border-radius: 8px !important;
        }

        .modal-responsive .modal-body {
            padding: 15px !important;
            max-height: calc(100vh - 120px) !important;
            overflow-y: auto !important;
        }

        /* Mobile Controls */
        .mapping-controls {
            margin-bottom: 15px !important;
        }

        .mapping-controls .col-md-6,
        .mapping-controls .col-md-4,
        .mapping-controls .col-md-2 {
            width: 100% !important;
            float: none !important;
            margin-bottom: 10px !important;
        }

        .mapping-controls .col-md-2:last-child {
            margin-bottom: 0 !important;
        }

        /* Mobile Table */
        .table-responsive {
            border: none !important;
            margin-bottom: 10px !important;
        }

        .table {
            margin-bottom: 0 !important;
            font-size: 12px !important;
        }

        /* Hide desktop columns on mobile */
        .table thead th:nth-child(1),
        .table tbody td:nth-child(1) {
            display: none !important;
        }

        /* Mobile table spacing - FORCE LAYOUT */
        .table td,
        .table th {
            padding: 8px 6px !important;
            vertical-align: middle !important;
            border-right: 8px solid transparent !important;
        }

        /* Mobile User column - FIXED WIDTH */
        .table tbody tr td:nth-child(2) {
            width: 45% !important;
            max-width: 45% !important;
            padding-right: 15px !important;
            box-sizing: border-box !important;
        }

        /* Mobile Device column */
        .table tbody tr td:nth-child(3) {
            width: 35% !important;
            padding-left: 10px !important;
        }

        /* Mobile Action column */
        .table tbody tr td:nth-child(4) {
            width: 20% !important;
            text-align: center !important;
        }

        /* Mobile Action column */
        .table tbody tr td:last-child {
            width: 20% !important;
            text-align: center !important;
        }

        /* Mobile button */
        .btn-xs {
            padding: 4px 8px !important;
            font-size: 11px !important;
        }

        /* Mobile pagination */
        .mapping-pagination {
            margin-top: 10px !important;
            padding-top: 10px !important;
        }

        .mapping-pagination .row>div {
            width: 100% !important;
            text-align: center !important;
            margin-bottom: 10px !important;
        }

        .mapping-pagination .pagination {
            display: inline-block !important;
            float: none !important;
        }

        .mapping-pagination .pagination>li>a {
            padding: 5px 8px !important;
            font-size: 12px !important;
        }

        /* Mobile modal footer */
        .modal-footer {
            padding: 10px 15px !important;
            text-align: center !important;
        }

        .modal-footer .btn {
            margin: 2px !important;
            font-size: 12px !important;
            padding: 6px 12px !important;
        }

        /* Mobile form controls */
        .form-control {
            font-size: 14px !important;
            height: 36px !important;
        }

        .input-group-addon {
            padding: 8px 10px !important;
        }

        /* Mobile label spacing */
        .label {
            font-size: 10px !important;
            padding: 2px 4px !important;
        }

        /* Mobile text sizing */
        small {
            font-size: 10px !important;
        }

        .text-muted {
            color: #999 !important;
        }
    }

    /* Extra small devices */
    @media (max-width: 480px) {
        .modal-responsive {
            width: 98% !important;
            margin: 5px auto !important;
        }

        .modal-responsive .modal-body {
            padding: 10px !important;
        }

        .table {
            font-size: 11px !important;
        }

        .table td,
        .table th {
            padding: 6px 2px !important;
        }

        .form-control {
            font-size: 12px !important;
            height: 32px !important;
        }

        .btn {
            font-size: 11px !important;
            padding: 4px 8px !important;
        }

        .modal-title {
            font-size: 16px !important;
        }
    }

    /* Landscape orientation fix */
    @media (max-width: 767px) and (orientation: landscape) {
        .modal-responsive .modal-body {
            max-height: calc(100vh - 80px) !important;
        }
    }

    /* Mobile User Info Layout - IMPROVED */
    @media (max-width: 767px) {
        .mobile-user-info {
            padding: 2px 0;
        }

        .mobile-username {
            display: flex;
            align-items: center;
            width: 100%;
            gap: 4px;
            max-width: calc(100% - 15px);
            padding-right: 10px;
            box-sizing: border-box;
        }

        .mobile-username strong {
            flex: 1;
            min-width: 0;
            word-break: break-word;
            line-height: 1.2;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .mobile-server-badge {
            background: #6c757d;
            color: white;
            padding: 2px 5px;
            border-radius: 8px;
            font-size: 8px;
            font-weight: 600;
            text-transform: uppercase;
            white-space: nowrap;
            flex-shrink: 0;
            line-height: 1;
            min-width: fit-content;
            align-self: center;
        }

        .mobile-username strong {
            flex: 1;
            min-width: 0;
            word-break: break-word;
            line-height: 1.2;
        }

        /* Dark mode mobile badge */
        .dark-mode .mobile-server-badge,
        body.dark-mode .mobile-server-badge {
            background: #495057;
            color: #e9ecef;
        }
    }

    /* Extra compact for very small screens */
    @media (max-width: 480px) {
        .mobile-username {
            gap: 4px !important;
        }

        .mobile-server-badge {
            font-size: 7px !important;
            padding: 1px 3px !important;
            border-radius: 6px !important;
        }

        .mobile-username strong {
            font-size: 13px !important;
        }
    }

    /* Specific filter inputs dark mode focus */
    .dark-mode #serverSearch:focus,
    .dark-mode #statusFilter:focus,
    .dark-mode #protocolFilter:focus,
    .dark-mode #priorityFilter:focus,
    body.dark-mode #serverSearch:focus,
    body.dark-mode #statusFilter:focus,
    body.dark-mode #protocolFilter:focus,
    body.dark-mode #priorityFilter:focus {
        background-color: #2c3e50 !important;
        color: #ffffff !important;
        border-color: #5a8db8 !important;
    }

    /* Placeholder color in dark mode */
    .dark-mode input::placeholder,
    body.dark-mode input::placeholder {
        color: #7f8c8d !important;
        opacity: 1;
    }

    /* Selection/highlight color in dark mode */
    .dark-mode input::selection,
    .dark-mode textarea::selection,
    body.dark-mode input::selection,
    body.dark-mode textarea::selection {
        background-color: #5a8db8 !important;
        color: #ffffff !important;
    }

    .dark-mode input::-moz-selection,
    .dark-mode textarea::-moz-selection,
    body.dark-mode input::-moz-selection,
    body.dark-mode textarea::-moz-selection {
        background-color: #5a8db8 !important;
        color: #ffffff !important;
    }

    /* COMPLETE DARK MODE SUPPORT FOR DEVICE MAPPING MODAL */
    /* Modal Container and Backdrop */
    .dark-mode #deviceMappingModal,
    body.dark-mode #deviceMappingModal {
        background-color: rgba(0, 0, 0, 0.8) !important;
    }

    .dark-mode #deviceMappingModal .modal-dialog,
    body.dark-mode #deviceMappingModal .modal-dialog {
        background-color: transparent !important;
    }

    /* Modal Content - Main Container */
    .dark-mode #deviceMappingModal .modal-content,
    body.dark-mode #deviceMappingModal .modal-content {
        background-color: #2c3139 !important;
        color: #e1e5ea !important;
        border: 1px solid #495057 !important;
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.5) !important;
    }

    /* Modal Header - Complete Fix */
    .dark-mode #deviceMappingModal .modal-header,
    body.dark-mode #deviceMappingModal .modal-header {
        background-color: #343a40 !important;
        background-image: none !important;
        border-bottom: 1px solid #495057 !important;
        color: #ffffff !important;
        box-shadow: none !important;
    }

    .dark-mode #deviceMappingModal .modal-title,
    body.dark-mode #deviceMappingModal .modal-title {
        color: #ffffff !important;
    }

    .dark-mode #deviceMappingModal .close,
    body.dark-mode #deviceMappingModal .close {
        color: #ffffff !important;
        opacity: 0.8 !important;
        text-shadow: none !important;
    }

    .dark-mode #deviceMappingModal .close:hover,
    body.dark-mode #deviceMappingModal .close:hover {
        color: #ffffff !important;
        opacity: 1 !important;
    }

    /* Modal Body - Complete Fix */
    .dark-mode #deviceMappingModal .modal-body,
    body.dark-mode #deviceMappingModal .modal-body {
        background-color: #2c3139 !important;
        color: #e1e5ea !important;
        border: none !important;
    }

    /* Modal Footer - Complete Fix */
    .dark-mode #deviceMappingModal .modal-footer,
    body.dark-mode #deviceMappingModal .modal-footer {
        background-color: #343a40 !important;
        background-image: none !important;
        border-top: 1px solid #495057 !important;
        color: #e1e5ea !important;
        box-shadow: none !important;
    }

    /* Form Controls - Search and Filter */
    .dark-mode #deviceMappingModal .form-control,
    .dark-mode #deviceMappingModal input[type="text"],
    .dark-mode #deviceMappingModal select,
    body.dark-mode #deviceMappingModal .form-control,
    body.dark-mode #deviceMappingModal input[type="text"],
    body.dark-mode #deviceMappingModal select {
        background-color: #343a40 !important;
        border: 1px solid #495057 !important;
        color: #ffffff !important;
        box-shadow: none !important;
    }

    .dark-mode #deviceMappingModal .form-control:focus,
    .dark-mode #deviceMappingModal input[type="text"]:focus,
    .dark-mode #deviceMappingModal select:focus,
    body.dark-mode #deviceMappingModal .form-control:focus,
    body.dark-mode #deviceMappingModal input[type="text"]:focus,
    body.dark-mode #deviceMappingModal select:focus {
        background-color: #2c3139 !important;
        border-color: #007bff !important;
        color: #ffffff !important;
        box-shadow: 0 0 0 2px rgba(0, 123, 255, 0.2) !important;
        outline: none !important;
    }

    .dark-mode #deviceMappingModal .form-control::placeholder,
    .dark-mode #deviceMappingModal input::placeholder,
    body.dark-mode #deviceMappingModal .form-control::placeholder,
    body.dark-mode #deviceMappingModal input::placeholder {
        color: #6c757d !important;
        opacity: 1 !important;
    }

    /* Select Options */
    .dark-mode #deviceMappingModal select option,
    body.dark-mode #deviceMappingModal select option {
        background-color: #343a40 !important;
        color: #ffffff !important;
    }

    /* Input Group Addon */
    .dark-mode #deviceMappingModal .input-group-addon,
    body.dark-mode #deviceMappingModal .input-group-addon {
        background-color: #495057 !important;
        border: 1px solid #495057 !important;
        color: #ffffff !important;
    }

    /* Controls Container */
    .dark-mode #deviceMappingModal .mapping-controls,
    body.dark-mode #deviceMappingModal .mapping-controls {
        background-color: #343a40 !important;
        border: 1px solid #495057 !important;
        color: #e1e5ea !important;
        box-shadow: none !important;
    }

    /* Table - Complete Styling */
    .dark-mode #deviceMappingModal .table-responsive,
    body.dark-mode #deviceMappingModal .table-responsive {
        background-color: #343a40 !important;
        border: 1px solid #495057 !important;
        border-radius: 6px !important;
        overflow: hidden !important;
    }

    .dark-mode #deviceMappingModal .table,
    body.dark-mode #deviceMappingModal .table {
        background-color: #343a40 !important;
        color: #e1e5ea !important;
        margin-bottom: 0 !important;
        border: none !important;
    }

    /* Table Header */
    .dark-mode #deviceMappingModal .table thead,
    body.dark-mode #deviceMappingModal .table thead {
        background-color: #2c3139 !important;
        background-image: none !important;
        border-bottom: 2px solid #495057 !important;
    }

    .dark-mode #deviceMappingModal .table thead th,
    body.dark-mode #deviceMappingModal .table thead th {
        background-color: #2c3139 !important;
        background-image: none !important;
        color: #ffffff !important;
        border-bottom: 2px solid #495057 !important;
        border-right: 1px solid #495057 !important;
        border-top: none !important;
        border-left: none !important;
        font-weight: 600 !important;
        text-transform: uppercase !important;
        font-size: 11px !important;
    }

    .dark-mode #deviceMappingModal .table thead th:last-child,
    body.dark-mode #deviceMappingModal .table thead th:last-child {
        border-right: none !important;
    }

    /* Table Body */
    .dark-mode #deviceMappingModal .table tbody td,
    body.dark-mode #deviceMappingModal .table tbody td {
        background-color: #343a40 !important;
        color: #e1e5ea !important;
        border-right: 1px solid #495057 !important;
        border-bottom: 1px solid #495057 !important;
        border-top: none !important;
        border-left: none !important;
        vertical-align: middle !important;
    }

    .dark-mode #deviceMappingModal .table tbody td:last-child,
    body.dark-mode #deviceMappingModal .table tbody td:last-child {
        border-right: none !important;
    }

    .dark-mode #deviceMappingModal .table tbody tr,
    body.dark-mode #deviceMappingModal .table tbody tr {
        border-bottom: 1px solid #495057 !important;
        transition: all 0.2s ease !important;
    }

    .dark-mode #deviceMappingModal .table tbody tr:hover,
    body.dark-mode #deviceMappingModal .table tbody tr:hover {
        background-color: #495057 !important;
        box-shadow: none !important;
    }

    .dark-mode #deviceMappingModal .table tbody tr:hover td,
    body.dark-mode #deviceMappingModal .table tbody tr:hover td {
        background-color: #495057 !important;
    }

    .dark-mode #deviceMappingModal .table tbody tr:last-child,
    body.dark-mode #deviceMappingModal .table tbody tr:last-child {
        border-bottom: none !important;
    }

    .dark-mode #deviceMappingModal .table tbody tr:last-child td,
    body.dark-mode #deviceMappingModal .table tbody tr:last-child td {
        border-bottom: none !important;
    }

    /* Pagination Container */
    .dark-mode #deviceMappingModal .mapping-pagination,
    body.dark-mode #deviceMappingModal .mapping-pagination {
        background-color: #343a40 !important;
        border: 1px solid #495057 !important;
        color: #e1e5ea !important;
        border-radius: 6px !important;
        box-shadow: none !important;
    }

    .dark-mode #deviceMappingModal .dataTables_info,
    body.dark-mode #deviceMappingModal .dataTables_info {
        color: #e1e5ea !important;
    }

    /* Pagination Controls */
    .dark-mode #deviceMappingModal .pagination,
    body.dark-mode #deviceMappingModal .pagination {
        margin: 0 !important;
    }

    .dark-mode #deviceMappingModal .pagination > li > a,
    .dark-mode #deviceMappingModal .pagination > li > span,
    body.dark-mode #deviceMappingModal .pagination > li > a,
    body.dark-mode #deviceMappingModal .pagination > li > span {
        background-color: #343a40 !important;
        border: 1px solid #495057 !important;
        color: #e1e5ea !important;
        box-shadow: none !important;
        transition: all 0.2s ease !important;
    }

    .dark-mode #deviceMappingModal .pagination > li > a:hover,
    .dark-mode #deviceMappingModal .pagination > li > span:hover,
    body.dark-mode #deviceMappingModal .pagination > li > a:hover,
    body.dark-mode #deviceMappingModal .pagination > li > span:hover {
        background-color: #495057 !important;
        border-color: #6c757d !important;
        color: #ffffff !important;
        transform: translateY(-1px) !important;
        box-shadow: none !important;
    }

    .dark-mode #deviceMappingModal .pagination > .active > a,
    .dark-mode #deviceMappingModal .pagination > .active > span,
    body.dark-mode #deviceMappingModal .pagination > .active > a,
    body.dark-mode #deviceMappingModal .pagination > .active > span {
        background-color: #007bff !important;
        border-color: #007bff !important;
        color: #ffffff !important;
        box-shadow: 0 2px 4px rgba(0, 123, 255, 0.3) !important;
    }

    .dark-mode #deviceMappingModal .pagination > .disabled > a,
    .dark-mode #deviceMappingModal .pagination > .disabled > span,
    body.dark-mode #deviceMappingModal .pagination > .disabled > a,
    body.dark-mode #deviceMappingModal .pagination > .disabled > span {
        background-color: #343a40 !important;
        border-color: #495057 !important;
        color: #6c757d !important;
    }

    /* Buttons */
    .dark-mode #deviceMappingModal .btn-default,
    body.dark-mode #deviceMappingModal .btn-default {
        background-color: #6c757d !important;
        background-image: none !important;
        border: 1px solid #6c757d !important;
        color: #ffffff !important;
        box-shadow: none !important;
    }

    .dark-mode #deviceMappingModal .btn-default:hover,
    body.dark-mode #deviceMappingModal .btn-default:hover {
        background-color: #5a6268 !important;
        border-color: #545b62 !important;
        color: #ffffff !important;
        transform: translateY(-1px) !important;
        box-shadow: none !important;
    }

    .dark-mode #deviceMappingModal .btn-primary,
    body.dark-mode #deviceMappingModal .btn-primary {
        background-color: #007bff !important;
        background-image: none !important;
        border-color: #007bff !important;
        color: #ffffff !important;
        box-shadow: none !important;
    }

    .dark-mode #deviceMappingModal .btn-primary:hover,
    body.dark-mode #deviceMappingModal .btn-primary:hover {
        background-color: #0056b3 !important;
        border-color: #004085 !important;
        transform: translateY(-1px) !important;
        box-shadow: none !important;
    }

    .dark-mode #deviceMappingModal .btn-danger,
    body.dark-mode #deviceMappingModal .btn-danger {
        background-color: #dc3545 !important;
        background-image: none !important;
        border-color: #dc3545 !important;
        color: #ffffff !important;
        box-shadow: none !important;
    }

    .dark-mode #deviceMappingModal .btn-danger:hover,
    body.dark-mode #deviceMappingModal .btn-danger:hover {
        background-color: #c82333 !important;
        border-color: #bd2130 !important;
        transform: translateY(-1px) !important;
        box-shadow: none !important;
    }

    /* Labels and Badges */
    .dark-mode #deviceMappingModal .label,
    body.dark-mode #deviceMappingModal .label {
        opacity: 0.9 !important;
        box-shadow: none !important;
    }

    .dark-mode #deviceMappingModal .label-default,
    body.dark-mode #deviceMappingModal .label-default {
        background-color: #6c757d !important;
        color: #ffffff !important;
    }

    .dark-mode #deviceMappingModal .mobile-server-badge,
    body.dark-mode #deviceMappingModal .mobile-server-badge {
        background-color: #495057 !important;
        color: #e9ecef !important;
    }

    /* Text Colors */
    .dark-mode #deviceMappingModal .text-muted,
    body.dark-mode #deviceMappingModal .text-muted {
        color: #adb5bd !important;
    }

    .dark-mode #deviceMappingModal .text-success,
    body.dark-mode #deviceMappingModal .text-success {
        color: #4ade80 !important;
    }

    .dark-mode #deviceMappingModal .text-primary,
    body.dark-mode #deviceMappingModal .text-primary {
        color: #60a5fa !important;
    }

    .dark-mode #deviceMappingModal .text-danger,
    body.dark-mode #deviceMappingModal .text-danger {
        color: #f87171 !important;
    }

    /* Small text and additional elements */
    .dark-mode #deviceMappingModal small,
    body.dark-mode #deviceMappingModal small {
        color: #adb5bd !important;
    }

    .dark-mode #deviceMappingModal strong,
    body.dark-mode #deviceMappingModal strong {
        color: #ffffff !important;
    }

    /* Row backgrounds */
    .dark-mode #deviceMappingModal .row,
    body.dark-mode #deviceMappingModal .row {
        color: #e1e5ea !important;
    }

    /* Any remaining white backgrounds - Nuclear Option */
    .dark-mode #deviceMappingModal *:not(.fa):not(.glyphicon),
    body.dark-mode #deviceMappingModal *:not(.fa):not(.glyphicon) {
        border-color: #495057 !important;
    }

    /* Autofill Prevention */
    .dark-mode #deviceMappingModal input:-webkit-autofill,
    .dark-mode #deviceMappingModal input:-webkit-autofill:hover,
    .dark-mode #deviceMappingModal input:-webkit-autofill:focus,
    .dark-mode #deviceMappingModal input:-webkit-autofill:active,
    body.dark-mode #deviceMappingModal input:-webkit-autofill,
    body.dark-mode #deviceMappingModal input:-webkit-autofill:hover,
    body.dark-mode #deviceMappingModal input:-webkit-autifill:focus,
    body.dark-mode #deviceMappingModal input:-webkit-autofill:active {
        -webkit-box-shadow: 0 0 0 30px #343a40 inset !important;
        -webkit-text-fill-color: #ffffff !important;
        box-shadow: 0 0 0 30px #343a40 inset !important;
    }

    /* Fix for Input Group with Search Icon */
    .dark-mode #deviceMappingModal .input-group,
    body.dark-mode #deviceMappingModal .input-group {
        background-color: transparent !important;
    }

    .dark-mode #deviceMappingModal .input-group .input-group-addon,
    body.dark-mode #deviceMappingModal .input-group .input-group-addon {
        background-color: #495057 !important;
        background-image: none !important;
        border: 1px solid #495057 !important;
        color: #ffffff !important;
        box-shadow: none !important;
    }

    .dark-mode #deviceMappingModal .input-group .input-group-addon i,
    .dark-mode #deviceMappingModal .input-group .input-group-addon .fa,
    body.dark-mode #deviceMappingModal .input-group .input-group-addon i,
    body.dark-mode #deviceMappingModal .input-group .input-group-addon .fa {
        color: #ffffff !important;
    }

    .dark-mode #deviceMappingModal .input-group .form-control:first-child,
    body.dark-mode #deviceMappingModal .input-group .form-control:first-child {
        border-right: none !important;
    }

    .dark-mode #deviceMappingModal .input-group .form-control:last-child,
    body.dark-mode #deviceMappingModal .input-group .form-control:last-child {
        border-left: none !important;
    }

    /* Ensure input group addon borders connect properly */
    .dark-mode #deviceMappingModal .input-group .input-group-addon:first-child,
    body.dark-mode #deviceMappingModal .input-group .input-group-addon:first-child {
        border-right: none !important;
        border-top-right-radius: 0 !important;
        border-bottom-right-radius: 0 !important;
    }

    .dark-mode #deviceMappingModal .input-group .input-group-addon:last-child,
    body.dark-mode #deviceMappingModal .input-group .input-group-addon:last-child {
        border-left: none !important;
        border-top-left-radius: 0 !important;
        border-bottom-left-radius: 0 !important;
    }

    /* Force all input group elements to have same height and alignment */
    .dark-mode #deviceMappingModal .input-group .form-control,
    .dark-mode #deviceMappingModal .input-group .input-group-addon,
    body.dark-mode #deviceMappingModal .input-group .form-control,
    body.dark-mode #deviceMappingModal .input-group .input-group-addon {
        height: 34px !important;
        line-height: 1.42857143 !important;
        border-width: 1px !important;
    }

    /* Loading states */
    .device-count-badge .fa-spinner {
        font-size: 12px;
    }

    .loading-placeholder {
        background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
        background-size: 200% 100%;
        animation: loading 1.5s infinite;
    }

    @keyframes loading {
        0% {
            background-position: 200% 0;
        }

        100% {
            background-position: -200% 0;
        }
    }

    /* Pagination styles */
    .pagination {
        margin: 10px 0;
        display: inline-block;
    }

    .pagination>li {
        display: inline;
    }

    .pagination>li>a {
        padding: 6px 12px;
        margin-left: -1px;
        line-height: 1.42857143;
        color: #337ab7;
        text-decoration: none;
        background-color: #fff;
        border: 1px solid #ddd;
        float: left;
    }

    .pagination>li:first-child>a {
        margin-left: 0;
        border-top-left-radius: 4px;
        border-bottom-left-radius: 4px;
    }

    .pagination>li:last-child>a {
        border-top-right-radius: 4px;
        border-bottom-right-radius: 4px;
    }

    .pagination>.active>a,
    .pagination>.active>a:hover,
    .pagination>.active>a:focus {
        z-index: 2;
        color: #fff;
        cursor: default;
        background-color: #337ab7;
        border-color: #337ab7;
    }

    .pagination>.disabled>a,
    .pagination>.disabled>a:hover,
    .pagination>.disabled>a:focus {
        color: #777;
        cursor: not-allowed;
        background-color: #fff;
        border-color: #ddd;
    }

    .dataTables_info {
        padding-top: 8px;
        white-space: nowrap;
    }

    .dataTables_paginate {
        text-align: right;
    }

    /* Dark mode pagination */
    .dark-mode .pagination>li>a,
    body.dark-mode .pagination>li>a {
        background-color: #343a40;
        border-color: #495057;
        color: #fff;
    }

    .dark-mode .pagination>.active>a,
    body.dark-mode .pagination>.active>a {
        background-color: #007bff;
        border-color: #007bff;
    }

    .dark-mode .pagination>.disabled>a,
    body.dark-mode .pagination>.disabled>a {
        background-color: #343a40;
        color: #6c757d;
    }

    /* ========================================
       MOBILE CARD VIEW STYLES
       ======================================== */
    
    .mobile-cards-container {
        padding: 10px;
    }

    .mobile-server-card {
        background: #fff;
        border: 1px solid #ddd;
        border-radius: 8px;
        margin-bottom: 15px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        overflow: hidden;
    }

    .mobile-server-card.priority-card-mobile {
        border: 2px solid #f39c12;
        box-shadow: 0 2px 8px rgba(243, 156, 18, 0.3);
    }

    .mobile-card-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 12px 15px;
        background: #f8f9fa;
        border-bottom: 1px solid #eee;
    }

    .mobile-card-title {
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 15px;
    }

    .mobile-card-title strong {
        color: #333;
    }

    .mobile-card-status .label {
        font-size: 11px;
        padding: 4px 8px;
    }

    .mobile-card-body {
        padding: 12px 15px;
    }

    .mobile-card-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 8px 0;
        border-bottom: 1px solid #f0f0f0;
    }

    .mobile-card-row:last-child {
        border-bottom: none;
    }

    .mobile-card-label {
        color: #666;
        font-size: 13px;
        display: flex;
        align-items: center;
        gap: 6px;
    }

    .mobile-card-label i {
        width: 16px;
        text-align: center;
        color: #999;
    }

    .mobile-card-value {
        font-size: 13px;
        font-weight: 500;
        color: #333;
    }

    .mobile-card-actions {
        display: flex;
        justify-content: space-around;
        padding: 12px 15px;
        background: #f8f9fa;
        border-top: 1px solid #eee;
        gap: 8px;
    }

    .mobile-card-actions .btn {
        flex: 1;
        padding: 10px 5px;
        font-size: 16px;
        border-radius: 6px;
    }

    .mobile-card-actions .btn i {
        font-size: 16px;
    }

    /* Dark Mode for Mobile Cards */
    .dark-mode .mobile-server-card,
    body.dark-mode .mobile-server-card {
        background: #2d3238;
        border-color: #495057;
    }

    .dark-mode .mobile-card-header,
    body.dark-mode .mobile-card-header {
        background: #343a40;
        border-color: #495057;
    }

    .dark-mode .mobile-card-title strong,
    body.dark-mode .mobile-card-title strong {
        color: #fff;
    }

    .dark-mode .mobile-card-body,
    body.dark-mode .mobile-card-body {
        background: #2d3238;
    }

    .dark-mode .mobile-card-row,
    body.dark-mode .mobile-card-row {
        border-color: #495057;
    }

    .dark-mode .mobile-card-label,
    body.dark-mode .mobile-card-label {
        color: #adb5bd;
    }

    .dark-mode .mobile-card-value,
    body.dark-mode .mobile-card-value {
        color: #fff;
    }

    .dark-mode .mobile-card-actions,
    body.dark-mode .mobile-card-actions {
        background: #343a40;
        border-color: #495057;
    }

    .dark-mode .priority-card-mobile,
    body.dark-mode .priority-card-mobile {
        border-color: #f39c12;
    }

    /* Hide desktop table on mobile, show cards */
    @media (max-width: 767px) {
        .hidden-xs {
            display: none !important;
        }
        .visible-xs {
            display: block !important;
        }
    }

    /* Hide cards on desktop, show table */
    @media (min-width: 768px) {
        .visible-xs {
            display: none !important;
        }
        .hidden-xs {
            display: block !important;
        }
    }

    /* ========================================
       FIX INFO BOX ICON ON MOBILE
       ======================================== */
    @media (max-width: 767px) {
        .info-box {
            display: flex !important;
            align-items: stretch;
            min-height: 80px;
        }

        .info-box-icon {
            display: flex !important;
            align-items: center;
            justify-content: center;
            float: none !important;
            width: 70px !important;
            min-width: 70px;
            height: auto !important;
            min-height: 80px;
            font-size: 35px !important;
            line-height: 1 !important;
        }

        .info-box-icon i {
            display: block !important;
            color: #fff !important;
        }

        .info-box-content {
            margin-left: 0 !important;
            padding: 8px 10px;
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .info-box-text {
            font-size: 12px !important;
        }

        .info-box-number {
            font-size: 20px !important;
        }

        .progress-description {
            font-size: 11px !important;
        }

        /* Stats cards row spacing */
        #stats-cards .col-xs-12 {
            padding-left: 10px;
            padding-right: 10px;
        }

        #stats-cards {
            margin-left: -5px;
            margin-right: -5px;
        }
    }
</style>

{include file="sections/footer.tpl"}

