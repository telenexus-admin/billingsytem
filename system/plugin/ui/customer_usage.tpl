{include file="sections/header.tpl"}

<!-- Include required libraries -->
<link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0/dist/chartjs-plugin-datalabels.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-adapter-date-fns@3.0.0/dist/chartjs-adapter-date-fns.bundle.min.js"></script>

<style>
    :root {
        --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        --success-gradient: linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%);
        --danger-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        --warning-gradient: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
    }
    
    .chart-container {
        position: relative;
        height: 350px;
    }
    
    .loading-spinner {
        border: 3px solid #f3f3f3;
        border-top: 3px solid #3498db;
        border-radius: 50%;
        width: 20px;
        height: 20px;
        animation: spin 1s linear infinite;
        display: inline-block;
        margin-left: 10px;
    }
    
    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }
    
    .card-hover {
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }
    
    .card-hover:hover {
        transform: translateY(-4px);
        box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.02);
    }
    
    .status-indicator {
        width: 10px;
        height: 10px;
        border-radius: 50%;
        display: inline-block;
        margin-right: 8px;
        animation: pulse 2s infinite;
    }
    
    @keyframes pulse {
        0% { transform: scale(0.95); opacity: 0.7; }
        70% { transform: scale(1); opacity: 1; }
        100% { transform: scale(0.95); opacity: 0.7; }
    }
    
    .status-online {
        background-color: #10b981;
        box-shadow: 0 0 0 0 rgba(16, 185, 129, 0.5);
    }
    
    .status-offline {
        background-color: #ef4444;
        animation: none;
    }
    
    .glass-effect {
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(10px);
    }
    
    .gradient-text {
        background: var(--primary-gradient);
        -webkit-background-clip: text;
        background-clip: text;
        color: transparent;
    }
    
    .table-row-hover {
        transition: all 0.2s ease;
    }
    
    .table-row-hover:hover {
        background: linear-gradient(90deg, rgba(102, 126, 234, 0.05) 0%, rgba(118, 75, 162, 0.05) 100%);
        transform: scale(1.01);
    }
    
    .btn-pulse {
        animation: btnPulse 1.5s ease-out infinite;
    }
    
    @keyframes btnPulse {
        0% { box-shadow: 0 0 0 0 rgba(102, 126, 234, 0.4); }
        70% { box-shadow: 0 0 0 10px rgba(102, 126, 234, 0); }
        100% { box-shadow: 0 0 0 0 rgba(102, 126, 234, 0); }
    }
    
    .stat-card {
        position: relative;
        overflow: hidden;
    }
    
    .stat-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
        transition: left 0.5s;
    }
    
    .stat-card:hover::before {
        left: 100%;
    }
    
    .badge {
        display: inline-flex;
        align-items: center;
        padding: 0.25rem 0.75rem;
        border-radius: 9999px;
        font-size: 0.75rem;
        font-weight: 600;
        letter-spacing: 0.025em;
    }
    
    .badge-success {
        background: linear-gradient(135deg, #10b981 0%, #059669 100%);
        color: white;
    }
    
    .badge-warning {
        background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
        color: white;
    }
    
    .badge-info {
        background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
        color: white;
    }
    
    .badge-danger {
        background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
        color: white;
    }
    
    .floating-btn {
        position: relative;
        overflow: hidden;
    }
    
    .floating-btn::after {
        content: '';
        position: absolute;
        top: 50%;
        left: 50%;
        width: 0;
        height: 0;
        border-radius: 50%;
        background: rgba(255,255,255,0.3);
        transform: translate(-50%, -50%);
        transition: width 0.3s, height 0.3s;
    }
    
    .floating-btn:active::after {
        width: 100%;
        height: 100%;
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
    
    .notification {
        animation: slideIn 0.3s ease-out;
    }
    
    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    
    .animate-fadeInUp {
        animation: fadeInUp 0.3s ease-out;
    }
    
    button {
        position: relative;
        overflow: hidden;
    }
</style>

<div class="min-h-screen bg-gradient-to-br from-gray-50 via-gray-100 to-gray-200 p-4 lg:p-8">
    <!-- Header Section -->
    <div class="mb-8">
        <div class="flex flex-col lg:flex-row justify-between items-start lg:items-center gap-6">
            <div class="flex items-center space-x-4">
                <div class="p-3 bg-gradient-to-br from-blue-500 to-purple-600 rounded-2xl shadow-lg transform rotate-3 hover:rotate-0 transition-transform duration-300">
                    <i class="fas fa-chart-line text-2xl text-white"></i>
                </div>
                <div>
                    <h1 class="text-4xl font-bold gradient-text">
                        Client Usage Analytics
                    </h1>
                    <p class="text-gray-600 mt-2 flex items-center">
                        <i class="fas fa-chart-simple text-blue-500 mr-2"></i>
                        Real-time monitoring & intelligent insights
                    </p>
                </div>
            </div>
            
            <div class="flex flex-wrap gap-3">
                <button onclick="exportData()" class="group bg-gradient-to-r from-green-500 to-emerald-600 hover:from-green-600 hover:to-emerald-700 text-white px-6 py-3 rounded-xl flex items-center gap-3 transition-all duration-300 shadow-lg hover:shadow-xl transform hover:scale-105">
                    <i class="fas fa-download group-hover:animate-bounce"></i>
                    <span class="font-semibold">Export Data</span>
                </button>
                
                <button onclick="refreshData()" id="refreshBtn" class="group bg-gradient-to-r from-blue-500 to-indigo-600 hover:from-blue-600 hover:to-indigo-700 text-white px-6 py-3 rounded-xl flex items-center gap-3 transition-all duration-300 shadow-lg hover:shadow-xl transform hover:scale-105">
                    <i class="fas fa-sync-alt" id="refreshIcon"></i>
                    <span class="font-semibold">Refresh</span>
                </button>
                
                <button onclick="toggleRealTime()" id="realTimeBtn" class="group bg-gradient-to-r from-purple-500 to-pink-600 hover:from-purple-600 hover:to-pink-700 text-white px-6 py-3 rounded-xl flex items-center gap-3 transition-all duration-300 shadow-lg hover:shadow-xl transform hover:scale-105">
                    <i class="fas fa-broadcast-tower"></i>
                    <span class="font-semibold">Live Mode</span>
                </button>
            </div>
        </div>
    </div>

    <!-- Stats Cards -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <!-- Total Users Card -->
        <div class="stat-card bg-white rounded-2xl p-6 card-hover shadow-lg border border-gray-100">
            <div class="flex items-center justify-between">
                <div>
                    <div class="flex items-center gap-2 mb-2">
                        <i class="fas fa-users text-blue-500 text-sm"></i>
                        <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">Total Users</p>
                    </div>
                    <p class="text-4xl font-black text-gray-900">{$total_users|number_format}</p>
                    <p class="text-xs text-gray-500 mt-2 flex items-center">
                        <i class="fas fa-chart-line text-green-500 mr-1"></i>
                        Active community
                    </p>
                </div>
                <div class="bg-gradient-to-br from-blue-400 to-blue-600 p-4 rounded-2xl shadow-lg">
                    <i class="fas fa-user-friends text-2xl text-white"></i>
                </div>
            </div>
        </div>

        <!-- Active Users Card -->
        <div class="stat-card bg-white rounded-2xl p-6 card-hover shadow-lg border border-gray-100">
            <div class="flex items-center justify-between">
                <div>
                    <div class="flex items-center gap-2 mb-2">
                        <span class="status-indicator status-online"></span>
                        <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">Active Now</p>
                    </div>
                    <p class="text-4xl font-black text-green-600">{$active|count}</p>
                    <p class="text-xs text-gray-500 mt-2 flex items-center">
                        <i class="fas fa-clock text-orange-500 mr-1"></i>
                        Last 2 minutes
                    </p>
                </div>
                <div class="bg-gradient-to-br from-green-400 to-green-600 p-4 rounded-2xl shadow-lg">
                    <i class="fas fa-wifi text-2xl text-white"></i>
                </div>
            </div>
        </div>

        <!-- Stations Card -->
        <div class="stat-card bg-white rounded-2xl p-6 card-hover shadow-lg border border-gray-100">
            <div class="flex items-center justify-between">
                <div>
                    <div class="flex items-center gap-2 mb-2">
                        <i class="fas fa-router text-purple-500 text-sm"></i>
                        <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">Active Stations</p>
                    </div>
                    <p class="text-4xl font-black text-purple-600">{$station_labels|count}</p>
                    <p class="text-xs text-gray-500 mt-2 flex items-center">
                        <i class="fas fa-signal text-blue-500 mr-1"></i>
                        Network coverage
                    </p>
                </div>
                <div class="bg-gradient-to-br from-purple-400 to-purple-600 p-4 rounded-2xl shadow-lg">
                    <i class="fas fa-network-wired text-2xl text-white"></i>
                </div>
            </div>
        </div>

        <!-- Pagination Info Card -->
        <div class="stat-card bg-white rounded-2xl p-6 card-hover shadow-lg border border-gray-100">
            <div class="flex items-center justify-between">
                <div>
                    <div class="flex items-center gap-2 mb-2">
                        <i class="fas fa-list-ol text-indigo-500 text-sm"></i>
                        <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">Current View</p>
                    </div>
                    <p class="text-2xl font-black text-gray-900">Page {$current_page}/{$total_pages}</p>
                    <p class="text-xs text-gray-500 mt-2 flex items-center">
                        <i class="fas fa-eye text-green-500 mr-1"></i>
                        Records {$start_record}-{$end_record}
                    </p>
                </div>
                <div class="bg-gradient-to-br from-indigo-400 to-indigo-600 p-4 rounded-2xl shadow-lg">
                    <i class="fas fa-list text-2xl text-white"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- Analytics Charts -->
    <div class="grid grid-cols-1 xl:grid-cols-3 gap-8 mb-8">
        <!-- Station Distribution -->
        <div class="xl:col-span-1">
            <div class="bg-white rounded-2xl p-6 shadow-xl border border-gray-100">
                <div class="flex items-center justify-between mb-6">
                    <div>
                        <h3 class="text-xl font-bold text-gray-900 flex items-center gap-3">
                            <i class="fas fa-chart-pie text-blue-500"></i>
                            Station Distribution
                        </h3>
                        <p class="text-gray-600 text-sm mt-1">Active users by location</p>
                    </div>
                    <div class="flex items-center gap-2 bg-gradient-to-r from-blue-50 to-purple-50 px-3 py-1 rounded-full">
                        <span class="status-indicator status-online"></span>
                        <span class="text-xs font-bold text-blue-600">Live Data</span>
                    </div>
                </div>
                <div class="chart-container">
                    <canvas id="stationChart"></canvas>
                </div>
            </div>
        </div>

        <!-- Usage Trends -->
        <div class="xl:col-span-2">
            <div class="bg-white rounded-2xl p-6 shadow-xl border border-gray-100">
                <div class="flex items-center justify-between mb-6">
                    <div>
                        <h3 class="text-xl font-bold text-gray-900 flex items-center gap-3">
                            <i class="fas fa-chart-bar text-green-500"></i>
                            Top Data Consumers
                        </h3>
                        <p class="text-gray-600 text-sm mt-1">Highest upload usage (All time)</p>
                    </div>
                    <div class="flex items-center gap-2 bg-gradient-to-r from-green-50 to-emerald-50 px-3 py-1 rounded-full">
                        <span class="status-indicator bg-green-500"></span>
                        <span class="text-xs font-bold text-green-600">Historical</span>
                    </div>
                </div>
                <div class="chart-container">
                    <canvas id="topUsersChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- Real-time Activity Monitor -->
    {if $active|count > 0}
    <div class="mb-8">
        <div class="bg-white rounded-2xl shadow-xl border border-gray-100 overflow-hidden">
            <div class="bg-gradient-to-r from-green-500 to-emerald-600 px-6 py-4">
                <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
                    <div>
                        <h3 class="text-xl font-bold text-white flex items-center gap-3">
                            <i class="fas fa-satellite-dish"></i>
                            Real-time Activity Monitor
                        </h3>
                        <p class="text-green-100 text-sm mt-1">Users active in the last 2 minutes</p>
                    </div>
                    <div class="flex items-center gap-4">
                        <div class="flex items-center gap-2 bg-white bg-opacity-20 px-4 py-2 rounded-full backdrop-blur-sm">
                            <span class="status-indicator bg-white"></span>
                            <span class="text-white font-bold">{$active|count} Online</span>
                        </div>
                        <button onclick="toggleAutoRefresh()" class="bg-white bg-opacity-20 hover:bg-opacity-30 text-white px-5 py-2 rounded-xl transition-all duration-300 font-semibold backdrop-blur-sm">
                            <i class="fas fa-sync-alt mr-2"></i>Auto-refresh
                        </button>
                    </div>
                </div>
            </div>
            
            <div class="overflow-x-auto">
                <table class="w-full">
                    <thead class="bg-gray-50 border-b-2 border-gray-200">
                        <tr>
                            <th class="px-6 py-4 text-left text-xs font-black text-gray-500 uppercase tracking-wider">
                                <i class="fas fa-user mr-2"></i>User
                            </th>
                            <th class="px-6 py-4 text-left text-xs font-black text-gray-500 uppercase tracking-wider">
                                <i class="fas fa-map-marker-alt mr-2"></i>Station
                            </th>
                            <th class="px-6 py-4 text-right text-xs font-black text-gray-500 uppercase tracking-wider">
                                <i class="fas fa-arrow-up mr-2 text-red-500"></i>Upload
                            </th>
                            <th class="px-6 py-4 text-right text-xs font-black text-gray-500 uppercase tracking-wider">
                                <i class="fas fa-arrow-down mr-2 text-green-500"></i>Download
                            </th>
                            <th class="px-6 py-4 text-right text-xs font-black text-gray-500 uppercase tracking-wider">
                                <i class="fas fa-database mr-2 text-blue-500"></i>Total
                            </th>
                            <th class="px-6 py-4 text-center text-xs font-black text-gray-500 uppercase tracking-wider">
                                <i class="fas fa-clock mr-2"></i>Last Seen
                            </th>
                            <th class="px-6 py-4 text-center text-xs font-black text-gray-500 uppercase tracking-wider">
                                <i class="fas fa-signal mr-2"></i>Status
                            </th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-100">
                        {foreach $active as $user}
                        <tr class="table-row-hover transition-all duration-200">
                            <td class="px-6 py-4">
                                <div class="flex items-center space-x-3">
                                    <div class="w-10 h-10 bg-gradient-to-br from-blue-400 to-blue-600 rounded-xl flex items-center justify-center shadow-md">
                                        <span class="text-sm font-black text-white">{$user.username|substr:0:1|upper}</span>
                                    </div>
                                    <div>
                                        <div class="font-bold text-gray-900">{$user.username}</div>
                                        <div class="text-xs text-gray-500">
                                            <i class="fas fa-user-circle mr-1"></i>Active User
                                        </div>
                                    </div>
                                </div>
                            </td>
                            <td class="px-6 py-4">
                                <span class="badge badge-info">
                                    <i class="fas fa-broadcast-tower mr-1 text-xs"></i>
                                    {$user.station}
                                </span>
                            </td>
                            <td class="px-6 py-4 text-right">
                                <div class="font-mono text-sm font-bold text-red-600 flex items-center justify-end gap-2">
                                    <i class="fas fa-upload text-xs"></i>
                                    {$user.tx_formatted}
                                </div>
                            </td>
                            <td class="px-6 py-4 text-right">
                                <div class="font-mono text-sm font-bold text-green-600 flex items-center justify-end gap-2">
                                    <i class="fas fa-download text-xs"></i>
                                    {$user.rx_formatted}
                                </div>
                            </td>
                            <td class="px-6 py-4 text-right">
                                <div class="font-mono text-sm font-black text-indigo-600 bg-indigo-50 px-3 py-1 rounded-xl">
                                    {$user.total_formatted}
                                </div>
                            </td>
                            <td class="px-6 py-4 text-center">
                                <div class="text-sm text-gray-600 flex items-center justify-center gap-2">
                                    <i class="fas fa-clock text-xs text-blue-500"></i>
                                    {$user.last_seen|date_format:"%H:%M:%S"}
                                </div>
                            </td>
                            <td class="text-center">
                                <span class="badge {if $user.status == 'online'} badge-success {else} badge-danger {/if}">
                                    <span class="status-indicator {if $user.status == 'online'} status-online {else} status-offline {/if}"></span>
                                    {$user.status|capitalize}
                                </span>
                            </td>
                        </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    {/if}

    <!-- Comprehensive Usage Statistics -->
    <div>
        <div class="bg-white rounded-2xl shadow-xl border border-gray-100 overflow-hidden">
            <div class="bg-gradient-to-r from-indigo-500 to-purple-600 px-6 py-4">
                <div class="flex flex-col lg:flex-row justify-between items-start lg:items-center gap-4">
                    <div>
                        <h3 class="text-xl font-bold text-white flex items-center gap-3">
                            <i class="fas fa-chart-line"></i>
                            Comprehensive Usage Statistics
                        </h3>
                        <p class="text-indigo-100 text-sm mt-1">Historical data and usage patterns</p>
                    </div>
                    
                    <!-- Controls -->
                    <div class="flex flex-wrap items-center gap-3">
                        <div class="flex items-center gap-2 bg-white bg-opacity-20 px-4 py-2 rounded-xl backdrop-blur-sm">
                            <i class="fas fa-list text-white"></i>
                            <label class="text-white text-sm font-semibold">Show:</label>
                            <select onchange="changeLimit(this.value)" class="bg-transparent text-white border-0 focus:ring-0 text-sm font-semibold cursor-pointer">
                                <option value="25" {if $limit == 25}selected{/if} class="text-gray-900">25</option>
                                <option value="50" {if $limit == 50}selected{/if} class="text-gray-900">50</option>
                                <option value="100" {if $limit == 100}selected{/if} class="text-gray-900">100</option>
                            </select>
                        </div>
                        
                        <button onclick="filterHeavyUsers()" class="bg-white bg-opacity-20 hover:bg-opacity-30 text-white px-5 py-2 rounded-xl transition-all duration-300 font-semibold backdrop-blur-sm">
                            <i class="fas fa-fire mr-2"></i>Heavy Users
                        </button>
                    </div>
                </div>
            </div>
            
            <div class="overflow-x-auto">
                <table class="w-full">
                    <thead class="bg-gray-50 border-b-2 border-gray-200">
                        <tr>
                            <th class="px-6 py-4 text-left text-xs font-black text-gray-500 uppercase tracking-wider">
                                <i class="fas fa-trophy mr-2 text-yellow-500"></i>Rank
                            </th>
                            <th class="px-6 py-4 text-left text-xs font-black text-gray-500 uppercase tracking-wider">
                                <i class="fas fa-user mr-2"></i>Username
                            </th>
                            <th class="px-6 py-4 text-right text-xs font-black text-gray-500 uppercase tracking-wider">
                                <i class="fas fa-arrow-up mr-2 text-red-500"></i>Total Upload
                            </th>
                            <th class="px-6 py-4 text-right text-xs font-black text-gray-500 uppercase tracking-wider">
                                <i class="fas fa-arrow-down mr-2 text-green-500"></i>Total Download
                            </th>
                            <th class="px-6 py-4 text-right text-xs font-black text-gray-500 uppercase tracking-wider">
                                <i class="fas fa-database mr-2 text-blue-500"></i>Grand Total
                            </th>
                            <th class="px-6 py-4 text-center text-xs font-black text-gray-500 uppercase tracking-wider">
                                <i class="fas fa-chart-line mr-2"></i>Usage Level
                            </th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-100">
                        {foreach $all_time as $index => $user}
                        <tr class="table-row-hover transition-all duration-200">
                            <td class="px-6 py-4">
                                {assign var="rank" value=$start_record + $index}
                                <div class="flex items-center">
                                    {if $rank <= 3}
                                        <div class="w-10 h-10 rounded-xl flex items-center justify-center text-sm font-black shadow-lg
                                            {if $rank == 1}bg-gradient-to-r from-yellow-400 to-yellow-600 text-white{/if}
                                            {if $rank == 2}bg-gradient-to-r from-gray-400 to-gray-600 text-white{/if}
                                            {if $rank == 3}bg-gradient-to-r from-orange-400 to-orange-600 text-white{/if}">
                                            <i class="fas fa-crown"></i>
                                        </div>
                                        <span class="ml-3 font-black text-gray-900 text-lg">#{$rank}</span>
                                    {else}
                                        <div class="w-10 h-10 bg-gray-100 rounded-xl flex items-center justify-center border-2 border-gray-200">
                                            <span class="text-gray-600 font-black text-sm">#{$rank}</span>
                                        </div>
                                    {/if}
                                </div>
                            </td>
                            <td class="px-6 py-4">
                                <div class="flex items-center space-x-3">
                                    <div class="w-10 h-10 bg-gradient-to-br from-indigo-400 to-indigo-600 rounded-xl flex items-center justify-center shadow-md">
                                        <span class="text-sm font-black text-white">{$user.username|substr:0:1|upper}</span>
                                    </div>
                                    <div>
                                        <div class="font-black text-gray-900">{$user.username}</div>
                                        <div class="text-xs text-gray-500">
                                            <i class="fas fa-calendar-alt mr-1"></i>Member
                                        </div>
                                    </div>
                                </div>
                            </td>
                            <td class="px-6 py-4 text-right">
                                <div class="font-mono text-sm font-bold text-red-600 bg-red-50 px-3 py-1 rounded-xl inline-block">
                                    <i class="fas fa-upload mr-1"></i>
                                    {$user.tx_total_formatted}
                                </div>
                            </td>
                            <td class="px-6 py-4 text-right">
                                <div class="font-mono text-sm font-bold text-green-600 bg-green-50 px-3 py-1 rounded-xl inline-block">
                                    <i class="fas fa-download mr-1"></i>
                                    {$user.rx_total_formatted}
                                </div>
                            </td>
                            <td class="px-6 py-4 text-right">
                                <div class="font-mono text-lg font-black text-indigo-700 bg-indigo-100 px-4 py-2 rounded-xl inline-block shadow-sm">
                                    {$user.total_formatted}
                                </div>
                            </td>
                            <td class="px-6 py-4 text-center">
                                {assign var="total_bytes" value=$user.tx_total + $user.rx_total}
                                {if $total_bytes > 10737418240}
                                    <span class="badge badge-danger">
                                        <i class="fas fa-fire mr-1"></i>Heavy User
                                    </span>
                                {elseif $total_bytes > 1073741824}
                                    <span class="badge badge-warning">
                                        <i class="fas fa-chart-line mr-1"></i>Active User
                                    </span>
                                {elseif $total_bytes > 104857600}
                                    <span class="badge badge-info">
                                        <i class="fas fa-user mr-1"></i>Regular User
                                    </span>
                                {else}
                                    <span class="badge" style="background: linear-gradient(135deg, #6b7280 0%, #4b5563 100%); color: white;">
                                        <i class="fas fa-leaf mr-1"></i>Light User
                                    </span>
                                {/if}
                            </td>
                        </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            {if $total_pages > 1}
            <div class="bg-gray-50 px-6 py-4 border-t border-gray-200">
                <div class="flex flex-col lg:flex-row justify-between items-center gap-4">
                    <div class="text-sm text-gray-600 flex items-center gap-2">
                        <i class="fas fa-info-circle text-blue-500"></i>
                        Showing <span class="font-black text-indigo-600">{$start_record}</span> to 
                        <span class="font-black text-indigo-600">{$end_record}</span> of 
                        <span class="font-black text-indigo-600">{$total_users|number_format}</span> results
                    </div>
                    
                    <nav class="flex items-center gap-2">
                        {if $pagination.prev}
                            <a href="{$pagination.prev}" class="px-5 py-2 text-sm font-bold text-white bg-gradient-to-r from-indigo-500 to-purple-600 rounded-xl hover:from-indigo-600 hover:to-purple-700 transition-all duration-300 shadow-md flex items-center gap-2 transform hover:scale-105">
                                <i class="fas fa-chevron-left text-xs"></i>
                                Previous
                            </a>
                        {else}
                            <span class="px-5 py-2 text-sm font-bold text-gray-400 bg-gray-200 rounded-xl cursor-not-allowed flex items-center gap-2">
                                <i class="fas fa-chevron-left text-xs"></i>
                                Previous
                            </span>
                        {/if}
                        
                        {foreach $pagination.pages as $page}
                            {if $page.current}
                                <span class="px-4 py-2 text-sm font-black text-white bg-gradient-to-r from-blue-500 to-indigo-600 rounded-xl shadow-md transform scale-110 min-w-[40px] text-center">
                                    {$page.number}
                                </span>
                            {else}
                                <a href="{$page.url}" class="px-4 py-2 text-sm font-bold text-gray-700 bg-white hover:bg-gray-50 border-2 border-gray-200 rounded-xl transition-all duration-200 min-w-[40px] text-center hover:border-indigo-300 hover:text-indigo-600">
                                    {$page.number}
                                </a>
                            {/if}
                        {/foreach}
                        
                        {if $pagination.next}
                            <a href="{$pagination.next}" class="px-5 py-2 text-sm font-bold text-white bg-gradient-to-r from-indigo-500 to-purple-600 rounded-xl hover:from-indigo-600 hover:to-purple-700 transition-all duration-300 shadow-md flex items-center gap-2 transform hover:scale-105">
                                Next
                                <i class="fas fa-chevron-right text-xs"></i>
                            </a>
                        {else}
                            <span class="px-5 py-2 text-sm font-bold text-gray-400 bg-gray-200 rounded-xl cursor-not-allowed flex items-center gap-2">
                                Next
                                <i class="fas fa-chevron-right text-xs"></i>
                            </span>
                        {/if}
                    </nav>
                </div>
            </div>
            {/if}
        </div>
    </div>

    <!-- Quick Actions Panel -->
    <div class="fixed bottom-6 right-6 z-50">
        <div class="flex flex-col gap-3">
            <button onclick="scrollToTop()" class="floating-btn w-12 h-12 bg-gradient-to-r from-blue-500 to-indigo-600 hover:from-blue-600 hover:to-indigo-700 text-white rounded-full shadow-2xl transition-all duration-300 flex items-center justify-center transform hover:scale-110">
                <i class="fas fa-arrow-up"></i>
            </button>
            <button onclick="showHelp()" class="floating-btn w-12 h-12 bg-gradient-to-r from-green-500 to-emerald-600 hover:from-green-600 hover:to-emerald-700 text-white rounded-full shadow-2xl transition-all duration-300 flex items-center justify-center transform hover:scale-110">
                <i class="fas fa-question"></i>
            </button>
        </div>
    </div>
</div>

{include file="sections/footer.tpl"}

<script>
// Global variables
var autoRefreshInterval;
var isAutoRefreshActive = false;
var stationChart, topUsersChart;

// Chart.js configuration
Chart.register(ChartDataLabels);

// Initialize charts when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    initializeCharts();
    setupEventListeners();
    addRippleEffect();
});

function addRippleEffect() {
    var buttons = document.querySelectorAll('button');
    for (var i = 0; i < buttons.length; i++) {
        buttons[i].addEventListener('click', function(e) {
            var ripple = document.createElement('span');
            ripple.classList.add('ripple');
            this.appendChild(ripple);
            
            var x = e.clientX - e.target.offsetLeft;
            var y = e.clientY - e.target.offsetTop;
            
            ripple.style.left = x + 'px';
            ripple.style.top = y + 'px';
            
            setTimeout(function() {
                ripple.remove();
            }, 600);
        });
    }
}

function initializeCharts() {
    // Station Distribution Chart
    var stationCtx = document.getElementById('stationChart').getContext('2d');
    stationChart = new Chart(stationCtx, {
        type: 'doughnut',
        data: {
            labels: {$station_labels|@json_encode},
            datasets: [{
                data: {$station_values|@json_encode},
                backgroundColor: [
                    '#3b82f6', '#10b981', '#f59e0b', '#8b5cf6', '#ef4444',
                    '#06b6d4', '#f97316', '#84cc16', '#ec4899', '#6b7280'
                ],
                borderColor: '#ffffff',
                borderWidth: 3,
                hoverBorderWidth: 4,
                hoverOffset: 10
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: '60%',
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        padding: 15,
                        usePointStyle: true,
                        font: { size: 11, weight: 'bold' }
                    }
                },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            var total = context.dataset.data.reduce(function(a, b) { return a + b; }, 0);
                            var percentage = ((context.parsed / total) * 100).toFixed(1);
                            return ' ' + context.label + ': ' + context.parsed + ' users (' + percentage + '%)';
                        }
                    }
                }
            }
        }
    });

    // Top Users Chart
    var topUsersCtx = document.getElementById('topUsersChart').getContext('2d');
    topUsersChart = new Chart(topUsersCtx, {
        type: 'bar',
        data: {
            labels: {$top5_labels|@json_encode},
            datasets: [{
                label: 'Upload Data',
                data: {$top5_values|@json_encode},
                backgroundColor: 'rgba(59, 130, 246, 0.8)',
                borderColor: '#1d4ed8',
                borderWidth: 2,
                borderRadius: 8,
                hoverBackgroundColor: 'rgba(59, 130, 246, 1)',
                barPercentage: 0.7,
                categoryPercentage: 0.8
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            indexAxis: 'y',
            plugins: {
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            var bytes = context.parsed.x;
                            var mb = bytes / (1024 * 1024);
                            var formatted = mb >= 1000 ? 
                                (mb / 1024).toFixed(2) + ' GB' : 
                                mb.toFixed(2) + ' MB';
                            return 'Upload: ' + formatted;
                        }
                    }
                }
            },
            scales: {
                x: {
                    beginAtZero: true,
                    grid: {
                        display: true,
                        color: 'rgba(0, 0, 0, 0.05)'
                    },
                    ticks: {
                        callback: function(value) {
                            var mb = value / (1024 * 1024);
                            return mb >= 1000 ? 
                                (mb / 1024).toFixed(0) + 'GB' : 
                                mb.toFixed(0) + 'MB';
                        }
                    }
                },
                y: {
                    grid: {
                        display: false
                    },
                    ticks: {
                        font: {
                            weight: 'bold'
                        }
                    }
                }
            }
        }
    });
}

function setupEventListeners() {
    document.addEventListener('keydown', function(e) {
        if (e.ctrlKey && e.key === 'r') {
            e.preventDefault();
            refreshData();
        }
        if (e.key === 'Escape') {
            closeModals();
        }
    });
}

function refreshData() {
    var refreshBtn = document.getElementById('refreshBtn');
    var refreshIcon = document.getElementById('refreshIcon');
    
    refreshIcon.classList.add('fa-spin');
    refreshBtn.disabled = true;
    
    setTimeout(function() {
        location.reload();
    }, 1000);
}

function exportData() {
    showNotification('Preparing your data for export...', 'info');
    
    setTimeout(function() {
        var csvData = [];
        csvData.push(['Rank', 'Username', 'Upload', 'Download', 'Total', 'Usage Level']);
        
        {foreach $all_time as $index => $user}
        csvData.push([
            '{$start_record + $index}',
            '{$user.username}',
            '{$user.tx_total_formatted}',
            '{$user.rx_total_formatted}',
            '{$user.total_formatted}',
            'User Level'
        ]);
        {/foreach}
        
        var csv = '';
        for (var i = 0; i < csvData.length; i++) {
            csv += csvData[i].join(',') + '\n';
        }
        
        var blob = new Blob([csv], { type: 'text/csv' });
        var url = window.URL.createObjectURL(blob);
        var a = document.createElement('a');
        a.style.display = 'none';
        a.href = url;
        a.download = 'customer_usage_' + new Date().toISOString().split('T')[0] + '.csv';
        document.body.appendChild(a);
        a.click();
        window.URL.revokeObjectURL(url);
        
        showNotification('Data exported successfully!', 'success');
    }, 500);
}

function changeLimit(limit) {
    var url = new URL(window.location);
    url.searchParams.set('limit', limit);
    url.searchParams.set('page', '1');
    window.location.href = url.toString();
}

function toggleRealTime() {
    isAutoRefreshActive = !isAutoRefreshActive;
    var btn = document.getElementById('realTimeBtn');
    
    if (isAutoRefreshActive) {
        btn.innerHTML = '<i class="fas fa-pause mr-2"></i><span class="font-semibold">Pause Live</span>';
        btn.className = btn.className.replace('bg-gradient-to-r from-purple-500 to-pink-600', 'bg-gradient-to-r from-red-500 to-pink-600');
        startAutoRefresh();
        showNotification('Live mode activated - Auto-refreshing every 30 seconds', 'success');
    } else {
        btn.innerHTML = '<i class="fas fa-broadcast-tower mr-2"></i><span class="font-semibold">Live Mode</span>';
        btn.className = btn.className.replace('bg-gradient-to-r from-red-500 to-pink-600', 'bg-gradient-to-r from-purple-500 to-pink-600');
        stopAutoRefresh();
        showNotification('Live mode deactivated', 'info');
    }
}

function startAutoRefresh() {
    autoRefreshInterval = setInterval(function() {
        if (!document.hidden) {
            location.reload();
        }
    }, 30000);
}

function stopAutoRefresh() {
    if (autoRefreshInterval) {
        clearInterval(autoRefreshInterval);
        autoRefreshInterval = null;
    }
}

function filterHeavyUsers() {
    var rows = document.querySelectorAll('tbody tr');
    var visibleCount = 0;
    
    for (var i = 0; i < rows.length; i++) {
        var row = rows[i];
        var usageLevel = row.querySelector('td:last-child .badge');
        if (usageLevel && usageLevel.textContent.indexOf('Heavy User') !== -1) {
            row.style.display = '';
            row.style.background = 'linear-gradient(90deg, rgba(239, 68, 68, 0.05) 0%, rgba(220, 38, 38, 0.05) 100%)';
            visibleCount++;
        } else {
            row.style.display = 'none';
        }
    }
    
    if (visibleCount === 0) {
        showNotification('No heavy users found in this page', 'info');
    } else {
        showNotification('Showing ' + visibleCount + ' heavy user(s)', 'success');
    }
}

function scrollToTop() {
    window.scrollTo({
        top: 0,
        behavior: 'smooth'
    });
}

function showHelp() {
    var helpContent = `
        <div class="space-y-6">
            <div class="bg-gradient-to-r from-blue-50 to-purple-50 p-4 rounded-xl">
                <h4 class="font-black text-gray-800 mb-3 flex items-center gap-2">
                    <i class="fas fa-keyboard text-blue-500"></i>
                    Keyboard Shortcuts
                </h4>
                <ul class="space-y-2">
                    <li class="flex items-center justify-between">
                        <span class="text-sm text-gray-600">Refresh data</span>
                        <kbd class="bg-gray-800 text-white px-3 py-1 rounded-lg text-xs font-mono">Ctrl + R</kbd>
                    </li>
                    <li class="flex items-center justify-between">
                        <span class="text-sm text-gray-600">Close modals</span>
                        <kbd class="bg-gray-800 text-white px-3 py-1 rounded-lg text-xs font-mono">Esc</kbd>
                    </li>
                </ul>
            </div>
            
            <div class="bg-gradient-to-r from-green-50 to-emerald-50 p-4 rounded-xl">
                <h4 class="font-black text-gray-800 mb-3 flex items-center gap-2">
                    <i class="fas fa-star text-green-500"></i>
                    Features
                </h4>
                <ul class="space-y-2 text-sm text-gray-600">
                    <li><i class="fas fa-check-circle text-green-500 mr-2"></i>Real-time activity monitoring</li>
                    <li><i class="fas fa-check-circle text-green-500 mr-2"></i>Automatic data refresh (Live Mode)</li>
                    <li><i class="fas fa-check-circle text-green-500 mr-2"></i>Export to CSV format</li>
                    <li><i class="fas fa-check-circle text-green-500 mr-2"></i>Advanced filtering by usage level</li>
                    <li><i class="fas fa-check-circle text-green-500 mr-2"></i>Interactive data visualization</li>
                </ul>
            </div>
            
            <div class="bg-gradient-to-r from-yellow-50 to-orange-50 p-4 rounded-xl">
                <h4 class="font-black text-gray-800 mb-3 flex items-center gap-2">
                    <i class="fas fa-chart-line text-orange-500"></i>
                    Usage Levels
                </h4>
                <ul class="space-y-2 text-sm">
                    <li><span class="badge badge-danger mr-2"></span>Heavy User: >10GB total</li>
                    <li><span class="badge badge-warning mr-2"></span>Active User: >1GB total</li>
                    <li><span class="badge badge-info mr-2"></span>Regular User: >100MB total</li>
                    <li><span class="badge" style="background: linear-gradient(135deg, #6b7280 0%, #4b5563 100%); color: white;">Light User: <100MB total</span></li>
                </ul>
            </div>
        </div>
    `;
    
    showModal('Help & Information', helpContent);
}

function showNotification(message, type) {
    if (typeof type === 'undefined') type = 'info';
    
    // Remove existing notifications
    var existingNotifications = document.querySelectorAll('.notification');
    for (var i = 0; i < existingNotifications.length; i++) {
        existingNotifications[i].remove();
    }
    
    var notification = document.createElement('div');
    notification.className = 'notification fixed top-20 right-4 px-6 py-4 rounded-2xl shadow-2xl transition-all duration-300 z-50';
    
    var colors = {
        success: 'bg-gradient-to-r from-green-500 to-emerald-600 text-white',
        error: 'bg-gradient-to-r from-red-500 to-pink-600 text-white',
        info: 'bg-gradient-to-r from-blue-500 to-indigo-600 text-white',
        warning: 'bg-gradient-to-r from-yellow-500 to-orange-600 text-white'
    };
    
    notification.className += ' ' + colors[type];
    
    var iconMap = {
        success: 'check-circle',
        error: 'times-circle',
        warning: 'exclamation-triangle',
        info: 'info-circle'
    };
    
    notification.innerHTML = 
        '<div class="flex items-center gap-3">' +
            '<i class="fas fa-' + iconMap[type] + ' text-xl"></i>' +
            '<span class="font-semibold">' + message + '</span>' +
        '</div>';
    
    document.body.appendChild(notification);
    
    // Remove after 3 seconds
    setTimeout(function() {
        if (notification.parentNode) {
            notification.remove();
        }
    }, 3000);
}

function showModal(title, content) {
    closeModals();
    
    var modal = document.createElement('div');
    modal.className = 'modal-overlay fixed inset-0 flex items-start justify-center p-4 pt-20';
    modal.style.backgroundColor = 'rgba(0, 0, 0, 0.6)';
    modal.style.backdropFilter = 'blur(8px)';
    modal.style.zIndex = '9999';
    modal.innerHTML = 
        '<div class="bg-white rounded-2xl shadow-2xl max-w-2xl w-full max-h-96 overflow-y-auto transform transition-all duration-300 scale-100 mt-8 animate-fadeInUp">' +
            '<div class="flex justify-between items-center px-6 py-4 border-b border-gray-200 bg-gradient-to-r from-gray-50 to-gray-100 rounded-t-2xl">' +
                '<h3 class="text-xl font-black text-gray-900 flex items-center gap-2">' +
                    '<i class="fas fa-question-circle text-blue-500"></i>' +
                    title +
                '</h3>' +
                '<button onclick="closeModals()" class="text-gray-400 hover:text-gray-600 transition-all p-2 rounded-full hover:bg-gray-200">' +
                    '<i class="fas fa-times text-lg"></i>' +
                '</button>' +
            '</div>' +
            '<div class="px-6 py-6">' +
                content +
            '</div>' +
            '<div class="px-6 py-4 border-t border-gray-200 bg-gray-50 rounded-b-2xl text-right">' +
                '<button onclick="closeModals()" class="bg-gradient-to-r from-blue-500 to-indigo-600 hover:from-blue-600 hover:to-indigo-700 text-white px-6 py-2 rounded-xl transition-all font-bold shadow-md">' +
                    'Got it' +
                '</button>' +
            '</div>' +
        '</div>';
    
    modal.addEventListener('click', function(e) {
        if (e.target === modal) {
            closeModals();
        }
    });
    
    document.body.appendChild(modal);
    document.body.style.overflow = 'hidden';
}

function closeModals() {
    var modals = document.querySelectorAll('.modal-overlay');
    for (var i = 0; i < modals.length; i++) {
        modals[i].remove();
    }
    document.body.style.overflow = '';
}

// Add CSS for ripple effect
var style = document.createElement('style');
style.textContent = `
    .ripple {
        position: absolute;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.6);
        transform: scale(0);
        animation: ripple 0.6s linear;
        pointer-events: none;
    }
    
    @keyframes ripple {
        to {
            transform: scale(4);
            opacity: 0;
        }
    }
`;
document.head.appendChild(style);

// Handle page visibility changes
document.addEventListener('visibilitychange', function() {
    if (document.hidden && isAutoRefreshActive) {
        console.log('Page hidden, pausing auto-refresh');
    } else if (!document.hidden && isAutoRefreshActive) {
        console.log('Page visible, resuming auto-refresh');
    }
});
</script>