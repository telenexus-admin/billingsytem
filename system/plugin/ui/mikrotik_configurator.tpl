{include file="sections/header.tpl"}

<div class="row">
    <div class="col-sm-12">
        <div class="panel panel-hovered mb20 panel-primary" style="border-color: #f97316;">
            <div class="panel-heading" style="background: linear-gradient(145deg, #f97316, #ea580c); color: white; border-color: #f97316;">
                <div class="btn-group pull-right">
                    <button class="btn btn-warning btn-xs" style="background: rgba(255,255,255,0.2); border-color: transparent; color: white;" title="Help" onclick="showHelp()">
                        <span class="glyphicon glyphicon-question-sign"></span>
                    </button>
                </div>
                <i class="fa fa-wifi"></i> MikroTik Router Configurator
            </div>
            <div class="panel-body">

                {if $action == 'routers'}
                    <!-- Router Selection Page (Similar to your screenshots) -->
                    <div class="row">
                        <div class="col-md-12">
                            <h4 style="color: #f97316;"><i class="fa fa-router"></i> Available MikroTik Routers</h4>
                            <p class="text-muted">Select a router to configure hotspot services</p>
                            <hr style="border-color: #f97316;">
                        </div>
                    </div>

                    <div class="row">
                        {foreach $routers as $router}
                            <div class="col-md-6 col-lg-4">
                                <div class="panel panel-default router-card" style="border-color: #f97316; border-width: 1px;">
                                    <div class="panel-body text-center">
                                        <div class="router-icon">
                                            <i class="fa fa-router fa-3x {if $router.status == 'Online'}text-warning{else}text-muted{/if}" style="color: {if $router.status == 'Online'}#f97316{else}#95a5a6{/if};"></i>
                                        </div>
                                        <h4 class="router-name" style="color: #f97316;">
                                            <i class="fa fa-wifi"></i> {$router.name}
                                        </h4>
                                        <p class="router-details">
                                            <strong>IP:</strong> {$router.ip_address}<br>
                                            <strong>Status:</strong> 
                                            <span class="label {if $router.status == 'Online'}label-warning{else}label-default{/if}" {if $router.status == 'Online'}style="background: #f97316;"{/if}>
                                                {$router.status}
                                            </span>
                                        </p>
                                        {if $router.description}
                                            <p class="text-muted">{$router.description}</p>
                                        {/if}
                                        <div class="router-actions">
                                            <a href="{$_url}plugin/mikrotik_configurator&action=configure&router_id={$router.id}" 
                                               class="btn btn-warning btn-block" style="background: #f97316; border-color: #ea580c;">
                                                <i class="fa fa-cogs"></i> Configure {$router.name} MikroTik
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        {/foreach}
                    </div>

                    {if !$routers}
                        <div class="alert alert-warning text-center" style="background: #fff3e0; border-color: #f97316; color: #f97316;">
                            <i class="fa fa-exclamation-triangle fa-2x"></i>
                            <h4>No Routers Found</h4>
                            <p>No enabled MikroTik routers are available for configuration.</p>
                            <p>Please ensure routers are added and enabled in the system.</p>
                        </div>
                    {/if}

                {elseif $action == 'configure'}
                    <!-- Router Configuration Page -->
                    <div class="row">
                        <div class="col-md-12">
                            <h4 style="color: #f97316;"><i class="fa fa-cogs"></i> Configure Router: {$router->name}</h4>
                            <p class="text-muted">Setup hotspot configuration for {$router->ip_address}</p>
                            <hr style="border-color: #f97316;">
                        </div>
                    </div>

                    <div class="row" id="configurationContainer">
                        <!-- Router Details -->
                        <div class="col-md-4">
                            <div class="panel panel-warning" style="border-color: #f97316;">
                                <div class="panel-heading" style="background: #f97316; color: white; border-color: #f97316;">Router Details</div>
                                <div class="panel-body">
                                    <dl>
                                        <dt>Router Name:</dt>
                                        <dd>{$router->name}</dd>
                                        <dt>Router IP:</dt>
                                        <dd>{$router->ip_address}</dd>
                                    </dl>
                                    
                                    <h5>Choose Service to Configure:</h5>
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" id="pppoeService" disabled> PPPoE
                                        </label>
                                    </div>
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" id="hotspotService" checked> Hotspot
                                        </label>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label>MikroTik Ports</label>
                                        <div id="portsContainer">
                                            <button type="button" class="btn btn-warning btn-sm" onclick="loadPorts()" id="loadPortsBtn" style="background: #f97316; border-color: #ea580c;">
                                                <i class="fa fa-refresh"></i> Loading ports...
                                            </button>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label>Run PPPoE and Hotspot on the same bridge?</label>
                                        <select class="form-control" id="bridgeOption" style="border-color: #f97316;">
                                            <option value="No">No</option>
                                            <option value="Yes">Yes</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Configuration Form -->
                        <div class="col-md-8">
                            <div class="panel panel-success" style="border-color: #f97316;">
                                <div class="panel-heading" style="background: #f97316; color: white; border-color: #f97316;">
                                    <h4 style="color: white; margin: 0;">Hotspot Configuration</h4>
                                </div>
                                <div class="panel-body">
                                    <form id="configurationForm">
                                        <input type="hidden" name="router_id" value="{$router_id}">
                                        
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Bridge Name:</label>
                                                    <input type="text" class="form-control" name="bridge_name" 
                                                           value="{$router->name}_bridge_hotspot" id="bridgeName" style="border-color: #f97316;">
                                                </div>
                                                
                                                <div class="form-group">
                                                    <label>Bridge Subnet:</label>
                                                    <input type="text" class="form-control" name="bridge_subnet" 
                                                           placeholder="192.168.1.0/24" readonly style="border-color: #f97316;">
                                                    <button type="button" class="btn btn-warning btn-sm mt-2" onclick="generateSubnet()" style="background: #f97316; border-color: #ea580c; margin-top: 5px;">
                                                        Generate Subnet
                                                    </button>
                                                </div>
                                            </div>
                                            
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Hotspot Options</label>
                                                </div>
                                                
                                                <div class="form-group">
                                                    <label>Hotspot IP Range:</label>
                                                    <input type="text" class="form-control" name="ip_range" 
                                                           value="192.168.100.0/24" id="ipRange" style="border-color: #f97316;">
                                                    <button type="button" class="btn btn-warning btn-sm mt-1" id="generateBtn" style="background: #f97316; border-color: #ea580c; margin-top: 5px;">
                                                        Generate
                                                    </button>
                                                    <small class="help-block">Example: 192.168.88.0/24</small>
                                                </div>

                                                <div class="form-group">
                                                    <label>Gateway IP:</label>
                                                    <input type="text" class="form-control" name="gateway_ip" 
                                                           value="192.168.100.1" id="gatewayIp" style="border-color: #f97316;">
                                                </div>
                                                
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <div class="form-group">
                                                            <label>DHCP Start:</label>
                                                            <input type="text" class="form-control" name="dhcp_start" 
                                                                   value="192.168.100.10" id="dhcpStart" style="border-color: #f97316;">
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="form-group">
                                                            <label>DHCP End:</label>
                                                            <input type="text" class="form-control" name="dhcp_end" 
                                                                   value="192.168.100.254" id="dhcpEnd" style="border-color: #f97316;">
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label>Enable Anti Hotspot Sharing?</label>
                                                    <select class="form-control" name="anti_sharing" style="border-color: #f97316;">
                                                        <option value="No">No</option>
                                                        <option value="Yes">Yes</option>
                                                    </select>
                                                </div>

                                                <div class="form-group">
                                                    <label>Choose Auth Type:</label>
                                                    <select class="form-control" name="auth_type" style="border-color: #f97316;">
                                                        <option value="API">API</option>
                                                        <option value="HTTP-CHAP">HTTP-CHAP</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label>DNS Servers:</label>
                                            <input type="text" class="form-control" name="dns_servers" 
                                                   value="8.8.8.8,1.1.1.1" style="border-color: #f97316;">
                                        </div>

                                        <div class="form-group">
                                            <label>Hotspot Name:</label>
                                            <input type="text" class="form-control" name="hotspot_name" 
                                                   value="{$router->name}_hotspot" style="border-color: #f97316;">
                                        </div>

                                        <hr style="border-color: #f97316;">
                                        
                                        <div class="btn-group">
                                            <button type="button" class="btn btn-warning" onclick="previewConfiguration()" style="background: #f97316; border-color: #ea580c;">
                                                <i class="fa fa-eye"></i> Preview Configuration
                                            </button>
                                            <button type="button" class="btn btn-success" onclick="generateConfiguration()" style="background: #f97316; border-color: #ea580c;">
                                                <i class="fa fa-cogs"></i> Configure {$router->name} MikroTik
                                            </button>
                                        </div>
                                        
                                        <a href="{$_url}plugin/mikrotik_configurator" class="btn btn-default" style="border-color: #f97316; color: #f97316;">
                                            <i class="fa fa-arrow-left"></i> Back to Routers
                                        </a>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                {/if}

            </div>
        </div>
    </div>
</div>

<!-- Configuration Preview Modal -->
<div class="modal fade" id="previewModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header" style="background: #f97316; color: white;">
                <button type="button" class="close" data-dismiss="modal" style="color: white;">&times;</button>
                <h4 class="modal-title" style="color: white;">Configuration Preview</h4>
            </div>
            <div class="modal-body">
                <pre id="configPreview" style="max-height: 400px; overflow-y: auto; border-color: #f97316;"></pre>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal" style="border-color: #f97316; color: #f97316;">Close</button>
                <button type="button" class="btn btn-success" onclick="deployConfiguration()" style="background: #f97316; border-color: #ea580c;">
                    <i class="fa fa-upload"></i> Deploy to MikroTik
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Deployment Status Modal -->
<div class="modal fade" id="deploymentModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header" style="background: #f97316; color: white;">
                <h4 class="modal-title" style="color: white;">Deployment Status</h4>
            </div>
            <div class="modal-body" id="deploymentStatus">
                <div class="text-center">
                    <i class="fa fa-spinner fa-spin fa-3x" style="color: #f97316;"></i>
                    <h4>Deploying Configuration...</h4>
                    <p>Please wait while we configure your MikroTik router.</p>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal" id="deploymentCloseBtn" style="display: none; border-color: #f97316; color: #f97316;">Close</button>
            </div>
        </div>
    </div>
</div>

<style>
.router-card {
    transition: all 0.3s ease;
    margin-bottom: 20px;
    border-color: #f97316 !important;
}

.router-card:hover {
    box-shadow: 0 5px 15px rgba(249, 115, 22, 0.3);
    transform: translateY(-5px);
    border-color: #f97316 !important;
}

.router-icon {
    margin-bottom: 15px;
}

.router-name {
    color: #f97316;
    margin-bottom: 10px;
}

.router-details {
    margin-bottom: 15px;
    font-size: 13px;
}

.ports-container {
    max-height: 200px;
    overflow-y: auto;
    border: 1px solid #f97316;
    border-radius: 4px;
    padding: 10px;
    margin-top: 10px;
}

.port-item {
    margin-bottom: 8px;
    padding: 5px;
    border-left: 3px solid transparent;
}

.port-item.selectable {
    border-left-color: #f97316;
}

.port-item.disabled {
    border-left-color: #d9534f;
    opacity: 0.6;
}

.loading-spinner {
    display: inline-block;
    width: 20px;
    height: 20px;
    border: 3px solid rgba(249, 115, 22, 0.3);
    border-radius: 50%;
    border-top-color: #f97316;
    animation: spin 1s ease-in-out infinite;
}

@keyframes spin {
    to { transform: rotate(360deg); }
}

.panel-primary {
    border-color: #f97316 !important;
}

.panel-primary .panel-heading {
    background: linear-gradient(145deg, #f97316, #ea580c) !important;
    border-color: #f97316 !important;
}

.label-warning {
    background: #f97316 !important;
}

.btn-warning {
    background: #f97316 !important;
    border-color: #ea580c !important;
}

.btn-warning:hover {
    background: #ea580c !important;
    border-color: #c2410c !important;
}

a:hover {
    color: #f97316 !important;
}

.form-control:focus {
    border-color: #f97316 !important;
    box-shadow: 0 0 5px rgba(249, 115, 22, 0.3) !important;
}
</style>

{literal}
<script>
var currentConfigId = null;
var selectedInterfaces = [];
var routerId = {$router_id|default:0};

// Load ports when page loads
{if $action == 'configure'}
    $(document).ready(function() {
        loadPorts();
    });
{/if}

function loadPorts() {
    if (!routerId) {
        alert('Invalid router ID');
        return;
    }
    
    $('#loadPortsBtn').prop('disabled', true).html('<i class="fa fa-spinner fa-spin"></i> Loading...');
    $('#portsContainer').html('<div class="loading-spinner"></div> Loading ports...');
    
    $.ajax({
        url: '{/literal}{$_url}{literal}plugin/mikrotik_configurator&action=scan_ports&router_id=' + routerId,
        method: 'POST',
        dataType: 'json',
        success: function(response) {
            if (response.success) {
                displayPorts(response.interfaces);
            } else {
                $('#portsContainer').html(
                    '<div class="alert alert-warning">' +
                    '<i class="fa fa-exclamation-triangle"></i> ' +
                    'Error: ' + response.message +
                    '</div>'
                );
            }
        },
        error: function() {
            $('#portsContainer').html(
                '<div class="alert alert-warning">' +
                '<i class="fa fa-exclamation-triangle"></i> ' +
                'Failed to connect to router' +
                '</div>'
            );
        },
        complete: function() {
            $('#loadPortsBtn').prop('disabled', false).html('<i class="fa fa-refresh"></i> Reload Ports');
        }
    });
}

function displayPorts(interfaces) {
    var html = '<div class="ports-container">';
    
    if (interfaces.length === 0) {
        html += '<div class="alert alert-info">No suitable interfaces found</div>';
    } else {
        interfaces.forEach(function(iface) {
            var statusClass = iface.selectable ? 'selectable' : 'disabled';
            var statusIcon = iface.running ? 'fa-check-circle text-success' : 'fa-times-circle text-danger';
            var typeIcon = iface.type === 'ether' ? 'fa-plug' : 'fa-wifi';
            
            html += '<div class="port-item ' + statusClass + '">' +
                    '<label class="checkbox-inline">' +
                    '<input type="checkbox" name="interface" value="' + iface.name + '"' +
                    (iface.selectable ? '' : ' disabled') + '> ' +
                    '<i class="fa ' + typeIcon + '"></i> ' + iface.name + ' (' + iface.type + ') ' +
                    '<i class="fa ' + statusIcon + '"></i>' +
                    '</label>';
            
            if (iface.comment) {
                html += '<br><small class="text-muted">' + iface.comment + '</small>';
            }
            
            html += '</div>';
        });
    }
    
    html += '</div>';
    $('#portsContainer').html(html);
    
    // Add change event to track selected interfaces
    $('input[name="interface"]').change(function() {
        updateSelectedInterfaces();
    });
}

function updateSelectedInterfaces() {
    selectedInterfaces = [];
    $('input[name="interface"]:checked').each(function() {
        selectedInterfaces.push($(this).val());
    });
}

function generateSubnet() {
    // Auto-generate subnet based on available ranges
    var subnets = [
        '192.168.1.0/24',
        '192.168.100.0/24', 
        '10.0.0.0/24',
        '172.16.0.0/24'
    ];
    
    var randomSubnet = subnets[Math.floor(Math.random() * subnets.length)];
    $('input[name="bridge_subnet"]').val(randomSubnet);
}

function previewConfiguration() {
    updateSelectedInterfaces();
    
    if (selectedInterfaces.length === 0) {
        alert('Please select at least one interface');
        return;
    }
    
    var formData = getFormData();
    
    $.ajax({
        url: '{/literal}{$_url}{literal}plugin/mikrotik_configurator&action=generate_config',
        method: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(formData),
        dataType: 'json',
        success: function(response) {
            if (response.success) {
                currentConfigId = response.config_id;
                $('#configPreview').text(response.rsc_content);
                $('#previewModal').modal('show');
            } else {
                alert('Error: ' + response.message);
            }
        },
        error: function() {
            alert('Failed to generate configuration');
        }
    });
}

function generateConfiguration() {
    updateSelectedInterfaces();
    
    if (selectedInterfaces.length === 0) {
        alert('Please select at least one interface');
        return;
    }
    
    var formData = getFormData();
    
    $.ajax({
        url: '{/literal}{$_url}{literal}plugin/mikrotik_configurator&action=generate_config',
        method: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(formData),
        dataType: 'json',
        success: function(response) {
            if (response.success) {
                currentConfigId = response.config_id;
                $('#configPreview').text(response.rsc_content);
                $('#previewModal').modal('show');
            } else {
                alert('Error: ' + response.message);
            }
        },
        error: function() {
            alert('Failed to generate configuration');
        }
    });
}

function deployConfiguration() {
    if (!currentConfigId) {
        alert('No configuration to deploy');
        return;
    }
    
    $('#previewModal').modal('hide');
    $('#deploymentModal').modal('show');
    
    $.ajax({
        url: '{/literal}{$_url}{literal}plugin/mikrotik_configurator&action=deploy_config',
        method: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({config_id: currentConfigId}),
        dataType: 'json',
        success: function(response) {
            if (response.success) {
                $('#deploymentStatus').html(
                    '<div class="alert alert-success text-center">' +
                    '<i class="fa fa-check-circle fa-3x text-success"></i>' +
                    '<h4>Configuration Deployed Successfully!</h4>' +
                    '<p>' + response.message + '</p>' +
                    '</div>'
                );
            } else {
                $('#deploymentStatus').html(
                    '<div class="alert alert-danger text-center">' +
                    '<i class="fa fa-times-circle fa-3x text-danger"></i>' +
                    '<h4>Deployment Failed</h4>' +
                    '<p>' + response.message + '</p>' +
                    '</div>'
                );
            }
            $('#deploymentCloseBtn').show();
        },
        error: function() {
            $('#deploymentStatus').html(
                '<div class="alert alert-danger text-center">' +
                '<i class="fa fa-times-circle fa-3x text-danger"></i>' +
                '<h4>Deployment Error</h4>' +
                '<p>Failed to deploy configuration to router</p>' +
                '</div>'
            );
            $('#deploymentCloseBtn').show();
        }
    });
}

function getFormData() {
    return {
        router_id: routerId,
        interfaces: selectedInterfaces,
        bridge_name: $('input[name="bridge_name"]').val(),
        ip_range: $('input[name="ip_range"]').val(),
        gateway_ip: $('input[name="gateway_ip"]').val(),
        dhcp_start: $('input[name="dhcp_start"]').val(),
        dhcp_end: $('input[name="dhcp_end"]').val(),
        dns_servers: $('input[name="dns_servers"]').val(),
        hotspot_name: $('input[name="hotspot_name"]').val(),
        auth_type: $('select[name="auth_type"]').val(),
        anti_sharing: $('select[name="anti_sharing"]').val()
    };
}

// Auto-update gateway and DHCP range when IP range changes
$('#generateBtn').click(function() {
    var ipRange = $('#ipRange').val();
    // Fixed regex pattern
    if (ipRange.match(/^(\d{1,3}\.){3}\d{1,3}\/\d{1,2}$/)) {
        var network = ipRange.split('/')[0];
        var parts = network.split('.');
        var gateway = parts[0] + '.' + parts[1] + '.' + parts[2] + '.1';
        var dhcpStart = parts[0] + '.' + parts[1] + '.' + parts[2] + '.10';
        var dhcpEnd = parts[0] + '.' + parts[1] + '.' + parts[2] + '.254';
        
        $('#gatewayIp').val(gateway);
        $('#dhcpStart').val(dhcpStart);
        $('#dhcpEnd').val(dhcpEnd);
    }
});

function showHelp() {
    alert('MikroTik Router Configurator Help:\n\n' +
          '1. Select a router from the list\n' +
          '2. Choose interfaces to configure\n' +
          '3. Set network parameters\n' +
          '4. Preview and deploy configuration\n\n' +
          'The system will automatically create hotspot configuration on your MikroTik router.');
}
</script>
{/literal}

{include file="sections/footer.tpl"}