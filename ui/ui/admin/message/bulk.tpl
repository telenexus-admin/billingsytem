{include file="sections/header.tpl"}
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.11.3/css/jquery.dataTables.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

<div class="row">
    <div class="col-sm-12 col-md-12">
        <div id="status" class="mb-3"></div>
        <div class="panel panel-primary panel-hovered panel-stacked mb30 {if $page>0 && $totalCustomers >0}hidden{/if}">
            <div class="panel-heading">{Lang::T('Send Bulk Message')}</div>
            <div class="panel-body">
                <form class="form-horizontal" method="get" role="form" id="bulkMessageForm" action="">
                    <input type="hidden" name="page" value="{if $page>0 && $totalCustomers==0}-1{else}{$page}{/if}">
                    <div class="form-group">
                        <label class="col-md-2 control-label">{Lang::T('Router')}</label>
                        <div class="col-md-6">
                            <select class="form-control select2" name="router" id="router">
                                <option value="">{Lang::T('All Routers')}</option>
                                {if $_c['radius_enable']}
                                <option value="radius">{Lang::T('Radius')}</option>
                                {/if}
                                {foreach $routers as $router}
                                <option value="{$router['id']}">{$router['name']}</option>
                                {/foreach}
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-2 control-label">{Lang::T('Service Type')}</label>
                        <div class="col-md-6">
                            <select class="form-control" name="service" id="service">
                                <option value="all" {if $group=='all' }selected{/if}>{Lang::T('All')}</option>
                                <option value="PPPoE" {if $service=='PPPoE' }selected{/if}>{Lang::T('PPPoE')}</option>
                                <option value="Hotspot" {if $service=='Hotspot' }selected{/if}>{Lang::T('Hotspot')}</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-2 control-label">{Lang::T('Group')}</label>
                        <div class="col-md-6">
                            <select class="form-control" name="group" id="group">
                                <option value="all" {if $group=='all' }selected{/if}>{Lang::T('All Customers')}</option>
                                <option value="new" {if $group=='new' }selected{/if}>{Lang::T('New Customers')}</option>
                                <option value="expired" {if $group=='expired' }selected{/if}>{Lang::T('Expired Customers')}</option>
                                <option value="active" {if $group=='active' }selected{/if}>{Lang::T('Active Customers')}</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-2 control-label">{Lang::T('Send Via')}</label>
                        <div class="col-md-6">
                            <select class="form-control" name="via" id="via">
                                <option value="sms" {if $via=='sms' }selected{/if}>{Lang::T('SMS')}</option>
                                <option value="wa" {if $via=='wa' }selected{/if}>{Lang::T('WhatsApp')}</option>
                                <option value="both" {if $via=='both' }selected{/if}>{Lang::T('SMS and WhatsApp')}</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-2 control-label">{Lang::T('Message per time')}</label>
                        <div class="col-md-6">
                            <select class="form-control" name="batch" id="batch">
                                <option value="25" {if $batch=='25' }selected{/if}>{Lang::T('25 Messages')}</option>
                                <option value="50" {if $batch=='50' }selected{/if}>{Lang::T('50 Messages')}</option>
                                <option value="75" {if $batch=='75' }selected{/if}>{Lang::T('75 Messages')}</option>
                                <option value="100" {if $batch=='100' }selected{/if}>{Lang::T('100 Messages')}</option>
                                <option value="150" {if $batch=='150' }selected{/if}>{Lang::T('150 Messages')}</option>
                                <option value="200" {if $batch=='200' }selected{/if}>{Lang::T('200 Messages')}</option>
                                <option value="auto" {if $batch=='auto' }selected{/if}>{Lang::T('Auto (Optimal Speed)')}</option>
                            </select>
                            <small class="help-block">{Lang::T('Auto mode adjusts batch size based on SMS gateway for optimal performance')}</small>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-2 control-label">{Lang::T('Processing Speed')}</label>
                        <div class="col-md-6">
                            <select class="form-control" name="speed" id="speed">
                                <option value="fast">{Lang::T('Fast (Recommended)')}</option>
                                <option value="medium">{Lang::T('Medium (Balanced)')}</option>
                                <option value="slow">{Lang::T('Slow (Conservative)')}</option>
                            </select>
                            <small class="help-block">{Lang::T('Fast: 0.5s delay, Medium: 1s delay, Slow: 2s delay between batches')}</small>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-2 control-label">{Lang::T('Message')}</label>
                        <div class="col-md-6">
                            <textarea class="form-control" id="message" name="message" required placeholder="{Lang::T('Compose your message...')}" rows="5">{$message}</textarea>
                            <input name="test" id="test" type="checkbox">
                            {Lang::T('Testing [if checked no real message is sent]')}
                        </div>
                        <p class="help-block col-md-4">
                            {Lang::T('Use placeholders:')}
                            <br>
                            <b>[[name]]</b> - {Lang::T('Customer Name')}
                            <br>
                            <b>[[user_name]]</b> - {Lang::T('Customer Username')}
                            <br>
                            <b>[[phone]]</b> - {Lang::T('Customer Phone')}
                            <br>
                            <b>[[company_name]]</b> - {Lang::T('Your Company Name')}
                        </p>
                    </div>
                    <div class="form-group">
                        <div class="col-lg-offset-2 col-lg-10">
                            <button type="button" id="startBulk" class="btn btn-primary btn-lg">
                                <i class="fas fa-paper-plane"></i> {Lang::T('Start Bulk Messaging')}
                            </button>
                            <button type="button" id="pauseBulk" class="btn btn-warning" style="display:none;">
                                <i class="fas fa-pause"></i> {Lang::T('Pause')}
                            </button>
                            <button type="button" id="resumeBulk" class="btn btn-success" style="display:none;">
                                <i class="fas fa-play"></i> {Lang::T('Resume')}
                            </button>
                            <button type="button" id="stopBulk" class="btn btn-danger" style="display:none;">
                                <i class="fas fa-stop"></i> {Lang::T('Stop')}
                            </button>
                            <a href="{Text::url('dashboard')}" class="btn btn-default">{Lang::T('Cancel')}</a>
                        </div>
                    </div>
                    
                    <!-- Progress Section -->
                    <div id="progressSection" class="form-group" style="display:none;">
                        <div class="col-lg-offset-2 col-lg-10">
                            <div class="panel panel-info">
                                <div class="panel-heading">
                                    <h4 class="panel-title">
                                        <i class="fas fa-chart-line"></i> {Lang::T('Sending Progress')}
                                    </h4>
                                </div>
                                <div class="panel-body">
                                    <div class="progress progress-striped active">
                                        <div id="progressBar" class="progress-bar progress-bar-info" style="width: 0%">
                                            <span id="progressText">0%</span>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-3">
                                            <div class="text-center">
                                                <h4 id="totalSentCount" class="text-success">0</h4>
                                                <small>{Lang::T('Sent Successfully')}</small>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="text-center">
                                                <h4 id="totalFailedCount" class="text-danger">0</h4>
                                                <small>{Lang::T('Failed')}</small>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="text-center">
                                                <h4 id="sendingSpeed" class="text-info">0</h4>
                                                <small>{Lang::T('SMS/min')}</small>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="text-center">
                                                <h4 id="estimatedTime" class="text-warning">--</h4>
                                                <small>{Lang::T('Est. Time Left')}</small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Add a Table for Sent History -->
<div class="panel panel-default">
    <div class="panel-heading">{Lang::T('Message Sending History')}</div>
    <div class="panel-body">
        <div id="status"></div>
        <table class="table table-bordered" id="historyTable">
            <thead>
                <tr>
                    <th>{Lang::T('Customer')}</th>
                    <th>{Lang::T('Phone')}</th>
                    <th>{Lang::T('Status')}</th>
                    <th>{Lang::T('Message')}</th>
                    <th>{Lang::T('Router')}</th>
                    <th>{Lang::T('Service Type')}</th>
                    <th>{Lang::T('Plan')}</th>
                </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.datatables.net/1.11.3/js/jquery.dataTables.min.js"></script>
{literal}
<script>
    let page = 0;
    let totalSent = 0;
    let totalFailed = 0;
    let hasMore = true;
    let isPaused = false;
    let isStopped = false;
    let startTime = null;
    let batchDelays = { fast: 500, medium: 1000, slow: 2000 };
    let adaptiveBatchSize = 50;
    let retryAttempts = 0;
    let maxRetries = 3;

    // Initialize DataTable with better performance
    let historyTable = $('#historyTable').DataTable({
        paging: true,
        searching: true,
        ordering: true,
        info: true,
        autoWidth: false,
        responsive: true,
        pageLength: 25,
        deferRender: true,
        processing: true,
        language: {
            processing: '<i class="fas fa-spinner fa-spin"></i> Processing...'
        }
    });

    // Auto-detect optimal batch size based on SMS gateway
    function getOptimalBatchSize() {
        const via = $('#via').val();
        const batch = $('#batch').val();
        
        if (batch !== 'auto') {
            return parseInt(batch);
        }
        
        // Adaptive batch sizes based on gateway capabilities
        switch(via) {
            case 'sms':
                return 100; // SMS gateways generally handle larger batches
            case 'wa':
                return 50;  // WhatsApp might be more rate-limited
            case 'both':
                return 30;  // Conservative for dual sending
            default:
                return 50;
        }
    }

    function updateProgress() {
        if (!startTime) return;
        
        const elapsed = (Date.now() - startTime) / 1000; // seconds
        const totalProcessed = totalSent + totalFailed;
        const speed = totalProcessed > 0 ? Math.round((totalProcessed / elapsed) * 60) : 0; // per minute
        
        $('#sendingSpeed').text(speed);
        
        // Estimate time remaining
        if (speed > 0 && hasMore) {
            const estimated = Math.round((totalProcessed * elapsed / totalSent) - elapsed);
            const mins = Math.floor(estimated / 60);
            const secs = estimated % 60;
            $('#estimatedTime').text(mins > 0 ? mins + 'm ' + secs + 's' : secs + 's');
        }
    }

    function updateUI(response) {
        $('#totalSentCount').text(totalSent.toLocaleString());
        $('#totalFailedCount').text(totalFailed.toLocaleString());
        
        // Update progress bar with actual percentage if we have total customers
        if (response && response.totalCustomers) {
            const processed = totalSent + totalFailed;
            const percentage = Math.round((processed / response.totalCustomers) * 100);
            $('#progressBar').css('width', percentage + '%');
            $('#progressText').text(`${processed.toLocaleString()} of ${response.totalCustomers.toLocaleString()} (${percentage}%)`);
        } else {
            const processed = totalSent + totalFailed;
            $('#progressText').text(processed.toLocaleString() + ' processed');
        }
        
        updateProgress();
    }

    function sendBatch() {
        if (!hasMore || isPaused || isStopped) return;

        const currentBatchSize = getOptimalBatchSize();
        const speed = $('#speed').val();
        const delay = batchDelays[speed] || 500;

        $.ajax({
            url: '?_route=message/send_bulk_ajax',
            method: 'POST',
            data: {
                group: $('#group').val(),
                message: $('#message').val(),
                via: $('#via').val(),
                batch: currentBatchSize,
                router: $('#router').val() || '',
                page: page,
                test: $('#test').is(':checked') ? 'on' : 'off',
                service: $('#service').val(),
            },
            dataType: 'json',
            timeout: 60000, // 60 second timeout
            beforeSend: function () {
                if (!startTime) {
                    startTime = Date.now();
                    $('#progressSection').show();
                }
                $('#status').html(`
                    <div class="alert alert-info">
                        <i class="fas fa-paper-plane fa-spin"></i> Sending batch ${page + 1} (${currentBatchSize} messages)...
                    </div>
                `);
            },
            success: function (response) {
                retryAttempts = 0; // Reset retry counter on success
                
                if (response && response.status === 'success') {
                    totalSent += response.totalSent || 0;
                    totalFailed += response.totalFailed || 0;
                    page = response.page || page + 1;
                    hasMore = response.hasMore !== false;

                    $('#status').html(`
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle"></i> Batch ${page} completed! 
                            <small>(Sent: ${response.totalSent || 0}, Failed: ${response.totalFailed || 0})</small>
                            ${response.debug ? '<br><small class="text-muted">Debug: ' + response.debug.query_filters + '</small>' : ''}
                        </div>
                    `);

                    // Add to history table in chunks to avoid UI freezing
                    if (response.batchStatus && response.batchStatus.length > 0) {
                        const batchData = response.batchStatus.map(msg => [
                            msg.name || 'Unknown',
                            msg.phone || 'Unknown',
                            msg.status && msg.status.includes('Failed') ? 
                                `<span class="label label-danger">${msg.status}</span>` : 
                                `<span class="label label-success">${msg.status || 'Sent'}</span>`,
                            (msg.message || 'No message').substring(0, 50) + '...',
                            msg.router || 'All Routers',
                            msg.service === 'all' ? 'All Services' : (msg.service || 'Unknown'),
                            msg.plan || 'No Plan'
                        ]);
                        
                        historyTable.rows.add(batchData).draw(false);
                    }

                    updateUI(response);

                    if (hasMore && !isPaused && !isStopped) {
                        // Use adaptive delay based on success rate
                        const successRate = totalSent / (totalSent + totalFailed);
                        const adaptiveDelay = successRate > 0.95 ? delay * 0.5 : delay;
                        
                        setTimeout(sendBatch, adaptiveDelay);
                    } else if (!hasMore) {
                        completeProcess();
                    }
                } else {
                    handleError('Unexpected response format', response);
                }
            },
            error: function (xhr, status, error) {
                handleError(`Request failed: ${error}`, { xhr, status, error });
            }
        });
    }

    function handleError(message, details) {
        retryAttempts++;
        console.error('Bulk SMS Error:', message, details);
        
        if (retryAttempts <= maxRetries && !isStopped) {
            $('#status').html(`
                <div class="alert alert-warning">
                    <i class="fas fa-exclamation-triangle"></i> ${message} 
                    <br><small>Retrying... (Attempt ${retryAttempts}/${maxRetries})</small>
                </div>
            `);
            
            // Exponential backoff for retries
            const retryDelay = Math.pow(2, retryAttempts) * 1000;
            setTimeout(sendBatch, retryDelay);
        } else {
            $('#status').html(`
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i> Failed after ${maxRetries} attempts: ${message}
                    <br><button class="btn btn-sm btn-warning" onclick="resumeSending()">Try Again</button>
                </div>
            `);
            resetControls();
        }
    }

    function completeProcess() {
        const duration = ((Date.now() - startTime) / 1000 / 60).toFixed(1);
        const avgSpeed = Math.round((totalSent + totalFailed) / parseFloat(duration));
        
        $('#status').html(`
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> 
                <strong>Bulk messaging completed!</strong><br>
                Total Sent: <strong>${totalSent.toLocaleString()}</strong> | 
                Failed: <strong>${totalFailed.toLocaleString()}</strong><br>
                Duration: ${duration} minutes | Average Speed: ${avgSpeed} SMS/min
            </div>
        `);
        
        resetControls();
    }

    function resetControls() {
        $('#startBulk').show();
        $('#pauseBulk, #resumeBulk, #stopBulk').hide();
        isPaused = false;
        isStopped = false;
    }

    function resumeSending() {
        retryAttempts = 0;
        sendBatch();
    }

    // Control button handlers
    $('#startBulk').on('click', function () {
        const message = $('#message').val().trim();
        const group = $('#group').val();
        const service = $('#service').val();
        const via = $('#via').val();
        
        // Validation
        if (!message) {
            alert('Please enter a message');
            $('#message').focus();
            return;
        }
        
        if (message.length < 10) {
            alert('Message is too short. Please enter at least 10 characters.');
            $('#message').focus();
            return;
        }
        
        if (!group || !service || !via) {
            alert('Please select all required options (Group, Service Type, Send Via)');
            return;
        }
        
        // Confirmation for large batches
        const batch = getOptimalBatchSize();
        if (batch > 100 && !confirm(`You are about to send messages in batches of ${batch}. This may send to many customers. Are you sure you want to continue?`)) {
            return;
        }
        
        // Reset counters and state
        page = 0;
        totalSent = 0;
        totalFailed = 0;
        hasMore = true;
        isPaused = false;
        isStopped = false;
        startTime = null;
        retryAttempts = 0;
        
        // Update UI
        $('#startBulk').hide();
        $('#pauseBulk, #stopBulk').show();
        $('#status').html(`
            <div class="alert alert-info">
                <i class="fas fa-rocket"></i> Initializing bulk messaging...
                <br><small>Filters: Group=${group}, Service=${service}, Via=${via}</small>
            </div>
        `);
        
        // Clear history table
        historyTable.clear().draw();
        
        // Start sending
        sendBatch();
    });

    $('#pauseBulk').on('click', function () {
        isPaused = true;
        $(this).hide();
        $('#resumeBulk').show();
        $('#status').html('<div class="alert alert-warning"><i class="fas fa-pause"></i> Bulk messaging paused</div>');
    });

    $('#resumeBulk').on('click', function () {
        isPaused = false;
        $(this).hide();
        $('#pauseBulk').show();
        sendBatch();
    });

    $('#stopBulk').on('click', function () {
        if (confirm('Are you sure you want to stop bulk messaging?')) {
            isStopped = true;
            hasMore = false;
            completeProcess();
        }
    });

    // Auto-update batch size when gateway changes
    $('#via').on('change', function() {
        if ($('#batch').val() === 'auto') {
            const optimal = getOptimalBatchSize();
            const viaText = $(this).find('option:selected').text();
            $('#batch').next('.help-block').html(`Auto mode will use ${optimal} messages per batch for ${viaText}`);
        }
    });

    // Show estimated customer count when filters change
    $('#group, #service, #router').on('change', function() {
        const group = $('#group').val();
        const service = $('#service').val();
        const router = $('#router').val();
        
        if (group && service) {
            // Quick estimate request (without actually sending)
            $.ajax({
                url: '?_route=message/estimate_bulk_count',
                method: 'POST',
                data: {
                    group: group,
                    service: service,
                    router: router || ''
                },
                dataType: 'json',
                success: function(response) {
                    if (response && response.estimated_count !== undefined) {
                        const count = parseInt(response.estimated_count);
                        let message = `Estimated recipients: <strong>${count.toLocaleString()}</strong>`;
                        
                        if (count === 0) {
                            message = '<span class="text-warning">No customers found with current filters</span>';
                        } else if (count > 1000) {
                            message += ' <span class="text-warning">(Large batch - consider filtering further)</span>';
                        }
                        
                        $('#estimateDisplay').html(`
                            <div class="alert alert-info" style="margin-top: 10px;">
                                <i class="fas fa-info-circle"></i> ${message}
                            </div>
                        `);
                    }
                },
                error: function() {
                    $('#estimateDisplay').html('');
                }
            });
        } else {
            $('#estimateDisplay').html('');
        }
    });

    // Initialize tooltips for better UX
    $(document).ready(function() {
        $('[data-toggle="tooltip"]').tooltip();
        
        // Add estimate display area after the form
        if ($('#estimateDisplay').length === 0) {
            $('#bulkMessageForm').after('<div id="estimateDisplay"></div>');
        }
    });
</script>
{/literal}

{include file="sections/footer.tpl"}