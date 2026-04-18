{include file="sections/header.tpl"}

<style>
    :root {
        --primary-color: #3c8dbc;
        --secondary-color: #6c757d;
        --success-color: #28a745;
        --danger-color: #dc3545;
        --light-bg: #f8f9fa;
        --border-radius: 8px;
    }

    .bg-primary {
        background-color: var(--primary-color);
    }

    .bg-danger {
        background-color: var(--danger-color);
    }

    .bg-secondary {
        background-color: var(--secondary-color);
    }

    .bg-success {
        background-color: var(--success-color);
    }

    .bg-light {
        background-color: var(--light-bg);
    }


    .table {
        width: 100%;
        margin-bottom: 1rem;
        background-color: #fff;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }

    .table th {
        vertical-align: middle;
        border-color: #dee2e6;
        background-color: #343a40;
        color: #fff;
    }

    #mapContainer {
        height: 400px;
        width: 100%;
    }

    .modern-input {
        border-radius: 6px;
        border: 1px solid #e0e0e0;
        transition: border-color 0.3s ease;
    }

    .modern-input:focus {
        border-color: #3c8dbc;
        box-shadow: none;
    }

    .modern-primary {
        background: #3c8dbc;
        border: none;
        padding: 10px 25px;
        border-radius: 6px;
        transition: all 0.3s ease;
    }

    .modern-primary:hover {
        background: #367fa9;
    }


    /* Responsive Design */
    @media (max-width: 768px) {
        .dashboard-container {
            padding: 1rem;
        }

        .card-header {
            flex-direction: column;
            align-items: flex-start;
            gap: 1rem;
        }

        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dataTables_filter {
            width: 100%;
            margin-bottom: 1rem;
        }
    }

    .sensitive-info {
        background: #f8f9fa;
        padding: 6px 10px;
        border-radius: 4px;
        cursor: pointer;
        transition: all 0.3s;
        color: #343a40;
    }

    .sensitive-info:hover {
        background: #e9ecef;
        color: #343a40;
    }
</style>
{*<form id="" method="post" action="{$_url}plugin/hotspot_token">
    <div class="input-group">
        <div class="input-group-addon">
            <a href=""><span class="fa fa-refresh"></span></a>
        </div>
        <input type="text" name="search" class="form-control" value="{$search}" placeholder="{Lang::T('Search')}...">
        <div class="input-group-btn">
            <button class="btn btn-success" type="submit">{Lang::T('Search')}</button>
        </div>
    </div>
</form>
<br>*}

<!-- <div class="btn-group pull-left">
    <button class="btn btn-success btn-xs" data-toggle="modal" data-target="#settings" title="General Settings"><span
         class="glyphicon glyphicon-cog" aria-hidden="true"></span> {Lang::T('Settings')}</button>
</div> -->
<!-- token -->
<div class="row" style="padding: 5px">
    <div class="col-lg-3 col-lg-offset-9">
        <div class="btn-group btn-group-justified" role="group">
            <div class="btn-group" role="group">
                <a href="#" class="btn btn-primary" data-toggle="modal" data-target="#create">
                    {Lang::T('Generate Tokens')}</a>
            </div>
            <div class="btn-group" role="group">
                <a href="{$_url}plugin/hotspot_tokensPrint" target="print_token" class="btn btn-info"><i
                        class="ion ion-android-print"></i> {Lang::T('Print All')}</a>
            </div>
        </div>
    </div>
</div>
<div class="panel-heading">
    <!-- {if in_array($_admin['user_type'],['SuperAdmin','Admin'])}
        <div class="btn-group pull-right">
            <a class="btn btn-danger btn-xs" title="Remove used token" href="{$_url}plugin/hotspot_token"
                onclick="return confirm('Delete all used token code?')"><span class="glyphicon glyphicon-trash"
                    aria-hidden="true"></span> Delete All</a>
        </div>
        {/if} -->
    &nbsp;
</div>

<table class="table table-hover" id="dynamic-table" style="width:100%">
    <thead>
        <tr>
            <th><input type="checkbox" id="select-all"></th>
            <th width="70px">#</th>
            <th>{Lang::T('Token Details')}</th>
            <th width="300px">{Lang::T('Actions')}</th>
        </tr>
    </thead>
    <tbody>
        {if $tokens}
        {foreach $tokens as $index => $token}
        <tr>
            <td><input type="checkbox" name="token_ids[]" value="{$token['id']}"></td>
            <td>{$index + 1}</td>
            <td>
                <div class="router-details">
                    <div class="d-flex justify-content-between mb-2">
                        <div>
                            <b>{Lang::T('Pin')}:</b> <span class="badge bg-primary sensitive-info"
                                data-text="{$token['token_number']}">••••••••••••••••</span>&nbsp;
                            <b>{Lang::T('Serial No')}:</b> <span class="badge bg-secondary sensitive-info"
                                data-text="{$token['serial_number']}">••••••••••••••••</span>&nbsp;
                            <b>{Lang::T('Status')}:</b> <span
                                class="badge bg-{if $token['status'] === 'active'}warning{elseif $token['status'] === 'used'}danger {else}success{/if}">
                                {if $token['status'] == 'used'}
                                {Lang::T('Used')}
                                {elseif $token['status'] == 'active'}
                                {Lang::T('Active')}
                                {else}
                                {Lang::T('Not Used')}
                                {/if}
                            </span>
                        </div>
                    </div>

                    <div class="row" style="margin-top: 10px;">
                        <div class="col-md-6">
                            <p class="mb-1">
                                <i class="fa fa-money me-2"></i>
                                {Lang::T('Price')}: {$token['value']}
                            </p>
                            <p class="mb-1">
                                <i class="fa fa-user me-2"></i>
                                {Lang::T('Generated By')}: {if $token['admin_name']}
                                <a href="{$_url}settings/users-view/{$token['generated_by']}">{$token['admin_name']}</a>
                                {else} - {/if}
                            </p>
                            <p class="mb-1">
                                <i class="fa fa-calendar me-2"></i>
                                {Lang::T('Used Date')}: {if $token['first_used']}
                                {$token['first_used']|date_format:"%Y-%m-%d %H:%M:%S"}
                                {else}
                                {Lang::T('Not Used')}{/if}
                            </p>
                            <p class="mb-1">
                                <i class="fa fa-clock-o me-2"></i>
                                {Lang::T('Usage Count')}: {$token['used_count']}
                            </p>
                        </div>
                        <div class="col-md-6">
                            <p class="mb-1">
                                <i class="fa fa-calendar me-2"></i>
                                {Lang::T('Created Date')}: {$token['created_at']|date_format:"%Y-%m-%d %H:%M:%S"}
                            </p>
                            <p class="mb-1">
                                <i class="fa fa-user me-2"></i>
                                {Lang::T('Used By')}: {if $token['used_by']}
                                {$token['used_by']}
                                {else}
                                {Lang::T('None')}{/if}
                            </p>
                            <p class="mb-1">
                                <i class="fa fa-calendar me-2"></i>
                                {Lang::T('Last Used')}: {if $token['last_used']}
                                {$token['last_used']|date_format:"%Y-%m-%d %H:%M:%S"}
                                {else}
                                {Lang::T('Not Used')}{/if}
                            </p>

                        </div>
                    </div>
                </div>
            </td>
            <td>
                <a href="{Text::url('plugin/hotspot_tokens_details')}&token_id={$token['id']}&csrf_token={$csrf_token}"
                    class="btn btn-xs btn-primary"><i class="fa fa-bar-chart" aria-hidden="true"></i>
                    &nbsp;{Lang::T('Reports')}</a>
                <hr>
                {if $token['status'] neq 'used'}
                <a href="{Text::url('plugin/hotspot_tokens_print')}&token_id={$token['id']}" id="{$token['id']}"
                    class="btn btn-success btn-xs">{Lang::T('Print')}</a>
                {/if}
                <button type="button" class="btn btn-primary btn-xs send-token" data-id="{$token['id']}"
                    data-toggle="modal" data-target="#sendTokenModal">
                    {Lang::T('Send')}
                </button>
                <button type="button" class="btn btn-warning btn-xs refill-token" data-id="{$token['id']}"
                    data-toggle="modal" data-target="#refillTokenModal">
                    {Lang::T('Refill')}
                </button>
                <hr />
                {if $token['status'] neq 'blocked'}
                <a href="javascript:void(0);"
                    onclick="confirmAction('{Text::url('plugin/hotspot_tokens_status')}&token_id={$token['id']}&status=blocked&csrf_token={$csrf_token}', '{Lang::T('Block')}')"
                    id="{$token['id']}" class="btn btn-danger btn-xs">
                    {Lang::T('Block')}
                </a>
                {else}
                <a href="javascript:void(0);"
                    onclick="confirmAction('{Text::url('plugin/hotspot_tokens_status')}&token_id={$token['id']}&status=active&csrf_token={$csrf_token}', '{Lang::T('Unblock')}')"
                    id="{$token['id']}" class="btn btn-warning btn-xs">
                    {Lang::T('Unblock')}
                </a>
                {/if}
            </td>
        </tr>
        {/foreach}
        {else}
        <tr>
            <td colspan="11" style="text-align: center;">
                {Lang::T('No tokens found.')}
            </td>
        </tr>
        {/if}
    </tbody>
</table>
<div class="row" style="padding: 5px">
    <div class="col-lg-3 col-lg-offset-9">
        <div class="btn-group btn-group-justified" role="group">
            <div class="btn-group" role="group">
                {if in_array($_admin['user_type'],['SuperAdmin','Admin'])}
                <button id="deleteSelectedTokens" class="btn btn-danger">{Lang::T('Delete
                    Selected')}</button>
                {/if}
            </div>
            <div class="btn-group" role="group">
                <button id="printSelectedTokens" class="btn btn-success">{Lang::T('Print
                    Selected')}</button>
            </div>
        </div>
    </div>
</div>
{*{include file="pagination.tpl"}*}
&nbsp;



<div class="modal fade" id="settings">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title"> {Lang::T('Generate Settings')}</h4>
            </div>
            <div class="box-body">
                <div class="tab-pane">
                    <form class="form-horizontal" method="post" autocomplete="off" role="form" action="">
                        <div class="form-group">
                            <label class="col-md-2 control-label">{Lang::T('Enable Recharge')}</label>
                            <div class="col-md-6">
                                <label class="switch">
                                    <input type="checkbox" id="hotspot_tokens_mode" value="1" name="hotspot_tokens_mode"
                                        {if $_c['hotspot_tokens_mode']==1}checked{/if}>
                                    <span class="slider"></span>
                                </label>
                            </div>
                        </div>
                        <div class="form-group" id="recharge-type-group">
                            <label class="col-md-2 control-label">{Lang::T('Recharge Notification')}</label>
                            <div class="col-md-6">
                                <select class="form-control" name="hotspot_tokens_notify" id="hotspot_tokens_notify">
                                    <option value="1" {if $_c['hotspot_tokens_notify']=='1' }selected{/if}>
                                        {Lang::T('Enabled')}</option>
                                    <option value="0" {if $_c['hotspot_tokens_notify']=='0' }selected{/if}>
                                        {Lang::T('Disabled')}</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-2 control-label">{Lang::T('Enable Message')}</label>
                            <div class="col-md-6">
                                <label class="switch">
                                    <input type="checkbox" id="recharge_message" value="1" name="recharge_message" {if
                                        $_c['recharge_message']==1 }checked{/if}>
                                    <span class="slider"></span>
                                </label>
                            </div>
                        </div>
                        <div class="form-group" id="message-group">
                            <label class="col-md-2 control-label">{Lang::T('Send Via')}</label>
                            <div class="col-md-6">
                                <select class="form-control" name="recharge_message_via" id="recharge_message_via">
                                    <option value="sms" {if $_c['recharge']=='sms' }selected{/if}>
                                        {Lang::T('SMS')}</option>
                                    <option value="wa" {if $_c['recharge_message_via']=='wa' }selected{/if}>
                                        {Lang::T('WhatsApp')}</option>
                                    <option value="both" {if $_c['recharge_message_via']=='both' }selected{/if}>
                                        {Lang::T('Both')}</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="message-content-group">
                            <label class="col-md-2 control-label">{Lang::T('Message')}</label>
                            <div class="col-md-6">
                                <textarea class="form-control" id="recharge_message_content"
                                    name="recharge_message_content"
                                    rows="6">{Lang::htmlspecialchars($_json[''])}</textarea>
                            </div>
                            <p class="help-block col-md-4">
                                <b>[[login_code]]</b> - {Lang::T('will replace customer login code')}.<br>
                                <b>[[package]]</b> - {Lang::T('will replace customer package name')}.<br>
                                <b>[[expiry]]</b> - {Lang::T('will replace customer package expiry date')}.<br>
                                <b>[[company]]</b> - {Lang::T('will replace your Company Name')}.<br>
                            </p>
                        </div>
                        <div class="form-group" id="">
                            <label class="col-md-2 control-label">{Lang::T('Recharge Send Template')}</label>
                            <div class="col-md-6">
                                <textarea rows="8" name="recharge_send" id="recharge_send"
                                    class="form-control">{Lang::htmlspecialchars($_json[''])}</textarea>
                            </div>
                            <p class="help-block col-md-4">
                                <b>[[code]]</b> - {Lang::T('will replace recharge code')}.<br>
                                <b>[[data]]</b> - {Lang::T('will replace recharge data limit')}.<br>
                                <b>[[validity]]</b> - {Lang::T('will replace recharge validity or duration')}.<br>
                                <b>[[company]]</b> - {Lang::T('will replace your Company Name')}.<br>
                            </p>
                        </div>

                        <div class="form-group" id="">
                            <label class="col-md-2 control-label">{Lang::T('Recharge Tokens Print Template')}</label>
                            <div class="col-md-6">
                                <textarea rows="8" name="" id=""
                                    class="form-control">{Lang::htmlspecialchars($_json[''])}</textarea>
                            </div>
                            <p class="help-block col-md-4">
                                <b>[[currency]]</b> - {Lang::T('will replace recharge currency code')}.<br>
                                <b>[[plan_price]]</b> - {Lang::T('will replace recharge plan price')}.<br>
                                <b>[[code]]</b> - {Lang::T('will replace recharge code')}.<br>
                                <b>[[data]]</b> - {Lang::T('will replace recharge data limit')}.<br>
                                <b>[[validity]]</b> - {Lang::T('will replace recharge validity or duration')}.<br>
                                <b>[[url]]</b> - {Lang::T('will replace recharge with recharge login url')}.<br>
                                <b>[[qrcode]]</b> - {Lang::T('will replace recharge QRcode')}.<br>
                            </p>
                        </div>
                        <div class="panel-body">
                            <div class="form-group">
                                <button class="btn btn-success btn-block" name="save" value="save" type="submit">
                                    {Lang::T('Save Changes')}
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<form id="printSelectedForm" method="POST" action="{$_url}plugin/hotspot_tokens_print">
    <input type="hidden" name="tokenIds" id="tokenIdsInput">
</form>

<div class="modal fade" id="create">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title"> {Lang::T('Generate Tokens')}</h4>
            </div>
            <div class="box-body">
                <div class="tab-pane">
                    <form action="" method="post" enctype="multipart/form-data" class="form-horizontal">
                        <div class="form-group">
                            <label for="inputExperience" class="col-sm-2 control-label">{Lang::T('No of
                                Tokens')}</label>
                            <div class="col-sm-10">
                                <input type="text" class="form-control" name="number_of_tokens" value="1">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="inputSkills" class="col-sm-2 control-label">
                                {Lang::T('PIN Length')}</label>
                            <div class="col-sm-10">
                                <input type="text" class="form-control" name="lengthcode" value="12">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="inputSkills" class="col-sm-2 control-label">
                                {Lang::T('Token Value')}</label>
                            <div class="col-sm-10">
                                <input type="token_value" class="form-control" name="token_value"
                                    placeholder="Recharge Amount" value="">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="inputSkills" class="col-sm-2 control-label"> {Lang::T('Print
                                Now')}</label>

                            <div class="col-sm-10">
                                <input type="checkbox" id="print_now" name="print_now" class="iCheck" value="1">
                            </div>
                        </div>
                        <div class="box-footer">
                            <div class="pull-right">
                                <button type="submit" value="token" name="generate" class="btn btn-primary">
                                    <i class="fa fa-telegram">
                                    </i> {Lang::T('Generate')}</button>
                            </div>
                            <button type="button" data-dismiss="modal" class="btn btn-danger">
                                <i class="">
                                </i> {Lang::T('Cancel')}</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>




<!-- Send Token Modal HTML -->

<div class="modal fade" id="sendTokenModal" tabindex="-1" role="dialog" aria-labelledby="sendTokenLabel"
    aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="sendTokenLabel"> {Lang::T('Send Token PIN')}</h4>
            </div>
            <div class="box-body">
                <div class="tab-pane">
                    <form action="{$_url}plugin/hotspot_tokens_sendToken" method="post" enctype="multipart/form-data"
                        class="form-horizontal">
                        <input type="hidden" id="tokenId" name="tokenId">
                        <div class="form-group">
                            <label for="phone_number" class="col-sm-2 control-label">{Lang::T('Phone No')}</label>
                            <div class="col-sm-10">
                                <input type="text" id="phone_number" name="phoneNumber"
                                    placeholder="{Lang::T('Enter the receiver phone number')}" class="form-control">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="method" class="col-sm-2 control-label">{Lang::T('Send Via')}</label>
                            <div class="col-sm-10">
                                <select name="method" id="method" class="form-control">
                                    <option value="sms">{Lang::T('SMS')}</option>
                                    <option value="wa">{Lang::T('WhatsApp')}</option>
                                    <option value="both">{Lang::T('Both')}</option>
                                </select>
                            </div>
                        </div>
                        <div class="box-footer">
                            <div class="pull-right">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fa fa-telegram"></i> {Lang::T('Send Now')}
                                </button>
                            </div>
                            <button type="button" data-dismiss="modal" class="btn btn-danger">
                                <i class=""></i> {Lang::T('Cancel')}
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Refill Token Modal HTML -->

<div class="modal fade" id="refillTokenModal" tabindex="-1" role="dialog" aria-labelledby="refillTokenLabel"
    aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="refillTokenLabel"> {Lang::T('Refill Token PIN')}</h4>
            </div>
            <div class="box-body">
                <div class="tab-pane">
                    <form action="{$_url}plugin/hotspot_tokens_refillToken" method="post" enctype="multipart/form-data"
                        class="form-horizontal">
                        <input type="hidden" id="tokenId" name="tokenId">
                        <div class="form-group">
                            <label for="amount" class="col-sm-2 control-label">{Lang::T('Amount')}</label>
                            <div class="col-sm-10">
                                <input type="text" id="amount" name="amount" placeholder="{Lang::T('Enter the amount')}"
                                    class="form-control">
                                <small>
                                    <input id="notify" name="notify" type="checkbox"> {Lang::T('Send Notification')}
                                </small>
                            </div>
                        </div>
                        <div class="form-group hidden-field" id="phoneNumberGroup">
                            <label for="phoneNumber" class="col-sm-2 control-label">{Lang::T('Phone No')}</label>
                            <div class="col-sm-10">
                                <input type="text" id="phoneNumber" name="phoneNumber"
                                    placeholder="{Lang::T('Enter the receiver phone number')}" class="form-control">
                            </div>
                        </div>
                        <div class="form-group hidden-field" id="methodGroup">
                            <label for="method" class="col-sm-2 control-label">{Lang::T('Send Via')}</label>
                            <div class="col-sm-10">
                                <select name="method" id="method" class="form-control">
                                    <option value="sms">{Lang::T('SMS')}</option>
                                    <option value="wa">{Lang::T('WhatsApp')}</option>
                                    <option value="both">{Lang::T('Both')}</option>
                                </select>
                            </div>
                        </div>
                        <div class="box-footer">
                            <div class="pull-right">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fa fa-telegram"></i> {Lang::T('Refill')}
                                </button>
                            </div>
                            <button type="button" data-dismiss="modal" class="btn btn-danger">
                                <i class=""></i> {Lang::T('Cancel')}
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript" charset="utf8"
    src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script>
    new DataTable('#dynamic-table');
</script>
<script>
    function deleteVouchers(voucherIds) {
        if (voucherIds.length > 0) {
            Swal.fire({
                title: 'Are you sure?',
                text: 'You won\'t be able to revert this!',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Yes, delete it!',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    var xhr = new XMLHttpRequest();
                    xhr.open('POST', '{$_url}plugin/hotspot_tokens_delete', true);
                    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                    xhr.onload = function () {
                        if (xhr.status === 200) {
                            var response = JSON.parse(xhr.responseText);

                            if (response.status === 'success') {
                                Swal.fire({
                                    title: 'Deleted!',
                                    text: response.message,
                                    icon: 'success',
                                    confirmButtonText: 'OK'
                                }).then(() => {
                                    location.reload(); // Reload the page after confirmation
                                });
                            } else {
                                Swal.fire({
                                    title: 'Error!',
                                    text: response.message,
                                    icon: 'error',
                                    confirmButtonText: 'OK'
                                });
                            }
                        } else {
                            Swal.fire({
                                title: 'Error!',
                                text: 'Failed to delete tokens. Please try again.',
                                icon: 'error',
                                confirmButtonText: 'OK'
                            });
                        }
                    };
                    xhr.send('tokenIds=' + JSON.stringify(voucherIds));
                }
            });
        } else {
            Swal.fire({
                title: 'Error!',
                text: 'No tokens selected to delete.',
                icon: 'error',
                confirmButtonText: 'OK'
            });
        }
    }

    // Example usage for selected tokens
    document.getElementById('deleteSelectedTokens').addEventListener('click', function () {
        var selectedTokens = [];
        document.querySelectorAll('input[name="token_ids[]"]:checked').forEach(function (checkbox) {
            selectedTokens.push(checkbox.value);
        });

        if (selectedTokens.length > 0) {
            deleteVouchers(selectedTokens);
        } else {
            Swal.fire({
                title: 'Error!',
                text: 'Please select at least one token to delete.',
                icon: 'error',
                confirmButtonText: 'OK'
            });
        }
    });

    // Example usage for single token deletion
    document.querySelectorAll('.delete-token').forEach(function (button) {
        button.addEventListener('click', function () {
            var tokenId = this.getAttribute('data-id');
            deleteVouchers([tokenId]);
        });
    });


    // Select or deselect all checkboxes
    document.getElementById('select-all').addEventListener('change', function () {
        var checkboxes = document.querySelectorAll('input[name="token_ids[]"]');
        for (var checkbox of checkboxes) {
            checkbox.checked = this.checked;
        }
    });


    $(document).on('click', '.sensitive-info', function (e) {
            e.stopPropagation();
            const original = $(this).data('text');
            $(this).text(original);
            setTimeout(() => {
                $(this).html('••••••••••••••••');
            }, 5000);
        });
</script>
{literal}
<script>
    function confirmAction(url, action) {
        Swal.fire({
            title: 'Are you sure?',
            text: `Do you really want to ${action.toLowerCase()} this token?`,
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes, proceed!',
            cancelButtonText: 'No, cancel!'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = url;
            }
        });
    }
</script>
{/literal}
<script>
    const $q = jQuery.noConflict();

    $q(document).ready(function () {
        $q('#locktable').DataTable({
            "pagingType": "full_numbers",
            "order": [
                [1, 'desc']
            ]
        });
    });
</script>
<script>
    const $j = jQuery.noConflict();

    $j(document).ready(function () {
        $j('#datatable').DataTable({
            "pagingType": "full_numbers",
            "order": [
                [1, 'desc']
            ]
        });
    });
</script>
<script>
    document.getElementById('printSelectedTokens').addEventListener('click', function () {
        var selectedTokens = [];
        document.querySelectorAll('input[name="token_ids[]"]:checked').forEach(function (checkbox) {
            selectedTokens.push(checkbox.value);
        });

        if (selectedTokens.length > 0) {
            document.getElementById('tokenIdsInput').value = JSON.stringify(selectedTokens);
            document.getElementById('printSelectedForm').submit();
        } else {
            alert('Please select at least one token to print.');
        }
    });
</script>
<script>
    var $ = jQuery.noConflict();
    $(document).ready(function () {
        $('.send-token').on('click', function () {
            var tokenId = $(this).data('id');
            console.log('token ID:', tokenId);
            $('#sendTokenModal').find('#tokenId').val(tokenId); // Corrected ID reference
        });
    });
</script>
<script>
    var $ = jQuery.noConflict();
    $(document).ready(function () {
        $('.refill-token').on('click', function () {
            var tokenId = $(this).data('id');
            console.log('token ID:', tokenId);
            $('#refillTokenModal').find('#tokenId').val(tokenId); // Corrected ID reference
        });
    });
</script>
<script>
    document.getElementById('notify').addEventListener('change', function () {
        var phoneNumberGroup = document.getElementById('phoneNumberGroup');
        var methodGroup = document.getElementById('methodGroup');

        if (this.checked) {
            phoneNumberGroup.classList.remove('hidden-field');
            methodGroup.classList.remove('hidden-field');
        } else {
            phoneNumberGroup.classList.add('hidden-field');
            methodGroup.classList.add('hidden-field');
        }
    });
</script>


<script>
    window.addEventListener('DOMContentLoaded', function () {
        var portalLink = "https://github.com/focuslinkstech";
        $('#version').html('Recharge Tokens Plugin | Ver: 1.0 | by: <a href="' + portalLink + '">Focuslinks Tech</a>');
    });
</script>


{include file="sections/footer.tpl"}