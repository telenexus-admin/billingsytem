{include file="sections/header.tpl"}

{if isset($message)}
<div class="alert alert-{if $notify_t == 's'}success{else}danger{/if}">
    <button type="button" class="close" data-dismiss="alert">
        <span aria-hidden="true">×</span>
    </button>
    <div>{$message}</div>
</div>
{/if}

<form class="form-horizontal" method="post" autocomplete="off" role="form" action="">
    <div class="row">
        <div class="col-sm-12 col-md-12">
            <div class="panel panel-primary panel-hovered panel-stacked mb30">
                <div class="panel-heading">Hotspot PayStack Payment Settings</div>
                <div class="panel-body">
                    <div class="form-group">
                        <label class="col-md-2 control-label">Paystack Secret Key</label>
                        <div class="col-md-6">
                            <input type="text" class="form-control" id="hotspot_paystack_secret_key"
                                name="hotspot_paystack_secret_key" value="{$_c['hotspot_paystack_secret_key']}">
                            <a href="https://dashboard.paystack.co/#/settings/developer" target="_blank"
                                class="help-block">https://dashboard.paystack.co/#/settings/developer</a>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-2 control-label">Webhook Url</label>
                        <div class="col-md-6">
                            <input type="text" readonly class="form-control" onclick="this.select()"
                                value="{$_url}plugin/hotspot_payment_gateway_paystack_webhook">
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-lg-offset-2 col-lg-10">
                            <button class="btn btn-primary waves-effect waves-light" name="save" value="save"
                                type="submit">{Lang::T('Save')}</button>
                        </div>
                    </div>
                    <div class="bs-callout bs-callout-info" id="callout-navbar-role">
                        <h4>Paystack Settings in Mikrotik</h4>
                        /ip hotspot walled-garden <br>
                        add dst-host=*.paystack.com <br>
                        add dst-host=*.paystack.co <br><br>
                        <small class="form-text text-muted">Set Telegram Bot to get any error and
                            notification</small>

                    </div>
                </div>
            </div>

        </div>
    </div>
</form>
{include file="sections/footer.tpl"}