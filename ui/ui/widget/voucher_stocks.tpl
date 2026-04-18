<div class="panel panel-default panel-hovered mb20 activities">
    <div class="panel-heading">{Lang::T('Voucher Stocks')}</div>
    <div class="panel-body">
        <div class="row text-center" style="margin-bottom: 15px;">
            <div class="col-xs-6">
                <span class="text-muted">{Lang::T('Unused')}</span>
                <h4 class="text-success" style="margin-top: 5px;">{$stocks.unused|default:0}</h4>
            </div>
            <div class="col-xs-6">
                <span class="text-muted">{Lang::T('Used')}</span>
                <h4 class="text-info" style="margin-top: 5px;">{$stocks.used|default:0}</h4>
            </div>
        </div>
        {if isset($plans) && count($plans) > 0}
            <div class="table-responsive">
                <table class="table table-condensed table-striped mb0">
                    <thead>
                        <tr>
                            <th>{Lang::T('Plan')}</th>
                            <th class="text-right">{Lang::T('Unused')}</th>
                            <th class="text-right">{Lang::T('Used')}</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach $plans as $p}
                            <tr>
                                <td>{$p['name_plan']}</td>
                                <td class="text-right">{$p['unused']}</td>
                                <td class="text-right">{$p['used']}</td>
                            </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
        {else}
            <p class="text-muted text-center mb0">{Lang::T('No vouchers')}</p>
        {/if}
    </div>
</div>
