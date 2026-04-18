{include file="sections/header.tpl"}
<style>
    :root {
        --primary: #f97316;
        --primary-dark: #ea580c;
        --primary-light: #fed7aa;
        --primary-soft: #fff7ed;
        --primary-hover: #fb923c;
    }

    .dataTables_wrapper .dataTables_paginate .paginate_button {
        display: inline-block;
        padding: 5px 10px;
        margin-right: 5px;
        border: 1px solid #f97316;
        background-color: #fff;
        color: #f97316;
        cursor: pointer;
        border-radius: 6px;
        transition: all 0.2s;
    }
    
    .dataTables_wrapper .dataTables_paginate .paginate_button:hover {
        background: #f97316;
        color: white !important;
        border-color: #ea580c;
    }
    
    .dataTables_wrapper .dataTables_paginate .paginate_button.current {
        background: #f97316;
        color: white !important;
        border-color: #ea580c;
    }

    /* Panel styling */
    .panel-primary {
        border-color: #f97316;
        box-shadow: 0 4px 12px rgba(249, 115, 22, 0.1);
    }
    
    .panel-primary > .panel-heading {
        background: linear-gradient(145deg, #f97316, #ea580c);
        color: white;
        border-color: #ea580c;
        font-weight: 600;
    }
    
    .panel-primary > .panel-heading .btn-primary {
        background: white;
        color: #f97316;
        border: none;
        padding: 5px 12px;
        font-size: 12px;
        border-radius: 20px;
        font-weight: 600;
        box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    }
    
    .panel-primary > .panel-heading .btn-primary:hover {
        background: #fff7ed;
        transform: translateY(-1px);
    }

    /* Button styling */
    .btn-primary {
        background: linear-gradient(145deg, #f97316, #ea580c);
        border: none;
        color: white;
        font-weight: 500;
        border-radius: 8px;
        transition: all 0.2s;
    }
    
    .btn-primary:hover {
        background: linear-gradient(145deg, #ea580c, #c2410c);
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(249, 115, 22, 0.3);
    }
    
    .btn-success {
        background: #f97316;
        border: none;
        color: white;
        font-weight: 500;
        border-radius: 8px;
        transition: all 0.2s;
    }
    
    .btn-success:hover {
        background: #ea580c;
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(249, 115, 22, 0.2);
    }
    
    .btn-info {
        background: #fb923c;
        border: none;
        color: white;
        font-weight: 500;
        border-radius: 8px;
        transition: all 0.2s;
    }
    
    .btn-info:hover {
        background: #f97316;
        transform: translateY(-1px);
    }
    
    .btn-group .btn-success {
        background: #f97316;
    }
    
    .btn-group .btn-success:hover {
        background: #ea580c;
    }

    /* Form controls */
    .form-control {
        border: 2px solid #e2e8f0;
        border-radius: 10px;
        transition: all 0.2s;
    }
    
    .form-control:focus {
        border-color: #f97316;
        box-shadow: 0 0 0 3px rgba(249, 115, 22, 0.1);
    }
    
    .input-group-addon {
        background: #fff7ed;
        border: 2px solid #e2e8f0;
        border-right: none;
        border-radius: 10px 0 0 10px;
        color: #f97316;
        font-weight: 500;
    }
    
    .input-group .form-control {
        border-left: none;
        border-radius: 0 10px 10px 0;
    }

    /* Table styling */
    .table-bordered {
        border: 2px solid #ffedd5;
        border-radius: 16px;
        overflow: hidden;
        box-shadow: 0 4px 12px rgba(249, 115, 22, 0.05);
    }
    
    .table thead tr {
        background: linear-gradient(145deg, #f97316, #ea580c);
        color: white;
    }
    
    .table thead th {
        border: none !important;
        font-weight: 600;
        text-transform: uppercase;
        font-size: 12px;
        letter-spacing: 0.5px;
        padding: 12px 8px !important;
        vertical-align: middle;
    }
    
    .table tbody tr:hover {
        background: #fff7ed !important;
        cursor: pointer;
    }
    
    .table tbody td {
        vertical-align: middle;
        border-color: #ffedd5;
    }
    
    .table .danger {
        background: #fff1f0;
        border-left: 4px solid #f97316;
    }
    
    .table .danger:hover {
        background: #ffe4e2 !important;
    }

    /* Labels and badges */
    .label-default {
        background: #f97316;
        color: white;
        padding: 4px 8px;
        border-radius: 20px;
        font-size: 11px;
        font-weight: 600;
    }
    
    .label-success {
        background: #22c55e;
    }
    
    .label-danger {
        background: #ef4444;
    }

    /* Action buttons in table - ONLY VIEW BUTTON STYLES */
    .btn-xs {
        border-radius: 20px;
        padding: 6px 16px;
        font-size: 12px;
        font-weight: 600;
        margin: 0;
        box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    
    /* Only style the View button (btn-success) */
    .btn-success.btn-xs {
        background: linear-gradient(145deg, #f97316, #ea580c);
        border: none;
        color: white;
        display: inline-block;
    }
    
    .btn-success.btn-xs:hover {
        background: linear-gradient(145deg, #ea580c, #c2410c);
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(249, 115, 22, 0.3);
    }
    
    /* Hide all other action buttons */
    .btn-info.btn-xs,
    .btn-primary.btn-xs,
    a[href*="customers/edit"],
    a[href*="customers/sync"],
    a[href*="plan/recharge"] {
        display: none !important;
    }

    /* Contact icons */
    .btn-default.btn-xs {
        background: #fff7ed;
        border: 1px solid #fed7aa;
        color: #f97316;
        border-radius: 8px;
        width: 28px;
        height: 28px;
        padding: 0;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        margin: 0 2px;
    }
    
    .btn-default.btn-xs:hover {
        background: #f97316;
        color: white;
        border-color: #f97316;
    }

    /* Photo thumbnail - HIDDEN */
    .table td img {
        display: none;
    }

    /* Modal styling */
    .modal-content {
        border: none;
        border-radius: 20px;
        box-shadow: 0 20px 40px rgba(249, 115, 22, 0.2);
    }
    
    .modal-header {
        background: linear-gradient(145deg, #f97316, #ea580c);
        color: white;
        border-radius: 20px 20px 0 0;
        padding: 15px 20px;
    }
    
    .modal-header .close {
        color: white;
        opacity: 0.8;
        text-shadow: none;
    }
    
    .modal-header .close:hover {
        opacity: 1;
    }
    
    .modal-title {
        font-weight: 600;
    }
    
    .modal-footer {
        border-top: 2px solid #ffedd5;
        padding: 15px 20px;
    }
    
    .modal-footer .btn-primary {
        background: linear-gradient(145deg, #f97316, #ea580c);
        padding: 8px 24px;
        border-radius: 30px;
    }
    
    .modal-footer .btn-secondary {
        background: #fff7ed;
        color: #f97316;
        border: 1px solid #fed7aa;
        padding: 8px 24px;
        border-radius: 30px;
    }
    
    .modal-footer .btn-secondary:hover {
        background: #fed7aa;
        color: #ea580c;
    }

    /* Pagination */
    .pagination {
        margin: 20px 0;
    }
    
    .pagination > li > a,
    .pagination > li > span {
        border: 1px solid #fed7aa;
        color: #f97316;
        margin: 0 3px;
        border-radius: 8px !important;
        transition: all 0.2s;
    }
    
    .pagination > li > a:hover,
    .pagination > li > span:hover {
        background: #f97316;
        border-color: #f97316;
        color: white;
    }
    
    .pagination > .active > a,
    .pagination > .active > span {
        background: #f97316;
        border-color: #f97316;
        color: white;
    }

    /* Search bar styling */
    .md-whiteframe-z1 {
        background: white;
        border-radius: 20px;
        padding: 20px 15px !important;
        box-shadow: 0 8px 24px rgba(249, 115, 22, 0.1) !important;
        border: 1px solid #fed7aa;
    }
    
    /* Checkbox styling */
    input[type="checkbox"] {
        width: 18px;
        height: 18px;
        cursor: pointer;
        accent-color: #f97316;
        border-radius: 4px;
    }
    
    #select-all {
        margin: 0;
    }

    /* Bottom action buttons */
    .btn-group .btn-success {
        background: #f97316;
        padding: 10px 20px;
        border-radius: 30px;
        font-weight: 600;
        box-shadow: 0 4px 12px rgba(249, 115, 22, 0.2);
    }
    
    .btn-group .btn-success:hover {
        background: #ea580c;
        transform: translateY(-2px);
        box-shadow: 0 6px 16px rgba(249, 115, 22, 0.3);
    }
    
    .btn-group .btn-danger {
        background: #ef4444;
        border-radius: 30px;
        font-weight: 600;
    }

    /* Responsive adjustments */
    @media (max-width: 768px) {
        .btn-xs {
            padding: 4px 12px;
            font-size: 11px;
        }
        
        .table td {
            font-size: 12px;
        }
    }

    /* Custom scrollbar */
    ::-webkit-scrollbar {
        width: 8px;
        height: 8px;
    }
    
    ::-webkit-scrollbar-track {
        background: #fff7ed;
        border-radius: 10px;
    }
    
    ::-webkit-scrollbar-thumb {
        background: #f97316;
        border-radius: 10px;
    }
    
    ::-webkit-scrollbar-thumb:hover {
        background: #ea580c;
    }

    /* Loading animation */
    .loading::after {
        border-top-color: #f97316;
    }

    /* Hide removed columns */
    .photo-column,
    .account-type-column,
    .balance-column,
    .contact-column {
        display: none;
    }
    
    /* Hide columns without relying only on classes (photo=4, account=5, balance=7, icons=8 after Connection) */
    th:nth-child(4),
    th:nth-child(5),
    th:nth-child(7),
    th:nth-child(8),
    td:nth-child(4),
    td:nth-child(5),
    td:nth-child(7),
    td:nth-child(8) {
        display: none;
    }

    .customer-connection-cell {
        white-space: nowrap;
        vertical-align: middle !important;
    }

    .customer-connection-cell .label {
        font-size: 11px;
        font-weight: 600;
        padding: 4px 8px;
        border-radius: 6px;
        display: inline-block;
        min-width: 64px;
        text-align: center;
    }
</style>

<div class="row">
    <div class="col-sm-12">
        <div class="panel panel-hovered mb20 panel-primary">
            <div class="panel-heading">
                {if in_array($_admin['user_type'],['SuperAdmin','Admin'])}
                <div class="btn-group pull-right">
                    <a class="btn btn-primary btn-xs" title="save"
                        href="{Text::url('customers/csv&token=', $csrf_token)}"
                        onclick="return ask(this, '{Lang::T("This will export to CSV")}?')"><span
                            class="glyphicon glyphicon-download" aria-hidden="true"></span> CSV</a>
                </div>
                {/if}
                <i class="glyphicon glyphicon-user" style="margin-right: 8px;"></i>
                {Lang::T('Manage Contact')}
            </div>
            <div class="panel-body">
                <form id="site-search" method="post" action="{Text::url('customers')}">
                    <input type="hidden" name="csrf_token" value="{$csrf_token}">
                    <div class="md-whiteframe-z1 mb20 text-center" style="padding: 15px">
                        <div class="col-lg-4">
                            <div class="input-group">
                                <span class="input-group-addon">{Lang::T('Order ')}&nbsp;&nbsp;</span>
                                <div class="row row-no-gutters">
                                    <div class="col-xs-8">
                                        <select class="form-control" id="order" name="order">
                                            <option value="username" {if $order eq 'username' }selected{/if}>
                                                {Lang::T('Username')}</option>
                                                                                        <option value="created_at" {if $order eq 'created_at' }selected{/if}>
                                                {Lang::T('Created Date')}</option>
                                            <option value="balance" {if $order eq 'balance' }selected{/if}>
                                                {Lang::T('Balance')}</option>
                                            <option value="status" {if $order eq 'status' }selected{/if}>
                                                {Lang::T('Status')}</option>
                                        </select>
                                    </div>
                                    <div class="col-xs-4">
                                        <select class="form-control" id="orderby" name="orderby">
                                            <option value="asc" {if $orderby eq 'asc' }selected{/if}>
                                                {Lang::T('Ascending')}</option>
                                            <option value="desc" {if $orderby eq 'desc' }selected{/if}>
                                                {Lang::T('Descending')}</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3">
                            <div class="input-group">
                                <span class="input-group-addon">{Lang::T('Status')}</span>
                                <select class="form-control" id="filter" name="filter">
                                    {foreach $statuses as $status}
                                    <option value="{$status}" {if $filter eq $status }selected{/if}>{Lang::T($status)}
                                    </option>
                                    {/foreach}
                                </select>
                            </div>
                        </div>
                        <div class="col-lg-4">
                            <div class="input-group">
                                <input type="text" name="search" class="form-control"
                                    placeholder="{Lang::T('Search')}..." value="{$search}">
                                <div class="input-group-btn">
                                    <button class="btn btn-primary" type="submit"><span class="fa fa-search"></span>
                                        {Lang::T('Search')}</button>
                                    <button class="btn btn-info" type="submit" name="export" value="csv">
                                        <span class="glyphicon glyphicon-download" aria-hidden="true"></span> CSV
                                    </button>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-1">
                            <a href="{Text::url('customers/add')}" class="btn btn-success text-black btn-block"
                                title="{Lang::T('Add')}">
                                <i class="ion ion-android-add"></i><i class="glyphicon glyphicon-user"></i>
                            </a>
                        </div>
                    </div>
                </form>
                <br>&nbsp;
                <div class="table-responsive table_mobile">
                    <table id="customerTable" class="table table-bordered table-striped table-condensed">
                        <thead>
                            <tr>
                                <th><input type="checkbox" id="select-all"></th>
                                <th>{Lang::T('Username')}</th>
                                <th class="th-connection">{Lang::T('Connection')}</th>
                                <th class="photo-column">Photo</th>
                                <th class="account-type-column">{Lang::T('Account Type')}</th>
                                <th>{Lang::T('Contact')}</th>
                                <th class="balance-column">{Lang::T('Balance')}</th>
                                <th class="contact-column">{Lang::T('Contact')}</th>
                                <th>{Lang::T('Package')}</th>
                                <th>{Lang::T('Service Type')}</th>
                                <th>PPPOE</th>
                                <th>{Lang::T('Status')}</th>
                                <th>{Lang::T('Created On')}</th>
                                <th>{Lang::T('Manage')}</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach $d as $ds}
                            <tr {if $ds['status'] !='Active' }class="danger" {/if}>
                                <td><input type="checkbox" name="customer_ids[]" value="{$ds['id']}"></td>
                                <td onclick="window.location.href = '{Text::url('customers/view/', $ds['id'])}'"
                                    style="cursor:pointer;">{$ds['username']}</td>
                                <td class="text-center customer-connection-cell">
                                    <span api-get-text="{Text::url('autoload/customer_list_connection/')}{$ds['id']}">
                                        <span class="text-muted small">{Lang::T('Checking...')}</span>
                                    </span>
                                </td>
                                <td class="photo-column">
                                    <a href="{$app_url}/{$UPLOAD_PATH}{$ds['photo']}" target="photo">
                                        <img src="{$app_url}/{$UPLOAD_PATH}{$ds['photo']}.thumb.jpg" width="32" alt="">
                                    </a>
                                </td>
                                <td class="account-type-column">{$ds['account_type']}</td>
                                <td onclick="window.location.href = '{Text::url('customers/view/', $ds['id'])}'"
                                    style="cursor: pointer;">{$ds['fullname']}</td>
                                <td class="balance-column">{Lang::moneyFormat($ds['balance'])}</td>
                                <td class="contact-column" align="center">
                                    {if $ds['phonenumber']}
                                    <a href="tel:{$ds['phonenumber']}" class="btn btn-default btn-xs"
                                        title="{$ds['phonenumber']}"><i class="glyphicon glyphicon-earphone"></i></a>
                                    {/if}
                                    {if $ds['email']}
                                    <a href="mailto:{$ds['email']}" class="btn btn-default btn-xs"
                                        title="{$ds['email']}"><i class="glyphicon glyphicon-envelope"></i></a>
                                    {/if}
                                </td>
                                <td align="center" api-get-text="{Text::url('autoload/plan_is_active/')}{$ds['id']}">
                                    <span class="label label-default">&bull;</span>
                                </td>
                                <td>{$ds['service_type']}</td>
                                <td>
                                    {$ds['pppoe_username']}
                                    {if !empty($ds['pppoe_username']) && !empty($ds['pppoe_ip'])}:{/if}
                                    {$ds['pppoe_ip']}
                                </td>
                                <td><span class="label {if $ds['status'] == 'Active'}label-success{else}label-danger{/if}">{Lang::T($ds['status'])}</span></td>
                                <td>{Lang::dateTimeFormat($ds['created_at'])}</td>
                                <td align="center">
                                    <!-- ONLY VIEW BUTTON IS VISIBLE -->
                                    <a href="{Text::url('customers/view/')}{$ds['id']}" id="{$ds['id']}"
                                        class="btn btn-success btn-xs">{Lang::T('View')}</a>
                                    
                                    <!-- Hidden buttons (kept in HTML but hidden via CSS) -->
                                    <a href="{Text::url('customers/edit/', $ds['id'], '&token=', $csrf_token)}"
                                        id="{$ds['id']}" class="btn btn-info btn-xs">{Lang::T('Edit')}</a>
                                    <a href="{Text::url('customers/sync/', $ds['id'], '&token=', $csrf_token)}"
                                        id="{$ds['id']}" class="btn btn-success btn-xs">{Lang::T('Sync')}</a>
                                    <a href="{Text::url('plan/recharge/', $ds['id'], '&token=', $csrf_token)}"
                                        id="{$ds['id']}" class="btn btn-primary btn-xs">{Lang::T('Recharge')}</a>
                                </td>
                            </tr>
                            {/foreach}
                        </tbody>
                    </table>
                    <div class="row" style="padding: 5px">
                        <div class="col-lg-12 text-right">
                            {if in_array($_admin['user_type'],['SuperAdmin','Admin'])}
                            <button type="button" id="deleteSelectedCustomers" class="btn btn-danger" style="margin-right:8px">
                                <i class="glyphicon glyphicon-trash"></i> {Lang::T('Delete_selected')}
                            </button>
                            {/if}
                            <button type="button" id="sendMessageToSelected" class="btn btn-success">
                                {Lang::T('Send Message')}
                            </button>
                        </div>
                    </div>
                </div>
                {include file="pagination.tpl"}
            </div>
        </div>
    </div>
</div>

<div id="customer-bulk-delete" class="hidden" style="display:none"
    data-url="{Text::url('customers/delete-selected')}"
    data-csrf="{$csrf_token|escape:'html'}"></div>

<!-- Modal for Sending Messages -->
<div id="sendMessageModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="sendMessageModalLabel"
    aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="sendMessageModalLabel">{Lang::T('Send Message')}</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <select id="messageType" class="form-control">
                    <option value="all">{Lang::T('All')}</option>
                    <option value="email">{Lang::T('Email')}</option>
                    <option value="inbox">{Lang::T('Inbox')}</option>
                    <option value="sms">{Lang::T('SMS')}</option>
                    <option value="wa">{Lang::T('WhatsApp')}</option>
                </select>
                <br>
                <textarea id="messageContent" class="form-control" rows="4"
                    placeholder="{Lang::T('Enter your message here...')}"></textarea>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">{Lang::T('Close')}</button>
                <button type="button" id="sendMessageButton" class="btn btn-primary">{Lang::T('Send Message')}</button>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    // Select or deselect all checkboxes
    document.getElementById('select-all').addEventListener('change', function () {
        var checkboxes = document.querySelectorAll('input[name="customer_ids[]"]');
        for (var checkbox of checkboxes) {
            checkbox.checked = this.checked;
        }
    });

    $(document).ready(function () {
        let selectedCustomerIds = [];

        $('#deleteSelectedCustomers').on('click', function () {
            selectedCustomerIds = $('input[name="customer_ids[]"]:checked').map(function () {
                return $(this).val();
            }).get();

            if (selectedCustomerIds.length === 0) {
                Swal.fire({
                    title: '{Lang::T('Error')}',
                    text: "{Lang::T('No_customers_selected_for_deletion')}",
                    icon: 'warning',
                    confirmButtonText: 'OK',
                    confirmButtonColor: '#f97316'
                });
                return;
            }

            Swal.fire({
                title: '{Lang::T('Delete_selected')}',
                text: "{Lang::T('Confirm_delete_selected_customers')}",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: '{Lang::T('Delete_selected')}',
                cancelButtonText: '{Lang::T('Cancel')}',
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#6c757d'
            }).then(function (result) {
                if (!result.isConfirmed) {
                    return;
                }
                var $meta = $('#customer-bulk-delete');
                var form = $('<form>', { method: 'POST', action: $meta.data('url') });
                form.append($('<input>', { type: 'hidden', name: 'csrf_token', value: $meta.data('csrf') }));
                selectedCustomerIds.forEach(function (id) {
                    form.append($('<input>', { type: 'hidden', name: 'customer_ids[]', value: id }));
                });
                $('body').append(form);
                form.submit();
            });
        });

        // Collect selected customer IDs when the button is clicked
        $('#sendMessageToSelected').on('click', function () {
            selectedCustomerIds = $('input[name="customer_ids[]"]:checked').map(function () {
                return $(this).val();
            }).get();

            if (selectedCustomerIds.length === 0) {
                Swal.fire({
                    title: 'Error!',
                    text: "{Lang::T('Please select at least one customer to send a message.')}",
                    icon: 'error',
                    confirmButtonText: 'OK',
                    confirmButtonColor: '#f97316'
                });
                return;
            }

            // Open the modal
            $('#sendMessageModal').modal('show');
        });

        // Handle sending the message
        $('#sendMessageButton').on('click', function () {
            const message = $('#messageContent').val().trim();
            const messageType = $('#messageType').val();

            if (!message) {
                Swal.fire({
                    title: 'Error!',
                    text: "{Lang::T('Please enter a message to send.')}",
                    icon: 'error',
                    confirmButtonText: 'OK',
                    confirmButtonColor: '#f97316'
                });
                return;
            }

            // Disable the button and show loading text
            $(this).prop('disabled', true).text('{Lang::T('Sending...')}');

            $.ajax({
                url: '?_route=message/send_bulk_selected',
                method: 'POST',
                data: {
                    customer_ids: selectedCustomerIds,
                    message_type: messageType,
                    message: message
                },
                dataType: 'json',
                success: function (response) {
                    // Handle success response
                    if (response.status === 'success') {
                        Swal.fire({
                            title: 'Success!',
                            text: "{Lang::T('Message sent successfully.')}",
                            icon: 'success',
                            confirmButtonText: 'OK',
                            confirmButtonColor: '#f97316'
                        });
                    } else {
                        Swal.fire({
                            title: 'Error!',
                            text: "{Lang::T('Error sending message: ')}" + response.message,
                            icon: 'error',
                            confirmButtonText: 'OK',
                            confirmButtonColor: '#f97316'
                        });
                    }
                    $('#sendMessageModal').modal('hide');
                    $('#messageContent').val(''); // Clear the message content
                },
                error: function () {
                    Swal.fire({
                        title: 'Error!',
                        text: "{Lang::T('Failed to send the message. Please try again.')}",
                        icon: 'error',
                        confirmButtonText: 'OK',
                        confirmButtonColor: '#f97316'
                    });
                },
                complete: function () {
                    // Re-enable the button and reset text
                    $('#sendMessageButton').prop('disabled', false).text('{Lang::T('Send Message')}');
                }
            });
        });
    });

    $(document).ready(function () {
        $('#sendMessageModal').on('show.bs.modal', function () {
            $(this).attr('inert', 'true');
        });
        $('#sendMessageModal').on('shown.bs.modal', function () {
            $('#messageContent').focus();
            $(this).removeAttr('inert');
        });
        $('#sendMessageModal').on('hidden.bs.modal', function () {
            // $('#button').focus();
        });
    });
</script>
{include file = "sections/footer.tpl"}