<?php
/* Smarty version 4.5.3, created on 2026-04-17 11:43:06
  from 'C:\Users\Administrator\Downloads\phpbilling sytem\ui\ui\admin\header.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.3',
  'unifunc' => 'content_69e1f29ac1c5e8_98337737',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '907bab933e2400c8d2b22fd3de3e1bf3685bb14c' => 
    array (
      0 => 'C:\\Users\\Administrator\\Downloads\\phpbilling sytem\\ui\\ui\\admin\\header.tpl',
      1 => 1776361565,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_69e1f29ac1c5e8_98337737 (Smarty_Internal_Template $_smarty_tpl) {
?><!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title><?php echo $_smarty_tpl->tpl_vars['_title']->value;?>
 - <?php echo $_smarty_tpl->tpl_vars['_c']->value['CompanyName'];?>
</title>
    <link rel="shortcut icon" href="<?php echo $_smarty_tpl->tpl_vars['app_url']->value;?>
/ui/ui/images/logo.png" type="image/x-icon" />

    <?php echo '<script'; ?>
>
        var appUrl = '<?php echo $_smarty_tpl->tpl_vars['app_url']->value;?>
';
    <?php echo '</script'; ?>
>

    <link rel="stylesheet" href="<?php echo $_smarty_tpl->tpl_vars['app_url']->value;?>
/ui/ui/styles/bootstrap.min.css">
    <link rel="stylesheet" href="<?php echo $_smarty_tpl->tpl_vars['app_url']->value;?>
/ui/ui/fonts/ionicons/css/ionicons.min.css">
    <!-- Replace Font Awesome with version 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<?php echo $_smarty_tpl->tpl_vars['app_url']->value;?>
/ui/ui/styles/modern-AdminLTE.min.css">
    <link rel="stylesheet" href="<?php echo $_smarty_tpl->tpl_vars['app_url']->value;?>
/ui/ui/styles/select2.min.css" />
    <link rel="stylesheet" href="<?php echo $_smarty_tpl->tpl_vars['app_url']->value;?>
/ui/ui/styles/select2-bootstrap.min.css" />
    <link rel="stylesheet" href="<?php echo $_smarty_tpl->tpl_vars['app_url']->value;?>
/ui/ui/styles/sweetalert2.min.css" />
    <link rel="stylesheet" href="<?php echo $_smarty_tpl->tpl_vars['app_url']->value;?>
/ui/ui/styles/plugins/pace.css" />
    <link rel="stylesheet" href="<?php echo $_smarty_tpl->tpl_vars['app_url']->value;?>
/ui/ui/summernote/summernote.min.css" />
    <link rel="stylesheet" href="<?php echo $_smarty_tpl->tpl_vars['app_url']->value;?>
/ui/ui/styles/allxsys.css?2025.2.4" />
    <link rel="stylesheet" href="<?php echo $_smarty_tpl->tpl_vars['app_url']->value;?>
/ui/ui/styles/7.css" />

    <?php echo '<script'; ?>
 src="<?php echo $_smarty_tpl->tpl_vars['app_url']->value;?>
/ui/ui/scripts/sweetalert2.all.min.js"><?php echo '</script'; ?>
>
    <?php echo '<script'; ?>
 src="https://cdn.jsdelivr.net/npm/chart.js@3.5.1/dist/chart.min.js"><?php echo '</script'; ?>
>
    <style>
    /* Main Background Color - Changed to light orange */
    body {
        background-color: #fff3e0; /* Light orange background */
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    /* Content Wrapper Background */
    .content-wrapper {
        background-color: #fff3e0; /* Light orange background */
        min-height: calc(100vh - 101px);
    }

    /* Main Content Area - Keep white for contrast */
    .content {
        background-color: #ffffff; /* White content area for readability */
        padding: 25px;
        border-radius: 12px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        margin-bottom: 25px;
        border: 1px solid #ffd8b8;
    }

    /* Sidebar improvements */
    .main-sidebar {
        background-color: #222d32;
        border-right: 1px solid #1a2226;
    }

    .sidebar {
        background-color: #222d32;
    }

    .sidebar-menu > li > a {
        border-left: 3px solid transparent;
        transition: all 0.3s ease;
    }

    .sidebar-menu > li.active > a,
    .sidebar-menu > li:hover > a {
        background-color: #1e282c;
        border-left-color: #ff6b35;
        color: #fff;
    }

    .sidebar-menu > li.active > a > i {
        color: #ff6b35;
    }

    /* Better icon spacing and styling */
    .sidebar-menu i {
        width: 20px;
        text-align: center;
        margin-right: 10px;
        font-size: 16px;
        transition: color 0.3s ease;
    }

    /* Active menu icon styling */
    .sidebar-menu > li.active > a > i,
    .treeview-menu > li.active > a > i {
        color: #ff6b35;
    }

    /* Treeview menu improvements */
    .treeview-menu {
        background-color: #1c2529;
    }

    .treeview-menu > li > a {
        padding-left: 45px;
        transition: all 0.3s ease;
    }

    .treeview-menu > li > a:hover {
        background-color: #1a2226;
        color: #ff6b35;
    }

    .treeview-menu > li.active > a {
        background-color: #1a2226;
        color: #ff6b35;
        font-weight: 600;
    }

    /* Make icons consistent size in treeview */
    .treeview-menu i {
        font-size: 14px;
        width: 18px;
    }

    /* Header improvements */
    .main-header {
        background: linear-gradient(135deg, #ff6b35 0%, #ff8e53 100%);
        border-bottom: 1px solid #e55a2d;
    }

    .logo {
        background-color: #e55a2d;
    }

    .logo:hover {
        background-color: #d45329;
    }

    .navbar-custom-menu .nav > li > a {
        color: white;
    }

    .navbar-custom-menu .nav > li > a:hover {
        background-color: rgba(255, 255, 255, 0.1);
    }

    /* User menu improvements */
    .user-menu .dropdown-menu i {
        margin-right: 8px;
        color: #555;
    }

    .user-header {
        background: linear-gradient(135deg, #ff6b35 0%, #ff8e53 100%);
    }

    /* Search icon improvement */
    #openSearch i {
        font-size: 18px;
        color: white;
    }

    /* Color code icons by category with orange theme */
    .fa-wifi, .fa-network-wired, .fa-server, .fa-shield, .fa-router, .fa-ethernet, .fa-plug {
        color: #ff6b35;
    }

    .fa-chart-line, .fa-history, .fa-clipboard, .fa-calendar-day {
        color: #ff9e53;
    }

    .fa-cogs, .fa-key, .fa-user-cog, .fa-gear, .fa-sliders-h, .fa-user-shield, .fa-database, .fa-credit-card, .fa-bell {
        color: #ff6b35;
    }

    .fa-users, .fa-user-check, .fa-user-plus, .fa-user {
        color: #ff8e53;
    }

    .fa-concierge-bell, .fa-ticket, .fa-credit-card, .fa-tags, .fa-redo, .fa-ticket-alt, .fa-battery-full, .fa-wallet {
        color: #ff9e53;
    }

    .fa-comments, .fa-envelope {
        color: #ffb074;
    }

    .fa-tachometer-alt {
        color: #ff6b35;
    }

    .fa-money-check-alt {
        color: #ff8e53;
    }

    .fa-code, .fa-server, .fa-envelope {
        color: #ff9e53;
    }

    .fa-tools, .fa-power-off {
        color: #ff6b35;
    }

    /* Better icon alignment in user dropdown */
    .user-body a i {
        margin-right: 8px;
        color: #ff6b35;
    }

    /* Logo icon improvement */
    .logo-mini b {
        color: white;
    }

    /* Content header improvements */
    .content-header {
        background: transparent;
        padding: 20px 20px 10px 20px;
    }

    .content-header h1 {
        color: #ff6b35;
        font-weight: 600;
        font-size: 24px;
    }

    .content-header h1 i {
        margin-right: 12px;
    }

    /* Footer improvements */
    .main-footer {
        background-color: #1e282c;
        border-top: 1px solid #1a2226;
        color: #b8c7ce;
        padding: 15px;
    }

    .main-footer strong {
        color: #ff8e53;
    }

    .main-footer .pull-right {
        color: #ffb074;
    }

    /* Button improvements */
    .btn-default {
        background-color: #f5f5f5;
        border-color: #ddd;
        color: #333;
    }

    .btn-default:hover {
        background-color: #e6e6e6;
        border-color: #adadad;
    }

    /* Notification bar */
    .notification-top-bar {
        background: linear-gradient(135deg, #ff9e53 0%, #ffb074 100%);
        color: white;
        padding: 10px 20px;
        text-align: center;
        border-bottom: 1px solid #ff8e53;
    }

    .notification-top-bar a {
        color: white;
        text-decoration: underline;
    }

    .notification-top-bar a:hover {
        color: #fff3e0;
    }

    /* Search overlay */
    .search-overlay {
        background-color: rgba(255, 107, 53, 0.95);
    }

    .search-container {
        background-color: white;
        border-radius: 8px;
        box-shadow: 0 5px 20px rgba(255, 107, 53, 0.3);
    }

    .searchTerm {
        border: 2px solid #ffd8b8;
    }

    .searchTerm:focus {
        border-color: #ff6b35;
        box-shadow: 0 0 0 0.2rem rgba(255, 107, 53, 0.25);
    }

    .cancelButton {
        background-color: #ff6b35;
        color: white;
    }

    .cancelButton:hover {
        background-color: #e55a2d;
    }
</style>
    <?php if ((isset($_smarty_tpl->tpl_vars['xheader']->value))) {?>
        <?php echo $_smarty_tpl->tpl_vars['xheader']->value;?>

    <?php }?>
</head>

<body class="hold-transition modern-skin-dark sidebar-mini <?php if ($_smarty_tpl->tpl_vars['_kolaps']->value) {?>sidebar-collapse<?php }?>">
    <div class="wrapper">
        <header class="main-header">
            <a href="<?php echo Text::url('dashboard');?>
" class="logo">
                <span class="logo-mini"><b>R</b>AY</span>
                <span class="logo-lg"><?php echo $_smarty_tpl->tpl_vars['_c']->value['CompanyName'];?>
</span>
            </a>
            <nav class="navbar navbar-static-top">
                <a href="#" class="sidebar-toggle" data-toggle="push-menu" role="button" onclick="return setKolaps()">
                    <span class="sr-only">Toggle navigation</span>
                    <i class="fas fa-bars"></i>
                </a>
                <div class="navbar-custom-menu">
                    <ul class="nav navbar-nav">
                        <div class="wrap">
                            <div class="">
                                <button id="openSearch" class="search"><i class="fas fa-search x2"></i></button>
                            </div>
                        </div>
                        <div id="searchOverlay" class="search-overlay">
                            <div class="search-container">
                                <input type="text" id="searchTerm" class="searchTerm"
                                    placeholder="<?php echo Lang::T('Search Users');?>
" autocomplete="off">
                                <div id="searchResults" class="search-results">
                                    <!-- Search results will be displayed here -->
                                </div>
                                <button type="button" id="closeSearch" class="cancelButton">
                                    <i class="fas fa-times"></i> <?php echo Lang::T('Cancel');?>

                                </button>
                            </div>
                        </div>
                        <li class="dropdown user user-menu">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                <img src="<?php echo $_smarty_tpl->tpl_vars['app_url']->value;?>
/<?php echo $_smarty_tpl->tpl_vars['UPLOAD_PATH']->value;
echo $_smarty_tpl->tpl_vars['_admin']->value['photo'];?>
.thumb.jpg"
                                    onerror="this.src='<?php echo $_smarty_tpl->tpl_vars['app_url']->value;?>
/<?php echo $_smarty_tpl->tpl_vars['UPLOAD_PATH']->value;?>
/admin.default.png'" class="user-image"
                                    alt="Avatar">
                                <span class="hidden-xs"><?php echo $_smarty_tpl->tpl_vars['_admin']->value['fullname'];?>
</span>
                            </a>
                            <ul class="dropdown-menu">
                                <li class="user-header">
                                    <img src="<?php echo $_smarty_tpl->tpl_vars['app_url']->value;?>
/<?php echo $_smarty_tpl->tpl_vars['UPLOAD_PATH']->value;
echo $_smarty_tpl->tpl_vars['_admin']->value['photo'];?>
.thumb.jpg"
                                        onerror="this.src='<?php echo $_smarty_tpl->tpl_vars['app_url']->value;?>
/<?php echo $_smarty_tpl->tpl_vars['UPLOAD_PATH']->value;?>
/admin.default.png'" class="img-circle"
                                        alt="Avatar">
                                    <p>
                                        <?php echo $_smarty_tpl->tpl_vars['_admin']->value['fullname'];?>

                                        <small><?php echo Lang::T($_smarty_tpl->tpl_vars['_admin']->value['user_type']);?>
</small>
                                    </p>
                                </li>
                                <li class="user-body">
                                    <div class="row">
                                        <div class="col-xs-7 text-center text-sm">
                                            <a href="<?php echo Text::url('settings/change-password');?>
">
                                                <i class="fas fa-key"></i>
                                                <?php echo Lang::T('Change Password');?>

                                            </a>
                                        </div>
                                        <div class="col-xs-5 text-center text-sm">
                                            <a href="<?php echo Text::url('settings/users-view/',$_smarty_tpl->tpl_vars['_admin']->value['id']);?>
">
                                                <i class="fas fa-user-cog"></i> <?php echo Lang::T('My Account');?>

                                            </a>
                                        </div>
                                    </div>
                                </li>
                                <li class="user-footer">
                                    <div class="pull-right">
                                        <a href="<?php echo Text::url('logout');?>
" class="btn btn-default btn-flat">
                                            <i class="fas fa-sign-out-alt"></i> <?php echo Lang::T('Logout');?>

                                        </a>
                                    </div>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </nav>
        </header>
        <aside class="main-sidebar">
            <section class="sidebar">
                <ul class="sidebar-menu" data-widget="tree">
                    <li <?php if ($_smarty_tpl->tpl_vars['_system_menu']->value == 'dashboard') {?>class="active" <?php }?>>
                        <a href="<?php echo Text::url('dashboard');?>
">
                            <i class="fas fa-tachometer-alt"></i>
                            <span><?php echo Lang::T('Dashboard');?>
</span>
                        </a>
                    </li>
                    <?php echo $_smarty_tpl->tpl_vars['_MENU_AFTER_DASHBOARD']->value;?>

                    <li <?php if ($_smarty_tpl->tpl_vars['_system_menu']->value == 'customers') {?>class="active" <?php }?>>
                        <a href="<?php echo Text::url('customers');?>
">
                            <i class="fas fa-users"></i>
                            <span><?php echo Lang::T('Clients');?>
</span>
                        </a>
                    </li>
                    <?php echo $_smarty_tpl->tpl_vars['_MENU_AFTER_CUSTOMERS']->value;?>

                    <?php if (!in_array($_smarty_tpl->tpl_vars['_admin']->value['user_type'],array('Report'))) {?>
                        <li class="<?php if ($_smarty_tpl->tpl_vars['_routes']->value[0] == 'plan' || $_smarty_tpl->tpl_vars['_routes']->value[0] == 'coupons') {?>active<?php }?> treeview">
                            <a href="#">
                                <i class="fas fa-concierge-bell"></i> <span><?php echo Lang::T('Services');?>
</span>
                                <span class="pull-right-container">
                                    <i class="fas fa-angle-left pull-right"></i>
                                </span>
                            </a>
                            <ul class="treeview-menu">
                                <li <?php if ($_smarty_tpl->tpl_vars['_routes']->value[1] == 'list') {?>class="active" <?php }?>>
                                    <a href="<?php echo Text::url('plan/list');?>
">
                                        <i class="fas fa-user-check"></i> <?php echo Lang::T('Active Clients');?>

                                    </a>
                                </li>
                                <?php if ($_smarty_tpl->tpl_vars['_c']->value['disable_voucher'] != 'yes') {?>
                                    <li <?php if ($_smarty_tpl->tpl_vars['_routes']->value[1] == 'refill') {?>class="active" <?php }?>>
                                        <a href="<?php echo Text::url('plan/refill');?>
">
                                            <i class="fas fa-redo"></i> <?php echo Lang::T('Refill Client');?>

                                        </a>
                                    </li>
                                <?php }?>
                                <?php if ($_smarty_tpl->tpl_vars['_c']->value['disable_voucher'] != 'yes') {?>
                                    <li <?php if ($_smarty_tpl->tpl_vars['_routes']->value[1] == 'voucher') {?>class="active" <?php }?>>
                                        <a href="<?php echo Text::url('plan/voucher');?>
">
                                            <i class="fas fa-ticket-alt"></i> <?php echo Lang::T('Vouchers');?>

                                        </a>
                                    </li>
                                <?php }?>
                                <?php if ($_smarty_tpl->tpl_vars['_c']->value['enable_coupons'] == 'yes') {?>
                                    <li <?php if ($_smarty_tpl->tpl_vars['_routes']->value[0] == 'coupons') {?>class="active" <?php }?>>
                                        <a href="<?php echo Text::url('coupons');?>
">
                                            <i class="fas fa-tags"></i> <?php echo Lang::T('Coupons');?>

                                        </a>
                                    </li>
                                <?php }?>
                                <li <?php if ($_smarty_tpl->tpl_vars['_routes']->value[1] == 'recharge') {?>class="active" <?php }?>>
                                    <a href="<?php echo Text::url('plan/recharge');?>
">
                                        <i class="fas fa-battery-full"></i> <?php echo Lang::T('Recharge Client');?>

                                    </a>
                                </li>
                                <?php if ($_smarty_tpl->tpl_vars['_c']->value['enable_balance'] == 'yes') {?>
                                    <li <?php if ($_smarty_tpl->tpl_vars['_routes']->value[1] == 'deposit') {?>class="active" <?php }?>>
                                        <a href="<?php echo Text::url('plan/deposit');?>
">
                                            <i class="fas fa-wallet"></i> <?php echo Lang::T('Refill Balance');?>

                                        </a>
                                    </li>
                                <?php }?>
                                <?php echo $_smarty_tpl->tpl_vars['_MENU_SERVICES']->value;?>

                            </ul>
                        </li>
                    <?php }?>
                    <?php echo $_smarty_tpl->tpl_vars['_MENU_AFTER_SERVICES']->value;?>

                    <?php echo $_smarty_tpl->tpl_vars['_MENU_AFTER_customer_usage']->value;?>

                    <?php if (in_array($_smarty_tpl->tpl_vars['_admin']->value['user_type'],array('SuperAdmin','Admin'))) {?>
                        <li class="<?php if ($_smarty_tpl->tpl_vars['_system_menu']->value == 'services') {?>active<?php }?> treeview">
                            <a href="#">
                                <i class="fas fa-wifi"></i> <span><?php echo Lang::T('Internet Plans');?>
</span>
                                <span class="pull-right-container">
                                    <i class="fas fa-angle-left pull-right"></i>
                                </span>
                            </a>
                            <ul class="treeview-menu">
                                <li <?php if ($_smarty_tpl->tpl_vars['_routes']->value[1] == 'hotspot') {?>class="active" <?php }?>>
                                    <a href="<?php echo Text::url('services/hotspot');?>
">
                                        <i class="fas fa-hotdog"></i> Hotspot
                                    </a>
                                </li>
                                <li <?php if ($_smarty_tpl->tpl_vars['_routes']->value[1] == 'pppoe') {?>class="active" <?php }?>>
                                    <a href="<?php echo Text::url('services/pppoe');?>
">
                                        <i class="fas fa-ethernet"></i> PPPOE
                                    </a>
                                </li>
                                <li <?php if ($_smarty_tpl->tpl_vars['_routes']->value[1] == 'list') {?>class="active" <?php }?>>
                                    <a href="<?php echo Text::url('bandwidth/list');?>
">
                                        <i class="fas fa-tachometer-alt"></i> Bandwidth
                                    </a>
                                </li>
                                <?php if ($_smarty_tpl->tpl_vars['_c']->value['enable_balance'] == 'yes') {?>
                                    <li <?php if ($_smarty_tpl->tpl_vars['_routes']->value[1] == 'balance') {?>class="active" <?php }?>>
                                        <a href="<?php echo Text::url('services/balance');?>
">
                                            <i class="fas fa-balance-scale"></i> <?php echo Lang::T('Customer Balance');?>

                                        </a>
                                    </li>
                                <?php }?>
                                <?php echo $_smarty_tpl->tpl_vars['_MENU_PLANS']->value;?>

                            </ul>
                        </li>
                    <?php }?>
                    <?php echo $_smarty_tpl->tpl_vars['_MENU_AFTER_PLANS']->value;?>

                    <li class="<?php if ($_smarty_tpl->tpl_vars['_system_menu']->value == 'reports') {?>active<?php }?> treeview">
                        <?php if (in_array($_smarty_tpl->tpl_vars['_admin']->value['user_type'],array('SuperAdmin','Admin','Report'))) {?>
                            <a href="#">
                                <i class="fas fa-chart-line"></i> <span><?php echo Lang::T('Reports');?>
</span>
                                <span class="pull-right-container">
                                    <i class="fas fa-angle-left pull-right"></i>
                                </span>
                            </a>
                        <?php }?>
                        <ul class="treeview-menu">
                            <li <?php if ($_smarty_tpl->tpl_vars['_routes']->value[1] == 'today') {?>class="active" <?php }?>>
                                <a href="<?php echo Text::url('reports/today');?>
">
                                    <i class="fas fa-calendar-day text-green"></i> <?php echo Lang::T('Daily reports');?>

                                </a>
                            </li>
                           
                            <li <?php if ($_smarty_tpl->tpl_vars['_routes']->value[1] == 'activation') {?>class="active" <?php }?>>
                                <a href="<?php echo Text::url('reports/by-period');?>
">
                                    <i class="fas fa-history"></i> <?php echo Lang::T('Period reports');?>

                                </a>
                            </li>
                            <?php echo $_smarty_tpl->tpl_vars['_MENU_REPORTS']->value;?>

                        </ul>
                    </li>
                    <?php echo $_smarty_tpl->tpl_vars['_MENU_AFTER_REPORTS']->value;?>

                    <li <?php if ($_smarty_tpl->tpl_vars['_system_menu']->value == 'transactions') {?>class="active" <?php }?>>
                        <a href="<?php echo Text::url('transactions');?>
">
                            <i class="fas fa-money-check-alt"></i>
                            <span>Payment Transactions</span>
                        </a>
                    </li>
                    <li class="<?php if ($_smarty_tpl->tpl_vars['_system_menu']->value == 'message') {?>active<?php }?> treeview">
                        <a href="#">
                            <i class="fas fa-comments"></i> <span><?php echo Lang::T('Send Message');?>
</span>
                            <span class="pull-right-container">
                                <i class="fas fa-angle-left pull-right"></i>
                            </span>
                        </a>
                        <ul class="treeview-menu">
                            <li <?php if ($_smarty_tpl->tpl_vars['_routes']->value[1] == 'send') {?>class="active" <?php }?>>
                                <a href="<?php echo Text::url('message/send');?>
">
                                    <i class="fas fa-user"></i> <?php echo Lang::T('Single Client');?>

                                </a>
                            </li>
                            <li <?php if ($_smarty_tpl->tpl_vars['_routes']->value[1] == 'send_bulk') {?>class="active" <?php }?>>
                                <a href="<?php echo Text::url('message/send_bulk');?>
">
                                    <i class="fas fa-users"></i> <?php echo Lang::T('Bulk Clients');?>

                                </a>
                            </li>
                            <?php echo $_smarty_tpl->tpl_vars['_MENU_MESSAGE']->value;?>

                        </ul>
                    </li>
                    <?php echo $_smarty_tpl->tpl_vars['_MENU_AFTER_MESSAGE']->value;?>

                    <?php if (in_array($_smarty_tpl->tpl_vars['_admin']->value['user_type'],array('SuperAdmin','Admin'))) {?>
                        <li class="<?php if ($_smarty_tpl->tpl_vars['_system_menu']->value == 'network') {?>active<?php }?> treeview">
                            <a href="#">
                                <i class="fas fa-network-wired"></i> <span><?php echo Lang::T('Network');?>
</span>
                                <span class="pull-right-container">
                                    <i class="fas fa-angle-left pull-right"></i>
                                </span>
                            </a>
                            <ul class="treeview-menu">
                                <li <?php if ($_smarty_tpl->tpl_vars['_routes']->value[0] == 'routers' && $_smarty_tpl->tpl_vars['_routes']->value[1] == '') {?>class="active" <?php }?>>
                                    <a href="<?php echo Text::url('routers');?>
">
                                        <i class="fas fa-router"></i> Routers
                                    </a>
                                </li>
                                <li <?php if ($_smarty_tpl->tpl_vars['_routes']->value[0] == 'pool' && $_smarty_tpl->tpl_vars['_routes']->value[1] == 'list') {?>class="active" <?php }?>>
                                    <a href="<?php echo Text::url('pool/list');?>
">
                                        <i class="fas fa-list-ol"></i> IP Pool
                                    </a>
                                </li>
                                <?php echo $_smarty_tpl->tpl_vars['_MENU_NETWORK']->value;?>

                            </ul>
                        </li>
                        <?php echo $_smarty_tpl->tpl_vars['_MENU_AFTER_NETWORKS']->value;?>

                        <?php if ($_smarty_tpl->tpl_vars['_c']->value['radius_enable']) {?>
                            <li class="<?php if ($_smarty_tpl->tpl_vars['_system_menu']->value == 'radius') {?>active<?php }?> treeview">
                                <a href="#">
                                    <i class="fas fa-server"></i> <span><?php echo Lang::T('Radius');?>
</span>
                                    <span class="pull-right-container">
                                        <i class="fas fa-angle-left pull-right"></i>
                                    </span>
                                </a>
                                <ul class="treeview-menu">
                                    <li <?php if ($_smarty_tpl->tpl_vars['_routes']->value[0] == 'radius' && $_smarty_tpl->tpl_vars['_routes']->value[1] == 'nas-list') {?>class="active" <?php }?>>
                                        <a href="<?php echo Text::url('radius/nas-list');?>
">
                                            <i class="fas fa-database"></i> <?php echo Lang::T('Radius NAS');?>

                                        </a>
                                    </li>
                                    <?php echo $_smarty_tpl->tpl_vars['_MENU_RADIUS']->value;?>

                                </ul>
                            </li>
                        <?php }?>
                        <?php echo $_smarty_tpl->tpl_vars['_MENU_AFTER_RADIUS']->value;?>

                    <?php }?>
                    <?php echo $_smarty_tpl->tpl_vars['_MENU_AFTER_PAGES']->value;?>

                    <li class="<?php if ($_smarty_tpl->tpl_vars['_system_menu']->value == 'settings' || $_smarty_tpl->tpl_vars['_system_menu']->value == 'paymentgateway') {?>active<?php }?> treeview">
                        <a href="#">
                            <i class="fas fa-cogs"></i> <span><?php echo Lang::T('Settings');?>
</span>
                            <span class="pull-right-container">
                                <i class="fas fa-angle-left pull-right"></i>
                            </span>
                        </a>
                        <ul class="treeview-menu">
                            <?php if (in_array($_smarty_tpl->tpl_vars['_admin']->value['user_type'],array('SuperAdmin','Admin'))) {?>
                                <li <?php if ($_smarty_tpl->tpl_vars['_routes']->value[1] == 'app') {?>class="active" <?php }?>>
                                    <a href="<?php echo Text::url('settings/app');?>
">
                                        <i class="fas fa-sliders-h"></i> <?php echo Lang::T('General Settings');?>

                                    </a>
                                </li>
                                <li <?php if ($_smarty_tpl->tpl_vars['_routes']->value[1] == 'notifications') {?>class="active" <?php }?>>
                                    <a href="<?php echo Text::url('settings/notifications');?>
">
                                        <i class="fas fa-bell"></i> <?php echo Lang::T('User Notification');?>

                                    </a>
                                </li>
                            <?php }?>
                            <?php if (in_array($_smarty_tpl->tpl_vars['_admin']->value['user_type'],array('SuperAdmin','Admin','Agent'))) {?>
                                <li <?php if ($_smarty_tpl->tpl_vars['_routes']->value[1] == 'users') {?>class="active" <?php }?>>
                                    <a href="<?php echo Text::url('settings/users');?>
">
                                        <i class="fas fa-user-shield"></i> <?php echo Lang::T('Administrator Users');?>

                                    </a>
                                </li>
                            <?php }?>
                            <?php if (in_array($_smarty_tpl->tpl_vars['_admin']->value['user_type'],array('SuperAdmin','Admin'))) {?>
                                <li <?php if ($_smarty_tpl->tpl_vars['_routes']->value[1] == 'dbstatus') {?>class="active" <?php }?>>
                                    <a href="<?php echo Text::url('settings/dbstatus');?>
">
                                        <i class="fas fa-database"></i> <?php echo Lang::T('Backup/Restore');?>

                                    </a>
                                </li>
                                <li <?php if ($_smarty_tpl->tpl_vars['_system_menu']->value == 'paymentgateway') {?>class="active" <?php }?>>
                                    <a href="<?php echo Text::url('paymentgateway');?>
">
                                        <i class="fas fa-credit-card"></i> <span class="text"><?php echo Lang::T('Payment Gateway');?>
</span>
                                    </a>
                                </li>
                                <?php echo $_smarty_tpl->tpl_vars['_MENU_SETTINGS']->value;?>

                            <?php }?>
                        </ul>
                    </li>
                    <?php echo $_smarty_tpl->tpl_vars['_MENU_AFTER_SETTINGS']->value;?>

                    <?php if (in_array($_smarty_tpl->tpl_vars['_admin']->value['user_type'],array('SuperAdmin','Admin'))) {?>
                        <li class="<?php if ($_smarty_tpl->tpl_vars['_system_menu']->value == 'logs') {?>active<?php }?> treeview">
                            <a href="#">
                                <i class="fas fa-history"></i> <span><?php echo Lang::T('Logs');?>
</span>
                                <span class="pull-right-container">
                                    <i class="fas fa-angle-left pull-right"></i>
                                </span>
                            </a>
                            <ul class="treeview-menu">
                                <li <?php if ($_smarty_tpl->tpl_vars['_routes']->value[1] == 'list') {?>class="active" <?php }?>>
                                    <a href="<?php echo Text::url('logs/allxsys');?>
">
                                        <i class="fas fa-code"></i> RAYPROTECH
                                    </a>
                                </li>
                                <?php if ($_smarty_tpl->tpl_vars['_c']->value['radius_enable']) {?>
                                    <li <?php if ($_smarty_tpl->tpl_vars['_routes']->value[1] == 'radius') {?>class="active" <?php }?>>
                                        <a href="<?php echo Text::url('logs/radius');?>
">
                                            <i class="fas fa-server"></i> Radius
                                        </a>
                                    </li>
                                <?php }?>
                            </ul>
                        </li>
                    <?php }?>
                    <?php echo $_smarty_tpl->tpl_vars['_MENU_AFTER_LOGS']->value;?>

                    <?php echo $_smarty_tpl->tpl_vars['_MENU_AFTER_COMMUNITY']->value;?>

                </ul>
            </section>
        </aside>

        <?php if ($_smarty_tpl->tpl_vars['_c']->value['maintenance_mode'] == 1) {?>
            <div class="notification-top-bar">
                <p>
                    <i class="fas fa-tools"></i> <?php echo Lang::T('The website is currently in maintenance mode, this means that some or all functionality may be unavailable to regular users during this time.');?>

                    <small> &nbsp;&nbsp;
                        <a href="<?php echo Text::url('settings/maintenance');?>
">
                            <i class="fas fa-power-off"></i> <?php echo Lang::T('Turn Off');?>

                        </a>
                    </small>
                </p>
            </div>
        <?php }?>

        <div class="content-wrapper">
            <section class="content-header">
                <h1>
                    <i class="fas fa-<?php if (strpos($_smarty_tpl->tpl_vars['_title']->value,'Dashboard') !== false) {?>tachometer-alt<?php } elseif (strpos($_smarty_tpl->tpl_vars['_title']->value,'Customer') !== false) {?>users<?php } elseif (strpos($_smarty_tpl->tpl_vars['_title']->value,'Report') !== false) {?>chart-line<?php } elseif (strpos($_smarty_tpl->tpl_vars['_title']->value,'Settings') !== false) {?>cogs<?php } else { ?>file<?php }?>"></i>
                    <?php echo $_smarty_tpl->tpl_vars['_title']->value;?>

                </h1>
            </section>

            <section class="content">
                <?php if ((isset($_smarty_tpl->tpl_vars['notify']->value))) {?>
                    <?php echo '<script'; ?>
>
                        // Display SweetAlert toast notification
                        Swal.fire({
                            icon: '<?php if ($_smarty_tpl->tpl_vars['notify_t']->value == "s") {?>success<?php } else { ?>error<?php }?>',
                            title: '<?php echo $_smarty_tpl->tpl_vars['notify']->value;?>
',
                            position: 'top-end',
                            showConfirmButton: false,
                            timer: 5000,
                            timerProgressBar: true,
                            didOpen: (toast) => {
                                toast.addEventListener('mouseenter', Swal.stopTimer)
                                toast.addEventListener('mouseleave', Swal.resumeTimer)
                            }
                        });
                    <?php echo '</script'; ?>
>
                <?php }
}
}
