<?php
include 'config.php';
$mysqli = new mysqli($db_host, $db_user, $db_pass, $db_name);

if ($mysqli->connect_error) {
    die("Connection failed: " . $mysqli->connect_error);
}

// Function to get a setting value
function getSettingValue($mysqli, $setting)
{
    $query = $mysqli->prepare("SELECT value FROM tbl_appconfig WHERE setting = ?");
    $query->bind_param("s", $setting);
    $query->execute();
    $result = $query->get_result();
    
    if ($row = $result->fetch_assoc()) {
        return $row['value'];
    }
    return '';
}

// Fetch hotspot title and description from tbl_appconfig
$hotspotTitle = getSettingValue($mysqli, 'hotspot_title');
// Note: phone, faq1, faq2, faq3 now fetched dynamically via API like plans - no hardcoding
$company = getSettingValue($mysqli, 'CompanyName');
$faq1 = getSettingValue($mysqli, 'faq1');
$faq2 = getSettingValue($mysqli, 'faq2');
$faq3 = getSettingValue($mysqli, 'faq3');
$backgroundImageUrl = trim(getSettingValue($mysqli, 'background_image_url'));
$color_scheme = getSettingValue($mysqli, 'color_scheme');
if (empty($color_scheme)) {
    $color_scheme = 'blue';
}

$supportLinkColorClass = "text-{$color_scheme}-400 hover:text-{$color_scheme}-300";
$buttonClass = "bg-{$color_scheme}-700 hover:bg-{$color_scheme}-800";
$buttonTextColor = "text-white";
$priceClass = "text-{$color_scheme}-400";

// Fetch router name and router ID from tbl_appconfig
$routerName = getSettingValue($mysqli, 'router_name');
$routerId = getSettingValue($mysqli, 'router_id');

//check if router name is empty
if (empty($routerName) || empty($routerId)) {
    die("Router name or router ID is not set in the configuration.");
}



// Fetch available plans with offer plans prioritized
$planQuery = "SELECT id, name_plan, price, validity, validity_unit, shared_users FROM tbl_plans WHERE routers = ? AND type = 'Hotspot' AND enabled = 1 ORDER BY CASE WHEN LOWER(name_plan) LIKE '%offer%' THEN 0 ELSE 1 END, CAST(price AS DECIMAL(10,2)) ASC";
$currency_code = getSettingValue($mysqli, 'currency_code');
$planStmt = $mysqli->prepare($planQuery);
$planStmt->bind_param("s", $routerName);
$planStmt->execute();
$planResult = $planStmt->get_result();

// Initialize HTML content variable
$htmlContent = "<!DOCTYPE html>\n";
$htmlContent .= "<html lang=\"en\">\n";
$htmlContent .= "<head>\n";
$htmlContent .= "    <meta charset=\"UTF-8\">\n";
$htmlContent .= "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, viewport-fit=cover\">\n";
$htmlContent .= "    <title>" . htmlspecialchars($hotspotTitle) . "</title>\n";
$htmlContent .= "    <script src=\"https://cdn.tailwindcss.com\"></script>\n";
$htmlContent .= "    <script src=\"https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js\"></script>\n";
$htmlContent .= "    <script src=\"https://cdn.jsdelivr.net/npm/sweetalert2@11\"></script>\n";
$htmlContent .= "    <style>\n";
$htmlContent .= "        /* Enhanced Device Compatibility & Cross-browser fixes */\n";
$htmlContent .= "        * { box-sizing: border-box; -webkit-tap-highlight-color: transparent; }\n";
$htmlContent .= "        html { font-size: clamp(14px, 1.5vw, 18px); }\n";
$htmlContent .= "        body { margin: 0; padding: 0; overflow-x: hidden; -webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale; }\n";
if (!empty($backgroundImageUrl)) {
    $safeBackgroundImageUrl = htmlspecialchars($backgroundImageUrl, ENT_QUOTES, 'UTF-8');
    $htmlContent .= "        body { background-image: url('" . $safeBackgroundImageUrl . "'); background-size: cover; background-position: center center; background-repeat: no-repeat; background-color: #111827; }\n";
}
$htmlContent .= "        input, button { -webkit-appearance: none; -moz-appearance: none; appearance: none; }\n";
$htmlContent .= "        button { touch-action: manipulation; }\n";
$htmlContent .= "        .form-control, input, select, button { font-size: max(16px, 1rem); }\n";
$htmlContent .= "        \n";
$htmlContent .= "        /* TV / very large display readability */\n";
$htmlContent .= "        @media (min-width: 1600px) {\n";
$htmlContent .= "            html { font-size: 19px; }\n";
$htmlContent .= "            #cards-container { gap: 1.5rem !important; max-width: 1500px !important; }\n";
$htmlContent .= "            .plan-card { min-height: 230px !important; }\n";
$htmlContent .= "            .plan-button, #submitBtn, .swal2-confirm-mobile, .swal2-cancel-mobile { min-height: 56px !important; font-size: 1.05rem !important; }\n";
$htmlContent .= "            input, select { min-height: 52px; }\n";
$htmlContent .= "        }\n";
$htmlContent .= "        \n";
$htmlContent .= "        /* Phones and small devices */\n";
$htmlContent .= "        @media (max-width: 480px) {\n";
$htmlContent .= "            #cards-container { gap: 0.65rem !important; padding: 0.35rem !important; }\n";
$htmlContent .= "            .plan-button, #submitBtn { min-height: 44px; }\n";
$htmlContent .= "            #scriptContent { font-size: 0.85rem; }\n";
$htmlContent .= "        }\n";
$htmlContent .= "        \n";
$htmlContent .= "        /* Enhanced SweetAlert Custom Styling - Light Theme */\n";
$htmlContent .= "        .swal2-popup-custom {\n";
$htmlContent .= "            border-radius: 12px !important;\n";
$htmlContent .= "            padding: 24px !important;\n";
$htmlContent .= "            backdrop-filter: blur(10px) !important;\n";
$htmlContent .= "            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12) !important;\n";
$htmlContent .= "            border: 1px solid rgba(0, 0, 0, 0.08) !important;\n";
$htmlContent .= "        }\n";
$htmlContent .= "        \n";
$htmlContent .= "        /* Mobile-specific SweetAlert styling for popups */\n";
$htmlContent .= "        .swal2-popup-mobile {\n";
$htmlContent .= "            width: 90% !important;\n";
$htmlContent .= "            max-width: 400px !important;\n";
$htmlContent .= "            min-width: 280px !important;\n";
$htmlContent .= "            margin: 0 auto !important;\n";
$htmlContent .= "            border-radius: 12px !important;\n";
$htmlContent .= "            padding: 1.5em !important;\n";
$htmlContent .= "            box-sizing: border-box !important;\n";
$htmlContent .= "            transform: none !important;\n";
$htmlContent .= "            position: relative !important;\n";
$htmlContent .= "        }\n";
$htmlContent .= "        \n";
$htmlContent .= "        .swal2-title-mobile {\n";
$htmlContent .= "            font-size: 1.2em !important;\n";
$htmlContent .= "            margin-bottom: 1em !important;\n";
$htmlContent .= "            line-height: 1.3 !important;\n";
$htmlContent .= "            word-wrap: break-word !important;\n";
$htmlContent .= "        }\n";
$htmlContent .= "        \n";
$htmlContent .= "        .swal2-html-mobile {\n";
$htmlContent .= "            margin: 1em 0 !important;\n";
$htmlContent .= "        }\n";
$htmlContent .= "        \n";
$htmlContent .= "        .swal2-html-mobile .swal2-input {\n";
$htmlContent .= "            width: 100% !important;\n";
$htmlContent .= "            max-width: 300px !important;\n";
$htmlContent .= "            margin: 0 auto !important;\n";
$htmlContent .= "            padding: 12px !important;\n";
$htmlContent .= "            font-size: 16px !important;\n";
$htmlContent .= "            border: 2px solid #e2e8f0 !important;\n";
$htmlContent .= "            border-radius: 8px !important;\n";
$htmlContent .= "            box-sizing: border-box !important;\n";
$htmlContent .= "            -webkit-appearance: none !important;\n";
$htmlContent .= "            -moz-appearance: none !important;\n";
$htmlContent .= "            appearance: none !important;\n";
$htmlContent .= "        }\n";
$htmlContent .= "        \n";
$htmlContent .= "        .swal2-confirm-mobile, .swal2-cancel-mobile {\n";
$htmlContent .= "            padding: 10px 20px !important;\n";
$htmlContent .= "            margin: 0 5px !important;\n";
$htmlContent .= "            font-size: 14px !important;\n";
$htmlContent .= "            font-weight: 600 !important;\n";
$htmlContent .= "            border-radius: 6px !important;\n";
$htmlContent .= "            border: none !important;\n";
$htmlContent .= "            min-width: 80px !important;\n";
$htmlContent .= "        }\n";
$htmlContent .= "        \n";
$htmlContent .= "        @media (max-width: 480px) {\n";
$htmlContent .= "            .swal2-popup-mobile {\n";
$htmlContent .= "                width: 95% !important;\n";
$htmlContent .= "                margin: 0 !important;\n";
$htmlContent .= "                padding: 1.2em !important;\n";
$htmlContent .= "            }\n";
$htmlContent .= "            \n";
$htmlContent .= "            .swal2-title-mobile {\n";
$htmlContent .= "                font-size: 1.1em !important;\n";
$htmlContent .= "            }\n";
$htmlContent .= "            \n";
$htmlContent .= "            .swal2-html-mobile .swal2-input {\n";
$htmlContent .= "                font-size: 16px !important;\n";
$htmlContent .= "                padding: 10px !important;\n";
$htmlContent .= "            }\n";
$htmlContent .= "            \n";
$htmlContent .= "            .swal2-confirm-mobile, .swal2-cancel-mobile {\n";
$htmlContent .= "                padding: 8px 16px !important;\n";
$htmlContent .= "                font-size: 13px !important;\n";
$htmlContent .= "                min-width: 70px !important;\n";
$htmlContent .= "            }\n";
$htmlContent .= "        }\n";
$htmlContent .= "        \n";
$htmlContent .= "        /* Performance optimizations */\n";
$htmlContent .= "        .fade-in { animation: fadeIn 0.3s ease-in; }\n";
$htmlContent .= "        @-webkit-keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }\n";
$htmlContent .= "        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }\n";
$htmlContent .= "        \n";
$htmlContent .= "        /* Cards Grid System - Enhanced Layout */\n";
$htmlContent .= "        #cards-container { \n";
$htmlContent .= "            display: grid; \n";
$htmlContent .= "            grid-template-columns: repeat(2, 1fr); \n";
$htmlContent .= "            gap: 0.75rem; \n";
$htmlContent .= "            padding: 0.5rem;\n";
$htmlContent .= "            max-width: 100%;\n";
$htmlContent .= "            margin: 0 auto;\n";
$htmlContent .= "        }\n";
$htmlContent .= "        \n";
$htmlContent .= "        /* Small Tablets and Landscape Mobile */\n";
$htmlContent .= "        @media (min-width: 480px) {\n";
$htmlContent .= "            #cards-container { \n";
$htmlContent .= "                grid-template-columns: repeat(3, 1fr); \n";
$htmlContent .= "                gap: 1rem; \n";
$htmlContent .= "                max-width: 720px;\n";
$htmlContent .= "            }\n";
$htmlContent .= "        }\n";
$htmlContent .= "        \n";
$htmlContent .= "        /* Large Tablets and Desktop */\n";
$htmlContent .= "        @media (min-width: 768px) {\n";
$htmlContent .= "            #cards-container { \n";
$htmlContent .= "                grid-template-columns: repeat(4, 1fr); \n";
$htmlContent .= "                gap: 1.25rem; \n";
$htmlContent .= "                max-width: 1200px;\n";
$htmlContent .= "            }\n";
$htmlContent .= "        }\n";
$htmlContent .= "        \n";
$htmlContent .= "        /* Card Base Styles */\n";
$htmlContent .= "        .plan-card {\n";
$htmlContent .= "            width: 100%;\n";
$htmlContent .= "            min-height: 180px;\n";
$htmlContent .= "            display: flex;\n";
$htmlContent .= "            flex-direction: column;\n";
$htmlContent .= "            transition: all 0.3s ease;\n";
$htmlContent .= "            transform-origin: center;\n";
$htmlContent .= "        }\n";
$htmlContent .= "        \n";
$htmlContent .= "        .plan-card:hover {\n";
$htmlContent .= "            transform: translateY(-4px);\n";
$htmlContent .= "            box-shadow: 0 12px 30px rgba(0,0,0,0.15);\n";
$htmlContent .= "        }\n";
$htmlContent .= "        \n";
$htmlContent .= "        .plan-card:active {\n";
$htmlContent .= "            transform: translateY(-1px);\n";
$htmlContent .= "            box-shadow: 0 6px 20px rgba(0,0,0,0.1);\n";
$htmlContent .= "        }\n";
$htmlContent .= "        \n";
$htmlContent .= "        /* Enhanced card interactions */\n";
$htmlContent .= "        .plan-card {\n";
$htmlContent .= "            cursor: pointer;\n";
$htmlContent .= "            user-select: none;\n";
$htmlContent .= "            -webkit-user-select: none;\n";
$htmlContent .= "            -moz-user-select: none;\n";
$htmlContent .= "            -ms-user-select: none;\n";
$htmlContent .= "        }\n";
$htmlContent .= "        \n";
$htmlContent .= "        .plan-card:focus {\n";
$htmlContent .= "            outline: 2px solid #3b82f6;\n";
$htmlContent .= "            outline-offset: 2px;\n";
$htmlContent .= "        }\n";
$htmlContent .= "        \n";
$htmlContent .= "        /* Offer Plan Styles - Orange/Amber Theme for Blue Background */\n";
$htmlContent .= "        .plan-card.offer-plan {\n";
$htmlContent .= "            background: linear-gradient(135deg, #fff7ed 0%, #fed7aa 100%);\n";
$htmlContent .= "            border: 2px solid #f97316;\n";
$htmlContent .= "            box-shadow: 0 4px 12px rgba(249, 115, 22, 0.25);\n";
$htmlContent .= "            position: relative;\n";
$htmlContent .= "        }\n";
$htmlContent .= "        \n";
$htmlContent .= "        .plan-card.offer-plan:hover {\n";
$htmlContent .= "            transform: translateY(-6px);\n";
$htmlContent .= "            box-shadow: 0 16px 40px rgba(249, 115, 22, 0.35);\n";
$htmlContent .= "        }\n";
$htmlContent .= "        \n";
$htmlContent .= "        .plan-card.offer-plan::before {\n";
$htmlContent .= "            content: 'SPECIAL OFFER';\n";
$htmlContent .= "            position: absolute;\n";
$htmlContent .= "            top: -2px;\n";
$htmlContent .= "            right: -2px;\n";
$htmlContent .= "            background: linear-gradient(135deg, #f97316 0%, #ea580c 100%);\n";
$htmlContent .= "            color: white;\n";
$htmlContent .= "            padding: 4px 8px;\n";
$htmlContent .= "            font-size: 0.6rem;\n";
$htmlContent .= "            font-weight: bold;\n";
$htmlContent .= "            border-radius: 0 8px 0 8px;\n";
$htmlContent .= "            z-index: 10;\n";
$htmlContent .= "        }\n";
$htmlContent .= "        \n";
$htmlContent .= "        .plan-card.offer-plan .bg-green-500 {\n";
$htmlContent .= "            background: linear-gradient(135deg, #f97316 0%, #ea580c 100%) !important;\n";
$htmlContent .= "        }\n";
$htmlContent .= "        \n";
$htmlContent .= "        .plan-card.offer-plan .plan-title {\n";
$htmlContent .= "            color: white !important;\n";
$htmlContent .= "            font-weight: 700;\n";
$htmlContent .= "        }\n";
$htmlContent .= "        \n";
$htmlContent .= "        .plan-card.offer-plan .plan-price {\n";
$htmlContent .= "            color: #c2410c;\n";
$htmlContent .= "            font-weight: 800;\n";
$htmlContent .= "        }\n";
$htmlContent .= "        \n";
$htmlContent .= "        .plan-card.offer-plan .plan-currency {\n";
$htmlContent .= "            color: #9a3412;\n";
$htmlContent .= "        }\n";
$htmlContent .= "        \n";
$htmlContent .= "        /* Mobile responsive for offer badge */\n";
$htmlContent .= "        @media (max-width: 480px) {\n";
$htmlContent .= "            .plan-card.offer-plan::before {\n";
$htmlContent .= "                content: 'OFFER';\n";
$htmlContent .= "                font-size: 0.55rem;\n";
$htmlContent .= "                padding: 3px 6px;\n";
$htmlContent .= "            }\n";
$htmlContent .= "        }\n";
$htmlContent .= "        \n";
$htmlContent .= "        /* Responsive Text Sizing - Enhanced for better visibility on small screens */\n";
$htmlContent .= "        .plan-title { font-size: clamp(0.8rem, 2.2vw, 1.0rem); font-weight: 600; }\n";
$htmlContent .= "        .plan-price { font-size: clamp(1.3rem, 4.5vw, 1.9rem); font-weight: 800; }\n";
$htmlContent .= "        .plan-currency { font-size: clamp(0.75rem, 2.2vw, 0.95rem); font-weight: 500; }\n";
$htmlContent .= "        .plan-validity { font-size: clamp(0.7rem, 2.2vw, 0.85rem); font-weight: 500; }\n";
$htmlContent .= "        .plan-button { font-size: clamp(0.75rem, 2.2vw, 0.9rem); font-weight: 600; }
        
        /* Additional mobile-specific enhancements for very small screens */
        @media (max-width: 480px) {
            .plan-card {
                min-height: 180px;
                padding: 0.5rem;
            }
            .plan-title {
                font-size: 0.95rem !important;
                line-height: 1.3;
                padding: 0.5rem;
            }
            .plan-price {
                font-size: 1.6rem !important;
                margin-bottom: 0.5rem;
            }
            .plan-currency {
                font-size: 0.9rem !important;
            }
            .plan-validity {
                font-size: 0.85rem !important;
                margin-bottom: 1rem;
            }
            .plan-button {
                font-size: 0.9rem !important;
                padding: 0.75rem 1rem;
                min-height: 44px; /* Better touch target */
            }
        }
        
        /* Extra small devices (iPhone SE, very small Android) */
        @media (max-width: 375px) {
            .plan-title {
                font-size: 0.9rem !important;
            }
            .plan-price {
                font-size: 1.5rem !important;
            }
            .plan-currency {
                font-size: 0.85rem !important;
            }
            .plan-validity {
                font-size: 0.8rem !important;
            }
            .plan-button {
                font-size: 0.85rem !important;
            }
        }\n";
$htmlContent .= "    </style>\n";
$htmlContent .= "    <link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css\">\n";
$htmlContent .= "    <link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/glider-js@1.7.7/glider.min.css\" />\n";
$htmlContent .= "    <script src=\"https://cdn.jsdelivr.net/npm/glider-js@1.7.7/glider.min.js\"></script>\n";
$htmlContent .= "    <link rel=\"preconnect\" href=\"https://cdn.jsdelivr.net\">\n";
$htmlContent .= "    <link rel=\"preconnect\" href=\"https://cdnjs.cloudflare.com\" crossorigin>\n";
$htmlContent .= "    <link rel=\"stylesheet\" href=\"https://rsms.me/inter/inter.css\">\n";
$htmlContent .= "</head>\n";
$htmlContent .= "<body class=\"font-sans antialiased text-gray-900 bg-gray-900 font-inter\">\n";

// Enhanced header section with modern design and device compatibility
$htmlContent .= "    <!-- Main Content -->\n";
$htmlContent .= "    <div class=\"mx-auto max-w-screen-xl px-2 sm:px-4 md:px-6\">\n";
$htmlContent .= "        <div class=\"relative mx-auto mt-4 flex max-w-md sm:max-w-lg flex-1 items-center justify-center overflow-hidden rounded-lg bg-green-50 shadow-md ring-1 ring-green-100\">\n";
$htmlContent .= "            <!-- Text Content -->\n";
$htmlContent .= "            <div class=\"relative w-full p-3 sm:p-5\">\n";
$htmlContent .= "                <!-- Title -->\n";
$htmlContent .= "                <div class=\"mb-3 text-center\">\n";
$htmlContent .= "                    <p class=\"text-lg sm:text-xl md:text-2xl font-bold text-gray-800 sm:text-2xl\">" . htmlspecialchars($hotspotTitle) . "</p>\n";
$htmlContent .= "                    <div class=\"mx-auto mt-1 h-0.5 w-12 sm:w-16 bg-green-400 rounded-full\"></div>\n";
$htmlContent .= "                </div>\n";
$htmlContent .= "                <!-- How to Purchase -->\n";
$htmlContent .= "                <div class=\"mb-4\">\n";
$htmlContent .= "                    <h3 class=\"text-base sm:text-md font-medium text-gray-700 mb-2 flex items-center\">\n";
$htmlContent .= "                        <svg class=\"w-4 h-4 mr-1.5 text-green-600\" fill=\"none\" stroke=\"currentColor\" viewBox=\"0 0 24 24\">\n";
$htmlContent .= "                            <path stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-width=\"2\" d=\"M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2\"></path>\n";
$htmlContent .= "                        </svg>\n";
$htmlContent .= "                        How to Purchase:\n";
$htmlContent .= "                    </h3>\n";
$htmlContent .= "                    <ol class=\"space-y-1.5 text-sm sm:text-base text-gray-700 pl-1\">\n";
$htmlContent .= "                        <li class=\"flex items-start\">\n";
$htmlContent .= "                            <span class=\"flex items-center justify-center w-5 h-5 bg-green-100 text-green-800 rounded-full mr-2 flex-shrink-0 text-xs font-medium\">1</span>\n";
if (!empty($faq1)) {
    $htmlContent .= "                            <span>" . htmlspecialchars($faq1) . "</span>\n";
} else {
    $htmlContent .= "                            <span>Click on your preferred package Buy</span>\n";
}
$htmlContent .= "                        </li>\n";
$htmlContent .= "                        <li class=\"flex items-start\">\n";
$htmlContent .= "                            <span class=\"flex items-center justify-center w-5 h-5 bg-green-100 text-green-800 rounded-full mr-2 flex-shrink-0 text-xs font-medium\">2</span>\n";
if (!empty($faq2)) {
    $htmlContent .= "                            <span>" . htmlspecialchars($faq2) . "</span>\n";
} else {
    $htmlContent .= "                            <span>Enter Your Mpesa No.</span>\n";
}
$htmlContent .= "                        </li>\n";
$htmlContent .= "                        <li class=\"flex items-start\">\n";
$htmlContent .= "                            <span class=\"flex items-center justify-center w-5 h-5 bg-green-100 text-green-800 rounded-full mr-2 flex-shrink-0 text-xs font-medium\">3</span>\n";
if (!empty($faq3)) {
    $htmlContent .= "                            <span>" . htmlspecialchars($faq3) . "</span>\n";
} else {
    $htmlContent .= "                            <span>Enter pin and wait for 30sec to be connected</span>\n";
}
$htmlContent .= "                        </li>\n";
$htmlContent .= "                    </ol>\n";
$htmlContent .= "                </div>\n";

// Dynamic Customer Care Section
$htmlContent .= "                <!-- Dynamic Customer Care -->\n";
$htmlContent .= "                <div id=\"customer-care-section\" class=\"text-center\" style=\"display: none;\">\n";
$htmlContent .= "                    <p class=\"text-sm font-medium text-gray-700 inline-flex items-center bg-green-100/80 px-3 py-1.5 rounded-md\">\n";
$htmlContent .= "                        <svg class=\"w-4 h-4 mr-1.5 text-green-600\" fill=\"none\" stroke=\"currentColor\" viewBox=\"0 0 24 24\">\n";
$htmlContent .= "                            <path stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-width=\"2\" d=\"M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z\"></path>\n";
$htmlContent .= "                        </svg>\n";
$htmlContent .= "                        CUSTOMER CARE: \n";
$htmlContent .= "                        <a id=\"phone-link\" href=\"#\" class=\"text-blue-600 underline hover:text-blue-800 transition\">\n";
$htmlContent .= "                            <span id=\"phone-number\" class=\"text-green-700 ml-1\"></span>\n";
$htmlContent .= "                        </a>\n";
$htmlContent .= "                    </p>\n";
$htmlContent .= "                </div>\n";
$htmlContent .= "            </div>\n";
$htmlContent .= "        </div>\n";
$htmlContent .= "    </div>\n";


// Add simple popup redemption buttons - always side by side with text truncation
$htmlContent .= "    <div class=\"text-center py-8\">\n";
$htmlContent .= "        <h3 class=\"text-xl font-bold text-white mb-6\">Already Have a Code?</h3>\n";
$htmlContent .= "        <div class=\"flex gap-2 sm:gap-4 max-w-lg mx-auto px-2 sm:px-4\">\n";
$htmlContent .= "            <button onclick=\"showVoucherPopup()\" class=\"flex-1 bg-blue-600 hover:bg-blue-700 text-white font-semibold py-3 px-2 sm:px-6 rounded-lg transition duration-200 shadow-lg min-w-0\">\n";
$htmlContent .= "                <svg class=\"w-4 h-4 sm:w-5 sm:h-5 inline-block mr-1 sm:mr-2 flex-shrink-0\" fill=\"none\" stroke=\"currentColor\" viewBox=\"0 0 24 24\">\n";
$htmlContent .= "                    <path stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-width=\"2\" d=\"M15 5v2m0 4v2m0 4v2M5 5a2 2 0 00-2 2v3a1 1 0 001 1h1a1 1 0 001-1V7a2 2 0 00-2-2H5zM5 14a2 2 0 00-2 2v3a1 1 0 001 1h1a1 1 0 001-1v-3a2 2 0 00-2-2H5z\"></path>\n";
$htmlContent .= "                </svg>\n";
$htmlContent .= "                <span class=\"truncate text-xs sm:text-base\">Redeem Voucher</span>\n";
$htmlContent .= "            </button>\n";
$htmlContent .= "            <button onclick=\"showMpesaPopup()\" class=\"flex-1 bg-green-600 hover:bg-green-700 text-white font-semibold py-3 px-2 sm:px-6 rounded-lg transition duration-200 shadow-lg min-w-0\">\n";
$htmlContent .= "                <svg class=\"w-4 h-4 sm:w-5 sm:h-5 inline-block mr-1 sm:mr-2 flex-shrink-0\" fill=\"none\" stroke=\"currentColor\" viewBox=\"0 0 24 24\">\n";
$htmlContent .= "                    <path stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-width=\"2\" d=\"M12 18h.01M8 21h8a2 2 0 002-2V5a2 2 0 00-2-2H8a2 2 0 00-2 2v14a2 2 0 002 2z\"></path>\n";
$htmlContent .= "                </svg>\n";
$htmlContent .= "                <span class=\"truncate text-xs sm:text-base\">M-Pesa Code</span>\n";
$htmlContent .= "            </button>\n";
$htmlContent .= "        </div>\n";
$htmlContent .= "    </div>\n\n";


// Plans container section with modern design
$htmlContent .= "    <div class=\"py-4 sm:py-6 lg:py-8\">\n";
$htmlContent .= "        <div class=\"mx-auto max-w-screen-xl px-4 md:px-6\">\n";
$htmlContent .= "            <div class=\"text-center mb-6\">\n";
$htmlContent .= "                <h2 class=\"text-2xl font-bold text-white mb-2\">Available Internet Plans</h2>\n";
$htmlContent .= "            </div>\n";
$htmlContent .= "            <div id=\"cards-container\">\n";
$htmlContent .= "                <!-- Cards will be populated here -->\n";
$htmlContent .= "            </div>\n";
$htmlContent .= "        </div>\n";
$htmlContent .= "    </div>\n";


// Modern Login Form Design
$htmlContent .= "    <div class=\"max-w-md mx-auto bg-white rounded-2xl overflow-hidden shadow-xl md:max-w-lg form-container my-8\">\n";
$htmlContent .= "        <div class=\"md:flex\">\n";
$htmlContent .= "            <div class=\"w-full p-6 md:p-8\">\n";
$htmlContent .= "                <div class=\"text-center mb-6\">\n";
$htmlContent .= "                    <h3 class=\"text-2xl sm:text-3xl font-bold text-gray-900 bg-gradient-to-r from-blue-600 to-indigo-600 bg-clip-text text-transparent\">Already Have an Active Package?</h3>\n";
$htmlContent .= "                    <p class=\"mt-2 text-gray-500\">Sign in for access</p>\n";
$htmlContent .= "                </div>\n";
$htmlContent .= "                <form id=\"loginForm\" class=\"form\" name=\"login\" action=\"\$(link-login-only)\" method=\"post\" \$(if chap-id)onSubmit=\"return doLogin()\" \$(endif)>\n";
$htmlContent .= "                    <input type=\"hidden\" name=\"dst\" value=\"\$(link-orig)\" />\n";
$htmlContent .= "                    <input type=\"hidden\" name=\"popup\" value=\"true\" />\n";
$htmlContent .= "                    <div class=\"mb-4\">\n";
$htmlContent .= "                        <label class=\"block text-gray-700 text-sm font-bold mb-2\" for=\"username\">Username</label>\n";
$htmlContent .= "                        <input id=\"usernameInput\" class=\"shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline\" name=\"username\" type=\"text\" value=\"\" placeholder=\"Username\">\n";
$htmlContent .= "                    </div>\n";
$htmlContent .= "                    <div class=\"mb-6\" style=\"display: none;\">\n";
$htmlContent .= "                        <label class=\"block text-gray-700 text-sm font-bold mb-2\" for=\"password\">Password</label>\n";
$htmlContent .= "                        <input id=\"passwordInput\" class=\"shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 mb-3 leading-tight focus:outline-none focus:shadow-outline\" name=\"password\" type=\"password\" value=\"1234\" placeholder=\"******************\">\n";
$htmlContent .= "                    </div>\n";
$htmlContent .= "                    <div class=\"flex items-center justify-center\">\n";
$htmlContent .= "                        <button id=\"submitBtn\" class=\"bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline\" type=\"button\">\n";
$htmlContent .= "                            Click Here To Connect\n";
$htmlContent .= "                        </button>\n";
$htmlContent .= "                    </div>\n";
$htmlContent .= "                </form>\n";
$htmlContent .= "            </div>\n";
$htmlContent .= "        </div>\n";
$htmlContent .= "    </div>\n";

// Hidden form elements for popup redemption
$htmlContent .= "    <div style=\"display: none;\">\n";
$htmlContent .= "        <input type=\"text\" id=\"voucher_code\" />\n";
$htmlContent .= "        <input type=\"text\" id=\"mpesa_code\" />\n";
$htmlContent .= "    </div>\n\n";

// Modern Footer Section
$htmlContent .= "    <div class=\"mx-auto max-w-screen-2xl px-4 md:px-8\">\n";
$htmlContent .= "        <div class=\"mx-auto max-w-lg\">\n";
$htmlContent .= "            <div class=\"border-t border-gray-700/50 py-4\">\n";
$htmlContent .= "                <p class=\"text-xs text-center font-medium text-gray-400\">\n";
$htmlContent .= "                    &copy; <span id=\"currentYear\"></span> All rights reserved. \n";
$htmlContent .= "                    <span class=\"text-blue-400\"> . $company .  </span>\n";
$htmlContent .= "                </p>\n";
$htmlContent .= "            </div>\n";
$htmlContent .= "        </div>\n";
$htmlContent .= "    </div>\n";
$htmlContent .= "</body>\n";

// Add current year script
$htmlContent .= "<script>\n";
$htmlContent .= "document.addEventListener('DOMContentLoaded', function() {\n";
$htmlContent .= "    var currentYearElement = document.getElementById('currentYear');\n";
$htmlContent .= "    if (currentYearElement) {\n";
$htmlContent .= "        currentYearElement.textContent = new Date().getFullYear();\n";
$htmlContent .= "    }\n";
$htmlContent .= "});\n";
$htmlContent .= "</script>\n";


// Enhanced auto-login with exact logic from reference
$htmlContent .= "<script>\n";
$htmlContent .= "if (!String.prototype.startsWith) { String.prototype.startsWith = function(search, pos){ pos = pos || 0; return this.substring(pos, pos + search.length) === search; }; }\n";
$htmlContent .= "if (!String.prototype.includes) { String.prototype.includes = function(search, start){ if (typeof start !== 'number') start = 0; return this.indexOf(search, start) !== -1; }; }\n";
$htmlContent .= "if (window.NodeList && !NodeList.prototype.forEach) { NodeList.prototype.forEach = Array.prototype.forEach; }\n";
$htmlContent .= "if (!window.fetch) { console.warn('Legacy browser: fetch not supported'); }\n";
$htmlContent .= "    // Utility functions (defined first to avoid reference errors)\n";
$htmlContent .= "    function setCookie(name, value, days) {\n";
$htmlContent .= "        var expires = \"\";\n";
$htmlContent .= "        if (days) {\n";
$htmlContent .= "            var date = new Date();\n";
$htmlContent .= "            date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));\n";
$htmlContent .= "            expires = \"; expires=\" + date.toUTCString();\n";
$htmlContent .= "        }\n";
$htmlContent .= "        document.cookie = name + \"=\" + (value || \"\") + expires + \"; path=/\";\n";
$htmlContent .= "        // Also store in localStorage as backup\n";
$htmlContent .= "        try {\n";
$htmlContent .= "            localStorage.setItem(name, value);\n";
$htmlContent .= "        } catch (e) {\n";
$htmlContent .= "        }\n";
$htmlContent .= "    }\n\n";
$htmlContent .= "    function getCookie(name) {\n";
$htmlContent .= "        var nameEQ = name + \"=\";\n";
$htmlContent .= "        var ca = document.cookie.split(';');\n";
$htmlContent .= "        for (var i = 0; i < ca.length; i++) {\n";
$htmlContent .= "            var c = ca[i];\n";
$htmlContent .= "            while (c.charAt(0) == ' ') c = c.substring(1, c.length);\n";
$htmlContent .= "            if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);\n";
$htmlContent .= "        }\n";
$htmlContent .= "        // Try getting from localStorage if cookie not found\n";
$htmlContent .= "        try {\n";
$htmlContent .= "            var localValue = localStorage.getItem(name);\n";
$htmlContent .= "            if (localValue) {\n";
$htmlContent .= "                // Restore cookie from localStorage\n";
$htmlContent .= "                setCookie(name, localValue, 100);\n";
$htmlContent .= "                return localValue;\n";
$htmlContent .= "            }\n";
$htmlContent .= "        } catch (e) {\n";
$htmlContent .= "        }\n";
$htmlContent .= "        return null;\n";
$htmlContent .= "    }\n\n";
$htmlContent .= "    function generateAccountNumber() {\n";
$htmlContent .= "        return '' + Math.floor(10000 + Math.random() * 90000); // Generate a random number between 10000 and 99999\n";
$htmlContent .= "    }\n\n";
$htmlContent .= "    function persistAccountNumber() {\n";
$htmlContent .= "        var accountNumber = getCookie('account_number');\n";
$htmlContent .= "        if (!accountNumber) {\n";
$htmlContent .= "            accountNumber = generateAccountNumber();\n";
$htmlContent .= "            setCookie('account_number', accountNumber, 365); // Store for 1 year\n";
$htmlContent .= "        }\n";
$htmlContent .= "        return accountNumber;\n";
$htmlContent .= "    }\n\n";
$htmlContent .= "    // Simple auto-trigger after 2 minutes (like login.html)\n";
$htmlContent .= "    var triggerCount = 0;\n";
$htmlContent .= "    var maxTriggers = 1; // Only trigger once\n\n";
$htmlContent .= "    function triggerReconnectButton() {\n";
$htmlContent .= "        if (triggerCount < maxTriggers) {\n";
$htmlContent .= "            triggerCount++;\n";
$htmlContent .= "            document.getElementById('submitBtn').click();\n";
$htmlContent .= "        } else {\n";
$htmlContent .= "            clearInterval(reconnectInterval);\n";
$htmlContent .= "        }\n";
$htmlContent .= "    }\n\n";
$htmlContent .= "    // Auto-trigger reconnect after 2 minutes\n";
$htmlContent .= "    var reconnectInterval = setInterval(triggerReconnectButton, 120000);\n\n";

$htmlContent .= "    // Simple popup functions for voucher and MPESA redemption (based on payments.html)\n";
$htmlContent .= "    function showVoucherPopup() {\n";
$htmlContent .= "        Swal.fire({\n";
$htmlContent .= "            title: 'Redeem Voucher',\n";
$htmlContent .= "            input: 'text',\n";
$htmlContent .= "            inputPlaceholder: 'Enter voucher code (alphanumeric only)',\n";
$htmlContent .= "            inputValidator: function(value) {\n";
$htmlContent .= "                if (!value) {\n";
$htmlContent .= "                    return 'You need to enter a voucher code!';\n";
$htmlContent .= "                }\n";
$htmlContent .= "                // Remove whitespace\n";
$htmlContent .= "                var cleanedValue = value.trim().replace(/\\s+/g, '');\n";
$htmlContent .= "                // Check minimum length\n";
$htmlContent .= "                if (cleanedValue.length < 2) {\n";
$htmlContent .= "                    return 'Voucher code must be at least 2 characters long';\n";
$htmlContent .= "                }\n";
$htmlContent .= "                // Check for invalid characters (only alphanumeric allowed)\n";
$htmlContent .= "                if (!/^[a-zA-Z0-9]+$/.test(cleanedValue)) {\n";
$htmlContent .= "                    return 'Voucher code can only contain letters and numbers (no special characters like #, @, etc.)';\n";
$htmlContent .= "                }\n";
$htmlContent .= "            },\n";
$htmlContent .= "            confirmButtonColor: '#3085d6',\n";
$htmlContent .= "            cancelButtonColor: '#d33',\n";
$htmlContent .= "            confirmButtonText: 'Redeem',\n";
$htmlContent .= "            showLoaderOnConfirm: true,\n";
$htmlContent .= "            preConfirm: function (voucherCode) {\n";
$htmlContent .= "                var accountNumber = getCookie('account_number');\n";
$htmlContent .= "                if (!accountNumber) {\n";
$htmlContent .= "                    accountNumber = generateAccountNumber();\n";
$htmlContent .= "                    setCookie('account_number', accountNumber, 365);\n";
$htmlContent .= "                }\n";
$htmlContent .= "                return fetch('" . APP_URL . "/index.php?_route=plugin/CreateHotspotuser&type=redeem_voucher', {\n";
$htmlContent .= "                    method: 'POST',\n";
$htmlContent .= "                    headers: {'Content-Type': 'application/json'},\n";
$htmlContent .= "                    body: JSON.stringify({voucher_code: voucherCode, account_number: accountNumber, router_id: " . $routerId . "}),\n";
$htmlContent .= "                })\n";
$htmlContent .= "                .then(function (response) {\n";
$htmlContent .= "                    if (!response.ok) {\n";
$htmlContent .= "                        throw new Error('Server error: ' + response.status);\n";
$htmlContent .= "                    }\n";
$htmlContent .= "                    return response.text().then(function (text) {\n";
$htmlContent .= "                        try {\n";
$htmlContent .= "                            return JSON.parse(text);\n";
$htmlContent .= "                        } catch (e) {\n";
$htmlContent .= "                            console.error('Invalid JSON response:', text);\n";
$htmlContent .= "                            throw new Error('Server returned invalid response. Please try again.');\n";
$htmlContent .= "                        }\n";
$htmlContent .= "                    });\n";
$htmlContent .= "                })\n";
$htmlContent .= "                .then(function (data) {\n";
$htmlContent .= "                    if (data.status === 'error') throw new Error(data.message);\n";
$htmlContent .= "                    if (data.status === 'used') return data;\n";
$htmlContent .= "                    return data;\n";
$htmlContent .= "                })\n";
$htmlContent .= "                .catch(function (error) {\n";
$htmlContent .= "                    console.error('Voucher error:', error);\n";
$htmlContent .= "                    throw error;\n";
$htmlContent .= "                });\n";
$htmlContent .= "            },\n";
$htmlContent .= "            allowOutsideClick: function () { return !Swal.isLoading(); }\n";
$htmlContent .= "        }).then(function (result) {\n";
$htmlContent .= "            if (result.isConfirmed) {\n";
$htmlContent .= "                Swal.fire({\n";
$htmlContent .= "                    icon: 'success',\n";
$htmlContent .= "                    title: 'Voucher Redeemed',\n";
$htmlContent .= "                    text: result.value.message,\n";
$htmlContent .= "                    showConfirmButton: false,\n";
$htmlContent .= "                    allowOutsideClick: false,\n";
$htmlContent .= "                    didOpen: function () {\n";
$htmlContent .= "                        Swal.showLoading();\n";
$htmlContent .= "                        var username = result.value.username;\n";
$htmlContent .= "                        var usernameInput = document.querySelector('input[name=\"username\"]');\n";
$htmlContent .= "                        if (usernameInput) {\n";
$htmlContent .= "                            usernameInput.value = username;\n";
$htmlContent .= "                            document.getElementById('passwordInput').value = result.value.tyhK || '1234';\n";
$htmlContent .= "                            setTimeout(function() {\n";
$htmlContent .= "                                var loginForm = document.getElementById('loginForm');\n";
$htmlContent .= "                                if (loginForm) {\n";
$htmlContent .= "                                    loginForm.submit();\n";
$htmlContent .= "                                }\n";
$htmlContent .= "                            }, 1500);\n";
$htmlContent .= "                        }\n";
$htmlContent .= "                    }\n";
$htmlContent .= "                });\n";
$htmlContent .= "            }\n";
$htmlContent .= "        }).catch(function (error) {\n";
$htmlContent .= "            Swal.fire({\n";
$htmlContent .= "                icon: 'error',\n";
$htmlContent .= "                title: 'Redemption Failed',\n";
$htmlContent .= "                text: error.message || 'An error occurred. Please try again.',\n";
$htmlContent .= "                confirmButtonColor: '#d33'\n";
$htmlContent .= "            });\n";
$htmlContent .= "        });\n";
$htmlContent .= "    }\n\n";
$htmlContent .= "    function showMpesaPopup() {\n";
$htmlContent .= "        Swal.fire({\n";
$htmlContent .= "            title: 'Reconnect with MPesa',\n";
$htmlContent .= "            input: 'text',\n";
$htmlContent .= "            inputPlaceholder: 'Enter MPesa Transaction Code or Full Message',\n";
$htmlContent .= "            inputValidator: function(value) {\n";
$htmlContent .= "                if (!value) {\n";
$htmlContent .= "                    return 'You need to enter an MPesa code!';\n";
$htmlContent .= "                }\n";
$htmlContent .= "                // Accept any input - backend will extract first 10 characters\n";
$htmlContent .= "                if (value.length < 10) {\n";
$htmlContent .= "                    return 'MPesa code must be at least 10 characters';\n";
$htmlContent .= "                }\n";
$htmlContent .= "            },\n";
$htmlContent .= "            confirmButtonColor: '#3085d6',\n";
$htmlContent .= "            cancelButtonColor: '#d33',\n";
$htmlContent .= "            confirmButtonText: 'Reconnect',\n";
$htmlContent .= "            showLoaderOnConfirm: true,\n";
$htmlContent .= "            preConfirm: function (mpesaCode) {\n";
$htmlContent .= "                return fetch('" . APP_URL . "/index.php?_route=plugin/CreateHotspotuser&type=redeem_mpesa_code', {\n";
$htmlContent .= "                    method: 'POST',\n";
$htmlContent .= "                    headers: {'Content-Type': 'application/json'},\n";
$htmlContent .= "                    body: JSON.stringify({mpesa_code: mpesaCode.trim()}),\n";
$htmlContent .= "                })\n";
$htmlContent .= "                .then(function (response) {\n";
$htmlContent .= "                    if (!response.ok) {\n";
$htmlContent .= "                        throw new Error('Network response was not ok');\n";
$htmlContent .= "                    }\n";
$htmlContent .= "                    return response.json();\n";
$htmlContent .= "                })\n";
$htmlContent .= "                .then(function (data) {\n";
$htmlContent .= "                    console.log('API Response:', data);\n";
$htmlContent .= "                    // Handle all non-success statuses as errors for inline display\n";
$htmlContent .= "                    if (data.status !== 'success') {\n";
$htmlContent .= "                        throw new Error(data.message || 'Invalid M-Pesa code');\n";
$htmlContent .= "                    }\n";
$htmlContent .= "                    return data;\n";
$htmlContent .= "                })\n";
$htmlContent .= "                .catch(function (error) {\n";
$htmlContent .= "                    console.error('M-Pesa validation error:', error);\n";
$htmlContent .= "                    throw error;\n";
$htmlContent .= "                });\n";
$htmlContent .= "            },\n";
$htmlContent .= "            allowOutsideClick: function () { return !Swal.isLoading(); }\n";
$htmlContent .= "        }).then(function (result) {\n";
$htmlContent .= "            if (result.isConfirmed) {\n";
$htmlContent .= "                var data = result.value;\n";
$htmlContent .= "                \n";
$htmlContent .= "                // Only success reaches here due to inline error handling\n";
$htmlContent .= "                Swal.fire({\n";
$htmlContent .= "                    icon: 'success',\n";
$htmlContent .= "                    title: 'Reconnection Successful',\n";
$htmlContent .= "                    text: data.message,\n";
$htmlContent .= "                    showConfirmButton: false,\n";
$htmlContent .= "                    allowOutsideClick: false,\n";
$htmlContent .= "                    didOpen: function () {\n";
$htmlContent .= "                        Swal.showLoading();\n";
$htmlContent .= "                        var username = data.username;\n";
$htmlContent .= "                        var usernameInput = document.querySelector('input[name=\"username\"]');\n";
$htmlContent .= "                        if (usernameInput) {\n";
$htmlContent .= "                            usernameInput.value = username;\n";
$htmlContent .= "                            document.getElementById('passwordInput').value = data.tyhK || '1234';\n";
$htmlContent .= "                            setTimeout(function() {\n";
$htmlContent .= "                                var loginForm = document.getElementById('loginForm');\n";
$htmlContent .= "                                if (loginForm) {\n";
$htmlContent .= "                                    loginForm.submit();\n";
$htmlContent .= "                                }\n";
$htmlContent .= "                            }, 2000);\n";
$htmlContent .= "                        }\n";
$htmlContent .= "                    }\n";
$htmlContent .= "                });\n";
$htmlContent .= "            }\n";
$htmlContent .= "        }).catch(function (error) {\n";
$htmlContent .= "            Swal.fire({\n";
$htmlContent .= "                icon: 'error',\n";
$htmlContent .= "                title: 'Oops...',\n";
$htmlContent .= "                text: error.message,\n";
$htmlContent .= "            });\n";
$htmlContent .= "        });\n";
$htmlContent .= "    }\n\n";

$htmlContent .= "    // Tab switching functionality\n";
$htmlContent .= "    function switchTab(event, tabId) {\n";
$htmlContent .= "        event.preventDefault();\n";
$htmlContent .= "        \n";
$htmlContent .= "        // Remove active class from all tabs and content\n";
$htmlContent .= "        var tabLinks = document.querySelectorAll('.nav-link');\n";
$htmlContent .= "        var tabPanes = document.querySelectorAll('.tab-pane');\n";
$htmlContent .= "        \n";
$htmlContent .= "        tabLinks.forEach(function(link) {\n";
$htmlContent .= "            link.classList.remove('active');\n";
$htmlContent .= "        });\n";
$htmlContent .= "        \n";
$htmlContent .= "        tabPanes.forEach(function(pane) {\n";
$htmlContent .= "            pane.classList.remove('active');\n";
$htmlContent .= "        });\n";
$htmlContent .= "        \n";
$htmlContent .= "        // Add active class to clicked tab and corresponding content\n";
$htmlContent .= "        event.target.classList.add('active');\n";
$htmlContent .= "        document.getElementById(tabId).classList.add('active');\n";
$htmlContent .= "        \n";
$htmlContent .= "        // Clear any previous messages when switching tabs\n";
$htmlContent .= "        document.getElementById('message').innerHTML = '';\n";
$htmlContent .= "        document.getElementById('mpesaMessage').innerHTML = '';\n";
$htmlContent .= "    }\n\n";

$htmlContent .= "    // Simple submit function (handled by event listener below)\n";
$htmlContent .= "    function submitLogin() {\n";
$htmlContent .= "        document.getElementById('submitBtn').click();\n";
$htmlContent .= "    }\n";
$htmlContent .= "\n";
$htmlContent .= "    // Main click handler for submit button (like reference payments.html)\n";
$htmlContent .= "    document.addEventListener('DOMContentLoaded', function() {\n";
$htmlContent .= "        var submitBtn = document.getElementById('submitBtn');\n";
$htmlContent .= "        \n";
$htmlContent .= "        submitBtn.addEventListener('click', function(event) {\n";
$htmlContent .= "            event.preventDefault(); // Prevent the default button action\n";
$htmlContent .= "            \n";
$htmlContent .= "            var usernameInput = document.getElementById('usernameInput');\n";
$htmlContent .= "            var passwordInput = document.getElementById('passwordInput');\n";
$htmlContent .= "            var accountNumber = usernameInput.value;\n";
$htmlContent .= "            \n";
$htmlContent .= "            if (accountNumber) {\n";
$htmlContent .= "                // Set password to 1234 (like reference)\n";
$htmlContent .= "                passwordInput.value = '1234';\n";
$htmlContent .= "                // Save account to cookie\n";
$htmlContent .= "                setCookie('account_number', accountNumber, 365);\n";
$htmlContent .= "                // Direct form submission like reference\n";
$htmlContent .= "                var loginForm = document.getElementById('loginForm');\n";
$htmlContent .= "                if (loginForm) {\n";
$htmlContent .= "                    loginForm.submit();\n";
$htmlContent .= "                }\n";
$htmlContent .= "            } else {\n";
$htmlContent .= "                event.preventDefault();\n";
$htmlContent .= "                Swal.fire({\n";
$htmlContent .= "                    icon: 'warning',\n";
$htmlContent .= "                    title: 'Missing Account Number',\n";
$htmlContent .= "                    text: 'Please enter your account number.',\n";
$htmlContent .= "                });\n";
$htmlContent .= "                return false;\n";
$htmlContent .= "            }\n";
$htmlContent .= "        });\n";
$htmlContent .= "    });\n";
$htmlContent .= "\n";
$htmlContent .= "</script>\n";

// Add fetchData function with enhanced card design and features
$htmlContent .= "<script>\n";
$htmlContent .= "// --- Plans Fetch and Display ---\n";
$htmlContent .= "function fetchData() {\n";
$htmlContent .= "    var domain = '" . APP_URL . "';\n";
$htmlContent .= "    var siteUrl = domain + \"/?_route=plugin/CreateHotspotuser&type=hotspot_plans\";\n";
$htmlContent .= "    var request = new XMLHttpRequest();\n";
$htmlContent .= "    var routerId = '" . $routerId . "';\n";
$htmlContent .= "    var requestData = JSON.stringify({router_id: routerId});\n";
$htmlContent .= "    \n";

$htmlContent .= "    \n";
$htmlContent .= "    request.open(\"POST\", siteUrl, true);\n";
$htmlContent .= "    request.setRequestHeader('Content-Type', 'application/json');\n";
$htmlContent .= "    request.onload = function () {\n";
$htmlContent .= "        if (request.readyState === XMLHttpRequest.DONE) {\n";
$htmlContent .= "            if (request.status === 200) {\n";
$htmlContent .= "                try {\n";
$htmlContent .= "                    var fetchedData = JSON.parse(request.responseText);\n";

$htmlContent .= "                    \n";
$htmlContent .= "                    if (fetchedData.status === 'error') {\n";
$htmlContent .= "                        console.error('API Error:', fetchedData.message);\n";
$htmlContent .= "                        document.getElementById('cards-container').innerHTML = '<p class=\"text-center text-red-500 py-8\">Error: ' + fetchedData.message + '</p>';\n";
$htmlContent .= "                        return;\n";
$htmlContent .= "                    }\n";
$htmlContent .= "                    \n";
$htmlContent .= "                    if (Array.isArray(fetchedData) && fetchedData.length > 0) {\n";
$htmlContent .= "                        populateCards({data: fetchedData});\n";
$htmlContent .= "                    } else if (fetchedData.data && Array.isArray(fetchedData.data) && fetchedData.data.length > 0) {\n";
$htmlContent .= "                        populateCards(fetchedData);\n";
$htmlContent .= "                    } else {\n";

$htmlContent .= "                        document.getElementById('cards-container').innerHTML = '<p class=\"text-center text-gray-500 py-8\">No plans available at the moment.</p>';\n";
$htmlContent .= "                    }\n";
$htmlContent .= "                } catch (e) {\n";

$htmlContent .= "                    document.getElementById('cards-container').innerHTML = '<p class=\"text-center text-red-500 py-8\">Error parsing response. Please try again later.</p>';\n";
$htmlContent .= "                }\n";
$htmlContent .= "            } else {\n";

$htmlContent .= "                document.getElementById('cards-container').innerHTML = '<p class=\"text-center text-red-500 py-8\">Network error (' + request.status + '). Please try again later.</p>';\n";
$htmlContent .= "            }\n";
$htmlContent .= "        }\n";
$htmlContent .= "    };\n";
$htmlContent .= "    request.onerror = function () {\n";
$htmlContent .= "        console.error(\"Network error\");\n";
$htmlContent .= "        document.getElementById('cards-container').innerHTML = '<p class=\"text-center text-red-500 py-8\">Network error. Please check your connection.</p>';\n";
$htmlContent .= "    };\n";
$htmlContent .= "    request.send(requestData);\n";
$htmlContent .= "}\n\n";

$htmlContent .= "function populateCards(data) {\n";
$htmlContent .= "    var cardsContainer = document.getElementById('cards-container');\n";
$htmlContent .= "    cardsContainer.innerHTML = ''; // Clear existing content\n";
$htmlContent .= "    \n";
$htmlContent .= "    data.data.forEach(function(router) {\n";
$htmlContent .= "        var plans = router.plans_hotspot || [];\n";
$htmlContent .= "        \n";
$htmlContent .= "        // Sort plans: offer plans first, then by price (lowest to highest)\n";
$htmlContent .= "        plans.sort(function(a, b) {\n";
$htmlContent .= "            var planNameA = (a.planname || a.name_plan || '').toLowerCase();\n";
$htmlContent .= "            var planNameB = (b.planname || b.name_plan || '').toLowerCase();\n";
$htmlContent .= "            \n";
$htmlContent .= "            // Check if plans are offer plans\n";
$htmlContent .= "            var isOfferA = planNameA.includes('offer');\n";
$htmlContent .= "            var isOfferB = planNameB.includes('offer');\n";
$htmlContent .= "            \n";
$htmlContent .= "            // If one is offer and other is not, offer goes first\n";
$htmlContent .= "            if (isOfferA && !isOfferB) return -1;\n";
$htmlContent .= "            if (!isOfferA && isOfferB) return 1;\n";
$htmlContent .= "            \n";
$htmlContent .= "            // If both are offers or both are regular plans, sort by price\n";
$htmlContent .= "            var priceA = parseFloat(a.price || 0);\n";
$htmlContent .= "            var priceB = parseFloat(b.price || 0);\n";
$htmlContent .= "            return priceA - priceB;\n";
$htmlContent .= "        });\n";
$htmlContent .= "        \n";
$htmlContent .= "        plans.forEach(function(item) {\n";
$htmlContent .= "            // Map different field name formats from API\n";
$htmlContent .= "            var planName = item.planname || item.name_plan || 'Unknown Plan';\n";
$htmlContent .= "            var planPrice = item.price || '0';\n";
$htmlContent .= "            var planValidity = item.validity || '1';\n";
$htmlContent .= "            var planUnit = item.timelimit || item.validity_unit || 'day';\n";
$htmlContent .= "            var planId = item.planId || item.id;\n";
$htmlContent .= "            var currency = item.currency || '" . $currency_code . "';\n";
$htmlContent .= "            var routerId = item.routerId || '" . $routerId . "';\n";
$htmlContent .= "            var sharedUsers = item.shared_users || '1';\n";
$htmlContent .= "            var deviceText = sharedUsers == '1' ? '1 device' : sharedUsers + ' devices';\n";
$htmlContent .= "            \n";
$htmlContent .= "            var cardDiv = document.createElement('div');\n";
$htmlContent .= "            \n";
$htmlContent .= "            // Check if plan is an offer plan (case insensitive)\n";
$htmlContent .= "            var isOfferPlan = planName.toLowerCase().includes('offer');\n";
$htmlContent .= "            cardDiv.className = isOfferPlan ? 'plan-card offer-plan bg-white border border-gray-200 rounded-lg shadow-md overflow-hidden cursor-pointer fade-in' : 'plan-card bg-white border border-gray-200 rounded-lg shadow-md overflow-hidden cursor-pointer fade-in';\n";
$htmlContent .= "            \n";
$htmlContent .= "            // Make the entire card clickable - exact signature from reference\n";
$htmlContent .= "            cardDiv.onclick = function(event) { \n";
$htmlContent .= "                handlePhoneNumberSubmission(planId, routerId, planPrice);\n";
$htmlContent .= "                return false;\n";
$htmlContent .= "            };\n";
$htmlContent .= "            cardDiv.innerHTML = \n";
$htmlContent .= "                '<div class=\"bg-green-500 text-white w-full py-1.5 px-2\">' +\n";
$htmlContent .= "                    '<h2 class=\"plan-title font-medium uppercase text-center truncate\">' + planName + '</h2>' +\n";
$htmlContent .= "                '</div>' +\n";
$htmlContent .= "                '<div class=\"px-2 py-3 flex-grow text-center\">' +\n";
$htmlContent .= "                    '<p class=\"plan-price font-bold text-green-600 mb-1\">' +\n";
$htmlContent .= "                        '<span class=\"plan-currency font-medium text-black\">' + currency + '</span> ' +\n";
$htmlContent .= "                        planPrice +\n";
$htmlContent .= "                    '</p>' +\n";
$htmlContent .= "                    '<p class=\"plan-validity text-gray-600 mb-2\">' +\n";
$htmlContent .= "                        'Valid for ' + planValidity + ' ' + planUnit + (planValidity > 1 ? '(s)' : '') +\n";
$htmlContent .= "                    '</p>' +\n";
$htmlContent .= "                    '<p class=\"device-limit text-sm text-gray-700 font-semibold mb-2\">' +\n";
$htmlContent .= "                        deviceText +\n";
$htmlContent .= "                    '</p>' +\n";
$htmlContent .= "                '</div>' +\n";
$htmlContent .= "                '<div class=\"px-2 pb-2\">' +\n";
$htmlContent .= "                    '<button class=\"plan-button w-full bg-gray-900 text-white hover:bg-blue-600 font-semibold py-1.5 px-3 rounded-lg transition duration-300\"' +\n";
$htmlContent .= "                        ' onclick=\"handlePhoneNumberSubmission(\\'' + planId + '\\', \\'' + routerId + '\\', \\'' + planPrice + '\\'); event.stopPropagation(); return false;\">' +\n";
$htmlContent .= "                            'Buy Now' +\n";
$htmlContent .= "                    '</button>' +\n";
$htmlContent .= "                '</div>';\n";
$htmlContent .= "            \n";
$htmlContent .= "            cardsContainer.appendChild(cardDiv);\n";
$htmlContent .= "        });\n";
$htmlContent .= "    });\n";
$htmlContent .= "    enhanceCardInteractions();\n";
$htmlContent .= "    adjustCardSizes();\n";
$htmlContent .= "}\n";
$htmlContent .= "\n";
$htmlContent .= "function enhanceCardInteractions() {\n";
$htmlContent .= "    // Enhanced touch and click feedback for cards\n";
$htmlContent .= "    var cards = document.querySelectorAll('.plan-card');\n";
$htmlContent .= "    cards.forEach(function (card) {\n";
$htmlContent .= "        // Touch interactions\n";
$htmlContent .= "        card.addEventListener('touchstart', function() {\n";
$htmlContent .= "            this.style.transform = 'translateY(-2px)';\n";
$htmlContent .= "            this.style.boxShadow = '0 8px 25px rgba(0,0,0,0.2)';\n";
$htmlContent .= "        });\n";
$htmlContent .= "        card.addEventListener('touchend', function() {\n";
$htmlContent .= "            setTimeout(function () {\n";
$htmlContent .= "                this.style.transform = '';\n";
$htmlContent .= "                this.style.boxShadow = '';\n";
$htmlContent .= "            }, 150);\n";
$htmlContent .= "        });\n";
$htmlContent .= "        \n";
$htmlContent .= "        // Keyboard navigation for accessibility\n";
$htmlContent .= "        card.setAttribute('tabindex', '0');\n";
$htmlContent .= "        card.addEventListener('keydown', function(e) {\n";
$htmlContent .= "            if (e.key === 'Enter' || e.key === ' ') {\n";
$htmlContent .= "                e.preventDefault();\n";
$htmlContent .= "                this.click();\n";
$htmlContent .= "            }\n";
$htmlContent .= "        });\n";
$htmlContent .= "        \n";
$htmlContent .= "        // Add fade-in class for smooth appearance\n";
$htmlContent .= "        card.classList.add('fade-in');\n";
$htmlContent .= "    });\n";
$htmlContent .= "}\n";
$htmlContent .= "\n";
$htmlContent .= "function adjustCardSizes() {\n";
$htmlContent .= "    var cards = document.querySelectorAll('.plan-card');\n";
$htmlContent .= "    var container = document.getElementById('cards-container');\n";
$htmlContent .= "    if (!container) return;\n";
$htmlContent .= "    \n";
$htmlContent .= "    var containerWidth = container.offsetWidth;\n";
$htmlContent .= "    var screenWidth = window.innerWidth;\n";
$htmlContent .= "    var columns = 2; // Default mobile\n";
$htmlContent .= "    \n";
$htmlContent .= "    // Use screen width instead of container width for better detection\n";
$htmlContent .= "    if (screenWidth >= 768) columns = 4;        // Large tablets and desktop\n";
$htmlContent .= "    else if (screenWidth >= 480) columns = 3;   // Small tablets and landscape mobile\n";
$htmlContent .= "    \n";
$htmlContent .= "    var cardWidth = Math.floor((containerWidth - (columns + 1) * 16) / columns);\n";
$htmlContent .= "    \n";
$htmlContent .= "    cards.forEach(function (card) {\n";
$htmlContent .= "        card.style.minWidth = cardWidth + 'px';\n";
$htmlContent .= "    });\n";
$htmlContent .= "}\n";
$htmlContent .= "\n";
$htmlContent .= "// Add resize listener for dynamic optimization\n";
$htmlContent .= "window.addEventListener('resize', adjustCardSizes);\n";
$htmlContent .= "window.addEventListener('orientationchange', function() {\n";
$htmlContent .= "    setTimeout(adjustCardSizes, 100);\n";
$htmlContent .= "});\n";
$htmlContent .= "\n";
$htmlContent .= "fetchData();\n";
$htmlContent .= "</script>\n";


// Add SweetAlert2 CDN
$htmlContent .= "<script src=\"https://cdn.jsdelivr.net/npm/sweetalert2@11\"></script>\n";

// Add utility functions matching payments.html
$htmlContent .= "<script>\n";
$htmlContent .= "    function formatPhoneNumber(phoneNumber) {\n";
$htmlContent .= "        if (phoneNumber.startsWith('+')) {\n";
$htmlContent .= "            phoneNumber = phoneNumber.substring(1);\n";
$htmlContent .= "        }\n";
$htmlContent .= "        if (phoneNumber.startsWith('0')) {\n";
$htmlContent .= "            phoneNumber = '254' + phoneNumber.substring(1);\n";
$htmlContent .= "        }\n";
$htmlContent .= "        if (phoneNumber.match(/^(7|1)/)) {\n";
$htmlContent .= "            phoneNumber = '254' + phoneNumber;\n";
$htmlContent .= "        }\n";
$htmlContent .= "        return phoneNumber;\n";
$htmlContent .= "    }\n\n";





$htmlContent .= "    // Dynamic settings loading\n";
$htmlContent .= "    function loadDynamicSettings() {\n";
$htmlContent .= "        fetch('" . APP_URL . "/index.php?_route=plugin/CreateHotspotuser&type=hotspot_settings')\n";
$htmlContent .= "            .then(function (response) { return response.json(); })\n";
$htmlContent .= "            .then(function (data) {\n";
$htmlContent .= "                if (data.status === 'success') {\n";
$htmlContent .= "                    updateDynamicContent(data.data);\n";
$htmlContent .= "                }\n";
$htmlContent .= "            })\n";
$htmlContent .= "            .catch(function (error) {\n";
$htmlContent .= "                console.log('Settings fetch failed:', error);\n";
$htmlContent .= "            });\n";
$htmlContent .= "    }\n\n";
$htmlContent .= "    function updateDynamicContent(settings) {\n";
$htmlContent .= "        // Update phone number dynamically\n";
$htmlContent .= "        var customerCareSection = document.getElementById('customer-care-section');\n";
$htmlContent .= "        var phoneLink = document.getElementById('phone-link');\n";
$htmlContent .= "        var phoneNumber = document.getElementById('phone-number');\n";
$htmlContent .= "        \n";
$htmlContent .= "        if (settings.phone && settings.phone.trim() !== '') {\n";
$htmlContent .= "            customerCareSection.style.display = 'block';\n";
$htmlContent .= "            phoneLink.href = 'tel:' + settings.phone;\n";
$htmlContent .= "            phoneNumber.textContent = settings.phone;\n";
$htmlContent .= "        } else {\n";
$htmlContent .= "            customerCareSection.style.display = 'none';\n";
$htmlContent .= "        }\n";
$htmlContent .= "    }\n\n";
$htmlContent .= "    // Auto populate username on page load\n";
$htmlContent .= "    document.addEventListener('DOMContentLoaded', function() {\n";
$htmlContent .= "        loadDynamicSettings();\n";
$htmlContent .= "        var accountNumber = persistAccountNumber();\n";
$htmlContent .= "        var usernameInput = document.getElementById('usernameInput');\n";
$htmlContent .= "        if (usernameInput) {\n";
$htmlContent .= "            usernameInput.value = accountNumber;\n";
$htmlContent .= "        }\n";
$htmlContent .= "    });\n\n";



$htmlContent .= "var loginTimeout; // Variable to store the timeout ID\n";
$htmlContent .= "var manualConnectTimer = null;\n";
$htmlContent .= "function clearManualConnectTimer() {\n";
$htmlContent .= "    if (manualConnectTimer) {\n";
$htmlContent .= "        clearTimeout(manualConnectTimer);\n";
$htmlContent .= "        manualConnectTimer = null;\n";
$htmlContent .= "    }\n";
$htmlContent .= "}\n";
$htmlContent .= "function showManualConnectFallback() {\n";
$htmlContent .= "    Swal.fire({\n";
$htmlContent .= "        icon: 'info',\n";
$htmlContent .= "        title: 'Still waiting?',\n";
$htmlContent .= "        html: 'If your TV or browser blocked automatic actions, click <b>Manual Connect</b> to continue.',\n";
$htmlContent .= "        showCancelButton: true,\n";
$htmlContent .= "        confirmButtonText: 'Manual Connect',\n";
$htmlContent .= "        cancelButtonText: 'Keep Waiting',\n";
$htmlContent .= "        allowOutsideClick: false\n";
$htmlContent .= "    }).then(function(result) {\n";
$htmlContent .= "        if (result.isConfirmed) {\n";
$htmlContent .= "            var btn = document.getElementById('submitBtn');\n";
$htmlContent .= "            if (btn) btn.click();\n";
$htmlContent .= "        }\n";
$htmlContent .= "    });\n";
$htmlContent .= "}\n";

$htmlContent .= "function handlePhoneNumberSubmission(planId, routerId, price) {\n";
$htmlContent .= "    Swal.fire({\n";
$htmlContent .= "        title: 'Enter Your Mpesa Number',\n";
$htmlContent .= "        input: 'number',\n";
$htmlContent .= "        inputPlaceholder: '0712345678/0112345678',\n";
$htmlContent .= "        inputAttributes: {\n";
$htmlContent .= "            required: 'true'\n";
$htmlContent .= "        },\n";
$htmlContent .= "        inputValidator: function(value) {\n";
$htmlContent .= "            if (value === '') {\n";
$htmlContent .= "                return 'You need to write your phonenumber!';\n";
$htmlContent .= "            }\n";
$htmlContent .= "        },\n";
$htmlContent .= "        showCancelButton: true,\n";
$htmlContent .= "        confirmButtonColor: '#3085d6',\n";
$htmlContent .= "        cancelButtonColor: '#d33',\n";
$htmlContent .= "        confirmButtonText: 'Pay Now',\n";
$htmlContent .= "        reverseButtons: true,\n";
$htmlContent .= "        showLoaderOnConfirm: true,\n";
$htmlContent .= "        preConfirm: function (phoneNumber) {\n";
$htmlContent .= "            var formattedPhoneNumber = formatPhoneNumber(phoneNumber);\n";
$htmlContent .= "            var accountNumber = getCookie('account_number');\n";
$htmlContent .= "            if (!accountNumber) {\n";
$htmlContent .= "                accountNumber = generateAccountNumber();\n";
$htmlContent .= "                setCookie('account_number', accountNumber, 365);\n";
$htmlContent .= "            }\n";
$htmlContent .= "            document.getElementById('usernameInput').value = accountNumber;\n";
$htmlContent .= "            \n";
$htmlContent .= "            return fetch('" . APP_URL . "/index.php?_route=plugin/CreateHotspotuser&type=grant', {\n";
$htmlContent .= "                method: 'POST',\n";
$htmlContent .= "                headers: {'Content-Type': 'application/json'},\n";
$htmlContent .= "                body: JSON.stringify({phone_number: formattedPhoneNumber, plan_id: planId, router_id: routerId, account_number: accountNumber}),\n";
$htmlContent .= "            })\n";
$htmlContent .= "            .then(function (response) {\n";
$htmlContent .= "                if (!response.ok) throw new Error('Network response was not ok');\n";
$htmlContent .= "                return response.json();\n";
$htmlContent .= "            })\n";
$htmlContent .= "            .then(function (data) {\n";
$htmlContent .= "                if (data.status === 'error') throw new Error(data.message);\n";
$htmlContent .= "                if (data.payment_method === 'paystack' && data.authorization_url) {\n";
$htmlContent .= "                    Swal.fire({\n";
$htmlContent .= "                        icon: 'info',\n";
$htmlContent .= "                        title: 'Pay with Paystack',\n";
$htmlContent .= "                        html: 'Complete payment in the new tab. Keep this page open — we will log you in when Paystack confirms.',\n";
$htmlContent .= "                        showConfirmButton: false,\n";
$htmlContent .= "                        allowOutsideClick: false,\n";
$htmlContent .= "                        didOpen: function () {\n";
$htmlContent .= "                            Swal.showLoading();\n";
$htmlContent .= "                            try { window.open(data.authorization_url, '_blank', 'noopener,noreferrer'); }\n";
$htmlContent .= "                            catch (e) { window.location.href = data.authorization_url; }\n";
$htmlContent .= "                            clearManualConnectTimer();\n";
$htmlContent .= "                            manualConnectTimer = setTimeout(showManualConnectFallback, 25000);\n";
$htmlContent .= "                            checkPaymentStatus(formattedPhoneNumber);\n";
$htmlContent .= "                        }\n";
$htmlContent .= "                    });\n";
$htmlContent .= "                    return formattedPhoneNumber;\n";
$htmlContent .= "                }\n";
$htmlContent .= "                Swal.fire({\n";
$htmlContent .= "                    icon: 'info',\n";
$htmlContent .= "                    title: 'Processing..',\n";
$htmlContent .= "                    html: 'A payment request has been sent to your phone. Please wait while we process your payment.',\n";
$htmlContent .= "                    showConfirmButton: false,\n";
$htmlContent .= "                    allowOutsideClick: false,\n";
$htmlContent .= "                    didOpen: function () {\n";
$htmlContent .= "                        Swal.showLoading();\n";
$htmlContent .= "                        clearManualConnectTimer();\n";
$htmlContent .= "                        manualConnectTimer = setTimeout(showManualConnectFallback, 25000);\n";
$htmlContent .= "                        checkPaymentStatus(formattedPhoneNumber);\n";
$htmlContent .= "                    }\n";
$htmlContent .= "                });\n";
$htmlContent .= "                return formattedPhoneNumber;\n";
$htmlContent .= "            })\n";
$htmlContent .= "            .catch(function (error) {\n";
$htmlContent .= "                Swal.fire({\n";
$htmlContent .= "                    icon: 'error',\n";
$htmlContent .= "                    title: 'Oops...',\n";
$htmlContent .= "                    text: error.message,\n";
$htmlContent .= "                });\n";
$htmlContent .= "            });\n";
$htmlContent .= "        },\n";
$htmlContent .= "        allowOutsideClick: function () { return !Swal.isLoading(); }\n";
$htmlContent .= "    });\n";
$htmlContent .= "}\n\n";

$htmlContent .= "function checkPaymentStatus(phoneNumber) {\n";
$htmlContent .= "    var pollMs = 650;\n";
$htmlContent .= "    var maxWaitMs = 120000;\n";
$htmlContent .= "    var loginDelayMs = 400;\n";
$htmlContent .= "    var checkInterval = null;\n";
$htmlContent .= "    var watchdog = null;\n";
$htmlContent .= "    function stopWatchdog() { if (watchdog) { clearTimeout(watchdog); watchdog = null; } }\n";
$htmlContent .= "    function doVerify() {\n";
$htmlContent .= "        fetch('" . APP_URL . "/index.php?_route=plugin/CreateHotspotuser&type=verify', {\n";
$htmlContent .= "            method: 'POST',\n";
$htmlContent .= "            headers: {'Content-Type': 'application/json'},\n";
$htmlContent .= "            body: JSON.stringify({account_number: document.getElementById('usernameInput').value}),\n";
$htmlContent .= "        })\n";
$htmlContent .= "        .then(function (response) { return response.json(); })\n";
$htmlContent .= "        .then(function (data) {\n";
$htmlContent .= "            if (data.Resultcode === '3') {\n";
$htmlContent .= "                clearManualConnectTimer();\n";
$htmlContent .= "                stopWatchdog();\n";
$htmlContent .= "                if (checkInterval) clearInterval(checkInterval);\n";
$htmlContent .= "                Swal.fire({\n";
$htmlContent .= "                    icon: 'success',\n";
$htmlContent .= "                    title: 'Payment Successful',\n";
$htmlContent .= "                    text: data.Message,\n";
$htmlContent .= "                    showConfirmButton: false,\n";
$htmlContent .= "                    timer: 1800,\n";
$htmlContent .= "                    timerProgressBar: true\n";
$htmlContent .= "                });\n";
$htmlContent .= "                if (loginTimeout) clearTimeout(loginTimeout);\n";
$htmlContent .= "                loginTimeout = setTimeout(function() {\n";
$htmlContent .= "                    var btn = document.getElementById('submitBtn');\n";
$htmlContent .= "                    if (btn) btn.click();\n";
$htmlContent .= "                }, loginDelayMs);\n";
$htmlContent .= "                return;\n";
$htmlContent .= "            }\n";
$htmlContent .= "            if (data.Resultcode === '2') {\n";
$htmlContent .= "                clearManualConnectTimer();\n";
$htmlContent .= "                stopWatchdog();\n";
$htmlContent .= "                if (checkInterval) clearInterval(checkInterval);\n";
$htmlContent .= "                var iconType = data.Status === 'danger' ? 'error' : data.Status;\n";
$htmlContent .= "                Swal.fire({ icon: iconType, title: 'Payment Issue', text: data.Message || data.Message1 });\n";
$htmlContent .= "            }\n";
$htmlContent .= "        })\n";
$htmlContent .= "        .catch(function() {});\n";
$htmlContent .= "    }\n";
$htmlContent .= "    doVerify();\n";
$htmlContent .= "    checkInterval = setInterval(doVerify, pollMs);\n";
$htmlContent .= "    watchdog = setTimeout(function() {\n";
$htmlContent .= "        clearManualConnectTimer();\n";
$htmlContent .= "        if (checkInterval) clearInterval(checkInterval);\n";
$htmlContent .= "        Swal.fire({ icon: 'warning', title: 'Timeout', text: 'Payment verification timed out. If you paid, wait a moment and try logging in, or contact support.' });\n";
$htmlContent .= "    }, maxWaitMs);\n";
$htmlContent .= "}\n\n";

$htmlContent .= "</script>\n";

// Simple and clean CSS for cards
$htmlContent .= "<style>\n";
$htmlContent .= "/* Device Compatibility Fixes */\n";
$htmlContent .= "* { box-sizing: border-box; }\n";
$htmlContent .= "body { margin: 0; padding: 0; overflow-x: hidden; }\n";
$htmlContent .= "</style>\n";

// Modern Form Styling
$htmlContent .= "<style>\n";
$htmlContent .= "/* Modern Form Styling */\n";
$htmlContent .= ".form-container {\n";
$htmlContent .= "    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);\n";
$htmlContent .= "    background-size: 400% 400%;\n";
$htmlContent .= "    animation: gradientShift 15s ease infinite;\n";
$htmlContent .= "    padding: 2px;\n";
$htmlContent .= "}\n";
$htmlContent .= ".form-container > div {\n";
$htmlContent .= "    background: white;\n";
$htmlContent .= "    border-radius: 1rem;\n";
$htmlContent .= "}\n";
$htmlContent .= "@keyframes gradientShift {\n";
$htmlContent .= "    0% { background-position: 0% 50%; }\n";
$htmlContent .= "    50% { background-position: 100% 50%; }\n";
$htmlContent .= "    100% { background-position: 0% 50%; }\n";
$htmlContent .= "}\n";
$htmlContent .= ".input-field {\n";
$htmlContent .= "    transition: all 0.3s ease;\n";
$htmlContent .= "    border: 2px solid #e5e7eb;\n";
$htmlContent .= "}\n";
$htmlContent .= ".input-field:focus {\n";
$htmlContent .= "    border-color: #3b82f6;\n";
$htmlContent .= "    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);\n";
$htmlContent .= "    transform: translateY(-1px);\n";
$htmlContent .= "}\n";
$htmlContent .= ".submit-btn {\n";
$htmlContent .= "    transition: all 0.3s ease;\n";
$htmlContent .= "    position: relative;\n";
$htmlContent .= "    overflow: hidden;\n";
$htmlContent .= "}\n";
$htmlContent .= ".submit-btn:hover {\n";
$htmlContent .= "    transform: translateY(-2px);\n";
$htmlContent .= "    box-shadow: 0 10px 25px rgba(59, 130, 246, 0.3);\n";
$htmlContent .= "}\n";
$htmlContent .= ".submit-btn:active {\n";
$htmlContent .= "    transform: translateY(0);\n";
$htmlContent .= "}\n";
$htmlContent .= ".submit-btn::before {\n";
$htmlContent .= "    content: '';\n";
$htmlContent .= "    position: absolute;\n";
$htmlContent .= "    top: 0;\n";
$htmlContent .= "    left: -100%;\n";
$htmlContent .= "    width: 100%;\n";
$htmlContent .= "    height: 100%;\n";
$htmlContent .= "    background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);\n";
$htmlContent .= "    transition: left 0.5s;\n";
$htmlContent .= "}\n";
$htmlContent .= ".submit-btn:hover::before {\n";
$htmlContent .= "    left: 100%;\n";
$htmlContent .= "}\n";
$htmlContent .= "</style>\n";

// Add jQuery library
$htmlContent .= "<script src=\"https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js\"></script>\n";

// Add device compatibility script
$htmlContent .= "<script>\n";
$htmlContent .= "// Cross-browser and device compatibility\n";
$htmlContent .= "(function() {\n";
$htmlContent .= "    // Detect device type\n";
$htmlContent .= "    var isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);\n";
$htmlContent .= "    var isTV = /TV|SmartTV|GoogleTV|AppleTV|Roku|AFTN|AFTB|AFTM|AFTS|AFTT/i.test(navigator.userAgent);\n";
$htmlContent .= "    var isIOS = /iPad|iPhone|iPod/.test(navigator.userAgent);\n";
$htmlContent .= "    var isAndroid = /Android/.test(navigator.userAgent);\n";
$htmlContent .= "    \n";
$htmlContent .= "    document.addEventListener('DOMContentLoaded', function() {\n";
$htmlContent .= "        // Add device-specific classes\n";
$htmlContent .= "        if (isMobile) document.body.classList.add('is-mobile');\n";
$htmlContent .= "        if (isTV) document.body.classList.add('is-tv');\n";
$htmlContent .= "        if (isIOS) document.body.classList.add('is-ios');\n";
$htmlContent .= "        if (isAndroid) document.body.classList.add('is-android');\n";
$htmlContent .= "        \n";
$htmlContent .= "        // Prevent zoom on input focus for iOS\n";
$htmlContent .= "        if (isIOS) {\n";
$htmlContent .= "            var inputs = document.querySelectorAll('input');\n";
$htmlContent .= "            inputs.forEach(function(input) {\n";
$htmlContent .= "                input.addEventListener('focus', function() {\n";
$htmlContent .= "                    var viewport = document.querySelector('meta[name=viewport]');\n";
$htmlContent .= "                    if (viewport) viewport.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');\n";
$htmlContent .= "                });\n";
$htmlContent .= "                input.addEventListener('blur', function() {\n";
$htmlContent .= "                    var viewport = document.querySelector('meta[name=viewport]');\n";
$htmlContent .= "                    if (viewport) viewport.setAttribute('content', 'width=device-width, initial-scale=1.0');\n";
$htmlContent .= "                });\n";
$htmlContent .= "            });\n";
$htmlContent .= "        }\n";
$htmlContent .= "        \n";
$htmlContent .= "        // Enhanced click handling for TV/Android TV\n";
$htmlContent .= "        if (isTV) {\n";
$htmlContent .= "            document.addEventListener('keydown', function(e) {\n";
$htmlContent .= "                if (e.key === 'Enter' && e.target.classList.contains('cursor-pointer')) {\n";
$htmlContent .= "                    e.target.click();\n";
$htmlContent .= "                }\n";
$htmlContent .= "            });\n";
$htmlContent .= "        }\n";
$htmlContent .= "    });\n";
$htmlContent .= "})();\n";
$htmlContent .= "</script>\n";

// Add button click handlers and voucher/mpesa functions
// Button click handler is now consolidated above in the main DOMContentLoaded listener

// Add voucher redemption function - exact copy from reference
$htmlContent .= "<script>\n";
$htmlContent .= "function redeemVoucher(router_id) {\n";
$htmlContent .= "    var voucherCode = document.getElementById('voucher_code').value;\n";
$htmlContent .= "    if (!voucherCode) {\n";
$htmlContent .= "        document.getElementById('message').innerText = 'Please enter a valid voucher code.';\n";
$htmlContent .= "        return;\n";
$htmlContent .= "    }\n\n";

$htmlContent .= "    fetch('" . APP_URL . "/index.php?_route=plugin/CreateHotspotuser&type=redeem_voucher', {\n";
$htmlContent .= "        method: 'POST',\n";
$htmlContent .= "        headers: { 'Content-Type': 'application/json' },\n";
$htmlContent .= "        body: JSON.stringify({ voucher_code: voucherCode, account_number: generateAccountNumber(), router_id: router_id })\n";
$htmlContent .= "    })\n";
$htmlContent .= "    .then(function (response) {\n";
$htmlContent .= "        if (!response.ok) throw new Error('Network response was not ok');\n";
$htmlContent .= "        return response.json();\n";
$htmlContent .= "    })\n";
$htmlContent .= "    .then(function (data) {\n";
$htmlContent .= "        if (data.status === 'error') throw new Error(data.message);\n";

$htmlContent .= "        if (data && (data.status === 'success' || data.Status === 'used')) {\n";
$htmlContent .= "            document.getElementById('message').innerText = 'Voucher redeemed successfully.';\n";
$htmlContent .= "            document.getElementById('usernameInput').value = data.username;\n";
$htmlContent .= "            document.getElementById('passwordInput').value = data.tyhK;\n";
$htmlContent .= "            setCookie('account_number', data.username, 365);\n\n";
$htmlContent .= "            document.getElementById('submitBtn').click();\n";
$htmlContent .= "        } else {\n";
$htmlContent .= "            document.getElementById('message').innerText = (data && data.message) ? data.message : 'An error occurred. Please try again.';\n";
$htmlContent .= "        }\n";
$htmlContent .= "    })\n";
$htmlContent .= "    .catch(function (error) {\n";
$htmlContent .= "        console.error('Error redeeming voucher:', error);\n";
$htmlContent .= "        document.getElementById('message').innerText = error.message || 'An error occurred. Please try again.';\n";
$htmlContent .= "    });\n";
$htmlContent .= "}\n";
$htmlContent .= "</script>\n";

// Add MPesa reconnection function - exact copy from reference  
$htmlContent .= "<script>\n";
$htmlContent .= "function redeemMpesa() {\n";
$htmlContent .= "    var mpesaCode = document.getElementById('mpesa_code').value.trim();\n";
$htmlContent .= "    if (!mpesaCode) {\n";
$htmlContent .= "        document.getElementById('mpesaMessage').innerText = 'Please enter a valid MPESA code or full message.';\n";
$htmlContent .= "        return;\n";
$htmlContent .= "    }\n";
$htmlContent .= "    if (mpesaCode.length < 10) {\n";
$htmlContent .= "        document.getElementById('mpesaMessage').innerText = 'MPESA code must be at least 10 characters.';\n";
$htmlContent .= "        return;\n";
$htmlContent .= "    }\n\n";

$htmlContent .= "    fetch('" . APP_URL . "/index.php?_route=plugin/CreateHotspotuser&type=redeem_mpesa_code', {\n";
$htmlContent .= "        method: 'POST',\n";
$htmlContent .= "        headers: { 'Content-Type': 'application/json' },\n";
$htmlContent .= "        body: JSON.stringify({ mpesa_code: mpesaCode })\n";
$htmlContent .= "    })\n";
$htmlContent .= "    .then(function (response) {\n";
$htmlContent .= "        if (!response.ok) throw new Error('Network response was not ok');\n";
$htmlContent .= "        return response.json();\n";
$htmlContent .= "    })\n";
$htmlContent .= "    .then(function (data) {\n";
$htmlContent .= "        if (data.status === 'error') throw new Error(data.message);\n\n";
$htmlContent .= "        if (data && (data.status === 'success')) {\n";
$htmlContent .= "            document.getElementById('mpesaMessage').innerText = 'MPESA code redeemed successfully.';\n";
$htmlContent .= "            document.getElementById('usernameInput').value = data.username;\n";
$htmlContent .= "            document.getElementById('passwordInput').value = data.tyhK;\n";
$htmlContent .= "            setCookie('account_number', data.username, 365);\n";
$htmlContent .= "            document.getElementById('submitBtn').click();\n";
$htmlContent .= "        } else {\n";
$htmlContent .= "            document.getElementById('mpesaMessage').innerText = (data && data.message) ? data.message : 'An error occurred. Please try again.';\n";
$htmlContent .= "        }\n";
$htmlContent .= "    })\n";
$htmlContent .= "    .catch(function (error) {\n";
$htmlContent .= "        console.error('Error redeeming MPESA code:', error);\n";
$htmlContent .= "        document.getElementById('mpesaMessage').innerText = error.message || 'An error occurred. Please try again.';\n";
$htmlContent .= "    });\n";
$htmlContent .= "}\n";
$htmlContent .= "</script>\n";

// Close all the HTML tags properly
$htmlContent .= "</html>\n";



$planStmt->close();
$mysqli->close();
// Check if the download parameter is set
if (isset($_GET['download']) && $_GET['download'] == '1') {
    // Prepare the HTML content for download
    // ... build your HTML content ...

    // Specify the filename for the download
    $filename = "login.html";

    // Send headers to force download
    header('Content-Type: application/octet-stream');
    header('Content-Disposition: attachment; filename=' . basename($filename));
    header('Expires: 0');
    header('Cache-Control: must-revalidate');
    header('Pragma: public');
    header('Content-Length: ' . strlen($htmlContent));

    // Output the content
    echo $htmlContent;

    // Prevent any further output
    exit;
}

// Regular page content goes here
// ... HTML and PHP code to display the page ...

if (isset($_GET['preview']) && $_GET['preview'] == '1') {
    // Generate your login page HTML as $htmlContent
    // ... your HTML generation logic here ...

    header('Content-Type: text/html; charset=UTF-8');
    echo $htmlContent;
    exit;
}

