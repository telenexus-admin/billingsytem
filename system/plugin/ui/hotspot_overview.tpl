{include file="admin/header.tpl"}
<style>
    /* Page-specific: Hotspot Overview - uses professional-theme.css for cards/charts */
    .dark-mode .content,
    .dark-mode .content-header,
    .dark-mode .content-wrapper,
    .dark-mode .right-side {
        background-color: #151521;
    }

    .container-fluid { padding: 24px; background: #f8fafc; min-height: 100vh; }
    .dark-mode .container-fluid { background: #151521; }

    /* Transaction table - professional styling */
    .hotspot-overview .table {
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
    }

    .hotspot-overview .table thead th {
        background: #334155;
        color: #fff;
        font-weight: 600;
        padding: 14px 20px;
        border: none;
    }

    .hotspot-overview .table tbody td { padding: 12px 20px; }

    .table-striped tbody tr:nth-of-type(odd) { background-color: rgba(0, 0, 0, .02); }
    .dark-mode .table-striped tbody tr:nth-of-type(odd) { background-color: rgba(255,255,255,.03); }

    .table-hover tbody tr:hover {
        background-color: rgba(37, 99, 235, 0.06);
        transition: background-color 0.2s ease;
    }

    .dark-mode .table th,
    .dark-mode .table td { border-color: #334155; color: #e2e8f0; }
    .dark-mode .table thead th { background: #1e293b; }

    .pagination .page-item .page-link {
        border-radius: 6px;
        transition: all 0.2s ease;
    }

    @keyframes pulse-danger {
        0% {
            box-shadow: 0 0 0 0 rgba(220, 53, 69, 0.4);
        }

        70% {
            box-shadow: 0 0 0 10px rgba(220, 53, 69, 0);
        }

        100% {
            box-shadow: 0 0 0 0 rgba(220, 53, 69, 0);
        }
    }

    .btn-refresh {
        animation: pulse-danger 2s infinite;
    }
</style>
{if isset($message)}
<div class="alert alert-{if $notify_t == 's'}success{else}danger{/if}">
    <button type="button" class="close" data-dismiss="alert">
        <span aria-hidden="true">×</span>
    </button>
    <div>{$message}</div>
</div>
{/if}

<div class="container-fluid hotspot-overview">
    <!-- Summary Cards Row -->
    <div class="row">
        <div class="col-md-3">
            <div class="summary-card">
                <h5>{Lang::T('SUCCESSFUL PAYMENTS')}</h5>
                <div class="value">{$successfulPayments}</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="summary-card">
                <h5>{Lang::T('FAILED PAYMENTS')}</h5>
                <div class="value">{$failedPayments}</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="summary-card">
                <h5>{Lang::T('PENDING PAYMENTS')}</h5>
                <div class="value">{$pendingPayments}</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="summary-card">
                <h5>{Lang::T('TOTAL VOUCHERS')}</h5>
                <div class="value">{$totalVouchers|default:0}</div>
            </div>
        </div>
    </div>

    <div class="row" style="padding: 5px">
        <div class="col-lg-3 col-lg-offset-9">
            <div class="btn-group btn-group-justified" role="group">
                <div class="btn-group" role="group">
                    <a href="{Text::url('plugin/hotspot_overview')}&refresh"
                        class="btn btn-primary btn-block waves-effect modern-primary btn-refresh" name="createRouter"
                        value="">{Lang::T('Refresh Dashboard')}</a>
                </div>
            </div>
        </div>
    </div>
    <!-- Charts Row -->
    <div class="row">
        <div class="col-md-6">
            <div class="chart-container">
                <h4>{Lang::T('Daily Sales')}</h4>
                <div class="chart">
                    <canvas id="dailySalesChart" height="200"></canvas>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="chart-container">
                <h4>{Lang::T('Weekly Sales')}</h4>
                <div class="chart">
                    <canvas id="weekly-sales-chart" height="200"></canvas>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="chart-container">
                <h4>{Lang::T('Monthly Sales')}</h4>
                <div class="chart">
                    <canvas id="monthlySalesChart" height="200"></canvas>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="chart-container">
                <h4>{Lang::T('Hotspot Tokens')}</h4>
                <div class="chart" style="height: 200px;">
                    <canvas id="tokenChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <br><br>
    <div class="table-responsive">
        <table class="table table-bordered table-striped" id="historyTable">
            <thead>
                <tr>
                    <th>{Lang::T('Transaction Ref')}</th>
                    <th>{Lang::T('Router Name')}</th>
                    <th>{Lang::T('Plan Name')}</th>
                    <th>{Lang::T('Voucher Code')}</th>
                    <th>{Lang::T('Amount')}</th>
                    <th>{Lang::T('Mac Address')}</th>
                    <th>{Lang::T('Transaction Status')}</th>
                    <th>{Lang::T('Payment Gateway')}</th>
                    <th>{Lang::T('Payment Date')}</th>
                    <th>{Lang::T('Plan Expiry Date')}</th>
                    <th>{Lang::T('Action')}</th>
                </tr>
            </thead>
            <tbody>
                {foreach $payments as $payment}
                <tr>
                    <td>{$payment.transaction_ref}</td>
                    <td>{$payment.router_name}</td>
                    <td>{$payment.plan_name}</td>
                    <td>{$payment.voucher_code}</td>
                    <td>{$payment.amount}</td>
                    <td>{$payment.mac_address}</td>
                    <td><span
                            class="label {if $payment.transaction_status == paid}label-success {elseif $payment.transaction_status == pending}label-warning {elseif $payment.transaction_status == failed}label-danger {elseif $payment.transaction_status == cancelled}label-danger {/if}">{$payment.transaction_status}</span>
                    </td>
                    <td>{$payment.payment_gateway}</td>
                    <td>{$payment.payment_date}</td>
                    <td>{$payment.expired_date}</td>
                    <td>
                        <div class="btn-group pull-right">
                            <button type="button" class="btn btn-default dropdown-toggle"
                                data-toggle="dropdown">{Lang::T('Action')}</button>
                            <ul class="dropdown-menu pull-right" role="menu">
                                    {if $payment.transaction_status == 'paid' && $payment.voucher_code && $payment.voucher_code != '**********'}
                                    <li>
                                        <a href="{$_url}plugin/hotspot_sync_payment_to_mikrotik&id={$payment.id}" onclick="return confirm('{Lang::T('Add this voucher to MikroTik so customer can connect?')}');">
                                            {Lang::T('Sync to MikroTik')}</a>
                                    </li>
                                    {/if}
                                    <li>
                                        <a href="{$_url}plugin/hotspot_block_mac&block&mac={$payment.mac_address}">
                                            {Lang::T('Block Mac Address')}</a>
                                    </li>
                                    <li>
                                        <a href="{$_url}plugin/hotspot_block_mac&unblock&mac={$payment.mac_address}">
                                            {Lang::T('Unblock Mac Address')}</a>
                                    </li>
                            </ul>

                        </div>
                    </td>
                </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        // Chart data configuration
        var used = '{$used}';
        var unused ='{$unused}';
        const data = {
            labels: ['Active Tokens', 'Used Tokens'],
            datasets: [{
                data: [parseInt(unused), parseInt(used)],
                backgroundColor: [
                    'rgba(4, 191, 13, 0.8)',
                    'rgba(191, 35, 4, 0.8)'
                ],
                borderColor: [
                    'rgba(255, 255, 255, 0.8)',
                    'rgba(255, 255, 255, 0.8)'
                ],
                borderWidth: 2,
                hoverOffset: 15
            }]
        };

        // Optimized chart options
        const options = {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'right',
                    labels: {
                        boxWidth: 20,
                        padding: 15,
                        font: {
                            size: 12
                        }
                    }
                },
                tooltip: {
                    bodyFont: {
                        size: 14
                    }
                }
            },
            animation: {
                duration: 1000,
                easing: 'easeOutQuad'
            }
        };

        // Chart creation
        const ctx = document.getElementById('tokenChart').getContext('2d');
        new Chart(ctx, {
            type: 'pie',
            data: data,
            options: options
        });
    });

    var monthlyData = {$monthlyData};
    // Prepare the chart data
    var chartData = {
        labels: Object.keys(monthlyData),
        datasets: [{
            data: Object.values(monthlyData),
            backgroundColor: [
                'rgba(255, 99, 132, 0.7)',
                'rgba(54, 162, 235, 0.7)',
                'rgba(255, 206, 86, 0.7)',
            ]
        }]
    };

    // Get the canvas element and initialize the chart
    var canvas = document.getElementById('monthlySalesChart');
    var ctx = canvas.getContext('2d');
    var chart = new Chart(ctx, {
        type: 'pie',
        data: chartData,
        options: {
            responsive: true,
            maintainAspectRatio: false,
        }
    });

    var dailySalesData = {$dailySalesData};
    var chartData = [];
    for (var date in dailySalesData) {
        if (dailySalesData.hasOwnProperty(date)) {
            chartData.push({
                date: date,
                total_sales: dailySalesData[date]
            });
        }
    }

    chartData.sort(function (a, b) {
        return new Date(a.date) - new Date(b.date);
    });

    var ctx = document.getElementById('dailySalesChart').getContext('2d');

    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: chartData.map(function (sale) {
                return sale.date;
            }),
            datasets: [{
                label: 'Today Sales',
                data: chartData.map(function (sale) {
                    return sale.total_sales;
                }),
                backgroundColor: createGradient(ctx, '#3B82F6', '#1D4ED8'),
                hoverBackgroundColor: '#2563eb',
                borderRadius: 6,
                borderWidth: 0,
                categoryPercentage: 0.8,
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                tooltip: {
                    backgroundColor: '#1e293b',
                    titleColor: '#f8fafc',
                    bodyColor: '#e2e8f0',
                    borderColor: '#334155',
                    borderWidth: 1,
                    padding: 12,
                    cornerRadius: 4
                },
                legend: {
                    display: false
                }
            },
            scales: {
                x: {
                    grid: {
                        display: false
                    }
                },
                y: {
                    grid: {
                        color: '#e2e8f0'
                    },
                    ticks: {
                        callback: function (value) {
                            return '$' + value;
                        }
                    }
                }
            },
            animation: {
                duration: 1000,
                easing: 'easeOutQuart'
            }
        }
    });

    function createGradient(ctx, color1, color2) {
        const gradient = ctx.createLinearGradient(0, 0, 0, 400);
        gradient.addColorStop(0, color1);
        gradient.addColorStop(1, color2);
        return gradient;
    }
    document.addEventListener('DOMContentLoaded', function () {
        var chartData = {$chartData};
        console.log(chartData);

        var ctx = document.getElementById('weekly-sales-chart').getContext('2d');
        var myChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: chartData.labels,
                datasets: [{
                    label: 'Weekly Sales',
                    data: chartData.data,
                    backgroundColor: createGradient(ctx, '#10B981', '#059669'),
                    hoverBackgroundColor: '#059669',
                    borderRadius: 6,
                    borderWidth: 0,
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    tooltip: {
                        backgroundColor: '#1e293b',
                        titleColor: '#f8fafc',
                        bodyColor: '#e2e8f0',
                        borderColor: '#334155',
                        borderWidth: 1,
                        padding: 12,
                        cornerRadius: 4
                    },
                    legend: {
                        display: false
                    }
                },
                scales: {
                    x: {
                        grid: {
                            display: false
                        }
                    },
                    y: {
                        grid: {
                            color: '#e2e8f0'
                        },
                        ticks: {
                            callback: function (value) {
                                return '$' + value;
                            }
                        }
                    }
                },
                animation: {
                    duration: 1000,
                    easing: 'easeOutQuart'
                }
            }
        });
    });
</script>
<script src="https://cdn.datatables.net/1.11.3/js/jquery.dataTables.min.js"></script>
<script>
    var $j = jQuery.noConflict();

    $j(document).ready(function () {
        $j('#historyTable').DataTable({
            "pagingType": "full_numbers",
            "order": [
                [8, 'desc']
            ]
        });
    });
</script>

<script>
    window.addEventListener('DOMContentLoaded', function () {
        const portalLink = "https://t.me/focuslinkstech";
        const updateLink = "{$updateLink}";
        const productName = "{$productName}";
        const version = "{$version}";
        if (updateLink !== "") {
            $('#version').html(productName + ' | Ver: ' + version + ' | <a href="' + updateLink + '">Update Available</a> | by: <a href="' + portalLink + '">Focuslinks Tech</a>');
        } else {
            $('#version').html(productName + ' | Ver: ' + version + ' | by: <a href="' + portalLink + '">Focuslinks Tech</a>');
        }
    });
</script>

{include file="admin/footer.tpl"}