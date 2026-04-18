<?php

/**
 * Bismillahir Rahmanir Raheem
 * 
 * PHP Mikrotik Billing (https://github.com/paybilling/phpnuxbill/)
 *
 * Advanced Hotspot System For PHPNuxBill 
 *
 * @author: Focuslinks Digital Solutions <focuslinkstech@gmail.com>
 * Website: https://focuslinkstech.com.ng/
 * GitHub: https://github.com/Focuslinkstech/
 * Telegram: https://t.me/focuslinkstech/
 *
 **/


// Security Constants
$hotspotProductName = 'Advanced Hotspot System';
$hotspotContactLink = "https://t.me/focuslinkstech";
$hotspotContactEmail = "focuslinkstech@gmail.com";
$hotspotContactPhone = "";
$hotspotCompanyName = "Focuslinks Digital Solutions";
$hotspotCompanyURL = "https://shop.focuslinkstech.com.ng";
$hotspotCopyrightYear = date("Y");
$hotspotLicenseLink = 'https://license.focuslinkstech.com.ng/?_route=plugin/license/api';
$hotspotUpdateLink = 'https://license.focuslinkstech.com.ng/?_route=plugin/license/update/check';
$hotspotApiKey = 'd5f02207f3428715b01c141fb42f07215ae3bc19';
$hotspotProductVersion = '3.7';
$hotspotReport = '1154170409';
if (function_exists('app_cors_apply_headers')) {
    app_cors_apply_headers(false);
}
if (isset($_SERVER['REQUEST_METHOD']) && $_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit;
}

use PEAR2\Net\RouterOS;

// Include hotspot token module
$hotspotTokenFile = __DIR__ . '/hotspot_voucher/hotspot_token.php';
if (file_exists($hotspotTokenFile)) {
    require_once $hotspotTokenFile;
}

// Helper to register plugin template directory with Smarty (called inside functions where $ui is available)
function _hotspot_register_templates()
{
    global $ui;
    static $registered = false;
    if (!$registered && isset($ui)) {
        $ui->addTemplateDir(__DIR__ . DIRECTORY_SEPARATOR . 'hotspot_voucher' . DIRECTORY_SEPARATOR . 'ui' . DIRECTORY_SEPARATOR, 'hotspot');
        $registered = true;
    }
}

register_menu(" Hotspot", true, "hotspot_overview", 'AFTER_MESSAGE', 'ion ion-android-wifi', '', "");
register_menu("Hotspot System Settings", true, "hotspot_config", 'SETTINGS', '', '', "");
register_menu(" Hotspot Voucher", true, "hotspot_voucher", 'AFTER_MESSAGE', 'ion ion-card', '', "");
register_hook('cronjob_end', 'hotspot_cron');

function hotspot_overview()
{
    global $ui, $hotspotProductName, $hotspotProductVersion;
    _hotspot_register_templates();
    _admin();
    $ui->assign('_title', 'Advanced Hotspot System');
    $ui->assign('_system_menu', '');
    $admin = Admin::_info();
    $ui->assign('_admin', $admin);
    $ui->assign('productName', $hotspotProductName);
    $ui->assign('version', $hotspotProductVersion);
    hotspot_installDB();
    // Check user type for access
    if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin', 'Sales'])) {
        _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
        exit;
    }
    if (hotspot_engine()) {
        $CACHE_PATH = 'system/cache/';
        if (isset($_GET['refresh'])) {
            $files = scandir($CACHE_PATH);
            foreach ($files as $file) {
                $ext = pathinfo($file, PATHINFO_EXTENSION);
                if (is_file($CACHE_PATH . DIRECTORY_SEPARATOR . $file) && $ext == 'json') {
                    unlink($CACHE_PATH . DIRECTORY_SEPARATOR . $file);
                }
            }
            r2(U . 'plugin/hotspot_overview', 's', 'Data Refreshed');
        }

        $cacheDir = 'system/cache/';
        $cacheKey = "hotspot_overview_" . md5($admin['user_type']);
        $cacheFile = "$cacheDir$cacheKey.json";
        $cacheTime = 3600; // Cache for 1 hour

        // Create cache directory if not exists
        if (!file_exists($cacheDir)) {
            mkdir($cacheDir, 0755, true);
        }

        // Check if cache file exists and is still valid
        if (file_exists($cacheFile) && (time() - filemtime($cacheFile)) < $cacheTime) {
            $cacheData = json_decode(file_get_contents($cacheFile), true);
            $payments = array_map(function ($payment) {
                return ORM::for_table('tbl_hotspot_payments')->create($payment);
            }, $cacheData['payments']);

            hotspot_backfillPaymentVoucherCodes($payments);

            foreach ($cacheData as $key => $value) {
                if ($key !== 'payments') {
                    $ui->assign($key, $value);
                }
            }

            $totalVouchers = 0;
            try {
                $totalVouchers = ORM::for_table('tbl_hotspot_vouchers')->count();
            } catch (Throwable $e) {
            }
            $ui->assign('totalVouchers', $totalVouchers);

            $ui->assign('payments', $payments);
            $ui->display('hotspot_overview.tpl');
            exit;
        }

        $query = ORM::for_table('tbl_hotspot_payments')->order_by_desc('created_date');
        $payments = $query->find_many();

        hotspot_backfillPaymentVoucherCodes($payments);

        // Get successful payments
        $successfulPayments = ORM::for_table('tbl_hotspot_payments')
            ->where('transaction_status', 'paid')
            ->count();

        // Get failed payments
        $failedPayments = ORM::for_table('tbl_hotspot_payments')
            ->where('transaction_status', 'failed')
            ->count();

        // Get pending payments
        $pendingPayments = ORM::for_table('tbl_hotspot_payments')
            ->where('transaction_status', 'pending')
            ->count();

        // Get cancelled payments
        $cancelledPayments = ORM::for_table('tbl_hotspot_payments')
            ->where('transaction_status', 'cancelled')
            ->count();

        // Get monthly sales data
        $monthlySales = ORM::for_table('tbl_hotspot_payments')
            ->select_expr('YEAR(created_date) AS year')
            ->select_expr('MONTH(created_date) AS month')
            ->select_expr('SUM(amount) AS total_sales')
            ->where('transaction_status', 'paid')
            ->group_by_expr('YEAR(created_date)')
            ->group_by_expr('MONTH(created_date)')
            ->group_by_expr('DATE_FORMAT(created_date, "%Y-%m")')
            ->find_array();

        $monthlyData = [];
        foreach ($monthlySales as $sale) {
            $monthYear = $sale['month'] . '-' . $sale['year'];
            $monthlyData[$monthYear] = $sale['total_sales'];
        }

        $startDate = date('Y-m-d', strtotime('this week'));
        $endDate = date('Y-m-d', strtotime('this week +6 days'));

        // Get weekly sales data
        $weeklySales = ORM::for_table('tbl_hotspot_payments')
            ->select_expr('YEAR(created_date) AS year')
            ->select_expr('WEEK(created_date, 1) AS week')
            ->select_expr('SUM(amount) AS total_sales')
            ->where('transaction_status', 'paid')
            ->where_gte('created_date', $startDate)
            ->where_lte('created_date', $endDate)
            ->group_by_expr('YEAR(created_date)')
            ->group_by_expr('WEEK(created_date, 1)')
            ->find_array();

        $weeklyData = [];
        foreach ($weeklySales as $sale) {
            $yearWeek = 'Week ' . $sale['week'] . ', ' . $sale['year'];
            $weeklyData[$yearWeek] = $sale['total_sales'];
        }

        // Get weekly sales data grouped by day of the week
        $weeklySales = ORM::for_table('tbl_hotspot_payments')
            ->select_expr('DAYOFWEEK(created_date) AS day_of_week')
            ->select_expr('SUM(amount) AS total_sales')
            ->where('transaction_status', 'paid')
            ->where_gte('created_date', $startDate)
            ->where_lte('created_date', $endDate)
            ->group_by_expr('DAYOFWEEK(created_date)')
            ->find_array();

        $daysOfWeek = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
        $weeklySalesData = array_fill_keys($daysOfWeek, 0);

        foreach ($weeklySales as $sale) {
            $dayIndex = ($sale['day_of_week'] + 6) % 7;
            $day = $daysOfWeek[$dayIndex];
            $weeklySalesData[$day] = $sale['total_sales'];
        }

        $chartData = [
            'labels' => $daysOfWeek,
            'data' => array_values($weeklySalesData)
        ];

        $today = date('Y-m-d');

        $dailySales = ORM::for_table('tbl_hotspot_payments')
            ->select_expr('DATE(created_date) AS date')
            ->select_expr('SUM(amount) AS total_sales')
            ->where('transaction_status', 'paid')
            ->where_raw('DATE(created_date) = ?', [$today])
            ->group_by_expr('DATE(created_date)')
            ->find_array();

        $dailyData = [];
        foreach ($dailySales as $sale) {
            $dailyData[$sale['date']] = $sale['total_sales'];
        }

        $paymentGateway = hotspot_getAvailablePaymentGateways();
        if (!$paymentGateway) {
            $ui->assign('message', '<em>' . Lang::T("Payment Gateway is missing, you can purchase payment gateway plugin from ") . ' <a href="https://shop.focuslinkstech.com.ng"> shop.focuslinkstech.com.ng </a>' . ' ' . ' ' . Lang::T(" or Contact ") . ' ' . '<a href="https://t.me/focuslinkstech"> @focuslinkstech </a>' . ' ' . Lang::T(" for more informations") . '</em>');
        }

        $hotspotTokens = ORM::for_table('tbl_hotspot_tokens')->find_many();
        $usedCount = 0;
        $unusedCount = 0;

        foreach ($hotspotTokens as $token) {
            $token->used_count > 0 ? $usedCount++ : $unusedCount++;
        }

        $totalVouchers = 0;
        try {
            $totalVouchers = ORM::for_table('tbl_hotspot_vouchers')->count();
        } catch (Throwable $e) {
            // Table may not exist yet
        }

        // Prepare data to cache
        $cacheData = [
            'dailySalesData' => json_encode(array_values($dailyData)),
            'chartData' => json_encode($chartData),
            'monthlyData' => json_encode($monthlyData),
            'weeklyData' => json_encode($weeklyData),
            'successfulPayments' => $successfulPayments,
            'failedPayments' => $failedPayments,
            'pendingPayments' => $pendingPayments,
            'cancelledPayments' => $cancelledPayments,
            'totalVouchers' => $totalVouchers,
            'payments' => array_map(function ($payment) {
                return $payment->as_array();
            }, iterator_to_array($payments)),
            'xheader' => '<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.11.3/css/jquery.dataTables.min.css">',
            'used' => $usedCount,
            'unused' => $unusedCount,
        ];

        // Save to cache file
        file_put_contents($cacheFile, json_encode($cacheData));
        foreach ($cacheData as $key => $value) {
            if ($key !== 'payments') {
                $ui->assign($key, $value);
            }
        }

        $ui->assign('payments', $payments);
        $ui->display('hotspot_overview.tpl');
    } else {
        hotspot_install();
    }
}


function hotspot_plan()
{
    if (function_exists('app_cors_apply_headers')) {
        app_cors_apply_headers(false);
    }
    if (isset($_SERVER['REQUEST_METHOD']) && $_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
        exit;
    }

    global $config;
    if (empty($config['hotspot_key'])) {
        $message = 'An error occurred. Please try again later or contact administrator.';
        $response = [
            'ResultCode' => "201",
            'message' => $message,
        ];
        echo json_encode($response, JSON_PRETTY_PRINT);
        exit;
    }
    $currency = $config['currency_code'];

    if ($_SERVER['REQUEST_METHOD'] != 'POST') {
        $response = [
            'ResultCode' => "201",
            'message' => "Invalid Request method"
        ];
        echo json_encode($response, JSON_PRETTY_PRINT);
        exit;
    }
    switch ($config['hotspot_radius_mode']) {
        case '1':
            $routername = "Radius";
            $cacheDir = 'system/cache/';
            $cacheKey = "hotspot_plan_" . md5($routername);
            $cacheFile = "$cacheDir$cacheKey.json";
            $cacheTime = 3600; // Cache for 1 hour

            // Create cache directory if not exists
            if (!file_exists($cacheDir)) {
                mkdir($cacheDir, 0755, true);
            }

            // Check if cache file exists and is still valid
            if (file_exists($cacheFile) && (time() - filemtime($cacheFile)) < $cacheTime) {
                echo file_get_contents($cacheFile);
                exit;
            }

            $hotspotplan = ORM::for_table('tbl_plans')
                ->where('type', 'Hotspot')
                ->where('device', 'Radius')
                ->where('is_radius', 1)
                ->where('enabled', 1)
                ->find_many();

            if (count($hotspotplan) > 0) {
                $response = [
                    'ResultCode' => "200",
                    'message' => "Success",
                    'data' => []
                ];

                foreach ($hotspotplan as $row) {
                    $limittype = $row->typebp;
                    $bandwidth = $row->id_bw;
                    $bandwidthrow = ORM::for_table('tbl_bandwidth')->where('id', $bandwidth)->find_one();

                    if ($bandwidthrow) {
                        $rate_down = $bandwidthrow->rate_down;
                        $rate_down_unit = $bandwidthrow->rate_down_unit;
                        $rate_up = $bandwidthrow->rate_up;
                        $rate_up_unit = $bandwidthrow->rate_up_unit;
                        $downlimit = "$rate_down $rate_down_unit";
                        $uplimit = "$rate_up $rate_up_unit";
                        $paymentlink = U . "plugin/hotspot_pay&planid=" . $row->id . "&routername=" . $routername;
                        $planId = $row->id;
                        switch ($limittype) {
                            case 'Unlimited':
                                $validity = "{$row->validity} {$row->validity_unit}";
                                $data = [
                                    'plantype' => "Time Limit",
                                    'planname' => $row->name_plan,
                                    'currency' => $currency,
                                    'price' => $row->price,
                                    'downlimit' => $downlimit,
                                    'uplimit' => $uplimit,
                                    'timelimit' => "Unlimited",
                                    'validity' => $validity,
                                    'device' => $row->shared_users,
                                    'datalimit' => 'Unlimited',
                                    'paymentlink' => $paymentlink,
                                    'planId' => $planId,
                                    'routerName' => $routername
                                ];
                                $response['data'][] = $data;
                                break;
                            case 'Limited':
                                $limit_type = $row->limit_type;
                                switch ($limit_type) {
                                    case 'Time_Limit':
                                        $timelimit = "{$row->time_limit} {$row->time_unit}";
                                        $validity = "{$row->validity} {$row->validity_unit}";
                                        $data = [
                                            'plantype' => "Time Limit",
                                            'planname' => $row->name_plan,
                                            'currency' => $currency,
                                            'price' => $row->price,
                                            'downlimit' => $downlimit,
                                            'uplimit' => $uplimit,
                                            'timelimit' => $timelimit,
                                            'validity' => $validity,
                                            'device' => $row->shared_users,
                                            'datalimit' => 'Unlimited',
                                            'paymentlink' => $paymentlink,
                                            'planId' => $planId,
                                            'routerName' => $routername
                                        ];
                                        $response['data'][] = $data;
                                        break;
                                    case 'Data_Limit':
                                        $datalimit = "{$row->data_limit} {$row->data_unit}";
                                        $validity = "{$row->validity} {$row->validity_unit}";
                                        $data = [
                                            'plantype' => "Data Limit",
                                            'planname' => $row->name_plan,
                                            'currency' => $currency,
                                            'price' => $row->price,
                                            'downlimit' => $downlimit,
                                            'uplimit' => $uplimit,
                                            'timelimit' => 'Unlimited',
                                            'validity' => $validity,
                                            'device' => $row->shared_users,
                                            'datalimit' => $datalimit,
                                            'paymentlink' => $paymentlink,
                                            'planId' => $planId,
                                            'routerName' => $routername
                                        ];
                                        $response['data'][] = $data;
                                        break;
                                    case 'Both_Limit':
                                        $timelimit = "{$row->time_limit} {$row->time_unit}";
                                        $datalimit = "{$row->data_limit} {$row->data_unit}";
                                        $validity = "{$row->validity} {$row->validity_unit}";
                                        $data = [
                                            'plantype' => "Time & Data Limit",
                                            'planname' => $row->name_plan,
                                            'currency' => $currency,
                                            'price' => $row->price,
                                            'downlimit' => $downlimit,
                                            'uplimit' => $uplimit,
                                            'timelimit' => $timelimit,
                                            'validity' => $validity,
                                            'device' => $row->shared_users,
                                            'datalimit' => $datalimit,
                                            'paymentlink' => $paymentlink,
                                            'planId' => $planId,
                                            'routerName' => $routername
                                        ];
                                        $response['data'][] = $data;
                                        break;
                                    default:
                                        $response = [
                                            'ResultCode' => "204",
                                            'message' => "unknown limit type"
                                        ];
                                        echo json_encode($response, JSON_PRETTY_PRINT);
                                        exit;
                                }
                                break;
                            default:
                                $response = [
                                    'ResultCode' => "204",
                                    'message' => "unknown bandwidth type"
                                ];
                                echo json_encode($response, JSON_PRETTY_PRINT);
                                exit;
                        }
                    }
                }

                $responseJson = json_encode($response, JSON_PRETTY_PRINT);
                file_put_contents($cacheFile, $responseJson); // Save to cache file
                echo $responseJson;
            } else {
                $response = [
                    'ResultCode' => "204",
                    'message' => "No Hotspot Plan Found"
                ];
                echo json_encode($response, JSON_PRETTY_PRINT);
            }
            break;

        default:
            $routername = $_POST['routername'];
            if (empty($routername)) {
                $response = [
                    'ResultCode' => "202",
                    'message' => "Please fill all fields $routername"
                ];
                echo json_encode($response, JSON_PRETTY_PRINT);
                exit;
            }

            $cacheDir = 'system/cache/';
            $cacheKey = "hotspot_plan_" . md5($routername);
            $cacheFile = "$cacheDir$cacheKey.json";
            $cacheTime = 3600; // Cache for 1 hour

            // Create cache directory if not exists
            if (!file_exists($cacheDir)) {
                mkdir($cacheDir, 0755, true);
            }

            // Check if cache file exists and is still valid
            if (file_exists($cacheFile) && (time() - filemtime($cacheFile)) < $cacheTime) {
                echo file_get_contents($cacheFile);
                exit;
            }

            $checkrouter = ORM::for_table('tbl_routers')->where('name', $routername)->find_one();
            if (!$checkrouter) {
                $response = [
                    'ResultCode' => "205",
                    'message' => "Router Not Found"
                ];
                echo json_encode($response, JSON_PRETTY_PRINT);
                exit;
            }

            $hotspotplan = ORM::for_table('tbl_plans')
                ->where('type', 'Hotspot')
                ->where('routers', $routername)
                ->where('enabled', 1)
                ->find_many();

            if (count($hotspotplan) > 0) {
                $response = [
                    'ResultCode' => "200",
                    'message' => "Success",
                    'data' => []
                ];

                foreach ($hotspotplan as $row) {
                    $limittype = $row->typebp;
                    $bandwidth = $row->id_bw;
                    $bandwidthrow = ORM::for_table('tbl_bandwidth')->where('id', $bandwidth)->find_one();

                    if ($bandwidthrow) {
                        $rate_down = $bandwidthrow->rate_down;
                        $rate_down_unit = $bandwidthrow->rate_down_unit;
                        $rate_up = $bandwidthrow->rate_up;
                        $rate_up_unit = $bandwidthrow->rate_up_unit;
                        $downlimit = "$rate_down $rate_down_unit";
                        $uplimit = "$rate_up $rate_up_unit";
                        $paymentlink = U . "plugin/hotspot_pay&planid=" . $row->id . "&routername=" . $routername;
                        $planId = $row->id;
                        switch ($limittype) {
                            case 'Unlimited':
                                $validity = "{$row->validity} {$row->validity_unit}";
                                $data = [
                                    'plantype' => "Time Limit",
                                    'planname' => $row->name_plan,
                                    'currency' => $currency,
                                    'price' => $row->price,
                                    'downlimit' => $downlimit,
                                    'uplimit' => $uplimit,
                                    'timelimit' => "Unlimited",
                                    'validity' => $validity,
                                    'device' => $row->shared_users,
                                    'datalimit' => 'Unlimited',
                                    'paymentlink' => $paymentlink,
                                    'planId' => $planId,
                                    'routerName' => $routername
                                ];
                                $response['data'][] = $data;
                                break;
                            case 'Limited':
                                $limit_type = $row->limit_type;
                                switch ($limit_type) {
                                    case 'Time_Limit':
                                        $timelimit = "{$row->time_limit} {$row->time_unit}";
                                        $validity = "{$row->validity} {$row->validity_unit}";
                                        $data = [
                                            'plantype' => "Time Limit",
                                            'planname' => $row->name_plan,
                                            'currency' => $currency,
                                            'price' => $row->price,
                                            'downlimit' => $downlimit,
                                            'uplimit' => $uplimit,
                                            'timelimit' => $timelimit,
                                            'validity' => $validity,
                                            'device' => $row->shared_users,
                                            'datalimit' => 'Unlimited',
                                            'paymentlink' => $paymentlink,
                                            'planId' => $planId,
                                            'routerName' => $routername
                                        ];
                                        $response['data'][] = $data;
                                        break;
                                    case 'Data_Limit':
                                        $datalimit = "{$row->data_limit} {$row->data_unit}";
                                        $validity = "{$row->validity} {$row->validity_unit}";
                                        $data = [
                                            'plantype' => "Data Limit",
                                            'planname' => $row->name_plan,
                                            'currency' => $currency,
                                            'price' => $row->price,
                                            'downlimit' => $downlimit,
                                            'uplimit' => $uplimit,
                                            'timelimit' => 'Unlimited',
                                            'validity' => $validity,
                                            'device' => $row->shared_users,
                                            'datalimit' => $datalimit,
                                            'paymentlink' => $paymentlink,
                                            'planId' => $planId,
                                            'routerName' => $routername
                                        ];
                                        $response['data'][] = $data;
                                        break;
                                    case 'Both_Limit':
                                        $timelimit = "{$row->time_limit} {$row->time_unit}";
                                        $datalimit = "{$row->data_limit} {$row->data_unit}";
                                        $validity = "{$row->validity} {$row->validity_unit}";
                                        $data = [
                                            'plantype' => "Time & Data Limit",
                                            'planname' => $row->name_plan,
                                            'currency' => $currency,
                                            'price' => $row->price,
                                            'downlimit' => $downlimit,
                                            'uplimit' => $uplimit,
                                            'timelimit' => $timelimit,
                                            'validity' => $validity,
                                            'device' => $row->shared_users,
                                            'datalimit' => $datalimit,
                                            'paymentlink' => $paymentlink,
                                            'planId' => $planId,
                                            'routerName' => $routername
                                        ];
                                        $response['data'][] = $data;
                                        break;
                                    default:
                                        $response = [
                                            'ResultCode' => "204",
                                            'message' => "unknown limit type"
                                        ];
                                        echo json_encode($response, JSON_PRETTY_PRINT);
                                        exit;
                                }
                                break;
                            default:
                                $response = [
                                    'ResultCode' => "204",
                                    'message' => "unknown bandwidth type"
                                ];
                                echo json_encode($response, JSON_PRETTY_PRINT);
                                exit;
                        }
                    }
                }

                $responseJson = json_encode($response, JSON_PRETTY_PRINT);
                file_put_contents($cacheFile, $responseJson); // Save to cache file
                echo $responseJson;
            } else {
                $response = [
                    'ResultCode' => "204",
                    'message' => "No Hotspot Plan Found"
                ];
                echo json_encode($response, JSON_PRETTY_PRINT);
            }
            break;
    }
}
function hotspot_pay()
{
    global $config;

    if (empty($config['hotspot_key'])) {
        hotspot_throwError('An error occurred. Please try again later or contact administrator.');
        exit;
    }

    if ($config['maintenance_mode']) {
        displayMaintenanceMessage();
        die();
    }

    $payment_gateways = hotspot_getAvailablePaymentGateways();

    if (isset($_GET['planid']) || isset($_GET['routername'])) {
        $routername = $_GET['routername'] ?? '';
        $planid = $_GET['planid'] ?? '';
        $mac_address = $_GET['mac'] ?? '';
        $ip_address = $_GET['ip'] ?? '';

        hotspot_validateMacAddress($mac_address);

        $plan = hotspot_getHotspotPlan($planid);
        if (!$plan) {
            hotspot_throwError(Lang::T("Invalid plan selected."));
        }

        $amount = $plan['price'];
        $plan_name = $plan['name_plan'];
        $validity = $plan['validity'] . ' ' . $plan['validity_unit'];
    }

    if (isset($_POST['pay'])) {
        $payment_data = hotspot_validateAndPreparePaymentData($_POST);

        // Ensure payment type is set
        if (!isset($_POST['type'])) {
            hotspot_throwError(Lang::T("Payment type is required."));
            die();
        }

        $type = $_POST['type'];
        $gateway = preg_replace('/[^a-zA-Z0-9_]/', '', $payment_data['payment_gateway']);

        if ($type === 'token') {
            $token = $_POST['payment_token'] ?? null; // Avoid undefined index warnings
            if (empty($token)) {
                hotspot_throwError(Lang::T("Payment token is required."));
                die();
            }
            if (!ctype_digit($token)) {
                hotspot_throwError(Lang::T("Invalid token value, Token must be only numeric value."));
                die();
            }

            $function_name = "hotspot_processPayment_tokens";
            if (function_exists($function_name)) {
                $result = $function_name($payment_data);
                if (!$result) {
                    hotspot_throwError(Lang::T("Failed to process payment using payment token. Please try again."));
                } else {
                    echo $result;
                }
            } else {
                sendTelegram("Error: Token payment processing function not found, Please Check the system");
                hotspot_throwError(Lang::T("We are currently experiencing problems trying to connect to this module. Please go back and try again, or report this issue to ") . ' <a href="tel:' . ($config['phone'] ?? 'Not Available') . '">' . ($config['phone'] ?? 'Not Available') . '</a><br><br>' . Lang::T("Thanks."));
            }
        } else {
            $function_name = "hotspot_processPayment_$gateway";
            if (function_exists($function_name)) {
                $result = $function_name($payment_data);
                echo $result;
            } else {
                hotspot_throwError(Lang::T("$gateway payment processing function not found. Please go back and try again, or report this issue to ") . ' <a href="tel:' . ($config['phone'] ?? 'Not Available') . '">' . ($config['phone'] ?? 'Not Available') . '</a><br><br>' . Lang::T("Thanks."));
            }
        }
    } else {
        hotspot_displayPaymentForm($payment_gateways, $planid, $plan_name, $amount, $routername, $validity, $mac_address, $ip_address);
    }
}


function hotspot_getAvailablePaymentGateways()
{
    $payment_gateways = [
        [
            'filename' => 'hotspot_pg-paystack.php',
            'value' => 'paystack',
            'name' => 'PayStack'
        ]
    ];
    return $payment_gateways;
}

function hotspot_getEmailAddress($phone)
{
    $serverHost = $_SERVER['HTTP_HOST'];

    // Check if the server host is localhost or a specific IP range
    if ($serverHost === 'localhost' || preg_match('/^192\.168\.\d+\.\d+$/', $serverHost) || preg_match('/^10\.1\.\d+\.\d+$/', $serverHost)) {
        $email = "$phone@localhost.com";
    } else {
        $email = "$phone@$serverHost";
    }

    return $email;
}

function hotspot_getHotspotPlan($planid)
{
    return ORM::for_table('tbl_plans')
        ->where('type', 'Hotspot')
        ->where('enabled', 1)
        ->where('id', $planid)
        ->find_one();
}

function hotspot_validateAndPreparePaymentData($post_data)
{
    $required_fields = ['routername', 'planid', 'phone', 'amount'];
    foreach ($required_fields as $field) {
        if (empty($post_data[$field])) {
            hotspot_throwError(ucfirst($field) . ' ' . Lang::T(" is required."));
        }
    }

    $phone = trim($post_data['phone']);
    $phone = hotspot_formatPhoneNumber($phone);

    if (!is_numeric($phone)) {
        hotspot_throwError(Lang::T("Phone number is invalid, please check and try again."));
    }
    if (substr($phone, 0, 3) == '220') {
        // continue
    } elseif (strlen($phone) < 9) {
        hotspot_throwError(Lang::T("Phone number is invalid, please check and try again."));
    } else {
        _req(Lang::T("Phone number is invalid, please check and try again."));
    }


    $mac_address = $post_data['mac_address'] ?? null;
    if (!$mac_address) {
        $mac_address = hotspot_getMacAddressByPhone($phone);
    }
    $mac = hotspot_validateMacAddress($mac_address);
    $plan = hotspot_getHotspotPlan($post_data['planid']);
    $email = hotspot_getEmailAddress($phone);
    $plan_name = $plan['name_plan'];
    return [
        'routername' => $post_data['routername'],
        'planid' => $post_data['planid'],
        'plan_name' => $plan_name,
        'payment_gateway' => $post_data['payment_gateway'],
        'phone' => $phone,
        'email' => $email,
        'amount' => $post_data['amount'],
        'mac_address' => $mac,
        'ip_address' => $post_data['ip_address'],
        'txref' => uniqid('trx'),
        'status' => 'pending',
        'payment_token' => $post_data['payment_token'],
    ];
}

function hotspot_formatPhoneNumber($phone)
{
    global $config;
    $countryCode = $config['country_code_phone'];
    if (substr($phone, 0, 1) == '+') {
        $phone = str_replace('+', '', $phone);
    }
    if (substr($phone, 0, 1) == '9') {
        $phone = preg_replace('/^9/', "{$countryCode}9", $phone);
    }

    if (substr($phone, 0, 1) == '8') {
        $phone = preg_replace('/^8/', "{$countryCode}8", $phone);
    }

    if (substr($phone, 0, 1) == '0') {
        $phone = preg_replace('/^0/', $countryCode, $phone);
    }
    if (substr($phone, 0, 1) == '7') {
        $phone = preg_replace('/^7/', "{$countryCode}7", $phone);
    }

    if (substr($phone, 0, 1) == '1') {
        $phone = preg_replace('/^1/', "{$countryCode}1", $phone);
    }

    return $phone;
}


function hotspot_getMacAddressByPhone($phone)
{
    $mac_record = ORM::for_table('tbl_hotspot_payments')->where('phone_number', $phone)->select('mac_address')->find_one();
    return $mac_record?->mac_address;
}
function hotspot_replaceCountryCode($phone)
{
    global $config;
    $phone = (string) $phone;

    if (empty($phone)) {
        return $phone;
    }

    if (!empty($config['country_code_phone'])) {
        $countryCode = preg_quote($config['country_code_phone'], '/');
        $phone = ($countryCode != '220') ? preg_replace("/^$countryCode/", '0', $phone) : preg_replace("/^$countryCode/", '', $phone);
    } else {
        $countryCodes = ['234', '254', '233', '251', '256', '220', '255', '237', '238', '239', '240', '241', '242', '243', '244', '245', '246', '247', '248'];
        foreach ($countryCodes as $countryCode) {
            // Check if phone starts with the current country code
            if (strpos($phone, $countryCode) === 0) {
                // Replace the country code with '0' if the country code is not 220
                if ($countryCode != '220') {
                    $phone = preg_replace('/^' . preg_quote($countryCode, '/') . '/', '0', $phone);
                    break;
                }
            }
        }
    }

    return $phone;
}

function hotspot_validateMacAddress($mac_address)
{
    global $config;
    $mac_regex = "/^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$/";

    if ($mac_address && !preg_match($mac_regex, $mac_address)) {
        $mac_address = "22:12:59:0C:45:58";
    }

    $blockedMacs = ORM::for_table('tbl_hotspot_payments')->where('mac_status', 'Banned')->select('mac_address')->find_many();

    $blockedMacArray = [];
    foreach ($blockedMacs as $blockedMac) {
        $blockedMacArray[] = $blockedMac->mac_address;
    }

    if ($mac_address && in_array($mac_address, $blockedMacArray)) {
        hotspot_throwError(Lang::T("This device has been blocked from accessing this service, Please Go back and try again, or Report this issue to ") . ' ' . ' <a href="tel:' . $config['phone'] . '">' . $config['phone'] . '</a>' . '<br>' . '<br>' . Lang::T("Thanks."));
    }

    return $mac_address;
}

function hotspot_displayPaymentForm($payment_gateways, $planid, $plan_name, $amount, $routername, $validity, $mac_address, $ip_address)
{
    global $ui, $config;
    _hotspot_register_templates();
    $ui->assign('_title', Lang::T("Hotspot Payments"));
    $ui->assign('companyName', $config['CompanyName']);
    $ui->assign('payment_gateways', $payment_gateways);
    $ui->assign('planid', $planid);
    $ui->assign('plan_name', $plan_name);
    $ui->assign('amount', $amount);
    $ui->assign('routername', $routername);
    $ui->assign('validity', $validity);
    $ui->assign('mac', $mac_address);
    $ui->assign('ip', $ip_address);
    $ui->display('hotspot_pay.tpl');
}

function hotspot_savePayment($transaction_id, $transaction_ref, $amount, $phone, $planid, $plan_name, $mac_address, $ip_address, $routername, $status, $paymentGateway, $failedMessage, $location)
{

    if (
        empty($transaction_id) || empty($transaction_ref) || empty($amount) || empty($phone) ||
        empty($planid) || empty($plan_name) || empty($mac_address) || empty($ip_address) || empty($routername) ||
        empty($status) || empty($paymentGateway)
    ) {
        hotspot_throwError(Lang::T("Invalid input provided"));
        return;
    }

    $trx = ORM::for_table('tbl_hotspot_payments')->create();
    $trx->transaction_id = $transaction_id;
    $trx->transaction_ref = $transaction_ref;
    $trx->amount = $amount;
    $trx->phone_number = $phone;
    $trx->plan_id = $planid;
    $trx->plan_name = $plan_name;
    $trx->mac_address = $mac_address;
    $trx->ip_address = $ip_address;
    $trx->router_name = $routername;
    $trx->voucher_code = '**********';
    $trx->transaction_status = $status;
    $trx->payment_gateway = $paymentGateway;
    $trx->created_date = date('Y-m-d H:i:s');

    try {
        $trx->save();
        return $location;
    } catch (Exception $e) {
        _log(Lang::T("Failed to save transaction: ") . $e->getMessage());
        hotspot_throwError($failedMessage);
        exit;
    }
}


function hotspot_throwError($message)
{
    // Construct the HTML content
    $html = '<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error: Bad Request</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f1f1f1;
            text-align: center;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 600px;
            margin: 100px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            color: #333;
            margin-top: 0;
            font-size: 24px;
        }
        p {
            color: #777;
            font-size: 16px;
        }
        .btn {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            font-size: 16px;
            color: #fff;
            background-color: #007bff;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            cursor: pointer;
        }
        .btn:hover {
            background-color: #0056b3;
        }
        /* Responsive Styles */
        @media screen and (max-width: 600px) {
            .container {
                margin: 50px auto;
                padding: 10px;
            }
            h1 {
                font-size: 20px;
            }
            p {
                font-size: 14px;
            }
            .btn {
                font-size: 14px;
                padding: 8px 16px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>An Error Occured</h1>
        <p> ' . $message . '</p>
        <a href="javascript:history.back()" class="btn">Go Back</a>
    </div>
</body>
</html>';


    // Set the appropriate headers
    header('Content-Type: text/html');
    header('HTTP/1.1 400 Bad Request');

    // Output the HTML page
    echo $html;
    exit;
}

/**
 * Backfill missing voucher_code for paid "Generated" payments by looking up tbl_hotspot_vouchers.
 * Updates payment records in DB so voucher code is available for display and for customers to connect.
 */
function hotspot_backfillPaymentVoucherCodes($payments)
{
    if (!is_array($payments) && !($payments instanceof Iterator)) {
        return;
    }
    foreach ($payments as $payment) {
        $status = is_object($payment) ? ($payment->transaction_status ?? '') : ($payment['transaction_status'] ?? '');
        $gateway = is_object($payment) ? ($payment->payment_gateway ?? '') : ($payment['payment_gateway'] ?? '');
        $code = is_object($payment) ? ($payment->voucher_code ?? '') : ($payment['voucher_code'] ?? '');
        if ($status !== 'paid' || $gateway !== 'Generated') {
            continue;
        }
        if (!empty($code) && $code !== '**********') {
            continue;
        }
        $planId = is_object($payment) ? ($payment->plan_id ?? 0) : ($payment['plan_id'] ?? 0);
        $routerName = is_object($payment) ? ($payment->router_name ?? '') : ($payment['router_name'] ?? '');
        $createdDate = is_object($payment) ? ($payment->created_date ?? '') : ($payment['created_date'] ?? '');
        if (!$planId || !$routerName || !$createdDate) {
            continue;
        }
        try {
            $from = date('Y-m-d H:i:s', strtotime($createdDate . ' -2 minutes'));
            $to = date('Y-m-d H:i:s', strtotime($createdDate . ' +2 minutes'));
            $voucher = ORM::for_table('tbl_hotspot_vouchers')
                ->where('plan_id', $planId)
                ->where('server', $routerName)
                ->where_raw('created_at >= ? AND created_at <= ?', [$from, $to])
                ->order_by_desc('id')
                ->find_one();
            if ($voucher && !empty($voucher->code)) {
                if (is_object($payment)) {
                    $payment->voucher_code = $voucher->code;
                    $payment->save();
                } else {
                    $payment['voucher_code'] = $voucher->code;
                }
            }
        } catch (Throwable $e) {
            _log("Hotspot backfill voucher_code: " . $e->getMessage());
        }
    }
}

function hotspot_verify()
{
    global $ui, $config;
    _hotspot_register_templates();

    if (empty($config['hotspot_key'])) {
        hotspot_throwError('An error occurred. Please try again later, or contact administrator.');
        exit;
    }

    $ui->assign('_title', Lang::T("Hotspot Payment Verification"));

    $reference = isset($_GET['reference']) ? $_GET['reference'] : '';
    $message = isset($_GET['message']) ? $_GET['message'] : '';

    if ($message) {
        hotspot_verify_display_error($message);
    }

    if (!$reference) {
        hotspot_verify_display_error(Lang::T("No reference supplied."));
    }

    $check = ORM::for_table('tbl_hotspot_payments')
        ->where('transaction_ref', $reference)
        ->find_one();

    if ($check) {
        $status = $check->transaction_status;

        switch ($status) {
            case 'paid':
                hotspot_verify_display_success($check);
                break;
            case 'failed':
                hotspot_verify_display_error(Lang::T("Transaction with this Reference ID: [$reference] has been processed and failed."));
                break;
            case 'cancelled':
                hotspot_verify_display_error(Lang::T("Transaction with this Reference ID: [$reference] has been processed and cancelled."));
                break;
            default:
                $ui->assign('companyName', $config['CompanyName']);
                $ui->assign('msg', $message);
                $ui->display('hotspot_verify.tpl');
                break;
        }
    } else {
        hotspot_verify_display_error(Lang::T("Transaction with this Reference ID: [$reference] not found."));
    }
}
function hotspot_verify_display_error($message)
{
    $html = '<!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Error: Bad Request</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    background-color: #f1f1f1;
                    text-align: center;
                    margin: 0;
                    padding: 0;
                }
                .container {
                    max-width: 600px;
                    margin: 100px auto;
                    padding: 20px;
                    background-color: #fff;
                    border-radius: 8px;
                    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                }
                h1 {
                    color: #333;
                    margin-top: 0;
                    font-size: 24px;
                }
                p {
                    color: #777;
                    font-size: 16px;
                }
                /* Responsive Styles */
                @media screen and (max-width: 600px) {
                    .container {
                        margin: 50px auto;
                        padding: 10px;
                    }
                    h1 {
                        font-size: 20px;
                    }
                    p {
                        font-size: 14px;
                    }
                }
            </style>
        </head>
        <body>
            <div class="container">
                <h1>An Error Occurred</h1>
                <p>' . $message . '</p>
            </div>
        </body>
        </html>';

    // Set the appropriate headers
    header('Content-Type: text/html');
    header('HTTP/1.1 400 Bad Request');

    // Output the HTML page
    echo $html;
    exit();
}


function hotspot_verify_display_success($transaction)
{
    global $config;

    if (empty($config['hotspot_key'])) {
        hotspot_throwError('An error occurred. Please try again later, or contact administrator.');
        exit;
    }
    $orderSummary = [
        Lang::T("Order Number") => $transaction->id,
        Lang::T("Transaction ID") => $transaction->transaction_id,
        Lang::T("Transaction Ref") => $transaction->transaction_ref,
        Lang::T("Package") => $transaction->plan_name,
        Lang::T("Expiry") => $transaction->expired_date,
        Lang::T("Amount Paid") => $config['currency_code'] . number_format($transaction->amount, 2),
        Lang::T("Payment Method") => $transaction->payment_gateway
    ];

    $voucherCode = $transaction->voucher_code;
    $ipAddress = $transaction->ip_address;
    $macAddress = $transaction->mac_address;
    $router = $transaction->router_name;
    $hotspotUrl = rtrim((string) ($config['hotspot_url'] ?? ''), '/');
    $hotspot_redirect_url = trim((string) ($config["hotspot_redirect_url"] ?? ''));
    if ($hotspot_redirect_url === '') {
        $hotspot_redirect_url = $hotspotUrl . '/status';
    }

    // Fallback for records that still have masked voucher code.
    if ($voucherCode === '**********' || $voucherCode === '') {
        try {
            $customer = ORM::for_table('tbl_customers')
                ->where('phonenumber', $transaction->phone_number)
                ->where('service_type', 'Hotspot')
                ->order_by_desc('id')
                ->find_one();
            if ($customer && !empty($customer->username)) {
                $voucherCode = $customer->username;
            }
        } catch (Exception $e) {
            _log("Hotspot verify fallback username lookup failed: " . $e->getMessage());
        }
    }

    $connectUrl = $hotspotUrl . '/login?dst=' . rawurlencode($hotspot_redirect_url)
        . '&username=' . rawurlencode((string) $voucherCode)
        . '&password=' . rawurlencode((string) $voucherCode);


    $html = '<!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Successful</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    background-color: #f1f1f1;
                    text-align: center;
                    margin: 0;
                    padding: 24px 12px;
                    min-height: 100vh;
                    box-sizing: border-box;
                }
                .container {
                    width: min(960px, 96vw);
                    margin: 4vh auto;
                    padding: clamp(14px, 2.2vw, 26px);
                    background-color: #fff;
                    border-radius: 8px;
                    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                }
                h1 {
                    color: #28a745;
                    margin-top: 0;
                    font-size: clamp(22px, 2.6vw, 36px);
                    animation: fadeIn 1s ease-in-out;
                }
                p {
                    color: #777;
                    font-size: clamp(14px, 1.2vw, 18px);
                    animation: fadeIn 1.5s ease-in-out;
                }
                .checkmark {
                    width: 80px;
                    height: 80px;
                    margin: 0 auto 20px auto;
                    border-radius: 50%;
                    background-color: #28a745;
                    animation: scaleUp 0.5s ease-in-out;
                    position: relative;
                }
                .checkmark::after {
                    content: "";
                    display: block;
                    width: 40px;
                    height: 20px;
                    border: 5px solid #fff;
                    border-width: 0 0 5px 5px;
                    transform: rotate(-45deg);
                    position: absolute;
                    top: 20px;
                    left: 20px;
                    animation: drawCheck 0.5s ease-in-out 0.5s forwards;
                }
                .btn {
                    display: inline-block;
                    margin-top: 20px;
                    padding: 12px 20px;
                    font-size: clamp(14px, 1.1vw, 18px);
                    color: #fff;
                    background-color: #007bff;
                    border: none;
                    border-radius: 4px;
                    text-decoration: none;
                    cursor: pointer;
                    animation: fadeIn 2s ease-in-out;
                }
                .btn:hover {
                    background-color: #0056b3;
                }
                .order-summary {
                    text-align: left;
                    margin: 20px auto;
                    padding: 20px;
                    background-color: #f9f9f9;
                    border-radius: 8px;
                    animation: fadeIn 2.5s ease-in-out;
                }
                .order-summary h2 {
                    color: #333;
                    font-size: clamp(18px, 1.7vw, 26px);
                    margin-bottom: 10px;
                }
                .order-summary table {
                    width: 100%;
                    border-collapse: collapse;
                }
                .order-summary table, .order-summary th, .order-summary td {
                    border: 1px solid #ddd;
                }
                .order-summary th, .order-summary td {
                    padding: 8px;
                    text-align: left;
                }
                .order-summary th {
                    background-color: #f2f2f2;
                }
                .small-btn {
                    padding: 5px 10px;
                    font-size: 14px;
                }
                /* Animations */
                @keyframes fadeIn {
                    from { opacity: 0; }
                    to { opacity: 1; }
                }
                @keyframes scaleUp {
                    from { transform: scale(0); }
                    to { transform: scale(1); }
                }
                @keyframes drawCheck {
                    from { width: 0; height: 0; }
                    to { width: 40px; height: 20px; }
                }
                /* Responsive Styles */
                @media screen and (max-width: 600px) {
                    .container {
                        margin: 3vh auto;
                        padding: 10px;
                    }
                    h1 {
                        font-size: 20px;
                    }
                    p {
                        font-size: 14px;
                    }
                    .btn {
                        font-size: 14px;
                        padding: 8px 16px;
                    }
                    .order-summary {
                        padding: 10px;
                    }
                    .order-summary h2 {
                        font-size: 18px;
                    }
                    .order-summary th, .order-summary td {
                        font-size: 14px;
                        padding: 6px;
                    }
                    .small-btn {
                        padding: 3px 8px;
                        font-size: 12px;
                    }
                }
                /* Better readability for TV / large screens */
                @media screen and (min-width: 1920px) {
                    .container {
                        width: min(1180px, 90vw);
                    }
                    .order-summary th, .order-summary td {
                        font-size: 18px;
                        padding: 10px;
                    }
                }
            </style>
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
            <script>
                function copyVoucherCode() {
                    var voucherCode = document.getElementById("voucherCode").innerText;
                    navigator.clipboard.writeText(voucherCode).then(function() {
                        Swal.fire({
                            icon: "success",
                            title: "Voucher code copied!",
                            text: "The voucher code has been copied to the clipboard.",
                            timer: 2000,
                            showConfirmButton: false
                        });
                    }, function(err) {
                        console.error("Could not copy text: ", err);
                    });
                }
            </script>
        </head>
        <body>
            <div class="container">
                <div class="checkmark"></div>
                <h1>Success!</h1>
                <p>Your payment has been successfully processed.</p>
                <div class="order-summary">
                    <h2>Package Summary</h2>
                    <table>
                        <tr>
                            <th>Item</th>
                            <th>Details</th>
                        </tr>';

    foreach ($orderSummary as $item => $details) {
        $html .= '<tr>
                            <td>' . $item . '</td>
                            <td>' . $details . '</td>
                        </tr>';
    }


    if ($transaction->payment_gateway == 'Payment Token') {
        $token = ORM::for_table('tbl_hotspot_tokens')->where('token_number', $transaction->transaction_id)->find_one();
        if (!$token) {
            _log("Payment Token not found for ID: {$transaction->transaction_id}");
            sendTelegram("An error occurred. Payment Token not found for ID: {$transaction->transaction_id}");
        }
        $balance = $token->value;
        $html .= '<tr>
        <td>' . Lang::T("Token Balance") . '</td>
        <td>' . $config['currency_code'] . number_format($balance, 2) . '</td>
        </tr>';
    }


    if ($voucherCode !== '**********') {
        $html .= '<tr>
                    <td>' . Lang::T("Voucher Code") . '</td>
                    <td>
                        <span id="voucherCode">' . $voucherCode . '</span>
                           <button onclick="copyVoucherCode()" class="btn small-btn">Copy</button>
                    </td>
                  </tr>';
    }

    $html .= '</table></div>';

    if ($config['hotspot_auto_login']) {
        $html .= '<div style="text-align: center;"><div class="countdown-timer" id="countdown">Connecting you in 5 seconds...</div></div>';
    }

    $html .= '<a href="' . $connectUrl . '" class="btn">Connect Now</a>';

    $html .= '</div> ';


    if ($config['hotspot_auto_login']) {
        $html .= '
            
            <script>
                    // Countdown timer
        var seconds = 5;
        function countdown() {
            var timer = setInterval(function () {
                seconds--;
                document.getElementById("countdown").innerHTML = "Connecting you in " + seconds + " seconds...";
                if (seconds <= 0) {
                    clearInterval(timer);
                    window.location.href = "' . $connectUrl . '";
                }
            }, 1000);
        }
        countdown();

          </script>';
    }
    $html .= '
        </body>
        </html>';

    // Set the appropriate headers
    header('Content-Type: text/html');
    header('HTTP/1.1 200 OK');

    // Output the HTML page
    echo $html;
    exit();
}


/**
 * Sync a paid payment's voucher to MikroTik (add hotspot user if missing).
 * Use when payment shows paid but customer cannot connect (e.g. router was down when voucher was generated).
 */
function hotspot_sync_payment_to_mikrotik()
{
    global $_app_stage;

    if (app_is_demo_restricted()) {
        r2(U . "plugin/hotspot_overview", 'e', Lang::T('You cannot perform this action in Demo mode'));
        return;
    }

    $id = (int)($_GET['id'] ?? 0);
    if (!$id) {
        r2(U . "plugin/hotspot_overview", 'e', Lang::T('Invalid payment.'));
        return;
    }

    $payment = ORM::for_table('tbl_hotspot_payments')->find_one($id);
    if (!$payment || $payment->transaction_status !== 'paid' || empty($payment->voucher_code) || $payment->voucher_code === '**********') {
        r2(U . "plugin/hotspot_overview", 'e', Lang::T('Payment not found or has no voucher code to sync.'));
        return;
    }

    $plan = ORM::for_table('tbl_plans')->find_one($payment->plan_id);
    $router = ORM::for_table('tbl_routers')->where('name', $payment->router_name)->find_one();
    if (!$plan || !$router) {
        r2(U . "plugin/hotspot_overview", 'e', Lang::T('Plan or router not found.'));
        return;
    }

    try {
        $iport = explode(":", $router['ip_address']);
        $client = new RouterOS\Client($iport[0], $router['username'], $router['password'], ($iport[1]) ? (int)$iport[1] : null);
        $comment = 'Hotspot synced ' . date('Y-m-d H:i:s');

        if ($plan->typebp === "Limited") {
            if ($plan->limit_type === "Time_Limit") {
                $timelimit = ($plan->time_unit === 'Hrs') ? "{$plan->time_limit}:00:00" : "00:{$plan->time_limit}:00";
                $client->sendSync((new RouterOS\Request('/ip/hotspot/user/add'))->setArgument('name', $payment->voucher_code)->setArgument('profile', $plan->name_plan)->setArgument('password', $payment->voucher_code)->setArgument('comment', $comment)->setArgument('limit-uptime', $timelimit));
            } elseif ($plan->limit_type === "Data_Limit") {
                $datalimit = ($plan->data_unit === 'GB') ? "{$plan->data_limit}000000000" : "{$plan->data_limit}000000";
                $client->sendSync((new RouterOS\Request('/ip/hotspot/user/add'))->setArgument('name', $payment->voucher_code)->setArgument('profile', $plan->name_plan)->setArgument('password', $payment->voucher_code)->setArgument('comment', $comment)->setArgument('limit-bytes-total', $datalimit));
            } else {
                $timelimit = ($plan->time_unit === 'Hrs') ? "{$plan->time_limit}:00:00" : "00:{$plan->time_limit}:00";
                $datalimit = ($plan->data_unit === 'GB') ? "{$plan->data_limit}000000000" : "{$plan->data_limit}000000";
                $client->sendSync((new RouterOS\Request('/ip/hotspot/user/add'))->setArgument('name', $payment->voucher_code)->setArgument('profile', $plan->name_plan)->setArgument('password', $payment->voucher_code)->setArgument('comment', $comment)->setArgument('limit-uptime', $timelimit)->setArgument('limit-bytes-total', $datalimit));
            }
        } else {
            $client->sendSync((new RouterOS\Request('/ip/hotspot/user/add'))->setArgument('name', $payment->voucher_code)->setArgument('profile', $plan->name_plan)->setArgument('password', $payment->voucher_code)->setArgument('comment', $comment));
        }

        r2(U . "plugin/hotspot_overview", 's', Lang::T('Voucher synced to MikroTik. Customer can connect with code: ') . $payment->voucher_code);
    } catch (Exception $e) {
        _log("Hotspot sync to MikroTik: " . $e->getMessage());
        r2(U . "plugin/hotspot_overview", 'e', Lang::T('Failed to sync to MikroTik: ') . $e->getMessage());
    }
}

function hotspot_block_mac()
{
    global $_app_stage;

    if (app_is_demo_restricted()) {
        r2(U . "plugin/hotspot_overview", 'e', Lang::T('You cannot perform this action in Demo mode'));
    }

    if (isset($_GET['block']) || isset($_GET['unblock'])) {
        $mac_address = $_GET['mac'];

        $users = ORM::for_table('tbl_hotspot_payments')->where('mac_address', $mac_address)->find_many();

        if ($users) {
            try {
                foreach ($users as $user) {
                    if (isset($_GET['block'])) {
                        $user->mac_status = 'Banned';
                        $successMessage = Lang::T("Device with Mac Address " . $mac_address . " has been Banned Successfully");
                    } elseif (isset($_GET['unblock'])) {
                        $user->mac_status = 'Active';
                        $successMessage = Lang::T("Device with Mac Address $mac_address has been Unblocked Successfully");
                    }
                    $user->save();
                }
                r2(U . "plugin/hotspot_overview", 's', Lang::T($successMessage));
                exit();
            } catch (Exception $e) {
                r2(U . "plugin/hotspot_overview", 'e', Lang::T("Error: " . $e->getMessage()));
            }
        } else {
            r2(U . "plugin/hotspot_overview", 'e', Lang::T("Error: Mac Address not found."));
        }
    }
}

function hotspot_generate_voucher_code()
{
    global $config;
    if ($config['hotspot_voucher_type'] === 'random') {
        return strtoupper(substr(md5(uniqid(rand(), true)), 0, 10));
    } elseif ($config['hotspot_voucher_type'] === 'number') {
        return rand(1000000000, 9999999999);
    } else {
    }
}
function hotspot_config()
{
    global $ui, $admin, $config, $hotspotProductName, $_app_stage;
    _hotspot_register_templates();

    if (!hotspot_engine()) {
        Message::sendTelegram("{$hotspotProductName} is not installed. Please install it first.");
        hotspot_install();
        exit;
    }

    $ui->assign('_title', Lang::T("Hotspot System General Settings"));
    $ui->assign('_system_menu', 'settings');

    $admin = Admin::_info();
    $ui->assign('_admin', $admin);
    if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin'])) {
        _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
        exit;
    }

    $UPLOAD_PATH = 'system' . DIRECTORY_SEPARATOR . 'uploads';
    $notifications_file = $UPLOAD_PATH . DIRECTORY_SEPARATOR . "hotspot_message.json";

    if (!file_exists($notifications_file)) {
        $default_content = [
            "hotspot_message_content" => "Dear Customer,\r\nYour  [[package]]  subscription has been activated.\r\nVoucher Code is:  [[login_code]]\r\nAccount expires on: [[expiry]]\r\n\r\n[[company]]",
            "voucher_send" => "Dear Customer,\r\nHere is your Voucher Details:\r\nData Limit:  [[data]]\r\nVoucher Code is:  [[code]]\r\nDuration: [[validity]]\r\n\r\n[[company]]",
            "voucher_template" => "<style type=\"text/css\">
                .voucher-container {
                    width: 250px;
                    height: 70px;
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
                    color: white;
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
                    width: 50px;
                    height: 50px;
                    margin: auto;
                    padding: 5px;
                }
                .qrcode img {
                    width: 100%;
                    height: auto;
                }
            </style>
            <div class=\"voucher-container\">
                <div class=\"price-bar\">[[currency]][[plan_price]]</div>
                <div class=\"details\">
                    <div class=\"code\">[[code]]</div>
                    <div class=\"info\">Data Limit: [[data]] Duration: [[validity]]</div>
                    <div class=\"info\">Login: [[url]] </div><br>
                    <div class=\"info\">Thank you for choosing our service</div>
                </div>
                <div class=\"qrcode\">[[qrcode]]</div>
            </div>",
        ];

        if (is_writable($UPLOAD_PATH)) {
            $result = file_put_contents($notifications_file, json_encode($default_content, JSON_PRETTY_PRINT));
            if ($result === false) {
                _log('[' . $admin['username'] . ']: ' . Lang::T('Failed to write JSON to file'), $admin['user_type']);
                r2(U . "plugin/hotspot_overview", 'e', Lang::T('Failed to save default notifications settings due to file write error'));
            } else {
                _log('[' . $admin['username'] . ']: ' . Lang::T('Default notifications file created successfully'), $admin['user_type']);
            }
        } else {
            _log('[' . $admin['username'] . ']: ' . Lang::T('Failed to write default notifications file due to file permissions'), $admin['user_type']);
            r2(U . "plugin/hotspot_overview", 'e', Lang::T('Failed to save default notifications settings due to file permissions'));
        }
    }


    if (_post('save') == 'save') {

        if (app_is_demo_restricted()) {
            r2(U . 'plugin/hotspot_config', 'e', Lang::T('You cannot perform this action in Demo mode'));
        }

        $hotspot_voucher_mode = isset($_POST['hotspot_voucher_mode']) ? 1 : 0;
        $hotspot_voucher_type = isset($_POST['hotspot_voucher_type']) ? htmlspecialchars($_POST['hotspot_voucher_type']) : '';
        $hotspot_payment_type = isset($_POST['hotspot_payment_type']) ? htmlspecialchars($_POST['hotspot_payment_type']) : '';
        $hotspot_message = isset($_POST['hotspot_message']) ? 1 : 0;
        $hotspot_message_via = isset($_POST['hotspot_message_via']) ? htmlspecialchars($_POST['hotspot_message_via']) : '';
        $hotspot_url = isset($_POST['hotspot_url']) ? htmlspecialchars($_POST['hotspot_url']) : '';
        $voucher_template = $_POST['voucher_template'] ?? '';
        $hotspot_cev = isset($_POST['hotspot_cev']) ? 1 : 0;
        $hotspot_cev_batch = $_POST['hotspot_cev_batch'] ?? 10;
        $hotspot_radius_mode = $_POST['hotspot_radius_mode'] ? 1 : 0;
        $hotspot_auto_login = $_POST['hotspot_auto_login'] ? 1 : 0;
        $hotspot_redirect_url = $_POST['hotspot_redirect_url'] ? htmlspecialchars($_POST['hotspot_redirect_url']) : 'http://www.google.com';
        $hotspot_clear_pending = isset($_POST['hotspot_clear_pending']) ? 1 : 0;
        $hotspot_clear_pending_time = isset($_POST['hotspot_clear_pending_time']) ? (int) $_POST['hotspot_clear_pending_time'] : 60;

        // Paystack settings for hotspot vouchers
        $hotspot_paystack_enable = isset($_POST['hotspot_paystack_enable']) ? 1 : 0;
        $hotspot_paystack_public_key = isset($_POST['hotspot_paystack_public_key']) ? trim($_POST['hotspot_paystack_public_key']) : '';
        $hotspot_paystack_secret_key = isset($_POST['hotspot_paystack_secret_key']) ? trim($_POST['hotspot_paystack_secret_key']) : '';

        $settings = [
            'hotspot_voucher_mode' => $hotspot_voucher_mode,
            'hotspot_voucher_type' => $hotspot_voucher_type,
            'hotspot_payment_type' => $hotspot_payment_type,
            'hotspot_message' => $hotspot_message,
            'hotspot_message_via' => $hotspot_message_via,
            'hotspot_url' => $hotspot_url,
            'hotspot_cev' => $hotspot_cev,
            'hotspot_cev_batch' => $hotspot_cev_batch,
            'hotspot_radius_mode' => $hotspot_radius_mode,
            'hotspot_auto_login' => $hotspot_auto_login,
            'hotspot_redirect_url' => $hotspot_redirect_url,
            'hotspot_clear_pending' => $hotspot_clear_pending,
            'hotspot_clear_pending_time' => $hotspot_clear_pending_time,
            'hotspot_paystack_enable' => $hotspot_paystack_enable,
            'hotspot_paystack_public_key' => $hotspot_paystack_public_key,
            'hotspot_paystack_secret_key' => $hotspot_paystack_secret_key,

        ];

        // Update or insert settings in the database
        foreach ($settings as $key => $value) {
            $d = ORM::for_table('tbl_appconfig')->where('setting', $key)->find_one();
            if ($d) {
                $d->value = $value;
                $d->save();
            } else {
                $d = ORM::for_table('tbl_appconfig')->create();
                $d->setting = $key;
                $d->value = $value;
                $d->save();
            }
        }

        // Save voucher template and hotspot message content
        if (is_writable($UPLOAD_PATH)) {
            $content_to_save = [
                "hotspot_message_content" => htmlspecialchars($_POST['hotspot_message_content']),
                "voucher_send" => htmlspecialchars($_POST['voucher_send']),
                "voucher_template" => $voucher_template,
            ];
            file_put_contents($notifications_file, json_encode($content_to_save, JSON_PRETTY_PRINT));
        } else {
            _log('[' . $admin['username'] . ']: ' . Lang::T('Failed to write notifications file'), $admin['user_type']);
            _alert(Lang::T('Failed to save notifications settings due to file permissions'), 'danger', "plugin/hotspot_config");
        }

        _log('[' . $admin['username'] . ']: ' . Lang::T('Settings Saved Successfully'), $admin['user_type']);
        r2(U . 'plugin/hotspot_config', 's', Lang::T('Settings Saved Successfully'));
    }

    if (file_exists($notifications_file)) {
        $json_data = file_get_contents($notifications_file);
        if ($json_data !== false) {
            $json_data_array = json_decode($json_data, true);
            $ui->assign('_json', $json_data_array);
        } else {
            _log('[' . $admin['username'] . ']: ' . Lang::T('Failed to read notifications file'), $admin['user_type']);
        }
    }

    $paymentGateway = hotspot_getAvailablePaymentGateways();
    if (!$paymentGateway) {
        $ui->assign('message', '<em>' . Lang::T("Payment Gateway is missing, you can purchase payment gateway plugin from ") . ' <a href="https://shop.focuslinkstech.com.ng">shop.focuslinkstech.com.ng</a>' . ' ' . ' ' . Lang::T("or Contact ") . ' ' . '<a href="https://t.me/focuslinkstech">@focuslinkstech</a>' . ' ' . Lang::T("for more informations") . '</em>');
    }

    $ui->assign('_c', $config);
    $ui->assign('companyName', $config['CompanyName']);
    $ui->display('hotspot_config.tpl');
}
function hotspot_login()
{

    global $config;
    if (empty($config['hotspot_key'])) {
        hotspot_throwError('An error occurred. Please try again later, or contact administrator.');
        exit;
    }
    if (isset($_GET['username'], $_GET['password'], $_GET['ip'], $_GET['mac'], $_GET['router'])) {
        $username = htmlspecialchars($_GET['username']);
        $password = htmlspecialchars($_GET['password']);
        $ip = htmlspecialchars($_GET['ip']);
        $mac_address = htmlspecialchars($_GET['mac']);
        $router_name = htmlspecialchars($_GET['router']);

        $customer = [
            'username' => $username,
            'password' => $password
        ];

        $plan = ORM::for_table('tbl_user_recharges')->where('username', $username)->where('status', 'on')->find_one();
        $p = ORM::for_table('tbl_plans')->where('routers', $router_name)->where('id', $plan->plan_id)->find_one();
        $dvc = Package::getDevice($p);
        if (file_exists($dvc)) {
            require_once $dvc;
            try {
                (new $p['device'])->connect_customer($customer, $ip, $mac_address, $router_name);
                hotspot_loginSuccess(Lang::T("Login Request Successfully"));
            } catch (Exception $e) {
                hotspot_throwError(Lang::T("An error occurred while logging in: ") . $e->getMessage());
            }
        } else {
            new Exception(Lang::T("Devices Not Found"));
        }
    } else {
        hotspot_throwError(Lang::T("An error occurred while logging in: missing parameters"));
    }
}

function hotspot_loginSuccess($message)
{
    global $config;

    $url = $config["hotspot_redirect_url"] ?? "http://www.google.com";
    $safeUrl = json_encode($url);

    $html = "<!DOCTYPE html>\n        <html lang=\"en\">\n        <head>\n            <meta charset=\"UTF-8\">\n            <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n            <title>Connection Success</title>\n            <style>\n                body {\n                    font-family: \"Helvetica Neue\", Helvetica, Arial, sans-serif;\n                    background-color: #f7f9fc;\n                    color: #333;\n                    margin: 0;\n                    padding: 20px;\n                    display: flex;\n                    align-items: center;\n                    justify-content: center;\n                    min-height: 100vh;\n                    box-sizing: border-box;\n                }\n                .container {\n                    width: min(900px, 96vw);\n                    padding: clamp(20px, 2.2vw, 36px);\n                    background-color: #ffffff;\n                    border-radius: 12px;\n                    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);\n                    text-align: center;\n                    transition: transform 0.3s, box-shadow 0.3s;\n                }\n                .container:hover {\n                    transform: translateY(-5px);\n                    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);\n                }\n                h1 {\n                    font-size: clamp(24px, 2.8vw, 40px);\n                    color: #2c3e50;\n                    margin-top: 0;\n                }\n                p {\n                    font-size: clamp(14px, 1.2vw, 20px);\n                    color: #7f8c8d;\n                    margin: 15px 0 0;\n                }\n                .button {\n                    display: inline-block;\n                    margin-top: 20px;\n                    padding: 12px 22px;\n                    font-size: clamp(14px, 1.1vw, 18px);\n                    color: #ffffff;\n                    background-color: #3498db;\n                    border: none;\n                    border-radius: 5px;\n                    cursor: pointer;\n                    text-decoration: none;\n                    transition: background-color 0.3s;\n                }\n                .button:hover {\n                    background-color: #2980b9;\n                }\n                @media screen and (min-width: 1920px) {\n                    .container {\n                        width: min(1200px, 90vw);\n                    }\n                }\n            </style>\n            <script>\n                function openHomepage() {\n                    window.location.href = " . $safeUrl . ";\n                }\n            </script>\n        </head>\n        <body>\n            <div class=\"container\">\n                <h1>Connected Successfully</h1>\n                <p>$message</p>\n                <button class=\"button\" onclick=\"openHomepage()\">Continue Browsing</button>\n            </div>\n        </body>\n        </html>";

    // Set the appropriate headers
    header('Content-Type: text/html');
    header('HTTP/1.1 200 Success');

    // Output the HTML page
    echo $html;
    exit();
}

function hotspot_update()
{
    global $hotspotProductName, $_app_stage;
    include "config.php";
    $admin = Admin::_info();

    if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin'])) {
        _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
        exit;
    }

    if (app_is_demo_restricted()) {
        r2(U . "plugin/hotspot_config", 'e', Lang::T('You cannot perform this action in Demo mode'));
    }

    if (!hotspot_engine()) {
        Message::sendTelegram("{$hotspotProductName} is not installed. Please install it first.");
        hotspot_install();
        exit;
    }

    if (isset($_GET['db'])) {
        try {
            $db = new PDO(
                "mysql:host=$db_host;dbname=$db_name",
                $db_user,
                $db_pass,
                [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
            );

            $done = [];
            if (file_exists("system/cache/hotspot_version.json")) {
                $done = json_decode(file_get_contents("system/cache/hotspot_version.json"), true);
            }
            if (!is_array($done)) {
                $done = [];
            }

            // 3.5: Add columns only if they don't exist (idempotent), fix invalid defaults
            if (!in_array("3.5", $done)) {
                $paymentsCols = $db->query("SHOW COLUMNS FROM `tbl_hotspot_payments`")->fetchAll(PDO::FETCH_COLUMN);
                if (!in_array('ip_address', $paymentsCols)) {
                    $db->exec("ALTER TABLE `tbl_hotspot_payments` ADD `ip_address` VARCHAR(50) NULL DEFAULT NULL AFTER `payment_method`;");
                }
                $paymentsCols = $db->query("SHOW COLUMNS FROM `tbl_hotspot_payments`")->fetchAll(PDO::FETCH_COLUMN);
                if (!in_array('is_processed', $paymentsCols)) {
                    $db->exec("ALTER TABLE `tbl_hotspot_payments` ADD `is_processed` TINYINT(1) NOT NULL DEFAULT 0 AFTER `ip_address`;");
                }

                $vouchersCols = $db->query("SHOW COLUMNS FROM `tbl_hotspot_vouchers`")->fetchAll(PDO::FETCH_COLUMN);
                if (!in_array('validity', $vouchersCols)) {
                    $db->exec("ALTER TABLE `tbl_hotspot_vouchers` ADD `validity` VARCHAR(50) NULL AFTER `price`;");
                }
                $vouchersCols = $db->query("SHOW COLUMNS FROM `tbl_hotspot_vouchers`")->fetchAll(PDO::FETCH_COLUMN);
                if (!in_array('validity_unit', $vouchersCols)) {
                    $db->exec("ALTER TABLE `tbl_hotspot_vouchers` ADD `validity_unit` VARCHAR(50) NULL AFTER `validity`;");
                }
                $vouchersCols = $db->query("SHOW COLUMNS FROM `tbl_hotspot_vouchers`")->fetchAll(PDO::FETCH_COLUMN);
                if (!in_array('is_admin', $vouchersCols)) {
                    $db->exec("ALTER TABLE `tbl_hotspot_vouchers` ADD `is_admin` TINYINT(1) NOT NULL DEFAULT 1 AFTER `generated_by`;");
                }
                $done[] = "3.5";
            }

            file_put_contents("system/cache/hotspot_version.json", json_encode($done));
            r2(U . "plugin/hotspot_config", 's', Lang::T("Hotspot database update successful"));
        } catch (Exception $e) {
            _log(Lang::T("Hotspot database update failed: " . $e->getMessage()));
            r2(U . "plugin/hotspot_config", 'e', Lang::T("Hotspot database update failed, check log for error: " . htmlspecialchars($e->getMessage())));
        }
    } else {
        r2(U . "plugin/hotspot_config", 'e', Lang::T("Invalid Parameter"));
    }
}
function hotspot_sendMessage($phone, $package, $login_code, $expiry)
{
    global $config;
    $UPLOAD_PATH = 'system' . DIRECTORY_SEPARATOR . 'uploads';
    $notifications_file = $UPLOAD_PATH . DIRECTORY_SEPARATOR . "hotspot_message.json";

    $default_message = "Dear Customer,\r\nYour [[package]] subscription has been activated.\r\nVoucher Code is: [[login_code]]\r\nAccount expires on: [[expiry]]\r\n\r\n[[company]]";

    if (file_exists($notifications_file)) {
        $json_data = file_get_contents($notifications_file);
        if ($json_data !== false) {
            $json_data_array = json_decode($json_data, true);
            $messageContent = $json_data_array['hotspot_message_content'] ?? $default_message;
        } else {
            $messageContent = $default_message;
        }
    } else {
        $messageContent = $default_message;
    }

    if ($config['hotspot_message'] == true) {
        // Replace placeholders with actual values
        $message = str_replace('[[company]]', $config['CompanyName'], $messageContent);
        $message = str_replace('[[package]]', $package, $message);
        $message = str_replace('[[expiry]]', $expiry, $message);
        $message = str_replace('[[login_code]]', $login_code, $message);

        $sendVia = $config['hotspot_message_via'];

        $channels = [
            'sms' => [
                'enabled' => $sendVia == 'sms' || $sendVia == 'both',
                'method' => 'Message::sendSMS',
                'args' => [$phone, $message]
            ],
            'whatsapp' => [
                'enabled' => $sendVia == 'wa' || $sendVia == 'both',
                'method' => 'Message::sendWhatsapp',
                'args' => [$phone, $message]
            ]
        ];

        foreach ($channels as $channel => $channelData) {
            if ($channelData['enabled']) {
                try {
                    call_user_func_array($channelData['method'], $channelData['args']);
                } catch (Exception $e) {
                    // Log the error and handle the failure
                    _log("Failed to send voucher code to $phone via $channel: " . $e->getMessage());
                }
            }
        }
    }
}

function hotspot_voucher()
{
    global $ui, $admin, $routes, $config, $hotspotProductName;
    _hotspot_register_templates();
    $title = !empty($config['CompanyName'])
        ? $config['CompanyName'] . ' - ' . Lang::T('Hotspot Voucher Code Generator')
        : Lang::T('Hotspot Voucher Code Generator');
    $ui->assign('_title', $title);
    $ui->assign('_system_menu', '');
    $admin = Admin::_info();
    $ui->assign('_admin', $admin);

    if (!hotspot_engine()) {
        Message::sendTelegram("{$hotspotProductName} is not installed. Please install it first.");
        hotspot_install();
        exit;
    }

    if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin', 'Sales'])) {
        _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
        exit;
    }

    $paymentGateway = hotspot_getAvailablePaymentGateways();
    if (!$paymentGateway) {
        $ui->assign('message', '<em>' . Lang::T("Payment Gateway is missing, you can purchase payment gateway plugin from ") . ' <a href="https://shop.focuslinkstech.com.ng"> shop.focuslinkstech.com.ng </a>' . ' ' . ' ' . Lang::T(" or Contact ") . ' ' . '<a href="https://t.me/focuslinkstech"> @focuslinkstech </a>' . ' ' . Lang::T(" for more information") . '</em>');
    }

    $routers = ORM::for_table('tbl_routers')->where('enabled', '1')->find_many();
    $router = $routes['2'] ?? '';

    if (empty($router) && !empty($routers)) {
        $router = $routers[0]['name'];
    }

    $ui->assign('routers', $routers);
    $ui->assign('router', $router);

    $dbVouchers = hotspot_getVouchers($router);
    $ui->assign('csrf_token', hotspot_generateCsrfToken());
    $ui->assign('d', $dbVouchers);
    $ui->assign('_c', $config);
    $ui->assign('xheader', '<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.11.3/css/jquery.dataTables.min.css">');
    $ui->assign('companyName', $config['CompanyName']);
    $ui->display('hotspot_voucher.tpl');
}

function hotspot_getVouchers($router)
{
    // Initialize an empty array for Mikrotik vouchers
    $mikrotikVouchers = [];
    hotspot_ensureVoucherIsAdminColumn();

    if ($router) {
        $mikrotik = ORM::for_table('tbl_routers')->where('name', $router)->find_one();
        if ($mikrotik) {
            $iport = explode(":", $mikrotik['ip_address']);
            $client = new RouterOS\Client($iport[0], $mikrotik['username'], $mikrotik['password'], ($iport[1]) ? $iport[1] : null);

            try {
                $request = new RouterOS\Request('/ip/hotspot/user/print');
                $response = $client->sendSync($request);

                foreach ($response as $entry) {
                    // Add Mikrotik voucher to the array
                    $mikrotikVouchers[$entry->getProperty('name')] = [
                        'name' => $entry->getProperty('name'),
                        'profile' => $entry->getProperty('profile'),
                        'uptime' => $entry->getProperty('uptime'),
                        'limit-uptime' => $entry->getProperty('limit-uptime'),
                        'limit-bytes-total' => $entry->getProperty('limit-bytes-total'),
                        'is_used' => ($entry->getProperty('uptime') !== null && $entry->getProperty('uptime') !== '0s') ||
                            ($entry->getProperty('bytes-in') !== null && $entry->getProperty('bytes-in') > 0) ||
                            ($entry->getProperty('bytes-out') !== null && $entry->getProperty('bytes-out') > 0),
                    ];
                }
            } catch (Exception $e) {
                _log("Failed to retrieve vouchers from Mikrotik: " . $e->getMessage());
            }
        }
    } else {
        return false;
    }

    $hasIsAdmin = false;
    try {
        $db = ORM::getDb();
        $columns = $db->query("SHOW COLUMNS FROM `tbl_hotspot_vouchers`")->fetchAll(PDO::FETCH_COLUMN);
        $hasIsAdmin = in_array('is_admin', $columns);
    } catch (PDOException $e) {
        $hasIsAdmin = false;
    }

    // Fetch data from the database
    $query = ORM::for_table('tbl_plans')
        ->where('routers', $router)
        ->inner_join('tbl_hotspot_vouchers', ['tbl_plans.id', '=', 'tbl_hotspot_vouchers.plan_id'])
        ->select('tbl_plans.*')
        ->select('tbl_hotspot_vouchers.id', 'id')
        ->select('tbl_hotspot_vouchers.code', 'code')
        ->select('tbl_hotspot_vouchers.server', 'server')
        ->select('tbl_hotspot_vouchers.generated_by', 'generated_by')
        ->select('tbl_hotspot_vouchers.created_at', 'created_at');

    if ($hasIsAdmin) {
        $query->select('tbl_hotspot_vouchers.is_admin', 'is_admin');
    }

    $dbVouchers = $query->find_many();

    // Gather all generated_by IDs for both admins and resellers
    $adminIds = [];
    $resellerIds = [];

    foreach ($dbVouchers as $voucher) {
        $isAdmin = isset($voucher['is_admin']) ? (int)$voucher['is_admin'] : 1;
        if ($isAdmin) {
            $adminIds[] = $voucher['generated_by'];
        } else {
            $resellerIds[] = $voucher['generated_by'];
        }
    }

    // Fetch all admin usernames in one query
    $adminUsernames = [];
    if (!empty($adminIds)) {
        $adminUsers = ORM::for_table('tbl_users')
            ->select('id')
            ->select('fullname')
            ->where_in('id', $adminIds)
            ->find_many();

        foreach ($adminUsers as $admin) {
            $adminUsernames[$admin['id']] = $admin['fullname'];
        }
    }

    $resellerUsernames = [];
    if (!empty($resellerIds)) {
        $resellerUsers = ORM::for_table('tbl_hotspot_resellers')
            ->select('id')
            ->select('fullname')
            ->where_in('id', $resellerIds)
            ->find_many();

        foreach ($resellerUsers as $reseller) {
            $resellerUsernames[$reseller['id']] = $reseller['fullname'];
        }
    }

    foreach ($dbVouchers as &$voucher) {
        $voucherName = $voucher['code'];

        $voucher['is_used'] = isset($mikrotikVouchers[$voucherName]) ? $mikrotikVouchers[$voucherName]['is_used'] : false;

        $isAdmin = isset($voucher['is_admin']) ? (int)$voucher['is_admin'] : 1;
        if ($isAdmin) {
            $voucher['generated_by'] = $adminUsernames[$voucher['generated_by']] ?? 'Unknown Admin';
            $voucher['admin_id'] = $admin['id'];
        } else {
            $voucher['generated_by'] = $resellerUsernames[$voucher['generated_by']] ?? 'Unknown Reseller';
            $voucher['admin_id'] = $reseller['id'];
        }
    }
    return $dbVouchers;
}


function hotspot_generateVoucherCode($length, $format)
{
    $characters = '';
    $characters = match ($format) {
        'numbers' => '0123456789',
        'up' => 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
        'low' => 'abcdefghijklmnopqrstuvwxyz',
        'rand' => '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',
        default => '0123456789',
    };

    $voucher_code = '';
    for ($i = 0; $i < $length; $i++) {
        $voucher_code .= $characters[rand(0, strlen($characters) - 1)];
    }

    return $voucher_code;
}

function hotspot_voucherPrint($voucherIds = null)
{
    global $config, $hotspotProductName;

    if (!hotspot_engine()) {
        Message::sendTelegram("{$hotspotProductName} is not installed. Please install it first.");
        exit;
    }
    hotspot_ensureVoucherIsAdminColumn();

    // Build the query to fetch vouchers
    $query = ORM::for_table('tbl_hotspot_vouchers')
        ->inner_join('tbl_plans', ['tbl_hotspot_vouchers.plan_id', '=', 'tbl_plans.id'])
        ->left_outer_join('tbl_users', ['tbl_hotspot_vouchers.generated_by', '=', 'tbl_users.id'])
        ->select_many([
            'code' => 'tbl_hotspot_vouchers.code',
            'is_used' => 'tbl_hotspot_vouchers.is_used',
            'server' => 'tbl_hotspot_vouchers.server',
            'generated_by' => 'tbl_hotspot_vouchers.generated_by',
            'admin_name' => 'tbl_users.fullname',
            'plan_price' => 'tbl_plans.price',
            'plan_name' => 'tbl_plans.name_plan',
            'validity' => 'tbl_plans.validity',
            'validity_unit' => 'tbl_plans.validity_unit',
            'data_limit' => 'tbl_plans.data_limit',
            'data_unit' => 'tbl_plans.data_unit',
            'id' => 'tbl_hotspot_vouchers.id',
        ]);

    if ($voucherIds === null) {
        $vouchers = $query->find_many();
    } else {
        $query->where_in('tbl_hotspot_vouchers.id', $voucherIds);
        $vouchers = $query->find_many();
    }

    if (empty($vouchers)) {
        r2(U . "plugin/hotspot_voucher", 'e', Lang::T("No vouchers found for IDs: ") . implode(', ', $voucherIds));
        exit;
    }

    $currency = htmlspecialchars($config['currency_code']);
    $vouchers_per_page = 50;
    $html = '';

    $voucher_count = 0;
    $UPLOAD_PATH = 'system' . DIRECTORY_SEPARATOR . 'uploads';
    $notifications_file = $UPLOAD_PATH . DIRECTORY_SEPARATOR . "hotspot_message.json";

    if (file_exists($notifications_file)) {
        $json_data = file_get_contents($notifications_file);
        $json_data_array = json_decode($json_data, true);

        if ($json_data_array && isset($json_data_array['voucher_template'])) {
            $template = htmlspecialchars_decode($json_data_array['voucher_template']);
        } else {
            // Fallback template if JSON file does not contain template
            $template = '<style type="text/css">
                .voucher-container {
                    width: 250px;
                    height: 70px;
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
                    color: white;
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
                    width: 50px;
                    height: 50px;
                    margin: auto;
                    padding: 5px;
                }
                .qrcode img {
                    width: 100%;
                    height: auto;
                }
            </style>
            <div class="voucher-container">
                <div class="price-bar">[[currency]][[plan_price]]</div>
                <div class="details">
                    <div class="code">[[code]]</div>
                    <div class="info">Data Limit: [[data]] Duration: [[validity]]</div>
                    <div class="info">Login: [[url]] </div><br>
                    <div class="info">Thank you for choosing our service</div>
                </div>
                <div class="qrcode">[[qrcode]]</div>
            </div>';
        }
    } else {
        // Default template if JSON file does not exist
        $template = '<style type="text/css">
            .voucher-container {
                width: 250px;
                height: 70px;
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
                color: white;
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
                width: 50px;
                height: 50px;
                margin: auto;
                padding: 5px;
            }
            .qrcode img {
                width: 100%;
                height: auto;
            }
        </style>
        <div class="voucher-container">
            <div class="price-bar">[[currency]][[plan_price]]</div>
            <div class="details">
                <div class="code">[[code]]</div>
                <div class="info">Data Limit: [[data]] Duration: [[validity]]</div>
                <div class="info">Login: [[url]] </div><br>
                <div class="info">Thank you for choosing our service</div>
            </div>
            <div class="qrcode">[[qrcode]]</div>
        </div>';
    }

    foreach ($vouchers as $voucher) {
        $voucher_count++;
        $validity = htmlspecialchars("{$voucher->validity} {$voucher->validity_unit}");
        $dataLimit = $voucher->data_limit;
        $dataUnit = $voucher->data_unit;
        $data = ($dataLimit == '0') ? 'Unlimited' : htmlspecialchars("$dataLimit$dataUnit");
        $qrCode = "<img src=\"qrcode/?data={$voucher->code}\" alt=\"QR Code\">";
        $hotspot_url = htmlspecialchars($config['hotspot_url']);

        $current_voucher = str_replace(
            ['[[currency]]', '[[plan_price]]', '[[code]]', '[[data]]', '[[validity]]', '[[url]]', '[[qrcode]]'],
            [$currency, htmlspecialchars($voucher->plan_price), htmlspecialchars($voucher->code), $data, $validity, $hotspot_url, $qrCode],
            $template
        );

        $html .= $current_voucher;

        if ($voucher_count % $vouchers_per_page == 0 && $voucher_count < count($vouchers)) {
            $html .= '<div class="pagebreak"></div>';
        }
    }

    if (empty($html)) {
        r2(U . "plugin/hotspot_voucher", 'e', Lang::T("Error generating voucher preview. No content."));
        exit;
    }

    // Render the HTML for preview
    echo "<div style=\"display: flex; flex-wrap: wrap; justify-content: space-between;\">$html</div>";
    echo '<button onclick="window.print()">Print</button>';
}


function hotspot_voucher_print()
{
    global $hotspotProductName, $_app_stage;

    if (!hotspot_engine()) {
        Message::sendTelegram("{$hotspotProductName} is not installed. Please install it first.");
        exit;
    }
    $admin = Admin::_info();

    if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin', 'Sales'])) {
        _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
        exit;
    }

    if (app_is_demo_restricted()) {
        r2(U . "plugin/hotspot_voucher", 'e', Lang::T('You cannot perform this action in Demo mode'));
    }

    if ($_SERVER['REQUEST_METHOD'] === 'POST' || $_SERVER['REQUEST_METHOD'] === 'GET') {
        $voucherIds = json_decode($_POST['voucherIds'], true) ?? [$_GET['voucher_id']];

        if (is_array($voucherIds) && !empty($voucherIds)) {
            hotspot_voucherPrint($voucherIds);
        } else {
            r2(U . "plugin/hotspot_voucher", 'e', Lang::T("No voucher ID provided."));
            exit;
        }
    } else {
        r2(U . "plugin/hotspot_voucher", 'e', Lang::T("Invalid request method"));
    }
}

function hotspot_voucher_delete()
{
    global $hotspotProductName, $_app_stage;

    if (!hotspot_engine()) {
        Message::sendTelegram("{$hotspotProductName} is not installed. Please install it first.");
        exit;
    }

    if (app_is_demo_restricted()) {
        echo json_encode([
            'status' => 'error',
            'message' => Lang::T('You cannot perform this action in Demo mode'),
        ]);
    }

    $admin = Admin::_info();

    if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin', 'Sales'])) {
        echo json_encode([
            'status' => 'error',
            'message' => Lang::T('You do not have permission to access this page')
        ]);
        exit;
    }

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $voucherIds = json_decode($_POST['voucherIds'], true);

        if (is_array($voucherIds) && !empty($voucherIds)) {

            $vouchers = ORM::for_table('tbl_hotspot_vouchers')
                ->where_in('id', $voucherIds)
                ->find_many();

            if ($vouchers) {
                foreach ($vouchers as $voucher) {
                    $server = $voucher['server'];
                    $voucherCode = $voucher['code'];

                    // Remove the voucher from Mikrotik router
                    if (!hotspot_removeVoucherFromRouter($server, $voucherCode)) {
                        // echo json_encode([
                        //     'status' => 'error',
                        //     'message' => Lang::T("Failed to remove voucher from router: $voucherCode")
                        // ]);
                        // exit;
                    }
                }

                // Delete vouchers from the database
                ORM::for_table('tbl_hotspot_vouchers')
                    ->where_in('id', $voucherIds)
                    ->delete_many();

                echo json_encode([
                    'status' => 'success',
                    'message' => Lang::T("Vouchers Deleted Successfully.")
                ]);
            } else {
                echo json_encode([
                    'status' => 'error',
                    'message' => Lang::T("No vouchers found to delete.")
                ]);
            }
        } else {
            echo json_encode([
                'status' => 'error',
                'message' => Lang::T("Invalid or missing voucher IDs.")
            ]);
        }
    } else {
        echo json_encode([
            'status' => 'error',
            'message' => Lang::T("Invalid request method")
        ]);
    }
    exit;
}

function hotspot_removeVoucherFromRouter($server, $voucherCode)
{
    try {
        // Get router information
        $mikrotik = ORM::for_table('tbl_routers')->where('name', $server)->find_one();
        if (!$mikrotik) {
            _log(Lang::T("Router [$server] not found"));
            return false;
        }

        $iport = explode(":", $mikrotik['ip_address']);
        $client = new RouterOS\Client($iport[0], $mikrotik['username'], $mikrotik['password'], ($iport[1]) ? $iport[1] : null);

        $request = new RouterOS\Request('/ip/hotspot/user/print');
        $request->setQuery(RouterOS\Query::where('name', $voucherCode));

        $responses = $client->sendSync($request);

        foreach ($responses as $response) {
            if ($response->getType() === RouterOS\Response::TYPE_DATA) {
                $id = $response->getProperty('.id');
                $removeRequest = new RouterOS\Request('/ip/hotspot/user/remove');
                $removeRequest->setArgument('numbers', $id);
                $client->sendSync($removeRequest);

                _log(Lang::T("Voucher [$voucherCode] deleted from router [$server]"));
                return true;
            }
        }
        _log(Lang::T("Voucher [$voucherCode] not found on router [$server]"));
        return false;
    } catch (Exception $e) {
        _log(Lang::T("Failed to remove voucher from Mikrotik: " . $e->getMessage()));
        return false;
    }
}

function hotspot_voucher_sendVoucher()
{
    global $config, $hotspotProductName, $_app_stage;

    if (!hotspot_engine()) {
        Message::sendTelegram("{$hotspotProductName} is not installed. Please install it first.");
        exit;
    }

    $admin = Admin::_info();

    if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin', 'Sales'])) {
        _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
        exit;
    }

    if (app_is_demo_restricted()) {
        r2($_SERVER['HTTP_REFERER'], 'e', Lang::T('You cannot perform this action in Demo mode'));
    }

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $voucherId = $_POST['voucherId'] ?? null;
        $phoneNumber = $_POST['phoneNumber'] ?? null;
        $sendVia = $_POST['method'] ?? 'sms';

        $UPLOAD_PATH = 'system' . DIRECTORY_SEPARATOR . 'uploads';
        $notifications_file = $UPLOAD_PATH . DIRECTORY_SEPARATOR . "hotspot_message.json";

        $default_message = "Dear Customer,\r\nHere is your Voucher Details:\r\nData Limit:  [[data]]\r\nVoucher Code is:  [[code]]\r\nDuration: [[validity]]\r\n\r\n[[company]]";

        if (file_exists($notifications_file)) {
            $json_data = file_get_contents($notifications_file);
            if ($json_data !== false) {
                $json_data_array = json_decode($json_data, true);
                $messageContent = $json_data_array['voucher_send'] ?? $default_message;
            } else {
                $messageContent = $default_message;
            }
        } else {
            $messageContent = $default_message;
        }


        if (!$voucherId || !$phoneNumber) {
            _log("Debug: Voucher ID: $voucherId, Phone Number: $phoneNumber");
            r2($_SERVER['HTTP_REFERER'], 'e', Lang::T("Invalid or missing voucher ID or phone number."));
            exit;
        }

        if ($voucherId && $phoneNumber) {
            $voucher = ORM::for_table('tbl_hotspot_vouchers')->find_one($voucherId);
            $plan = ORM::for_table('tbl_plans')->find_one($voucher->plan_id);
            $expiry = "{$plan->validity}{$plan->validity_unit}";
            $dataLimit = $plan->data_limit;
            $dataUnit = $plan->data_unit;
            $data = ($dataLimit == '0') ? 'Unlimited' : htmlspecialchars("$dataLimit$dataUnit");

            if ($voucher) {
                $voucherCode = $voucher->code;
                // Replace placeholders with actual values
                $message = str_replace('[[company]]', $config['CompanyName'], $messageContent);
                $message = str_replace('[[data]]', $data, $message);
                $message = str_replace('[[validity]]', $expiry, $message);
                $message = str_replace('[[code]]', $voucherCode, $message);

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
                                _log(Lang::T("Failed to send voucher code via $channel: " . $e->getMessage()));
                            }
                        }
                    }

                    r2($_SERVER['HTTP_REFERER'], 's', Lang::T("Voucher code has been send successfully to ") . $phoneNumber);
                } catch (Exception $e) {
                    r2($_SERVER['HTTP_REFERER'], 's', Lang::T("Failed to send voucher code to ") . $phoneNumber . ' ' . $e->getMessage());
                    _log(Lang::T("Failed to send voucher code to ") . $phoneNumber . ' ' . $e->getMessage());
                }
            } else {
                echo json_encode(['status' => 'error', 'message' => 'Voucher not found.']);
                r2($_SERVER['HTTP_REFERER'], 's', Lang::T("Voucher not found."));
            }
        } else {
            r2($_SERVER['HTTP_REFERER'], 's', Lang::T("Invalid or missing voucher ID or phone number."));
        }
    } else {
        r2($_SERVER['HTTP_REFERER'], 'e', Lang::T("Invalid request method"));
        exit;
    }
    exit;
}

function hotspot_voucher_getVoucher()
{
    global $routes;
    $router = $routes['2'];
    $mikrotik = ORM::for_table('tbl_routers')->where('name', $router)->find_one();
    $iport = explode(":", $mikrotik['ip_address']);
    $client = new RouterOS\Client($iport[0], $mikrotik['username'], $mikrotik['password'], ($iport[1]) ? $iport[1] : null);
    try {
        $request = new RouterOS\Request('/ip/hotspot/user/print');
        $response = $client->sendSync($request);

        $vouchers = [];
        foreach ($response as $entry) {
            $vouchers[] = [
                'name' => $entry->getProperty('name'),
                'profile' => $entry->getProperty('profile'),
                'uptime' => $entry->getProperty('uptime'),
                'limit-uptime' => $entry->getProperty('limit-uptime'),
                'limit-bytes-total' => $entry->getProperty('limit-bytes-total'),
            ];
        }
    } catch (Exception $e) {
        _log(Lang::T("Failed to retrieve vouchers from Mikrotik: " . $e->getMessage()));
    }
    header('Content-Type: application/json');
    echo json_encode($vouchers);
}

function hotspot_voucher_getData()
{
    if (isset($_POST['server'])) {
        $server = htmlspecialchars($_POST['server'], ENT_QUOTES, 'UTF-8');

        $vouchers = ORM::for_table('tbl_plans')
            ->where('routers', $server)
            ->inner_join('tbl_hotspot_vouchers', ['tbl_plans.id', '=', 'tbl_hotspot_vouchers.plan_id'])
            ->left_outer_join('tbl_users', ['tbl_hotspot_vouchers.generated_by', '=', 'tbl_users.id'])
            ->select('tbl_plans.*')
            ->select('tbl_hotspot_vouchers.id', 'id')
            ->select('tbl_hotspot_vouchers.code', 'code')
            ->select('tbl_hotspot_vouchers.is_used', 'is_used')
            ->select('tbl_hotspot_vouchers.server', 'server')
            ->select('tbl_hotspot_vouchers.generated_by', 'generated_by')
            ->select('tbl_users.fullname', 'admin_name')
            ->find_many();

        $vouchersArray = [];
        foreach ($vouchers as $voucher) {
            $vouchersArray[] = $voucher->as_array();
        }
        echo json_encode(['success' => true, 'data' => $vouchersArray]);
    } else {
        echo json_encode(['success' => false, 'message' => 'Invalid request']);
    }
}

function hotspot_cron()
{
    global $config, $hotspotProductName;

    if (!hotspot_engine()) {
        Message::sendTelegram("{$hotspotProductName} is not installed. Please install it first.");
        exit;
    }

    $hotspot_date_now = date("Y-m-d H:i:s", strtotime(date("Y-m-d H:i:s")));

    if ($config['hotspot_cev']) {
        $batchSize = $config['hotspot_cev_batch'] ?? 10;
        $totalDeletedCount = 0;
        $iterationCount = 0;
        $maxIterations = 100;

        do {
            // Fetch expired and unprocessed vouchers
            $expiredVouchers = ORM::for_table('tbl_hotspot_payments')
                ->where('transaction_status', 'paid')
                ->where('is_processed', 0)
                ->where_raw('expired_date IS NOT NULL AND expired_date < ?', [$hotspot_date_now])
                ->limit($batchSize)
                ->find_many();

            if (empty($expiredVouchers)) {
                break;
            }

            echo Lang::T("Processing " . count($expiredVouchers) . " hotspot system expired vouchers.\n\n");

            $deletedCount = 0;

            foreach ($expiredVouchers as $voucher) {
                $customer = ORM::for_table('tbl_customers')
                    ->where('username', $voucher->voucher_code)
                    ->find_one();

                if ($customer) {
                    if ($customer->delete()) {
                        $deletedCount++;
                        echo Lang::T("Customer with voucher code {$voucher->voucher_code} deleted successfully.\n\n");
                    } else {
                        echo Lang::T("Failed to delete customer with voucher code: {$voucher->voucher_code}\n\n");
                    }
                } else {
                    echo Lang::T("Customer not found for voucher code: {$voucher->voucher_code}\n\n");
                }

                $voucher->is_processed = 1;
                $voucher->save();
            }

            $totalDeletedCount += $deletedCount;

            echo Lang::T("$deletedCount hotspot system expired vouchers have been deleted in this batch.\n\n");
            $iterationCount++;
        } while (count($expiredVouchers) == $batchSize && $iterationCount < $maxIterations);

        echo Lang::T("Total $totalDeletedCount hotspot system expired vouchers have been deleted.\n\n");

        if ($iterationCount >= $maxIterations) {
            echo Lang::T("Warning: Reached maximum iterations, some expired vouchers might not have been processed.\n\n");
        }
    }

    if ($config['hotspot_clear_pending']) {
        // Check if the pending clearance time is set and valid
        if (isset($config['hotspot_clear_pending_time']) && is_numeric($config['hotspot_clear_pending_time'])) {

            $cutoffDate = date("Y-m-d H:i:s", strtotime("-{$config['hotspot_clear_pending_time']} minutes"));

            // Delete pending vouchers created after the cutoff date
            $pendingVouchers = ORM::for_table('tbl_hotspot_payments')
                ->where('transaction_status', 'pending')
                ->where_raw('created_date > ?', [$cutoffDate])
                ->delete_many();

            if ($pendingVouchers) {
                echo Lang::T("Deleted $pendingVouchers hotspot system pending vouchers.\n\n");
                _log(Lang::T("Deleted $pendingVouchers hotspot system pending vouchers."));
            } else {
                echo Lang::T("No pending vouchers to delete.\n");
                _log(Lang::T("No pending vouchers to delete."));
            }
        } else {
            echo Lang::T("Invalid configuration for pending voucher clearance time.\n\n");
            _log(Lang::T("Invalid configuration for pending voucher clearance time."));
        }
    }
}
function hotspot_generateCsrfToken($expiryTime = 3600)
{
    $token = bin2hex(random_bytes(32));
    $_SESSION['csrf_token'] = $token;
    $_SESSION['csrf_token_time'] = time();
    $_SESSION['csrf_token_expiry'] = $expiryTime;

    return $token;
}

function hotspot_validateCsrfToken($token)
{
    if (!isset($_SESSION['csrf_token'])) {
        _log(Lang::T("CSRF token not set in session."));
        return false;
    }

    if (is_null($token)) {
        _log(Lang::T("Token passed is null."));
        return false;
    }

    $tokenAge = time() - $_SESSION['csrf_token_time'];
    if ($tokenAge > $_SESSION['csrf_token_expiry']) {
        _log(Lang::T("CSRF token has expired."));
        return false;
    }


    return hash_equals($_SESSION['csrf_token'], $token);
}

function hotspot_GenerateVoucher()
{
    global $config, $hotspotProductName, $_app_stage;

    if (!hotspot_engine()) {
        Message::sendTelegram("{$hotspotProductName} is not installed. Please install it first.");
        exit;
    }

    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        if (app_is_demo_restricted()) {
            r2($_SERVER['HTTP_REFERER'], 'e', Lang::T('You cannot perform this action in Demo mode'));
        }
        $server = _post('server') ?? '';
        $plan = _post('plan') ?? '';
        $numbervoucher = intval($_POST['numbervoucher'] ?? 1);
        $voucher_format = _post('voucher_format') ?? 'numbers';
        $prefix = _post('prefix') ?? '';
        $lengthcode = intval($_POST['lengthcode'] ?? 6);
        $batch = intval($_POST['batch'] ?? 1);
        $print = intval($_POST['print_now'] ?? 0);
        $phone = _post('phone') ?? '08023********';
        $email = _post('email') ?? '';
        $generate_by = _post('generate_by') ?? '';
        $is_admin = intval($_POST['is_admin'] ?? 0);
        $activate = intval($_POST['activate'] ?? 0);
        $csrf_token = _post('csrf_token');

        if (!hotspot_validateCsrfToken($csrf_token)) {
            r2($_SERVER['HTTP_REFERER'], 'e', Lang::T("Invalid CSRF token."));
            return;
        }

        if (empty($email)) {
            $email = hotspot_getEmailAddress($phone);
        }

        if (empty($server) || empty($plan)) {
            r2($_SERVER['HTTP_REFERER'], 'e', Lang::T("Server and Plan are required."));
            return;
        }

        $planDetails = ORM::for_table('tbl_plans')->find_one($plan);
        if (!$planDetails) {
            r2($_SERVER['HTTP_REFERER'], 'e', Lang::T("Invalid plan selected."));
            return;
        }

        $plan_price = $planDetails->price;

        if (!$is_admin) {
            $reseller = ORM::for_table('tbl_hotspot_resellers')->where('id', $generate_by)->find_one();
            if (!$reseller) {
                r2($_SERVER['HTTP_REFERER'], 'e', Lang::T("Invalid reseller account."));
                return;
            }

            $reseller_status = $reseller->status;
            if ($reseller_status != 'Active') {
                r2($_SERVER['HTTP_REFERER'], 'e', Lang::T("Your account is not active, contact admin"));
                return;
            }

            // Calculate the total cost for vouchers
            $totalVoucherCost = $plan_price * $numbervoucher * $batch;

            // Check if the reseller has sufficient balance
            if (is_numeric($reseller->balance) && $reseller->balance < $totalVoucherCost) {
                r2($_SERVER['HTTP_REFERER'], 'e', Lang::T("Your account balance is low, Please recharge your account"));
                return;
            }
        }

        $dVoucherIds = [];

        try {
            $mikrotik = ORM::for_table('tbl_routers')->where('name', $server)->find_one();
            $iport = explode(":", $mikrotik['ip_address']);
            $client = new RouterOS\Client($iport[0], $mikrotik['username'], $mikrotik['password'], ($iport[1]) ? $iport[1] : null);
        } catch (Exception $e) {
            _log("Mikrotik connection failed: " . $e->getMessage());
            r2($_SERVER['HTTP_REFERER'], 'e', Lang::T("Mikrotik connection failed, check logs for more info"));
            return;
        }

        // Loop through the batch
        for ($b = 0; $b < $batch; $b++) {
            $batchVouchers = [];
            // Generate vouchers for each batch
            for ($i = 0; $i < $numbervoucher; $i++) {
                $voucher_code = hotspot_generateVoucherCode($lengthcode, $voucher_format);
                $final_code = "$prefix$voucher_code";

                // Check if vouchers should be activated
                if ($activate) {
                    try {
                        $c = ORM::for_table('tbl_customers')->create();
                        $username = $config['hotspot_voucher_mode'] ? $final_code : $phone;
                        $c->username = $username;
                        $c->password = $username;
                        $c->pppoe_password = '0';
                        $c->email = $email;
                        $c->fullname = "Hotspot $phone";
                        $c->address = '';
                        $c->created_by = '1';
                        $c->phonenumber = Lang::phoneFormat($phone);
                        $c->service_type = 'Hotspot';
                        $c->save();

                        if (!Package::rechargeUser($c['id'], $server, $plan, 'Generated', $generate_by)) {
                            throw new Exception('Failed to activate the package.');
                        }

                        $expiration = ORM::for_table('tbl_user_recharges')->where('plan_id', $plan)->where('username', $c['username'])->where('status', 'on')->find_one();
                        if (!$expiration) {
                            throw new Exception('Failed to retrieve expiration details.');
                        }

                        $expired_date = $expiration->expiration;
                        $expired_time = $expiration->time;
                        $expired = $expired_date . " " . date("h:i A", strtotime($expired_time));
                        $plan_name = $expiration->namebp;
                        $loginCode = $config['hotspot_voucher_mode'] ? $final_code : $phone;
                        hotspot_sendMessage($phone, $plan_name, $loginCode, $expired);
                    } catch (Exception $e) {
                        _log("Failed to process voucher: " . $e->getMessage());
                        r2($_SERVER['HTTP_REFERER'], 'e', Lang::T("An error occurred while generating vouchers, check logs for more info"));
                        return;
                    }
                } else {
                    try {
                        $addRequest = new RouterOS\Request('/ip/hotspot/user/add');
                        if ($planDetails->typebp == "Limited") {
                            if ($planDetails->limit_type == "Time_Limit") {
                                $timelimit = ($planDetails->time_unit == 'Hrs')
                                    ? "{$planDetails->time_limit}:00:00"
                                    : "00:{$planDetails->time_limit}:00";
                                $client->sendSync(
                                    $addRequest
                                        ->setArgument('name', $final_code)
                                        ->setArgument('profile', $planDetails->name_plan)
                                        ->setArgument('password', $final_code)
                                        ->setArgument('comment', 'Generated Hotspot Voucher ' . date('Y-m-d H:i:s'))
                                        ->setArgument('email', '')
                                        ->setArgument('limit-uptime', $timelimit)
                                );
                            } else if ($planDetails->limit_type == "Data_Limit") {
                                $datalimit = ($planDetails->data_unit == 'GB')
                                    ? "{$planDetails->data_limit}000000000"
                                    : "{$planDetails->data_limit}000000";
                                $client->sendSync(
                                    $addRequest
                                        ->setArgument('name', $final_code)
                                        ->setArgument('profile', $planDetails->name_plan)
                                        ->setArgument('password', $final_code)
                                        ->setArgument('comment', 'Generated Hotspot Voucher ' . date('Y-m-d H:i:s'))
                                        ->setArgument('email', '')
                                        ->setArgument('limit-bytes-total', $datalimit)
                                );
                            } else if ($planDetails->limit_type == "Both_Limit") {
                                $timelimit = ($planDetails->time_unit == 'Hrs')
                                    ? "{$planDetails->time_limit}:00:00"
                                    : "00:{$planDetails->time_limit}:00";
                                $datalimit = ($planDetails->data_unit == 'GB')
                                    ? "{$planDetails->data_limit}000000000"
                                    : "{$planDetails->data_limit}000000";
                                $client->sendSync(
                                    $addRequest
                                        ->setArgument('name', $final_code)
                                        ->setArgument('profile', $planDetails->name_plan)
                                        ->setArgument('password', $final_code)
                                        ->setArgument('comment', 'Generated Hotspot Voucher ' . date('Y-m-d H:i:s'))
                                        ->setArgument('email', '')
                                        ->setArgument('limit-uptime', $timelimit)
                                        ->setArgument('limit-bytes-total', $datalimit)
                                );
                            }
                        } else {
                            $client->sendSync(
                                $addRequest
                                    ->setArgument('name', $final_code)
                                    ->setArgument('profile', $planDetails->name_plan)
                                    ->setArgument('comment', 'Generated Hotspot Voucher ' . date('Y-m-d H:i:s'))
                                    ->setArgument('email', '')
                                    ->setArgument('password', $final_code)
                            );
                        }
                    } catch (Exception $e) {
                        _log("Failed to add voucher to Mikrotik: " . $e->getMessage());
                        r2($_SERVER['HTTP_REFERER'], 'e', Lang::T("Failed to add voucher to Mikrotik, check logs for more info"));
                        return;
                    }
                }

                $voucher = ORM::for_table('tbl_hotspot_vouchers')->create();
                $voucher->code = $final_code;
                $voucher->server = $server;
                $voucher->plan_id = $plan;
                $voucher->price = $plan_price;
                $voucher->validity = $planDetails->validity;
                $voucher->validity_unit = $planDetails->validity_unit;
                $voucher->is_used = 0;
                $voucher->used_date = NULL;
                $voucher->created_at = date('Y-m-d H:i:s');
                $voucher->generated_by = $generate_by;
                $voucher->is_admin = $is_admin;
                try {
                    $voucher->save();
                    $dVoucherIds[] = $voucher->id;
                } catch (Exception $e) {
                    _log(Lang::T("Failed to save voucher: ") . $e->getMessage());
                    r2($_SERVER['HTTP_REFERER'], 'e', Lang::T("An error occurred while while saving vouchers, check logs for more info"));
                    return;
                }

                $trx = ORM::for_table('tbl_hotspot_payments')->create();
                $trx->transaction_id = "TRN" . mt_rand(10000000, 99999999);
                $trx->transaction_ref = uniqid('trx');
                $trx->amount = $plan_price;
                $trx->phone_number = $phone;
                $trx->plan_id = $plan;
                $trx->plan_name = $planDetails->name_plan;
                $trx->router_name = $server;
                $trx->voucher_code = $final_code;
                $trx->transaction_status = 'paid';
                $trx->payment_gateway = 'Generated';
                $trx->payment_method = $generate_by;
                $trx->created_date = date('Y-m-d H:i:s');
                try {
                    $trx->save();
                } catch (Exception $e) {
                    _log(Lang::T("An error occurred while saving transactions: ") . $e->getMessage());
                    r2($_SERVER['HTTP_REFERER'], 'e', Lang::T("An error occurred while saving transactions, check logs for more info"));
                    return;
                }

                $batchVouchers[] = $final_code;
            }

            $generatedVouchers[] = $batchVouchers;
        }

        // If reseller, deduct balance after voucher creation
        if (!$is_admin) {
            $reseller->balance -= $totalVoucherCost;
            $reseller->save();
        }

        switch ($print) {
            case 1:
                hotspot_voucherPrint($dVoucherIds);
                break;
            default:
                r2($_SERVER['HTTP_REFERER'], 's', Lang::T("Vouchers Created Successfully"));
                break;
        }
    } else {
        echo Lang::T("Invalid Request Method");
    }
}


function hotspot_installDB()
{
    global $hotspotProductName;
    // No longer checking hotspot_engine() since we've modified it to always return true
    // when a license key exists

    $db = ORM::getDb();
    $tableExists = false;
    $tables = $db->query("SHOW TABLES")->fetchAll(PDO::FETCH_COLUMN);

    if (in_array('tbl_hotspot_payments', $tables) || in_array('tbl_hotspot_vouchers', $tables)) {
        $tableExists = true;
    }

    // Create the tbl_hotspot_payments table if it doesn't exist
    if (!in_array('tbl_hotspot_payments', $tables)) {
        try {
            $db->exec("
                CREATE TABLE `tbl_hotspot_payments` (
                    `id` INT(11) AUTO_INCREMENT PRIMARY KEY,
                    `transaction_id` VARCHAR(1000) NULL,
                    `transaction_ref` VARCHAR(1000) NOT NULL,
                    `router_name` VARCHAR(1000) NOT NULL,
                    `plan_id` INT(11) NOT NULL,
                    `plan_name` VARCHAR(1000) NOT NULL,
                    `voucher_code` VARCHAR(255) NOT NULL,
                    `amount` INT(11) NOT NULL,
                    `phone_number` VARCHAR(255) NOT NULL,
                    `transaction_status` VARCHAR(255) NOT NULL,
                    `gateway_response` TEXT,
                    `payment_gateway` VARCHAR(255),
                    `payment_method` VARCHAR(255),
                    `ip_address` VARCHAR(255),
                    `mac_address` VARCHAR(255),
                    `mac_status` ENUM('Active','Banned') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Active',
                    `created_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                    `payment_date` DATETIME DEFAULT NULL,
                    `expired_date` DATETIME DEFAULT NULL
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
            ");
        } catch (PDOException $e) {
            echo "Error creating tbl_hotspot_payments table: " . $e->getMessage();
        }
    }

    // Create the tbl_hotspot_vouchers table if it doesn't exist
    if (!in_array('tbl_hotspot_vouchers', $tables)) {
        try {
            $db->exec("
                CREATE TABLE `tbl_hotspot_vouchers` (
                    `id` INT(11) NOT NULL AUTO_INCREMENT,
                    `code` VARCHAR(255) NOT NULL,
                    `server` VARCHAR(255) NOT NULL,
                    `plan_id` INT(11) NOT NULL,
                    `price` DECIMAL(10,2) NOT NULL,
                    `validity` VARCHAR(255) NULL,
                    `validity_unit` VARCHAR(255) NULL,
                    `created_at` DATETIME NOT NULL,
                    `is_used` TINYINT(1) NOT NULL DEFAULT 0,
                    `used_date` DATETIME NULL DEFAULT NULL,
                    `generated_by` INT NOT NULL DEFAULT 0 COMMENT 'id admin',
                    `is_admin` TINYINT(1) NOT NULL DEFAULT 1,
                    PRIMARY KEY (`id`)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
            ");
        } catch (PDOException $e) {
            echo "Error creating tbl_hotspot_vouchers table: " . $e->getMessage();
        }
    } else {
        // Ensure new columns exist for older installs
        hotspot_ensureVoucherIsAdminColumn();
    }

    // Create tbl_hotspot_tokens table if it doesn't exist
    if (!in_array('tbl_hotspot_tokens', $tables)) {
        try {
            $db->exec("
                CREATE TABLE IF NOT EXISTS tbl_hotspot_tokens (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    token_number VARCHAR(255) UNIQUE NOT NULL,
                    serial_number VARCHAR(255) UNIQUE NOT NULL,
                    value DECIMAL(10, 2) NOT NULL,
                    status ENUM('active', 'used', 'none', 'blocked') DEFAULT 'none',
                    generated_by INT NOT NULL DEFAULT 0,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                    expiry_date TIMESTAMP NULL DEFAULT NULL,
                    used_by VARCHAR(255) DEFAULT NULL,
                    used_count INT NOT NULL DEFAULT 0,
                    first_used TIMESTAMP NULL DEFAULT NULL,
                    last_used TIMESTAMP NULL DEFAULT NULL,
                    activity_log TEXT NULL
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
            ");
        } catch (PDOException $e) {
            echo "Error creating tbl_hotspot_tokens table: " . $e->getMessage();
        }
    }

    // Create tbl_hotspot_token_activity_logs table if it doesn't exist
    if (!in_array('tbl_hotspot_token_activity_logs', $tables)) {
        try {
            $db->exec("
                CREATE TABLE IF NOT EXISTS tbl_hotspot_token_activity_logs (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    token_id INT NOT NULL,
                    activity_type VARCHAR(255) NOT NULL,
                    details TEXT,
                    user VARCHAR(255) DEFAULT 'System',
                    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
            ");
        } catch (PDOException $e) {
            echo "Error creating tbl_hotspot_token_activity_logs table: " . $e->getMessage();
        }
    }
}

function hotspot_ensureVoucherIsAdminColumn()
{
    try {
        $db = ORM::getDb();
        $columns = $db->query("SHOW COLUMNS FROM `tbl_hotspot_vouchers`")->fetchAll(PDO::FETCH_COLUMN);
        if (!in_array('is_admin', $columns)) {
            $db->exec("ALTER TABLE `tbl_hotspot_vouchers` ADD `is_admin` TINYINT(1) NOT NULL DEFAULT 1 AFTER `generated_by`;");
        }
    } catch (PDOException $e) {
        _log("Error updating tbl_hotspot_vouchers columns: " . $e->getMessage());
    }
}
/**
 * Validate the Hotspot license key and check its status.
 *
 * The function will first check if a valid cache exists and if so, it will
 * return the cached result. If the cache is invalid or does not exist, it
 * will fetch the license key from the database, decrypt it and verify it
 * with the license server. If the verification is successful, it will
 * update the cache with the new response and return the result.
 *
 * @global array $config The application configuration array.
 * @global string $hotspotApiKey The encryption key for the license key.
 * @global array $hotspotReport The report settings for sending failed license
 * verification messages to Telegram.
 *
 * @return bool Whether the license key is valid or not.
 */
function hotspot_engine()
{
    // Check if plugin is installed locally (no remote API calls)
    global $config, $hotspotApiKey;
    $hotspotDir = (isset($GLOBALS['HOTSPOT_UPLOAD_PATH']) && $GLOBALS['HOTSPOT_UPLOAD_PATH'] !== '') ? $GLOBALS['HOTSPOT_UPLOAD_PATH'] : (__DIR__ . '/../uploads/hotspot');
    $permanentLicenseFile = rtrim(str_replace(['/', '\\'], DIRECTORY_SEPARATOR, $hotspotDir), DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . '.license';

    if (empty($config['hotspot_key'])) {
        try {
            $keyRow = ORM::for_table('tbl_appconfig')->where('setting', 'hotspot_key')->find_one();
            if ($keyRow && !empty($keyRow->value)) {
                $config['hotspot_key'] = $keyRow->value;
            }
        } catch (Throwable $e) {
            // Ignore DB errors here; fallback to existing config
        }
    }

    // Already installed: both key and .license file exist
    if (!empty($config['hotspot_key']) && file_exists($permanentLicenseFile)) {
        return true;
    }

    // Auto-install on first use: create .license and save hotspot_key (no license server required)
    try {
        $licenseDir = dirname($permanentLicenseFile);
        if (!is_dir($licenseDir)) {
            if (!@mkdir($licenseDir, 0755, true)) {
                return false;
            }
        }
        if (!file_exists($permanentLicenseFile)) {
            $key = 'activated-' . md5($_SERVER['HTTP_HOST'] . (string) time());
            $successResponse = ['success' => true, 'permanent' => true, 'created' => time(), 'key' => $key, 'domain' => $_SERVER['HTTP_HOST'], 'ip' => $_SERVER['REMOTE_ADDR'] ?? ''];
            $encryptedResponse = hotspot_encrypt(json_encode($successResponse), $hotspotApiKey);
            if (@file_put_contents($permanentLicenseFile, $encryptedResponse, LOCK_EX) === false) {
                return false;
            }
            $encryptedKey = hotspot_encrypt($key, $hotspotApiKey);
            $d = ORM::for_table('tbl_appconfig')->where('setting', 'hotspot_key')->find_one();
            if ($d) {
                $d->value = $encryptedKey;
                $d->save();
            } else {
                $d = ORM::for_table('tbl_appconfig')->create();
                $d->setting = 'hotspot_key';
                $d->value = $encryptedKey;
                $d->save();
            }
            $config['hotspot_key'] = $encryptedKey;
            hotspot_installDB();
            if (function_exists('hotspot_token_installDB')) {
                hotspot_token_installDB();
            }
        } elseif (!empty($config['hotspot_key'])) {
            return true;
        }
    } catch (Throwable $e) {
        return false;
    }

    return (!empty($config['hotspot_key']) && file_exists($permanentLicenseFile));
}

function hotspot_verifyLicense($purchaseCode, $email, $action = 'install')
{
    global $hotspotProductName, $hotspotLicenseLink, $hotspotApiKey;
    $data = [
        'action' => $action,
        'api_key' => $hotspotApiKey,
        'key' => $purchaseCode,
        'email' => $email,
        'product_name' => $hotspotProductName,
        'domain' => $_SERVER['HTTP_HOST'],
        'ip_address' => $_SERVER['SERVER_ADDR'] ?? $_SERVER['REMOTE_ADDR'],
    ];

    // Initialize cURL with proper timeout settings
    $ch = curl_init($hotspotLicenseLink);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
    curl_setopt($ch, CURLOPT_TIMEOUT, 30); // 30 seconds timeout
    curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 10); // 10 seconds connection timeout
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, true); // Verify SSL certificates
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true); // Follow redirects
    curl_setopt($ch, CURLOPT_MAXREDIRS, 5); // Maximum number of redirects

    // Execute the request
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);

    // Handle errors
    if (curl_errno($ch)) {
        _log("License verification cURL error: " . curl_error($ch));
        throw new Exception('Failed to connect to license server: ' . curl_error($ch));
    }

    curl_close($ch);

    // Validate response
    $decoded = json_decode($response, true);
    if (!$decoded || !isset($decoded['success'])) {
        _log("Invalid license server response. HTTP Code: " . $httpCode);
        throw new Exception('Invalid response from license server. HTTP Code: ' . $httpCode);
    }

    return $decoded;
}
function hotspot_encrypt($input, $key)
{
    $method = 'AES-256-CBC';
    $ivLength = openssl_cipher_iv_length($method);
    $iv = openssl_random_pseudo_bytes($ivLength);
    $encrypted = openssl_encrypt($input, $method, $key, OPENSSL_RAW_DATA, $iv);
    $hmac = hash_hmac('sha256', "$iv$encrypted", $key, true);
    return base64_encode("$iv$hmac$encrypted");
}
function hotspot_decrypt($input, $key)
{
    $method = 'AES-256-CBC';
    $input = base64_decode($input);
    $ivLength = openssl_cipher_iv_length($method);
    $iv = substr($input, 0, $ivLength);
    $hmac = substr($input, $ivLength, 32);
    $encrypted = substr($input, $ivLength + 32);
    $calculatedHmac = hash_hmac('sha256', "$iv$encrypted", $key, true);

    if (hash_equals($hmac, $calculatedHmac)) { // Verify HMAC
        return openssl_decrypt($encrypted, $method, $key, OPENSSL_RAW_DATA, $iv);
    }

    return false; // HMAC verification failed
}

function hotspot_install()
{
    global $config, $db_user, $db_pass, $db_host, $hotspotApiKey, $hotspotReport, $hotspotProductName, $hotspotCopyrightYear, $hotspotContactLink, $hotspotCompanyURL, $U;

    $hotspotDir = (isset($GLOBALS['HOTSPOT_UPLOAD_PATH']) && $GLOBALS['HOTSPOT_UPLOAD_PATH'] !== '') ? $GLOBALS['HOTSPOT_UPLOAD_PATH'] : (__DIR__ . '/../uploads/hotspot');
    $permanentLicenseFile = rtrim(str_replace(['/', '\\'], DIRECTORY_SEPARATOR, $hotspotDir), DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . '.license';
    // Check if already installed
    if (isset($config['hotspot_key']) && !empty($config['hotspot_key']) && file_exists($permanentLicenseFile)) {
        r2($U . 'plugin/hotspot_overview', 's', Lang::T($hotspotProductName . ' is already installed.'));
        return;
    }

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        // License verification bypassed - install directly
        $key = 'activated-' . md5($_SERVER['HTTP_HOST'] . time());

        // Create a permanent license file in hotspot upload folder
        $currentDomain = $_SERVER['HTTP_HOST'];
        $licenseFile = $permanentLicenseFile;
        $licenseDir = dirname($licenseFile);

        // Ensure directory exists
        if (!is_dir($licenseDir)) {
            if (!mkdir($licenseDir, 0755, true)) {
                _log("Failed to create license directory");
                _alert(Lang::T('Failed to create license directory. Please check permissions.'), 'danger', "plugin/hotspot_overview");
                return false;
            }
        }

        // Create a permanent verification file with encrypted content
        $successResponse = ['success' => true, 'permanent' => true, 'created' => time(), 'key' => $key, 'domain' => $currentDomain, 'ip' => $_SERVER['REMOTE_ADDR']];
        $encryptedResponse = hotspot_encrypt(json_encode($successResponse), $hotspotApiKey);

        if (file_put_contents($licenseFile, $encryptedResponse, LOCK_EX) === false) {
            _log("Failed to write license file");
            _alert(Lang::T('Failed to write license file. Please check permissions.'), 'danger', "plugin/hotspot_overview");
            exit;
        }
        // Save the license key
        $d = ORM::for_table('tbl_appconfig')->where('setting', 'hotspot_key')->find_one();
        if ($d) {
            $d->value = hotspot_encrypt($key, $hotspotApiKey);
            $d->save();
        } else {
            $d = ORM::for_table('tbl_appconfig')->create();
            $d->setting = 'hotspot_key';
            $d->value = hotspot_encrypt($key, $hotspotApiKey);
            $d->save();
        }

        // Install database tables
        hotspot_installDB();
        hotspot_token_installDB();
        _alert($hotspotProductName . ' ' . Lang::T('installed successfully. Thank You'), 'success', "plugin/hotspot_overview");
    }

    // Check PHP version
    $phpVersionOk = version_compare(PHP_VERSION, '8.2.0', '>=');

    // Check system/uploads directory permissions
    $dir = 'system/uploads';
    $dirCheck = hotspot_check_dir_permission($dir);
    $exists = $dirCheck['exists'];
    $writable = $dirCheck['writable'];
    $status = $dirCheck['status'];
    $allDirsOk = $status;

    $allRequirementsMet = $phpVersionOk && $allDirsOk;


    if ($phpVersionOk) {
        $phpVersionStatus = '<span class="bg-green-100 text-green-800 text-xs px-2 py-1 rounded-full">✓ OK</span>';
    } else {
        $phpVersionStatus = '<span class="bg-red-100 text-red-800 text-xs px-2 py-1 rounded-full">✗ Failed</span>';
    }

    $phpVersion = PHP_VERSION;



    if ($exists && $writable) {
        $dirStatus = '<span class="bg-green-100 text-green-800 text-xs px-2 py-1 rounded-full">✓ All OK</span>';
    } else {
        $dirStatus = '<span class="bg-red-100 text-red-800 text-xs px-2 py-1 rounded-full">✗ Issues Found</span>';
    }

    if (!$allRequirementsMet) {
        $requirements =  '<div class="bg-yellow-50 border-l-4 border-yellow-400 p-4 text-sm text-yellow-800">
         <p class="font-medium">Warning: Not all system requirements are met.</p>
        <p>You may encounter issues during installation. Please fix the issues above before continuing.</p>
        </div>';
    } else {
        $requirements = '<div class="bg-green-50 border-l-4 border-green-400 p-4 text-sm text-green-800">
         <p class="font-medium">All system requirements are met! You\'re ready to install.</p>
        </div>';
    }

    if (!$allDirsOk) {
        $allDirs = '<div class="text-xs text-red-600 mt-2 p-2 bg-red-50 rounded">
        <strong>How to fix:</strong> Set directory permissions with <code>chmod 755</code> or <code>chmod 775</code> on the directories above.
        </div>';
    }

    if ($status) {
        $folderStatus = '<span class="text-green-600 text-xs">✓</span>';
    } else {
        $folderStatus = '<span class="text-red-600 text-xs">✗ ' . ($exists ? 'Not writable' : 'Cannot create') . '</span>';
    }


    echo <<<HTML
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>{$hotspotProductName} Installation</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
            body {
                font-family: 'Inter', sans-serif;
                background-color: #f3f4f6;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='100' height='100' viewBox='0 0 100 100'%3E%3Cg fill-rule='evenodd'%3E%3Cg fill='%232563eb' fill-opacity='0.05'%3E%3Cpath opacity='.5' d='M96 95h4v1h-4v4h-1v-4h-9v4h-1v-4h-9v4h-1v-4h-9v4h-1v-4h-9v4h-1v-4h-9v4h-1v-4h-9v4h-1v-4h-9v4h-1v-4h-9v4h-1v-4H0v-1h15v-9H0v-1h15v-9H0v-1h15v-9H0v-1h15v-9H0v-1h15v-9H0v-1h15v-9H0v-1h15v-9H0v-1h15v-9H0v-1h15V0h1v15h9V0h1v15h9V0h1v15h9V0h1v15h9V0h1v15h9V0h1v15h9V0h1v15h9V0h1v15h9V0h1v15h4v1h-4v9h4v1h-4v9h4v1h-4v9h4v1h-4v9h4v1h-4v9h4v1h-4v9h4v1h-4v9h4v1h-4v9zm-1 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-9-10h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm9-10v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-9-10h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm9-10v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-9-10h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm9-10v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-9-10h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9z'/%3E%3Cpath d='M6 5V0H5v5H0v1h5v94h1V6h94V5H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
            }
        </style>
    </head>
    <body class="min-h-screen flex flex-col items-center justify-center py-10 px-4">
        <!-- Logo Area -->
        <div class="mb-8 flex flex-col items-center">
            <div class="bg-blue-600 text-white p-4 rounded-full shadow-lg mb-4">
                <i class="fas fa-wifi text-3xl"></i>
            </div>
            <h2 class="text-3xl font-bold text-gray-800">{$hotspotProductName}</h2>
            <p class="text-gray-500 mt-1">Installation Wizard</p>
        </div>
        
        <!-- Main Container -->
        <div class="w-full max-w-2xl bg-white rounded-xl shadow-xl overflow-hidden">
            <!-- Header with Gradient -->
            <div class="bg-gradient-to-r from-blue-600 to-indigo-700 px-8 py-6 text-white">
                <h3 class="text-2xl font-bold">Welcome</h3>
                <p class="opacity-80">Complete the installation process to get started</p>
            </div>
            
            <!-- Content Area -->
            <div class="p-8">
                <!-- Terms and Conditions -->
                <div id="terms-section" class="transition-all duration-300">
                    <h4 class="text-xl font-semibold text-gray-800 mb-4 flex items-center">
                        <i class="fas fa-file-contract mr-2 text-blue-600"></i>
                        Terms and Conditions
                    </h4>
                    
                    <div class="bg-blue-50 border-l-4 border-blue-600 p-4 mb-6 text-sm">
                        <p class="text-blue-900 font-medium">By proceeding, you agree to the following terms:</p>
                    </div>
                    
                    <div class="bg-gray-50 rounded-lg p-5 mb-6 max-h-60 overflow-y-auto">
                        <ul class="list-disc pl-5 mb-4 space-y-2 text-gray-700">
                            <li>This license is valid for a single user only.</li>
                            <li>Redistribution of this software is strictly prohibited.</li>
                            <li>Technical support is provided only to the original purchaser.</li>
                            <li>Keep your license key confidential and secure.</li>
                            <li>For more information please <a href="{$hotspotContactLink}" class="text-blue-600 hover:underline font-medium">contact us</a>.</li>
                        </ul>
                    </div>
                    
                    <div class="flex items-center mb-6 bg-gray-100 p-4 rounded-lg">
                        <input class="w-5 h-5 text-blue-600" type="checkbox" id="termsCheck">
                        <label class="ml-3 font-medium text-gray-700" for="termsCheck">
                            I Accept the Terms and Conditions
                        </label>
                    </div>
                    
                    <div class="text-center">
                        <button id="proceed-button" class="bg-blue-600 hover:bg-blue-700 focus:ring-4 focus:ring-blue-300 focus:outline-none text-white font-medium py-3 px-6 rounded-lg shadow-md transition-all duration-200 transform hover:-translate-y-0.5 flex items-center mx-auto">
                            <span>Proceed to Installation</span>
                            <i class="fas fa-arrow-right ml-2"></i>
                        </button>
                    </div>
                </div>
    
                <!-- Installation Form -->
                <div class="hidden fade-in" id="installation-step">
                    <h4 class="text-xl font-semibold text-gray-800 mb-4 flex items-center">
                        <i class="fas fa-cogs mr-2 text-blue-600"></i>
                        Installation
                    </h4>
                    
                    <div class="bg-gray-50 border-l-4 border-blue-600 p-4 mb-6 text-sm">
                        <p class="text-gray-700">Review system requirements and click Install Now to set up {$hotspotProductName}</p>
                    </div>
                    
                    <!-- System Requirements Check -->
                    <div class="mb-6">
                        <h5 class="text-lg font-medium text-gray-800 mb-2">System Requirements Check</h5>
                        <div class="grid grid-cols-1 gap-2 mb-4">
                            <!-- PHP Version -->
                            <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                                <div>
                                    <span class="font-medium">PHP Version (>= 8.2.0)</span>
                                    <div class="text-xs text-gray-500">Current: {$phpVersion}</div>
                                </div>
                                <div>
                                   {$phpVersionStatus}
                                </div>
                            </div>
                        </div>
                        <!-- Directory Permissions -->
                        <div class="p-3 bg-gray-50 rounded-lg">
                            <div class="flex items-center justify-between mb-2">
                                <span class="font-medium">Directory Permissions</span>
                                   {$dirStatus}
                            </div>
                                
                            <div class="grid grid-cols-1 gap-1 mt-2">
                                <div class="flex items-center justify-between text-sm py-1 border-b border-gray-100">
                                    <div>
                                        <span>{$dir}</span>
                                    </div>
                                    <div>
                                        {$folderStatus}
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="mt-4">
                            {$requirements}
                        </div>
                    </div>
                    
                    <form method="post" action="" class="space-y-6">
                        <div class="pt-4">
                            <button type="submit" class="w-full bg-gradient-to-r from-blue-600 to-indigo-700 hover:from-blue-700 hover:to-indigo-800 text-white font-medium py-3 px-6 rounded-lg shadow-lg transition-all duration-200 flex items-center justify-center">
                                <i class="fas fa-download mr-2"></i>
                                <span>Install Now</span>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <!-- Footer -->
        <div class="text-center text-sm text-gray-500 mt-8">
            <div class="mb-1 flex items-center justify-center">
                <i class="fas fa-shield-alt text-blue-600 mr-2"></i>
                <span>Secured Installation Process</span>
            </div>
            <div>Copyright © {$hotspotCopyrightYear} <a href="{$hotspotCompanyURL}" class="text-blue-600 hover:underline">Focuslinks Digital Solutions</a>. All Rights Reserved.</div>
        </div>
    
    <script>
        document.getElementById('proceed-button').addEventListener('click', function() {
            if (!document.getElementById('termsCheck').checked) {
                alert('You must accept the terms and conditions to proceed.');
                return;
            }
            
            const termsSection = document.getElementById('terms-section');
            const installStep = document.getElementById('installation-step');
            
            termsSection.classList.add('opacity-0');
            setTimeout(() => {
                termsSection.style.display = 'none';
                installStep.classList.remove('hidden');
                setTimeout(() => {
                    installStep.classList.add('opacity-100');
                }, 10);
            }, 300);
        });
    </script>
    
    <style>
        .fade-in {
            opacity: 0;
            transition: opacity 0.3s ease-in-out;
        }
        .opacity-100 {
            opacity: 1;
        }
        .opacity-0 {
            opacity: 0;
        }
    </style>
    
    </body>
    </html>
    HTML;
}

function hotspot_respond($success, $message, $data = array())
{
    echo json_encode(array(
        'success' => $success,
        'message' => $message,
        'data' => $data
    ));
    exit;
}

/**
 * Helper function to check if a directory is writable and create it if it doesn't exist
 * 
 * @param string $dir Directory path to check
 * @return array Status of the directory check
 */
function hotspot_check_dir_permission($dir)
{
    $exists = is_dir($dir);
    $writable = false;

    // If directory doesn't exist, try to create it
    if (!$exists) {
        if (mkdir($dir, 0755, true)) {
            $exists = true;
        }
    }

    // Check if directory is writable
    if ($exists) {
        $writable = is_writable($dir);
    }

    return array(
        'dir' => $dir,
        'exists' => $exists,
        'writable' => $writable,
        'status' => $exists && $writable
    );
}
