{include file="sections/header.tpl"}
<!-- pool -->
<div class="row">
    <div class="col-sm-12">
        <div class="panel panel-hovered mb20 panel-primary">
            <div class="panel-heading">
                {if in_array($_admin['user_type'],['SuperAdmin','Admin'])}
                    <div class="btn-group pull-right">
                        <button type="submit" form="logs-multidelete-form" class="btn btn-danger btn-xs" id="logs-delete-selected-btn">
                            <span class="glyphicon glyphicon-trash" aria-hidden="true"></span> {Lang::T('Delete selected')}
                        </button>
                        <a class="btn btn-primary btn-xs" title="save" href="{Text::url('logs/list-csv')}"
                            onclick="return ask(this, '{Lang::T('This will export to CSV')}?')"><span class="glyphicon glyphicon-download"
                                aria-hidden="true"></span> CSV</a>
                    </div>
                {/if}
                {Lang::T('Activity Log')}
            </div>
            <div class="panel-body">
                <div class="text-center" style="padding: 15px">
                    <div class="col-md-4">
                        <form id="site-search" method="post" action="{Text::url('logs/list/')}">
                            <div class="input-group">
                                <div class="input-group-addon">
                                    <span class="fa fa-search"></span>
                                </div>
                                <input type="text" name="q" class="form-control" value="{$q}"
                                    placeholder="{Lang::T('Search by Name')}...">
                                <div class="input-group-btn">
                                    <button class="btn btn-success" type="submit">{Lang::T('Search')}</button>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="col-md-8">
                        <form class="form-inline" method="post" action="{Text::url('')}logs/list/">
                            <div class="input-group has-error">
                                <span class="input-group-addon">{Lang::T('Keep Logs')} </span>
                                <input type="text" name="keep" class="form-control" placeholder="90" value="90">
                                <span class="input-group-addon">{Lang::T('Days')}</span>
                            </div>
                            <button type="submit" class="btn btn-danger btn-sm"
                                onclick="return ask(this, '{Lang::T("Clear old logs?")}')">{Lang::T('Clean up Logs')}</button>
                        </form>
                    </div>&nbsp;
                </div>
                <br>
                <form id="logs-multidelete-form" method="post" action="{Text::url('logs/delete-selected')}">
                    <input type="hidden" name="csrf_token" value="{$csrf_token}">
                    <input type="hidden" name="return_q" value="{$q|escape:'html'}">
                <div class="table-responsive">
                    <table class="table table-bordered table-striped table-condensed">
                        <thead>
                            <tr>
                                {if in_array($_admin['user_type'],['SuperAdmin','Admin'])}
                                    <th style="width:36px;" class="text-center">
                                        <input type="checkbox" id="select-all-logs" title="{Lang::T('Select all on this page')}">
                                    </th>
                                {/if}
                                <th>{Lang::T('ID')}</th>
                                <th>{Lang::T('Date')}</th>
                                <th>{Lang::T('Type')}</th>
                                <th>{Lang::T('IP')}</th>
                                <th>{Lang::T('Description')}</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach $d as $ds}
                                <tr>
                                    {if in_array($_admin['user_type'],['SuperAdmin','Admin'])}
                                        <td class="text-center">
                                            <input type="checkbox" name="log_ids[]" value="{$ds['id']}" class="log-row-check">
                                        </td>
                                    {/if}
                                    <td>{$ds['id']}</td>
                                    <td>{Lang::dateTimeFormat($ds['date'])}</td>
                                    <td>{$ds['type']}</td>
                                    <td>{$ds['ip']}</td>
                                    <td style="overflow-x: scroll;">{nl2br($ds['description'])}</td>
                                </tr>
                            {/foreach}
                        </tbody>
                    </table>
                </div>
                </form>
                {include file="pagination.tpl"}
            </div>
        </div>
    </div>
</div>

{if in_array($_admin['user_type'],['SuperAdmin','Admin'])}
<script>
(function () {
    var all = document.getElementById('select-all-logs');
    var form = document.getElementById('logs-multidelete-form');
    if (!form) return;
    var msgNone = {$logs_js_no_selection|default:'""'};
    var msgConfirm = {$logs_js_confirm_delete|default:'""'};
    if (all) {
        all.addEventListener('change', function () {
            document.querySelectorAll('.log-row-check').forEach(function (cb) {
                cb.checked = all.checked;
            });
        });
    }
    form.addEventListener('submit', function (e) {
        var n = document.querySelectorAll('.log-row-check:checked').length;
        if (n < 1) {
            e.preventDefault();
            alert(msgNone);
            return;
        }
        if (!window.confirm(msgConfirm)) {
            e.preventDefault();
        }
    });
})();
</script>
{/if}

{include file="sections/footer.tpl"}
