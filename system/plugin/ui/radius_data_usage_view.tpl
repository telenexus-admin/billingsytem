{include file="sections/header.tpl"}
<style>
    .card {
        border: 1px solid #ddd;
        border-radius: 4px;
        margin-bottom: 20px;
        background: white;
    }

    .card-header {
        background: #f8f9fa;
        color: #333;
        border-bottom: 1px solid #ddd;
        padding: 15px;
        font-weight: 600;
    }

    .chart-container {
        height: 350px;
        min-height: 350px;
    }

    .info-metric {
        background: white;
        border: 1px solid #ddd;
        padding: 20px;
        border-radius: 4px;
        margin-bottom: 15px;
    }

    .metric-value {
        font-size: 1.5rem;
        font-weight: 600;
        color: #333;
        margin-bottom: 0.25rem;
    }

    .metric-label {
        font-size: 0.875rem;
        color: #666;
    }

    .form-control {
        border: 1px solid #ddd;
        border-radius: 4px;
        padding: 8px 12px;
    }

    .btn {
        border-radius: 4px;
        padding: 8px 16px;
        border: 1px solid #ddd;
        background: white;
        color: #333;
    }

    .btn-primary {
        background: #007bff;
        color: white;
        border-color: #007bff;
    }

    .alert {
        border: 1px solid #ddd;
        border-radius: 4px;
        padding: 12px;
        margin-bottom: 20px;
    }

    .alert-info {
        background: #d1ecf1;
        color: #0c5460;
        border-color: #bee5eb;
    }
</style>

    .card-title {
        margin: 0;
        font-size: 16px;
        display: flex;
        align-items: center;
        gap: 8px;
        color: white;
    }

    .chart-container {
        position: relative;
        height: 350px;
        min-height: 350px;
    }

    .chart-actions {
        margin-top: 15px;
        text-align: center;
        gap: 10px;
    }

    .info-metric {
        background: white;
        border-left: 4px solid #2c5aa0;
        padding: 20px;
        border-radius: 8px;
        margin-bottom: 15px;
        transition: all 0.3s ease;
        box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    }

    .info-metric:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.15);
    }

    .info-metric.download {
        border-left-color: #17a2b8;
    }

    .info-metric.upload {
        border-left-color: #dc3545;
    }

    .info-metric.total {
        border-left-color: #28a745;
    }

    .info-metric.source {
        border-left-color: #ffc107;
    }

    .metric-icon {
        font-size: 2rem;
        margin-bottom: 0.5rem;
        opacity: 0.8;
    }

    .metric-value {
        font-size: 1.5rem;
        font-weight: 600;
        color: var(--dark-color);
        margin-bottom: 0.25rem;
    }

    .metric-label {
        font-size: 0.875rem;
        color: var(--secondary-color);
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .form-floating {
        margin-bottom: 1rem;
    }

    .btn {
        border-radius: 4px;
        padding: 8px 16px;
        font-weight: 500;
        transition: all 0.3s ease;
        border: none;
        display: inline-flex;
        align-items: center;
        gap: 5px;
    }

    .btn-primary {
        background: linear-gradient(135deg, #2c5aa0, #1e4080);
        color: white;
    }

    .btn-primary:hover {
        background: linear-gradient(135deg, #1e4080, #1a3670);
        transform: translateY(-1px);
    }

    .btn-outline-secondary {
        border: 1px solid #ddd;
        color: #333;
        background: white;
    }

    .btn-outline-secondary:hover {
        background: #f8f9fa;
        border-color: #2c5aa0;
        color: #2c5aa0;
    }

    .alert {
        border-radius: 6px;
        border: none;
        padding: 12px 16px;
        margin-bottom: 20px;
    }

    .alert-info {
        background: #d1ecf1;
        color: #0c5460;
        border-left: 4px solid #17a2b8;
    }

    .form-control {
        border-radius: 4px;
        border: 1px solid #ddd;
        padding: 8px 12px;
        transition: border-color 0.3s ease;
    }

    .form-control:focus {
        border-color: #2c5aa0;
        box-shadow: 0 0 0 2px rgba(44, 90, 160, 0.2);
    }

    .package-status {
        display: inline-block;
        padding: 0.25rem 0.75rem;
        border-radius: 50px;
        font-size: 0.75rem;
        font-weight: 600;
        text-transform: uppercase;
    }

    .package-status.active {
        background-color: var(--success-color);
        color: white;
    }

    .package-status.inactive {
        background-color: var(--secondary-color);
        color: white;
    }

    .loading-spinner {
        display: none;
        text-align: center;
        padding: 2rem;
    }

    @media (max-width: 768px) {
        .chart-container {
            height: 250px;
            min-height: 250px;
        }
        
        .metric-value {
            font-size: 1.25rem;
        }
        
        .info-metric {
            padding: 1rem;
        }
    }
</style>

<div class="container-fluid">
    <div class="row g-4">
        <div class="col-lg-6">
            <!-- Package Details -->
            <div class="card h-100">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="card-title mb-0">
                        <i class="fas fa-box me-2"></i>{Lang::T('Current Package Details')}
                    </h5>
                    <div class="btn-group" role="group">
                        <button type="button" class="btn btn-outline-secondary btn-sm" data-bs-toggle="collapse" data-bs-target="#packageDetails">
                            <i class="fas fa-chevron-down"></i>
                        </button>
                    </div>
                </div>
                <div class="card-body collapse show" id="packageDetails">
                    {foreach $packages as $package}
                    <div class="mb-4">
                        <h6 class="text-center mb-3 text-primary">{$package['type']} - {$package['namebp']}</h6>
                        <div class="list-group list-group-flush">
                            <div class="list-group-item d-flex justify-content-between align-items-center border-0 px-0">
                                {Lang::T('Status')}
                                <span class="package-status {if $package['status']=='on'}active{else}inactive{/if}">
                                    {if $package['status']=='on'}Active{else}Inactive{/if}
                                </span>
                            </div>
                            <div class="list-group-item d-flex justify-content-between align-items-center border-0 px-0">
                                {Lang::T('Type')}
                                <span class="badge bg-{if $package['prepaid'] eq yes}warning{else}primary{/if}">
                                    {if $package['prepaid'] eq yes}Prepaid{else}Postpaid{/if}
                                </span>
                            </div>
                            <div class="list-group-item d-flex justify-content-between align-items-center border-0 px-0">
                                {Lang::T('Created On')}
                                <span class="text-muted">{Lang::dateAndTimeFormat($package['recharged_on'],$package['recharged_time'])}</span>
                            </div>
                            <div class="list-group-item d-flex justify-content-between align-items-center border-0 px-0">
                                {Lang::T('Expires On')}
                                <span class="text-muted">{Lang::dateAndTimeFormat($package['expiration'], $package['time'])}</span>
                            </div>
                            <div class="list-group-item d-flex justify-content-between align-items-center border-0 px-0">
                                {$package['routers']}
                                <span class="badge bg-secondary">{$package['method']}</span>
                            </div>
                        </div>
                        <div class="row g-2 mt-3">
                            <div class="col-4">
                                <a href="{$_url}customers/deactivate/{$d['id']}/{$package['plan_id']}" 
                                   class="btn btn-danger btn-modern w-100 btn-sm"
                                   onclick="return confirm('This will deactivate Customer Plan, and make it expired')">
                                    <i class="fas fa-times me-1"></i>{Lang::T('Deactivate')}
                                </a>
                            </div>
                            <div class="col-8">
                                <a href="{$_url}customers/recharge/{$d['id']}/{$package['plan_id']}"
                                   class="btn btn-success btn-modern w-100 btn-sm">
                                    <i class="fas fa-plus me-1"></i>{Lang::T('Recharge')}
                                </a>
                            </div>
                        </div>
                    </div>
                    {if !$smarty.foreach.packages.last}<hr>{/if}
                    {/foreach}
                </div>
            </div>
        </div>
        
        <div class="col-lg-6">
            <!-- Filter Section -->
            <div class="card h-100">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="card-title mb-0">
                        <i class="fas fa-filter me-2"></i>{Lang::T('Filter Data Usages')}
                    </h5>
                    <button type="button" class="btn btn-outline-secondary btn-sm" data-bs-toggle="collapse" data-bs-target="#filterSection">
                        <i class="fas fa-chevron-down"></i>
                    </button>
                </div>
                <div class="card-body collapse show" id="filterSection">
                    <form action="{$_url}plugin/radius_data_usage/{$username}" method="post" id="filterForm">
                        <div class="form-floating">
                            <input class="form-control" value="{$start_date}" type="date" 
                                   id="start_date" name="start_date" max="{$smarty.now|date_format:'%Y-%m-%d'}">
                            <label for="start_date">{Lang::T('Start Date')}</label>
                        </div>
                        <div class="form-floating">
                            <input class="form-control" value="{$end_date}" type="date" 
                                   id="end_date" name="end_date" max="{$smarty.now|date_format:'%Y-%m-%d'}">
                            <label for="end_date">{Lang::T('End Date')}</label>
                        </div>
                        <div class="form-check mb-3">
                            <input class="form-check-input" type="checkbox" name="force_live" value="1" id="force_live">
                            <label class="form-check-label" for="force_live">
                                {Lang::T('Force live data (ignore historical)')}
                            </label>
                        </div>
                        <div class="d-grid gap-2 d-md-flex">
                            <button class="btn btn-primary btn-modern flex-fill" type="submit">
                                <i class="fas fa-filter me-2"></i>{Lang::T('Filter')}
                            </button>
                            <button type="button" class="btn btn-info btn-modern" onclick="resetDates()">
                                <i class="fas fa-calendar me-2"></i>{Lang::T('This Month')}
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4 mt-1">
        <div class="col-12">
            <!-- Daily Usage Chart -->
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="card-title mb-0">
                        <i class="fas fa-chart-line me-2"></i>{Lang::T('Daily Data Usage')} 
                        <small class="text-muted">({Lang::T('From')} {$start_date} {Lang::T('To')} {$end_date})</small>
                    </h5>
                    <div class="btn-group" role="group">
                        <button type="button" class="btn btn-outline-secondary btn-sm dropdown-toggle" 
                                data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-cog"></i>
                        </button>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item reset-zoom" data-chart="dataChart" href="#">
                                <i class="fas fa-search-minus me-2"></i>{Lang::T('Reset Zoom')}
                            </a></li>
                            <li><a class="dropdown-item export-chart" data-chart="dataChart" href="#">
                                <i class="fas fa-download me-2"></i>{Lang::T('Export as Image')}
                            </a></li>
                        </ul>
                    </div>
                </div>
                <div class="card-body">
                    <div class="alert alert-modern alert-info d-flex align-items-center" role="alert">
                        <i class="fas fa-info-circle me-2"></i>
                        {Lang::T('Data for dates older than 30 days comes from historical records.')}
                    </div>
                    <div class="loading-spinner" id="chartLoading">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                        <p class="mt-2 text-muted">Loading chart data...</p>
                    </div>
                    <div class="chart-container">
                        <canvas id="dataChart"></canvas>
                    </div>
                    <div class="chart-actions d-flex justify-content-center">
                        <button class="btn btn-outline-secondary btn-sm me-2 reset-zoom" data-chart="dataChart">
                            <i class="fas fa-search-minus me-1"></i>{Lang::T('Reset Zoom')}
                        </button>
                        <button class="btn btn-outline-secondary btn-sm export-chart" data-chart="dataChart">
                            <i class="fas fa-download me-1"></i>{Lang::T('Export')}
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4 mt-1">
        <div class="col-lg-6">
            <!-- Total Usage Pie Chart -->
            <div class="card h-100">
                <div class="card-header">
                    <h5 class="card-title mb-0">
                        <i class="fas fa-chart-pie me-2"></i>{Lang::T('Total Usage Breakdown')}
                    </h5>
                </div>
                <div class="card-body">
                    <div class="chart-container">
                        <canvas id="totalUsageChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-lg-6">
            <!-- Summary Metrics -->
            <div class="card h-100">
                <div class="card-header">
                    <h5 class="card-title mb-0">
                        <i class="fas fa-chart-bar me-2"></i>{Lang::T('Usage Summary')}
                    </h5>
                </div>
                <div class="card-body">
                    <div class="info-metric download">
                        <div class="d-flex align-items-center">
                            <div class="metric-icon text-info me-3">
                                <i class="fas fa-download"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="metric-label">{Lang::T('Total Download')}</div>
                                <div class="metric-value">
                                    {($totalDownload/1024/1024)|string_format:"%.2f"} MB
                                </div>
                                <small class="text-muted">
                                    {($totalDownload/1024/1024/1024)|string_format:"%.2f"} GB
                                </small>
                            </div>
                        </div>
                    </div>
                    
                    <div class="info-metric upload">
                        <div class="d-flex align-items-center">
                            <div class="metric-icon text-danger me-3">
                                <i class="fas fa-upload"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="metric-label">{Lang::T('Total Upload')}</div>
                                <div class="metric-value">
                                    {($totalUpload/1024/1024)|string_format:"%.2f"} MB
                                </div>
                                <small class="text-muted">
                                    {($totalUpload/1024/1024/1024)|string_format:"%.2f"} GB
                                </small>
                            </div>
                        </div>
                    </div>
                    
                    <div class="info-metric total">
                        <div class="d-flex align-items-center">
                            <div class="metric-icon text-success me-3">
                                <i class="fas fa-exchange-alt"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="metric-label">{Lang::T('Total Usage')}</div>
                                <div class="metric-value">
                                    {($totalDownload/1024/1024 + $totalUpload/1024/1024)|string_format:"%.2f"} MB
                                </div>
                                <small class="text-muted">
                                    {(($totalDownload + $totalUpload)/1024/1024/1024)|string_format:"%.2f"} GB
                                </small>
                            </div>
                        </div>
                    </div>
                    
                    <div class="info-metric source">
                        <div class="d-flex align-items-center">
                            <div class="metric-icon text-warning me-3">
                                <i class="fas fa-database"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="metric-label">{Lang::T('Data Source')}</div>
                                <div class="metric-value">
                                    {if $use_history}{Lang::T('Historical Records')}{else}{Lang::T('Live Data')}{/if}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// Simple data usage charts without animations
class DataUsageCharts {
    constructor() {
        this.charts = {};
        this.init();
    }

    init() {
        document.addEventListener('DOMContentLoaded', () => {
            this.initializeCharts();
        });
    }

    resetDates() {
        const today = new Date();
        const firstDay = new Date(today.getFullYear(), today.getMonth(), 1);
        const lastDay = new Date(today.getFullYear(), today.getMonth() + 1, 0);
        
        document.getElementById('start_date').valueAsDate = firstDay;
        document.getElementById('end_date').valueAsDate = lastDay;
    }

    initializeCharts() {
        try {
            this.initDataChart();
            this.initPieChart();
        } catch (error) {
            console.error('Error initializing charts:', error);
        }
    }

    initDataChart() {
        const data = JSON.parse('{$chart_data|escape:"javascript"}');
        const ctx = document.getElementById('dataChart').getContext('2d');
        
        this.charts.dataChart = new Chart(ctx, {
            type: 'line',
            data: data,
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: true
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    }

    initPieChart() {
        const totalDownload = {$totalDownload};
        const totalUpload = {$totalUpload};
        const ctx = document.getElementById('totalUsageChart').getContext('2d');
        
        this.charts.totalUsageChart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['{Lang::T('Download')}', '{Lang::T('Upload')}'],
                datasets: [{
                    data: [totalDownload, totalUpload],
                    backgroundColor: ['#36a2eb', '#ff6384']
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false
            }
        });
    }
}

// Global function for backward compatibility
function resetDates() {
    const today = new Date();
    const firstDay = new Date(today.getFullYear(), today.getMonth(), 1);
    const lastDay = new Date(today.getFullYear(), today.getMonth() + 1, 0);
    
    document.getElementById('start_date').valueAsDate = firstDay;
    document.getElementById('end_date').valueAsDate = lastDay;
}

// Initialize the application
const dataUsageApp = new DataUsageCharts();
</script>

    // Initialize main data chart
    initDataChart() {
        const data = JSON.parse('{$chart_data|escape:"javascript"}');
        const ctx = document.getElementById('dataChart').getContext('2d');
        
        this.charts.dataChart = new Chart(ctx, {
            type: 'line',
            data: data,
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    zoom: {
                        zoom: {
                            wheel: { enabled: true },
                            pinch: { enabled: true },
                            mode: 'xy',
                        },
                        pan: {
                            enabled: true,
                            mode: 'xy',
                            threshold: 10
                        },
                        limits: {
                            x: { min: 'original', max: 'original' },
                            y: { min: 'original', max: 'original' }
                        }
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.8)',
                        titleColor: '#fff',
                        bodyColor: '#fff',
                        cornerRadius: 8,
                        displayColors: true,
                        callbacks: {
                            label: function(context) {
                                return context.dataset.label + ': ' + context.raw + ' MB';
                            },
                            footer: function(tooltipItems) {
                                var total = tooltipItems.reduce(function(sum, item) {
                                    return sum + item.parsed.y;
                                }, 0);
                                return '{Lang::T('Total')}: ' + total + ' MB';
                            }
                        }
                    },
                    legend: {
                        position: 'top',
                        labels: {
                            usePointStyle: true,
                            padding: 20
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: '{Lang::T('Data Usage (MB)')}',
                            font: { weight: 'bold' }
                        },
                        ticks: {
                            callback: function(value) {
                                return value.toLocaleString() + ' MB';
                            }
                        },
                        grid: {
                            color: 'rgba(0, 0, 0, 0.1)'
                        }
                    },
                    x: {
                        title: {
                            display: true,
                            text: '{Lang::T('Day of Month')}',
                            font: { weight: 'bold' }
                        },
                        grid: {
                            color: 'rgba(0, 0, 0, 0.1)'
                        }
                    }
                },
                interaction: {
                    intersect: false,
                    mode: 'index'
                }
            }
        });
    }

    // Initialize pie chart
    initPieChart() {
        const totalDownload = {$totalDownload};
        const totalUpload = {$totalUpload};
        const ctx = document.getElementById('totalUsageChart').getContext('2d');
        
        this.charts.totalUsageChart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['{Lang::T('Download')}', '{Lang::T('Upload')}'],
                datasets: [{
                    data: [totalDownload, totalUpload],
                    backgroundColor: [
                        'rgba(13, 202, 240, 0.8)',
                        'rgba(220, 53, 69, 0.8)'
                    ],
                    borderColor: [
                        'rgba(13, 202, 240, 1)',
                        'rgba(220, 53, 69, 1)'
                    ],
                    borderWidth: 2,
                    hoverOffset: 10
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '60%',
                plugins: {
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.8)',
                        titleColor: '#fff',
                        bodyColor: '#fff',
                        cornerRadius: 8,
                        callbacks: {
                            label: function(context) {
                                var label = context.label || '';
                                var value = context.raw;
                                var mb = (value / 1024 / 1024).toFixed(2);
                                var gb = (value / 1024 / 1024 / 1024).toFixed(2);
                                var percentage = ((value / (totalDownload + totalUpload)) * 100).toFixed(1);
                                return label + ': ' + parseFloat(mb).toLocaleString() + ' MB (' + parseFloat(gb).toLocaleString() + ' GB) - ' + percentage + '%';
                            }
                        }
                    },
                    legend: {
                        position: 'bottom',
                        labels: {
                            usePointStyle: true,
                            padding: 20
                        }
                    }
                }
            }
        });
    }

    // Bind event listeners
    bindEvents() {
        var self = this;
        // Reset zoom buttons
        document.querySelectorAll('.reset-zoom').forEach(function(button) {
            button.addEventListener('click', function(e) {
                e.preventDefault();
                var chartId = button.dataset.chart;
                if (self.charts[chartId]) {
                    self.charts[chartId].resetZoom();
                }
            });
        });

        // Export chart buttons
        document.querySelectorAll('.export-chart').forEach(function(button) {
            button.addEventListener('click', function(e) {
                e.preventDefault();
                var chartId = button.dataset.chart;
                var canvas = document.getElementById(chartId);
                if (canvas) {
                    canvas.toBlob(function(blob) {
                        saveAs(blob, chartId + '-export.png');
                    });
                }
            });
        });

        // Form submission with loading state
        var filterForm = document.getElementById('filterForm');
        if (filterForm) {
            filterForm.addEventListener('submit', function() {
                self.showLoading();
            });
        }

        // Responsive chart handling
        window.addEventListener('resize', this.debounce(function() {
            Object.keys(self.charts).forEach(function(key) {
                var chart = self.charts[key];
                if (chart) chart.resize();
            });
        }, 250));
    }

    // Debounce utility function
    debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    }
}

// Global function for backward compatibility
function resetDates() {
    const today = new Date();
    const firstDay = new Date(today.getFullYear(), today.getMonth(), 1);
    const lastDay = new Date(today.getFullYear(), today.getMonth() + 1, 0);
    
    document.getElementById('start_date').valueAsDate = firstDay;
    document.getElementById('end_date').valueAsDate = lastDay;
}

// Initialize the application
const dataUsageApp = new DataUsageCharts();
</script>

{include file="sections/footer.tpl"}