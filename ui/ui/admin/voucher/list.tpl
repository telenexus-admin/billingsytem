{include file="sections/header.tpl"}

<style>
    :root {
        --primary: #f97316;
        --primary-dark: #ea580c;
        --primary-light: #fed7aa;
        --primary-soft: #fff7ed;
    }

    /* Mobile Responsive Styles */
    @media (max-width: 768px) {
        /* Make modal responsive */
        .modal-dialog {
            width: 95% !important;
            max-width: none !important;
            margin: 10px auto !important;
        }
        
        /* Stack voucher details and SMS vertically on mobile */
        #voucher-content .row {
            display: flex;
            flex-direction: column;
        }
        
        #voucher-content .col-md-9,
        #voucher-content .col-md-3 {
            width: 100% !important;
            float: none !important;
        }
        
        /* Reduce padding and font sizes for mobile */
        .modal-body {
            padding: 10px !important;
        }
        
        .panel-body {
            padding: 10px !important;
        }
        
        #voucher-print-content {
            font-size: 10px !important;
            padding: 10px !important;
            max-height: 200px !important;
        }
        
        /* Make buttons and inputs more touch-friendly */
        .btn {
            min-height: 44px;
        }
        
        .form-control {
            min-height: 44px;
        }
        
        /* Reduce table font size */
        .table {
            font-size: 12px;
        }
        
        .table th, .table td {
            padding: 4px !important;
        }
        
        /* Make filters more compact */
        .form-control, .input-group-addon {
            font-size: 12px;
        }
        
        /* Reduce panel title sizes */
        .panel-title {
            font-size: 14px !important;
        }
        
        h4.panel-title {
            font-size: 14px !important;
        }
        
        /* Keep tabs side by side on mobile */
        #voucherTabs {
            display: flex !important;
            flex-wrap: nowrap !important;
        }
        
        #voucherTabs li {
            flex: 1 !important;
            text-align: center !important;
        }
        
        #voucherTabs li a {
            padding: 8px 4px !important;
            font-size: 12px !important;
            white-space: nowrap !important;
        }
        
        /* Fix action buttons to be consistent and side by side */
        .table .btn {
            min-height: 28px !important;
            padding: 2px 6px !important;
            font-size: 10px !important;
            margin: 1px !important;
        }
        
        .table .btn-xs {
            min-height: 24px !important;
            padding: 1px 4px !important;
            font-size: 9px !important;
        }
        
        /* Make sure buttons stay side by side */
        .table td:last-child {
            white-space: nowrap !important;
        }
        
        /* Fix delete selected button */
        .row .btn-danger {
            font-size: 12px !important;
            padding: 6px 12px !important;
        }
        
        /* Fix delete button in panel header */
        .panel-heading .btn-group {
            margin-top: -5px !important;
        }
        
        .panel-heading .btn-xs {
            font-size: 11px !important;
            padding: 8px 12px !important;
            white-space: nowrap !important;
            min-height: 36px !important;
            line-height: 1.2 !important;
            border-radius: 4px !important;
        }
        
        /* Specific mobile styling for header buttons */
        .panel-heading .btn-group .btn {
            margin: 2px !important;
        }
        
        /* Make panel title more responsive */
        .panel-title {
            flex-direction: column !important;
            align-items: stretch !important;
        }
        
        .panel-title > div:first-child {
            margin-bottom: 8px !important;
        }
        
        .panel-title .btn-group {
            margin-left: 0 !important;
            width: 100% !important;
        }
        
        .panel-title .btn-group .btn {
            flex: 1 !important;
        }
        
        /* Hide mobile text on large screens */
        .delete-btn-mobile {
            display: none !important;
        }
        
        /* Show mobile text on small screens */
        @media (max-width: 767px) {
            .delete-btn-desktop {
                display: none !important;
            }
            
            .delete-btn-mobile {
                display: inline !important;
            }
        }
        
        /* Mobile filter layout: search + one dropdown, then two dropdowns, then buttons */
        @media (max-width: 767px) {
            .mobile-filter-row1 .col-lg-2:nth-child(1),
            .mobile-filter-row1 .col-lg-2:nth-child(2) {
                width: 50% !important;
                float: left !important;
            }
            
            .mobile-filter-row1 .col-lg-2:nth-child(3),
            .mobile-filter-row1 .col-lg-2:nth-child(4),
            .mobile-filter-row1 .col-lg-2:nth-child(5) {
                display: none !important;
            }
            
            .mobile-filter-row2,
            .mobile-filter-row3 {
                display: block !important;
                margin-top: 5px !important;
            }
            
            .mobile-filter-row2 > div,
            .mobile-filter-row3 > div {
                width: 50% !important;
                float: left !important;
                padding-left: 2px !important;
                padding-right: 2px !important;
            }
            
            .mobile-filter-row3 > div:first-child {
                width: 100% !important;
            }
        }
        
        @media (min-width: 768px) {
            .mobile-filter-row2,
            .mobile-filter-row3 {
                display: none !important;
            }
        }
    }
    
    /* Panel Styling */
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
    
    .panel-body {
        background: white;
    }
    
    .panel-title {
        color: white;
        font-weight: 600;
    }
    
    .btn-primary {
        background: linear-gradient(145deg, var(--primary), var(--primary-dark));
        border: none;
        color: white;
        border-radius: 8px;
        padding: 6px 12px;
        transition: all 0.2s;
    }
    
    .btn-primary:hover {
        background: linear-gradient(145deg, var(--primary-dark), #c2410c);
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(249, 115, 22, 0.3);
    }
    
    .btn-success {
        background: linear-gradient(145deg, var(--primary), var(--primary-dark));
        border: none;
        color: white;
        border-radius: 8px;
        transition: all 0.2s;
    }
    
    .btn-success:hover {
        background: linear-gradient(145deg, var(--primary-dark), #c2410c);
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(249, 115, 22, 0.3);
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
    
    .btn-warning {
        background: var(--primary-light);
        border: 1px solid var(--primary);
        color: var(--primary-dark);
        border-radius: 8px;
    }
    
    .btn-warning:hover {
        background: var(--primary);
        color: white;
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
    
    /* Voucher Tab Styling */
    #voucherTabs {
        border-bottom: 2px solid var(--primary-light);
        margin-bottom: 15px;
    }
    
    #voucherTabs li a {
        color: #1e293b;
        border: none;
        border-radius: 0;
        padding: 12px 20px;
        font-weight: 500;
        transition: all 0.3s ease;
    }
    
    #voucherTabs li.active a {
        color: var(--primary);
        border-bottom: 3px solid var(--primary);
        background: transparent;
        font-weight: 600;
    }
    
    #voucherTabs li a:hover {
        background: var(--primary-soft);
        border-color: transparent;
    }
    
    .badge-success {
        background-color: var(--primary);
    }
    
    .badge-danger {
        background-color: #ef4444;
    }
    
    /* Table styling */
    .table {
        border-radius: 12px;
        overflow: hidden;
    }
    
    .table thead tr {
        background: var(--primary-soft);
        color: var(--primary-dark);
        font-weight: 600;
    }
    
    .table thead th {
        border-bottom: 2px solid var(--primary-light);
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
    
    /* Form controls */
    .form-control {
        border: 2px solid #e2e8f0;
        border-radius: 12px;
        padding: 8px 12px;
        transition: all 0.2s;
    }
    
    .form-control:focus {
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(249, 115, 22, 0.1);
    }
    
    .input-group-addon {
        background: var(--primary-soft);
        border: 2px solid #e2e8f0;
        border-right: none;
        color: var(--primary);
        font-weight: 500;
    }
    
    /* Voucher code visibility styles */
    .voucher-code-hidden {
        background-color: #1e293b !important;
        color: #1e293b !important;
        transition: all 0.3s ease;
    }
    
    .voucher-code-visible {
        background-color: white !important;
        color: var(--primary-dark) !important;
        font-weight: bold !important;
        border: 1px solid var(--primary-light) !important;
        transition: all 0.3s ease;
    }
    
    .voucher-code-hidden:hover {
        background-color: var(--primary-soft) !important;
        color: var(--primary-dark) !important;
    }
    
    /* Toggle button styling */
    #toggle-voucher-codes {
        transition: all 0.3s ease;
        background: var(--primary-soft);
        border: 1px solid var(--primary);
        color: var(--primary-dark);
    }
    
    #toggle-voucher-codes:hover {
        transform: translateY(-1px);
        box-shadow: 0 2px 4px rgba(249, 115, 22, 0.3);
        background: var(--primary);
        color: white;
    }
    
    /* Voucher panel header responsive layout */
    .voucher-panel-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
    }
    
    .header-text {
        flex: 1;
        min-width: 200px;
        color: white;
    }
    
    .header-buttons {
        display: flex;
        gap: 8px;
        flex-wrap: nowrap;
    }
    
    .header-btn {
        white-space: nowrap;
        font-size: 12px;
        padding: 6px 10px;
        min-height: 32px;
        line-height: 1.3;
    }
    
    /* Modal Styling */
    .modal-content {
        border-radius: 16px;
        border: none;
        box-shadow: 0 20px 40px rgba(249, 115, 22, 0.2);
    }
    
    .modal-header {
        background: linear-gradient(145deg, var(--primary), var(--primary-dark));
        color: white;
        border-radius: 16px 16px 0 0;
        padding: 15px 20px;
    }
    
    .modal-header .close {
        color: white;
        opacity: 0.8;
    }
    
    .modal-header .close:hover {
        opacity: 1;
    }
    
    .modal-title {
        font-weight: 600;
    }
    
    .modal-footer {
        border-top: 2px solid var(--primary-light);
        padding: 15px 20px;
    }
    
    .modal-footer .btn-default {
        background: var(--primary-soft);
        border: 1px solid var(--primary-light);
        color: var(--primary-dark);
        border-radius: 30px;
    }
    
    #voucher-print-content {
        background: var(--primary-soft) !important;
        border: 2px solid var(--primary-light) !important;
        border-radius: 12px !important;
        color: #1e293b !important;
    }
    
    /* Alert styling */
    .alert-info {
        background: var(--primary-soft);
        border-left: 4px solid var(--primary);
        color: #1e293b;
        border-radius: 12px;
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
    
    /* Badge styling */
    .btn-tag {
        display: inline-block;
        padding: 4px 8px;
        border-radius: 20px;
        font-size: 11px;
        font-weight: 600;
    }
    
    .btn-tag-success {
        background: var(--primary-soft);
        color: var(--primary-dark);
        border: 1px solid var(--primary-light);
    }
    
    .btn-tag-danger {
        background: #fff1f0;
        color: #ef4444;
        border: 1px solid #fecaca;
    }
    
    /* SMS Input Validation Styles */
    .valid-input {
        border-color: #22c55e !important;
        background-color: #f0fff4 !important;
    }
    
    .invalid-input {
        border-color: #ef4444 !important;
        background-color: #fff5f5 !important;
    }
</style>

<!-- voucher -->
<div class="row" style="padding: 5px">
    <div class="col-lg-3 col-lg-offset-9">
        <div class="btn-group btn-group-justified" role="group">
            {if in_array($_admin['user_type'],['SuperAdmin','Admin'])}
                <div class="btn-group" role="group">
                    <a href="{Text::url('')}plan/add-voucher" class="btn btn-primary"><i class="ion ion-android-add"></i>
                        {Lang::T('Create Voucher')}</a>
                </div>
            {/if}
            {if !in_array($_admin['user_type'],['SuperAdmin','Admin'])}
                <div class="btn-group" role="group">
                    <a href="{Text::url('')}plan/refill" class="btn btn-success"><i class="ion ion-android-share"></i>
                        {Lang::T('Distribute Voucher')}</a>
                </div>
            {/if}
        </div>
    </div>
</div>
<div class="panel panel-hovered mb20 panel-primary">
    <div class="panel-heading">
        <div class="panel-title voucher-panel-header">
            <div class="header-text">
                <i class="glyphicon glyphicon-tags" style="margin-right: 8px;"></i>
                {Lang::T('Voucher Management')}
                {if !in_array($_admin['user_type'],['SuperAdmin','Admin'])}
                    <small style="color: var(--primary-light);"> ({$_admin['user_type']} - {Lang::T('View & Distribute Only')})</small>
                {/if}
            </div>
            <div class="header-buttons">
                <button class="btn btn-info btn-xs header-btn" id="toggle-voucher-codes" title="Show/Hide all voucher codes">
                    <span class="glyphicon glyphicon-eye-open" aria-hidden="true" id="toggle-icon"></span> 
                    <span id="toggle-text">{Lang::T('Show All Codes')}</span>
                </button>
                {if in_array($_admin['user_type'],['SuperAdmin','Admin'])}
                    <a class="btn btn-danger btn-xs header-btn" title="{Lang::T('Remove used Voucher')}" href="{Text::url('')}plan/remove-voucher"
                        onclick="return ask(this, '{Lang::T('Delete all used voucher code more than 1 month?')}')">
                        <span class="glyphicon glyphicon-trash" aria-hidden="true"></span> {Lang::T('Delete')} &gt; 
                        <span class="delete-btn-desktop">1 {Lang::T('Months')}</span>
                        <span class="delete-btn-mobile">1M</span>
                    </a>
                {/if}
            </div>
        </div>
    </div>
    
    <!-- Voucher Status Tabs -->
    <div class="panel-body" style="padding-bottom: 0;">
        <ul class="nav nav-tabs" id="voucherTabs" role="tablist">
            <li role="presentation" class="active">
                <a href="#not-used-vouchers" aria-controls="not-used-vouchers" role="tab" data-toggle="tab" onclick="showVoucherTab('not-used')">
                    <i class="fa fa-clock-o" style="color: var(--primary);"></i> {Lang::T('Not Used Vouchers')} 
                    <span class="badge badge-success" id="not-used-count" style="background: var(--primary);">0</span>
                </a>
            </li>
            <li role="presentation">
                <a href="#used-vouchers" aria-controls="used-vouchers" role="tab" data-toggle="tab" onclick="showVoucherTab('used')">
                    <i class="fa fa-check-circle" style="color: #ef4444;"></i> {Lang::T('Used Vouchers')} 
                    <span class="badge badge-danger" id="used-count">0</span>
                </a>
            </li>
        </ul>
    </div>
    <div class="panel-body">
        <!-- Tab Content -->
        <div class="tab-content" id="voucherTabContent">
            <!-- Not Used Vouchers Tab -->
            <div role="tabpanel" class="tab-pane active" id="not-used-vouchers">
                <form id="site-search" method="post" action="{Text::url('')}plan/voucher/">
                    <input type="hidden" name="status" value="0" id="search-status">
                    <div class="row mobile-filter-row1" style="padding: 5px">
                        <div class="col-lg-2">
                            <div class="input-group">
                                <div class="input-group-addon" style="background: var(--primary-soft); color: var(--primary);">
                                    <span class="fa fa-search"></span>
                                </div>
                                <input type="text" name="search" class="form-control" placeholder="{Lang::T('Code Voucher')}"
                                    value="{$search}" id="voucher-search">
                            </div>
                        </div>
                        <div class="col-lg-2">
                            <select class="form-control" id="router" name="router">
                                <option value="">{Lang::T('Routers')}</option>
                                {foreach $routers as $r}
                                    <option value="{$r}" {if $router eq $r }selected{/if}>{$r}</option>
                                {/foreach}
                            </select>
                        </div>
                        <div class="col-lg-2">
                            <select class="form-control" id="plan" name="plan">
                                <option value="">{Lang::T('Plan Name')}</option>
                                {foreach $plans as $p}
                                    <option value="{$p['id']}" {if $plan eq $p['id'] }selected{/if}>{$p['name_plan']}</option>
                                {/foreach}
                            </select>
                        </div>
                        <div class="col-lg-2">
                            <select class="form-control" id="customer" name="customer">
                                <option value="">{Lang::T('Customer')}</option>
                                {foreach $customers as $c}
                                    <option value="{$c['user']}" {if $customer eq $c['user'] }selected{/if}>{$c['user']}</option>
                                {/foreach}
                            </select>
                        </div>
                        <div class="col-lg-2">
                            <div class="btn-group btn-group-justified" role="group">
                                <div class="btn-group" role="group">
                                    <button class="btn btn-success btn-block" type="button" onclick="filterVouchers()">
                                        <span class="fa fa-search"></span>
                                    </button>
                                </div>
                                <div class="btn-group" role="group">
                                    <button class="btn btn-warning btn-block" type="button" onclick="clearFilters()" title="Clear Search Query">
                                        <span class="glyphicon glyphicon-remove-circle"></span>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Mobile-only second row: Plan + Customer -->
                    <div class="row mobile-filter-row2" style="padding: 2px; display: none;">
                        <div class="col-xs-6">
                            <select class="form-control" id="plan-mobile" name="plan">
                                <option value="">{Lang::T('Plan Name')}</option>
                                {foreach $plans as $p}
                                    <option value="{$p['id']}" {if $plan eq $p['id'] }selected{/if}>{$p['name_plan']}</option>
                                {/foreach}
                            </select>
                        </div>
                        <div class="col-xs-6">
                            <select class="form-control" id="customer-mobile" name="customer">
                                <option value="">{Lang::T('Customer')}</option>
                                {foreach $customers as $c}
                                    <option value="{$c['user']}" {if $customer eq $c['user'] }selected{/if}>{$c['user']}</option>
                                {/foreach}
                            </select>
                        </div>
                    </div>
                    
                    <!-- Mobile-only third row: Buttons -->
                    <div class="row mobile-filter-row3" style="padding: 2px; display: none;">
                        <div class="col-xs-12">
                            <div class="btn-group btn-group-justified" role="group">
                                <div class="btn-group" role="group">
                                    <button class="btn btn-success" type="button" onclick="filterVouchersMobile()">
                                        <span class="fa fa-search"></span> {Lang::T('Search')}
                                    </button>
                                </div>
                                <div class="btn-group" role="group">
                                    <button class="btn btn-warning" type="button" onclick="clearFiltersMobile()" title="Clear">
                                        <span class="glyphicon glyphicon-remove-circle"></span> {Lang::T('Clear')}
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            
            <!-- Used Vouchers Tab -->
            <div role="tabpanel" class="tab-pane" id="used-vouchers">
                <div class="alert alert-info">
                    <i class="fa fa-info-circle" style="color: var(--primary);"></i> 
                    <strong style="color: var(--primary-dark);">{Lang::T('Used Vouchers')}:</strong> {Lang::T('These vouchers have already been redeemed and cannot be used again. Use the same search filters to find specific used vouchers.')}
                </div>
            </div>
        </div>
    </div>
    <div class="table-responsive">
        <div style="margin-left: 5px; margin-right: 5px;">&nbsp;
            <table id="datatable" class="table table-bordered table-striped table-condensed">
                <thead>
                    <tr>
                        <th><input type="checkbox" id="select-all"></th>
                        <th>ID</th>
                        <th>{Lang::T('Type')}</th>
                        <th>{Lang::T('Routers')}</th>
                        <th>{Lang::T('Plan Name')}</th>
                        <th>{Lang::T('Code Voucher')}</th>
                        <th>{Lang::T('Status Voucher')}</th>
                        <th>{Lang::T('Customer')}</th>
                        <th>{Lang::T('Create Date')}</th>
                        <th>{Lang::T('Used Date')}</th>
                        <th>{Lang::T('Generated By')}</th>
                        <th>{Lang::T('Manage')}</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach $d as $ds}
                        <tr {if $ds['status'] eq '1' }class="danger" {/if}>
                            <td><input type="checkbox" name="voucher_ids[]" value="{$ds['id']}"></td>
                            <td>{$ds['id']}</td>
                            <td>{$ds['type']}</td>
                            <td>{$ds['routers']}</td>
                            <td>{$ds['name_plan']}</td>
                            <td class="voucher-code-cell voucher-code-hidden" data-code="{$ds['code']}"
                                onmouseleave="if(!window.voucherCodesVisible) this.className = this.className.replace('voucher-code-visible', 'voucher-code-hidden');"
                                onmouseenter="if(!window.voucherCodesVisible) this.className = this.className.replace('voucher-code-hidden', 'voucher-code-visible');">
                                {$ds['code']}</td>
                            <td>
                                {if $ds['status'] eq '0'} 
                                    <span class="btn-tag btn-tag-success">{Lang::T('Not Used')}</span>
                                {else} 
                                    <span class="btn-tag btn-tag-danger">{Lang::T('Used')}</span>
                                {/if}
                            </td>
                            <td>
                                {if $ds['user'] eq '0'} -
                                {else}<a href="{Text::url('')}customers/viewu/{$ds['user']}" style="color: var(--primary);">{$ds['user']}</a>
                                {/if}
                            </td>
                            <td>{if $ds['created_at']}{Lang::dateTimeFormat($ds['created_at'])}{/if}</td>
                            <td>{if $ds['used_date']}{Lang::dateTimeFormat($ds['used_date'])}{/if}</td>
                            <td>
                                {if $ds['generated_by']}
                                    <a href="{Text::url('')}settings/users-view/{$ds['generated_by']}" style="color: var(--primary);">{$admins[$ds['generated_by']]}</a>
                                {else} -
                                {/if}
                            </td>
                            <td>
                                {if $ds['status'] neq '1'}
                                    <button onclick="viewVoucherDetails({$ds['id']})" id="{$ds['id']}" style="margin: 0px;"
                                        class="btn btn-success btn-xs">
                                        <i class="glyphicon glyphicon-eye-open"></i> {Lang::T('View')}
                                    </button>
                                {/if}
                                {if in_array($_admin['user_type'],['SuperAdmin','Admin'])}
                                    <a href="{Text::url('')}plan/voucher-delete/{$ds['id']}" id="{$ds['id']}"
                                        class="btn btn-danger btn-xs" onclick="return ask(this, '{Lang::T('Delete')}?')">
                                        <i class="glyphicon glyphicon-trash"></i>
                                    </a>
                                {/if}
                            </td>
                        </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Voucher Details Modal -->
<div class="modal fade" id="voucherDetailsModal" tabindex="-1" role="dialog" aria-labelledby="voucherDetailsModalLabel">
    <div class="modal-dialog modal-xl" role="document" style="width: 95%; max-width: 1200px;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="voucherDetailsModalLabel">
                    <i class="fa fa-ticket"></i> {Lang::T('Voucher Details')}
                </h4>
            </div>
            <div class="modal-body">
                <div id="voucher-loading" class="text-center" style="padding: 30px;">
                    <i class="fa fa-spinner fa-spin fa-2x" style="color: var(--primary);"></i>
                    <p class="text-muted">{Lang::T('Loading voucher details...')}</p>
                </div>
                <div id="voucher-content" style="display: none;">
                    <div class="row">
                        <div class="col-md-9">
                            <div class="panel panel-default">
                                <div class="panel-heading" style="background: var(--primary-soft); border-bottom: 2px solid var(--primary-light);">
                                    <h4 class="panel-title" style="color: var(--primary-dark);"><i class="fa fa-ticket"></i> {Lang::T('Voucher Details')}</h4>
                                </div>
                                <div class="panel-body" style="padding: 20px;">
                                    <pre id="voucher-print-content" style="background: var(--primary-soft); border: 2px solid var(--primary-light); padding: 20px; border-radius: 12px; font-size: 12px; line-height: 1.4; max-height: 300px; overflow-y: auto; font-family: 'Courier New', monospace;"></pre>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-3">
                            <div class="panel panel-default">
                                <div class="panel-heading" style="background: var(--primary-soft); border-bottom: 2px solid var(--primary-light);">
                                    <h4 class="panel-title" style="color: var(--primary-dark);"><i class="fa fa-mobile"></i> {Lang::T('Send SMS')}</h4>
                                </div>
                                <div class="panel-body" style="padding: 15px;">
                                    <div class="row">
                                        <div class="col-md-12">
                                            <label for="sms-phone" style="font-weight: 500; margin-bottom: 0; color: var(--primary-dark);">{Lang::T('Enter Phone Number')}:</label>
                                        </div>
                                    </div>
                                    <div class="row" style="margin-top: 8px;">
                                        <div class="col-md-12">
                                            <input type="tel" class="form-control" id="sms-phone" 
                                                   placeholder="0712345678" 
                                                   maxlength="10">
                                        </div>
                                    </div>
                                    <div class="row" style="margin-top: 10px;">
                                        <div class="col-md-12">
                                            <button type="button" class="btn btn-primary btn-block btn-sm" id="send-sms-btn">
                                                <i class="fa fa-paper-plane"></i> {Lang::T('Send SMS')}
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">
                    <i class="fa fa-times"></i> {Lang::T('Close')}
                </button>
            </div>
        </div>
    </div>
</div>

{if in_array($_admin['user_type'],['SuperAdmin','Admin'])}
<div class="row" style="padding: 5px">
    <div class="col-lg-3 col-lg-offset-9">
        <div class="btn-group btn-group-justified" role="group">
            <div class="btn-group" role="group">
                <button id="deleteSelectedVouchers" class="btn btn-danger">
                    <i class="glyphicon glyphicon-trash"></i> {Lang::T('Delete Selected')}
                </button>
            </div>
        </div>
    </div>
</div>
{else}
<div class="row" style="padding: 5px">
    <div class="col-lg-12">
        <div class="alert alert-info">
            <i class="fa fa-info-circle" style="color: var(--primary);"></i> 
            <strong style="color: var(--primary-dark);">{Lang::T('Note')}:</strong> {Lang::T('As a')} {$_admin['user_type']}, {Lang::T('you can view and distribute vouchers but cannot create or delete them. Contact your administrator for voucher creation needs.')}
        </div>
    </div>
</div>
{/if}
{include file="pagination.tpl"}

<!-- Keep all existing JavaScript functions - they work with the orange theme -->
<script>
    // Global variables for voucher management
    let currentTab = 'not-used';
    let allVouchers = [];
    window.voucherCodesVisible = false; // Track visibility state
    
    // Initialize the voucher management system
    document.addEventListener('DOMContentLoaded', function() {
        initializeVoucherTabs();
        loadVoucherData();
        initializeVoucherCodeToggle();
    });
    
    function initializeVoucherTabs() {
        // Set default tab
        showVoucherTab('not-used');
        updateVoucherCounts();
    }
    
    function showVoucherTab(tabType) {
        currentTab = tabType;
        
        // Update search form status
        document.getElementById('search-status').value = tabType === 'not-used' ? '0' : '1';
        
        // Filter and display vouchers based on tab
        filterVoucherRows();
        
        // Update tab appearance
        updateTabAppearance(tabType);
    }
    
    function updateTabAppearance(activeTab) {
        // Remove active class from all tabs
        document.querySelectorAll('#voucherTabs li').forEach(function(tab) {
            tab.classList.remove('active');
        });
        
        // Add active class to current tab
        if (activeTab === 'not-used') {
            document.querySelector('#voucherTabs li:first-child').classList.add('active');
        } else {
            document.querySelector('#voucherTabs li:last-child').classList.add('active');
        }
    }
    
    function filterVoucherRows() {
        const table = document.getElementById('datatable');
        const rows = table.querySelectorAll('tbody tr');
        let visibleCount = 0;
        
        rows.forEach(function(row) {
            const statusCell = row.cells[6]; // Status column
            const isUsed = statusCell.textContent.trim().includes('Used');
            
            if (currentTab === 'not-used' && !isUsed) {
                row.style.display = '';
                visibleCount++;
            } else if (currentTab === 'used' && isUsed) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        });
        
        // Update empty state
        updateEmptyState(visibleCount);
    }
    
    function updateEmptyState(visibleCount) {
        const table = document.getElementById('datatable');
        let emptyRow = table.querySelector('.empty-state-row');
        
        // Remove existing empty state
        if (emptyRow) {
            emptyRow.remove();
        }
        
        // Add empty state if no vouchers visible
        if (visibleCount === 0) {
            const tbody = table.querySelector('tbody');
            const emptyRow = tbody.insertRow();
            emptyRow.className = 'empty-state-row';
            const emptyCell = emptyRow.insertCell();
            emptyCell.colSpan = 12;
            emptyCell.className = 'text-center text-muted';
            emptyCell.style.padding = '20px';
            emptyCell.innerHTML = '<i class="fa fa-info-circle" style="color: var(--primary);"></i> ' + 
                                 (currentTab === 'not-used' ? 'No unused vouchers found.' : 'No used vouchers found.');
        }
    }
    
    function updateVoucherCounts() {
        const table = document.getElementById('datatable');
        const rows = table.querySelectorAll('tbody tr:not(.empty-state-row)');
        let notUsedCount = 0;
        let usedCount = 0;
        
        rows.forEach(function(row) {
            const statusCell = row.cells[6]; // Status column
            const isUsed = statusCell.textContent.trim().includes('Used');
            
            if (isUsed) {
                usedCount++;
            } else {
                notUsedCount++;
            }
        });
        
        // Update badges
        document.getElementById('not-used-count').textContent = notUsedCount;
        document.getElementById('used-count').textContent = usedCount;
    }
    
    function filterVouchers() {
        // Get filter values
        const search = document.getElementById('voucher-search').value.toLowerCase();
        const router = document.getElementById('router').value;
        const plan = document.getElementById('plan').value;
        const customer = document.getElementById('customer').value;
        
        const table = document.getElementById('datatable');
        const rows = table.querySelectorAll('tbody tr:not(.empty-state-row)');
        let visibleCount = 0;
        
        rows.forEach(function(row) {
            const statusCell = row.cells[6]; // Status column
            const isUsed = statusCell.textContent.trim().includes('Used');
            
            // Check if row matches current tab
            const matchesTab = (currentTab === 'not-used' && !isUsed) || (currentTab === 'used' && isUsed);
            
            if (!matchesTab) {
                row.style.display = 'none';
                return;
            }
            
            // Apply additional filters
            let matches = true;
            
            // Search filter (voucher code)
            if (search && !row.cells[5].textContent.toLowerCase().includes(search)) {
                matches = false;
            }
            
            // Router filter
            if (router && row.cells[3].textContent !== router) {
                matches = false;
            }
            
            // Plan filter
            if (plan && !row.cells[4].textContent.includes(plan)) {
                matches = false;
            }
            
            // Customer filter
            if (customer && !row.cells[7].textContent.includes(customer)) {
                matches = false;
            }
            
            if (matches) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        });
        
        updateEmptyState(visibleCount);
    }
    
    function clearFilters() {
        // Clear all filter inputs
        document.getElementById('voucher-search').value = '';
        document.getElementById('router').selectedIndex = 0;
        document.getElementById('plan').selectedIndex = 0;
        document.getElementById('customer').selectedIndex = 0;
        
        // Clear mobile filters too
        if (document.getElementById('plan-mobile')) {
            document.getElementById('plan-mobile').selectedIndex = 0;
        }
        if (document.getElementById('customer-mobile')) {
            document.getElementById('customer-mobile').selectedIndex = 0;
        }
        
        // Reapply tab filter only
        filterVoucherRows();
    }
    
    // Mobile filter functions
    function filterVouchersMobile() {
        // Sync mobile values to main filters
        var planMobile = document.getElementById('plan-mobile');
        var customerMobile = document.getElementById('customer-mobile');
        
        if (planMobile) {
            document.getElementById('plan').value = planMobile.value;
        }
        if (customerMobile) {
            document.getElementById('customer').value = customerMobile.value;
        }
        
        // Use the main filter function
        filterVouchers();
    }
    
    function clearFiltersMobile() {
        // Clear all filters including mobile ones
        clearFilters();
    }
    
    function loadVoucherData() {
        // Initialize counts and filters
        updateVoucherCounts();
        filterVoucherRows();
    }

    function deleteVouchers(voucherIds) {
        if (voucherIds.length > 0) {
            Swal.fire({
                title: '{Lang::T('Are you sure?')}',
                text: '{Lang::T('You won\'t be able to revert this!')}',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#f97316',
                cancelButtonColor: '#64748b',
                confirmButtonText: '{Lang::T('Yes, delete it!')}',
                cancelButtonText: '{Lang::T('Cancel')}'
            }).then((result) => {
                if (result.isConfirmed) {
                    var xhr = new XMLHttpRequest();
                    xhr.open('POST', '{Text::url('')}plan/voucher-delete-many', true);
                    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                    xhr.onload = function() {
                        if (xhr.status === 200) {
                            var response = JSON.parse(xhr.responseText);

                            if (response.status === 'success') {
                                Swal.fire({
                                    title: '{Lang::T('Deleted!')}',
                                    text: response.message,
                                    icon: 'success',
                                    confirmButtonColor: '#f97316',
                                    confirmButtonText: '{Lang::T('OK')}'
                                }).then(() => {
                                    location.reload(); // Reload the page after confirmation
                                });
                            } else {
                                Swal.fire({
                                    title: '{Lang::T('Error!')}',
                                    text: response.message,
                                    icon: 'error',
                                    confirmButtonColor: '#f97316',
                                    confirmButtonText: '{Lang::T('OK')}'
                                });
                            }
                        } else {
                            Swal.fire({
                                title: '{Lang::T('Error!')}',
                                text: '{Lang::T('Failed to delete vouchers. Please try again.')}',
                                icon: 'error',
                                confirmButtonColor: '#f97316',
                                confirmButtonText: '{Lang::T('OK')}'
                            });
                        }
                    };
                    xhr.send('voucherIds=' + JSON.stringify(voucherIds));
                }
            });
        } else {
            Swal.fire({
                title: '{Lang::T('Error!')}',
                text: '{Lang::T('No vouchers selected to delete.')}',
                icon: 'error',
                confirmButtonColor: '#f97316',
                confirmButtonText: '{Lang::T('OK')}'
            });
        }
    }

    // Example usage for selected vouchers
    if (document.getElementById('deleteSelectedVouchers')) {
        document.getElementById('deleteSelectedVouchers').addEventListener('click', function() {
            var selectedVouchers = [];
            document.querySelectorAll('input[name="voucher_ids[]"]:checked').forEach(function(checkbox) {
                selectedVouchers.push(checkbox.value);
            });

            if (selectedVouchers.length > 0) {
                deleteVouchers(selectedVouchers);
            } else {
                Swal.fire({
                    title: '{Lang::T('Error!')}',
                    text: '{Lang::T('Please select at least one voucher to delete.')}',
                    icon: 'error',
                    confirmButtonColor: '#f97316',
                    confirmButtonText: '{Lang::T('OK')}'
                });
            }
        });
    }

    document.querySelectorAll('.delete-voucher').forEach(function(button) {
        button.addEventListener('click', function() {
            var voucherId = this.getAttribute('data-id');
            deleteVouchers([voucherId]);
        });
    });


    // Select or deselect all checkboxes
    if (document.getElementById('select-all')) {
        document.getElementById('select-all').addEventListener('change', function() {
            var checkboxes = document.querySelectorAll('input[name="voucher_ids[]"]');
            for (var checkbox of checkboxes) {
                checkbox.checked = this.checked;
            }
        });
    }

    // Voucher details modal functionality
    function viewVoucherDetails(voucherId) {
        // Show modal and loading state
        $('#voucherDetailsModal').modal('show');
        $('#voucher-loading').show();
        $('#voucher-content').hide();
        
        // Make AJAX request to get voucher details
        var xhr = new XMLHttpRequest();
        xhr.open('GET', '{Text::url('')}plan/voucher-details-ajax/' + voucherId, true);
        xhr.onload = function() {
            $('#voucher-loading').hide();
            
            if (xhr.status === 200) {
                try {
                    var response = JSON.parse(xhr.responseText);
                    
                    if (response.status === 'success') {
                        // Populate modal with voucher data
                        document.getElementById('voucher-print-content').textContent = response.content;
                        
                        // Update country code display if provided
                        if (response.country_code) {
                            window.currentCountryCode = response.country_code;
                        } else {
                            window.currentCountryCode = '254'; // Default to Kenya
                        }
                        
                        // Store voucher data for SMS sending
                        window.currentVoucherData = {
                            id: response.voucher_id,
                            content: response.content
                        };
                        
                        $('#voucher-content').show();
                    } else {
                        showErrorInModal(response.message || '{Lang::T('Failed to load voucher details')}');
                    }
                } catch (e) {
                    showErrorInModal('{Lang::T('Invalid response from server')}');
                }
            } else {
                showErrorInModal('{Lang::T('Failed to load voucher details. Please try again.')}');
            }
        };
        
        xhr.onerror = function() {
            $('#voucher-loading').hide();
            showErrorInModal('{Lang::T('Network error. Please check your connection and try again.')}');
        };
        
        xhr.send();
    }
    
    function showErrorInModal(message) {
        $('#voucher-content').html('<div class="alert alert-danger"><i class="fa fa-exclamation-triangle"></i> ' + message + '</div>').show();
    }
    
    // SMS and modal event listeners
    $(document).ready(function() {
        // SMS sending functionality
        $('#send-sms-btn').on('click', function() {
            var phone = $('#sms-phone').val().trim();
            var button = $(this);
            
            if (!phone) {
                showSMSAlert('error', '{Lang::T('Please enter a phone number')}');
                $('#sms-phone').focus();
                return;
            }
            
            // Validate phone number format (must start with 07 or 01 and be 10 digits)
            if (!/^0[17][0-9]{8}$/.test(phone)) {
                showSMSAlert('error', '{Lang::T('Phone number must be 10 digits starting with 07 or 01 (e.g., 0712345678)')}');
                $('#sms-phone').focus();
                return;
            }
            
            if (!window.currentVoucherData) {
                showSMSAlert('error', '{Lang::T('No voucher data available')}');
                return;
            }
            
            // Convert phone number format for sending (remove 0, add country code)
            var countryCode = window.currentCountryCode || '254';
            var phoneWithoutZero = phone.substring(1); // Remove leading 0
            var fullPhoneNumber = '+' + countryCode + phoneWithoutZero;
            
            // Disable button and show loading state
            button.prop('disabled', true);
            var originalHtml = button.html();
            button.html('<i class="fa fa-spinner fa-spin"></i> {Lang::T('Sending SMS...')}');
            
            // Send AJAX request
            $.ajax({
                url: '{Text::url('')}plan/send-voucher-sms',
                method: 'POST',
                data: {
                    voucher_id: window.currentVoucherData.id,
                    phone: fullPhoneNumber,
                    custom_message: '' // Using default message
                },
                success: function(response) {
                    if (response.status === 'success') {
                        showSMSAlert('success', '{Lang::T('SMS sent successfully to')} ' + phone);
                        $('#sms-phone').val(''); // Clear phone input
                    } else {
                        showSMSAlert('error', response.message || '{Lang::T('Failed to send SMS')}');
                    }
                },
                error: function(xhr, status, error) {
                    showSMSAlert('error', '{Lang::T('Network error: Unable to send SMS')}');
                },
                complete: function() {
                    // Re-enable button
                    button.prop('disabled', false);
                    button.html(originalHtml);
                }
            });
        });
        
        // Phone number input validation and formatting
        $('#sms-phone').on('input', function() {
            var value = this.value;
            
            // Remove any non-digit characters
            value = value.replace(/[^0-9]/g, '');
            
            // Limit to 10 digits
            if (value.length > 10) {
                value = value.substring(0, 10);
            }
            
            // Ensure it starts with 0 if user enters something
            if (value.length > 0 && value.charAt(0) !== '0') {
                value = '0' + value;
            }
            
            // Ensure second digit is 7 or 1 if we have at least 2 digits
            if (value.length >= 2 && value.charAt(1) !== '7' && value.charAt(1) !== '1') {
                if (value.charAt(1) === '2' || value.charAt(1) === '3' || value.charAt(1) === '4') {
                    // Likely trying to enter 07... format
                    value = '07' + value.substring(2);
                } else {
                    // Default to 07
                    value = '07' + value.substring(2);
                }
            }
            
            this.value = value;
            
            // Visual feedback for validation
            if (value.length === 10 && /^0[17][0-9]{8}$/.test(value)) {
                $(this).removeClass('invalid-input').addClass('valid-input');
            } else if (value.length > 0) {
                $(this).removeClass('valid-input').addClass('invalid-input');
            } else {
                $(this).removeClass('valid-input invalid-input');
            }
        });
        
        // Allow Enter key to send SMS
        $('#sms-phone').on('keypress', function(e) {
            if (e.which === 13) { // Enter key
                $('#send-sms-btn').click();
            }
        });
    });
    
    // Function to show SMS alerts
    function showSMSAlert(type, message) {
        var alertClass = type === 'success' ? 'alert-success' : 'alert-danger';
        var iconClass = type === 'success' ? 'fa-check-circle' : 'fa-exclamation-triangle';
        
        var alertHtml = '<div class="alert ' + alertClass + ' alert-dismissible" role="alert">' +
                       '<button type="button" class="close" data-dismiss="alert" aria-label="Close">' +
                       '<span aria-hidden="true">&times;</span>' +
                       '</button>' +
                       '<i class="fa ' + iconClass + '" style="color: ' + (type === 'success' ? '#22c55e' : '#ef4444') + ';"></i> ' + message +
                       '</div>';
        
        // Insert alert at the top of modal body
        $('.modal-body').prepend(alertHtml);
        
        // Auto-remove alert after 5 seconds
        setTimeout(function() {
            $('.alert').fadeOut(function() {
                $(this).remove();
            });
        }, 5000);
    }
    
    // Initialize voucher code toggle functionality
    function initializeVoucherCodeToggle() {
        const toggleButton = document.getElementById('toggle-voucher-codes');
        const toggleIcon = document.getElementById('toggle-icon');
        const toggleText = document.getElementById('toggle-text');
        
        if (toggleButton) {
            toggleButton.addEventListener('click', function() {
                window.voucherCodesVisible = !window.voucherCodesVisible;
                toggleVoucherCodes(window.voucherCodesVisible);
                
                // Update button appearance
                if (window.voucherCodesVisible) {
                    toggleIcon.className = 'glyphicon glyphicon-eye-close';
                    toggleText.textContent = '{Lang::T('Hide All Codes')}';
                    toggleButton.className = toggleButton.className.replace('btn-info', 'btn-warning');
                    toggleButton.title = '{Lang::T('Click to hide all voucher codes')}';
                } else {
                    toggleIcon.className = 'glyphicon glyphicon-eye-open';
                    toggleText.textContent = '{Lang::T('Show All Codes')}';
                    toggleButton.className = toggleButton.className.replace('btn-warning', 'btn-info');
                    toggleButton.title = '{Lang::T('Click to show all voucher codes')}';
                }
            });
        }
    }
    
    function toggleVoucherCodes(visible) {
        const voucherCells = document.querySelectorAll('.voucher-code-cell');
        
        voucherCells.forEach(function(cell) {
            if (visible) {
                // Show all codes
                cell.className = cell.className.replace('voucher-code-hidden', 'voucher-code-visible');
                cell.onmouseenter = null;
                cell.onmouseleave = null;
            } else {
                // Hide all codes
                cell.className = cell.className.replace('voucher-code-visible', 'voucher-code-hidden');
                cell.onmouseenter = function() {
                    if (!window.voucherCodesVisible) {
                        this.className = this.className.replace('voucher-code-hidden', 'voucher-code-visible');
                    }
                };
                cell.onmouseleave = function() {
                    if (!window.voucherCodesVisible) {
                        this.className = this.className.replace('voucher-code-visible', 'voucher-code-hidden');
                    }
                };
            }
        });
    }
</script>
{include file="sections/footer.tpl"}