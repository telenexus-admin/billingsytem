<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{$_title} - {Lang::T('Payment Page')}</title>
    <link rel="shortcut icon" href="ui/ui/images/logo.png" type="image/x-icon" />

    <link rel="stylesheet" href="ui/ui/styles/bootstrap.min.css">
    <link rel="stylesheet" href="ui/ui/styles/modern-AdminLTE.min.css">
    <link rel="stylesheet" href="ui/ui/styles/professional-theme.css?2025.2.6" />
    <link rel="stylesheet" href="ui/ui/styles/sweetalert2.min.css" />
    <link rel="stylesheet" href="ui/ui/styles/plugins/pace.css" />
    <script src="ui/ui/scripts/sweetalert2.all.min.js"></script>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #FF5A8E, #671293, #1D004B, #FF6142);
            background-size: 400% 400%;
            animation: gradientAnimation 10s ease infinite;
            color: white;
            min-height: 100vh;
            justify-content: center;
            align-items: center;
        }

        .login-box {
            width: 95%;
            max-width: 420px;
            margin: 20px auto;
        }

        .login-box-body {
            box-sizing: border-box;
            width: 100%;
            overflow-wrap: anywhere;
        }

        @keyframes gradientAnimation {
            0% {
                background-position: 0% 50%;
            }

            50% {
                background-position: 100% 50%;
            }

            100% {
                background-position: 0% 50%;
            }
        }

        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.7);
            z-index: 9999;
            display: none;
            justify-content: center;
            align-items: center;
        }

        .loading-overlay .spinner {
            border: 16px solid #f3f3f3;
            border-radius: 50%;
            border-top: 16px solid #3498db;
            width: 120px;
            height: 120px;
            animation: spin 2s linear infinite;
        }

        .login-logo a {
            color: #f3f3f3;
        }

        @keyframes spin {
            0% {
                transform: rotate(0deg);
            }

            100% {
                transform: rotate(360deg);
            }
        }

        .radio-group {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-bottom: 10px;
        }

        .radio-label input[type="radio"] {
            position: absolute;
            opacity: 0;
            cursor: pointer;
        }

        .radio-label {
            display: inline-flex;
            align-items: center;
            cursor: pointer;
            padding: 12px 20px;
            border: 1px solid #ccc;
            border-top-left-radius: 8px;
            border-bottom-right-radius: 8px;
            background-color: #f9f9f9;
            transition: all 0.3s ease;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            position: relative;
            flex: 1;
            min-width: 120px;
            text-align: center;
            margin: 5px;
        }

        .radio-label:hover {
            border-color: #007bff;
            background-color: #e7f3ff;
            transform: scale(1.05);
        }

        .radio-label span {
            font-size: 12px;
            font-weight: 500;
            color: #333;
        }

        .radio-label input[type="radio"]+span {
            position: relative;
            padding-left: 25px;
            font-size: 14px;
            color: #333;
        }

        .radio-label input[type="radio"]+span::before {
            content: '';
            position: absolute;
            left: 0;
            top: 50%;
            transform: translateY(-50%);
            width: 16px;
            height: 16px;
            border: 2px solid #ccc;
            border-radius: 50%;
            background-color: #fff;
            transition: all 0.3s ease;
        }

        .radio-label input[type="radio"]:checked+span::before {
            border-color: #00d1b2;
            background-color: #00d1b2;
        }

        .radio-label input[type="radio"]:checked+span::after {
            content: '';
            position: absolute;
            left: 4px;
            top: 50%;
            transform: translateY(-50%);
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background-color: #fff;
        }

        .form-control {
            border-top-left-radius: 8px;
            border-top-right-radius: 0;
            border-bottom-right-radius: 8px;
            border-bottom-left-radius: 0;
        }

        .login-box-body,
        .register-box-body {
            border-top-left-radius: 25px;
            border-top-right-radius: 0;
            border-bottom-right-radius: 25px;
            border-bottom-left-radius: 0;
        }

        .error-message {
            color: red;
            font-size: 14px;
            margin-top: 5px;
        }

        @media (max-width: 767px) {
            .radio-label {
                width: 100%;
                padding: 10px 15px;
                font-size: 14px;
                margin: 0;
            }

            .radio-group {
                flex-direction: column;
                gap: 8px;
            }
        }

        /* Open in browser warning */
        #open-browser-warning {
            display: none;
            padding: 15px;
            background: rgba(0, 0, 0, 0.6);
            color: #fff;
            border-radius: 10px;
            margin: 10px 0;
            text-align: center;
        }
    </style>
</head>

<body>
    <div class="loading-overlay">
        <div class="spinner"></div>
    </div>

    <div id="open-browser-warning">
        <p>{Lang::T('For a smooth payment experience, please open this page in your browser.')}</p>
        <button class="btn btn-warning" onclick="openInBrowser()">{Lang::T('Open in Chrome/Safari')}</button>
    </div>

    <section class="content">
        {if isset($notify)}
        <script>
            document.body.style.overflow = 'hidden';
            if (typeof Swal !== 'undefined' && Swal.fire) {
                Swal.fire({
                    icon: '{if $notify_t == "s"}success{else}warning{/if}',
                    title: '{if $notify_t == "s"}Success{else}Error{/if}',
                    text: '{$notify}',
                    backdrop: 'rgba(0, 0, 0, 0.5)',
                }).then(function () {
                    document.body.style.overflow = '';
                });
            } else {
                alert('{$notify|escape:"javascript"}');
                document.body.style.overflow = '';
            }
        </script>
        {/if}

        <div class="login-box">
            <div class="login-logo">
                <a href=""><b> {$companyName}</b></a>
            </div>
            <div class="login-box-body">
                <p class="login-box-msg">{Lang::T('Make Payment')}</p>
                <form id="payment-form" action="{$_url}plugin/hotspot_pay" method="post">
                    <input type="hidden" name="routername" value="{$routername}" />
                    <input type="hidden" name="mac_address" value="{$mac}" />
                    <input type="hidden" name="ip_address" value="{$ip}" />
                    <input type="hidden" name="planid" value="{$planid}" />

                    {if $_c['hotspot_payment_type'] == 'payment_gateways'}
                    <input type="hidden" name="type" value="gateways" />
                    <label class="">{Lang::T('Payment Gateway')}</label>
                    <div class="form-group has-feedback">
                        <select name="payment_gateway" id="payment_gateway" class="form-control" required>
                            {if $payment_gateways}
                            {foreach $payment_gateways as $gateway}
                            <option value="{$gateway.value|escape}">{$gateway.name|escape}</option>
                            {/foreach}
                            {else}
                            <option value="">{Lang::T('Payment gateway is not available')}</option>
                            {/if}
                        </select>
                    </div>
                    {elseif $_c['hotspot_payment_type'] == 'payment_token'}
                    <input type="hidden" name="type" value="token" />
                    <div id="" class="form-group has-feedback">
                        <label for="token">{Lang::T('Payment Token')}</label>
                        <input type="number" class="form-control" name="payment_token" id="payment_token" required
                            placeholder="{Lang::T('Enter your token here')}">
                        <span class="glyphicon glyphicon-qrcode form-control-feedback"></span>
                    </div>
                    {else}
                    <label>{Lang::T('Tap One Method')}</label>
                    <div class="form-group radio-group">
                        <label class="radio-label">
                            <input type="radio" id="gateways" name="type" value="gateways"
                                onclick="togglePaymentFields()" required>
                            <span>{Lang::T('Payment Gateway')}</span>
                        </label>
                        <label class="radio-label">
                            <input type="radio" id="token" name="type" value="token" onclick="togglePaymentFields()"
                                required>
                            <span>{Lang::T('Payment Token')}</span>
                        </label>
                    </div>
                    <div id="payment-gateway-div" class="form-group has-feedback" style="display: none;">
                        <label>{Lang::T('Select Gateway')}</label>
                        <select name="payment_gateway" id="payment_gateway" class="form-control">
                            {if $payment_gateways}
                            {foreach $payment_gateways as $gateway}
                            <option value="{$gateway.value|escape}">{$gateway.name|escape}</option>
                            {/foreach}
                            {else}
                            <option value="">{Lang::T('Payment gateway is not available')}</option>
                            {/if}
                        </select>
                    </div>

                    <div id="token-div" class="form-group has-feedback" style="display: none;">
                        <label for="token">{Lang::T('Payment Token')}</label>
                        <input type="number" class="form-control" name="payment_token" id="payment_token"
                            placeholder="{Lang::T('Enter your token here')}">
                        <span class="glyphicon glyphicon-qrcode form-control-feedback"></span>
                    </div>
                    {/if}

                    <div id="azampay-gateway-div" class="form-group has-feedback" style="display: none;">
                        <label>{Lang::T('Azampay Channel')}</label>
                        <select name="azampay_channel" id="azampay_channel" class="form-control">
                            <option value="Airtel">Airtel</option>
                            <option value="Tigo">Tigo</option>
                            <option value="Halopesa">Halopesa</option>
                            <option value="Azampesa">Azampesa</option>
                            <option value="Mpesa">Mpesa</option>
                        </select>
                    </div>

                    <div class="form-group has-feedback">
                        <label for="phone">{Lang::T('Phone Number')}</label>
                        <input type="number" class="form-control" name="phone" id="phone" required
                            placeholder="{Lang::T('Enter your phone number here')}">
                        <span class="glyphicon glyphicon-phone-alt form-control-feedback"></span>
                    </div>

                    <label for="plan_name">{Lang::T('Package')}</label>
                    <div class="form-group has-feedback">
                        <input id="plan_name" name="plan_name" type="text" placeholder="{Lang::T('Package')}"
                            class="form-control" value="{$plan_name} ::: Validity: {$validity}" autocomplete="no"
                            readonly />
                        <span class="glyphicon glyphicon-shopping-cart form-control-feedback"></span>
                    </div>

                    <label for="amount">{Lang::T('Amount')}</label>
                    <div class="form-group has-feedback">
                        <input id="amount" name="amount" type="text" placeholder="{Lang::T('Amount')}"
                            class="form-control" value="{$amount}" autocomplete="no" readonly />
                        <span class="glyphicon glyphicon-credit-card form-control-feedback"></span>
                    </div>

                    <div class="box-body">
                        <button type="submit" id="pay-now-btn" name="pay"
                            class="btn btn-block btn-success btn-flat">{Lang::T('Pay Now')}</button>
                    </div>
                </form>
            </div>
        </div>
    </section>

    <script>
        function togglePaymentFields() {
            var gatewayDiv = document.getElementById('payment-gateway-div');
            var tokenDiv = document.getElementById('token-div');
            var azampayDiv = document.getElementById('azampay-gateway-div');
            var paymentGatewaySelect = document.getElementById('payment_gateway');
            var gatewaysRadio = document.getElementById('gateways');
            var tokenRadio = document.getElementById('token');

            if (gatewaysRadio && gatewaysRadio.checked) {
                gatewayDiv.style.display = 'block';
                tokenDiv.style.display = 'none';
                azampayDiv.style.display = (paymentGatewaySelect && paymentGatewaySelect.value === 'azampay') ? 'block' : 'none';
            } else if (tokenRadio && tokenRadio.checked) {
                gatewayDiv.style.display = 'none';
                tokenDiv.style.display = 'block';
                azampayDiv.style.display = 'none';
            } else {
                // Fixed gateway/token mode: keep optional sections hidden.
                if (gatewayDiv) gatewayDiv.style.display = 'none';
                if (tokenDiv) tokenDiv.style.display = 'none';
                if (azampayDiv) azampayDiv.style.display = 'none';
            }
        }

        var paymentGatewayEl = document.getElementById('payment_gateway');
        var gatewaysEl = document.getElementById('gateways');
        var tokenEl = document.getElementById('token');
        if (paymentGatewayEl) {
            paymentGatewayEl.addEventListener('change', togglePaymentFields);
        }
        if (gatewaysEl) {
            gatewaysEl.addEventListener('change', togglePaymentFields);
        }
        if (tokenEl) {
            tokenEl.addEventListener('change', togglePaymentFields);
        }
        togglePaymentFields();
    </script>

    <script>
        function isInWebView() {
            var ua = navigator.userAgent || navigator.vendor || window.opera;
            return (/(iPhone|iPod|iPad).*AppleWebKit(?!.*Safari)/i.test(ua)) ||
                (/Android.*(wv|Version\/[\d\.]+).*Chrome/i.test(ua));
        }

        function openInBrowser() {
            var currentUrl = window.location.href;
            if (/Android/i.test(navigator.userAgent)) {
                window.location = "intent://" + currentUrl.replace(/^https?:\/\//, '') + "#Intent;scheme=https;package=com.android.chrome;end";
            } else if (/iPhone|iPad|iPod/i.test(navigator.userAgent)) {
                if (typeof Swal !== 'undefined' && Swal.fire) {
                    Swal.fire({
                        icon: 'info',
                        title: 'Open in Safari',
                        html: 'Please click <b>Share</b> and choose <b>Open in Safari</b> to complete the payment.',
                        confirmButtonText: 'OK'
                    });
                } else {
                    alert('Please click Share and choose Open in Safari to complete the payment.');
                }
            }
        }

        if (isInWebView()) {
            document.getElementById('open-browser-warning').style.display = 'block';
        }
    </script>

    <script src="ui/ui/scripts/jquery.min.js"></script>
    <script src="ui/ui/scripts/bootstrap.min.js"></script>
    <script src="ui/ui/scripts/adminlte.min.js"></script>
    <script src="ui/ui/scripts/plugins/select2.min.js"></script>
    <script src="ui/ui/scripts/pace.min.js"></script>
    <script src="ui/ui/scripts/custom.js"></script>
    <script>
        $(document).ready(function () {
            $("#payment-form").on("submit", function (event) {
                $(".loading-overlay").css("display", "flex");
            });
        });
    </script>

</body>

</html>