<?php
/**
 * Bismillahir Rahmanir Raheem
 * 
 * PHP Mikrotik Billing (https://github.com/paybilling/phpnuxbill/)
 *
 * Hotspot Token For Advanced Hotspot System 
 *
 * @author: Focuslinks Digital Solutions <focuslinkstech@gmail.com>
 * Website: https://focuslinkstech.com.ng/
 * GitHub: https://github.com/Focuslinkstech/
 * Telegram: https://t.me/focuslinkstech/
 *
 **/

register_menu(" Hotspot Payment Token", true, "hotspot_token", 'AFTER_MESSAGE', 'glyphicon glyphicon-qrcode', '', "");

function hotspot_token()
{
    global $ui, $_app_stage;
    _admin();
    $ui->assign('_title', 'Hotspot Tokens');
    $ui->assign('_system_menu', '');
    $admin = Admin::_info();
    $ui->assign('_admin', $admin);

    if (!hotspot_engine()) {
        hotspot_install();
        exit;
    }
    hotspot_token_installDB();

    if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin', 'Sales'])) {
        _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
        exit;
    }
    $search = _post('search');
    $filter = _post('filter', 'none');

    if (_post('generate', '') == 'token') {
        if (app_is_demo_restricted()) {
            r2($_SERVER['HTTP_REFERER'], 'e', Lang::T('You cannot perform this action in Demo mode'));
        }
        $number_of_tokens = intval(_post('number_of_tokens', 1));
        $lengthcode = intval(_post('lengthcode', 12));
        $token_value = floatval(_post('token_value'));
        $print = intval(_post('print_now', 0));

        if ($lengthcode <= 0) {
            r2($_SERVER['HTTP_REFERER'], 'e', Lang::T("Invalid length for token code."));
            exit;
        }


        if ($number_of_tokens <= 0 || $token_value <= 0) {
            r2($_SERVER['HTTP_REFERER'], 'e', Lang::T("Invalid number of tokens or token value."));
            exit;
        }

        for ($i = 0; $i < $number_of_tokens; $i++) {

            $token_number = substr(str_shuffle(str_repeat('0123456789', $lengthcode)), 0, $lengthcode);
            $serial_number = uniqid();

            $token = ORM::for_table('tbl_hotspot_tokens')->create();
            $token->token_number = $token_number;
            $token->serial_number = $serial_number;
            $token->value = $token_value;
            $token->status = 'none';
            $token->generated_by = $admin['id'];
            try {
                $token->save();
                $tokenIds[] = $token->id;
            } catch (Exception $e) {
                _log(Lang::T("Failed to save tokens: ") . $e->getMessage());
                r2($_SERVER['HTTP_REFERER'], 'e', Lang::T("An error occurred while while saving tokens, check logs for more info"));
                return;
            }
        }

        if ($print) {
            hotspot_tokensPrint($tokenIds);
            r2($_SERVER['HTTP_REFERER'], 's', Lang::T("$number_of_tokens tokens generated and Printed Successfully"));
        } else {
            r2($_SERVER['HTTP_REFERER'], 's', Lang::T("$number_of_tokens tokens generated successfully."));
        }
    }

    $tokensData = ($search != '') ? ORM::for_table('tbl_hotspot_tokens')
        ->where_raw(
            '(token_number LIKE ? OR serial_number LIKE ? OR value LIKE ? OR used_by LIKE ? OR CAST(used_count AS CHAR) LIKE ? OR IFNULL(first_used, "") LIKE ? OR IFNULL(last_used, "") LIKE ? OR IFNULL(activity_log, "") LIKE ?)',
            array_fill(0, 8, '%' . str_replace(['\\', '%', '_'], ['\\\\', '\\%', '\\_'], $search) . '%')
        )
        ->table_alias('t')
        ->select_many(
            't.id',
            't.token_number',
            't.serial_number',
            't.value',
            't.status',
            't.generated_by',
            't.created_at',
            't.expiry_date',
            't.used_count',
            't.first_used',
            't.last_used',
            't.used_by',

        )
        ->order_by_asc('t.id')
        ->left_outer_join('tbl_users', ['t.generated_by', '=', 'tbl_users.id'])
        ->select('tbl_users.fullname', 'admin_name') : ORM::for_table('tbl_hotspot_tokens')
            ->table_alias('t')
            ->select_many(
                't.id',
                't.token_number',
                't.serial_number',
                't.value',
                't.status',
                't.generated_by',
                't.created_at',
                't.expiry_date',
                't.used_count',
                't.first_used',
                't.last_used',
                't.used_by',

            )
            ->order_by_asc('t.id')
            ->left_outer_join('tbl_users', ['t.generated_by', '=', 'tbl_users.id'])
            ->select('tbl_users.fullname', 'admin_name');

    $tokens = $tokensData->findMany();
    $ui->assign('csrf_token', hotspot_generateCsrfToken());
    $ui->assign('tokens', $tokens);
    $ui->assign('search', $search);
    $ui->assign('filter', $filter);
    $ui->assign('xheader', '<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.11.3/css/jquery.dataTables.min.css">');
    $ui->display('hotspot_tokens.tpl');
}

function hotspot_tokensPrint($tokenIds = null)
{
    global $config, $_app_stage;

    if (app_is_demo_restricted()) {
        r2($_SERVER['HTTP_REFERER'], 'e', Lang::T('You cannot perform this action in Demo mode'));
    }

    // Build the query to fetch tokens
    $query = ORM::for_table('tbl_hotspot_tokens');

    if ($tokenIds === null) {
        $tokens = $query->find_many();
    } else {
        $query->where_in('tbl_hotspot_tokens.id', $tokenIds);
        $tokens = $query->find_many();
    }

    if (empty($tokens)) {
        r2(U . "plugin/hotspot_tokens", 'e', Lang::T("No tokens found for IDs: ") . implode(', ', $tokenIds));
        exit;
    }

    $currency = htmlspecialchars($config['currency_code']);
    $tokens_per_page = 50;
    $html = '';

    $token_count = 0;
    $UPLOAD_PATH = 'system' . DIRECTORY_SEPARATOR . 'uploads';
    $hotspot_tokens_temp = $UPLOAD_PATH . DIRECTORY_SEPARATOR . "hotspot_tokens_temp.json";

    if (file_exists($hotspot_tokens_temp)) {
        $json_data = file_get_contents($hotspot_tokens_temp);
        $json_data_array = json_decode($json_data, true);

        if ($json_data_array && isset($json_data_array['token_template'])) {
            $template = htmlspecialchars_decode($json_data_array['token_template']);
        } else {
            // Fallback template if JSON file does not contain template
            $template = '<style type="text/css">
                .token-container {
                    width: 250px;
                    height: 85px;
                    border: 1px solid #000;
                    font-family: Arial, sans-serif;
                    font-size: 10px;
                    margin-bottom: 5px;
                    display: flex;
                    background-color: #f7f7f7;
                }
                .price-bar {
                    width: 15px;
                    background-color: #ff8c00;
                    color: black;
                    text-align: center;
                    font-weight: bold;
                    padding: 5px 2px;
                    writing-mode: vertical-rl;
                    transform: rotate(180deg);
                }
                .details {
                    flex: 1;
                    padding: 5px;
                }
                .details .code {
                    font-size: 14px;
                    font-weight: bold;
                    text-align: center;
                    margin-bottom: 2px;
                }
                .details .info {
                    font-size: 9px;
                    margin-bottom: 2px;
                }
                .qrcode {
                    width: 68px;
                    height: 68px;
                    margin: auto;
                    padding: 5px;
                }
                .qrcode img {
                    width: 100%;
                    height: auto;
                }
            </style>
        <div class="token-container">
            <div class="price-bar">[[currency]][[value]]</div>
            <div class="details">
                <div class="code">[[token_pin]]</div>
                <div class="info">token can only be use on our hotpsot</div>
                <div class="info">[[url]] </div>
                <div class="info">SN: [[serial]]</div>
                <div class="info">Thank you for choosing our service</div>
            </div>
            <div class="qrcode">[[qrcode]]</div>
        </div>';
        }
    } else {
        // Default template if JSON file does not exist
        $template = '<style type="text/css">
            .token-container {
                width: 250px;
                height: 85px;
                border: 1px solid #000;
                font-family: Arial, sans-serif;
                font-size: 10px;
                margin-bottom: 5px;
                display: flex;
                background-color: #f7f7f7;
            }
            .price-bar {
                width: 15px;
                background-color: #ff8c00;
                color: black;
                text-align: center;
                font-weight: bold;
                padding: 5px 2px;
                writing-mode: vertical-rl;
                transform: rotate(180deg);
            }
            .details {
                flex: 1;
                padding: 5px;
            }
            .details .code {
                font-size: 14px;
                font-weight: bold;
                text-align: center;
                margin-bottom: 2px;
            }
            .details .info {
                font-size: 9px;
                margin-bottom: 2px;
            }
            .qrcode {
                width: 68px;
                height: 68px;
                margin: auto;
                padding: 5px;
            }
            .qrcode img {
                width: 100%;
                height: auto;
            }
        </style>
        <div class="token-container">
            <div class="price-bar">[[currency]][[value]]</div>
            <div class="details">
                <div class="code">[[token_pin]]</div>
                <div class="info">token can only be use on our hotpsot</div>
                <div class="info">[[url]] </div>
                <div class="info">SN: [[serial]]</div>
                <div class="info">Thank you for choosing our service</div>
            </div>
            <div class="qrcode">[[qrcode]]</div>
        </div>';
    }

    foreach ($tokens as $token) {
        $token_count++;
        $url_recharge = APP_URL . urlencode("/?route=plugin/hotspot_tokensClient&token={$token->token_number}");
        $url = htmlspecialchars($config['hotspot_url']);
        $qrCode = "<img src=\"qrcode/?data={$url_recharge}\" alt=\"QR Code\">";
        $current_token = str_replace(
            ['[[currency]]', '[[value]]', '[[token_pin]]', '[[url]]', '[[serial]]', '[[qrcode]]'],
            [$currency, htmlspecialchars($token->value), htmlspecialchars($token->token_number), $url, htmlspecialchars($token->serial_number), $qrCode],
            $template
        );

        $html .= $current_token;

        if ($token_count % $tokens_per_page == 0 && $token_count < count($tokens)) {
            $html .= '<div class="pagebreak"></div>';
        }
    }

    if (empty($html)) {
        r2(U . "plugin/hotspot_tokens", 'e', Lang::T("Error generating token preview. No content."));
        exit;
    }

    // Render the HTML for preview
    echo "<div style=\"display: flex; flex-wrap: wrap; justify-content: space-between;\">$html</div>";
    echo '<button onclick="window.print()">Print</button>';
}


function hotspot_tokens_print()
{
    global $_app_stage;
    $admin = Admin::_info();

    if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin', 'Sales'])) {
        _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
        exit;
    }

    if ($_SERVER['REQUEST_METHOD'] === 'POST' || $_SERVER['REQUEST_METHOD'] === 'GET') {
        $tokenIds = json_decode($_POST['tokenIds'], true) ?? [$_GET['token_id']];

        if (app_is_demo_restricted()) {
            r2($_SERVER['HTTP_REFERER'], 'e', Lang::T('You cannot perform this action in Demo mode'));
        }

        if (is_array($tokenIds) && !empty($tokenIds)) {
            hotspot_tokensPrint($tokenIds);
        } else {
            r2($_SERVER['HTTP_REFERER'], 'e', Lang::T("No token ID provided."));
            exit;
        }
    } else {
        r2($_SERVER['HTTP_REFERER'], 'e', Lang::T("Invalid request method"));
    }
}
function hotspot_tokens_delete()
{
    global $_app_stage;
    $admin = Admin::_info();

    if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin', 'Sales'])) {
        echo json_encode(['status' => 'error', 'message' => Lang::T('You do not have permission to access this page')]);
        exit;
    }

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $tokenIds = json_decode($_POST['tokenIds'], true);
        if (app_is_demo_restricted()) {
            echo json_encode(['status' => 'error', 'message' => Lang::T('You cannot perform this action in Demo mode')]);
        }
        if (is_array($tokenIds) && !empty($tokenIds)) {
            // Delete tokens from the database
            ORM::for_table('tbl_hotspot_tokens')
                ->where_in('id', $tokenIds)
                ->delete_many();

            // Return success response
            echo json_encode(['status' => 'success', 'message' => Lang::T("Tokens Deleted Successfully.")]);
            exit;
        } else {
            echo json_encode(['status' => 'error', 'message' => Lang::T("Invalid or missing token IDs.")]);
            exit;
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => Lang::T("Invalid request method.")]);
        exit;
    }
}

function hotspot_tokens_sendToken()
{
    global $config, $_app_stage;
    $admin = Admin::_info();

    if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin', 'Sales'])) {
        _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
        exit;
    }

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        if (app_is_demo_restricted()) {
            r2($_SERVER['HTTP_REFERER'], 'e', Lang::T('You cannot perform this action in Demo mode'));
        }
        $tokenId = $_POST['tokenId'] ?? null;
        $phoneNumber = $_POST['phoneNumber'] ?? null;
        $sendVia = $_POST['method'] ?? 'sms';
        $UPLOAD_PATH = 'system' . DIRECTORY_SEPARATOR . 'uploads';
        $hotspot_tokens_temp = $UPLOAD_PATH . DIRECTORY_SEPARATOR . "hotspot_tokens_temp.json";

        $default_message = "Dear Customer,\r\nHere is your Recharge Token Details:\r\nToken PIN: [[token_number]]\r\nToken Value: [[value]]\r\n\r\n[[company]]";

        if (file_exists($hotspot_tokens_temp)) {
            $json_data = file_get_contents($hotspot_tokens_temp);
            if ($json_data !== false) {
                $json_data_array = json_decode($json_data, true);
                $messageContent = $json_data_array['token_send'] ?? $default_message;
            } else {
                $messageContent = $default_message;
            }
        } else {
            $messageContent = $default_message;
        }


        if (!$tokenId || !$phoneNumber) {
            _log("Debug: token ID: $tokenId, Phone Number: $phoneNumber");
            r2($_SERVER['HTTP_REFERER'], 'e', Lang::T("Invalid or missing token ID or phone number."));
            exit;
        }

        if ($tokenId && $phoneNumber) {
            $token = ORM::for_table('tbl_hotspot_tokens')->find_one($tokenId);

            if ($token) {
                $tokenPin = $token->token_number;
                // Replace placeholders with actual values
                $message = str_replace('[[company]]', $config['CompanyName'], $messageContent);
                $message = str_replace('[[token_number]]', $tokenPin, $message);
                $message = str_replace('[[value]]', $token->value, $message);

                $channels = [
                    'sms' => [
                        'enabled' => $sendVia == 'sms' || $sendVia == 'both',
                        'method' => 'Message::sendSMS',
                        'args' => [$phoneNumber, $message]
                    ],
                    'whatsapp' => [
                        'enabled' => $sendVia == 'wa' || $sendVia == 'both',
                        'method' => 'Message::sendWhatsapp',
                        'args' => [$phoneNumber, $message]
                    ]
                ];

                try {
                    foreach ($channels as $channel => $channelData) {
                        if ($channelData['enabled']) {
                            try {
                                call_user_func_array($channelData['method'], $channelData['args']);
                            } catch (Exception $e) {
                                _log("Failed to send token PIN via $channel: " . $e->getMessage());
                            }
                        }
                    }

                    r2($_SERVER['HTTP_REFERER'], 's', Lang::T("Token PIN has been send successfully to: ") . $phoneNumber);
                } catch (Exception $e) {
                    r2($_SERVER['HTTP_REFERER'], 'e', Lang::T("Failed to send token PIN to ") . $phoneNumber . ' ' . $e->getMessage());
                    _log(Lang::T("Failed to send token PIN to ") . $phoneNumber . ' ' . $e->getMessage());
                }
            } else {
                echo json_encode(['status' => 'error', 'message' => 'token not found.']);
                r2($_SERVER['HTTP_REFERER'], 'e', Lang::T("token not found."));
            }
        } else {
            r2($_SERVER['HTTP_REFERER'], 'e', Lang::T("Invalid or missing token ID or phone number."));
        }
    } else {
        r2($_SERVER['HTTP_REFERER'], 'e', Lang::T("Invalid request method"));
        exit;
    }
    exit;
}

function hotspot_processPayment_tokens($data)
{
    global $config;

    $token = $data['payment_token'];
    $result = hotspot_tokens_processToken($token, $data);
    switch ($result['status']) {
        case 'success':
            return r2(U . "plugin/hotspot_verify&reference={$data['txref']}", 's', Lang::T($result['message']));
        default:
            if ($result['status'] == 'error') {
                r2($_SERVER['HTTP_REFERER'], 'e', Lang::T($result['message']));
            }
            break;
    }

    echo json_encode($result);
    exit;
}

function hotspot_tokens_processToken($token, $data)
{
    global $config;
    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }

    // Extract and sanitize inputs
    $phone = trim($data['phone'] ?? '');
    $macAddress = trim($data['mac_address'] ?? '');
    $amount = (float) ($data['amount'] ?? 0);

    if (!$phone || !$macAddress || $amount <= 0) {
        return [
            'status' => 'error',
            'message' => Lang::T("Invalid input data provided.")
        ];
    }

    $lockoutDuration = 5 * 60;
    $maxAttempts = 5;

    $phoneKey = "lockout_phone_" . hash('sha256', $phone);
    $macKey = "lockout_mac_" . hash('sha256', $macAddress);
    $insufficientBalanceKey = "low_balance_attempts_" . hash('sha256', "$phone$macAddress");
    $blockedTokenKey = "bocked_token_attempts_" . hash('sha256', "$phone$macAddress");

    $currentTime = time();
    if (
        ($phoneLockout = $_SESSION[$phoneKey] ?? 0) > $currentTime ||
        ($macLockout = $_SESSION[$macKey] ?? 0) > $currentTime
    ) {
        $lockoutUntil = max($phoneLockout, $macLockout);
        $timeRemaining = $lockoutUntil - $currentTime;
        return [
            'status' => 'error',
            'message' => Lang::T("Too many failed attempts. Try again in " . gmdate("i:s", $timeRemaining) . " minutes.")
        ];
    }

    $tokenData = ORM::for_table('tbl_hotspot_tokens')
        ->where('token_number', $token)
        ->find_one();

    if ($tokenData) {
        // Check token balance
        if ($tokenData->status === 'blocked') {
            if (!isset($_SESSION[$blockedTokenKey])) {
                $_SESSION[$blockedTokenKey] = 0;
            }
            $_SESSION[$blockedTokenKey]++;

            if ($_SESSION[$blockedTokenKey] >= $maxAttempts) {
                $_SESSION[$phoneKey] = $currentTime + $lockoutDuration;
                $_SESSION[$macKey] = $currentTime + $lockoutDuration;

                return [
                    'status' => 'error',
                    'message' => Lang::T("Too many attempts with suspended token. You are locked out for 5 minutes.")
                ];
            }

            $remainingAttempts = $maxAttempts - $_SESSION[$blockedTokenKey];
            return [
                'status' => 'error',
                'message' => Lang::T("Your token has been suspended, Please contact customer service. You have $remainingAttempts attempt(s) remaining before lockout.")
            ];
        }

        if ($tokenData->value < $amount) {
            if (!isset($_SESSION[$insufficientBalanceKey])) {
                $_SESSION[$insufficientBalanceKey] = 0;
            }
            $_SESSION[$insufficientBalanceKey]++;

            if ($_SESSION[$insufficientBalanceKey] >= $maxAttempts) {
                $_SESSION[$phoneKey] = $currentTime + $lockoutDuration;
                $_SESSION[$macKey] = $currentTime + $lockoutDuration;

                return [
                    'status' => 'error',
                    'message' => Lang::T("Too many attempts with insufficient balance. You are locked out for 5 minutes.")
                ];
            }

            $remainingAttempts = $maxAttempts - $_SESSION[$insufficientBalanceKey];
            return [
                'status' => 'error',
                'message' => Lang::T("Insufficient balance in token. Your token balance is: {$tokenData->value}. You have $remainingAttempts attempt(s) remaining before lockout.")
            ];
        }

        $tokenData->value -= $amount;
        $tokenData->last_used = date('Y-m-d H:i:s');
        if (empty($tokenData->first_used)) {
            $tokenData->first_used = date('Y-m-d H:i:s');
        }
        $tokenData->used_by = $phone;
        $tokenData->status = $tokenData->value > 0 ? 'active' : 'used';
        $tokenData->used_count++;
        $tokenData->save();
        $details = "Purchased a hotspot plan {$data['plan_name']}\nAmount: {$config['Currency']}{$data['amount']}\nDevice Mac Address: {$data['mac_address']}\nTransaction Reference: {$data['txref']}";
        hotspot_tokens_logTokenActivity($tokenData, 'usage', $details, $phone);
        // Reset session keys
        unset($_SESSION[$insufficientBalanceKey], $_SESSION[$phoneKey], $_SESSION[$macKey]);

        if (!hotspot_tokens_activatePackage($tokenData, $data)) {

            return [
                'status' => 'error',
                'message' => Lang::T("There is an error while activating the package. Please try again later.")
            ];
        } else {

            return [
                'status' => 'success',
                'message' => Lang::T("Token transaction processed successfully. Remaining balance: {$tokenData->value}.")
            ];
        }
    } else {
        // Handle invalid token
        $attemptsPhoneKey = "attempts_phone_" . hash('sha256', $phone);
        $attemptsMacKey = "attempts_mac_" . hash('sha256', $macAddress);

        if (!isset($_SESSION[$attemptsPhoneKey])) {
            $_SESSION[$attemptsPhoneKey] = 0;
        }
        if (!isset($_SESSION[$attemptsMacKey])) {
            $_SESSION[$attemptsMacKey] = 0;
        }

        // Increment failed attempts for both phone and MAC
        $_SESSION[$attemptsPhoneKey]++;
        $_SESSION[$attemptsMacKey]++;

        if ($_SESSION[$attemptsPhoneKey] >= $maxAttempts || $_SESSION[$attemptsMacKey] >= $maxAttempts) {
            $_SESSION[$phoneKey] = $currentTime + $lockoutDuration;
            $_SESSION[$macKey] = $currentTime + $lockoutDuration;

            return [
                'status' => 'error',
                'message' => Lang::T("Too many failed attempts. You are locked out for 5 minutes.")
            ];
        }

        $remainingAttemptsPhone = $maxAttempts - $_SESSION[$attemptsPhoneKey];
        $remainingAttemptsMac = $maxAttempts - $_SESSION[$attemptsMacKey];

        return [
            'status' => 'error',
            'message' => Lang::T(
                "Invalid token. You have $remainingAttemptsPhone attempt(s) remaining for this phone number and $remainingAttemptsMac attempt(s) remaining for this device before lockout."
            )
        ];
    }
}
function hotspot_tokens_activatePackage($token, $data)
{
    global $config;

    // Validate required data
    $requiredFields = ['phone', 'mac_address', 'ip_address', 'routername', 'txref', 'planid', 'amount', 'email'];
    foreach ($requiredFields as $field) {
        if (empty($data[$field])) {
            return [
                'status' => 'error',
                'message' => Lang::T("Invalid or incomplete input data.")
            ];
        }
    }

    // Extract and sanitize inputs
    $phone = $data['phone'];
    $mac_address = $data['mac_address'];
    $ip_address = $data['ip_address'];
    $routername = $data['routername'];
    $txref = $data['txref'];
    $planid = $data['planid'];
    $plan_name = $data['plan_name'];
    $amount = $data['amount'];
    $email = $data['email'];
    $voucherCode = hotspot_generate_voucher_code();
    $modifiedPhone = hotspot_replaceCountryCode($phone);

    // Fetch or create customer
    $customer = ORM::for_table('tbl_customers')->where('phonenumber', $phone)->find_one();
    $username = $config['hotspot_voucher_mode'] ? $voucherCode : $modifiedPhone;
    $password = $username;

    if (!$customer) {
        $customer = ORM::for_table('tbl_customers')->create();
        $customer->pppoe_password = '0';
        $customer->email = $email;
        $customer->fullname = "Hotspot $modifiedPhone";
        $customer->address = '';
        $customer->created_by = 1; // Admin ID
        $customer->phonenumber = Lang::phoneFormat($phone);
        $customer->service_type = 'Hotspot';
    }

    $customer->username = $username;
    $customer->password = $password;
    $customer->save();

    // Recharge user
    if (!Package::rechargeUser($customer->id, $routername, $planid, 'Token', "{$token->token_number}")) {
        $errorMsg = Lang::T("Failed to activate your Package, try again later.");
        _log($errorMsg);
        sendTelegram($errorMsg);
    }

    // Plan details
    $bills = ORM::for_table('tbl_user_recharges')
        ->where('plan_id', $planid)
        ->where('username', $customer->username)
        ->where('status', 'on')
        ->find_one();

    if (!$bills) {
        return [
            'status' => 'error',
            'message' => Lang::T("Failed to retrieve plan details.")
        ];
    }

    $expired = date('Y-m-d H:i:s', strtotime("{$bills->expiration} {$bills->time}"));
    $plan_name = $bills->namebp;

    // Save transaction
    $trx = ORM::for_table('tbl_hotspot_payments')->create();
    $trx->transaction_id = $token->token_number;
    $trx->transaction_ref = $txref;
    $trx->amount = $amount;
    $trx->phone_number = $phone;
    $trx->plan_id = $planid;
    $trx->plan_name = $plan_name;
    $trx->mac_address = $mac_address;
    $trx->ip_address = $ip_address;
    $trx->router_name = $routername;
    $trx->voucher_code = $username;
    $trx->transaction_status = 'paid';
    $trx->payment_gateway = "Payment Token";
    $trx->payment_method = "{$token->token_number}";
    $trx->payment_date = date('Y-m-d H:i:s');
    $trx->gateway_response = "Payment Token {$token->token_number}";
    $trx->expired_date = $expired;
    try {
        $trx->save();
    } catch (Exception $e) {
        _log(Lang::T("Failed to save transaction: ") . $e->getMessage());
        sendTelegram(Lang::T("Failed to save transaction: ") . $e->getMessage());
        return false;
    }

    // Send notifications
    hotspot_sendMessage($phone, $plan_name, $username, $expired);
    $notification = Lang::T("Notification") . ": Payment Status: Paid using token: {$token->token_number}, Amount: {$amount}";
    _log($notification);
    sendTelegram($notification);

    return true;
}
function hotspot_tokens_refillToken()
{
    global $_app_stage;
    _admin();
    $admin = Admin::_info();
    if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin', 'Sales'])) {
        _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
        exit;
    }

    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        if (app_is_demo_restricted()) {
            r2($_SERVER['HTTP_REFERER'], 'e', Lang::T('You cannot perform this action in Demo mode'));
        }
        $postData = [
            'tokenId' => $_POST['tokenId'] ?? '',
            'amount' => $_POST['amount'] ?? '',
            'notify' => $_POST['notify'] ?? '',
            'phoneNumber' => $_POST['phoneNumber'] ?? '',
            'method' => $_POST['method'] ?? '',
        ];

        $result = hotspot_tokens_refillTokenProcess($postData, true);
        if ($result['status'] === 'success') {
            r2($_SERVER['HTTP_REFERER'], 's', Lang::T($result['message']));
        } else {
            r2($_SERVER['HTTP_REFERER'], 'e', Lang::T($result['message']));
        }
    }
}

function hotspot_tokens_refillTokenProcess($postData, $isAdmin = false)
{
    global $config;
    $tokenId = $postData['tokenId'] ?? '';
    $amount = $postData['amount'] ?? '';
    $notify = $postData['notify'] ?? '';
    $phone = $postData['phoneNumber'] ?? '';
    $via = $postData['method'] ?? '';

    if (empty($tokenId) || empty($amount)) {
        return [
            'status' => 'error',
            'message' => "Invalid or incomplete input data."
        ];
    }

    $token = ORM::for_table('tbl_hotspot_tokens')->where('id', $tokenId)->find_one();
    if (!$token) {
        return [
            'status' => 'error',
            'message' => Lang::T("Token not found.")
        ];
    }
    if ($token->status === 'blocked' && $isAdmin === false) {
        return [
            'status' => 'error',
            'message' => "Token is blocked."
        ];
    }
    if ($amount <= 0) {
        return [
            'status' => 'error',
            'message' => "Invalid amount."
        ];
    }

    $token->value += $amount;
    $token->status = 'active';
    $token->save();
    hotspot_tokens_logTokenActivity($token, 'refill', "Refilled with amount {$amount}.", $phone ?: 'System');
    if ($notify === '1') {
        $message = Lang::T("Dear {$phone}, your token number {$token->token_number} has been successfully refilled.\nThe new token balance is {$token->value}.\nThanks for using our service \n" . $config['companyname']);
        if ($via === 'sms') {
            sendSMS($phone, $message);
        } elseif ($via === 'wa') {
            sendWhatsapp($phone, $message);
        } else {
            sendWhatsapp($phone, $message);
            sendSMS($phone, $message);
        }
    }

    $notification = Lang::T("Notification") . "\nRefill Token: {$token->token_number}, Amount: {$amount}";
    _log($notification);
    sendTelegram($notification);
    return [
        'status' => 'success',
        'message' => "Token refilled successfully."
    ];
}

function hotspot_tokens_logTokenActivity($token, $activityType, $details, $user = 'System')
{
    $log = [
        'token_id' => $token->id,
        'activity_type' => $activityType,
        'details' => $details,
        'user' => $user,
        'timestamp' => date('Y-m-d H:i:s'),
    ];

    // Insert the log using Idiorm
    ORM::for_table('tbl_hotspot_token_activity_logs')->create()
        ->set('token_id', $log['token_id'])
        ->set('activity_type', $log['activity_type'])
        ->set('details', $log['details'])
        ->set('user', $log['user'])
        ->set('timestamp', $log['timestamp'])
        ->save();

}

function hotspot_tokens_status()
{
    global $_app_stage;
    $admin = Admin::_info();

    if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin', 'Sales'])) {
        _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
        exit;
    }

    if ($_SERVER['REQUEST_METHOD'] === 'GET') {

        if (app_is_demo_restricted()) {
            r2($_SERVER['HTTP_REFERER'], 'e', Lang::T('You cannot perform this action in Demo mode'));
        }

        $tokenId = $_GET['token_id'] ?? '';
        $csrf_token = $_GET['csrf_token'] ?? '';
        $status = $_GET['status'] ?? '';
        if (empty($tokenId) || empty($csrf_token) || !hotspot_validateCsrfToken($csrf_token) || empty($status)) {
            r2($_SERVER['HTTP_REFERER'], 'e', Lang::T("Invalid request"));
            exit;
        }
        $token = ORM::for_table('tbl_hotspot_tokens')->where('id', $tokenId)->find_one();
        if (!$token) {
            r2($_SERVER['HTTP_REFERER'], 'e', Lang::T("Token not found."));
            exit;
        }
        $token->status = $status;
        $token->save();
        hotspot_tokens_logTokenActivity($token, $status === 'active' ? 'activate' : 'deactivate', $status === 'active' ? 'Activated' : 'Deactivated');
        r2($_SERVER['HTTP_REFERER'], 's', Lang::T("Token status updated successfully."));
    } else {
        r2($_SERVER['HTTP_REFERER'], 'e', Lang::T("Invalid request method"));
    }
}
function hotspot_tokens_details()
{
    global $ui;
    _admin();
    $admin = Admin::_info();

    if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin', 'Sales'])) {
        _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
        exit;
    }

    $tokenId = $_GET['token_id'] ?? '';
    $csrf_token = $_GET['csrf_token'] ?? '';

    if (empty($tokenId) || empty($csrf_token) || !hotspot_validateCsrfToken($csrf_token)) {
        r2($_SERVER['HTTP_REFERER'], 'e', Lang::T("Invalid request"));
        exit;
    }

    $token = ORM::for_table('tbl_hotspot_tokens')->find_one($tokenId);

    if ($token) {
        $activityLogJson = json_decode($token->activity_log, true) ?? [];
        $activityLogDb = ORM::for_table('tbl_hotspot_token_activity_logs')
            ->where('token_id', $token->id)
            ->order_by_desc('timestamp')
            ->find_many();

        // Convert database logs to an associative array
        $activityLogDbArray = [];
        foreach ($activityLogDb as $log) {
            $activityLogDbArray[] = [
                'type' => $log->activity_type,
                'details' => $log->details,
                'user' => $log->user,
                'timestamp' => $log->timestamp,
            ];
        }

        $mergedActivityLog = array_merge($activityLogJson, $activityLogDbArray);

        // Sort the merged activity log by timestamp in descending order
        usort($mergedActivityLog, function ($a, $b) {
            return strtotime($b['timestamp']) - strtotime($a['timestamp']);
        });

        $ui->assign('activityLog', $mergedActivityLog);
        $ui->assign('token', $token->token_number);
        $ui->assign('xheader', '<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.11.3/css/jquery.dataTables.min.css">');
        $ui->display('hotspot_tokens_details.tpl');
    } else {
        r2($_SERVER['HTTP_REFERER'], 'e', Lang::T("Token not found."));
    }
}


function hotspot_token_installDB()
{
    global $config;

    try {
        $db = ORM::get_db();

        // Create tbl_hotspot_tokens table
        $tokensTableQuery = "
            CREATE TABLE IF NOT EXISTS tbl_hotspot_tokens (
                id INT AUTO_INCREMENT PRIMARY KEY,
                token_number VARCHAR(255) UNIQUE NOT NULL,
                serial_number VARCHAR(255) UNIQUE NOT NULL,
                value DECIMAL(10, 2) NOT NULL,
                status ENUM('active', 'used', 'none', 'blocked') DEFAULT 'none' COMMENT 'Token status: active, used, none, or blocked',
                generated_by INT NOT NULL DEFAULT 0 COMMENT 'Admin ID who generated the token',
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                expiry_date TIMESTAMP NULL DEFAULT NULL,
                used_by VARCHAR(255) DEFAULT NULL COMMENT 'User or device that used the token',
                used_count INT NOT NULL DEFAULT 0 COMMENT 'Number of times the token was used',
                first_used TIMESTAMP NULL DEFAULT NULL COMMENT 'Timestamp of the first usage',
                last_used TIMESTAMP NULL DEFAULT NULL COMMENT 'Timestamp of the last usage',
                activity_log TEXT NULL COMMENT 'JSON-formatted log of token activities'
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ";

        // Execute table creation query
        $db->exec($tokensTableQuery);
    } catch (PDOException $e) {
        echo "Database error: " . $e->getMessage();
    } catch (Exception $e) {
        echo "An unexpected error occurred: " . $e->getMessage();
    }

    try {
        $db = ORM::get_db();

        // Create tbl_hotspot_token_activity_logs table
        $tokensTableQuery = "
            CREATE TABLE IF NOT EXISTS tbl_hotspot_token_activity_logs (
                id INT AUTO_INCREMENT PRIMARY KEY,
                token_id INT NOT NULL,
                activity_type VARCHAR(255) NOT NULL,
                details TEXT,
                user VARCHAR(255) DEFAULT 'System',
                timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ";

        // Execute table creation query
        $db->exec($tokensTableQuery);
    } catch (PDOException $e) {
        echo "Database error: " . $e->getMessage();
    } catch (Exception $e) {
        echo "An unexpected error occurred: " . $e->getMessage();
    }

}