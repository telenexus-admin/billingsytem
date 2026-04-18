{include file="sections/header.tpl"}

<!-- Essential Statistics Only -->
<div class="row">
    {if in_array($_admin['user_type'],['SuperAdmin'])}
        <div class="col-lg-3 col-xs-6">
            <div class="small-box" style="background: #00a65a; color: white;">
                <div class="inner">
                    <h3 style="color: white;">{Lang::moneyFormat($stats.total_amount)}</h3>
                    <p style="color: white;">Online Payments Revenue</p>
                </div>
                <div class="icon">
                    <i class="ion ion-card" style="color: rgba(255,255,255,0.8); font-size: 50px;"></i>
                </div>
                <a href="{Text::url('reports/by-period')}" class="small-box-footer" style="background: rgba(0,0,0,0.1); color: white;">View Details</a>
            </div>
        </div>
        <div class="col-lg-3 col-xs-6">
            <div class="small-box" style="background: #00a65a; color: white;">
                <div class="inner">
                    <h3 style="color: white;">{$stats.paid}</h3>
                    <p style="color: white;">Paid Online Transactions</p>
                </div>
                <div class="icon">
                    <i class="ion ion-checkmark-circled" style="color: rgba(255,255,255,0.8); font-size: 50px;"></i>
                </div>
                <a href="#" class="small-box-footer" style="background: rgba(0,0,0,0.1); color: white;">More Info</a>
            </div>
        </div>
        <div class="col-lg-3 col-xs-6">
            <div class="small-box" style="background: #00a65a; color: white;">
                <div class="inner">
                    <h3 style="color: white;">{Lang::moneyFormat($cash_stats.total_amount)}</h3>
                    <p style="color: white;">Manual Cash Revenue</p>
                </div>
                <div class="icon">
                    <i class="ion ion-cash" style="color: rgba(255,255,255,0.8); font-size: 50px;"></i>
                </div>
                <a href="{Text::url('reports/by-period')}" class="small-box-footer" style="background: rgba(0,0,0,0.1); color: white;">View Details</a>
            </div>
        </div>
        <div class="col-lg-3 col-xs-6">
            <div class="small-box" style="background: #00a65a; color: white;">
                <div class="inner">
                    <h3 style="color: white;">{$voucher_stats.total_count}</h3>
                    <p style="color: white;">Voucher Recharges</p>
                </div>
                <div class="icon">
                    <i class="ion ion-pricetag" style="color: rgba(255,255,255,0.8); font-size: 50px;"></i>
                </div>
                <a href="#" class="small-box-footer" style="background: rgba(0,0,0,0.1); color: white;">More Info</a>
            </div>
        </div>
    {else}
        <div class="col-lg-12">
            <div class="alert alert-info">
                <i class="fa fa-info-circle"></i> Payment statistics are only visible to Super Administrators.
            </div>
        </div>
    {/if}
</div>

<div class="row">
    <div class="col-md-12">
        <div class="panel panel-hovered mb20 panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    All Payment Gateway Transactions 
                    <small class="text-muted">
                        ({if $period == 'previous'}Previous Period{else}Current Period{/if}: 
                        {$period_start|date_format:"%d %b %Y"} - {$period_end|date_format:"%d %b %Y"})
                    </small>
                </div>
                <div class="panel-tools">
                    <span class="label label-success">Online +</span>
                    <span class="label label-info">Cash =</span>
                    <span class="label label-primary">Total Sales: {Lang::moneyFormat($stats.total_amount + $cash_stats.total_amount)}</span>
                </div>
            </div>
            <div class="panel-body">
                <!-- Period Selector -->
                <div class="row mb15">
                    <div class="col-md-12">
                        <div class="btn-group" role="group" aria-label="Period Selection">
                            <a href="?_route=transactions&period=current" class="btn {if $period == 'current'}btn-success{else}btn-default{/if}">
                                <i class="fa fa-calendar"></i> Current Period
                                <small>({$period_start|date_format:"%d %b"} - {$period_end|date_format:"%d %b"})</small>
                            </a>
                            <a href="?_route=transactions&period=previous" class="btn {if $period == 'previous'}btn-success{else}btn-default{/if}">
                                <i class="fa fa-history"></i> Previous Period
                            </a>
                        </div>
                        <div class="pull-right">
                            <small class="text-muted">
                                <i class="fa fa-info-circle"></i> 
                                Billing cycle resets on day {$reset_day} of each month
                            </small>
                        </div>
                    </div>
                </div>
                
                <!-- Filters -->
                <div class="row mb15">
                    <div class="col-md-12">
                        <div class="form-inline" id="filterForm">
                            <div class="form-group col-xs-12 col-sm-6 col-md-3">
                                <label class="sr-only" for="q">Search</label>
                                <input type="text" name="q" id="q" class="form-control" placeholder="Search by username, transaction ID, plan..." value="{$q}" style="width: 100%;">
                            </div>
                            <div class="form-group col-xs-6 col-sm-3 col-md-2">
                                <label class="sr-only" for="gateway">Gateway</label>
                                <select name="gateway" id="gateway" class="form-control" style="width: 100%;">
                                    <option value="">All Gateways</option>
                                    {foreach $gateways as $gw}
                                        <option value="{$gw.gateway}" {if $gateway == $gw.gateway}selected{/if}>{ucwords($gw.gateway)}</option>
                                    {/foreach}
                                </select>
                            </div>
                            <div class="form-group col-xs-6 col-sm-3 col-md-2">
                                <label class="sr-only" for="status">Status</label>
                                <select name="status" id="status" class="form-control" style="width: 100%;">
                                    <option value="">All Status</option>
                                    <option value="1" {if $status == '1'}selected{/if}>Pending</option>
                                    <option value="2" {if $status == '2'}selected{/if}>Paid</option>
                                    <option value="3" {if $status == '3'}selected{/if}>Failed</option>
                                    <option value="4" {if $status == '4'}selected{/if}>Canceled</option>
                                </select>
                            </div>
                            <div class="form-group col-xs-6 col-sm-6 col-md-2">
                                <label class="sr-only" for="date_from">From Date</label>
                                <input type="date" name="date_from" id="date_from" class="form-control" value="{$date_from}" placeholder="From Date" style="width: 100%;">
                            </div>
                            <div class="form-group col-xs-6 col-sm-6 col-md-2">
                                <label class="sr-only" for="date_to">To Date</label>
                                <input type="date" name="date_to" id="date_to" class="form-control" value="{$date_to}" placeholder="To Date" style="width: 100%;">
                            </div>
                            <div class="form-group col-xs-12 col-sm-12 col-md-1">
                                <button type="button" id="clearFilters" class="btn btn-default" style="width: 100%;">
                                    <i class="fa fa-refresh"></i> Clear
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Transactions Table -->
                <div class="table-responsive">
                    <table class="table table-bordered table-striped table-condensed">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Gateway</th>
                                <th>Transaction ID</th>
                                <th>Username</th>
                                <th>Plan</th>
                                <th>Router</th>
                                <th>Amount</th>
                                <th>Payment Method</th>
                                <th>Channel</th>
                                <th>Created</th>
                                <th>Paid</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody id="transactionsTableBody">
                            {foreach $pgs as $pg}
                                <tr class="{if $pg['status'] == 1}warning{elseif $pg['status'] == 2}success{elseif $pg['status'] == 3}danger{else}active{/if}">
                                    <td>
                                        <strong>#{$pg['id']}</strong>
                                    </td>
                                    <td>
                                        <span class="label label-success">{ucwords($pg['gateway'])}</span>
                                    </td>
                                    <td>
                                        <small class="text-muted">{if $pg['gateway_trx_id']}{$pg['gateway_trx_id']}{else}-{/if}</small>
                                    </td>
                                    <td>
                                        <a href="{$_url}customers/viewu/{$pg['username']}" class="text-dark">
                                            {$pg['username']}
                                        </a>
                                    </td>
                                    <td>
                                        <small>{$pg['plan_name']}</small>
                                    </td>
                                    <td>
                                        <small class="text-muted">{$pg['routers']}</small>
                                    </td>
                                    <td>
                                        <strong>{Lang::moneyFormat($pg['price'])}</strong>
                                    </td>
                                    <td>
                                        <small>{$pg['payment_method']}</small>
                                    </td>
                                    <td>
                                        <small class="text-muted">{$pg['payment_channel']}</small>
                                    </td>
                                    <td>
                                        <small>{if $pg['created_date']}{Lang::dateTimeFormat($pg['created_date'])}{else}-{/if}</small>
                                    </td>
                                    <td>
                                        <small>{if $pg['paid_date']}{Lang::dateTimeFormat($pg['paid_date'])}{else}-{/if}</small>
                                    </td>
                                    <td>
                                        {if $pg['status'] == 1}
                                            <span class="label label-warning">PENDING</span>
                                        {elseif $pg['status'] == 2}
                                            <span class="label label-success">PAID</span>
                                        {elseif $pg['status'] == 3}
                                            <span class="label label-danger">FAILED</span>
                                        {else}
                                            <span class="label label-default">CANCELED</span>
                                        {/if}
                                    </td>
                                </tr>
                            {/foreach}
                        </tbody>
                    </table>
                </div>

                {if !$pgs}
                    <div class="text-center">
                        <p class="text-muted">No transactions found matching your criteria.</p>
                    </div>
                {/if}

                {include file="pagination.tpl"}
            </div>
        </div>
    </div>
</div>

<!-- Ensure jQuery is loaded -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Custom CSS for responsive filters and period selector -->
<style>
.btn-group .btn {
    border-radius: 0;
}

.btn-group .btn:first-child {
    border-top-left-radius: 4px;
    border-bottom-left-radius: 4px;
}

.btn-group .btn:last-child {
    border-top-right-radius: 4px;
    border-bottom-right-radius: 4px;
}

@media (max-width: 768px) {
    #filterForm .form-group {
        margin-bottom: 10px;
    }
    
    #filterForm {
        display: block !important;
    }
    
    .btn-group {
        display: block;
        margin-bottom: 15px;
    }
    
    .btn-group .btn {
        display: block;
        width: 100%;
        border-radius: 4px !important;
        margin-bottom: 5px;
    }
    
    .table-responsive {
        overflow-x: auto;
        -webkit-overflow-scrolling: touch;
    }
    
    .table th, .table td {
        white-space: nowrap;
        font-size: 12px;
    }
}

@media (max-width: 576px) {
    .form-group.col-xs-12 {
        padding-left: 0;
        padding-right: 0;
    }
    
    .form-group.col-xs-6 {
        padding-left: 5px;
        padding-right: 5px;
    }
}
</style>

<script>
// Wait for jQuery to load and then execute our code
(function() {
    function initializeTransactionsPage() {
        if (typeof jQuery === 'undefined') {
            setTimeout(initializeTransactionsPage, 100);
            return;
        }
        
        var $ = jQuery; // Use jQuery explicitly
        
        $(document).ready(function() {
            let filterTimeout;
            
            // Function to perform AJAX search
            function performSearch() {
                const formData = {
                    ajax: '1',
                    q: $('#q').val(),
                    gateway: $('#gateway').val(),
                    status: $('#status').val(),
                    date_from: $('#date_from').val(),
                    date_to: $('#date_to').val(),
                    period: '{$period}'
                };
                
                // Show loading indicator
                $('#transactionsTableBody').html('<tr><td colspan="12" class="text-center"><i class="fa fa-spinner fa-spin"></i> Loading...</td></tr>');
                
                // Use the current page URL with parameters
                const ajaxUrl = window.location.href.split('?')[0] + '?_route=transactions';
                
                $.ajax({
                    url: ajaxUrl,
                    type: 'GET',
                    data: formData,
                    dataType: 'json',
                    success: function(data) {
                        updateTransactionsTable(data);
                    },
                    error: function(xhr, status, error) {
                        $('#transactionsTableBody').html('<tr><td colspan="12" class="text-center text-danger">Error loading transactions: ' + error + '</td></tr>');
                    }
                });
            }
            
            // Function to update the transactions table
            function updateTransactionsTable(transactions) {
        let html = '';
        
        if (transactions.length === 0) {
            html = '<tr><td colspan="12" class="text-center text-muted">No transactions found matching your criteria.</td></tr>';
        } else {
            transactions.forEach(function(pg) {
                let statusClass = '';
                let statusLabel = '';
                let statusBadge = '';
                
                switch(pg.status.toString()) {
                    case '1':
                        statusClass = 'warning';
                        statusLabel = 'PENDING';
                        statusBadge = 'label-warning';
                        break;
                    case '2':
                        statusClass = 'success';
                        statusLabel = 'PAID';
                        statusBadge = 'label-success';
                        break;
                    case '3':
                        statusClass = 'danger';
                        statusLabel = 'FAILED';
                        statusBadge = 'label-danger';
                        break;
                    default:
                        statusClass = 'active';
                        statusLabel = 'CANCELED';
                        statusBadge = 'label-default';
                }
                
                const createdDate = pg.created_date ? new Date(pg.created_date).toLocaleString() : '-';
                const paidDate = pg.paid_date ? new Date(pg.paid_date).toLocaleString() : '-';
                
                html += 
                    '<tr class="' + statusClass + '">' +
                        '<td><strong>#' + pg.id + '</strong></td>' +
                        '<td><span class="label label-success">' + pg.gateway.charAt(0).toUpperCase() + pg.gateway.slice(1) + '</span></td>' +
                        '<td><small class="text-muted">' + (pg.gateway_trx_id || '-') + '</small></td>' +
                        '<td><a href="{$_url}customers/viewu/' + pg.username + '" class="text-dark">' + pg.username + '</a></td>' +
                        '<td><small>' + pg.plan_name + '</small></td>' +
                        '<td><small class="text-muted">' + pg.routers + '</small></td>' +
                        '<td><strong>{$_c.currency_code} ' + parseFloat(pg.price).toFixed(2) + '</strong></td>' +
                        '<td><small>' + pg.payment_method + '</small></td>' +
                        '<td><small class="text-muted">' + pg.payment_channel + '</small></td>' +
                        '<td><small>' + createdDate + '</small></td>' +
                        '<td><small>' + paidDate + '</small></td>' +
                        '<td><span class="label ' + statusBadge + '">' + statusLabel + '</span></td>' +
                    '</tr>';
            });
        }
        
                $('#transactionsTableBody').html(html);
            }
            
            // Instant search on text input
            $('#q').on('input', function() {
                clearTimeout(filterTimeout);
                filterTimeout = setTimeout(performSearch, 300); // 300ms delay for performance
            });
            
            // Instant filter on dropdown changes
            $('#gateway, #status').on('change', performSearch);
            
            // Date filter
            $('#date_from, #date_to').on('change', performSearch);
            
            // Clear filters
            $('#clearFilters').on('click', function() {
                $('#q').val('');
                $('#gateway').val('');
                $('#status').val('');
                $('#date_from').val('');
                $('#date_to').val('');
                performSearch();
            });
            
        }); // End of $(document).ready()
        
    } // End of initializeTransactionsPage()
    
    // Start the initialization
    initializeTransactionsPage();
})(); // End of self-executing function
</script>
{include file="sections/footer.tpl"}