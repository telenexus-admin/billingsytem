<?php

$protocol = (!empty($_SERVER["HTTPS"]) && $_SERVER["HTTPS"] !== "off" || (isset($_SERVER["SERVER_PORT"]) && $_SERVER["SERVER_PORT"] == 443)) ? "https://" : "http://";
$host = isset($_SERVER["HTTP_HOST"]) ? $_SERVER["HTTP_HOST"] : (isset($_SERVER["SERVER_NAME"]) ? $_SERVER["SERVER_NAME"] : 'localhost');
$baseDir = rtrim(dirname(isset($_SERVER["SCRIPT_NAME"]) ? $_SERVER["SCRIPT_NAME"] : ''), "/\\");
define("APP_URL", $protocol . $host . $baseDir);

// Live, Dev, Demo
$_app_stage = "Live";

// true = no demo-style limits (router/SMS/settings/plugins); false = honour Demo mode when $_app_stage is demo
$_app_unlimited = true;

// Database PHPNuxBill
$db_host	    = "localhost";
$db_user        = "root";
$db_pass    	= "";
$db_name	    = "luy";

// Database Radius
$radius_host	    = "localhost";
$radius_user        = "root";
$radius_pass    	= "";
$radius_name	    = "luy";

if($_app_stage!="Live"){
    error_reporting(E_ERROR);
    ini_set("display_errors", 1);
    ini_set("display_startup_errors", 1);
}else{
    error_reporting(E_ERROR);
    ini_set("display_errors", 0);
    ini_set("display_startup_errors", 0);
}