<?php
/// Allow requests from any origin
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit;
}

function CreateHotspotuser()
{
    Alloworigins();
}

function Alloworigins()
{
    if (!isset($_GET['type'])) {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["status" => "error", "message" => "Missing request type"]);
        exit();
    }

    $type = $_GET['type'];
    if ($type == "verify") {
        VerifyHotspot();
    } elseif ($type == "grant") {
        CreateHostspotUser();
    } elseif ($type == "hotspot_plans") {
        GetHotspotPlans();
    } elseif ($type == "redeem_voucher") {
        RedeemVoucher();
    } elseif ($type == "redeem_mpesa_code") {
        MpesaCodeLogin();
    } elseif ($type == "hotspot_settings") {
        GetHotspotSettings();
    } else {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["status" => "error", "message" => "Invalid request type"]);
        exit();
    }
}

function VerifyHotspot()
{
    $input = json_decode(file_get_contents('php://input'), true);
    $account_number = isset($input['account_number']) ? $input['account_number'] : '';
    if (empty($account_number)) {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["status" => "error", "message" => "Missing required parameters when verifying account number" . $account_number]);
        exit();
    }
    $user = ORM::for_table('tbl_payment_gateway')
        ->where('username', $account_number)
        ->order_by_desc('id')
        ->find_one();
    if ($user) {
        $status = $user->status;
        $mpesacode = $user->gateway_trx_id;
        $res = $user->pg_paid_response;
        $gw = strtolower((string) ($user->gateway ?? ''));
        if ($status == 2) {
            $paidMsg = ($gw === 'paystack')
                ? "Paystack payment confirmed (ref: $mpesacode). Please wait while we sign you in."
                : "We have received your transaction under the Mpesa Transaction $mpesacode, Please don't leave this page as we are redirecting you";
            $data = [
                "Resultcode" => "3",
                "username" => $account_number,
                "tyhK" => "1234",
                "Message" => $paidMsg,
                "Status" => "success"
            ];
        } elseif ($res == "Not enough balance") {
            $data = [
                "Resultcode" => "2",
                "Message1" => "Insufficient Balance for the transaction",
                "Status" => "danger",
                "Redirect" => "Insufficient balance"
            ];
        } elseif ($res == "Wrong Mpesa pin") {
            $data = [
                "Resultcode" => "2",
                "Message" => "You entered Wrong Mpesa pin, please resubmit",
                "Status" => "danger",
                "Redirect" => "Wrong Mpesa pin"
            ];
        } elseif ($status == 4) {
            $data = [
                "Resultcode" => "2",
                "Message" => "You cancelled the transaction, you can enter phone number again to activate",
                "Status" => "danger",
                "Redirect" => "Transaction Cancelled"
            ];
        } else {
            $pendingMsg = ($gw === 'paystack')
                ? "Complete your Paystack payment in the payment window, then keep this page open until login completes."
                : "A payment pop up has been sent, Please enter pin to continue (Please do not leave or reload the page until redirected)";
            $data = [
                "Resultcode" => "1",
                "Message" => $pendingMsg,
                "Status" => "primary"
            ];
        }
    } else {
        $data = ["status" => "error", "message" => "Account " . $account_number . " not found"];
    }
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($data);
    exit();
}

function CreateHostspotUser()
{
    $result = ORM::for_table('tbl_appconfig')->find_many();
    foreach ($result as $value) {
        $config[$value['setting']] = $value['value'];
    }
    // Check if the request method is POST
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["status" => "error", "message" => "Invalid request method"]);
        exit();
    }
    if ($config['maintenance_mode']) {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(['status' => 'error', 'message' => 'Scheduled maintenance is currently in progress. Please check back soon. We apologize for any inconvenience']);
        exit();
    }
    try {
        // Parse JSON input
        $input = json_decode(file_get_contents('php://input'), true);

        // Extract data from JSON input
        $phone = isset($input['phone_number']) ? $input['phone_number'] : '';
        $planId = isset($input['plan_id']) ? $input['plan_id'] : '';
        $routerId = isset($input['router_id']) ? $input['router_id'] : '';
        $user_account = isset($input['account_number']) ? $input['account_number'] : '';
        $mac_address = isset($input['mac_address']) ? $input['mac_address'] : '';

        $missingParams = [];
        if (empty($phone)) $missingParams[] = 'phone_number';
        if (empty($planId)) $missingParams[] = 'plan_id';
        if (empty($routerId)) $missingParams[] = 'router_id';
        if (empty($user_account)) $missingParams[] = 'account_number';
        
        if (!empty($missingParams)) {
            header('Content-Type: application/json; charset=utf-8');
            echo json_encode(["status" => "error", "message" => "Missing required parameters: " . implode(', ', $missingParams)]);
            exit();
        }

        $macs = ["22:12:59:0C:45:58"];

        if (in_array($mac_address, $macs)) {
            header('Content-Type: application/json; charset=utf-8');
            echo json_encode(['status' => 'error', 'message' => 'This device has been blocked from accessing this service, please contact service provider']);
            exit();
        }

        $phone = (substr($phone, 0, 1) == '+') ? str_replace('+', '', $phone) : $phone;
        $phone = (substr($phone, 0, 1) == '0') ? preg_replace('/^0/', '254', $phone) : $phone;
        $phone = (substr($phone, 0, 1) == '7') ? preg_replace('/^7/', '2547', $phone) : $phone; //cater for phone number prefix 2547XXXX
        $phone = (substr($phone, 0, 1) == '1') ? preg_replace('/^1/', '2541', $phone) : $phone; //cater for phone number prefix 2541XXXX
        $phone = (substr($phone, 0, 1) == '0') ? preg_replace('/^01/', '2541', $phone) : $phone;
        $phone = (substr($phone, 0, 1) == '0') ? preg_replace('/^07/', '2547', $phone) : $phone;

        $PlanExist = ORM::for_table('tbl_plans')->where('id', $planId)->where('enabled', 1)->count() > 0;
        $RouterExist = ORM::for_table('tbl_routers')->where('id', $routerId)->count() > 0;

        if (!$PlanExist || !$RouterExist) {
            header('Content-Type: application/json; charset=utf-8');
            echo json_encode(["status" => "error", "message" => "Unable to process your request, please refresh the page"]);
            exit();
        }

        // MULTI-USER PER PHONE: Lookup ONLY by username (not dual-key)
        // This allows multiple usernames (e.g., 573822, 537839) to share same phone
        $Userexist = ORM::for_table('tbl_customers')->where('username', $user_account)
            ->where('service_type', 'Hotspot')  // ← Only Hotspot, never PPPoE
            ->find_one();

        if ($Userexist) {
            // User exists - RECHARGE instead of creating new
            $Userexist->router_id = $routerId;
            $Userexist->password = '1234';
            $Userexist->phonenumber = $phone;  // Update phone in case changed
            if (empty($Userexist->status) || $Userexist->status !== 'Active') {
                $Userexist->status = 'Active';
            }
            $Userexist->save();
            InitiateStkpush($phone, $planId, $routerId, $user_account, $mac_address);
        } else {
            // Check if router_id column exists in tbl_customers
            $table = ORM::for_table('tbl_customers')->raw_query('SHOW COLUMNS FROM tbl_customers LIKE "router_id"')->find_one();
            if (!$table) {
                $sql = "ALTER TABLE tbl_customers ADD router_id VARCHAR(255) AFTER fullname";
                ORM::for_table('tbl_customers')->raw_execute($sql);
            }

            // Create NEW user ONLY if username doesn't exist as ANY service type
            // Check if this username exists as PPPoE or other service
            $UserexistAny = ORM::for_table('tbl_customers')->where('username', $user_account)->find_one();
            
            if ($UserexistAny && $UserexistAny->service_type !== 'Hotspot') {
                // User exists but as different service type - DON'T override
                header('Content-Type: application/json; charset=utf-8');
                echo json_encode(["status" => "error", "message" => "This account is registered as " . $UserexistAny->service_type . " service, cannot convert to Hotspot"]);
                exit();
            }

            // Create new Hotspot user
            $defpass = '1234';
            $defaddr = 'Hotspot Address';
            $defmail = $user_account . '@gmail.com';
            $createUser = ORM::for_table('tbl_customers')->create();
            $createUser->username = $user_account;
            $createUser->password = $defpass;
            $createUser->fullname = $phone;
            $createUser->router_id = $routerId;
            $createUser->phonenumber = $phone;
            $createUser->pppoe_password = $defpass;
            $createUser->address = $defaddr;
            $createUser->email = $defmail;
            $createUser->service_type = 'Hotspot';  // ← Explicitly Hotspot only
            $createUser->status = 'Active';

            if ($createUser->save()) {
                InitiateStkpush($phone, $planId, $routerId, $user_account, $mac_address);
            } else {
                header('Content-Type: application/json; charset=utf-8');
                echo json_encode(["status" => "error", "message" => "There was a system error when registering user, please contact support"]);
                exit();
            }
        }
    } catch (Exception $e) {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["status" => "error", "message" => $e->getMessage()]);
        exit();
    }
}


function GetHotspotPlans()
{

    // Check if the request method is POST
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["status" => "error", "message" => "Invalid request method"]);
        exit();
    }
    $input = json_decode(file_get_contents('php://input'), true);
    $router_id = isset($input['router_id']) ? $input['router_id'] : '';
    if (empty($router_id)) {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["status" => "error", "message" => "Missing required parameters router_id : " . $router_id]);
        exit();
    }


    //GET ROUTER NAME
    $routerName = ORM::for_table('tbl_routers')
        ->where('id', $router_id)
        ->find_one();
    if (!$routerName) {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["status" => "error", "message" => "Router not found"]);
        exit();
    }
    $routerName = $routerName->name;
    $result = ORM::for_table('tbl_appconfig')->find_many();
    foreach ($result as $value) {
        $config[$value['setting']] = $value['value'];
    }
    if ($config['maintenance_mode']) {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(['status' => 'error', 'message' => 'Scheduled maintenance is currently in progress. Please check back soon. We apologize for any inconvenience']);
        exit();
    }
    $routers = ORM::for_table('tbl_routers')->find_array();
    $plans_hotspot = ORM::for_table('tbl_plans')->where('type', 'Hotspot')->where('enabled', 1)->find_array();
    $bandwidth_map = ORM::for_table('tbl_bandwidth')->find_array();

    $color_scheme = ORM::for_table('tbl_appconfig')->where('setting', 'color_scheme')->find_one();
    $color_scheme = $color_scheme ? $color_scheme->value : 'blue';


    $shape = ORM::for_table('tbl_appconfig')->where('setting', 'shape_selector')->find_one();
    $shape = $shape ? $shape->value : 'square';
    if ($shape == 'square') {
        $shape_card_class_name = 'w-64 h-64 rounded-lg';
    } elseif ($shape == 'rectangle') {
        $shape_card_class_name = 'w-80 h-48 rounded-lg';
    } elseif ($shape == 'circle') {
        $shape_card_class_name = 'w-64 h-64 rounded-full';
    } elseif ($shape == 'oval') {
        $shape_card_class_name = 'w-80 h-48 rounded-full';
    } else {
        $shape_card_class_name = 'rounded-lg';
    }

    $currency_config = ORM::for_table('tbl_appconfig')->where('setting', 'currency_code')->find_one();
    $currency = $currency_config ? $currency_config->value : 'Ksh';
    $data = [];
    foreach ($routers as $router) {
        if ($router['name'] === $routerName) {
            $routerData = [
                'name' => $router['name'],
                'router_id' => $router['id'],
                'description' => $router['description'],
                'plans_hotspot' => [],
            ];
            foreach ($plans_hotspot as $plan) {
                if ($router['name'] == $plan['routers']) {
                    $plan_id = $plan['id'];
                    $bandwidth_data = isset($bandwidth_map[$plan_id]) ? $bandwidth_map[$plan_id] : [];
                    $paymentlink = "";
                    $routerData['plans_hotspot'][] = [
                        'plantype' => $plan['type'],
                        'planname' => $plan['name_plan'],
                        'typebp' => $plan['typebp'],
                        'currency' => $currency,
                        'price' => $plan['price'],
                        'validity' => $plan['validity'],
                        'shared_users' => $plan['shared_users'],
                        'device' => $plan['shared_users'],
                        'datalimit' => $plan['data_limit'],
                        'timelimit' => $plan['validity_unit'] ?? null,
                        'downlimit' => $bandwidth_data['rate_down'] ?? null,
                        'uplimit' => $bandwidth_data['rate_up'] ?? null,
                        'paymentlink' => $paymentlink,
                        'planId' => $plan['id'],
                        'routerName' => $router['name'],
                        'routerId' => $router['id'],
                        'shape' => $shape,
                        'shape_card_class_name' => $shape_card_class_name,
                        'color_scheme' => $color_scheme,
                    ];
                }
            }
            $data[] = $routerData;
        }
    }
    header('Content-Type: application/json');
    echo json_encode($data);
    exit();
}

function InitiateStkpush($phone, $planId, $routerId, $user_Account, $mac_address)
{
    try {
        $file_path = 'system/removeuser.php';
        //  include_once $file_path;

        $gateway = ORM::for_table('tbl_appconfig')
            ->where('setting', 'payment_gateway')
            ->find_one();
        $gateway = ($gateway) ? $gateway->value : null;

        if ($gateway == "MpesatillStk") {
            $url = (U . "plugin/initiatetillstk");
        } elseif ($gateway == "BankStkPush") {
            $url = (U . "plugin/initiatebankstk");
        } elseif ($gateway == "MpesaPaybill") {
            $url = (U . "plugin/initiatePaybillStk");
        } elseif ($gateway == "mpesa") {
            $url = (U . "plugin/initiatempesa");
        } elseif ($gateway == "paybilltillsbankmpesa") {
            $url = (U . "plugin/initiatepaybilltillsbankmpesa");
        } elseif ($gateway == "kopokopo") {
            $url = (U . "plugin/initiatekopokopo");
        } elseif ($gateway !== null && strcasecmp((string) $gateway, 'paystack') === 0) {
            $url = '';
        } else {
            header('Content-Type: application/json; charset=utf-8');
            echo json_encode(["status" => "error", "message" => "Payment gateway not configured"]);
            exit();
        }

        $usePaystack = ($gateway !== null && strcasecmp((string) $gateway, 'paystack') === 0);

        $Planname = ORM::for_table('tbl_plans')
            ->where('id', $planId)
            ->order_by_desc('id')
            ->find_one();
        $Findrouter = ORM::for_table('tbl_routers')
            ->where('id', $routerId)
            ->order_by_desc('id')
            ->find_one();

        $rname = $Findrouter->name;
        $price = $Planname->price;
        $Planname = $Planname->name_plan;

        $Checkorders = ORM::for_table('tbl_payment_gateway')
            ->where('username', $user_Account)
            ->where('status', 1)
            ->order_by_desc('id')
            ->find_many();

        if ($Checkorders) {
            foreach ($Checkorders as $Dorder) {
                $Dorder->delete();
            }
        }

        //check first if routers_id column is available in the table if not add it
        $table = ORM::for_table('tbl_payment_gateway')->raw_query('SHOW COLUMNS FROM tbl_payment_gateway LIKE "routers_id"')->find_one();
        if (!$table) {
            $sql = "ALTER TABLE tbl_payment_gateway ADD routers_id VARCHAR(255) AFTER plan_name";
            ORM::for_table('tbl_payment_gateway')->raw_execute($sql);
        }

        //check first if mac_address column is available in the table if not add it
        $table = ORM::for_table('tbl_payment_gateway')->raw_query('SHOW COLUMNS FROM tbl_payment_gateway LIKE "mac_address"')->find_one();
        if (!$table) {
            $sql = "ALTER TABLE tbl_payment_gateway ADD mac_address VARCHAR(255) AFTER gateway";
            ORM::for_table('tbl_payment_gateway')->raw_execute($sql);
        }

        $d = ORM::for_table('tbl_payment_gateway')->create();
        $d->username = $user_Account;
        $d->gateway = $gateway;
        $d->mac_address = $mac_address;
        $d->plan_id = $planId;
        $d->plan_name = $Planname;
        $d->routers_id = $routerId;
        $d->routers = $rname;
        $d->price = $price;
        $d->payment_method = $gateway;
        $d->payment_channel = $gateway;
        $d->created_date = date('Y-m-d H:i:s');
        $d->paid_date = date('Y-m-d H:i:s');
        $d->expired_date = date('Y-m-d H:i:s');
        $d->pg_url_payment = $usePaystack ? '' : $url;
        $d->status = 1;
        $d->save();
        if ($usePaystack) {
            CreateHotspotUser_paystackInitialize($d, $user_Account, $phone);
            exit();
        }
        SendSTKcred($phone, $user_Account, $url);
        exit();
    } catch (Exception $e) {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["status" => "error", "message" => $e->getMessage()]);
        exit();
    }
}

/**
 * Paystack rejects many synthetic addresses (e.g. *.local). Prefer customer email, then APP_URL host, then same pattern as new Hotspot users ({username}@gmail.com).
 */
function CreateHotspotUser_paystackResolveEmail($user_account, $phone)
{
    $user_account = trim((string) $user_account);
    $cust = ORM::for_table('tbl_customers')->where('username', $user_account)->find_one();
    if ($cust && !empty($cust->email)) {
        $e = filter_var(trim((string) $cust->email), FILTER_VALIDATE_EMAIL);
        if ($e) {
            return $e;
        }
    }
    if (filter_var($user_account, FILTER_VALIDATE_EMAIL)) {
        return $user_account;
    }
    $digits = preg_replace('/\D+/', '', (string) $phone);
    $local = preg_replace('/[^a-zA-Z0-9._%+-]/', '_', $user_account);
    $local = preg_replace('/_+/', '_', $local);
    $local = trim($local, '._+-');
    if ($local === '' && $digits !== '') {
        $local = $digits;
    }
    if ($local === '') {
        $local = 'u' . substr(preg_replace('/\W/', '', md5($user_account . $digits)), 0, 12);
    }
    if (strlen($local) > 64) {
        $local = substr($local, 0, 64);
    }
    $host = '';
    if (defined('APP_URL') && APP_URL) {
        $parsed = parse_url(APP_URL, PHP_URL_HOST);
        $host = $parsed ? strtolower((string) $parsed) : '';
    }
    if ($host !== '' && $host !== 'localhost' && strpos($host, '127.') !== 0 && !filter_var($host, FILTER_VALIDATE_IP)) {
        return $local . '@' . $host;
    }
    return $local . '@gmail.com';
}

/**
 * Start Paystack inline checkout for captive hotspot (tbl_payment_gateway row must be saved first).
 */
function CreateHotspotUser_paystackInitialize($gatewayRow, $user_account, $phone)
{
    $config = [];
    foreach (ORM::for_table('tbl_appconfig')->find_many() as $row) {
        $config[$row->setting] = $row->value;
    }
    $secret = trim($config['hotspot_paystack_secret_key'] ?? '');
    if ($secret === '') {
        $secret = trim($config['paystack_secret_key'] ?? '');
    }
    if ($secret === '') {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode([
            'status' => 'error',
            'message' => 'Paystack is not configured. Add Hotspot Paystack secret (Hotspot settings) or main Paystack secret (Payment Gateway).',
        ]);
        exit();
    }
    $reference = $gatewayRow->id . '_' . time();
    $amount = (int) round((float) $gatewayRow->price * 100);
    if ($amount < 1) {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(['status' => 'error', 'message' => 'Invalid plan price for Paystack.']);
        exit();
    }
    $email = CreateHotspotUser_paystackResolveEmail($user_account, $phone);
    $callbackUrl = rtrim(U, '/') . 'callback/paystack&trxref=' . rawurlencode($reference);
    $fields = [
        'email' => $email,
        'amount' => $amount,
        'reference' => $reference,
        'callback_url' => $callbackUrl,
        'metadata' => [
            'custom_fields' => [
                [
                    'display_name' => 'Username',
                    'variable_name' => 'username',
                    'value' => $user_account,
                ],
                [
                    'display_name' => 'Plan',
                    'variable_name' => 'plan_name',
                    'value' => $gatewayRow->plan_name,
                ],
            ],
        ],
    ];
    $ch = curl_init('https://api.paystack.co/transaction/initialize');
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($fields));
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Authorization: Bearer ' . $secret,
        'Content-Type: application/json',
        'Cache-Control: no-cache',
    ]);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    $result = curl_exec($ch);
    curl_close($ch);
    $response = json_decode($result, true);
    if (!is_array($response) || empty($response['status']) || empty($response['data']['authorization_url'])) {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode([
            'status' => 'error',
            'message' => isset($response['message']) ? $response['message'] : 'Paystack initialize failed',
        ]);
        exit();
    }
    $gw = ORM::for_table('tbl_payment_gateway')->find_one($gatewayRow->id);
    if ($gw) {
        $gw->gateway_trx_id = $reference;
        $gw->pg_url_payment = $response['data']['authorization_url'];
        $gw->pg_request = json_encode($fields);
        $gw->save();
    }
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode([
        'status' => 'success',
        'payment_method' => 'paystack',
        'authorization_url' => $response['data']['authorization_url'],
        'message' => 'Open Paystack to complete payment, then wait on this page.',
    ]);
    exit();
}

function SendSTKcred($phone, $user_Account, $url)
{
    $fields = [
        'username' => $user_Account,
        'phone' => $phone,
        'channel' => 'Yes',
    ];

    $postvars = json_encode($fields); // Encode fields as JSON

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $postvars);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true); // Capture the response
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Content-Type: application/json', // Set header to JSON
        'Content-Length: ' . strlen($postvars),
    ]);

    $result = curl_exec($ch);
    if ($result === false) {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["status" => "error", "message" => curl_error($ch)]);
        exit();
    }

    curl_close($ch);
    echo $result;
}

function RedeemVoucher()
{
    error_reporting(E_ERROR | E_PARSE);
    
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["status" => "error", "message" => "Invalid request method"]);
        exit();
    }

    try {
        $rawInput = file_get_contents('php://input');
        $input = json_decode($rawInput, true);
        
        if (json_last_error() !== JSON_ERROR_NONE) {
            header('Content-Type: application/json; charset=utf-8');
            echo json_encode(["status" => "error", "message" => "Invalid request data format"]);
            exit();
        }
    } catch (Exception $e) {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["status" => "error", "message" => "Failed to parse request data"]);
        exit();
    }
    
    $voucher_code = $input['voucher_code'] ?? '';
    $old_account_number = $input['account_number'] ?? '';
    $routerId = $input['router_id'] ?? '';

    // Validate required parameters
    if (empty($voucher_code) || empty($old_account_number) || empty($routerId)) {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["status" => "error", "message" => "Missing required parameters"]);
        exit();
    }

    // Remove whitespace
    $voucher_code = preg_replace('/\s+/', '', $voucher_code);
    
    // Validate minimum length (at least 2 characters)
    if (strlen($voucher_code) < 2) {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["status" => "error", "message" => "Voucher code must be at least 2 characters long"]);
        exit();
    }
    
    // Validate alphanumeric only (reject special characters)
    if (!preg_match('/^[a-zA-Z0-9]+$/', $voucher_code)) {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["status" => "error", "message" => "Invalid voucher code. Only letters and numbers are allowed (no special characters like #, @, etc.)"]);
        exit();
    }
    
    // USE VOUCHER CODE AS THE USERNAME (ACCOUNT NUMBER)
    // When user redeems voucher, they get a new account with voucher code as username
    $user_account = $voucher_code;

    // Use parameterized queries to prevent SQL injection
    // Try case-sensitive match first (for codes with letters)
    $voucher_code_data = ORM::for_table('tbl_voucher')
        ->where_raw("BINARY code = ?", [$voucher_code])
        ->where('status', 0)
        ->find_one();
    
    // If not found and code is numeric only, try case-insensitive match
    if (!$voucher_code_data && preg_match('/^[0-9]+$/', $voucher_code)) {
        $voucher_code_data = ORM::for_table('tbl_voucher')
            ->where('code', $voucher_code)
            ->where('status', 0)
            ->find_one();
    }

    if (!$voucher_code_data) {
        header('Content-Type: application/json; charset=utf-8');
        //CHECK IF VOUCHER CODE IS USED
        // Try case-sensitive match first
        $voucher_code_data_used = ORM::for_table('tbl_voucher')
            ->where_raw("BINARY code = ?", [$voucher_code])
            ->where('status', 1)
            ->find_one();
        
        // If not found and code is numeric only, try case-insensitive match
        if (!$voucher_code_data_used && preg_match('/^[0-9]+$/', $voucher_code)) {
            $voucher_code_data_used = ORM::for_table('tbl_voucher')
                ->where('code', $voucher_code)
                ->where('status', 1)
                ->find_one();
        }
        if ($voucher_code_data_used) {
            echo json_encode([
                "status" => "used",
                "message" => "Voucher code already used. Auto-logging you in...",
                "username" => $voucher_code_data_used['user'],
                "voucher" => $voucher_code_data_used['code'],
                "tyhK" => "1234",
            ]);
            exit();
        } else {
            echo json_encode(["status" => "error", "message" => "Invalid voucher code"]);
            exit();
        }
    }

    // Generate a phone number based on user account (for consistency)
    $phone = "254" . substr(md5($user_account), 0, 9); // Dynamic phone based on account

    // Validate that the voucher's router matches the requested router
    if ($voucher_code_data['routers'] !== ORM::for_table('tbl_routers')->where('id', $routerId)->find_one()->name) {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["status" => "error", "message" => "Voucher is not valid for this router"]);
        exit();
    }

    // *** FOLLOW SAME PATTERN AS REGULAR PURCHASE FLOW ***
    // Only for Hotspot service type, never override PPPoE users
    
    try {
        // MULTI-USER PER PHONE: Lookup ONLY by username (not dual-key)
        $Userexist = ORM::for_table('tbl_customers')->where('username', $user_account)
            ->where('service_type', 'Hotspot')  // ← Only Hotspot, never PPPoE
            ->find_one();

        if ($Userexist) {
            // User exists - RECHARGE instead of creating new
            $Userexist->router_id = $routerId;
            $Userexist->password = '1234';
            $Userexist->phonenumber = $phone; // Update phone for consistency
            $Userexist->save();
            
            // Recharge existing user using the voucher
            $rechargeStatus = Package::rechargeUser(
                $Userexist->id,  // Use existing user ID
                $voucher_code_data['routers'],
                $voucher_code_data['id_plan'],
                "Voucher",
                $voucher_code,
                '',
                $voucher_code  // Use voucher code as invoice
            );
        } else {
            // Check if this username exists as PPPoE or other service - DON'T override
            $UserexistAny = ORM::for_table('tbl_customers')->where('username', $user_account)->find_one();
            
            if ($UserexistAny && $UserexistAny->service_type !== 'Hotspot') {
                header('Content-Type: application/json; charset=utf-8');
                echo json_encode(["status" => "error", "message" => "This account is registered as " . $UserexistAny->service_type . " service, cannot convert to Hotspot"]);
                exit();
            }

            // User doesn't exist - create new user (same as regular flow)
            
            // Check if `router_id` column exists, if not, add it (Run only once)
            $tableCheck = ORM::for_table('tbl_customers')
                ->raw_query('SHOW COLUMNS FROM tbl_customers LIKE "router_id"')
                ->find_one();

            if (!$tableCheck) {
                ORM::for_table('tbl_customers')->raw_execute("ALTER TABLE tbl_customers ADD router_id VARCHAR(255) AFTER fullname");
            }

            // Define default values
            $defpass = '1234';
            $defaddr = 'Hotspot Address';
            $defmail = $user_account . '@gmail.com';

            // Create a new Hotspot user
            $createUser = ORM::for_table('tbl_customers')->create();
            $createUser->username = $user_account;
            $createUser->password = $defpass;
            $createUser->fullname = $phone;
            $createUser->router_id = $routerId;
            $createUser->phonenumber = $phone;
            $createUser->pppoe_password = $defpass;
            $createUser->address = $defaddr;
            $createUser->email = $defmail;
            $createUser->service_type = 'Hotspot';  // ← Explicitly Hotspot only
            
            if (!$createUser->save()) {
                header('Content-Type: application/json; charset=utf-8');
            echo json_encode(["status" => "error", "message" => "User creation failed"]);
            exit();
        }

        // Recharge new user using the voucher
        $rechargeStatus = Package::rechargeUser(
            $createUser->id,  // Use newly created user ID
            $voucher_code_data['routers'],
            $voucher_code_data['id_plan'],
            "Voucher",
            $voucher_code,
            '',
            $voucher_code  // Use voucher code as invoice
        );
    }

        if ($rechargeStatus) {
            $voucher_code_data->status = 1;
            $voucher_code_data->used_date = date('Y-m-d H:i:s');
            $voucher_code_data->user = $user_account;
            $voucher_code_data->save();

            header('Content-Type: application/json; charset=utf-8');
            echo json_encode([
                "status" => "success",
                "message" => "Voucher redeemed successfully",
                "username" => $user_account,
                "voucher" => $voucher_code,
                "tyhK" => "1234",
            ]);
            exit();
        } else {
            header('Content-Type: application/json; charset=utf-8');
            echo json_encode(["status" => "error", "message" => "Failed to recharge user"]);
            exit();
        }
    } catch (Exception $e) {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["status" => "error", "message" => "System error: " . $e->getMessage()]);
        exit();
    }
}


function MpesaCodeLogin()
{
    // Ensure the request method is POST
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        sendJsonMpesaCodeResponse("error", "Invalid request method");
    }

    // Get input data
    $input = json_decode(file_get_contents('php://input'), true);
    $mpesa_code = $input['mpesa_code'] ?? '';

    // Validate required parameters
    if (empty($mpesa_code)) {
        sendJsonMpesaCodeResponse("error", "Missing required parameters");
    }

    // Get the first 10 characters of the Mpesa code
    $mpesa_code = substr($mpesa_code, 0, 10);

    // Fetch user details from the database
    $user = ORM::for_table('tbl_payment_gateway')
        ->where('gateway_trx_id', $mpesa_code)
        ->order_by_desc('id')
        ->find_one();

    if ($user) {
        $status = $user->status;
        $mpesacode = $user->gateway_trx_id;
        $res = $user->pg_paid_response;

        if ($status == 2) {
            sendJsonMpesaCodeResponse("success", "We have received your transaction under the Mpesa Transaction $mpesacode, Please don't leave this page as we are redirecting you", [
                "Resultcode" => "3",
                "username" => $user->username,
                "tyhK" => "1234",
            ]);
        } elseif ($res == "Not enough balance") {
            sendJsonMpesaCodeResponse("danger", "Insufficient Balance for the transaction", [
                "Resultcode" => "2",
                "Redirect" => "Insufficient balance"
            ]);
        } elseif ($res == "Wrong Mpesa pin") {
            sendJsonMpesaCodeResponse("danger", "You entered Wrong Mpesa pin, please resubmit", [
                "Resultcode" => "2",
                "Redirect" => "Wrong Mpesa pin"
            ]);
        } elseif ($status == 4) {
            sendJsonMpesaCodeResponse("danger", "You cancelled the transaction, you can enter phone number again to activate", [
                "Resultcode" => "2",
                "Redirect" => "Transaction Cancelled"
            ]);
        } else {
            sendJsonMpesaCodeResponse("primary", "A payment pop-up has been sent, Please enter PIN to continue (Please do not leave or reload the page until redirected)", [
                "Resultcode" => "1"
            ]);
        }
    } else {
        sendJsonMpesaCodeResponse("error", "Mpesa code $mpesa_code not found");
    }
}

function GetHotspotSettings()
{
    // Check if the request method is GET (for settings)
    if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["status" => "error", "message" => "Invalid request method"]);
        exit();
    }

    // Get settings from database
    $settings = [];
    $settingsToFetch = ['phone', 'hotspot_title', 'CompanyName', 'faq1', 'faq2', 'faq3'];

    foreach ($settingsToFetch as $setting) {
        $result = ORM::for_table('tbl_appconfig')
            ->where('setting', $setting)
            ->find_one();
        $settings[$setting] = $result ? $result->value : '';
    }

    $pg = ORM::for_table('tbl_appconfig')->where('setting', 'payment_gateway')->find_one();
    $settings['payment_gateway'] = $pg ? $pg->value : '';
    $hpk = ORM::for_table('tbl_appconfig')->where('setting', 'hotspot_paystack_public_key')->find_one();
    $mpk = ORM::for_table('tbl_appconfig')->where('setting', 'paystack_public_key')->find_one();
    $settings['paystack_public_key'] = trim($hpk && $hpk->value ? $hpk->value : ($mpk ? $mpk->value : ''));

    header('Content-Type: application/json; charset=utf-8');
    echo json_encode([
        "status" => "success",
        "data" => $settings
    ]);
    exit();
}

/**
 * Helper function to send JSON response
 */
function sendJsonMpesaCodeResponse($status, $message, $data = [])
{
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode(array_merge(["status" => $status, "message" => $message], $data));
    exit();
}
