<?php
/* Smarty version 4.5.3, created on 2026-04-18 16:00:19
  from 'C:\Users\Administrator\Downloads\testing billing\ui\ui\admin\hotspot\list.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.3',
  'unifunc' => 'content_69e38063a08b58_75257184',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'db705b4e98b11e681de6aebcd7c32bf2b84052dd' => 
    array (
      0 => 'C:\\Users\\Administrator\\Downloads\\testing billing\\ui\\ui\\admin\\hotspot\\list.tpl',
      1 => 1776361569,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
    'file:sections/header.tpl' => 1,
    'file:sections/footer.tpl' => 1,
  ),
),false)) {
function content_69e38063a08b58_75257184 (Smarty_Internal_Template $_smarty_tpl) {
$_smarty_tpl->_subTemplateRender("file:sections/header.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
?>

<style>
    :root {
        --primary: #f97316;
        --primary-dark: #ea580c;
        --primary-light: #fed7aa;
        --primary-soft: #fff7ed;
    }

    .panel-primary {
        border-color: var(--primary);
        box-shadow: 0 4px 12px rgba(249, 115, 22, 0.1);
        border-radius: 16px;
        overflow: hidden;
    }
    
    .panel-primary > .panel-heading {
        background: linear-gradient(145deg, var(--primary), var(--primary-dark));
        color: white;
        border-color: var(--primary-dark);
        font-weight: 600;
        padding: 12px 15px;
    }
    
    .panel-heading .btn-primary {
        background: white;
        color: var(--primary);
        border: none;
        border-radius: 20px;
        font-weight: 600;
        padding: 4px 12px;
        transition: all 0.2s;
    }
    
    .panel-heading .btn-primary:hover {
        background: var(--primary-soft);
        transform: translateY(-1px);
    }
    
    .panel-body {
        background: white;
    }
    
    .form-control {
        border: 2px solid #e2e8f0;
        border-radius: 12px;
        padding: 8px 12px;
        transition: all 0.2s;
        height: 40px;
    }
    
    .form-control:focus {
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(249, 115, 22, 0.1);
    }
    
    .btn-danger {
        background: #ef4444;
        border: none;
        border-radius: 8px;
        transition: all 0.2s;
    }
    
    .btn-danger:hover {
        background: #dc2626;
        transform: translateY(-1px);
    }
    
    .btn-success {
        background: linear-gradient(145deg, var(--primary), var(--primary-dark));
        border: none;
        border-radius: 12px;
        font-weight: 500;
        transition: all 0.2s;
        color: white;
    }
    
    .btn-success:hover {
        background: linear-gradient(145deg, var(--primary-dark), #c2410c);
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(249, 115, 22, 0.3);
    }
    
    .btn-primary {
        background: linear-gradient(145deg, var(--primary), var(--primary-dark));
        border: none;
        border-radius: 12px;
        font-weight: 500;
        color: white;
    }
    
    .btn-primary:hover {
        background: linear-gradient(145deg, var(--primary-dark), #c2410c);
    }
    
    .btn-info {
        background: var(--primary-soft);
        border: 1px solid var(--primary);
        color: var(--primary-dark);
        border-radius: 8px;
    }
    
    .btn-info:hover {
        background: var(--primary-light);
    }
    
    .input-group-addon {
        background: var(--primary-soft);
        border: 2px solid #e2e8f0;
        border-right: none;
        color: var(--primary);
        font-weight: 500;
    }
    
    /* Table styling */
    .table {
        border-radius: 12px;
        overflow: hidden;
    }
    
    .table thead tr:first-child th {
        background: var(--primary-soft);
        color: var(--primary-dark);
        font-weight: 600;
        border-bottom: 2px solid var(--primary-light);
    }
    
    .table thead tr:first-child th[colspan] {
        background: var(--primary-soft);
        color: var(--primary-dark);
    }
    
    .table thead tr:last-child th {
        background: white;
        color: #1e293b;
        font-weight: 600;
        border-bottom: 2px solid var(--primary-light);
    }
    
    .table thead th[style*="background-color: rgb(246, 244, 244)"] {
        background: var(--primary-soft) !important;
        color: var(--primary-dark) !important;
    }
    
    .table thead th[style*="background-color: rgb(243, 241, 172)"] {
        background: #fef9c3 !important;
        color: #854d0e !important;
    }
    
    .table tbody tr:hover {
        background: var(--primary-soft);
    }
    
    .table .danger {
        background: #fff1f0;
        border-left: 4px solid var(--primary);
    }
    
    .table .danger:hover {
        background: #ffe4e2;
    }
    
    .table .warning {
        background: #fef9c3;
        border-left: 4px solid #eab308;
    }
    
    .table .warning:hover {
        background: #fef08a;
    }
    
    .table td .label-primary {
        background: var(--primary);
        padding: 3px 8px;
        border-radius: 20px;
        font-size: 10px;
        font-weight: 600;
    }
    
    .table td a {
        color: var(--primary);
        font-weight: 500;
    }
    
    .table td a:hover {
        color: var(--primary-dark);
    }
    
    .headcol {
        font-weight: 600;
        color: var(--primary-dark);
    }
    
    sup {
        color: #ef4444;
        font-size: 10px;
    }
    
    /* Pagination */
    .pagination > li > a,
    .pagination > li > span {
        border: 1px solid var(--primary-light);
        color: var(--primary);
        margin: 0 3px;
        border-radius: 8px !important;
    }
    
    .pagination > li > a:hover,
    .pagination > li > span:hover {
        background: var(--primary);
        border-color: var(--primary);
        color: white;
    }
    
    .pagination > .active > a,
    .pagination > .active > span {
        background: var(--primary);
        border-color: var(--primary);
    }
    
    /* Callout styling */
    .bs-callout-info {
        background: var(--primary-soft);
        border-left: 4px solid var(--primary);
        border-radius: 8px;
        padding: 15px;
        margin-top: 20px;
    }
    
    .bs-callout-info h4 {
        color: var(--primary-dark);
        font-weight: 600;
        margin-top: 0;
        margin-bottom: 10px;
    }
    
    .bs-callout-info p {
        color: #1e293b;
        margin-bottom: 0;
    }
    
    /* Panel footer */
    .panel-footer {
        background: white;
        border-top: 2px solid var(--primary-light);
        padding: 15px;
    }

    .plan-stats-bar {
        display: flex;
        flex-wrap: wrap;
        gap: 12px;
        align-items: stretch;
        margin: 0 5px 16px 5px;
    }

    .plan-stat-card {
        flex: 1 1 140px;
        background: #fff;
        border: 1px solid #e2e8f0;
        border-radius: 12px;
        padding: 14px 16px;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
    }

    .plan-stat-card .plan-stat-label {
        font-size: 11px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.04em;
        color: #64748b;
        margin-bottom: 4px;
    }

    .plan-stat-card .plan-stat-value {
        font-size: 1.75rem;
        font-weight: 700;
        line-height: 1.2;
    }

    .plan-stat-card.plan-stat-total .plan-stat-value {
        color: var(--primary-dark);
    }

    .plan-stat-card.plan-stat-on .plan-stat-value {
        color: #16a34a;
    }

    .plan-stat-card.plan-stat-off .plan-stat-value {
        color: #dc2626;
    }

    .plan-stat-card.plan-stat-expired .plan-stat-value {
        color: #d97706;
    }

    .plan-list-meta {
        margin: 0 5px 10px 5px;
        font-size: 13px;
        color: #64748b;
    }
</style>

<div class="row">
    <div class="col-sm-12">
        <div class="panel panel-hovered mb20 panel-primary">
            <div class="panel-heading">
                <div class="btn-group pull-right">
                    <a class="btn btn-primary btn-xs" title="save" href="<?php echo Text::url('services/sync/hotspot');?>
"
                        onclick="return ask(this, 'This will sync/send hotspot package to Mikrotik?')">
                        <span class="glyphicon glyphicon-refresh" aria-hidden="true"></span> <?php echo Lang::T('sync');?>

                    </a>
                </div>
                <i class="glyphicon glyphicon-tags" style="margin-right: 8px;"></i>
                <?php echo Lang::T('Hotspot Plans');?>

            </div>
            <form id="site-search" method="post" action="<?php echo Text::url('services/hotspot/');?>
">
                <div class="panel-body">
                    <div class="row row-no-gutters" style="padding: 5px">
                        <div class="col-lg-2">
                            <div class="input-group">
                                <div class="input-group-btn">
                                    <a class="btn btn-danger" title="Clear Search Query"
                                        href="<?php echo Text::url('services/hotspot/');?>
">
                                        <span class="glyphicon glyphicon-remove-circle"></span>
                                    </a>
                                </div>
                                <input type="text" name="name" class="form-control"
                                    placeholder="<?php echo Lang::T('Search by Name');?>
...">
                            </div>
                        </div>
                       
                        <div class="col-lg-1 col-xs-4">
                            <select class="form-control" id="bandwidth" name="bandwidth">
                                <option value="">Bandwidth</option>
                                <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['bws']->value, 'b');
$_smarty_tpl->tpl_vars['b']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['b']->value) {
$_smarty_tpl->tpl_vars['b']->do_else = false;
?>
                                    <option value="<?php echo $_smarty_tpl->tpl_vars['b']->value['id'];?>
" <?php if ($_smarty_tpl->tpl_vars['bandwidth']->value == $_smarty_tpl->tpl_vars['b']->value['id']) {?>selected<?php }?>>
                                        <?php echo $_smarty_tpl->tpl_vars['b']->value['name_bw'];?>

                                    </option>
                                <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
                            </select>
                        </div>
                        <div class="col-lg-1 col-xs-4">
                            <select class="form-control" id="type3" name="type3">
                                <option value=""><?php echo Lang::T('Category');?>
</option>
                                <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['type3s']->value, 't');
$_smarty_tpl->tpl_vars['t']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['t']->value) {
$_smarty_tpl->tpl_vars['t']->do_else = false;
?>
                                    <option value="<?php echo $_smarty_tpl->tpl_vars['t']->value;?>
" <?php if ($_smarty_tpl->tpl_vars['type3']->value == $_smarty_tpl->tpl_vars['t']->value) {?>selected<?php }?>><?php echo $_smarty_tpl->tpl_vars['t']->value;?>
</option>
                                <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
                            </select>
                        </div>
                        <div class="col-lg-1 col-xs-4">
                            <select class="form-control" id="valid" name="valid">
                                <option value=""><?php echo Lang::T('Validity');?>
</option>
                                <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['valids']->value, 'v');
$_smarty_tpl->tpl_vars['v']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['v']->value) {
$_smarty_tpl->tpl_vars['v']->do_else = false;
?>
                                    <option value="<?php echo $_smarty_tpl->tpl_vars['v']->value;?>
" <?php if ($_smarty_tpl->tpl_vars['valid']->value == $_smarty_tpl->tpl_vars['v']->value) {?>selected<?php }?>><?php echo $_smarty_tpl->tpl_vars['v']->value;?>
</option>
                                <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
                            </select>
                        </div>
                        <div class="col-lg-1 col-xs-4">
                            <select class="form-control" id="router" name="router">
                                <option value=""><?php echo Lang::T('Location');?>
</option>
                                <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['routers']->value, 'r');
$_smarty_tpl->tpl_vars['r']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['r']->value) {
$_smarty_tpl->tpl_vars['r']->do_else = false;
?>
                                    <option value="<?php echo $_smarty_tpl->tpl_vars['r']->value;?>
" <?php if ($_smarty_tpl->tpl_vars['router']->value == $_smarty_tpl->tpl_vars['r']->value) {?>selected<?php }?>><?php echo $_smarty_tpl->tpl_vars['r']->value;?>
</option>
                                <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
                                                            </select>
                        </div>
                        <div class="col-lg-1 col-xs-4">
                            <select class="form-control" id="device" name="device">
                                <option value=""><?php echo Lang::T('Device');?>
</option>
                                <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['devices']->value, 'r');
$_smarty_tpl->tpl_vars['r']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['r']->value) {
$_smarty_tpl->tpl_vars['r']->do_else = false;
?>
                                    <option value="<?php echo $_smarty_tpl->tpl_vars['r']->value;?>
" <?php if ($_smarty_tpl->tpl_vars['device']->value == $_smarty_tpl->tpl_vars['r']->value) {?>selected<?php }?>><?php echo $_smarty_tpl->tpl_vars['r']->value;?>
</option>
                                <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
                            </select>
                        </div>
                        <div class="col-lg-1 col-xs-4">
                            <select class="form-control" id="status" name="status">
                                <option value="-"><?php echo Lang::T('Status');?>
</option>
                                <option value="1" <?php if ($_smarty_tpl->tpl_vars['status']->value == '1') {?>selected<?php }?>><?php echo Lang::T('Active');?>
</option>
                                <option value="0" <?php if ($_smarty_tpl->tpl_vars['status']->value == '0') {?>selected<?php }?>><?php echo Lang::T('Not Active');?>
</option>
                            </select>
                        </div>
                        <div class="col-lg-1 col-xs-8">
                            <button class="btn btn-success btn-block" type="submit">
                                <span class="fa fa-search"></span>
                            </button>
                        </div>
                        <div class="col-lg-1 col-xs-4">
                            <a href="<?php echo Text::url('services/add');?>
" class="btn btn-primary btn-block"
                                title="<?php echo Lang::T('New Service Package');?>
">
                                <i class="ion ion-android-add"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </form>
            <div class="plan-stats-bar">
                <div class="plan-stat-card plan-stat-total">
                    <div class="plan-stat-label"><?php echo Lang::T('Total');?>
</div>
                    <div class="plan-stat-value"><?php echo (($tmp = $_smarty_tpl->tpl_vars['hotspot_stats_total']->value ?? null)===null||$tmp==='' ? 0 ?? null : $tmp);?>
</div>
                </div>
                <div class="plan-stat-card plan-stat-on">
                    <div class="plan-stat-label"><?php echo Lang::T('Active');?>
</div>
                    <div class="plan-stat-value"><?php echo (($tmp = $_smarty_tpl->tpl_vars['hotspot_stats_enabled']->value ?? null)===null||$tmp==='' ? 0 ?? null : $tmp);?>
</div>
                </div>
                <div class="plan-stat-card plan-stat-off">
                    <div class="plan-stat-label"><?php echo Lang::T('Not Active');?>
</div>
                    <div class="plan-stat-value"><?php echo (($tmp = $_smarty_tpl->tpl_vars['hotspot_stats_disabled']->value ?? null)===null||$tmp==='' ? 0 ?? null : $tmp);?>
</div>
                </div>
                <div class="plan-stat-card plan-stat-expired">
                    <div class="plan-stat-label"><?php echo Lang::T('Expired_Internet_Package');?>
</div>
                    <div class="plan-stat-value"><?php echo (($tmp = $_smarty_tpl->tpl_vars['hotspot_stats_expired_package']->value ?? null)===null||$tmp==='' ? 0 ?? null : $tmp);?>
</div>
                </div>
            </div>
            <?php if ($_smarty_tpl->tpl_vars['hotspot_stats_total']->value > 0) {?>
                <p class="plan-list-meta">
                    <?php echo Lang::T('Showing');?>
 <?php echo $_smarty_tpl->tpl_vars['hotspot_stats_from']->value;?>
–<?php echo $_smarty_tpl->tpl_vars['hotspot_stats_to']->value;?>
 <?php echo Lang::T('of');?>
 <?php echo $_smarty_tpl->tpl_vars['hotspot_stats_total']->value;?>

                </p>
            <?php }?>
            <div class="table-responsive">
                <div style="margin-left: 5px; margin-right: 5px;">
                    <table class="table table-bordered table-striped table-condensed">
                        <thead>
                            <tr>
                                <th rowspan="2" class="text-center text-muted" style="width:48px;vertical-align:middle;">#</th>
                                <th colspan="5" class="text-center"><?php echo Lang::T('Internet Package');?>
</th>
                                <th colspan="2" class="text-center" style="background-color: var(--primary-soft);">
                                    <?php echo Lang::T('Limit');?>
</th>
                                <th colspan="2"></th>
                                <th colspan="2" class="text-center" style="background-color: #fef9c3;">
                                    <?php echo Lang::T('Expired');?>
</th>
                                <th colspan="3"></th>
                            </tr>
                            <tr>
                                <th><?php echo Lang::T('Name');?>
</th>
                                <th><?php echo Lang::T('Type');?>
</th>
                                <th><a href="<?php echo Text::url('bandwidth/list');?>
"><?php echo Lang::T('Bandwidth');?>
</a></th>
                                <th><?php echo Lang::T('Category');?>
</th>
                                <th><?php echo Lang::T('Price');?>
</th>
                                <th><?php echo Lang::T('Validity');?>
</th>
                                <th style="background-color: var(--primary-soft);"><?php echo Lang::T('Time');?>
</th>
                                <th style="background-color: var(--primary-soft);"><?php echo Lang::T('Data');?>
</th>
                                <th><a href="<?php echo Text::url('routers/list');?>
"><?php echo Lang::T('Router');?>
</a></th>
                                                                <th style="background-color: #fef9c3;"><?php echo Lang::T('Internet Package');?>
</th>
                                <th style="background-color: #fef9c3;"><?php echo Lang::T('Date');?>
</th>
                                <th><?php echo Lang::T('ID');?>
</th>
                                <th><?php echo Lang::T('Manage');?>
</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['d']->value, 'ds');
$_smarty_tpl->tpl_vars['ds']->iteration = 0;
$_smarty_tpl->tpl_vars['ds']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['ds']->value) {
$_smarty_tpl->tpl_vars['ds']->do_else = false;
$_smarty_tpl->tpl_vars['ds']->iteration++;
$__foreach_ds_5_saved = $_smarty_tpl->tpl_vars['ds'];
?>
                                <tr <?php if ($_smarty_tpl->tpl_vars['ds']->value['enabled'] != 1) {?>class="danger" title="disabled" <?php } elseif ($_smarty_tpl->tpl_vars['ds']->value['prepaid'] != 'yes') {?>class="warning" title="Postpaid" <?php }?>>
                                    <td class="text-center text-muted"><?php echo $_smarty_tpl->tpl_vars['hotspot_stats_from']->value+$_smarty_tpl->tpl_vars['ds']->iteration-1;?>
</td>
                                    <td class="headcol"><?php echo $_smarty_tpl->tpl_vars['ds']->value['name_plan'];?>
</td>
                                    <td>
                                        <?php if ($_smarty_tpl->tpl_vars['ds']->value['prepaid'] == 'no') {?>
                                            <span class="badge" style="background: #fef9c3; color: #854d0e;">Postpaid</span>
                                        <?php } else { ?>
                                            <span class="badge" style="background: var(--primary-soft); color: var(--primary-dark);">Prepaid</span>
                                        <?php }?>
                                        <?php echo $_smarty_tpl->tpl_vars['ds']->value['plan_type'];?>

                                    </td>
                                    <td><?php echo $_smarty_tpl->tpl_vars['ds']->value['name_bw'];?>
</td>
                                    <td><?php echo $_smarty_tpl->tpl_vars['ds']->value['typebp'];?>
</td>
                                    <td>
                                        <span style="color: var(--primary-dark); font-weight: 600;"><?php echo Lang::moneyFormat($_smarty_tpl->tpl_vars['ds']->value['price']);?>
</span>
                                        <?php if (!empty($_smarty_tpl->tpl_vars['ds']->value['price_old'])) {?>
                                            <sup style="text-decoration: line-through; color: #ef4444"><?php echo Lang::moneyFormat($_smarty_tpl->tpl_vars['ds']->value['price_old']);?>
</sup>
                                        <?php }?>
                                    </td>
                                    <td><?php echo $_smarty_tpl->tpl_vars['ds']->value['validity'];?>
 <?php echo $_smarty_tpl->tpl_vars['ds']->value['validity_unit'];?>
</td>
                                    <td><?php echo $_smarty_tpl->tpl_vars['ds']->value['time_limit'];?>
 <?php echo $_smarty_tpl->tpl_vars['ds']->value['time_unit'];?>
</td>
                                    <td><?php echo $_smarty_tpl->tpl_vars['ds']->value['data_limit'];?>
 <?php echo $_smarty_tpl->tpl_vars['ds']->value['data_unit'];?>
</td>
                                    <td>
                                        <?php if ($_smarty_tpl->tpl_vars['ds']->value['is_radius']) {?>
                                           
                                        <?php } else { ?>
                                            <?php if ($_smarty_tpl->tpl_vars['ds']->value['routers'] != '') {?>
                                                <a href="<?php echo Text::url('routers/edit/0&name=');
echo $_smarty_tpl->tpl_vars['ds']->value['routers'];?>
"><?php echo $_smarty_tpl->tpl_vars['ds']->value['routers'];?>
</a>
                                            <?php }?>
                                        <?php }?>
                                    </td>
                                    
                                    <td>
                                        <?php if ($_smarty_tpl->tpl_vars['ds']->value['plan_expired']) {?>
                                            <a href="<?php echo Text::url('services/edit/');
echo $_smarty_tpl->tpl_vars['ds']->value['plan_expired'];?>
" class="text-success">
                                                <i class="glyphicon glyphicon-ok" style="color: var(--primary);"></i> <?php echo Lang::T('Yes');?>

                                            </a>
                                        <?php } else { ?>
                                            <span class="text-muted"><?php echo Lang::T('No');?>
</span>
                                        <?php }?>
                                    </td>
                                    <td><?php if ($_smarty_tpl->tpl_vars['ds']->value['prepaid'] == 'no') {
echo $_smarty_tpl->tpl_vars['ds']->value['expired_date'];
}?></td>
                                    <td><span class="badge" style="background: var(--primary-soft); color: var(--primary-dark);"><?php echo $_smarty_tpl->tpl_vars['ds']->value['id'];?>
</span></td>
                                    <td>
                                        <a href="<?php echo Text::url('services/edit/');
echo $_smarty_tpl->tpl_vars['ds']->value['id'];?>
" class="btn btn-info btn-xs">
                                            <i class="glyphicon glyphicon-pencil"></i> <?php echo Lang::T('Edit');?>

                                        </a>
                                        <a href="<?php echo Text::url('services/delete/');
echo $_smarty_tpl->tpl_vars['ds']->value['id'];?>
" id="<?php echo $_smarty_tpl->tpl_vars['ds']->value['id'];?>
"
                                            onclick="return ask(this, '<?php echo Lang::T('Delete');?>
?')"
                                            class="btn btn-danger btn-xs">
                                            <i class="glyphicon glyphicon-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            <?php
$_smarty_tpl->tpl_vars['ds'] = $__foreach_ds_5_saved;
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
                        </tbody>
                    </table>
                </div>
            </div>
           
        </div>
    </div>
</div>

<?php $_smarty_tpl->_subTemplateRender("file:sections/footer.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
}
}
