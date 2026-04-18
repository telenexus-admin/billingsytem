<?php

/**
 * Paystack Payment Gateway
 * Simplified integration for PHPNuxBill
 * 
 * Auto-configures on first load - no manual setup required!
 */

// Auto-load installer and configure if needed
if (file_exists(__DIR__ . '/paystack_install.php')) {
    require_once __DIR__ . '/paystack_install.php';
}

function paystack_validate_config($gateway = null)
{
    global $config;
    if (empty($config['paystack_secret_key']) && empty($config['hotspot_paystack_secret_key'])) {
        sendTelegram("Paystack Gateway: Secret Key is not set");
        return false;
    }
    return true;
}

/**
 * Main Paystack secret and optional Hotspot-specific secret (CreateHotspotUser / captive).
 *
 * @return list<string>
 */
function paystack_collect_secret_keys()
{
    global $config;
    $keys = [];
    foreach (['paystack_secret_key', 'hotspot_paystack_secret_key'] as $k) {
        $v = isset($config[$k]) ? trim((string) $config[$k]) : '';
        if ($v !== '' && !in_array($v, $keys, true)) {
            $keys[] = $v;
        }
    }
    return $keys;
}

function paystack_show_config()
{
    global $ui, $config;
    $ui->assign('_title', 'Paystack Gateway');
    $ui->assign('_c', $config);
    $ui->display('paystack.tpl');
}

function paystack_save_config()
{
    global $admin, $config;

    $paystack_secret_key = _post('paystack_secret_key');
    $paystack_public_key = _post('paystack_public_key');
    $paystack_callback_url = _post('paystack_callback_url');
    $paystack_webhook_url = _post('paystack_webhook_url');
    $enable_paystack = _post('enable_paystack') === 'yes' ? 'yes' : 'no';

    // Save Secret Key
    $d = ORM::for_table('tbl_appconfig')->where('setting', 'paystack_secret_key')->find_one();
    if ($d) {
        $d->value = $paystack_secret_key;
        $d->save();
    } else {
        $d = ORM::for_table('tbl_appconfig')->create();
        $d->setting = 'paystack_secret_key';
        $d->value = $paystack_secret_key;
        $d->save();
    }

    // Save Public Key
    $d = ORM::for_table('tbl_appconfig')->where('setting', 'paystack_public_key')->find_one();
    if ($d) {
        $d->value = $paystack_public_key;
        $d->save();
    } else {
        $d = ORM::for_table('tbl_appconfig')->create();
        $d->setting = 'paystack_public_key';
        $d->value = $paystack_public_key;
        $d->save();
    }

    // Save Enable Paystack
    $d = ORM::for_table('tbl_appconfig')->where('setting', 'enable_paystack')->find_one();
    if ($d) {
        $d->value = $enable_paystack;
        $d->save();
    } else {
        $d = ORM::for_table('tbl_appconfig')->create();
        $d->setting = 'enable_paystack';
        $d->value = $enable_paystack;
        $d->save();
    }

    // Save Callback URL (with default fallback)
    if (empty($paystack_callback_url)) {
        $paystack_callback_url = 'https://phpnuxbill-webhooks.vercel.app/webhook/paystack';
    }
    $d = ORM::for_table('tbl_appconfig')->where('setting', 'paystack_callback_url')->find_one();
    if ($d) {
        $d->value = $paystack_callback_url;
        $d->save();
    } else {
        $d = ORM::for_table('tbl_appconfig')->create();
        $d->setting = 'paystack_callback_url';
        $d->value = $paystack_callback_url;
        $d->save();
    }

    // Save Webhook URL (default to this app's webhook endpoint)
    if (empty($paystack_webhook_url)) {
        $paystack_webhook_url = (defined('APP_URL') ? APP_URL : '') . '/?_route=webhook/paystack';
    }
    $d = ORM::for_table('tbl_appconfig')->where('setting', 'paystack_webhook_url')->find_one();
    if ($d) {
        $d->value = $paystack_webhook_url;
        $d->save();
    } else {
        $d = ORM::for_table('tbl_appconfig')->create();
        $d->setting = 'paystack_webhook_url';
        $d->value = $paystack_webhook_url;
        $d->save();
    }

    _log('[' . $admin['username'] . ']: Paystack Gateway Config Saved', 'Admin', $admin['id']);
    r2(U . 'paymentgateway/paystack', 's', 'Paystack Gateway configuration saved successfully');
}

function paystack_get_gateway_url()
{
    return 'https://api.paystack.co';
}

function paystack_payment($trx, $user)
{
    global $config;

    if (!paystack_validate_config('paystack')) {
        return false;
    }

    $secret_key = $config['paystack_secret_key'];
    $callback_url = !empty($config['paystack_callback_url'])
        ? $config['paystack_callback_url']
        : 'https://phpnuxbill-webhooks.vercel.app/webhook/paystack';

    // For local/direct callback, use proper PHPNuxBill routing format
    $direct_callback = U . 'callback/paystack';

    $amount = $trx['price'] * 100; // Convert to kobo (smallest currency unit)
    $email = $user['email'];
    $reference = $trx['id'] . '_' . time();

    $url = "https://api.paystack.co/transaction/initialize";

    $fields = [
        'email' => $email,
        'amount' => $amount,
        'reference' => $reference,
        'callback_url' => $direct_callback . '&trxref=' . $reference,
        'metadata' => [
            'custom_fields' => [
                [
                    'display_name' => 'Username',
                    'variable_name' => 'username',
                    'value' => $user['username']
                ],
                [
                    'display_name' => 'Plan',
                    'variable_name' => 'plan_name',
                    'value' => $trx['plan_name']
                ]
            ]
        ]
    ];

    $fields_string = json_encode($fields);

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $fields_string);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "Authorization: Bearer " . $secret_key,
        "Cache-Control: no-cache",
        "Content-Type: application/json"
    ]);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

    $result = curl_exec($ch);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

    if (curl_errno($ch)) {
        sendTelegram("Paystack Error: " . curl_error($ch));
        return false;
    }

    $response = json_decode($result, true);

    if (isset($response['status']) && $response['status'] && isset($response['data']['authorization_url'])) {
        // Update transaction with Paystack reference
        $trx_update = ORM::for_table('tbl_payment_gateway')->find_one($trx['id']);
        if ($trx_update) {
            $trx_update->gateway_trx_id = $reference;
            $trx_update->pg_url_payment = $response['data']['authorization_url'];
            $trx_update->pg_request = json_encode($fields);
            $trx_update->save();
        }

        return $response['data']['authorization_url'];
    }

    sendTelegram("Paystack Error: " . json_encode($response));
    return false;
}

function paystack_create_transaction($trx, $user)
{
    global $config, $ui;

    if (!paystack_validate_config('paystack')) {
        r2(getUrl('order/package'), 'e', 'Paystack is not properly configured. Please contact admin.');
    }

    $paystack_url = paystack_payment($trx, $user);

    if ($paystack_url) {
        // Redirect to Paystack checkout
        header('Location: ' . $paystack_url);
        exit();
    } else {
        r2(getUrl('order/view/' . $trx['id']), 'e', 'Failed to initialize Paystack payment. Please try again.');
    }
}

/**
 * Render beautiful success page for payment callback
 */
function renderPaymentSuccess($transaction, $paystackData)
{
    $amount = number_format($transaction->price, 2);
    $currency = $transaction->gateway ?? 'NGN';
    $reference = $transaction->gateway_trx_id ?? 'N/A';
    $email = $paystackData['customer']['email'] ?? 'N/A';
    $paymentMethod = ucwords($paystackData['channel'] ?? 'Card');
    if (isset($paystackData['authorization']['last4'])) {
        $paymentMethod .= ' •••• ' . $paystackData['authorization']['last4'];
    }
    $paidAt = date('M d, Y, g:i A', strtotime($transaction->paid_date));
    $orderUrl = U . 'order/view/' . $transaction->id;
    $homeUrl = U . 'home';

    $currencySymbol = ($currency === 'NGN') ? '₦' : $currency;

    return <<<HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Payment Successful - PHPNuxBill</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
      background: #f1f1f1;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 40px 20px;
    }
    .container {
      background: white;
      border-radius: 12px;
      box-shadow: 0 4px 20px rgba(0,0,0,0.1);
      max-width: 720px;
      width: 100%;
      overflow: hidden;
      animation: slideUp 0.4s ease-out;
    }
    @keyframes slideUp {
      from { opacity: 0; transform: translateY(30px); }
      to { opacity: 1; transform: translateY(0); }
    }
    .header {
      background: #fff;
      padding: 40px 40px 25px;
      text-align: center;
      border-bottom: 2px solid #f1f1f1;
    }
    .checkmark {
      width: 60px;
      height: 60px;
      border-radius: 50%;
      background: #22c55e;
      margin: 0 auto 16px;
      display: flex;
      align-items: center;
      justify-content: center;
      animation: scaleIn 0.5s ease-out 0.2s both;
    }
    @keyframes scaleIn {
      from { transform: scale(0); }
      to { transform: scale(1); }
    }
    .checkmark svg {
      width: 32px;
      height: 32px;
      stroke: white;
      stroke-width: 3;
      fill: none;
      stroke-linecap: round;
      stroke-linejoin: round;
      stroke-dasharray: 50;
      stroke-dashoffset: 50;
      animation: drawCheck 0.5s ease-out 0.4s forwards;
    }
    @keyframes drawCheck {
      to { stroke-dashoffset: 0; }
    }
    .header h1 {
      font-size: 28px;
      font-weight: 700;
      margin-bottom: 8px;
      color: #1f2937;
    }
    .header p {
      font-size: 15px;
      color: #6b7280;
    }
    .content {
      padding: 35px 40px;
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 30px;
      align-items: start;
    }
    .amount {
      text-align: center;
      padding: 35px 20px;
      background: #22c55e;
      border-radius: 8px;
      display: flex;
      flex-direction: column;
      justify-content: center;
      height: 100%;
      box-shadow: 0 2px 8px rgba(34, 197, 94, 0.2);
    }
    .amount-label {
      font-size: 12px;
      color: rgba(255,255,255,0.9);
      margin-bottom: 12px;
      text-transform: uppercase;
      letter-spacing: 1.5px;
      font-weight: 600;
    }
    .amount-value {
      font-size: 40px;
      font-weight: 800;
      color: white;
    }
    .details {
      background: #fff;
      border: 1px solid #e5e7eb;
      border-radius: 8px;
      padding: 0;
    }
    .detail-row {
      display: flex;
      justify-content: space-between;
      padding: 16px 20px;
      border-bottom: 1px solid #f3f4f6;
      gap: 20px;
    }
    .detail-row:last-child {
      border-bottom: none;
    }
    .detail-label {
      color: #6b7280;
      font-size: 14px;
      font-weight: 600;
      white-space: nowrap;
    }
    .detail-value {
      color: #1f2937;
      font-weight: 600;
      font-size: 14px;
      text-align: right;
      overflow: hidden;
      text-overflow: ellipsis;
    }
    .reference {
      font-family: 'Courier New', monospace;
      background: #f3f4f6;
      padding: 5px 10px;
      border-radius: 4px;
      font-size: 13px;
      color: #374151;
    }
    .actions {
      grid-column: 1 / -1;
      display: flex;
      gap: 12px;
      margin-top: 10px;
    }
    .btn {
      flex: 1;
      padding: 16px 24px;
      border-radius: 8px;
      font-size: 15px;
      font-weight: 700;
      text-decoration: none;
      text-align: center;
      cursor: pointer;
      border: none;
      transition: all 0.3s ease;
      display: inline-flex;
      align-items: center;
      justify-content: center;
    }
    .btn-primary {
      background: #3b82f6;
      color: white;
      box-shadow: 0 2px 8px rgba(59, 130, 246, 0.3);
    }
    .btn-primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(59, 130, 246, 0.4);
      background: #2563eb;
    }
    .btn-secondary {
      background: white;
      color: #6b7280;
      border: 2px solid #e5e7eb;
    }
    .btn-secondary:hover {
      background: #f9fafb;
    }
    .footer {
      text-align: center;
      padding: 20px;
      color: #9ca3af;
      font-size: 13px;
      background: #fafafa;
      border-top: 1px solid #f3f4f6;
      font-weight: 500;
    }
    @media (max-width: 640px) {
      .content {
        grid-template-columns: 1fr;
      }
      body {
        padding: 20px;
      }
      .header {
        padding: 30px 20px 20px;
      }
      .content {
        padding: 25px 20px;
      }
      .amount-value {
        font-size: 32px;
      }
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <div class="checkmark">
        <svg viewBox="0 0 52 52">
          <polyline points="14 27 22 35 38 19"/>
        </svg>
      </div>
      <h1>Payment Successful!</h1>
      <p>Your transaction has been completed</p>
    </div>
    
    <div class="content">
      <div class="amount">
        <div class="amount-label">Amount Paid</div>
        <div class="amount-value">{$currencySymbol}{$amount}</div>
      </div>
      
      <div class="details">
        <div class="detail-row">
          <span class="detail-label">Reference</span>
          <span class="detail-value reference">{$reference}</span>
        </div>
        <div class="detail-row">
          <span class="detail-label">Plan</span>
          <span class="detail-value">{$transaction->plan_name}</span>
        </div>
        <div class="detail-row">
          <span class="detail-label">Payment Method</span>
          <span class="detail-value">{$paymentMethod}</span>
        </div>
        <div class="detail-row">
          <span class="detail-label">Date & Time</span>
          <span class="detail-value">{$paidAt}</span>
        </div>
      </div>
      
      <div class="actions">
        <a href="{$orderUrl}" class="btn btn-primary">View Order Details</a>
        <a href="{$homeUrl}" class="btn btn-secondary">Back to Dashboard</a>
      </div>
    </div>
    
    <div class="footer">
      Powered by PHPNuxBill × Paystack
    </div>
  </div>
</body>
</html>
HTML;
}

/**
 * Render error page for failed payments
 */
function renderPaymentError($title, $message)
{
    $homeUrl = U . 'order/history';

    return <<<HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Payment Failed - PHPNuxBill</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      background: #f1f1f1;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 40px 20px;
    }
    .container {
      background: white;
      border-radius: 12px;
      box-shadow: 0 4px 20px rgba(0,0,0,0.1);
      max-width: 500px;
      width: 100%;
      padding: 50px 40px;
      text-align: center;
    }
    .error-icon {
      width: 70px;
      height: 70px;
      border-radius: 50%;
      background: #ef4444;
      margin: 0 auto 20px;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .error-icon svg {
      width: 40px;
      height: 40px;
      stroke: white;
      stroke-width: 3;
    }
    h1 {
      font-size: 24px;
      color: #1f2937;
      margin-bottom: 12px;
      font-weight: 700;
    }
    p {
      font-size: 15px;
      color: #6b7280;
      margin-bottom: 30px;
      line-height: 1.6;
    }
    .btn {
      display: inline-block;
      padding: 14px 28px;
      background: #ef4444;
      color: white;
      text-decoration: none;
      border-radius: 8px;
      font-weight: 700;
      font-size: 15px;
      transition: transform 0.2s;
      box-shadow: 0 2px 8px rgba(239, 68, 68, 0.2);
    }
    .btn:hover {
      transform: translateY(-2px);
      background: #dc2626;
      box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="error-icon">
      <svg viewBox="0 0 24 24" fill="none">
        <path d="M6 18L18 6M6 6l12 12" stroke="currentColor" stroke-linecap="round"/>
      </svg>
    </div>
    <h1>{$title}</h1>
    <p>{$message}</p>
    <a href="{$homeUrl}" class="btn">Return to Orders</a>
  </div>
</body>
</html>
HTML;
}

/**
 * Payment Notification Handler for Paystack Webhook/Callback
 * - GET with trxref/reference = customer redirect after payment (callback URL).
 * - POST with JSON body = server-to-server webhook (verify x-paystack-signature).
 */
function paystack_payment_notification()
{
    global $config;

    $is_user_callback = $_SERVER['REQUEST_METHOD'] === 'GET';

    _log('[Paystack] Payment notification received - Method: ' . $_SERVER['REQUEST_METHOD'], 'Paystack');

    $reference = isset($_GET['trxref']) ? $_GET['trxref'] : (isset($_GET['reference']) ? $_GET['reference'] : null);
    $input = '';

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $input = @file_get_contents("php://input");
        if ($input === false) {
            $input = '';
        }

        // Verify Paystack webhook signature (HMAC SHA512 of raw body) — try main + hotspot keys
        $signature = isset($_SERVER['HTTP_X_PAYSTACK_SIGNATURE']) ? $_SERVER['HTTP_X_PAYSTACK_SIGNATURE'] : '';
        $secrets = paystack_collect_secret_keys();
        if ($signature !== '' && $secrets) {
            $valid = false;
            foreach ($secrets as $sec) {
                if (hash_equals(hash_hmac('sha512', $input, $sec), $signature)) {
                    $valid = true;
                    break;
                }
            }
            if (!$valid) {
                _log('[Paystack] Webhook signature verification failed', 'Paystack');
                http_response_code(400);
                header('Content-Type: application/json');
                echo json_encode(['error' => 'Invalid signature']);
                exit;
            }
        }

        $event = json_decode($input, true);
        if (is_array($event) && isset($event['data']['reference'])) {
            $reference = $event['data']['reference'];
        }
    }

    if (!$reference) {
        _log('[Paystack] No reference provided in notification', 'Paystack');

        if ($is_user_callback) {
            echo renderPaymentError('No payment reference found', 'Please contact support if you believe this is an error.');
            exit;
        }

        http_response_code(400);
        die('No reference');
    }

    _log('[Paystack] Processing payment for reference: ' . $reference, 'Paystack');

    $secrets = paystack_collect_secret_keys();
    if (!$secrets) {
        _log('[Paystack] No secret keys configured', 'Paystack');
        if ($is_user_callback) {
            echo renderPaymentError('Configuration Error', 'Paystack is not configured.');
            exit;
        }
        http_response_code(500);
        die('Not configured');
    }

    $url = "https://api.paystack.co/transaction/verify/" . rawurlencode($reference);
    $result = null;
    $http_code = 0;
    foreach ($secrets as $secret_key) {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            "Authorization: Bearer " . $secret_key,
            "Cache-Control: no-cache"
        ]);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

        $response = curl_exec($ch);
        $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        if ($http_code !== 200) {
            continue;
        }
        $decoded = json_decode($response, true);
        if (is_array($decoded) && isset($decoded['data']['status']) && $decoded['data']['status'] === 'success') {
            $result = $decoded;
            break;
        }
    }

    if ($http_code !== 200 || !is_array($result)) {
        _log('[Paystack] Verification failed with HTTP code: ' . $http_code, 'Paystack');

        if ($is_user_callback) {
            echo renderPaymentError('Payment Verification Failed', 'Unable to verify your payment with Paystack. Please contact support.');
            exit;
        }

        http_response_code(400);
        die('Verification failed');
    }

    if (!isset($result['data']) || $result['data']['status'] !== 'success') {
        _log('[Paystack] Payment not successful: ' . json_encode($result), 'Paystack');

        if ($is_user_callback) {
            echo renderPaymentError('Payment Not Successful', 'Your payment was not completed successfully. Please try again.');
            exit;
        }

        http_response_code(400);
        die('Payment not successful');
    }

    // Find transaction in payment gateway table (standard PHPNuxBill table)
    $transaction = ORM::for_table('tbl_payment_gateway')
        ->where('gateway_trx_id', $reference)
        ->find_one();

    if (!$transaction) {
        // Try alternative lookup
        $transaction = ORM::for_table('tbl_payment_gateway')
            ->where('routers_id', $reference)
            ->find_one();

        if (!$transaction) {
            // Extract just the ID part before underscore
            $id_part = explode('_', $reference)[0];
            $transaction = ORM::for_table('tbl_payment_gateway')
                ->where('id', $id_part)
                ->find_one();

            if (!$transaction) {
                $hotspotTrx = ORM::for_table('tbl_hotspot_payments')
                    ->where('transaction_ref', $reference)
                    ->find_one();

                if ($hotspotTrx && function_exists('hotspot_paystack_complete_transaction')) {
                    if ($hotspotTrx->transaction_status !== 'paid') {
                        hotspot_paystack_complete_transaction($hotspotTrx, $result['data']);
                    }
                    if ($is_user_callback) {
                        header('Location: ' . U . 'plugin/hotspot_verify&reference=' . rawurlencode($reference));
                        exit;
                    }

                    echo 'Hotspot payment processed';
                    exit;
                }

                _log('[Paystack] Transaction not found for reference: ' . $reference, 'Paystack');

                if ($is_user_callback) {
                    echo renderPaymentError('Transaction Not Found', 'We could not find your transaction. Please contact support with reference: ' . $reference);
                    exit;
                }

                http_response_code(404);
                die('Transaction not found');
            }
        }
    }

    // Check if already processed
    if ($transaction->status == 2) {
        _log('[Paystack] Transaction already processed: ' . $reference, 'Paystack');

        if ($is_user_callback) {
            // Show success page for already processed transaction
            echo renderPaymentSuccess($transaction, $result['data']);
            exit;
        }

        echo 'Already processed';
        exit;
    }

    $customer = ORM::for_table('tbl_customers')
        ->where('username', $transaction->username)
        ->order_by_desc('id')
        ->find_one();
    $paystackRef = $result['data']['reference'] ?? $reference;
    $activated = false;
    if ($customer) {
        try {
            $activated = (bool) Package::rechargeUser(
                (int) $customer->id,
                $transaction->routers,
                $transaction->plan_id,
                $transaction->gateway ?: 'paystack',
                'Paystack',
                '',
                $paystackRef
            );
        } catch (Throwable $e) {
            _log('[Paystack] Package::rechargeUser error: ' . $e->getMessage(), 'Paystack');
            $activated = false;
        }
    } else {
        _log('[Paystack] Customer not found for username: ' . $transaction->username, 'Paystack');
    }

    if (!$activated && $customer) {
        _log('[Paystack] Paystack payment OK but package activation failed (reference: ' . $reference . ')', 'Paystack');
    }

    // Mark paid once Paystack confirms funds — captive portal polls tbl_payment_gateway.status; activation may still need retry/sync.
    $transaction->status = 2;
    $transaction->paid_date = date('Y-m-d H:i:s');
    $payload = $result['data'];
    if (is_array($payload) && !$activated) {
        $payload['billing_activation_failed'] = true;
    }
    $transaction->pg_paid_response = is_array($payload) ? json_encode($payload) : json_encode($result['data']);

    try {
        $transaction->save();
        _log('[Paystack] Payment recorded for reference: ' . $reference . ($activated ? '' : ' (activation failed)'), 'Paystack');

        if ($is_user_callback) {
            echo renderPaymentSuccess($transaction, $result['data']);
            exit;
        }

        echo 'Payment processed successfully';
    } catch (Exception $e) {
        _log('[Paystack] Failed to save transaction: ' . $e->getMessage(), 'Paystack');

        if ($is_user_callback) {
            echo renderPaymentError('Failed to Process Payment', 'An error occurred while processing your payment. Please contact support.');
            exit;
        }

        http_response_code(500);
        die('Failed to save transaction');
    }
}

function paystack_get_status($trx, $user)
{
    global $config, $ui;

    if (!paystack_validate_config('paystack')) {
        r2(U . 'order/package', 'e', 'Paystack configuration error');
        return;
    }

    // If transaction is already paid, show success page
    if ($trx['status'] == 2) {
        $ui->assign('_title', 'Payment Status - Paid');
        $ui->assign('_system_menu', 'order');
        $ui->assign('trx', $trx);
        $ui->assign('user', $user);

        // Get router info if available
        if ($trx['routers_id']) {
            $router = ORM::for_table('tbl_routers')->find_one($trx['routers_id']);
            $ui->assign('router', $router);
        }

        $ui->display('customer/orderView.tpl');
        return;
    }

    // Get reference from transaction
    $reference = $trx['gateway_trx_id'];
    if (empty($reference)) {
        // Try to extract from routers_id field if it contains reference
        $reference = $trx['routers_id'];
    }

    if (empty($reference)) {
        r2(U . 'order/view/' . $trx['id'], 'e', 'No transaction reference found');
        return;
    }

    _log('[Paystack] Checking payment status for reference: ' . $reference, 'Paystack');

    // Verify with Paystack API
    $secret_key = $config['paystack_secret_key'];
    $url = "https://api.paystack.co/transaction/verify/" . $reference;

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Authorization: Bearer ' . $secret_key
    ]);

    $response = curl_exec($ch);

    if (curl_errno($ch)) {
        _log('[Paystack] CURL Error: ' . curl_error($ch), 'Paystack');
        curl_close($ch);
        r2(U . 'order/view/' . $trx['id'], 'e', 'Failed to verify payment with Paystack');
        return;
    }

    curl_close($ch);

    $result = json_decode($response, true);
    _log('[Paystack] Verification response: ' . $response, 'Paystack');

    if (!$result || !$result['status']) {
        $error_message = isset($result['message']) ? $result['message'] : 'Payment verification failed';
        _log('[Paystack] Verification failed: ' . $error_message, 'Paystack');
        r2(U . 'order/view/' . $trx['id'], 'e', $error_message);
        return;
    }

    $data = $result['data'];

    // Check if payment was successful
    if ($data['status'] == 'success') {
        _log('[Paystack] Payment verified successfully. Updating transaction.', 'Paystack');

        // Update transaction status
        $transaction = ORM::for_table('tbl_payment_gateway')->find_one($trx['id']);
        $transaction->status = 2; // Paid
        $transaction->paid_date = date('Y-m-d H:i:s');
        $transaction->pg_paid_response = json_encode($data);
        $transaction->save();

        r2(U . 'order/view/' . $trx['id'], 's', 'Payment verified successfully!');
    } else {
        _log('[Paystack] Payment status: ' . $data['status'], 'Paystack');
        r2(U . 'order/view/' . $trx['id'], 'w', 'Payment status: ' . ucfirst($data['status']));
    }
}
