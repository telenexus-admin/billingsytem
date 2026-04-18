{include file="sections/header.tpl"}

<style>
:root {
    --primary: #f97316;
    --primary-dark: #ea580c;
    --primary-light: #fed7aa;
    --primary-soft: #fff7ed;
}

.bg-orange { background-color: var(--primary) !important; }
.text-orange { color: var(--primary) !important; }
.border-orange { border-color: var(--primary) !important; }

.box.box-primary {
    border-top-color: var(--primary) !important;
}

.box.box-success {
    border-top-color: var(--primary) !important;
}

.box.box-warning {
    border-top-color: var(--primary) !important;
}

.box.box-info {
    border-top-color: var(--primary) !important;
}

.btn-primary {
    background-color: var(--primary) !important;
    border-color: var(--primary-dark) !important;
}

.btn-primary:hover {
    background-color: var(--primary-dark) !important;
    border-color: var(--primary-dark) !important;
}

.btn-info {
    background-color: var(--primary) !important;
    border-color: var(--primary-dark) !important;
}

.btn-info:hover {
    background-color: var(--primary-dark) !important;
    border-color: var(--primary-dark) !important;
}

.btn-success {
    background-color: var(--primary) !important;
    border-color: var(--primary-dark) !important;
}

.btn-success:hover {
    background-color: var(--primary-dark) !important;
    border-color: var(--primary-dark) !important;
}

.btn-warning {
    background-color: var(--primary) !important;
    border-color: var(--primary-dark) !important;
    color: white !important;
}

.btn-warning:hover {
    background-color: var(--primary-dark) !important;
    border-color: var(--primary-dark) !important;
    color: white !important;
}

.label-success {
    background-color: var(--primary) !important;
}

.badge.bg-green {
    background-color: var(--primary) !important;
}

.badge.bg-blue {
    background-color: var(--primary) !important;
}

.nav-tabs > li.active > a,
.nav-tabs > li.active > a:hover,
.nav-tabs > li.active > a:focus {
    color: var(--primary) !important;
    border-top-color: var(--primary) !important;
}

a {
    color: var(--primary);
}

a:hover {
    color: var(--primary-dark);
}

.table > thead > tr > th {
    color: var(--primary);
    border-bottom-color: var(--primary) !important;
}

.list-group-item .pull-right {
    color: var(--primary);
}

.text-success {
    color: var(--primary) !important;
}

.text-primary {
    color: var(--primary) !important;
}

.profile-username {
    color: var(--primary);
}

.box-header .box-title i {
    color: var(--primary);
}

.box-tools .btn-box-tool:hover {
    color: var(--primary);
}

.alert-info {
    background-color: var(--primary-soft);
    border-color: var(--primary-light);
    color: var(--primary-dark);
}

.alert-info h4 {
    color: var(--primary);
}

.description-percentage {
    color: var(--primary) !important;
}

.description-header {
    color: var(--primary);
}

hr {
    border-top-color: var(--primary-light);
}

.pagination > .active > a,
.pagination > .active > a:hover,
.pagination > .active > a:focus,
.pagination > .active > span,
.pagination > .active > span:hover,
.pagination > .active > span:focus {
    background-color: var(--primary) !important;
    border-color: var(--primary) !important;
}
</style>

<div class="row">
    <!-- User Basic Info -->
    <div class="col-sm-4 col-md-3">
        <div class="box box-{if $d['status']=='Active'}primary{else}danger{/if}">
            <div class="box-body box-profile">
                <h3 class="profile-username text-center">{$d['username']}</h3>
                <ul class="list-group list-group-unbordered">
                    <li class="list-group-item">
                        <b>{Lang::T('Phone Number')}</b> <span class="pull-right">{$d['phonenumber']}</span>
                    </li>
                    <li class="list-group-item">
                        <b>{Lang::T('Status')}</b> <span class="pull-right {if $d['status'] !='Active'}bg-red{/if}">&nbsp;{Lang::T($d['status'])}&nbsp;</span>
                    </li>
                    <li class="list-group-item">
                        <b>{Lang::T('Service Type')}</b> <span class="pull-right">{Lang::T($d['service_type'])}</span>
                    </li>
                    <li class="list-group-item">
                        <b>{Lang::T('Created On')}</b> <span class="pull-right">{Lang::dateTimeFormat($d['created_at'])}</span>
                    </li>
                    <li class="list-group-item">
                        <b>{Lang::T('Last Login')}</b> <span class="pull-right">{Lang::dateTimeFormat($d['last_login'])}</span>
                    </li>
                </ul>
                <!-- Action Buttons at Top -->
                <div class="row">
                    <div class="col-xs-6">
                        <a href="{Text::url('customers/sync/', $d['id'], '&token=', $csrf_token)}"
                            onclick="return ask(this, '{Lang::T('This will sync Customer to Mikrotik')}?')"
                            class="btn btn-info btn-sm btn-block">{Lang::T('Sync')}</a>
                    </div>
                    <div class="col-xs-6">
                        <a href="{Text::url('customers/edit/', $d['id'], '&token=', $csrf_token)}"
                            class="btn btn-warning btn-sm btn-block">{Lang::T('Edit')}</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Live Session Data -->
    <div class="col-sm-5 col-md-5">
        <div class="box box-{if $userSession.online}success{else}warning{/if}">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i class="fa fa-{if $userSession.online}wifi{else}exclamation-triangle{/if}"></i> 
                    {if $userSession.online}Live Session Data{else}User Offline{/if}
                </h3>
                <div class="box-tools pull-right">
                    <button onclick="location.reload()" class="btn btn-box-tool" title="Refresh">
                        <i class="fa fa-refresh"></i>
                    </button>
                </div>
            </div>
            <div class="box-body">
                {if $userSession.online}
                    <!-- Online User: Show session details + current usage -->
                    <div class="row">
                        <div class="col-md-6">
                            <p><strong>IP Address:</strong> {$userSession.ip}</p>
                            <p><strong>MAC Address:</strong> {$userSession.mac}</p>
                            <p><strong>Connection:</strong> <span class="badge bg-orange">{$userSession.type}</span></p>
                        </div>
                        <div class="col-md-6">
                            <p><strong>Uptime:</strong> {$userSession.uptime}</p>
                            <p><strong>Time Left:</strong> {$userSession.session_time_left}</p>
                            <p><strong>Router:</strong> {$userSession.router}</p>
                        </div>
                    </div>
                    <hr>
                    <div class="row text-center">
                        <div class="col-md-4">
                            <div class="description-block">
                                <span class="description-percentage text-green"><i class="fa fa-download"></i></span>
                                <h5 class="description-header">{$userSession.download}</h5>
                                <span class="description-text">DOWNLOAD</span>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="description-block">
                                <span class="description-percentage text-yellow"><i class="fa fa-upload"></i></span>
                                <h5 class="description-header">{$userSession.upload}</h5>
                                <span class="description-text">UPLOAD</span>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="description-block">
                                <span class="description-percentage text-red"><i class="fa fa-exchange"></i></span>
                                <h5 class="description-header">{$userSession.total}</h5>
                                <span class="description-text">TOTAL</span>
                            </div>
                        </div>
                    </div>
                {else}
                    <!-- Offline User: Show total usage data without session details -->
                    <div class="alert alert-info">
                        <h4><i class="fa fa-info-circle"></i> User Offline</h4>
                        <p>No active session found. Showing total usage data.</p>
                    </div>
                    <div class="row text-center">
                        <div class="col-md-4">
                            <div class="description-block">
                                <span class="description-percentage text-green"><i class="fa fa-download"></i></span>
                                <h5 class="description-header">{$userSession.download}</h5>
                                <span class="description-text">TOTAL DOWNLOAD</span>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="description-block">
                                <span class="description-percentage text-yellow"><i class="fa fa-upload"></i></span>
                                <h5 class="description-header">{$userSession.upload}</h5>
                                <span class="description-text">TOTAL UPLOAD</span>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="description-block">
                                <span class="description-percentage text-red"><i class="fa fa-exchange"></i></span>
                                <h5 class="description-header">{$userSession.total}</h5>
                                <span class="description-text">TOTAL USAGE</span>
                            </div>
                        </div>
                    </div>
                {/if}
            </div>
        </div>
    </div>
    
    <!-- Active Package Info -->
    <div class="col-sm-3 col-md-4">
        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title"><i class="fa fa-package"></i> Active Package</h3>
            </div>
            <div class="box-body">
                {if $d.active_package}
                    <ul class="list-group list-group-unbordered">
                        <li class="list-group-item">
                            <b>Plan Name</b> <span class="pull-right">{$d.active_package.namebp}</span>
                        </li>
                        <li class="list-group-item">
                            <b>Bandwidth</b> <span class="pull-right">{$d.active_package.name_bw}</span>
                        </li>
                        <li class="list-group-item">
                            <b>Status</b> <span class="pull-right">
                                {if $d.package_status == 'online'}<span class="label label-success">Online</span>
                                {elseif $d.package_status == 'offline'}<span class="label label-warning">Offline</span>
                                {else}<span class="label label-danger">Expired</span>{/if}
                            </span>
                        </li>
                        <li class="list-group-item">
                            <b>Active Since</b> <span class="pull-right">{$d.active_since}</span>
                        </li>
                        <li class="list-group-item">
                            <b>Time Remaining</b> <span class="pull-right">{$d.time_remaining}</span>
                        </li>
                        <li class="list-group-item">
                            <b>Expires On</b> <span class="pull-right text-danger">{Lang::dateAndTimeFormat($d.active_package.expiration,$d.active_package.time)}</span>
                        </li>
                    </ul>
                    <div class="row" style="margin-top: 10px;">
                        <div class="col-xs-6">
                            <a href="{Text::url('customers/deactivate/', $d['id'], '/', $d.active_package.plan_id, '&token=', $csrf_token)}"
                                class="btn btn-danger btn-sm btn-block">Deactivate</a>
                        </div>
                        <div class="col-xs-6">
                            <a href="{Text::url('customers/recharge/', $d['id'], '/', $d.active_package.plan_id, '&token=', $csrf_token)}"
                                class="btn btn-success btn-sm btn-block">Recharge</a>
                        </div>
                    </div>
                {else}
                    <div class="alert alert-info">
                        <p>No active package found.</p>
                    </div>
                {/if}
            </div>
        </div>
    </div>
</div>

<!-- Recharge History Section at Bottom -->
<div class="row">
    <div class="col-md-12">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title"><i class="fa fa-history"></i> Recharge History</h3>
            </div>
            <div class="box-body">
                <ul class="nav nav-tabs">
                    <li role="presentation" {if $v=='activation' }class="active" {/if}><a
                            href="{Text::url('customers/view/', $d['id'], '/activation')}">Activation History</a></li>
                    <li role="presentation" {if $v=='order' }class="active" {/if}><a
                            href="{Text::url('customers/view/', $d['id'], '/order')}">Order History</a></li>
                </ul>
                <div class="table-responsive" style="background-color: white; margin-top: 10px;">
                    <table class="table table-bordered table-striped table-condensed">
                        {if Lang::arrayCount($activation)}
                            <thead>
                                <tr>
                                    <th>Invoice</th>
                                    <th>Plan Name</th>
                                    <th>Price</th>
                                    <th>Created On</th>
                                    <th>Expires On</th>
                                    <th>Method</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach $activation as $ds}
                                    <tr onclick="window.location.href = '{Text::url('plan/view/', $ds['id'])}'"
                                        style="cursor:pointer;">
                                        <td>{$ds['invoice']}</td>
                                        <td>{$ds['plan_name']}</td>
                                        <td>{Lang::moneyFormat($ds['price'])}</td>
                                        <td class="text-success">{Lang::dateAndTimeFormat($ds['recharged_on'],$ds['recharged_time'])}</td>
                                        <td class="text-danger">{Lang::dateAndTimeFormat($ds['expiration'],$ds['time'])}</td>
                                        <td>{$ds['method']}</td>
                                    </tr>
                                {/foreach}
                            </tbody>
                        {/if}
                        {if Lang::arrayCount($order)}
                            <thead>
                                <tr>
                                    <th>Plan Name</th>
                                    <th>Gateway</th>
                                    <th>Price</th>
                                    <th>Created On</th>
                                    <th>Expires On</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach $order as $ds}
                                    <tr>
                                        <td>{$ds['plan_name']}</td>
                                        <td>{$ds['gateway']}</td>
                                        <td>{Lang::moneyFormat($ds['price'])}</td>
                                        <td class="text-primary">{Lang::dateTimeFormat($ds['created_date'])}</td>
                                        <td class="text-danger">{Lang::dateTimeFormat($ds['expired_date'])}</td>
                                        <td>
                                            {if $ds['status']==1}<span class="badge bg-red">UNPAID</span>
                                            {elseif $ds['status']==2}<span class="badge bg-orange">PAID</span>
                                            {elseif $ds['status']==3}<span class="badge bg-yellow">FAILED</span>
                                            {elseif $ds['status']==4}<span class="badge bg-gray">CANCELED</span>
                                            {elseif $ds['status']==5}<span class="badge bg-blue">UNKNOWN</span>
                                            {/if}
                                        </td>
                                    </tr>
                                {/foreach}
                            </tbody>
                        {/if}
                    </table>
                </div>
                {include file="pagination.tpl"}
            </div>
        </div>
    </div>
</div>

<hr>
<div class="row">
    <div class="col-xs-6 col-md-3">
        <a href="{Text::url('customers/list')}" class="btn btn-primary btn-sm btn-block">{Lang::T('Back')}</a>
    </div>
    <div class="col-xs-6 col-md-3">
        <a href="{Text::url('message/send/', $d['id'], '&token=', $csrf_token)}"
            class="btn btn-success btn-sm btn-block">
            {Lang::T('Send Message')}
        </a>
    </div>
    <div class="col-xs-6 col-md-3">
        <a href="{Text::url('customers/delete/', $d['id'], '&token=', $csrf_token)}" id="{$d['id']}"
            class="btn btn-danger btn-sm btn-block"
            onclick="return ask(this, '{Lang::T('Delete')}?')">Delete Customer</a>
    </div>
    <div class="col-xs-6 col-md-3">
        <button onclick="location.reload()" class="btn btn-info btn-sm btn-block">
            <i class="fa fa-refresh"></i> Refresh Data
        </button>
    </div>
</div>

{include file="sections/footer.tpl"}