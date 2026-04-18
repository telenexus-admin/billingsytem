{include file="sections/header.tpl"}

<div class="row">
    <div class="col-sm-12">
        <div class="panel panel-hovered mb20 panel-primary">
            <div class="panel-heading">
                <i class="ion ion-settings"></i> GenieACS Parameter Configuration
            </div>
            <div class="panel-body">

                <!-- Professional Tab Navigation -->
                <div class="parameters-navigation">
                    <div class="nav-wrapper">
                        <ul class="nav nav-pills nav-professional">
                            <li class="active">
                                <a href="#basic" data-toggle="tab">
                                    <i class="fa fa-cog"></i>
                                    <span>Basic Configuration</span>
                                </a>
                            </li>
                            <li>
                                <a href="#wifi" data-toggle="tab">
                                    <i class="fa fa-wifi"></i>
                                    <span>WiFi Settings</span>
                                </a>
                            </li>
                            <li>
                                <a href="#webadmin" data-toggle="tab">
                                    <i class="fa fa-lock"></i>
                                    <span>Web Admin</span>
                                </a>
                            </li>
                            <li>
                                <a href="#config" data-toggle="tab">
                                    <i class="fa fa-sliders"></i>
                                    <span>Config</span>
                                </a>
                            </li>
                        </ul>
                        <div class="nav-actions">
                            <button class="btn btn-secondary btn-sm"
                                onclick="window.location.href='{$_url}plugin/genieacs_manager'">
                                <i class="fa fa-server"></i>
                                <span class="btn-text">Manage Servers</span>
                            </button>
                            <button class="btn btn-primary btn-sm" onclick="showAddModal()">
                                <i class="fa fa-plus"></i>
                                <span class="btn-text">Add Parameter</span>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Tab Content -->
                <div class="tab-content">
                    {foreach $grouped_params as $category => $params}
                        {if $category != 'advanced'}
                            <div class="tab-pane {if $category == 'basic'}active{/if}" id="{$category}">
                                
                                {* === CONFIG TAB === *}
                                {if $category == 'config'}
                                    <div class="config-cards-container">
                                        {foreach $params as $param}
                                            <div class="config-card">
                                                <div class="config-card-header">
                                                    <div class="config-icon">
                                                        {if $param->param_key == 'ssid_prefix_2g'}
                                                            <i class="fa fa-wifi"></i>
                                                        {elseif $param->param_key == 'ssid_prefix_5g'}
                                                            <i class="fa fa-wifi"></i>
                                                        {else}
                                                            <i class="fa fa-cog"></i>
                                                        {/if}
                                                    </div>
                                                    <div class="config-title">
                                                        <h4>{$param->param_label}</h4>
                                                        <span class="config-key">{$param->param_key}</span>
                                                    </div>
                                                    <div class="config-actions">
                                                        <button class="btn-icon btn-edit"
                                                            onclick="editParameter({$param->id}, '{$param->param_key}', '{$param->param_label}', '{$param->param_path|escape:'javascript'}', '{$param->param_type}', '{$param->param_category}', {$param->is_required}, {$param->display_order})"
                                                            title="Edit">
                                                            <i class="fa fa-pencil"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                                <div class="config-card-body">
                                                    <div class="config-value-display">
                                                        <label>Current Value:</label>
                                                        {if $param->param_path}
                                                            <div class="config-value">{$param->param_path}</div>
                                                            {if $param->param_key == 'ssid_prefix_2g' || $param->param_key == 'ssid_prefix_5g'}
                                                                <div class="config-preview">
                                                                    <span class="preview-label">Preview:</span>
                                                                    <span class="preview-value">{$param->param_path}YourSSID</span>
                                                                </div>
                                                            {/if}
                                                        {else}
                                                            <div class="config-value empty">Not Set (Disabled)</div>
                                                        {/if}
                                                    </div>
                                                </div>
                                                {if $param->param_key == 'ssid_prefix_2g'}
                                                    <div class="config-card-footer">
                                                        <span class="config-badge badge-2g">2.4 GHz Band</span>
                                                    </div>
                                                {elseif $param->param_key == 'ssid_prefix_5g'}
                                                    <div class="config-card-footer">
                                                        <span class="config-badge badge-5g">5 GHz Band</span>
                                                    </div>
                                                {/if}
                                            </div>
                                        {/foreach}
                                        
                                        {if count($params) == 0}
                                            <div class="empty-state">
                                                <i class="fa fa-sliders"></i>
                                                <p>No configuration parameters</p>
                                            </div>
                                        {/if}
                                    </div>
                                
                                {* === BASIC TAB === *}
                                {elseif $category == 'basic'}
                                    <div class="param-cards-container">
                                        {foreach $params as $param}
                                            <div class="param-card param-card-basic">
                                                <div class="param-card-header">
                                                    <div class="param-icon icon-basic">
                                                        {if $param->param_key == 'device_manufacturer'}
                                                            <i class="fa fa-industry"></i>
                                                        {elseif $param->param_key == 'device_model'}
                                                            <i class="fa fa-cube"></i>
                                                        {elseif $param->param_key == 'device_serial'}
                                                            <i class="fa fa-barcode"></i>
                                                        {elseif $param->param_key == 'software_version'}
                                                            <i class="fa fa-code-fork"></i>
                                                        {elseif $param->param_key == 'hardware_version'}
                                                            <i class="fa fa-microchip"></i>
                                                        {elseif $param->param_key == 'uptime'}
                                                            <i class="fa fa-clock-o"></i>
                                                        {else}
                                                            <i class="fa fa-info-circle"></i>
                                                        {/if}
                                                    </div>
                                                    <div class="param-title">
                                                        <h4>{$param->param_label}</h4>
                                                        <span class="param-key">{$param->param_key}</span>
                                                    </div>
                                                    <div class="param-actions">
                                                        <button class="btn-icon btn-edit"
                                                            onclick="editParameter({$param->id}, '{$param->param_key}', '{$param->param_label}', '{$param->param_path|escape:'javascript'}', '{$param->param_type}', '{$param->param_category}', {$param->is_required}, {$param->display_order})"
                                                            title="Edit">
                                                            <i class="fa fa-pencil"></i>
                                                        </button>
                                                        {if !$param->is_required}
                                                            <button class="btn-icon btn-delete"
                                                                onclick="deleteParameter({$param->id}, '{$param->param_label}')"
                                                                title="Delete">
                                                                <i class="fa fa-trash"></i>
                                                            </button>
                                                        {/if}
                                                    </div>
                                                </div>
                                                <div class="param-card-body">
                                                    <div class="param-info-row">
                                                        <div class="param-info-item">
                                                            <label>GenieACS Path:</label>
                                                            <code class="param-path-value" title="{$param->param_path}">{$param->param_path}</code>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="param-card-footer">
                                                    <span class="type-badge type-{$param->param_type}">
                                                        {if $param->param_type == 'display'}
                                                            <i class="fa fa-eye"></i> Display
                                                        {elseif $param->param_type == 'update'}
                                                            <i class="fa fa-edit"></i> Update
                                                        {elseif $param->param_type == 'config'}
                                                            <i class="fa fa-cog"></i> Config
                                                        {else}
                                                            <i class="fa fa-exchange"></i> Both
                                                        {/if}
                                                    </span>
                                                    {if $param->is_required}
                                                        <span class="required-badge">
                                                            <i class="fa fa-check-circle"></i> Required
                                                        </span>
                                                    {/if}
                                                    <span class="order-badge-small">#{$param->display_order}</span>
                                                </div>
                                            </div>
                                        {/foreach}
                                        
                                        {if count($params) == 0}
                                            <div class="empty-state-card">
                                                <i class="fa fa-inbox"></i>
                                                <h4>No Parameters</h4>
                                                <p>No parameters in basic category</p>
                                            </div>
                                        {/if}
                                    </div>
                                
                                {* === WIFI TAB === *}
                                {elseif $category == 'wifi'}
                                    <div class="param-cards-container">
                                        {foreach $params as $param}
                                            <div class="param-card param-card-wifi">
                                                <div class="param-card-header">
                                                    <div class="param-icon icon-wifi">
                                                        {if $param->param_key == 'wifi_ssid_2g'}
                                                            <i class="fa fa-wifi"></i>
                                                        {elseif $param->param_key == 'wifi_ssid_5g'}
                                                            <i class="fa fa-wifi"></i>
                                                        {elseif $param->param_key == 'wifi_password'}
                                                            <i class="fa fa-key"></i>
                                                        {elseif $param->param_key == 'wifi_channel_2g' || $param->param_key == 'wifi_channel_5g'}
                                                            <i class="fa fa-sliders"></i>
                                                        {elseif $param->param_key == 'wifi_security_2g' || $param->param_key == 'wifi_security_5g'}
                                                            <i class="fa fa-shield"></i>
                                                        {elseif $param->param_key == 'wifi_enabled_2g' || $param->param_key == 'wifi_enabled_5g'}
                                                            <i class="fa fa-toggle-on"></i>
                                                        {else}
                                                            <i class="fa fa-wifi"></i>
                                                        {/if}
                                                    </div>
                                                    <div class="param-title">
                                                        <h4>{$param->param_label}</h4>
                                                        <span class="param-key">{$param->param_key}</span>
                                                    </div>
                                                    <div class="param-actions">
                                                        <button class="btn-icon btn-edit"
                                                            onclick="editParameter({$param->id}, '{$param->param_key}', '{$param->param_label}', '{$param->param_path|escape:'javascript'}', '{$param->param_type}', '{$param->param_category}', {$param->is_required}, {$param->display_order})"
                                                            title="Edit">
                                                            <i class="fa fa-pencil"></i>
                                                        </button>
                                                        {if !$param->is_required}
                                                            <button class="btn-icon btn-delete"
                                                                onclick="deleteParameter({$param->id}, '{$param->param_label}')"
                                                                title="Delete">
                                                                <i class="fa fa-trash"></i>
                                                            </button>
                                                        {/if}
                                                    </div>
                                                </div>
                                                <div class="param-card-body">
                                                    <div class="param-info-row">
                                                        <div class="param-info-item">
                                                            <label>GenieACS Path:</label>
                                                            <code class="param-path-value" title="{$param->param_path}">{$param->param_path}</code>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="param-card-footer">
                                                    <span class="type-badge type-{$param->param_type}">
                                                        {if $param->param_type == 'display'}
                                                            <i class="fa fa-eye"></i> Display
                                                        {elseif $param->param_type == 'update'}
                                                            <i class="fa fa-edit"></i> Update
                                                        {elseif $param->param_type == 'config'}
                                                            <i class="fa fa-cog"></i> Config
                                                        {else}
                                                            <i class="fa fa-exchange"></i> Both
                                                        {/if}
                                                    </span>
                                                    {if $param->is_required}
                                                        <span class="required-badge">
                                                            <i class="fa fa-check-circle"></i> Required
                                                        </span>
                                                    {/if}
                                                    {if strpos($param->param_key, '2g') !== false}
                                                        <span class="band-badge badge-2g">2.4 GHz</span>
                                                    {elseif strpos($param->param_key, '5g') !== false}
                                                        <span class="band-badge badge-5g">5 GHz</span>
                                                    {/if}
                                                    <span class="order-badge-small">#{$param->display_order}</span>
                                                </div>
                                            </div>
                                        {/foreach}
                                        
                                        {if count($params) == 0}
                                            <div class="empty-state-card">
                                                <i class="fa fa-wifi"></i>
                                                <h4>No Parameters</h4>
                                                <p>No parameters in WiFi category</p>
                                            </div>
                                        {/if}
                                    </div>
                                
                                
                                {* === WEBADMIN TAB === *}
                                {elseif $category == 'webadmin'}
                                    <div class="param-cards-container">
                                        {foreach $params as $param}
                                            <div class="param-card param-card-webadmin">
                                                <div class="param-card-header">
                                                    <div class="param-icon icon-webadmin">
                                                        {if $param->param_key == 'admin_username' || $param->param_key == 'webadmin_username'}
                                                            <i class="fa fa-user-circle"></i>
                                                        {elseif $param->param_key == 'admin_password' || $param->param_key == 'webadmin_password'}
                                                            <i class="fa fa-key"></i>
                                                        {elseif $param->param_key == 'admin_url' || $param->param_key == 'webadmin_url'}
                                                            <i class="fa fa-link"></i>
                                                        {elseif $param->param_key == 'admin_port' || $param->param_key == 'webadmin_port'}
                                                            <i class="fa fa-plug"></i>
                                                        {elseif $param->param_key == 'admin_https' || $param->param_key == 'webadmin_https'}
                                                            <i class="fa fa-shield"></i>
                                                        {elseif strpos($param->param_key, 'remote') !== false}
                                                            <i class="fa fa-cloud"></i>
                                                        {elseif strpos($param->param_key, 'access') !== false}
                                                            <i class="fa fa-unlock-alt"></i>
                                                        {else}
                                                            <i class="fa fa-lock"></i>
                                                        {/if}
                                                    </div>
                                                    <div class="param-title">
                                                        <h4>{$param->param_label}</h4>
                                                        <span class="param-key">{$param->param_key}</span>
                                                    </div>
                                                    <div class="param-actions">
                                                        <button class="btn-icon btn-edit"
                                                            onclick="editParameter({$param->id}, '{$param->param_key}', '{$param->param_label}', '{$param->param_path|escape:'javascript'}', '{$param->param_type}', '{$param->param_category}', {$param->is_required}, {$param->display_order})"
                                                            title="Edit">
                                                            <i class="fa fa-pencil"></i>
                                                        </button>
                                                        {if !$param->is_required}
                                                            <button class="btn-icon btn-delete"
                                                                onclick="deleteParameter({$param->id}, '{$param->param_label}')"
                                                                title="Delete">
                                                                <i class="fa fa-trash"></i>
                                                            </button>
                                                        {/if}
                                                    </div>
                                                </div>
                                                <div class="param-card-body">
                                                    <div class="param-info-row">
                                                        <div class="param-info-item">
                                                            <label>GenieACS Path:</label>
                                                            <code class="param-path-value" title="{$param->param_path}">{$param->param_path}</code>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="param-card-footer">
                                                    <span class="type-badge type-{$param->param_type}">
                                                        {if $param->param_type == 'display'}
                                                            <i class="fa fa-eye"></i> Display
                                                        {elseif $param->param_type == 'update'}
                                                            <i class="fa fa-edit"></i> Update
                                                        {elseif $param->param_type == 'config'}
                                                            <i class="fa fa-cog"></i> Config
                                                        {else}
                                                            <i class="fa fa-exchange"></i> Both
                                                        {/if}
                                                    </span>
                                                    {if $param->is_required}
                                                        <span class="required-badge">
                                                            <i class="fa fa-check-circle"></i> Required
                                                        </span>
                                                    {/if}
                                                    <span class="order-badge-small">#{$param->display_order}</span>
                                                </div>
                                            </div>
                                        {/foreach}
                                        
                                        {if count($params) == 0}
                                            <div class="empty-state-card">
                                                <i class="fa fa-lock"></i>
                                                <h4>No Parameters</h4>
                                                <p>No parameters in Web Admin category</p>
                                            </div>
                                        {/if}
                                    </div>
                                
                                {* === OTHER TABS (Table Layout - Fallback) === *}
                                {else}
                                    <div class="data-table-container">
                                        <table class="professional-table">
                                            <thead>
                                                <tr>
                                                    <th class="col-order">
                                                        <span class="th-content">#</span>
                                                    </th>
                                                    <th class="col-key">
                                                        <span class="th-content">Parameter Key</span>
                                                    </th>
                                                    <th class="col-label">
                                                        <span class="th-content">Display Label</span>
                                                    </th>
                                                    <th class="col-path">
                                                        <span class="th-content">GenieACS Path</span>
                                                    </th>
                                                    <th class="col-type">
                                                        <span class="th-content">Type</span>
                                                    </th>
                                                    <th class="col-required">
                                                        <span class="th-content">Required</span>
                                                    </th>
                                                    <th class="col-actions">
                                                        <span class="th-content">Actions</span>
                                                    </th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                {foreach $params as $param}
                                                    <tr class="data-row">
                                                        <td class="col-order">
                                                            <span class="order-number">{$param->display_order}</span>
                                                        </td>
                                                        <td class="col-key">
                                                            <span class="key-tag">{$param->param_key}</span>
                                                        </td>
                                                        <td class="col-label">
                                                            <span class="label-text">{$param->param_label}</span>
                                                        </td>
                                                        <td class="col-path">
                                                            <code class="path-code">{$param->param_path}</code>
                                                        </td>
                                                        <td class="col-type">
                                                            <span class="type-badge type-{$param->param_type}">
                                                                {if $param->param_type == 'display'}
                                                                    <i class="fa fa-eye"></i> Display
                                                                {elseif $param->param_type == 'update'}
                                                                    <i class="fa fa-edit"></i> Update
                                                                {elseif $param->param_type == 'config'}
                                                                    <i class="fa fa-cog"></i> Config
                                                                {else}
                                                                    <i class="fa fa-exchange"></i> Both
                                                                {/if}
                                                            </span>
                                                        </td>
                                                        <td class="col-required">
                                                            {if $param->is_required}
                                                                <span class="status-indicator required">
                                                                    <i class="fa fa-check"></i>
                                                                </span>
                                                            {else}
                                                                <span class="status-indicator optional">
                                                                    <i class="fa fa-minus"></i>
                                                                </span>
                                                            {/if}
                                                        </td>
                                                        <td class="col-actions">
                                                            <div class="action-buttons">
                                                                <button class="btn-icon btn-edit"
                                                                    onclick="editParameter({$param->id}, '{$param->param_key}', '{$param->param_label}', '{$param->param_path|escape:'javascript'}', '{$param->param_type}', '{$param->param_category}', {$param->is_required}, {$param->display_order})"
                                                                    title="Edit">
                                                                    <i class="fa fa-pencil"></i>
                                                                </button>
                                                                {if !$param->is_required}
                                                                    <button class="btn-icon btn-delete"
                                                                        onclick="deleteParameter({$param->id}, '{$param->param_label}')"
                                                                        title="Delete">
                                                                        <i class="fa fa-trash"></i>
                                                                    </button>
                                                                {/if}
                                                            </div>
                                                        </td>
                                                    </tr>
                                                {/foreach}
                                            </tbody>
                                        </table>
                                    </div>

                                    {if count($params) == 0}
                                        <div class="empty-state">
                                            <i class="fa fa-inbox"></i>
                                            <p>No parameters in {$category} category</p>
                                        </div>
                                    {/if}
                                {/if}
                            </div>
                        {/if}
                    {/foreach}
                </div>
            </div>
        </div>
    </div>
</div>


<!-- Modern Modal Parameter -->
<div class="modal-overlay" id="parameterModalOverlay" style="display: none;">
    <div class="modal-container">
        <div class="modal-header-new">
            <h4 id="modalTitle"><i class="fa fa-plus-circle"></i> Add Parameter</h4>
            <button class="modal-close-btn" onclick="closeParameterModal()">&times;</button>
        </div>
        <div class="modal-body-new">
            <form id="parameterForm" method="POST" action="">
                <input type="hidden" id="param_id" name="id" value="0">
                
                <!-- Section: Basic Information -->
                <div class="form-section-new">
                    <div class="form-section-header-new">
                        <i class="fa fa-info-circle"></i>
                        <span>Basic Information</span>
                    </div>
                    
                    <div class="form-group-new">
                        <label>Parameter Key <span class="text-danger">*</span></label>
                        <input type="text" class="form-control-new" id="param_key" name="param_key" 
                            placeholder="Example: device_model" required
                            pattern="[a-z0-9_]+" title="Lowercase letters, numbers, and underscore only">
                        <small class="form-help-new">Unique identifier (lowercase, no spaces)</small>
                    </div>
                    
                    <div class="form-group-new">
                        <label>Display Label <span class="text-danger">*</span></label>
                        <input type="text" class="form-control-new" id="param_label" name="param_label" 
                            placeholder="Example: Device Model" required>
                    </div>
                    
                    <div class="form-group-new">
                        <label>Display Order</label>
                        <input type="number" class="form-control-new" id="display_order" name="display_order" 
                            value="0" min="0" placeholder="0">
                        <small class="form-help-new">Parameter display order (smaller number = higher position)</small>
                    </div>
                </div>
                
                <!-- Section: Category & Type -->
                <div class="form-section-new">
                    <div class="form-section-header-new">
                        <i class="fa fa-folder-open"></i>
                        <span>Category & Type</span>
                    </div>
                    
                    <div class="form-group-new">
                        <label>Category <span class="text-danger">*</span></label>
                        <div class="category-grid-new">
                            <label class="category-card-new">
                                <input type="radio" name="param_category" value="basic" checked>
                                <div class="category-card-content">
                                    <i class="fa fa-desktop"></i>
                                    <span>Basic</span>
                                </div>
                            </label>
                            <label class="category-card-new">
                                <input type="radio" name="param_category" value="wifi">
                                <div class="category-card-content">
                                    <i class="fa fa-wifi"></i>
                                    <span>WiFi</span>
                                </div>
                            </label>
                            <label class="category-card-new">
                                <input type="radio" name="param_category" value="webadmin">
                                <div class="category-card-content">
                                    <i class="fa fa-lock"></i>
                                    <span>WebAdmin</span>
                                </div>
                            </label>
                            <label class="category-card-new">
                                <input type="radio" name="param_category" value="config">
                                <div class="category-card-content">
                                    <i class="fa fa-sliders"></i>
                                    <span>Config</span>
                                </div>
                            </label>
                        </div>
                    </div>
                    
                    <div class="form-group-new">
                        <label>Parameter Type <span class="text-danger">*</span></label>
                        <div class="type-grid-new">
                            <label class="type-card-new">
                                <input type="radio" name="param_type" value="display">
                                <div class="type-card-content">
                                    <i class="fa fa-eye"></i>
                                    <span>Display</span>
                                </div>
                            </label>
                            <label class="type-card-new">
                                <input type="radio" name="param_type" value="update">
                                <div class="type-card-content">
                                    <i class="fa fa-edit"></i>
                                    <span>Update</span>
                                </div>
                            </label>
                            <label class="type-card-new">
                                <input type="radio" name="param_type" value="both" checked>
                                <div class="type-card-content">
                                    <i class="fa fa-exchange"></i>
                                    <span>Both</span>
                                </div>
                            </label>
                            <label class="type-card-new">
                                <input type="radio" name="param_type" value="config">
                                <div class="type-card-content">
                                    <i class="fa fa-cog"></i>
                                    <span>Config</span>
                                </div>
                            </label>
                        </div>
                    </div>
                    
                    <div class="form-group-new">
                        <label class="checkbox-container-new">
                            <input type="checkbox" id="is_required" name="is_required">
                            <span class="checkbox-text-new">Mark as required parameter</span>
                        </label>
                    </div>
                </div>
                
                <!-- Section: GenieACS Path -->
                <div class="form-section-new">
                    <div class="form-section-header-new">
                        <i class="fa fa-code"></i>
                        <span>GenieACS Path</span>
                    </div>
                    
                    <div class="form-group-new">
                        <label>Path Parameter <span class="text-danger" id="path-required">*</span></label>
                        <input type="text" class="form-control-new" id="param_path" name="param_path" 
                            placeholder="Example: VirtualParameters.pppoeUsername">
                        <small class="form-help-new">Path to the parameter in GenieACS (optional for Config category)</small>
                        
                        <div class="path-hints-new">
                            <span class="hint-tag" onclick="insertPath('VirtualParameters.')">
                                <i class="fa fa-tag"></i> Virtual
                            </span>
                            <span class="hint-tag" onclick="insertPath('InternetGatewayDevice.')">
                                <i class="fa fa-tag"></i> TR-069
                            </span>
                            <span class="hint-tag" onclick="insertPath('_deviceId.')">
                                <i class="fa fa-tag"></i> Device ID
                            </span>
                            <span class="hint-tag" onclick="insertPath('_id')">
                                <i class="fa fa-tag"></i> ID
                            </span>
                        </div>
                    </div>
                </div>
            </form>
        </div>
        <div class="modal-footer-new">
            <button type="button" class="btn-cancel-new" onclick="closeParameterModal()">
                <i class="fa fa-times"></i> Cancel
            </button>
            <button type="button" class="btn-save-new" onclick="document.getElementById('parameterForm').submit()">
                <i class="fa fa-save"></i> Save
            </button>
        </div>
    </div>
</div>

<style>

    /* Navigation Tabs */
    .parameters-navigation {
        margin-bottom: 24px;
    }

    .nav-wrapper {
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 2px solid #dee2e6;
        padding-bottom: 0;
    }

    .nav-professional {
        display: flex;
        margin-bottom: -2px;
        border: none;
    }

    .nav-professional li {
        margin-right: 4px;
    }

    .nav-professional li a {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 12px 20px;
        color: #6c757d;
        background: transparent;
        border: none;
        border-bottom: 2px solid transparent;
        transition: all 0.2s;
        text-decoration: none;
    }

    .nav-professional li a:hover {
        color: #495057;
        background: #f8f9fa;
    }

    .nav-professional li.active a {
        color: #0056b3;
        border-bottom-color: #0056b3;
        background: transparent;
    }

    .nav-professional li a i {
        font-size: 14px;
    }

    .nav-professional li a span {
        font-size: 14px;
        font-weight: 500;
    }

    .nav-actions {
        display: flex;
        gap: 8px;
        padding-bottom: 8px;
    }

    /* Professional Buttons */
    .btn {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 8px 16px;
        border-radius: 4px;
        font-size: 14px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.2s;
        border: 1px solid transparent;
        text-decoration: none;
    }

    .btn-sm {
        padding: 6px 12px;
        font-size: 13px;
    }

    .btn-primary {
        background: #22c55e;
        color: white;
        border-color: #22c55e;
    }

    .btn-primary:hover {
        background: #16a34a;
        border-color: #16a34a;
        color: white;
    }

    .btn-secondary {
        background: #8b5cf6;
        color: white;
        border-color: #8b5cf6;
    }

    .btn-secondary:hover {
        background: #7c3aed;
        border-color: #7c3aed;
        color: white;
    }

    /* Professional Table */
    .data-table-container {
        background: #ffffff;
        border: 1px solid #dee2e6;
        border-radius: 8px;
        overflow: hidden;
    }

    .professional-table {
        width: 100%;
        border-collapse: collapse;
        margin: 0;
    }

    .professional-table thead {
        background: #f8f9fa;
        border-bottom: 2px solid #dee2e6;
    }

    .professional-table thead th {
        padding: 14px 16px;
        text-align: left;
        font-size: 12px;
        font-weight: 600;
        color: #6c757d;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .col-order {
        width: 60px;
        text-align: center;
    }

    .col-key {
        width: 15%;
    }

    .col-label {
        width: 20%;
    }

    .col-path {
        width: 35%;
        min-width: 250px;
    }

    .col-type {
        width: 140px;
        text-align: center;
    }

    .col-required {
        width: 100px;
        text-align: center;
    }

    .col-actions {
        width: 120px;
        text-align: center;
        position: sticky;
        right: 0;
        background: inherit;
        z-index: 10;
    }

    .professional-table tbody tr {
        border-bottom: 1px solid #e9ecef;
        transition: background 0.1s;
    }

    .professional-table tbody tr:hover {
        background: #f8f9fa;
    }

    .professional-table tbody td {
        padding: 12px 16px;
        font-size: 14px;
        color: #212529;
    }

    /* Table Elements */
    .order-number {
        display: inline-block;
        width: 28px;
        height: 28px;
        line-height: 28px;
        text-align: center;
        background: #e9ecef;
        color: #495057;
        border-radius: 4px;
        font-size: 13px;
        font-weight: 600;
    }

    .key-tag {
        display: inline-block;
        padding: 4px 10px;
        background: #e7f3ff;
        color: #0056b3;
        border: 1px solid #b8daff;
        border-radius: 4px;
        font-family: 'Courier New', monospace;
        font-size: 13px;
        font-weight: 600;
    }

    .label-text {
        font-weight: 500;
        color: #212529;
    }

    .path-code {
        display: inline-block;
        padding: 4px 8px;
        background: #f6f8fa;
        border: 1px solid #e1e4e8;
        border-radius: 4px;
        color: #0056b3;
        font-size: 12px;
        font-family: 'Courier New', monospace;
        max-width: 300px;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }

    .path-code:hover {
        overflow: visible;
        white-space: normal;
        word-break: break-all;
        z-index: 10;
        position: relative;
    }

    .type-badge {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 6px 12px;
        border-radius: 8px;
        font-size: 12px;
        font-weight: 600;
        backdrop-filter: blur(10px);
        -webkit-backdrop-filter: blur(10px);
    }

    .type-badge.type-display {
        background: rgba(66, 153, 225, 0.15);
        color: #2b6cb0;
        border: 1px solid rgba(66, 153, 225, 0.3);
    }

    .type-badge.type-update {
        background: rgba(237, 137, 54, 0.15);
        color: #c05621;
        border: 1px solid rgba(237, 137, 54, 0.3);
    }

    .type-badge.type-both {
        background: rgba(72, 187, 120, 0.15);
        color: #276749;
        border: 1px solid rgba(72, 187, 120, 0.3);
    }

    .type-badge.type-config {
        background: rgba(155, 89, 182, 0.15);
        color: #6b46c1;
        border: 1px solid rgba(155, 89, 182, 0.3);
    }

    .status-indicator {
        display: inline-block;
        width: 24px;
        height: 24px;
        line-height: 24px;
        text-align: center;
        border-radius: 50%;
    }

    .status-indicator.required {
        background: #d4edda;
        color: #28a745;
    }

    .status-indicator.optional {
        background: #e9ecef;
        color: #6c757d;
    }

    .action-buttons {
        display: flex;
        justify-content: center;
        gap: 4px;
    }

    .btn-icon {
        width: 32px;
        height: 32px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border: 1px solid #dee2e6;
        background: #ffffff;
        border-radius: 4px;
        cursor: pointer;
        transition: all 0.2s;
    }

    .btn-icon:hover {
        background: #f8f9fa;
    }

    .btn-edit {
        color: #ffc107;
    }

    .btn-edit:hover {
        background: #fff3cd;
        border-color: #ffc107;
    }

    .btn-delete {
        color: #dc3545;
    }

    .btn-delete:hover {
        background: #f8d7da;
        border-color: #dc3545;
    }

    /* Empty State */
    .empty-state {
        text-align: center;
        padding: 48px 24px;
        color: #6c757d;
    }

    .empty-state i {
        font-size: 48px;
        margin-bottom: 16px;
        opacity: 0.3;
    }

    .empty-state p {
        margin: 0;
        font-size: 14px;
    }

    /* Modal Professional Design */
    .modal-content {
        border: none;
        border-radius: 8px;
        overflow: hidden;
    }

    .professional-header {
        background: #0056b3;
        color: white;
        padding: 20px;
        border: none;
    }

    .professional-header .close {
        color: white;
        opacity: 0.8;
        font-size: 24px;
    }

    .professional-header .close:hover {
        opacity: 1;
    }

    .modal-title {
        font-size: 18px;
        font-weight: 600;
    }

    .modal-body {
        padding: 0;
        background: #f8f9fa;
    }

    /* Form Layout Structure */
    .form-layout {
        padding: 25px;
    }

    .form-section {
        background: white;
        border-radius: 8px;
        margin-bottom: 20px;
        overflow: hidden;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
    }

    .form-section:last-child {
        margin-bottom: 0;
    }

    .section-header {
        background: #f6f8fa;
        padding: 12px 20px;
        border-bottom: 1px solid #e9ecef;
    }

    .section-title {
        font-size: 14px;
        font-weight: 600;
        color: #495057;
        margin: 0;
    }

    /* Form Grid untuk alignment yang sempurna */
    .form-grid {
        padding: 20px;
    }

    .form-group {
        display: grid;
        grid-template-columns: 150px 1fr;
        gap: 15px;
        align-items: start;
        margin-bottom: 18px;
    }

    .form-group:last-child {
        margin-bottom: 0;
    }

    .form-group.full-width {
        grid-template-columns: 150px 1fr;
    }

    .form-label {
        font-size: 13px;
        font-weight: 600;
        color: #495057;
        padding-top: 10px;
        text-align: right;
    }

    .input-wrapper {
        width: 100%;
    }

    .required {
        color: #dc3545;
        margin-left: 2px;
    }

    .custom-input {
        border: 2px solid #e9ecef;
        border-radius: 6px;
        padding: 10px 12px;
        font-size: 14px;
        transition: all 0.3s;
        width: 100%;
    }

    .custom-input:focus {
        border-color: #0056b3;
        box-shadow: 0 0 0 3px rgba(0, 86, 179, 0.1);
        outline: none;
    }

    .help-text {
        color: #6c757d;
        font-size: 12px;
        margin-top: 5px;
        display: block;
    }

    /* Category Selector */
    .category-selector {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 12px;
    }

    @media (min-width: 768px) {
        .category-selector {
            grid-template-columns: repeat(4, 1fr);
        }
    }

    .category-option {
        cursor: pointer;
    }

    .category-option input[type="radio"] {
        display: none;
    }

    .category-box {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 12px 15px;
        border: 2px solid #e9ecef;
        border-radius: 8px;
        background: white;
        transition: all 0.3s;
        font-size: 13px;
    }

    .category-box i {
        font-size: 18px;
        color: #6c757d;
        width: 20px;
        text-align: center;
    }

    .category-box span {
        flex: 1;
    }

    .category-option input[type="radio"]:checked+.category-box {
        border-color: #0056b3;
        background: #e7f3ff;
    }

    .category-option input[type="radio"]:checked+.category-box i {
        color: #0056b3;
    }

    /* Type Selector */
    .type-selector {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 10px;
    }

    .type-option {
        cursor: pointer;
    }

    .type-option input[type="radio"] {
        display: none;
    }

    .type-box {
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 10px 15px;
        border: 2px solid #e9ecef;
        border-radius: 6px;
        text-align: center;
        background: white;
        transition: all 0.3s;
        font-size: 13px;
        min-height: 40px;
    }

    .type-option input[type="radio"]:checked+.type-box {
        border-color: #0056b3;
        background: #0056b3;
        color: white;
    }

    /* Custom Checkbox */
    .custom-checkbox {
        display: flex;
        align-items: center;
        cursor: pointer;
        user-select: none;
    }

    .custom-checkbox input[type="checkbox"] {
        display: none;
    }

    .checkbox-box {
        width: 20px;
        height: 20px;
        border: 2px solid #dee2e6;
        border-radius: 4px;
        margin-right: 10px;
        position: relative;
        transition: all 0.3s;
        flex-shrink: 0;
    }

    .custom-checkbox input[type="checkbox"]:checked+.checkbox-box {
        background: #0056b3;
        border-color: #0056b3;
    }

    .custom-checkbox input[type="checkbox"]:checked+.checkbox-box:after {
        content: '\f00c';
        font-family: FontAwesome;
        color: white;
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        font-size: 12px;
    }

    .checkbox-label {
        font-size: 14px;
        color: #495057;
    }

    /* Path Hints */
    .path-hints {
        margin-top: 12px;
        display: flex;
        gap: 8px;
        flex-wrap: wrap;
    }

    .hint-badge {
        display: inline-block;
        padding: 6px 14px;
        background: #0056b3;
        color: white;
        border-radius: 15px;
        font-size: 11px;
        cursor: pointer;
        transition: all 0.2s;
    }

    .hint-badge:hover {
        background: #004494;
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0, 86, 179, 0.3);
    }

    /* Modal Footer */
    .modal-footer {
        background: white;
        border-top: 1px solid #e9ecef;
        padding: 15px 25px;
    }

    .btn-modal-cancel,
    .btn-modal-save {
        padding: 10px 20px;
        border-radius: 6px;
        font-size: 14px;
        font-weight: 500;
        border: none;
        transition: all 0.3s;
    }

    .btn-modal-cancel {
        background: #6c757d;
        color: white;
    }

    .btn-modal-cancel:hover {
        background: #5a6268;
        color: white;
    }

    .btn-modal-save {
        background: #28a745;
        color: white;
    }

    .btn-modal-save:hover {
        background: #218838;
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(40, 167, 69, 0.2);
        color: white;
    }

    .dark-mode .nav-wrapper,
    body.dark-mode .nav-wrapper {
        border-color: #30363d;
    }

    .dark-mode .nav-professional li a,
    body.dark-mode .nav-professional li a {
        color: #8b949e;
    }

    .dark-mode .nav-professional li a:hover,
    body.dark-mode .nav-professional li a:hover {
        background: #161b22;
        color: #e6edf3;
    }

    .dark-mode .nav-professional li.active a,
    body.dark-mode .nav-professional li.active a {
        color: #58a6ff;
        border-color: #58a6ff;
    }

    .dark-mode .data-table-container,
    body.dark-mode .data-table-container {
        background: #0d1117;
        border-color: #30363d;
    }

    .dark-mode .professional-table thead,
    body.dark-mode .professional-table thead {
        background: #161b22;
        border-color: #30363d;
    }

    .dark-mode .professional-table thead th,
    body.dark-mode .professional-table thead th {
        color: #8b949e;
    }

    .dark-mode .professional-table tbody tr,
    body.dark-mode .professional-table tbody tr {
        border-color: #21262d;
    }

    .dark-mode .professional-table tbody tr:hover,
    body.dark-mode .professional-table tbody tr:hover {
        background: #161b22;
    }

    .dark-mode .professional-table tbody td,
    body.dark-mode .professional-table tbody td {
        color: #e6edf3;
    }

    .dark-mode .order-number,
    body.dark-mode .order-number {
        background: #21262d;
        color: #8b949e;
    }

    .dark-mode .key-tag,
    body.dark-mode .key-tag {
        background: #1f2937;
        color: #58a6ff;
        border-color: #30363d;
    }

    .dark-mode .label-text,
    body.dark-mode .label-text {
        color: #e6edf3;
    }

    .dark-mode .path-code,
    body.dark-mode .path-code {
        background: #161b22;
        border-color: #30363d;
        color: #58a6ff;
    }

    .dark-mode .type-badge.type-display,
    body.dark-mode .type-badge.type-display {
        background: #1f2937;
        color: #79c0ff;
        border-color: #30363d;
    }

    .dark-mode .type-badge.type-update,
    body.dark-mode .type-badge.type-update {
        background: #2d2416;
        color: #d29922;
        border-color: #30363d;
    }

    .dark-mode .type-badge.type-both,
    body.dark-mode .type-badge.type-both {
        background: #1b2f23;
        color: #3fb950;
        border-color: #30363d;
    }

    .dark-mode .btn-icon,
    body.dark-mode .btn-icon {
        background: #21262d;
        border-color: #30363d;
    }

    .dark-mode .btn-icon:hover,
    body.dark-mode .btn-icon:hover {
        background: #30363d;
    }

    .dark-mode .empty-state,
    body.dark-mode .empty-state {
        color: #8b949e;
    }

    /* Dark Mode Modal */
    .dark-mode .modal-content,
    body.dark-mode .modal-content {
        background: #0d1117;
    }

    .dark-mode .professional-header,
    body.dark-mode .professional-header {
        background: #161b22;
    }

    .dark-mode .modal-body,
    body.dark-mode .modal-body {
        background: #0d1117;
    }

    .dark-mode .form-layout,
    body.dark-mode .form-layout {
        background: #0d1117;
    }

    .dark-mode .form-section,
    body.dark-mode .form-section {
        background: #161b22;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
    }

    .dark-mode .section-header,
    body.dark-mode .section-header {
        background: #0d1117;
        border-color: #30363d;
    }

    .dark-mode .section-title,
    body.dark-mode .section-title {
        color: #e4e6eb;
    }

    .dark-mode .form-label,
    body.dark-mode .form-label {
        color: #e4e6eb;
    }

    .dark-mode .custom-input,
    body.dark-mode .custom-input {
        background: #0d1117;
        border-color: #30363d;
        color: #e4e6eb;
    }

    .dark-mode .custom-input:focus,
    body.dark-mode .custom-input:focus {
        border-color: #58a6ff;
        box-shadow: 0 0 0 3px rgba(88, 166, 255, 0.2);
    }

    .dark-mode .category-box,
    body.dark-mode .category-box,
    .dark-mode .type-box,
    body.dark-mode .type-box {
        background: #0d1117;
        border-color: #30363d;
        color: #e4e6eb;
    }

    .dark-mode .category-option input[type="radio"]:checked+.category-box,
    body.dark-mode .category-option input[type="radio"]:checked+.category-box {
        background: #1f2937;
        border-color: #58a6ff;
    }

    .dark-mode .type-option input[type="radio"]:checked+.type-box,
    body.dark-mode .type-option input[type="radio"]:checked+.type-box {
        background: #58a6ff;
        color: white;
    }

    .dark-mode .checkbox-label,
    body.dark-mode .checkbox-label {
        color: #e4e6eb;
    }

    .dark-mode .help-text,
    body.dark-mode .help-text {
        color: #8b92a8;
    }

    .dark-mode .modal-footer,
    body.dark-mode .modal-footer {
        background: #161b22;
        border-color: #30363d;
    }

    .dark-mode .hint-badge,
    body.dark-mode .hint-badge {
        background: #1f6feb;
    }

    .dark-mode .hint-badge:hover,
    body.dark-mode .hint-badge:hover {
        background: #58a6ff;
    }

    /* Responsive Design */
    @media (max-width: 992px) {
        .reference-grid {
            grid-template-columns: 1fr;
        }

        .nav-wrapper {
            flex-direction: column;
            align-items: stretch;
        }

        .nav-professional {
            order: 2;
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
            margin-bottom: 0;
        }

        .nav-actions {
            order: 1;
            justify-content: flex-end;
            padding-bottom: 12px;
            margin-bottom: 12px;
            border-bottom: 1px solid #dee2e6;
        }

        .col-path,
        .col-type {
            display: none;
        }

        .professional-table thead th:nth-child(4),
        .professional-table thead th:nth-child(5),
        .professional-table tbody td:nth-child(4),
        .professional-table tbody td:nth-child(5) {
            display: none;
        }
    }

    @media (max-width: 768px) {
        .form-group {
            grid-template-columns: 1fr;
            gap: 8px;
        }

        .form-label {
            text-align: left;
            padding-top: 0;
        }

        .category-selector {
            grid-template-columns: 1fr;
        }

        .type-selector {
            grid-template-columns: 1fr;
        }
    }

    @media (max-width: 576px) {
        .reference-header {
            padding: 12px 16px;
        }

        .reference-title {
            font-size: 14px;
        }

        .nav-professional li a {
            padding: 10px 16px;
        }

        .nav-professional li a span {
            font-size: 13px;
        }

        .btn-text {
            display: none;
        }

        .btn {
            padding: 8px 12px;
        }

        .col-order,
        .col-required {
            display: none;
        }

        .professional-table thead th:nth-child(1),
        .professional-table thead th:nth-child(6),
        .professional-table tbody td:nth-child(1),
        .professional-table tbody td:nth-child(6) {
            display: none;
        }

        .professional-table thead th {
            padding: 12px;
            font-size: 11px;
        }

        .professional-table tbody td {
            padding: 10px 12px;
            font-size: 13px;
        }

        .key-tag {
            font-size: 11px;
            padding: 3px 6px;
        }
    }
     /* ============================================
       Config Cards Style
       ============================================ */
    .config-cards-container {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
        gap: 20px;
        padding: 10px 0;
    }

    .config-card {
        background: #ffffff;
        border-radius: 12px;
        border: 1px solid #e2e8f0;
        overflow: hidden;
        transition: all 0.3s ease;
        box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    }

    .config-card:hover {
        box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        transform: translateY(-4px);
    }

    .config-card-header {
        display: flex;
        align-items: center;
        gap: 15px;
        padding: 20px;
        background: linear-gradient(135deg, rgba(155, 89, 182, 0.05) 0%, rgba(142, 68, 173, 0.1) 100%);
        border-bottom: 1px solid #e2e8f0;
    }

    .config-icon {
        width: 50px;
        height: 50px;
        display: flex;
        align-items: center;
        justify-content: center;
        background: linear-gradient(135deg, #9b59b6 0%, #8e44ad 100%);
        border-radius: 12px;
        color: white;
        font-size: 20px;
        box-shadow: 0 4px 15px rgba(155, 89, 182, 0.3);
    }

    .config-title {
        flex: 1;
    }

    .config-title h4 {
        margin: 0 0 4px 0;
        font-size: 16px;
        font-weight: 600;
        color: #2d3748;
    }

    .config-key {
        font-size: 12px;
        color: #718096;
        font-family: 'Courier New', monospace;
        background: #f7fafc;
        padding: 2px 8px;
        border-radius: 4px;
    }

    .config-actions {
        display: flex;
        gap: 8px;
    }

    .config-card-body {
        padding: 20px;
    }

    .config-value-display label {
        display: block;
        font-size: 12px;
        color: #718096;
        margin-bottom: 8px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .config-value {
        padding: 14px 18px;
        background: #f7fafc;
        border: 1px solid #e2e8f0;
        border-radius: 10px;
        font-family: 'Courier New', monospace;
        font-size: 14px;
        color: #667eea;
        font-weight: 500;
    }

    .config-value.empty {
        color: #a0aec0;
        font-style: italic;
        font-family: inherit;
    }

    .config-preview {
        margin-top: 12px;
        padding: 12px 16px;
        background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
        border-radius: 8px;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .preview-label {
        font-size: 12px;
        color: #718096;
    }

    .preview-value {
        font-family: 'Courier New', monospace;
        font-size: 13px;
        color: #5a67d8;
        font-weight: 600;
    }

    .config-card-footer {
        padding: 12px 20px;
        background: #f7fafc;
        border-top: 1px solid #e2e8f0;
    }

    .config-badge {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 6px 14px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 600;
    }

    .badge-2g {
        background: rgba(66, 153, 225, 0.15);
        color: #3182ce;
    }

    .badge-5g {
        background: rgba(72, 187, 120, 0.15);
        color: #38a169;
    }

    /* ============================================
       Dark Mode Support for Config Cards
       ============================================ */
    .dark-mode .config-card,
    body.dark-mode .config-card {
        background: #1e293b;
        border-color: #334155;
    }

    .dark-mode .config-card:hover,
    body.dark-mode .config-card:hover {
        box-shadow: 0 10px 25px rgba(0,0,0,0.4);
    }

    .dark-mode .config-card-header,
    body.dark-mode .config-card-header {
        background: linear-gradient(135deg, rgba(155, 89, 182, 0.15) 0%, rgba(142, 68, 173, 0.2) 100%);
        border-bottom-color: #334155;
    }

    .dark-mode .config-title h4,
    body.dark-mode .config-title h4 {
        color: #f1f5f9;
    }

    .dark-mode .config-key,
    body.dark-mode .config-key {
        color: #94a3b8;
        background: #334155;
    }

    .dark-mode .config-card-body,
    body.dark-mode .config-card-body {
        background: #1e293b;
    }

    .dark-mode .config-value-display label,
    body.dark-mode .config-value-display label {
        color: #94a3b8;
    }

    .dark-mode .config-value,
    body.dark-mode .config-value {
        background: #0f172a;
        border-color: #334155;
        color: #a78bfa;
    }

    .dark-mode .config-value.empty,
    body.dark-mode .config-value.empty {
        color: #64748b;
    }

    .dark-mode .config-preview,
    body.dark-mode .config-preview {
        background: linear-gradient(135deg, rgba(102, 126, 234, 0.2) 0%, rgba(118, 75, 162, 0.2) 100%);
    }

    .dark-mode .preview-label,
    body.dark-mode .preview-label {
        color: #94a3b8;
    }

    .dark-mode .preview-value,
    body.dark-mode .preview-value {
        color: #c4b5fd;
    }

    .dark-mode .config-card-footer,
    body.dark-mode .config-card-footer {
        background: #0f172a;
        border-top-color: #334155;
    }

    .dark-mode .badge-2g,
    body.dark-mode .badge-2g {
        background: rgba(66, 153, 225, 0.25);
        color: #7dd3fc;
    }

    .dark-mode .badge-5g,
    body.dark-mode .badge-5g {
        background: rgba(72, 187, 120, 0.25);
        color: #86efac;
    }
    .param-cards-container {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
        gap: 20px;
        padding: 10px 0;
    }

    .param-card {
        background: #ffffff;
        border-radius: 12px;
        border: 1px solid #e2e8f0;
        overflow: hidden;
        transition: all 0.3s ease;
        box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    }

    .param-card:hover {
        box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        transform: translateY(-4px);
    }

    /* Basic Card - Blue Theme */
    .param-card-basic .param-card-header {
        background: linear-gradient(135deg, rgba(66, 153, 225, 0.08) 0%, rgba(49, 130, 206, 0.15) 100%);
        border-bottom: 1px solid rgba(66, 153, 225, 0.2);
    }

    .param-card-basic .param-icon {
        background: linear-gradient(135deg, #4299e1 0%, #3182ce 100%);
        box-shadow: 0 4px 15px rgba(66, 153, 225, 0.3);
    }

    .param-card-header {
        display: flex;
        align-items: center;
        gap: 15px;
        padding: 18px 20px;
    }

    .param-icon {
        width: 48px;
        height: 48px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 12px;
        color: white;
        font-size: 18px;
        flex-shrink: 0;
    }

    .param-title {
        flex: 1;
        min-width: 0;
    }

    .param-title h4 {
        margin: 0 0 4px 0;
        font-size: 15px;
        font-weight: 600;
        color: #2d3748;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    .param-key {
        font-size: 11px;
        color: #718096;
        font-family: 'Courier New', monospace;
        background: rgba(0,0,0,0.05);
        padding: 2px 8px;
        border-radius: 4px;
        display: inline-block;
    }

    .param-actions {
        display: flex;
        gap: 6px;
        flex-shrink: 0;
    }

    .param-card-body {
        padding: 16px 20px;
    }

    .param-info-row {
        display: flex;
        flex-direction: column;
        gap: 12px;
    }

    .param-info-item {
        display: flex;
        flex-direction: column;
        gap: 6px;
    }

    .param-info-item label {
        font-size: 11px;
        color: #718096;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        margin: 0;
    }

    .param-path-value {
        display: block;
        padding: 10px 14px;
        background: #f7fafc;
        border: 1px solid #e2e8f0;
        border-radius: 8px;
        font-family: 'Courier New', monospace;
        font-size: 12px;
        color: #4299e1;
        word-break: break-all;
        line-height: 1.5;
    }

    .param-card-footer {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 12px 20px;
        background: #f8fafc;
        border-top: 1px solid #e2e8f0;
        flex-wrap: wrap;
    }

    .required-badge {
        display: inline-flex;
        align-items: center;
        gap: 4px;
        padding: 4px 10px;
        background: rgba(72, 187, 120, 0.15);
        color: #276749;
        border-radius: 6px;
        font-size: 11px;
        font-weight: 600;
    }

    .order-badge-small {
        margin-left: auto;
        padding: 4px 10px;
        background: #edf2f7;
        color: #718096;
        border-radius: 6px;
        font-size: 11px;
        font-weight: 600;
    }

    .empty-state-card {
        grid-column: 1 / -1;
        text-align: center;
        padding: 60px 30px;
        background: linear-gradient(135deg, #f7fafc 0%, #ffffff 100%);
        border-radius: 12px;
        border: 2px dashed #e2e8f0;
    }

    .empty-state-card i {
        font-size: 48px;
        color: #cbd5e0;
        margin-bottom: 16px;
    }

    .empty-state-card h4 {
        margin: 0 0 8px 0;
        font-size: 18px;
        color: #4a5568;
    }

    .empty-state-card p {
        margin: 0;
        font-size: 14px;
        color: #718096;
    }

    /* Mobile Responsive for Param Cards */
    @media (max-width: 768px) {
        .param-cards-container {
            grid-template-columns: 1fr;
        }
        
        .param-card-header {
            flex-wrap: wrap;
            gap: 12px;
        }
        
        .param-icon {
            width: 42px;
            height: 42px;
            font-size: 16px;
        }
        
        .param-title h4 {
            font-size: 14px;
        }
        
        .param-card-footer {
            flex-wrap: wrap;
        }
        
        .order-badge-small {
            margin-left: 0;
        }
    }

    /* ============================================
       Dark Mode Support for Param Cards
       ============================================ */
    .dark-mode .param-card,
    body.dark-mode .param-card {
        background: #1e293b;
        border-color: #334155;
    }

    .dark-mode .param-card:hover,
    body.dark-mode .param-card:hover {
        box-shadow: 0 10px 25px rgba(0,0,0,0.4);
    }

    .dark-mode .param-card-basic .param-card-header,
    body.dark-mode .param-card-basic .param-card-header {
        background: linear-gradient(135deg, rgba(66, 153, 225, 0.15) 0%, rgba(49, 130, 206, 0.25) 100%);
        border-bottom-color: rgba(66, 153, 225, 0.3);
    }

    .dark-mode .param-title h4,
    body.dark-mode .param-title h4 {
        color: #f1f5f9;
    }

    .dark-mode .param-key,
    body.dark-mode .param-key {
        color: #94a3b8;
        background: rgba(255,255,255,0.1);
    }

    .dark-mode .param-card-body,
    body.dark-mode .param-card-body {
        background: #1e293b;
    }

    .dark-mode .param-info-item label,
    body.dark-mode .param-info-item label {
        color: #94a3b8;
    }

    .dark-mode .param-path-value,
    body.dark-mode .param-path-value {
        background: #0f172a;
        border-color: #334155;
        color: #7dd3fc;
    }

    .dark-mode .param-card-footer,
    body.dark-mode .param-card-footer {
        background: #0f172a;
        border-top-color: #334155;
    }

    .dark-mode .required-badge,
    body.dark-mode .required-badge {
        background: rgba(72, 187, 120, 0.25);
        color: #86efac;
    }

    .dark-mode .order-badge-small,
    body.dark-mode .order-badge-small {
        background: #334155;
        color: #94a3b8;
    }

    .dark-mode .empty-state-card,
    body.dark-mode .empty-state-card {
        background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
        border-color: #334155;
    }

    .dark-mode .empty-state-card i,
    body.dark-mode .empty-state-card i {
        color: #475569;
    }

    .dark-mode .empty-state-card h4,
    body.dark-mode .empty-state-card h4 {
        color: #e2e8f0;
    }

    .dark-mode .empty-state-card p,
    body.dark-mode .empty-state-card p {
        color: #94a3b8;
    }
    /* ============================================
       WiFi Card Theme - Green
       ============================================ */
    .param-card-wifi .param-card-header {
        background: linear-gradient(135deg, rgba(72, 187, 120, 0.08) 0%, rgba(56, 161, 105, 0.15) 100%);
        border-bottom: 1px solid rgba(72, 187, 120, 0.2);
    }

    .param-card-wifi .param-icon,
    .icon-wifi {
        background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
        box-shadow: 0 4px 15px rgba(72, 187, 120, 0.3);
    }

    .band-badge {
        display: inline-flex;
        align-items: center;
        gap: 4px;
        padding: 4px 10px;
        border-radius: 6px;
        font-size: 11px;
        font-weight: 600;
    }

    .band-badge.badge-2g {
        background: rgba(66, 153, 225, 0.15);
        color: #3182ce;
    }

    .band-badge.badge-5g {
        background: rgba(159, 122, 234, 0.15);
        color: #805ad5;
    }

    /* ============================================
       Dark Mode Support for WiFi Cards
       ============================================ */
    .dark-mode .param-card-wifi .param-card-header,
    body.dark-mode .param-card-wifi .param-card-header {
        background: linear-gradient(135deg, rgba(72, 187, 120, 0.15) 0%, rgba(56, 161, 105, 0.25) 100%);
        border-bottom-color: rgba(72, 187, 120, 0.3);
    }

    .dark-mode .band-badge.badge-2g,
    body.dark-mode .band-badge.badge-2g {
        background: rgba(66, 153, 225, 0.25);
        color: #7dd3fc;
    }

    .dark-mode .band-badge.badge-5g,
    body.dark-mode .band-badge.badge-5g {
        background: rgba(159, 122, 234, 0.25);
        color: #c4b5fd;
    }
    /* ============================================
       WebAdmin Card Theme - Red
       ============================================ */
    .param-card-webadmin .param-card-header {
        background: linear-gradient(135deg, rgba(245, 101, 101, 0.08) 0%, rgba(229, 62, 62, 0.15) 100%);
        border-bottom: 1px solid rgba(245, 101, 101, 0.2);
    }

    .param-card-webadmin .param-icon,
    .icon-webadmin {
        background: linear-gradient(135deg, #f56565 0%, #e53e3e 100%);
        box-shadow: 0 4px 15px rgba(245, 101, 101, 0.3);
    }

    /* ============================================
       Dark Mode Support for WebAdmin Cards
       ============================================ */
    .dark-mode .param-card-webadmin .param-card-header,
    body.dark-mode .param-card-webadmin .param-card-header {
        background: linear-gradient(135deg, rgba(245, 101, 101, 0.15) 0%, rgba(229, 62, 62, 0.25) 100%);
        border-bottom-color: rgba(245, 101, 101, 0.3);
    }
    /* ============================================
       NEW MODERN MODAL STYLES
       ============================================ */
    .modal-overlay {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(0, 0, 0, 0.6);
        backdrop-filter: blur(4px);
        z-index: 9999;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 20px;
        overflow-y: auto;
    }

    .modal-container {
        background: #ffffff;
        border-radius: 16px;
        width: 100%;
        max-width: 600px;
        max-height: 90vh;
        overflow: hidden;
        box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
        animation: modalSlideIn 0.3s ease-out;
        display: flex;
        flex-direction: column;
    }

    @keyframes modalSlideIn {
        from {
            opacity: 0;
            transform: translateY(-20px) scale(0.95);
        }
        to {
            opacity: 1;
            transform: translateY(0) scale(1);
        }
    }

    .modal-header-new {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 20px 24px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
    }

    .modal-header-new h4 {
        margin: 0;
        font-size: 18px;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .modal-close-btn {
        background: rgba(255, 255, 255, 0.2);
        border: none;
        color: white;
        width: 36px;
        height: 36px;
        border-radius: 50%;
        font-size: 24px;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.2s;
    }

    .modal-close-btn:hover {
        background: rgba(255, 255, 255, 0.3);
        transform: rotate(90deg);
    }

    .modal-body-new {
        padding: 24px;
        overflow-y: auto;
        flex: 1;
    }

    .form-section-new {
        background: #f8fafc;
        border: 1px solid #e2e8f0;
        border-radius: 12px;
        padding: 20px;
        margin-bottom: 20px;
    }

    .form-section-new:last-child {
        margin-bottom: 0;
    }

    .form-section-header-new {
        display: flex;
        align-items: center;
        gap: 10px;
        margin-bottom: 16px;
        padding-bottom: 12px;
        border-bottom: 2px solid #e2e8f0;
    }

    .form-section-header-new i {
        width: 32px;
        height: 32px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 14px;
    }

    .form-section-header-new span {
        font-size: 15px;
        font-weight: 600;
        color: #1e293b;
    }

    .form-group-new {
        margin-bottom: 16px;
    }

    .form-group-new:last-child {
        margin-bottom: 0;
    }

    .form-group-new label {
        display: block;
        font-size: 13px;
        font-weight: 600;
        color: #374151;
        margin-bottom: 6px;
    }

    .form-control-new {
        width: 100%;
        padding: 12px 14px;
        border: 2px solid #e2e8f0;
        border-radius: 10px;
        font-size: 14px;
        transition: all 0.2s;
        background: #ffffff;
    }

    .form-control-new:focus {
        outline: none;
        border-color: #667eea;
        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    }

    .form-control-new::placeholder {
        color: #9ca3af;
    }

    .form-help-new {
        display: block;
        font-size: 12px;
        color: #64748b;
        margin-top: 6px;
    }

    .form-help-new i {
        margin-right: 4px;
    }

    .text-danger {
        color: #ef4444;
    }

    /* Category Grid */
    .category-grid-new {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 10px;
    }

    .category-card-new {
        cursor: pointer;
    }

    .category-card-new input {
        display: none;
    }

    .category-card-content {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        padding: 14px 10px;
        background: #ffffff;
        border: 2px solid #e2e8f0;
        border-radius: 10px;
        transition: all 0.2s;
        gap: 6px;
    }

    .category-card-content i {
        font-size: 20px;
        color: #64748b;
    }

    .category-card-content span {
        font-size: 12px;
        font-weight: 500;
        color: #64748b;
    }

    .category-card-new input:checked + .category-card-content {
        border-color: #667eea;
        background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
    }

    .category-card-new input:checked + .category-card-content i,
    .category-card-new input:checked + .category-card-content span {
        color: #667eea;
    }

    /* Type Grid */
    .type-grid-new {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 10px;
    }

    .type-card-new {
        cursor: pointer;
    }

    .type-card-new input {
        display: none;
    }

    .type-card-content {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        padding: 12px 8px;
        background: #ffffff;
        border: 2px solid #e2e8f0;
        border-radius: 10px;
        transition: all 0.2s;
        gap: 4px;
    }

    .type-card-content i {
        font-size: 16px;
        color: #64748b;
    }

    .type-card-content span {
        font-size: 11px;
        font-weight: 500;
        color: #64748b;
    }

    .type-card-new input:checked + .type-card-content {
        border-color: #22c55e;
        background: rgba(34, 197, 94, 0.1);
    }

    .type-card-new input:checked + .type-card-content i,
    .type-card-new input:checked + .type-card-content span {
        color: #22c55e;
    }

    /* Checkbox - More Visible Design */
    .checkbox-container-new {
        display: inline-flex;
        flex-direction: row;
        align-items: center;
        justify-content: flex-start;
        cursor: pointer;
        font-size: 14px;
        user-select: none;
        padding: 12px 16px;
        background: #ffffff;
        border-radius: 10px;
        border: 2px solid #e2e8f0;
        transition: all 0.2s;
        gap: 10px;
        width: 100%;
        box-sizing: border-box;
    }

    .checkbox-container-new:hover {
        border-color: #667eea;
        background: #f8fafc;
    }

    .checkbox-container-new input[type="checkbox"] {
        width: 18px;
        height: 18px;
        min-width: 18px;
        min-height: 18px;
        max-width: 18px;
        max-height: 18px;
        margin: 0;
        padding: 0;
        cursor: pointer;
        accent-color: #22c55e;
        flex-shrink: 0;
        vertical-align: middle;
    }

    .checkbox-text-new {
        color: #374151;
        font-weight: 500;
        line-height: 18px;
        vertical-align: middle;
        margin: 0;
        padding: 0;
    }

    /* Container berubah saat checked */
    .checkbox-container-new:has(input:checked) {
        border-color: #22c55e;
        background: rgba(34, 197, 94, 0.05);
    }

    .checkbox-container-new:has(input:checked) .checkbox-text-new {
        color: #16a34a;
        font-weight: 600;
    }

    /* Dark Mode Checkbox */
    .dark-mode .checkbox-container-new,
    body.dark-mode .checkbox-container-new {
        background: #1e293b;
        border-color: #334155;
    }

    .dark-mode .checkbox-text-new,
    body.dark-mode .checkbox-text-new {
        color: #e2e8f0;
    }

    .dark-mode .checkbox-container-new:has(input:checked),
    body.dark-mode .checkbox-container-new:has(input:checked) {
        border-color: #22c55e;
        background: rgba(34, 197, 94, 0.1);
    }

    .dark-mode .checkbox-container-new:has(input:checked) .checkbox-text-new,
    body.dark-mode .checkbox-container-new:has(input:checked) .checkbox-text-new {
        color: #4ade80;
    }

    /* Path Hints */
    .path-hints-new {
        display: flex;
        flex-wrap: wrap;
        gap: 8px;
        margin-top: 12px;
    }

    .hint-tag {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 8px 14px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.2s;
    }

    .hint-tag:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
    }

    .hint-tag i {
        font-size: 10px;
    }

    /* Modal Footer */
    .modal-footer-new {
        display: flex;
        justify-content: flex-end;
        gap: 12px;
        padding: 16px 24px;
        background: #f8fafc;
        border-top: 1px solid #e2e8f0;
    }

    .btn-cancel-new,
    .btn-save-new {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        padding: 12px 24px;
        border-radius: 10px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s;
        border: none;
    }

    .btn-cancel-new {
        background: #6b7280;
        color: white;
    }

    .btn-cancel-new:hover {
        background: #4b5563;
    }

    .btn-save-new {
        background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
        color: white;
    }

    .btn-save-new:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(34, 197, 94, 0.4);
    }

    /* Dark Mode Modal */
    .dark-mode .modal-container,
    body.dark-mode .modal-container {
        background: #1e293b;
    }

    .dark-mode .modal-body-new,
    body.dark-mode .modal-body-new {
        background: #1e293b;
    }

    .dark-mode .form-section-new,
    body.dark-mode .form-section-new {
        background: #0f172a;
        border-color: #334155;
    }

    .dark-mode .form-section-header-new,
    body.dark-mode .form-section-header-new {
        border-bottom-color: #334155;
    }

    .dark-mode .form-section-header-new span,
    body.dark-mode .form-section-header-new span {
        color: #e2e8f0;
    }

    .dark-mode .form-group-new label,
    body.dark-mode .form-group-new label {
        color: #e2e8f0;
    }

    .dark-mode .form-control-new,
    body.dark-mode .form-control-new {
        background: #1e293b;
        border-color: #334155;
        color: #e2e8f0;
    }

    .dark-mode .form-help-new,
    body.dark-mode .form-help-new {
        color: #94a3b8;
    }

    .dark-mode .category-card-content,
    body.dark-mode .category-card-content,
    .dark-mode .type-card-content,
    body.dark-mode .type-card-content {
        background: #1e293b;
        border-color: #334155;
    }

    .dark-mode .checkbox-container-new,
    body.dark-mode .checkbox-container-new {
        background: #1e293b;
        border-color: #334155;
    }

    .dark-mode .checkbox-text-new,
    body.dark-mode .checkbox-text-new {
        color: #e2e8f0;
    }

    .dark-mode .modal-footer-new,
    body.dark-mode .modal-footer-new {
        background: #0f172a;
        border-top-color: #334155;
    }

    /* Responsive Mobile */
    @media (max-width: 640px) {
        .modal-overlay {
            padding: 10px;
        }

        .modal-container {
            max-height: 95vh;
            border-radius: 12px;
        }

        .modal-header-new {
            padding: 16px 18px;
        }

        .modal-header-new h4 {
            font-size: 16px;
        }

        .modal-body-new {
            padding: 16px;
        }

        .form-section-new {
            padding: 16px;
        }

        .category-grid-new {
            grid-template-columns: repeat(2, 1fr);
        }

        .type-grid-new {
            grid-template-columns: repeat(2, 1fr);
        }

        .modal-footer-new {
            flex-direction: column;
            padding: 16px;
        }

        .btn-cancel-new,
        .btn-save-new {
            width: 100%;
            justify-content: center;
        }
    }

    /* Tablet */
    @media (min-width: 641px) and (max-width: 1024px) {
        .modal-container {
            max-width: 550px;
        }

        .category-grid-new {
            grid-template-columns: repeat(4, 1fr);
        }

        .type-grid-new {
            grid-template-columns: repeat(4, 1fr);
        }
    }
</style>

<script>
    var editMode = false;

    function showAddModal() {
        editMode = false;
        document.getElementById('modalTitle').innerHTML = '<i class="fa fa-plus-circle"></i> Add Parameter';
        document.getElementById('parameterForm').action = '{$_url}plugin/genieacs_parameters/save';
        document.getElementById('parameterForm').reset();
        document.getElementById('param_id').value = 0;
        document.getElementById('param_key').readOnly = false;
        // Set default radio buttons
        document.querySelector('input[name="param_category"][value="basic"]').checked = true;
        document.querySelector('input[name="param_type"][value="both"]').checked = true;
        // Show modal
        document.getElementById('parameterModalOverlay').style.display = 'flex';
        document.body.style.overflow = 'hidden';
        setTimeout(updatePathRequired, 100);
    }

    function editParameter(id, key, label, path, type, category, required, order) {
        editMode = true;
        document.getElementById('modalTitle').innerHTML = '<i class="fa fa-edit"></i> Edit Parameter';
        document.getElementById('parameterForm').action = '{$_url}plugin/genieacs_parameters/update';
        document.getElementById('param_id').value = id;
        document.getElementById('param_key').value = key;
        document.getElementById('param_key').readOnly = true;
        document.getElementById('param_label').value = label;
        document.getElementById('param_path').value = path;
        document.getElementById('display_order').value = order;
        // Set radio buttons
        var typeRadio = document.querySelector('input[name="param_type"][value="' + type + '"]');
        if (typeRadio) typeRadio.checked = true;
        var categoryRadio = document.querySelector('input[name="param_category"][value="' + category + '"]');
        if (categoryRadio) categoryRadio.checked = true;
        document.getElementById('is_required').checked = (required == 1);
        // Show modal
        document.getElementById('parameterModalOverlay').style.display = 'flex';
        document.body.style.overflow = 'hidden';
        setTimeout(updatePathRequired, 100);
    }

    function closeParameterModal() {
        document.getElementById('parameterModalOverlay').style.display = 'none';
        document.body.style.overflow = 'auto';
    }

    // Close modal when clicking overlay
    document.getElementById('parameterModalOverlay').addEventListener('click', function(e) {
        if (e.target === this) {
            closeParameterModal();
        }
    });

    // Close modal with Escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeParameterModal();
        }
    });

    function deleteParameter(id) {
        Swal.fire({
            title: 'Delete Parameter?',
            text: 'This action cannot be undone!',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            confirmButtonText: 'Yes, delete it!'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = '{$_url}plugin/genieacs_parameters/delete/' + id;
            }
        });
    }

    function insertPath(prefix) {
        var input = document.getElementById('param_path');
        input.value = prefix;
        input.focus();
    }

    // Toggle required indicator based on category
    function updatePathRequired() {
        var selectedCategory = document.querySelector('input[name="param_category"]:checked');
        var pathRequired = document.getElementById('path-required');
        var paramPath = document.getElementById('param_path');
        
        if (selectedCategory && selectedCategory.value === 'config') {
            if (pathRequired) pathRequired.style.display = 'none';
            if (paramPath) paramPath.removeAttribute('required');
        } else {
            if (pathRequired) pathRequired.style.display = 'inline';
            if (paramPath) paramPath.setAttribute('required', 'required');
        }
    }

    // Listen for category change (vanilla JS)
    document.addEventListener('DOMContentLoaded', function() {
        var categoryInputs = document.querySelectorAll('input[name="param_category"]');
        categoryInputs.forEach(function(input) {
            input.addEventListener('change', updatePathRequired);
        });
        
        // ============================================
        // STAY ON ACTIVE TAB AFTER RELOAD
        // ============================================
        
        // Save active tab to localStorage when tab is clicked
        var tabLinks = document.querySelectorAll('a[data-toggle="tab"]');
        tabLinks.forEach(function(tabLink) {
            tabLink.addEventListener('click', function(e) {
                var activeTab = this.getAttribute('href');
                localStorage.setItem('genieacs_params_active_tab', activeTab);
            });
        });
        
        // Restore active tab on page load
        var savedTab = localStorage.getItem('genieacs_params_active_tab');
        if (savedTab) {
            var tabToActivate = document.querySelector('a[data-toggle="tab"][href="' + savedTab + '"]');
            if (tabToActivate) {
                // Remove active from all tabs
                document.querySelectorAll('.nav-professional li').forEach(function(li) {
                    li.classList.remove('active');
                });
                document.querySelectorAll('.tab-pane').forEach(function(pane) {
                    pane.classList.remove('active');
                });
                
                // Add active to saved tab
                tabToActivate.parentElement.classList.add('active');
                var targetPane = document.querySelector(savedTab);
                if (targetPane) {
                    targetPane.classList.add('active');
                }
            }
        }
    });

    // Update on modal show - gunakan event delegation
    document.addEventListener('click', function(e) {
        if (e.target && (e.target.matches('[onclick*="showAddModal"]') || e.target.matches('[onclick*="editParameter"]') || e.target.closest('[onclick*="showAddModal"]') || e.target.closest('[onclick*="editParameter"]'))) {
            setTimeout(updatePathRequired, 100);
        }
    });
</script>

{include file="sections/footer.tpl"}