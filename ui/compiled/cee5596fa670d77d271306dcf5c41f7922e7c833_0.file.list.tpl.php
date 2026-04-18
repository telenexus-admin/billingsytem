<?php
/* Smarty version 4.5.3, created on 2026-04-17 15:19:40
  from 'C:\Users\Administrator\Downloads\phpbilling sytem\ui\ui\admin\routers\list.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.3',
  'unifunc' => 'content_69e2255ce8ca78_31866472',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'cee5596fa670d77d271306dcf5c41f7922e7c833' => 
    array (
      0 => 'C:\\Users\\Administrator\\Downloads\\phpbilling sytem\\ui\\ui\\admin\\routers\\list.tpl',
      1 => 1776361575,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
    'file:sections/header.tpl' => 1,
    'file:sections/footer.tpl' => 1,
  ),
),false)) {
function content_69e2255ce8ca78_31866472 (Smarty_Internal_Template $_smarty_tpl) {
$_smarty_tpl->_checkPlugins(array(0=>array('file'=>'C:\\Users\\Administrator\\Downloads\\phpbillingsytem\\system\\vendor\\smarty\\smarty\\libs\\plugins\\modifier.count.php','function'=>'smarty_modifier_count',),1=>array('file'=>'C:\\Users\\Administrator\\Downloads\\phpbillingsytem\\system\\vendor\\smarty\\smarty\\libs\\plugins\\modifier.date_format.php','function'=>'smarty_modifier_date_format',),));
$_smarty_tpl->_subTemplateRender("file:sections/header.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
?>

<style>
:root {
    --primary: #ff9900;
    --primary-dark: #e68a00;
    --primary-light: #ffb84d;
    --primary-soft: #fff4e0;
    --success: #10b981;
    --danger: #ef4444;
    --warning: #f59e0b;
    --info: #3b82f6;
    --dark: #1e293b;
    --light: #f8fafc;
    --border: #e2e8f0;
    --shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
    --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
    --radius: 12px;
    --radius-sm: 8px;
}

/* Page Header */
.page-header {
    background: linear-gradient(135deg, var(--primary), var(--primary-dark));
    padding: 24px;
    border-radius: var(--radius);
    margin-bottom: 24px;
    color: white;
    box-shadow: var(--shadow-lg);
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.page-header h4 {
    margin: 0;
    font-weight: 600;
    font-size: 1.5rem;
    display: flex;
    align-items: center;
    gap: 12px;
}

.page-header h4 i {
    font-size: 1.8rem;
    background: rgba(255,255,255,0.2);
    padding: 10px;
    border-radius: 50%;
}

/* Section Headers */
.section-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 20px;
    padding-bottom: 12px;
    border-bottom: 3px solid var(--primary-light);
}

.section-header h2 {
    margin: 0;
    font-size: 1.4rem;
    font-weight: 600;
    color: var(--dark);
    display: flex;
    align-items: center;
    gap: 10px;
}

.section-header h2 i {
    color: var(--primary);
    font-size: 1.6rem;
}

.section-header .badge {
    background: var(--primary-soft);
    color: var(--primary-dark);
    padding: 6px 15px;
    border-radius: 30px;
    font-weight: 600;
    font-size: 0.9rem;
    border: 1px solid var(--primary-light);
}

/* Search Section */
.search-section {
    background: white;
    border-radius: var(--radius);
    padding: 20px;
    margin-bottom: 24px;
    box-shadow: var(--shadow);
    border: 1px solid var(--primary-light);
}

.search-form {
    display: flex;
    gap: 12px;
    align-items: center;
}

.search-input-group {
    flex: 1;
    position: relative;
}

.search-input-group i {
    position: absolute;
    left: 14px;
    top: 50%;
    transform: translateY(-50%);
    color: var(--primary);
    font-size: 16px;
}

.search-input-group input {
    width: 100%;
    padding: 12px 12px 12px 42px;
    border: 2px solid var(--primary-light);
    border-radius: var(--radius-sm);
    font-size: 14px;
    transition: all 0.3s;
}

.search-input-group input:focus {
    border-color: var(--primary);
    outline: none;
    box-shadow: 0 0 0 3px rgba(255,153,0,0.1);
}

.btn-search {
    background: linear-gradient(135deg, var(--primary), var(--primary-dark));
    color: white;
    border: none;
    padding: 12px 30px;
    border-radius: var(--radius-sm);
    font-weight: 600;
    display: flex;
    align-items: center;
    gap: 8px;
    cursor: pointer;
    transition: all 0.3s;
}

.btn-search:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(255,153,0,0.3);
}

.btn-add {
    background: white;
    color: var(--primary);
    border: 2px solid var(--primary);
    padding: 12px 25px;
    border-radius: var(--radius-sm);
    font-weight: 600;
    display: flex;
    align-items: center;
    gap: 8px;
    cursor: pointer;
    transition: all 0.3s;
    text-decoration: none;
}

.btn-add:hover {
    background: var(--primary);
    color: white;
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(255,153,0,0.2);
    text-decoration: none;
}

/* Router Card */
.router-card {
    background: white;
    border-radius: var(--radius);
    margin-bottom: 12px;
    box-shadow: var(--shadow);
    border: 1px solid var(--border);
    transition: all 0.3s;
    overflow: hidden;
}

.router-card:hover {
    transform: translateX(4px);
    box-shadow: var(--shadow-lg);
    border-color: var(--primary-light);
}

.router-card.disabled {
    background: #fef2f2;
    opacity: 0.8;
}

.router-header {
    padding: 16px 20px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    cursor: pointer;
    background: linear-gradient(to right, transparent, rgba(255,153,0,0.02));
}

.router-info {
    display: flex;
    align-items: center;
    gap: 20px;
    flex: 1;
    flex-wrap: wrap;
}

.router-name {
    display: flex;
    align-items: center;
    gap: 8px;
    min-width: 180px;
}

.router-name i {
    color: var(--primary);
    font-size: 20px;
}

.router-name strong {
    font-size: 16px;
    color: var(--dark);
}

.router-location {
    color: var(--primary);
    text-decoration: none;
    padding: 4px 8px;
    border-radius: 20px;
    background: var(--primary-soft);
    transition: all 0.2s;
}

.router-location:hover {
    background: var(--primary);
    color: white;
}

.router-ip {
    font-family: 'Courier New', monospace;
    background: var(--light);
    padding: 6px 12px;
    border-radius: 20px;
    font-size: 13px;
    color: var(--dark);
    border: 1px solid var(--border);
    min-width: 140px;
}

.router-username {
    font-family: 'Courier New', monospace;
    color: var(--dark);
    font-size: 13px;
    min-width: 120px;
}

.router-status {
    display: flex;
    align-items: center;
    gap: 20px;
    min-width: 300px;
}

.status-badge {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 6px 12px;
    border-radius: 30px;
    font-size: 13px;
    font-weight: 600;
    min-width: 90px;
}

.status-badge.online {
    background: #d1fae5;
    color: #065f46;
    border: 1px solid #10b981;
}

.status-badge.offline {
    background: #fee2e2;
    color: #991b1b;
    border: 1px solid #ef4444;
}

.status-badge.warning {
    background: #fed7aa;
    color: #9b4d00;
    border: 1px solid #f59e0b;
}

.status-badge i {
    font-size: 14px;
}

.last-seen {
    color: var(--dark);
    font-size: 13px;
    display: flex;
    align-items: center;
    gap: 5px;
}

.last-seen i {
    color: var(--primary);
}

.router-actions {
    display: flex;
    gap: 8px;
}

.action-btn {
    width: 36px;
    height: 36px;
    border-radius: 8px;
    border: none;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.2s;
    color: white;
    font-size: 16px;
}

.action-btn.edit { background: var(--info); }
.action-btn.test { background: var(--success); }
.action-btn.reboot { background: var(--warning); }
.action-btn.delete { background: var(--danger); }

.action-btn:hover {
    transform: translateY(-2px);
    filter: brightness(1.1);
    box-shadow: 0 4px 8px rgba(0,0,0,0.15);
}

.action-btn:disabled {
    opacity: 0.6;
    cursor: not-allowed;
    transform: none;
}

/* Router Details */
.router-details {
    padding: 20px;
    border-top: 1px solid var(--border);
    background: var(--light);
    display: none;
}

.details-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 20px;
}

.detail-item {
    display: flex;
    flex-direction: column;
    gap: 4px;
}

.detail-label {
    font-size: 12px;
    color: #64748b;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.detail-value {
    font-size: 14px;
    color: var(--dark);
    font-weight: 500;
    display: flex;
    align-items: center;
    gap: 8px;
}

.detail-value i {
    color: var(--primary);
}

/* Pagination */
.pagination {
    margin: 30px 0 10px;
    display: flex;
    justify-content: center;
    gap: 8px;
}

.page-item {
    list-style: none;
}

.page-link {
    display: flex;
    align-items: center;
    justify-content: center;
    min-width: 40px;
    height: 40px;
    padding: 0 8px;
    border: 2px solid var(--border);
    border-radius: 8px;
    color: var(--dark);
    text-decoration: none;
    font-weight: 500;
    transition: all 0.2s;
}

.page-link:hover {
    border-color: var(--primary);
    color: var(--primary);
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(255,153,0,0.1);
}

.page-item.active .page-link {
    background: var(--primary);
    border-color: var(--primary);
    color: white;
}

.page-item.disabled .page-link {
    opacity: 0.5;
    cursor: not-allowed;
    pointer-events: none;
}

/* Loading Spinner */
.spinner {
    animation: spin 1s linear infinite;
}

@keyframes spin {
    from { transform: rotate(0deg); }
    to { transform: rotate(360deg); }
}

/* Stats Cards */
.stats-row {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 20px;
    margin-bottom: 24px;
}

.stat-card {
    background: white;
    border-radius: var(--radius);
    padding: 20px;
    box-shadow: var(--shadow);
    border: 1px solid var(--border);
    display: flex;
    align-items: center;
    gap: 15px;
    transition: all 0.3s;
}

.stat-card:hover {
    transform: translateY(-2px);
    box-shadow: var(--shadow-lg);
    border-color: var(--primary-light);
}

.stat-icon {
    width: 50px;
    height: 50px;
    border-radius: 12px;
    background: var(--primary-soft);
    color: var(--primary);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 24px;
}

.stat-content h3 {
    margin: 0;
    font-size: 1.5rem;
    font-weight: 700;
    color: var(--dark);
    line-height: 1.2;
}

.stat-content p {
    margin: 0;
    color: #64748b;
    font-size: 0.9rem;
    font-weight: 500;
}

/* Quick Actions */
.quick-actions {
    background: white;
    border-radius: var(--radius);
    padding: 20px;
    margin-bottom: 24px;
    box-shadow: var(--shadow);
    border: 1px solid var(--border);
}

.quick-actions h3 {
    margin: 0 0 15px 0;
    font-size: 1.1rem;
    color: var(--dark);
    display: flex;
    align-items: center;
    gap: 8px;
}

.quick-actions h3 i {
    color: var(--primary);
}

.action-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
    gap: 12px;
}

.quick-action-btn {
    background: var(--light);
    border: 1px solid var(--border);
    border-radius: var(--radius-sm);
    padding: 12px;
    display: flex;
    align-items: center;
    gap: 10px;
    color: var(--dark);
    text-decoration: none;
    transition: all 0.3s;
    cursor: pointer;
}

.quick-action-btn:hover {
    background: var(--primary);
    color: white;
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(255,153,0,0.2);
    border-color: var(--primary);
}

.quick-action-btn:hover i {
    color: white;
}

/* Responsive */
@media (max-width: 1200px) {
    .router-info {
        gap: 10px;
    }
    
    .router-status {
        min-width: auto;
    }
}

@media (max-width: 768px) {
    .search-form {
        flex-direction: column;
    }
    
    .search-input-group,
    .btn-search,
    .btn-add {
        width: 100%;
    }
    
    .router-header {
        flex-direction: column;
        gap: 15px;
    }
    
    .router-info {
        flex-direction: column;
        align-items: flex-start;
        width: 100%;
    }
    
    .router-name {
        min-width: auto;
    }
    
    .router-status {
        width: 100%;
        justify-content: space-between;
    }
    
    .details-grid {
        grid-template-columns: 1fr;
    }
    
    .stats-row {
        grid-template-columns: 1fr;
    }
    
    .action-grid {
        grid-template-columns: 1fr;
    }
}
</style>

<!-- Main Page Header -->
<div class="page-header">
    <h4>
        <i class="fa fa-globe"></i>
        Network Router Management
    </h4>
    <span class="badge" style="background: rgba(255,255,255,0.2); padding: 8px 16px;">
        <i class="fa fa-hdd-o"></i> Total Routers: <?php echo smarty_modifier_count($_smarty_tpl->tpl_vars['d']->value);?>

    </span>
</div>

<!-- Statistics Cards -->
<div class="stats-row">
    <div class="stat-card">
        <div class="stat-icon">
            <i class="fa fa-server"></i>
        </div>
        <div class="stat-content">
            <h3><?php echo smarty_modifier_count($_smarty_tpl->tpl_vars['d']->value);?>
</h3>
            <p>Total Routers</p>
        </div>
    </div>
    <div class="stat-card">
        <div class="stat-icon">
            <i class="fa fa-check-circle" style="color: var(--success);"></i>
        </div>
        <div class="stat-content">
            <?php $_smarty_tpl->_assignInScope('online_count', 0);?>
            <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['d']->value, 'ds');
$_smarty_tpl->tpl_vars['ds']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['ds']->value) {
$_smarty_tpl->tpl_vars['ds']->do_else = false;
?>
                <?php if ($_smarty_tpl->tpl_vars['ds']->value['status'] == 'Online') {?>
                    <?php $_smarty_tpl->_assignInScope('online_count', $_smarty_tpl->tpl_vars['online_count']->value+1);?>
                <?php }?>
            <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
            <h3><?php echo $_smarty_tpl->tpl_vars['online_count']->value;?>
</h3>
            <p>Online Routers</p>
        </div>
    </div>
    <div class="stat-card">
        <div class="stat-icon">
            <i class="fa fa-times-circle" style="color: var(--danger);"></i>
        </div>
        <div class="stat-content">
            <?php $_smarty_tpl->_assignInScope('offline_count', 0);?>
            <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['d']->value, 'ds');
$_smarty_tpl->tpl_vars['ds']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['ds']->value) {
$_smarty_tpl->tpl_vars['ds']->do_else = false;
?>
                <?php if ($_smarty_tpl->tpl_vars['ds']->value['status'] == 'Offline') {?>
                    <?php $_smarty_tpl->_assignInScope('offline_count', $_smarty_tpl->tpl_vars['offline_count']->value+1);?>
                <?php }?>
            <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
            <h3><?php echo $_smarty_tpl->tpl_vars['offline_count']->value;?>
</h3>
            <p>Offline Routers</p>
        </div>
    </div>
    <div class="stat-card">
        <div class="stat-icon">
            <i class="fa fa-clock-o" style="color: var(--warning);"></i>
        </div>
        <div class="stat-content">
            <h3><?php echo $_smarty_tpl->tpl_vars['paginator']->value->total_pages;?>
</h3>
            <p>Total Pages</p>
        </div>
    </div>
</div>

<!-- Search Section Header -->
<div class="section-header">
    <h2>
        <i class="fa fa-search"></i>
        Search Routers
    </h2>
    <span class="badge">Quick Search</span>
</div>

<div class="search-section">
    <form method="post" action="<?php echo Text::url('');?>
routers/list/" class="search-form">
        <div class="search-input-group">
            <i class="fa fa-search"></i>
            <input type="text" name="name" placeholder="Search by router name, IP, or username...">
        </div>
        <button type="submit" class="btn-search">
            <i class="fa fa-search"></i> Search
        </button>
        <a href="<?php echo Text::url('');?>
routers/add" class="btn-add">
            <i class="fa fa-plus"></i> + New Router
        </a>
    </form>
</div>

<!-- Quick Actions Section -->
<div class="quick-actions">
    <h3>
        <i class="fa fa-bolt"></i>
        Quick Actions
    </h3>
    <div class="action-grid">
        <a href="<?php echo Text::url('');?>
routers/add" class="quick-action-btn">
            <i class="fa fa-plus-circle"></i>
            Add Router
        </a>
        <a href="<?php echo Text::url('');?>
routers/list" class="quick-action-btn">
            <i class="fa fa-refresh"></i>
            Refresh List
        </a>
        <button onclick="checkAllStatus()" class="quick-action-btn">
            <i class="fa fa-plug"></i>
            Check All Status
        </button>
    </div>
</div>

<!-- Routers List Header -->
<div class="section-header">
    <h2>
        <i class="fa fa-list"></i>
        Router List
    </h2>
    <span class="badge">Showing <?php echo smarty_modifier_count($_smarty_tpl->tpl_vars['d']->value);?>
 of <?php echo $_smarty_tpl->tpl_vars['paginator']->value->total_items;?>
 routers</span>
</div>

<div class="router-list">
    <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['d']->value, 'ds');
$_smarty_tpl->tpl_vars['ds']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['ds']->value) {
$_smarty_tpl->tpl_vars['ds']->do_else = false;
?>
    <div class="router-card <?php if ($_smarty_tpl->tpl_vars['ds']->value['enabled'] != 1) {?>disabled<?php }?>" id="router-<?php echo $_smarty_tpl->tpl_vars['ds']->value['id'];?>
">
        <div class="router-header" onclick="toggleDetails(<?php echo $_smarty_tpl->tpl_vars['ds']->value['id'];?>
)">
            <div class="router-info">
                <div class="router-name">
                    <?php if ($_smarty_tpl->tpl_vars['ds']->value['coordinates']) {?>
                    <a href="https://www.google.com/maps/dir//<?php echo $_smarty_tpl->tpl_vars['ds']->value['coordinates'];?>
/" target="_blank" 
                       class="router-location" title="View on Google Maps" onclick="event.stopPropagation()">
                        <i class="fa fa-map-marker"></i>
                    </a>
                    <?php }?>
                    <i class="fa fa-server"></i>
                    <strong><?php echo $_smarty_tpl->tpl_vars['ds']->value['name'];?>
</strong>
                </div>
                
                <div class="router-ip">
                    <i class="fa fa-globe"></i> <?php echo $_smarty_tpl->tpl_vars['ds']->value['ip_address'];?>

                </div>
                
                <div class="router-username">
                    <i class="fa fa-user"></i> <?php echo $_smarty_tpl->tpl_vars['ds']->value['username'];?>

                </div>
                
                <div class="router-status">
                    <span id="status-<?php echo $_smarty_tpl->tpl_vars['ds']->value['id'];?>
" class="status-badge <?php if ($_smarty_tpl->tpl_vars['ds']->value['status'] == 'Online') {?>online<?php } elseif ($_smarty_tpl->tpl_vars['ds']->value['status'] == 'Rebooting') {?>warning<?php } else { ?>offline<?php }?>">
                        <?php if ($_smarty_tpl->tpl_vars['ds']->value['status'] == 'Online') {?>
                            <i class="fa fa-check-circle"></i> Online
                        <?php } elseif ($_smarty_tpl->tpl_vars['ds']->value['status'] == 'Rebooting') {?>
                            <i class="fa fa-spinner spinner"></i> Rebooting
                        <?php } else { ?>
                            <i class="fa fa-times-circle"></i> Offline
                        <?php }?>
                    </span>
                    
                    <span id="lastseen-<?php echo $_smarty_tpl->tpl_vars['ds']->value['id'];?>
" class="last-seen">
                        <i class="fa fa-clock-o"></i>
                        <?php if ($_smarty_tpl->tpl_vars['ds']->value['last_seen']) {?>
                            <?php echo smarty_modifier_date_format($_smarty_tpl->tpl_vars['ds']->value['last_seen'],"%H:%M:%S");?>

                        <?php } else { ?>
                            Never
                        <?php }?>
                    </span>
                </div>
            </div>
            
            <div class="router-actions" onclick="event.stopPropagation()">
                <a href="<?php echo Text::url('');?>
routers/edit/<?php echo $_smarty_tpl->tpl_vars['ds']->value['id'];?>
" class="action-btn edit" title="Edit Router">
                    <i class="fa fa-pencil"></i>
                </a>
                <button onclick="testConnection(<?php echo $_smarty_tpl->tpl_vars['ds']->value['id'];?>
)" class="action-btn test" title="Test Connection">
                    <i class="fa fa-plug"></i>
                </button>
                <button onclick="rebootRouter(<?php echo $_smarty_tpl->tpl_vars['ds']->value['id'];?>
, '<?php echo $_smarty_tpl->tpl_vars['ds']->value['name'];?>
')" class="action-btn reboot" title="Reboot Router">
                    <i class="fa fa-power-off"></i>
                </button>
                <button onclick="deleteRouter(<?php echo $_smarty_tpl->tpl_vars['ds']->value['id'];?>
, '<?php echo $_smarty_tpl->tpl_vars['ds']->value['name'];?>
')" class="action-btn delete" title="Delete Router">
                    <i class="fa fa-trash"></i>
                </button>
            </div>
        </div>
        
        <div class="router-details" id="details-<?php echo $_smarty_tpl->tpl_vars['ds']->value['id'];?>
">
            <div class="details-grid">
                <div class="detail-item">
                    <span class="detail-label">Description</span>
                    <span class="detail-value">
                        <i class="fa fa-info-circle"></i>
                        <?php if ($_smarty_tpl->tpl_vars['ds']->value['description']) {?>
                            <?php echo $_smarty_tpl->tpl_vars['ds']->value['description'];?>

                        <?php } else { ?>
                            No description
                        <?php }?>
                    </span>
                </div>
                
                <div class="detail-item">
                    <span class="detail-label">Uptime</span>
                    <span class="detail-value" id="uptime-<?php echo $_smarty_tpl->tpl_vars['ds']->value['id'];?>
">
                        <i class="fa fa-dashboard"></i>
                        <?php if ($_smarty_tpl->tpl_vars['ds']->value['status'] == 'Online') {?>
                            <i class="fa fa-spinner spinner"></i> Loading...
                        <?php } else { ?>
                            -
                        <?php }?>
                    </span>
                </div>
                
                <div class="detail-item">
                    <span class="detail-label">Version</span>
                    <span class="detail-value" id="version-<?php echo $_smarty_tpl->tpl_vars['ds']->value['id'];?>
">
                        <i class="fa fa-code-fork"></i>
                        <?php if ($_smarty_tpl->tpl_vars['ds']->value['status'] == 'Online') {?>
                            <i class="fa fa-spinner spinner"></i> Loading...
                        <?php } else { ?>
                            -
                        <?php }?>
                    </span>
                </div>
                
                <div class="detail-item">
                    <span class="detail-label">Status</span>
                    <span class="detail-value">
                        <i class="fa <?php if ($_smarty_tpl->tpl_vars['ds']->value['enabled'] == 1) {?>fa-check-circle text-success<?php } else { ?>fa-ban text-danger<?php }?>"></i>
                        <?php if ($_smarty_tpl->tpl_vars['ds']->value['enabled'] == 1) {?>Enabled<?php } else { ?>Disabled<?php }?>
                    </span>
                </div>
            </div>
        </div>
    </div>
    <?php
}
if ($_smarty_tpl->tpl_vars['ds']->do_else) {
?>
    <div class="text-center py-5">
        <i class="fa fa-server" style="font-size: 48px; color: #ccc;"></i>
        <h4 class="text-muted mt-3">No routers found</h4>
        <p>Click the "+ New Router" button to add your first router.</p>
    </div>
    <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
</div>

<!-- Pagination Section -->
<?php if ($_smarty_tpl->tpl_vars['paginator']->value->total_pages > 1) {?>
<div class="section-header" style="margin-top: 20px;">
    <h2>
        <i class="fa fa-arrows-h"></i>
        Pagination
    </h2>
    <span class="badge">Page <?php echo $_smarty_tpl->tpl_vars['paginator']->value->current_page;?>
 of <?php echo $_smarty_tpl->tpl_vars['paginator']->value->total_pages;?>
</span>
</div>

<ul class="pagination">
    <li class="page-item <?php if ($_smarty_tpl->tpl_vars['paginator']->value->current_page == 1) {?>disabled<?php }?>">
        <a class="page-link" href="<?php echo Text::url('');?>
routers/list/<?php echo $_smarty_tpl->tpl_vars['paginator']->value->prev_page;?>
">
            <i class="fa fa-chevron-left"></i>
        </a>
    </li>
    
    <?php
$_smarty_tpl->tpl_vars['i'] = new Smarty_Variable(null, $_smarty_tpl->isRenderingCache);$_smarty_tpl->tpl_vars['i']->step = 1;$_smarty_tpl->tpl_vars['i']->total = (int) ceil(($_smarty_tpl->tpl_vars['i']->step > 0 ? $_smarty_tpl->tpl_vars['paginator']->value->total_pages+1 - (1) : 1-($_smarty_tpl->tpl_vars['paginator']->value->total_pages)+1)/abs($_smarty_tpl->tpl_vars['i']->step));
if ($_smarty_tpl->tpl_vars['i']->total > 0) {
for ($_smarty_tpl->tpl_vars['i']->value = 1, $_smarty_tpl->tpl_vars['i']->iteration = 1;$_smarty_tpl->tpl_vars['i']->iteration <= $_smarty_tpl->tpl_vars['i']->total;$_smarty_tpl->tpl_vars['i']->value += $_smarty_tpl->tpl_vars['i']->step, $_smarty_tpl->tpl_vars['i']->iteration++) {
$_smarty_tpl->tpl_vars['i']->first = $_smarty_tpl->tpl_vars['i']->iteration === 1;$_smarty_tpl->tpl_vars['i']->last = $_smarty_tpl->tpl_vars['i']->iteration === $_smarty_tpl->tpl_vars['i']->total;?>
        <?php if ($_smarty_tpl->tpl_vars['i']->value >= $_smarty_tpl->tpl_vars['paginator']->value->current_page-2 && $_smarty_tpl->tpl_vars['i']->value <= $_smarty_tpl->tpl_vars['paginator']->value->current_page+2) {?>
        <li class="page-item <?php if ($_smarty_tpl->tpl_vars['i']->value == $_smarty_tpl->tpl_vars['paginator']->value->current_page) {?>active<?php }?>">
            <a class="page-link" href="<?php echo Text::url('');?>
routers/list/<?php echo $_smarty_tpl->tpl_vars['i']->value;?>
"><?php echo $_smarty_tpl->tpl_vars['i']->value;?>
</a>
        </li>
        <?php }?>
    <?php }
}
?>
    
    <li class="page-item <?php if ($_smarty_tpl->tpl_vars['paginator']->value->current_page == $_smarty_tpl->tpl_vars['paginator']->value->total_pages) {?>disabled<?php }?>">
        <a class="page-link" href="<?php echo Text::url('');?>
routers/list/<?php echo $_smarty_tpl->tpl_vars['paginator']->value->next_page;?>
">
            <i class="fa fa-chevron-right"></i>
        </a>
    </li>
</ul>
<?php }?>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content" style="border-radius: var(--radius); border: 2px solid var(--primary);">
            <div class="modal-header" style="background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: white; border: none;">
                <h5 class="modal-title">
                    <i class="fa fa-trash"></i> Confirm Delete
                </h5>
                <button type="button" class="close" data-dismiss="modal" style="color: white;">&times;</button>
            </div>
            <div class="modal-body" style="padding: 25px;">
                <p>Enter security code <strong>"antiqua"</strong> to confirm deletion:</p>
                <input type="text" id="security_code" class="form-control" placeholder="Enter antiqua" 
                       style="border: 2px solid var(--primary-light); border-radius: var(--radius-sm); padding: 12px;">
                <input type="hidden" id="delete_router_id" value="">
                <input type="hidden" id="delete_router_name" value="">
                <small class="text-muted" style="margin-top: 10px; display: block;">
                    <i class="fa fa-info-circle"></i> This action cannot be undone.
                </small>
            </div>
            <div class="modal-footer" style="border-top: 2px solid var(--primary-light);">
                <button type="button" class="btn btn-default" data-dismiss="modal" 
                        style="padding: 10px 25px; border-radius: var(--radius-sm);">
                    <i class="fa fa-times"></i> Cancel
                </button>
                <button type="button" class="btn btn-danger" onclick="confirmDelete()" 
                        style="padding: 10px 25px; border-radius: var(--radius-sm); background: var(--danger); border: none;">
                    <i class="fa fa-trash"></i> Delete
                </button>
            </div>
        </div>
    </div>
</div>
<?php echo '<script'; ?>
 src="https://code.jquery.com/jquery-3.6.0.min.js"><?php echo '</script'; ?>
>
<?php echo '<script'; ?>
 src="https://cdn.jsdelivr.net/npm/sweetalert2@11"><?php echo '</script'; ?>
>
<?php echo '<script'; ?>
>
// Get the correct base URL
var baseUrl = window.location.protocol + "//" + window.location.host + window.location.pathname.split('index.php')[0];
var fullBaseUrl = baseUrl + 'index.php?_route=';

console.log('Base URL:', baseUrl);
console.log('Full Base URL:', fullBaseUrl);

$(document).ready(function() {
    console.log('Document ready - checking router statuses');
    checkAllStatus();
    setInterval(checkAllStatus, 30000);
});

function toggleDetails(routerId) {
    $('#details-' + routerId).slideToggle(300);
}

function checkAllStatus() {
    <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['d']->value, 'ds');
$_smarty_tpl->tpl_vars['ds']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['ds']->value) {
$_smarty_tpl->tpl_vars['ds']->do_else = false;
?>
        checkRouterStatus(<?php echo $_smarty_tpl->tpl_vars['ds']->value['id'];?>
);
    <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
}

function checkRouterStatus(routerId) {
    var statusUrl = fullBaseUrl + 'routers/status/' + routerId;
    console.log('Checking status for router ' + routerId + ' at:', statusUrl);
    
    $.ajax({
        url: statusUrl,
        type: 'GET',
        dataType: 'json',
        timeout: 10000,
        success: function(response) {
            console.log('Status response for router ' + routerId + ':', response);
            
            if (response.status == 'online') {
                $('#status-' + routerId).removeClass('offline warning').addClass('online')
                    .html('<i class="fa fa-check-circle"></i> Online');
                $('#lastseen-' + routerId).html('<i class="fa fa-clock-o"></i> ' + 
                    new Date().toLocaleTimeString());
                
                if (response.uptime) {
                    $('#uptime-' + routerId).html('<i class="fa fa-dashboard"></i> ' + response.uptime);
                }
                if (response.version) {
                    $('#version-' + routerId).html('<i class="fa fa-code-fork"></i> ' + response.version);
                }
            } else if (response.status == 'offline') {
                $('#status-' + routerId).removeClass('online warning').addClass('offline')
                    .html('<i class="fa fa-times-circle"></i> Offline');
                $('#uptime-' + routerId).html('<i class="fa fa-dashboard"></i> -');
                $('#version-' + routerId).html('<i class="fa fa-code-fork"></i> -');
            }
        },
        error: function(xhr, status, error) {
            console.error('Status check error for router ' + routerId + ':', status, error);
            console.log('Response text:', xhr.responseText);
            $('#status-' + routerId).removeClass('online warning').addClass('offline')
                .html('<i class="fa fa-times-circle"></i> Offline');
        }
    });
}

function testConnection(routerId) {
    var btn = event.currentTarget;
    var originalHtml = $(btn).html();
    
    $(btn).html('<i class="fa fa-spinner spinner"></i>').prop('disabled', true);
    
    var testUrl = fullBaseUrl + 'routers/test-connection/' + routerId;
    console.log('Testing connection for router ' + routerId + ' at:', testUrl);
    
    $.ajax({
        url: testUrl,
        type: 'GET',
        dataType: 'json',
        timeout: 15000,
        success: function(response) {
            console.log('Test connection response:', response);
            
            if (response.status == 'success') {
                Swal.fire({
                    icon: 'success',
                    title: 'Connection Successful!',
                    text: response.message,
                    timer: 2000,
                    showConfirmButton: false
                });
                checkRouterStatus(routerId);
            } else {
                Swal.fire({
                    icon: 'error',
                    title: 'Connection Failed',
                    text: response.message
                });
            }
        },
        error: function(xhr, status, error) {
            console.error('Test connection error:', status, error);
            console.log('Response text:', xhr.responseText);
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Could not test connection: ' + (error || 'Timeout')
            });
        },
        complete: function() {
            $(btn).html(originalHtml).prop('disabled', false);
        }
    });
}

function rebootRouter(routerId, routerName) {
    Swal.fire({
        title: 'Reboot Router?',
        html: 'Are you sure you want to reboot <strong>' + routerName + '</strong>?<br><small class="text-warning">?? This will temporarily disconnect all users!</small>',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#ff9900',
        cancelButtonColor: '#6c757d',
        confirmButtonText: '<i class="fa fa-power-off"></i> Yes, reboot it!',
        cancelButtonText: '<i class="fa fa-times"></i> Cancel'
    }).then((result) => {
        if (result.isConfirmed) {
            Swal.fire({
                title: 'Rebooting...',
                html: 'Sending reboot command to <strong>' + routerName + '</strong><br>Please wait...',
                allowOutsideClick: false,
                showConfirmButton: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });
            
            var rebootUrl = fullBaseUrl + 'routers/reboot/' + routerId;
            console.log('Sending reboot request to:', rebootUrl);
            
            $.ajax({
                url: rebootUrl,
                type: 'POST',
                dataType: 'json',
                timeout: 30000,
                success: function(response) {
                    console.log('Reboot response:', response);
                    
                    if (response.status == 'success') {
                        Swal.fire({
                            icon: 'success',
                            title: 'Reboot Initiated!',
                            html: response.message + '<br><small>The router will be back online in a few moments.</small>',
                            timer: 5000,
                            showConfirmButton: true,
                            confirmButtonText: '<i class="fa fa-check"></i> OK'
                        }).then(() => {
                            $('#status-' + routerId).removeClass('online offline').addClass('warning')
                                .html('<i class="fa fa-spinner spinner"></i> Rebooting...');
                            
                            let checkCount = 0;
                            let checkInterval = setInterval(function() {
                                checkCount++;
                                checkRouterStatus(routerId);
                                
                                if (checkCount >= 12) {
                                    clearInterval(checkInterval);
                                }
                            }, 10000);
                        });
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: 'Reboot Failed',
                            text: response.message || 'Unknown error occurred',
                            confirmButtonText: '<i class="fa fa-check"></i> OK'
                        });
                    }
                },
                error: function(xhr, status, error) {
                    console.error('Reboot error:', status, error);
                    console.log('Response text:', xhr.responseText);
                    
                    let errorMsg = 'Failed to send reboot command';
                    
                    if (status === 'timeout') {
                        errorMsg = 'Request timeout. Router may be unreachable.';
                    } else if (xhr.status === 404) {
                        errorMsg = 'API endpoint not found. Attempted URL: ' + rebootUrl;
                    } else if (xhr.status === 500) {
                        errorMsg = 'Server error. Please check PHP error logs.';
                    } else if (xhr.responseText && xhr.responseText.indexOf('<!DOCTYPE') !== -1) {
                        errorMsg = 'Server returned HTML instead of JSON. The endpoint may not exist.';
                    } else if (xhr.responseJSON && xhr.responseJSON.message) {
                        errorMsg = xhr.responseJSON.message;
                    }
                    
                    Swal.fire({
                        icon: 'error',
                        title: 'Connection Error',
                        html: errorMsg + '<br><small>Check console for details.</small>',
                        confirmButtonText: '<i class="fa fa-check"></i> OK'
                    });
                }
            });
        }
    });
}

function deleteRouter(routerId, routerName) {
    $('#delete_router_id').val(routerId);
    $('#delete_router_name').val(routerName);
    $('#security_code').val('');
    $('#deleteModal').modal('show');
}

function confirmDelete() {
    var routerId = $('#delete_router_id').val();
    var routerName = $('#delete_router_name').val();
    var securityCode = $('#security_code').val();
    
    if (!securityCode) {
        Swal.fire('Error', 'Please enter security code', 'error');
        return;
    }
    
    if (securityCode.toLowerCase() != 'antiqua') {
        Swal.fire('Error', 'Invalid security code', 'error');
        return;
    }
    
    $('#deleteModal').modal('hide');
    
    Swal.fire({
        title: 'Deleting...',
        text: 'Please wait',
        allowOutsideClick: false,
        showConfirmButton: false,
        didOpen: () => Swal.showLoading()
    });
    
    $.ajax({
        url: fullBaseUrl + 'routers/delete/' + routerId,
        type: 'POST',
        data: {
            confirm_delete: true,
            security_code: securityCode
        },
        dataType: 'json',
        success: function(response) {
            if (response.status == 'success') {
                Swal.fire({
                    icon: 'success',
                    title: 'Deleted!',
                    text: response.message,
                    timer: 2000
                }).then(function() {
                    location.reload();
                });
            } else {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: response.message
                });
            }
        },
        error: function(xhr, status, error) {
            console.error('Delete error:', status, error);
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Failed to delete router: ' + (error || 'Unknown error')
            });
        }
    });
}
<?php echo '</script'; ?>
>
<?php $_smarty_tpl->_subTemplateRender("file:sections/footer.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
}
}
