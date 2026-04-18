{include file="sections/header.tpl"}

<form class="form-horizontal" method="post" role="form" action="{$_url}paymentgateway/paystack">
    <div class="row">
        <div class="col-sm-12 col-md-12">
            <div class="panel panel-primary panel-hovered panel-stacked mb30">
                <div class="panel-heading">{Lang::T('Paystack Payment Gateway Configuration')}</div>
                <div class="panel-body row">
                    <div class="form-group col-md-12">
                        <label class="col-md-2 control-label">{Lang::T('Enable Paystack')}</label>
                        <div class="col-md-6">
                            <select class="form-control" name="enable_paystack" id="enable_paystack">
                                <option value="yes" {if $_c['enable_paystack'] == 'yes'}selected{/if}>{Lang::T('Yes')}</option>
                                <option value="no" {if $_c['enable_paystack'] != 'yes'}selected{/if}>{Lang::T('No')}</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group col-md-12">
                        <label class="col-md-2 control-label">{Lang::T('Paystack Public Key')}</label>
                        <div class="col-md-6">
                            <input type="text" class="form-control" name="paystack_public_key" id="paystack_public_key"
                                value="{$_c['paystack_public_key']|default:''|escape}" placeholder="pk_test_xxx or pk_live_xxx" autocomplete="off" />
                            <p class="help-block"><small>{Lang::T('Your Paystack public key (starts with pk_test_ or pk_live_)')}</small></p>
                        </div>
                    </div>

                    <div class="form-group col-md-12">
                        <label class="col-md-2 control-label">{Lang::T('Paystack Secret Key')}</label>
                        <div class="col-md-6">
                            <input type="password" class="form-control" name="paystack_secret_key" id="paystack_secret_key"
                                value="{$_c['paystack_secret_key']|default:''|escape}" placeholder="sk_test_xxx or sk_live_xxx" autocomplete="off" />
                            <p class="help-block"><small>{Lang::T('Your Paystack secret key (starts with sk_test_ or sk_live_)')}</small></p>
                        </div>
                    </div>

                    <div class="form-group col-md-12">
                        <label class="col-md-2 control-label">Callback URL</label>
                        <div class="col-md-6">
                            <input type="url" class="form-control" name="paystack_callback_url" id="paystack_callback_url"
                                value="{$_c['paystack_callback_url']|default:''|escape}" placeholder="https://..." />
                            <p class="help-block"><small>Leave empty to use the default hosted callback.</small></p>
                        </div>
                    </div>

                    <div class="form-group col-md-12">
                        <label class="col-md-2 control-label">Webhook URL</label>
                        <div class="col-md-6">
                            <input type="url" class="form-control" name="paystack_webhook_url" id="paystack_webhook_url"
                                value="{$_c['paystack_webhook_url']|default:''|escape}" placeholder="https://..." />
                            <p class="help-block"><small>{Lang::T('Add this URL to your Paystack webhook settings for automatic payment confirmation')}</small></p>
                        </div>
                    </div>

                    <div class="form-group col-md-12">
                        <div class="col-md-offset-2 col-md-6">
                            <button class="btn btn-primary btn-block" type="submit">{Lang::T('Save Changes')}</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>

{include file="sections/footer.tpl"}
