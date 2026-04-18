{include file="sections/header.tpl"}

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
    }
    
    .btn-primary:hover {
        background: linear-gradient(145deg, var(--primary-dark), #c2410c);
    }
    
    .btn-warning {
        background: var(--primary-light);
        border: 1px solid var(--primary);
        color: var(--primary-dark);
        border-radius: 8px;
        transition: all 0.2s;
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

    .plan-stats-bar {
        display: flex;
        flex-wrap: wrap;
        gap: 12px;
        align-items: stretch;
        margin: 0 5px 16px 5px;
    }

    .plan-stat-card {
        flex: 1 1 160px;
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

    .plan-list-meta {
        margin: 0 5px 10px 5px;
        font-size: 13px;
        color: #64748b;
    }

    .th-subscription,
    .th-session {
        white-space: nowrap;
    }

    .plan-empty-state {
        text-align: center;
        padding: 28px 16px 20px;
        color: #64748b;
        border: 1px dashed #e2e8f0;
        border-radius: 12px;
        margin: 0 5px 12px 5px;
        background: #fafafa;
    }

    .plan-empty-state .lead {
        color: #334155;
        font-weight: 600;
        margin-bottom: 8px;
    }

    .plan-empty-state .btn {
        margin: 4px;
    }
</style>

<div class="row">
    <div class="col-sm-12">
        <div class="panel panel-hovered mb20 panel-primary">
            <div class="panel-heading clearfix">
                {if in_array($_admin['user_type'],['SuperAdmin','Admin'])}
                    <div class="btn-group pull-right">
                        <a class="btn btn-primary btn-xs" title="save" href="{Text::url('')}plan/sync"
                            onclick="return ask(this, '{Lang::T("This will sync dan send Customer active package to Mikrotik")}?')">
                            <span class="glyphicon glyphicon-refresh" aria-hidden="true"></span> {Lang::T("Sync")}
                        </a>
                    </div>
                {/if}
                <i class="glyphicon glyphicon-user" style="margin-right: 8px;"></i>
                {Lang::T('Active Customers')}
            </div>
            <form id="site-search" method="post" action="{Text::url('')}plan/list/">
                <div class="panel-body">
                    <div class="row row-no-gutters" style="padding: 5px">
                        <div class="col-lg-2">
                            <div class="input-group">
                                <div class="input-group-btn">
                                    <a class="btn btn-danger" title="Clear Search Query"
                                        href="{Text::url('')}plan/list">
                                        <span class="glyphicon glyphicon-remove-circle"></span>
                                    </a>
                                </div>
                                <input type="text" name="search" class="form-control"
                                    placeholder="{Lang::T("Search")}..." value="{$search}">
                            </div>
                        </div>
                        <div class="col-lg-2 col-xs-4">
                            <select class="form-control" id="router" name="router">
                                <option value="">{Lang::T("Router")}</option>
                                {foreach $routers as $r}
                                    <option value="{$r}" {if $router eq $r }selected{/if}>{$r}</option>
                                {/foreach}
                            </select>
                        </div>
                        <div class="col-lg-2 col-xs-4">
                            <select class="form-control" id="plan" name="plan">
                                <option value="">{Lang::T("Plan Name")}</option>
                                {foreach $plans as $p}
                                    <option value="{$p['id']}" {if $plan eq $p['id'] }selected{/if}>{$p['name_plan']}</option>
                                {/foreach}
                            </select>
                        </div>
                        <div class="col-lg-2 col-xs-4">
                            <select class="form-control" id="status" name="status">
                                <option value="-">{Lang::T("Status")}</option>
                                <option value="on" {if $status eq 'on' }selected{/if}>{Lang::T("Active")}</option>
                                <option value="off" {if $status eq 'off' }selected{/if}>{Lang::T("Expired")}</option>
                            </select>
                        </div>
                        <div class="col-md-4 col-xs-6">
                            <button class="btn btn-success btn-block" type="submit">
                                <span class="fa fa-search"></span>
                            </button>
                        </div>
                    </div>
                </div>
            </form>
            <div class="plan-stats-bar">
                <div class="plan-stat-card plan-stat-total">
                    <div class="plan-stat-label">{Lang::T('Total')}</div>
                    <div class="plan-stat-value">{$plan_stats_total|default:0}</div>
                </div>
                <div class="plan-stat-card plan-stat-on">
                    <div class="plan-stat-label">{Lang::T('Active')}</div>
                    <div class="plan-stat-value">{$plan_stats_on|default:0}</div>
                </div>
                <div class="plan-stat-card plan-stat-off">
                    <div class="plan-stat-label">{Lang::T('Expired')}</div>
                    <div class="plan-stat-value">{$plan_stats_off|default:0}</div>
                </div>
            </div>
            {if $plan_stats_total > 0}
                <p class="plan-list-meta">
                    {Lang::T('Showing')} {$plan_stats_from}–{$plan_stats_to} {Lang::T('of')} {$plan_stats_total}
                </p>
            {/if}
            {if $plan_stats_total == 0}
                <div class="plan-empty-state">
                    <p class="lead">{Lang::T('No active or expired packages match your filters')}</p>
                    <p class="small">{Lang::T('Try adjusting filters or clearing the search.')}</p>
                </div>
            {/if}
            {if $plan_stats_total > 0}
            <div class="table-responsive">
                <div style="margin-left: 5px; margin-right: 5px;">&nbsp;
                    <table id="datatable" class="table table-bordered table-striped table-condensed">
                        <thead>
                            <tr>
                                <th style="width:48px;">#</th>
                                <th>{Lang::T("Username")}</th>
                                <th>{Lang::T("Plan Name")}</th>
                                <th>{Lang::T("Type")}</th>
                                <th class="th-subscription">{Lang::T("Subscription")}</th>
                                <th class="th-session">{Lang::T("Session")}</th>
                                <th>{Lang::T("Created On")}</th>
                                <th>{Lang::T("Expires On")}</th>
                                <th>{Lang::T("Method")}</th>
                                <th><a href="{Text::url('')}routers/list" style="color: var(--primary-dark);">{Lang::T("Location")}</a></th>
                                <th>{Lang::T("Manage")}</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach $d as $ds}
                                <tr {if $ds['status']=='off' }class="danger" {/if}>
                                    <td class="text-muted text-center">{$plan_stats_from + $ds@iteration - 1}</td>
                                    <td>
                                        {if $ds['customer_id'] == '0'}
                                            <a href="{Text::url('plan/voucher/&search=')}{$ds['username']}" style="color: var(--primary); font-weight: 600;">
                                                {$ds['username']}
                                            </a>
                                        {else}
                                            <a href="{Text::url('customers/viewu/')}{$ds['username']}" style="color: var(--primary); font-weight: 600;">
                                                {$ds['username']}
                                            </a>
                                        {/if}
                                    </td>
                                    <td>
                                        {if $ds['type'] == 'Hotspot'}
                                            <a href="{Text::url('')}services/edit/{$ds['plan_id']}" style="color: var(--primary);">
                                                {$ds['namebp']}
                                            </a>
                                        {elseif $ds['type'] == 'PPPOE'}
                                            <a href="{Text::url('')}services/pppoe-edit/{$ds['plan_id']}" style="color: var(--primary);">
                                                {$ds['namebp']}
                                            </a>
                                        {elseif $ds['type'] == 'VPN'}
                                            <a href="{Text::url('')}services/vpn-edit/{$ds['plan_id']}" style="color: var(--primary);">
                                                {$ds['namebp']}
                                            </a>
                                        {else}
                                            <a href="{Text::url('')}services/edit/{$ds['plan_id']}" style="color: var(--primary);">
                                                {$ds['namebp']}
                                            </a>
                                        {/if}
                                    </td>
                                    <td><span class="badge" style="background: var(--primary-light); color: var(--primary-dark);">{$ds['type']}</span></td>
                                    <td class="text-center">
                                        {if $ds['status']=='on'}
                                            <span class="label label-success">{Lang::T('Active')}</span>
                                        {else}
                                            <span class="label label-danger">{Lang::T('Expired')}</span>
                                        {/if}
                                    </td>
                                    <td class="text-center" style="white-space:nowrap;">
                                        {if $ds['status']=='off'}
                                            <span class="label label-default">—</span>
                                        {elseif $_c['check_customer_online'] == 'yes'}
                                            <span api-get-text="{Text::url('')}autoload/customer_is_active/{$ds['username']}/{$ds['plan_id']}"><span class="text-muted small">{Lang::T('Checking...')}</span></span>
                                        {else}
                                            <span class="label label-info">{Lang::T('Active')}</span>
                                        {/if}
                                    </td>
                                    <td>{Lang::dateAndTimeFormat($ds['recharged_on'],$ds['recharged_time'])}</td>
                                    <td>{Lang::dateAndTimeFormat($ds['expiration'],$ds['time'])}</td>
                                    <td>{$ds['method']}</td>
                                    <td><span class="label" style="background: var(--primary-soft); color: var(--primary-dark); border: 1px solid var(--primary-light);">{$ds['routers']}</span></td>
                                    <td>
                                        <a href="{Text::url('')}plan/edit/{$ds['id']}" class="btn btn-warning btn-xs">
                                            <i class="glyphicon glyphicon-pencil"></i> {Lang::T("Edit")}
                                        </a>
                                        {if in_array($_admin['user_type'],['SuperAdmin','Admin'])}
                                            <a href="{Text::url('')}plan/delete/{$ds['id']}" id="{$ds['id']}"
                                                onclick="return ask(this, '{Lang::T("Delete")}?')"
                                                class="btn btn-danger btn-xs">
                                                <i class="glyphicon glyphicon-trash"></i>
                                            </a>
                                        {/if}
                                        {if $ds['status']=='off'}
                                            <a href="javascript:void(0)" onclick="extendExpiredPlan('{$ds['id']}');" class="btn btn-info btn-xs">
                                                <i class="glyphicon glyphicon-time"></i> {Lang::T("Extend")}
                                            </a>
                                        {/if}
                                    </td>
                                </tr>
                            {foreachelse}
                                <tr>
                                    <td colspan="11" class="text-center text-muted" style="padding: 20px;">
                                        {Lang::T('No rows on this page')}
                                    </td>
                                </tr>
                            {/foreach}
                        </tbody>
                    </table>
                </div>
            </div>
            {include file="pagination.tpl"}
            {/if}
        </div>
    </div>
</div>

<script>
    var extendPlanSvoucher = "{App::getVoucher()}";
    function extendExpiredPlan(rechargeId) {
        var days = prompt("{Lang::T('Extend_for_how_many_days')|escape:'javascript'}", "3");
        if (days === null || String(days).trim() === '') {
            return;
        }
        days = parseInt(days, 10);
        if (isNaN(days) || days < 1) {
            alert("{Lang::T('Please_enter_a_valid_number_of_days')|escape:'javascript'}");
            return;
        }
        if (!confirm("{Lang::T('Extend_for')|escape:'javascript'} " + days + " {Lang::T('days_word')|escape:'javascript'}?")) {
            return;
        }
        window.location.href = "{Text::url('')}plan/extend/" + rechargeId + "/" + days + "{Text::isQA()}svoucher=" + encodeURIComponent(extendPlanSvoucher);
    }
</script>

{include file="sections/footer.tpl"}
