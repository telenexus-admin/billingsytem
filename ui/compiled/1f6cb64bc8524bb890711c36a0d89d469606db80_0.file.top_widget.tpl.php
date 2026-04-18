<?php
/* Smarty version 4.5.3, created on 2026-04-17 11:43:06
  from 'C:\Users\Administrator\Downloads\phpbilling sytem\ui\ui\widget\top_widget.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.3',
  'unifunc' => 'content_69e1f29a6a1f91_71136171',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '1f6cb64bc8524bb890711c36a0d89d469606db80' => 
    array (
      0 => 'C:\\Users\\Administrator\\Downloads\\phpbilling sytem\\ui\\ui\\widget\\top_widget.tpl',
      1 => 1776361612,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_69e1f29a6a1f91_71136171 (Smarty_Internal_Template $_smarty_tpl) {
$_smarty_tpl->_checkPlugins(array(0=>array('file'=>'C:\\Users\\Administrator\\Downloads\\phpbillingsytem\\system\\vendor\\smarty\\smarty\\libs\\plugins\\modifier.count.php','function'=>'smarty_modifier_count',),1=>array('file'=>'C:\\Users\\Administrator\\Downloads\\phpbillingsytem\\system\\vendor\\smarty\\smarty\\libs\\plugins\\modifier.date_format.php','function'=>'smarty_modifier_date_format',),));
?>
<div class="top-widget-dashboard-root">
<link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .top-widget-dashboard-root,
        .top-widget-dashboard-root * {
            box-sizing: border-box;
        }
        .top-widget-dashboard-root {
            --primary: #10b981;
            --primary-dark: #059669;
            --primary-light: #a7f3d0;
            --accent-soft: #f0fdf4;
            --card-border: rgba(16, 185, 129, 0.12);
            --bg-gradient-start: #0f172a;
            --bg-gradient-end: #1e293b;
            --card-bg: rgba(255, 255, 255, 0.95);
            --text-primary: #1e293b;
            --text-secondary: #475569;
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #0b1120 0%, #1a2639 50%, #0f172a 100%);
            border-radius: 12px;
            padding: 0.75rem;
            position: relative;
            overflow: hidden;
            margin-bottom: 1rem;
        }
        
        .top-widget-dashboard-root::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: 
                radial-gradient(circle at 20% 50%, rgba(16, 185, 129, 0.08) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(16, 185, 129, 0.05) 0%, transparent 50%),
                radial-gradient(circle at 40% 20%, rgba(16, 185, 129, 0.06) 0%, transparent 50%),
                radial-gradient(circle at 90% 30%, rgba(16, 185, 129, 0.04) 0%, transparent 50%);
            pointer-events: none;
            z-index: 0;
        }
        
        .top-widget-dashboard-root::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-image: 
                linear-gradient(rgba(16, 185, 129, 0.02) 1px, transparent 1px),
                linear-gradient(90deg, rgba(16, 185, 129, 0.02) 1px, transparent 1px);
            background-size: 50px 50px;
            pointer-events: none;
            z-index: 0;
        }
        
        .dashboard-container {
            width: 100%;
            max-width: 1400px;
            margin: 0 auto;
            position: relative;
            z-index: 1;
        }
        
        .router-filter-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border-radius: 22px;
            padding: 1rem 1.5rem;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
            border: 1px solid rgba(16, 185, 129, 0.2);
        }
        
        .router-select-custom {
            border: 2px solid rgba(16, 185, 129, 0.2);
            border-radius: 14px;
            padding: 0.6rem 1rem;
            background: rgba(255, 255, 255, 0.9);
            color: #1e293b;
            font-weight: 500;
            outline: none;
            min-width: 260px;
            backdrop-filter: blur(4px);
            cursor: pointer;
            transition: all 0.2s;
            font-size: 0.9rem;
        }
        .router-select-custom:hover {
            border-color: var(--primary);
            background: white;
        }
        .router-select-custom:focus { 
            border-color: var(--primary); 
            background: white;
            box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.1);
        }
        
        .status-online {
            color: #10b981;
        }
        
        .status-offline {
            color: #ef4444;
        }
        
        .sales-gradient {
            background: linear-gradient(145deg, #10b981 0%, #047857 100%);
            box-shadow: 0 16px 24px -10px rgba(4,120,87,0.4);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .insight-icon-base {
            width: 44px; height: 44px; border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            color: white; font-size: 1.3rem;
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
        }
        
        .masked-amount { letter-spacing: 6px; font-family: 'SF Mono', 'Fira Code', monospace; font-weight: 600; }
        .real-value { display: none; }
        
        .eye-icon {
            width: 38px; height: 38px; background: rgba(255,255,255,0.2);
            border-radius: 10px; display: inline-flex; align-items: center; justify-content: center;
            transition: all 0.15s; cursor: pointer; color: white;
            backdrop-filter: blur(4px);
            border: 1px solid rgba(255,255,255,0.1);
        }
        .eye-icon:hover { background: rgba(255,255,255,0.35); transform: scale(0.96); }
        
        .insight-item-custom {
            background: rgba(240, 253, 244, 0.8);
            backdrop-filter: blur(4px);
            border-radius: 20px;
            padding: 1rem 1.2rem;
            border: 1px solid rgba(16, 185, 129, 0.15);
            transition: all 0.15s;
        }
        .insight-item-custom:hover {
            background: white;
            border-color: var(--primary-light);
            transform: translateX(5px);
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.15);
        }
        
        .stat-block-mod {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 1.2rem 0.8rem;
            border-left: 5px solid var(--primary);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
        }
        
        .btn-primary {
            background: linear-gradient(145deg, #10b981, #059669);
            color: white;
            padding: 0.6rem 1.2rem;
            border-radius: 0.75rem;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            border: none;
            cursor: pointer;
            transition: all 0.2s;
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
        }
        .btn-primary:hover {
            background: linear-gradient(145deg, #059669, #047857);
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(16, 185, 129, 0.4);
        }
        
        .btn-secondary {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(4px);
            color: #1e293b;
            padding: 0.6rem 1.2rem;
            border-radius: 0.75rem;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            border: 1px solid rgba(16, 185, 129, 0.2);
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-secondary:hover {
            background: white;
            transform: translateY(-2px);
            border-color: var(--primary);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        
        @media (max-width: 640px) {
            .stat-value-large { font-size: 28px; }
            .router-filter-card { padding: 1rem; }
            .router-select-custom { min-width: 200px; }
        }
        
        .loading { opacity: 0.6; pointer-events: none; position: relative; }
        .loading::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 24px;
            height: 24px;
            margin-left: -12px;
            margin-top: -12px;
            border: 3px solid rgba(16, 185, 129, 0.2);
            border-top-color: var(--primary);
            border-radius: 50%;
            animation: spin 0.8s linear infinite;
            z-index: 10;
        }
        
        @keyframes spin { to { transform: rotate(360deg); } }
        
        .pulse-animation {
            animation: quickPulse 0.5s ease-in-out;
        }
        
        @keyframes quickPulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }
        
        .last-updated {
            color: rgba(255, 255, 255, 0.8);
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        }
        
        .user-insight-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border: 1px solid rgba(16, 185, 129, 0.15);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
        }
        
        .source-badge {
            font-size: 0.7rem;
            padding: 0.2rem 0.5rem;
            border-radius: 999px;
            background: rgba(16, 185, 129, 0.1);
            color: var(--primary-dark);
            display: inline-block;
        }
        
        .selected-router-badge {
            background: rgba(16, 185, 129, 0.2);
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 500;
        }
        
        .auto-refresh-indicator {
            background: rgba(16, 185, 129, 0.15);
            border-radius: 20px;
            padding: 0.25rem 0.75rem;
            font-size: 0.7rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .live-dot {
            width: 8px;
            height: 8px;
            background-color: #10b981;
            border-radius: 50%;
            display: inline-block;
            animation: livePulse 1.2s infinite;
        }
        
        @keyframes livePulse {
            0% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.4; transform: scale(0.9); }
            100% { opacity: 1; transform: scale(1); }
        }
    </style>
<?php echo '<script'; ?>
>
window.__dashboardRouterAjax = "<?php echo strtr((string)(($tmp = $_smarty_tpl->tpl_vars['dashboard_router_ajax_url']->value ?? null)===null||$tmp==='' ? '' ?? null : $tmp), array("\\" => "\\\\", "'" => "\\'", "\"" => "\\\"", "\r" => "\\r", 
                       "\n" => "\\n", "</" => "<\/", "<!--" => "<\!--", "<s" => "<\s", "<S" => "<\S",
                       "`" => "\\`", "\${" => "\\\$\{"));?>
";
<?php echo '</script'; ?>
>
<div class="dashboard-container">
    <div id="alert-container" class="mb-3"></div>

    <!-- ========== ROUTER FILTER - AUTO UPDATE ON SELECT ========== -->
    <div class="router-filter-card mb-5">
        <div class="flex flex-col sm:flex-row justify-between items-center gap-4">
            <div class="flex items-center gap-3">
                <div class="p-2.5 bg-green-100 rounded-xl">
                    <i class="fas fa-network-wired text-[var(--primary)] text-lg"></i>
                </div>
                <div>
                    <h2 class="font-semibold text-gray-800">Router Filter</h2>
                    <p class="text-xs text-gray-500">Auto-updates when router changes</p>
                </div>
            </div>
            <div class="flex flex-wrap items-center gap-3 w-full sm:w-auto">
                <select id="router-select" class="router-select-custom w-full sm:w-80 text-sm">
                    <option value="all"><?php echo Lang::T('All');?>
 / <?php echo Lang::T('Routers');?>
</option>
                    <?php if ((isset($_smarty_tpl->tpl_vars['routers']->value)) && smarty_modifier_count($_smarty_tpl->tpl_vars['routers']->value) > 0) {?>
                        <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['routers']->value, 'router');
$_smarty_tpl->tpl_vars['router']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['router']->value) {
$_smarty_tpl->tpl_vars['router']->do_else = false;
?>
                            <option value="<?php echo $_smarty_tpl->tpl_vars['router']->value['id'];?>
" data-status="<?php echo htmlspecialchars((string)$_smarty_tpl->tpl_vars['router']->value['status'], ENT_QUOTES, 'UTF-8', true);?>
">
                                <?php if ($_smarty_tpl->tpl_vars['router']->value['status'] == 'Online') {?>[+] <?php } else { ?>[-] <?php }
echo htmlspecialchars((string)$_smarty_tpl->tpl_vars['router']->value['name'], ENT_QUOTES, 'UTF-8', true);?>

                            </option>
                        <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
                    <?php }?>
                </select>
                <button id="refresh-btn" class="btn-secondary">
                    <i class="fas fa-sync-alt"></i> Refresh
                </button>
            </div>
        </div>
    </div>

    <!-- last updated line - ONLY TIMESTAMP VISIBLE -->
    <div class="flex justify-end mb-4 text-sm">
        <div class="last-updated">
            <i class="far fa-clock text-[var(--primary)] mr-2"></i>
            <span>Updated: <span id="last-update" class="font-medium text-white"><?php echo smarty_modifier_date_format(time(),"%H:%M:%S");?>
</span></span>
        </div>
    </div>

    <!-- ========== MAIN GRID ========== -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- LEFT COLUMN: sales + online stats -->
        <div class="lg:col-span-2 space-y-6">
            <!-- TODAY & MONTHLY revenue cards -->
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
                <div class="sales-gradient rounded-2xl p-5 text-white relative overflow-hidden">
                    <div class="relative z-10">
                        <p class="text-xs font-medium uppercase tracking-wider opacity-90 mb-2">
                            <i class="fas fa-calendar-day mr-1"></i> TODAY'S REVENUE
                        </p>
                        <div class="flex items-center justify-between">
                            <div class="flex items-baseline gap-1">
                                <span class="text-xl font-medium">KES</span>
                                <span class="text-4xl font-bold" id="today-sales-display">
                                    <span class="masked-amount" id="today-sales-mask">*****</span>
                                    <span class="real-value" id="today-sales-real"><?php echo number_format((($tmp = $_smarty_tpl->tpl_vars['iday']->value ?? null)===null||$tmp==='' ? 0 ?? null : $tmp),0,',','.');?>
</span>
                                </span>
                            </div>
                            <button onclick="toggleVisibility('today')" class="eye-icon">
                                <i class="fas fa-eye" id="today-eye"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <div class="sales-gradient rounded-2xl p-5 text-white relative overflow-hidden">
                    <div class="relative z-10">
                        <p class="text-xs font-medium uppercase tracking-wider opacity-90 mb-2">
                            <i class="fas fa-calendar-alt mr-1"></i> MONTHLY INCOME
                        </p>
                        <div class="flex items-center justify-between">
                            <div class="flex items-baseline gap-1">
                                <span class="text-xl font-medium">KES</span>
                                <span class="text-4xl font-bold" id="month-sales-display">
                                    <span class="masked-amount" id="month-sales-mask">*****</span>
                                    <span class="real-value" id="month-sales-real"><?php echo number_format((($tmp = $_smarty_tpl->tpl_vars['imonth']->value ?? null)===null||$tmp==='' ? 0 ?? null : $tmp),0,',','.');?>
</span>
                                </span>
                            </div>
                            <button onclick="toggleVisibility('month')" class="eye-icon">
                                <i class="fas fa-eye" id="month-eye"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- three stat cards (total online, hotspot, pppoe) -->
            <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                <div class="stat-block-mod text-center">
                    <div class="stat-value-large text-3xl md:text-4xl font-bold text-green-600" id="total-online-users"><?php echo (($tmp = $_smarty_tpl->tpl_vars['u_act']->value ?? null)===null||$tmp==='' ? 0 ?? null : $tmp);?>
</div>
                    <div class="stat-label text-xs font-semibold text-green-600 uppercase mt-1">
                        <i class="fas fa-users mr-1"></i> TOTAL ONLINE
                    </div>
                    <div class="text-xs text-gray-500 mt-0.5">Active connections</div>
                </div>
                
                <div class="stat-block-mod text-center" style="border-left-color: #eab308;">
                    <div class="stat-value-large text-3xl md:text-4xl font-bold text-yellow-600" id="online-hotspot-users"><?php echo (($tmp = $_smarty_tpl->tpl_vars['hotspot_online']->value ?? null)===null||$tmp==='' ? 0 ?? null : $tmp);?>
</div>
                    <div class="stat-label text-xs font-semibold text-yellow-600 uppercase mt-1">
                        <i class="fas fa-wifi mr-1"></i> HOTSPOT
                    </div>
                    <div class="text-xs text-gray-500 mt-0.5">WiFi users</div>
                </div>
                
                <div class="stat-block-mod text-center" style="border-left-color: #a855f7;">
                    <div class="stat-value-large text-3xl md:text-4xl font-bold text-purple-600" id="online-pppoe-users"><?php echo (($tmp = $_smarty_tpl->tpl_vars['pppoe_online']->value ?? null)===null||$tmp==='' ? 0 ?? null : $tmp);?>
</div>
                    <div class="stat-label text-xs font-semibold text-purple-600 uppercase mt-1">
                        <i class="fas fa-network-wired mr-1"></i> PPPOE
                    </div>
                    <div class="text-xs text-gray-500 mt-0.5">Connections</div>
                </div>
            </div>
        </div>

        <!-- RIGHT COLUMN: USER INSIGHT card -->
        <div class="user-insight-card rounded-3xl p-5 shadow-lg">
            <div class="flex items-center gap-3 mb-5">
                <div class="p-2.5 bg-green-100 rounded-xl">
                    <i class="fas fa-chart-pie text-[var(--primary)] text-lg"></i>
                </div>
                <h3 class="text-lg font-semibold text-gray-800">User Insight</h3>
            </div>

            <div class="space-y-3">
                <div class="insight-item-custom flex justify-between items-center">
                    <div class="flex items-center gap-3">
                        <div class="insight-icon-base" style="background: linear-gradient(145deg, #10b981, #059669);">
                            <i class="fas fa-user-check"></i>
                        </div>
                        <div>
                            <p class="font-semibold text-gray-800">Active Accounts</p>
                            <p class="text-xs text-gray-500">With active package</p>
                        </div>
                    </div>
                    <span class="text-2xl font-bold text-gray-800" id="active-accounts"><?php echo (($tmp = (($tmp = $_smarty_tpl->tpl_vars['active_accounts']->value ?? null)===null||$tmp==='' ? $_smarty_tpl->tpl_vars['u_all']->value ?? null : $tmp) ?? null)===null||$tmp==='' ? 0 ?? null : $tmp);?>
</span>
                </div>
                
                <div class="insight-item-custom flex justify-between items-center">
                    <div class="flex items-center gap-3">
                        <div class="insight-icon-base" style="background: linear-gradient(145deg, #34d399, #10b981);">
                            <i class="fas fa-database"></i>
                        </div>
                        <div>
                            <p class="font-semibold text-gray-800">Total Users</p>
                            <p class="text-xs text-gray-500">Registered customers</p>
                        </div>
                    </div>
                    <span class="text-2xl font-bold text-gray-800" id="total-users"><?php echo (($tmp = $_smarty_tpl->tpl_vars['c_all']->value ?? null)===null||$tmp==='' ? 0 ?? null : $tmp);?>
</span>
                </div>
                
                <div class="insight-item-custom flex justify-between items-center">
                    <div class="flex items-center gap-3">
                        <div class="insight-icon-base" style="background: linear-gradient(145deg, #6ee7b7, #34d399);">
                            <i class="fas fa-wifi"></i>
                        </div>
                        <div>
                            <p class="font-semibold text-gray-800">Online Routers</p>
                            <p class="text-xs text-gray-500">Connected to system</p>
                        </div>
                    </div>
                    <span class="text-2xl font-bold text-gray-800" id="online-routers"><?php echo (($tmp = $_smarty_tpl->tpl_vars['online_routers']->value ?? null)===null||$tmp==='' ? 0 ?? null : $tmp);?>
/<?php echo (($tmp = smarty_modifier_count($_smarty_tpl->tpl_vars['routers']->value) ?? null)===null||$tmp==='' ? 0 ?? null : $tmp);?>
</span>
                </div>
                
                <?php if ((isset($_smarty_tpl->tpl_vars['active_but_not_online']->value)) && smarty_modifier_count($_smarty_tpl->tpl_vars['active_but_not_online']->value) > 0) {?>
                <div class="mt-4 pt-3 border-t border-gray-200">
                    <p class="text-xs text-gray-500 mb-2">
                        <i class="fas fa-info-circle mr-1"></i>
                        <?php echo smarty_modifier_count($_smarty_tpl->tpl_vars['active_but_not_online']->value);?>
 active users offline
                    </p>
                    <div class="text-xs text-gray-400 max-h-20 overflow-y-auto">
                        <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['active_but_not_online']->value, 'offline_user');
$_smarty_tpl->tpl_vars['offline_user']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['offline_user']->value) {
$_smarty_tpl->tpl_vars['offline_user']->do_else = false;
?>
                            <span class="inline-block bg-gray-100 rounded px-2 py-0.5 mr-1 mb-1"><?php echo $_smarty_tpl->tpl_vars['offline_user']->value;?>
</span>
                        <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
                    </div>
                </div>
                <?php }?>
            </div>
        </div>
    </div>
</div>

<?php echo '<script'; ?>
 src="https://code.jquery.com/jquery-3.6.0.min.js"><?php echo '</script'; ?>
>
<?php echo '<script'; ?>
>
// Format number with commas
function formatNumber(num) {
    if (num === undefined || num === null) return '0';
    return num.toString().replace(/\B(?=(\d<?php echo 3;?>
)+(?!\d))/g, ",");
}

// Eye toggle functionality
function toggleVisibility(type) {
    const mask = document.getElementById(type + '-sales-mask');
    const real = document.getElementById(type + '-sales-real');
    const eye = document.getElementById(type + '-eye');
    
    if (mask.style.display !== 'none') {
        mask.style.display = 'none';
        real.style.display = 'inline';
        eye.classList.remove('fa-eye');
        eye.classList.add('fa-eye-slash');
    } else {
        mask.style.display = 'inline';
        real.style.display = 'none';
        eye.classList.remove('fa-eye-slash');
        eye.classList.add('fa-eye');
    }
}

// Show loading state
function showLoading() {
    $('.stat-block-mod, .insight-item-custom, .sales-gradient').addClass('loading');
}

// Hide loading state
function hideLoading() {
    $('.stat-block-mod, .insight-item-custom, .sales-gradient').removeClass('loading');
}

// Pulse animation on update
function pulseElement(elementId) {
    $('#' + elementId).addClass('pulse-animation');
    setTimeout(function() { 
        $('#' + elementId).removeClass('pulse-animation'); 
    }, 500);
}

let autoRefreshInterval = null;
let currentRouterId = 'all';

// Load data based on selected router
function loadRouterData(routerId, showLoader = true) {
    if (showLoader) showLoading();
    
    var filterRouter = routerId || $('#router-select').val();
    currentRouterId = filterRouter;
    console.log('Loading data for router:', filterRouter);
    
    // Use app-generated dashboard URL so routing matches url_canonical / index.php
    var base = (typeof window.__dashboardRouterAjax === 'string' && window.__dashboardRouterAjax.length > 0)
        ? window.__dashboardRouterAjax
        : (window.location.href.split('?')[0] + '?_route=dashboard');
    var joinChar = (base.indexOf('?') !== -1) ? '&' : '?';
    var url = base + joinChar + 'router_id=' + encodeURIComponent(filterRouter);
    
    $.ajax({
        url: url,
        method: 'GET',
        dataType: 'json',
        timeout: 10000,
        headers: {
            'X-Requested-With': 'XMLHttpRequest'
        },
        success: function(response) {
            console.log('Data received:', response);
            
            if (response && response.success) {
                // Update revenue cards
                if (response.today_sales !== undefined) {
                    var formatted = formatNumber(Math.round(response.today_sales));
                    $('#today-sales-real').text(formatted);
                    pulseElement('today-sales-real');
                }
                if (response.monthly_sales !== undefined) {
                    var formatted = formatNumber(Math.round(response.monthly_sales));
                    $('#month-sales-real').text(formatted);
                    pulseElement('month-sales-real');
                }
                
                // Update online users counts
                if (response.online_users !== undefined) {
                    $('#total-online-users').text(response.online_users);
                    pulseElement('total-online-users');
                }
                
                // Update hotspot count
                if (response.hotspot_online !== undefined) {
                    $('#online-hotspot-users').text(response.hotspot_online);
                    pulseElement('online-hotspot-users');
                }
                
                // Update PPPoE count
                if (response.pppoe_online !== undefined) {
                    $('#online-pppoe-users').text(response.pppoe_online);
                    pulseElement('online-pppoe-users');
                }
                
                // Update insight data
                if (response.active_accounts !== undefined) {
                    $('#active-accounts').text(response.active_accounts);
                }
                if (response.total_users !== undefined) {
                    $('#total-users').text(response.total_users);
                }
                if (response.online_routers !== undefined && response.total_routers !== undefined) {
                    $('#online-routers').text(response.online_routers + '/' + response.total_routers);
                }
            } else {
                console.error('Invalid response format:', response);
                if (response && response.error) {
                    console.error('Error message:', response.error);
                }
            }
            
            // Update timestamp
            var now = new Date();
            var timeStr = now.getHours().toString().padStart(2,'0') + ':' + 
                         now.getMinutes().toString().padStart(2,'0') + ':' + 
                         now.getSeconds().toString().padStart(2,'0');
            $('#last-update').text(timeStr);
            
            if (showLoader) hideLoading();
        },
        error: function(xhr, status, error) {
            console.error('Error loading data:', error);
            console.error('Status:', status);
            
            $('#last-update').text(new Date().toLocaleTimeString() + ' (error)');
            if (showLoader) hideLoading();
        }
    });
}

// Start auto-refresh
function startAutoRefresh() {
    if (autoRefreshInterval) {
        clearInterval(autoRefreshInterval);
    }
    autoRefreshInterval = setInterval(function() {
        var selectedRouter = $('#router-select').val();
        console.log('Auto-refresh triggered for router:', selectedRouter);
        loadRouterData(selectedRouter, false);
    }, 30000); // Update every 30 seconds
}

// Stop auto-refresh
function stopAutoRefresh() {
    if (autoRefreshInterval) {
        clearInterval(autoRefreshInterval);
        autoRefreshInterval = null;
    }
}

// Document ready
$(document).ready(function() {
    console.log('Dashboard ready - Auto-update on router selection enabled');
    
    // Initialize auto-refresh
    startAutoRefresh();
    
    // AUTO-UPDATE ON ROUTER SELECTION - NO NEED TO CLICK APPLY
    $('#router-select').on('change', function() {
        var selectedRouter = $(this).val();
        var selectedText = $(this).find('option:selected').text();
        console.log('Router changed to:', selectedRouter, selectedText);
        
        // Immediately load data for the selected router
        loadRouterData(selectedRouter, true);
        
        // Visual feedback
        $('#refresh-btn i').addClass('fa-spin');
        setTimeout(function() {
            $('#refresh-btn i').removeClass('fa-spin');
        }, 500);
    });
    
    // Refresh button click - force refresh with current selection
    $('#refresh-btn').on('click', function() {
        console.log('Manual refresh clicked');
        var selectedRouter = $('#router-select').val();
        loadRouterData(selectedRouter, true);
        // Add visual feedback
        $(this).find('i').addClass('fa-spin');
        setTimeout(function() {
            $('#refresh-btn i').removeClass('fa-spin');
        }, 800);
    });
    
    // Ensure masked amounts are shown initially
    $('#today-sales-mask').show();
    $('#today-sales-real').hide();
    $('#month-sales-mask').show();
    $('#month-sales-real').hide();
    
    // Log initial values
    console.log('Initial PPPoE count:', $('#online-pppoe-users').text());
    console.log('Initial Hotspot count:', $('#online-hotspot-users').text());
});
<?php echo '</script'; ?>
>
</div><?php }
}
