-- phpMyAdmin SQL Dump
-- version 5.1.1deb5ubuntu1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Sep 29, 2025 at 10:59 AM
-- Server version: 10.6.22-MariaDB-0ubuntu0.22.04.1
-- PHP Version: 8.2.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `loy`
--

-- --------------------------------------------------------

--
-- Table structure for table `nas`
--

CREATE TABLE `nas` (
  `id` int(11) NOT NULL,
  `nasname` varchar(128) NOT NULL,
  `shortname` varchar(32) DEFAULT NULL,
  `type` varchar(30) DEFAULT 'other',
  `ports` int(11) DEFAULT NULL,
  `secret` varchar(60) NOT NULL DEFAULT 'secret',
  `server` varchar(64) DEFAULT NULL,
  `community` varchar(50) DEFAULT NULL,
  `description` varchar(200) DEFAULT 'RADIUS Client',
  `routers` varchar(32) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nasreload`
--

CREATE TABLE `nasreload` (
  `nasipaddress` varchar(15) NOT NULL,
  `reloadtime` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `radacct`
--

CREATE TABLE `radacct` (
  `radacctid` bigint(20) NOT NULL,
  `acctsessionid` varchar(64) NOT NULL DEFAULT '',
  `acctuniqueid` varchar(32) NOT NULL DEFAULT '',
  `username` varchar(64) NOT NULL DEFAULT '',
  `realm` varchar(64) DEFAULT '',
  `nasipaddress` varchar(15) NOT NULL DEFAULT '',
  `nasportid` varchar(32) DEFAULT NULL,
  `nasporttype` varchar(32) DEFAULT NULL,
  `acctstarttime` datetime DEFAULT NULL,
  `acctupdatetime` datetime DEFAULT NULL,
  `acctstoptime` datetime DEFAULT NULL,
  `acctinterval` int(11) DEFAULT NULL,
  `acctsessiontime` int(10) UNSIGNED DEFAULT NULL,
  `acctauthentic` varchar(32) DEFAULT NULL,
  `connectinfo_start` varchar(128) DEFAULT NULL,
  `connectinfo_stop` varchar(128) DEFAULT NULL,
  `acctinputoctets` bigint(20) DEFAULT NULL,
  `acctoutputoctets` bigint(20) DEFAULT NULL,
  `calledstationid` varchar(50) NOT NULL DEFAULT '',
  `callingstationid` varchar(50) NOT NULL DEFAULT '',
  `acctterminatecause` varchar(32) NOT NULL DEFAULT '',
  `servicetype` varchar(32) DEFAULT NULL,
  `framedprotocol` varchar(32) DEFAULT NULL,
  `framedipaddress` varchar(15) NOT NULL DEFAULT '',
  `framedipv6address` varchar(45) NOT NULL DEFAULT '',
  `framedipv6prefix` varchar(45) NOT NULL DEFAULT '',
  `framedinterfaceid` varchar(44) NOT NULL DEFAULT '',
  `delegatedipv6prefix` varchar(45) NOT NULL DEFAULT '',
  `class` varchar(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `radcheck`
--

CREATE TABLE `radcheck` (
  `id` int(10) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `attribute` varchar(64) NOT NULL DEFAULT '',
  `op` char(2) NOT NULL DEFAULT '==',
  `value` varchar(253) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `radgroupcheck`
--

CREATE TABLE `radgroupcheck` (
  `id` int(10) UNSIGNED NOT NULL,
  `groupname` varchar(64) NOT NULL DEFAULT '',
  `attribute` varchar(64) NOT NULL DEFAULT '',
  `op` char(2) NOT NULL DEFAULT '==',
  `value` varchar(253) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `radgroupreply`
--

CREATE TABLE `radgroupreply` (
  `id` int(10) UNSIGNED NOT NULL,
  `groupname` varchar(64) NOT NULL DEFAULT '',
  `attribute` varchar(64) NOT NULL DEFAULT '',
  `op` char(2) NOT NULL DEFAULT '=',
  `value` varchar(253) NOT NULL DEFAULT '',
  `plan_id` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `radius_daily_history`
--

CREATE TABLE `radius_daily_history` (
  `id` int(11) NOT NULL,
  `username` varchar(64) NOT NULL,
  `date` date NOT NULL,
  `download_bytes` bigint(20) NOT NULL DEFAULT 0,
  `upload_bytes` bigint(20) NOT NULL DEFAULT 0,
  `total_bytes` bigint(20) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `radius_monthly_history`
--

CREATE TABLE `radius_monthly_history` (
  `id` int(11) NOT NULL,
  `username` varchar(64) NOT NULL,
  `year` int(4) NOT NULL,
  `month` int(2) NOT NULL,
  `download_bytes` bigint(20) NOT NULL DEFAULT 0,
  `upload_bytes` bigint(20) NOT NULL DEFAULT 0,
  `total_bytes` bigint(20) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `radpostauth`
--

CREATE TABLE `radpostauth` (
  `id` int(11) NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `pass` varchar(64) NOT NULL DEFAULT '',
  `reply` varchar(32) NOT NULL DEFAULT '',
  `authdate` timestamp(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `class` varchar(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `radreply`
--

CREATE TABLE `radreply` (
  `id` int(10) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `attribute` varchar(64) NOT NULL DEFAULT '',
  `op` char(2) NOT NULL DEFAULT '=',
  `value` varchar(253) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `radusergroup`
--

CREATE TABLE `radusergroup` (
  `id` int(10) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `groupname` varchar(64) NOT NULL DEFAULT '',
  `priority` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `rad_acct`
--

CREATE TABLE `rad_acct` (
  `id` bigint(20) NOT NULL,
  `acctsessionid` varchar(64) NOT NULL DEFAULT '',
  `username` varchar(64) NOT NULL DEFAULT '',
  `realm` varchar(128) NOT NULL DEFAULT '',
  `nasid` varchar(32) NOT NULL DEFAULT '',
  `nasipaddress` varchar(15) NOT NULL DEFAULT '',
  `nasportid` varchar(32) DEFAULT NULL,
  `nasporttype` varchar(32) DEFAULT NULL,
  `framedipaddress` varchar(15) NOT NULL DEFAULT '',
  `acctsessiontime` bigint(20) NOT NULL DEFAULT 0,
  `acctinputoctets` bigint(20) NOT NULL DEFAULT 0,
  `acctoutputoctets` bigint(20) NOT NULL DEFAULT 0,
  `acctstatustype` varchar(32) DEFAULT NULL,
  `macaddr` varchar(50) NOT NULL,
  `dateAdded` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_appconfig`
--

CREATE TABLE `tbl_appconfig` (
  `id` int(11) NOT NULL,
  `setting` mediumtext NOT NULL,
  `value` mediumtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_appconfig`
--

INSERT INTO `tbl_appconfig` (`id`, `setting`, `value`) VALUES
(1, 'currency_code', 'Ksh.'),
(2, 'language', 'english'),
(3, 'show-logo', '1'),
(4, 'nstyle', 'blue'),
(5, 'timezone', 'Africa/Nairobi'),
(6, 'dec_point', '.'),
(7, 'thousands_sep', ','),
(8, 'rtl', '0'),
(9, 'address', ''),
(10, 'date_format', 'd M Y'),
(11, 'note', 'Thank you...'),
(12, 'CompanyFooter', ''),
(13, 'printer_cols', '37'),
(14, 'theme', 'default'),
(15, 'payment_usings', ''),
(16, 'reset_day', '1'),
(17, 'dashboard_cr', ''),
(18, 'url_canonical', 'no'),
(19, 'enable_coupons', 'no'),
(20, 'disable_registration', 'noreg'),
(21, 'registration_username', 'username'),
(22, 'photo_register', 'no'),
(23, 'sms_otp_registration', 'no'),
(24, 'phone_otp_type', 'sms'),
(25, 'reg_nofify_admin', 'no'),
(26, 'man_fields_email', 'no'),
(27, 'man_fields_fname', 'no'),
(28, 'man_fields_address', 'no'),
(29, 'single_session', 'no'),
(30, 'csrf_enabled', 'no'),
(31, 'disable_voucher', 'no'),
(32, 'voucher_format', 'rand'),
(33, 'radius_enable', '1'),
(34, 'country_code_phone', '254'),
(35, 'radius_plan', 'Radius Plan'),
(36, 'hotspot_plan', 'Hotspot Plan'),
(37, 'pppoe_plan', 'PPPOE Plan'),
(38, 'new_version_notify', 'enable'),
(39, 'router_check', '1'),
(40, 'show_bandwidth_plan', 'yes'),
(41, 'hs_auth_method', 'api'),
(42, 'check_customer_online', 'yes'),
(43, 'save', 'save'),
(44, 'auto_manual_display', 'auto'),
(45, 'whatsapp_country_code_phone', '254'),
(46, 'faq1', 'Click on your preferred package'),
(47, 'faq2', 'Enter your M-Pesa number'),
(48, 'faq3', 'Enter PIN and wait to connect'),
(49, 'plm_enabled', '1'),
(50, 'plm_timeout_minutes', '5'),
(51, 'plm_max_failures', '3'),
(52, 'plm_alert_interval_minutes', '15'),
(53, 'plm_cleanup_days', '30'),
(54, 'plm_telegram_alerts', '1'),
(55, 'localization', ''),
(56, 'system_start_date', '2025-09-29 13:25:01'),
(57, 'number_format', '1234.56'),
(59, 'CompanyName', 'Rayprotech');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_bandwidth`
--

CREATE TABLE `tbl_bandwidth` (
  `id` int(10) UNSIGNED NOT NULL,
  `name_bw` varchar(255) NOT NULL,
  `rate_down` int(10) UNSIGNED NOT NULL,
  `rate_down_unit` enum('Kbps','Mbps') NOT NULL,
  `rate_up` int(10) UNSIGNED NOT NULL,
  `rate_up_unit` enum('Kbps','Mbps') NOT NULL,
  `burst` varchar(128) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_coupons`
--

CREATE TABLE `tbl_coupons` (
  `id` int(11) NOT NULL,
  `code` varchar(50) NOT NULL,
  `type` enum('fixed','percent') NOT NULL,
  `value` decimal(10,2) NOT NULL,
  `description` text NOT NULL,
  `max_usage` int(11) NOT NULL DEFAULT 1,
  `usage_count` int(11) NOT NULL DEFAULT 0,
  `status` enum('active','inactive') NOT NULL,
  `min_order_amount` decimal(10,2) NOT NULL,
  `max_discount_amount` decimal(10,2) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_customers`
--

CREATE TABLE `tbl_customers` (
  `id` int(11) NOT NULL,
  `username` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  `photo` varchar(128) NOT NULL DEFAULT '/user.default.jpg',
  `pppoe_username` varchar(32) NOT NULL DEFAULT '' COMMENT 'For PPPOE Login',
  `pppoe_password` varchar(45) NOT NULL DEFAULT '' COMMENT 'For PPPOE Login',
  `pppoe_ip` varchar(32) NOT NULL DEFAULT '' COMMENT 'For PPPOE Login',
  `fullname` varchar(45) NOT NULL,
  `address` mediumtext DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `district` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `zip` varchar(10) DEFAULT NULL,
  `phonenumber` varchar(20) DEFAULT '0',
  `email` varchar(128) NOT NULL DEFAULT '1',
  `coordinates` varchar(50) NOT NULL DEFAULT '' COMMENT 'Latitude and Longitude coordinates',
  `account_type` enum('Business','Personal') DEFAULT 'Personal' COMMENT 'For selecting account type',
  `balance` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT 'For Money Deposit',
  `service_type` enum('Hotspot','PPPoE','VPN','Others') DEFAULT 'Others' COMMENT 'For selecting user type',
  `auto_renewal` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Auto renewall using balance',
  `router_id` varchar(64) DEFAULT NULL,
  `status` enum('Active','Banned','Disabled','Inactive','Limited','Suspended') NOT NULL DEFAULT 'Active',
  `created_by` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_login` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_customers_fields`
--

CREATE TABLE `tbl_customers_fields` (
  `id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `field_name` varchar(255) NOT NULL,
  `field_value` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_customers_inbox`
--

CREATE TABLE `tbl_customers_inbox` (
  `id` int(10) UNSIGNED NOT NULL,
  `customer_id` int(11) NOT NULL,
  `date_created` datetime NOT NULL,
  `date_read` datetime DEFAULT NULL,
  `subject` varchar(64) NOT NULL,
  `body` text DEFAULT NULL,
  `from` varchar(8) NOT NULL DEFAULT 'System' COMMENT 'System or Admin or Else',
  `admin_id` int(11) NOT NULL DEFAULT 0 COMMENT 'other than admin is 0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_logs`
--

CREATE TABLE `tbl_logs` (
  `id` int(11) NOT NULL,
  `date` datetime DEFAULT NULL,
  `type` varchar(50) NOT NULL,
  `description` mediumtext NOT NULL,
  `userid` int(11) NOT NULL,
  `ip` mediumtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_logs`
--

INSERT INTO `tbl_logs` (`id`, `date`, `type`, `description`, `userid`, `ip`) VALUES
(1, '2025-09-29 13:56:45', 'SuperAdmin', 'admin Login Successful', 1, '41.209.60.122');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_message_logs`
--

CREATE TABLE `tbl_message_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `message_type` varchar(50) DEFAULT NULL,
  `recipient` varchar(255) DEFAULT NULL,
  `message_content` text DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `error_message` text DEFAULT NULL,
  `sent_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_meta`
--

CREATE TABLE `tbl_meta` (
  `id` int(10) UNSIGNED NOT NULL,
  `tbl` varchar(32) NOT NULL COMMENT 'Table name',
  `tbl_id` int(11) NOT NULL COMMENT 'table value id',
  `name` varchar(32) NOT NULL,
  `value` mediumtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='This Table to add additional data for any table';

-- --------------------------------------------------------

--
-- Table structure for table `tbl_mpesa_transactions`
--

CREATE TABLE `tbl_mpesa_transactions` (
  `id` int(11) NOT NULL,
  `TransID` varchar(255) NOT NULL,
  `TransactionType` varchar(255) NOT NULL,
  `TransTime` varchar(255) NOT NULL,
  `TransAmount` decimal(10,2) NOT NULL,
  `BusinessShortCode` varchar(255) NOT NULL,
  `BillRefNumber` varchar(255) NOT NULL,
  `OrgAccountBalance` decimal(10,2) NOT NULL,
  `MSISDN` varchar(255) NOT NULL,
  `FirstName` varchar(255) NOT NULL,
  `CustomerID` varchar(255) NOT NULL,
  `PackageName` varchar(255) NOT NULL,
  `PackagePrice` varchar(255) NOT NULL,
  `TransactionStatus` varchar(255) NOT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_payment_gateway`
--

CREATE TABLE `tbl_payment_gateway` (
  `id` int(11) NOT NULL,
  `username` varchar(32) NOT NULL,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `gateway` varchar(32) NOT NULL COMMENT 'xendit | midtrans',
  `mac_address` varchar(255) DEFAULT NULL,
  `gateway_trx_id` varchar(512) NOT NULL DEFAULT '',
  `plan_id` int(11) NOT NULL,
  `plan_name` varchar(40) NOT NULL,
  `routers_id` int(11) NOT NULL,
  `routers` varchar(32) NOT NULL,
  `price` varchar(40) NOT NULL,
  `pg_url_payment` varchar(512) NOT NULL DEFAULT '',
  `payment_method` varchar(32) NOT NULL DEFAULT '',
  `payment_channel` varchar(32) NOT NULL DEFAULT '',
  `pg_request` text DEFAULT NULL,
  `pg_paid_response` text DEFAULT NULL,
  `expired_date` datetime DEFAULT NULL,
  `created_date` datetime NOT NULL,
  `paid_date` datetime DEFAULT NULL,
  `trx_invoice` varchar(25) NOT NULL DEFAULT '' COMMENT 'from tbl_transactions',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 unpaid 2 paid 3 failed 4 canceled',
  `checkout` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_plans`
--

CREATE TABLE `tbl_plans` (
  `id` int(11) NOT NULL,
  `name_plan` varchar(40) NOT NULL,
  `id_bw` int(11) NOT NULL,
  `price` varchar(40) NOT NULL,
  `price_old` varchar(40) NOT NULL DEFAULT '',
  `type` enum('Hotspot','PPPOE','VPN','Balance') NOT NULL,
  `typebp` enum('Unlimited','Limited') DEFAULT NULL,
  `limit_type` enum('Time_Limit','Data_Limit','Both_Limit') DEFAULT NULL,
  `time_limit` int(10) UNSIGNED DEFAULT NULL,
  `time_unit` enum('Mins','Hrs') DEFAULT NULL,
  `data_limit` int(10) UNSIGNED DEFAULT NULL,
  `data_unit` enum('MB','GB') DEFAULT NULL,
  `validity` int(11) NOT NULL,
  `validity_unit` enum('Mins','Hrs','Days','Months','Period') NOT NULL,
  `shared_users` int(11) DEFAULT NULL,
  `routers` varchar(32) NOT NULL,
  `is_radius` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1 is radius',
  `pool` varchar(40) DEFAULT NULL,
  `plan_expired` int(11) NOT NULL DEFAULT 0,
  `expired_date` tinyint(1) NOT NULL DEFAULT 20,
  `enabled` tinyint(1) NOT NULL DEFAULT 1 COMMENT '0 disabled\r\n',
  `allow_purchase` enum('yes','no') DEFAULT 'yes' COMMENT 'allow to show package in buy package page',
  `prepaid` enum('yes','no') DEFAULT 'yes' COMMENT 'is prepaid',
  `plan_type` enum('Business','Personal') DEFAULT 'Personal' COMMENT 'For selecting account type',
  `device` varchar(32) NOT NULL DEFAULT '',
  `on_login` text DEFAULT NULL,
  `on_logout` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pool`
--

CREATE TABLE `tbl_pool` (
  `id` int(11) NOT NULL,
  `pool_name` varchar(40) NOT NULL,
  `local_ip` varchar(40) NOT NULL DEFAULT '',
  `range_ip` varchar(40) NOT NULL,
  `routers` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_port_pool`
--

CREATE TABLE `tbl_port_pool` (
  `id` int(11) NOT NULL,
  `public_ip` varchar(40) NOT NULL,
  `port_name` varchar(40) NOT NULL,
  `range_port` varchar(40) NOT NULL,
  `routers` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_routers`
--

CREATE TABLE `tbl_routers` (
  `id` int(11) NOT NULL,
  `name` varchar(32) NOT NULL,
  `ip_address` varchar(128) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(60) NOT NULL,
  `description` varchar(256) DEFAULT NULL,
  `coordinates` varchar(50) NOT NULL DEFAULT '',
  `status` enum('Online','Offline') DEFAULT 'Online',
  `last_seen` datetime DEFAULT NULL,
  `coverage` varchar(8) NOT NULL DEFAULT '0',
  `enabled` tinyint(1) NOT NULL DEFAULT 1 COMMENT '0 disabled'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_sms_logs`
--

CREATE TABLE `tbl_sms_logs` (
  `id` int(11) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `message_id` varchar(255) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `status_message` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_transactions`
--

CREATE TABLE `tbl_transactions` (
  `id` int(11) NOT NULL,
  `invoice` varchar(25) NOT NULL,
  `username` varchar(32) NOT NULL,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `plan_name` varchar(40) NOT NULL,
  `price` varchar(40) NOT NULL,
  `recharged_on` date NOT NULL,
  `recharged_time` time NOT NULL DEFAULT '00:00:00',
  `expiration` date NOT NULL,
  `time` time NOT NULL,
  `method` varchar(128) NOT NULL,
  `routers` varchar(32) NOT NULL,
  `type` enum('Hotspot','PPPOE','VPN','Balance') NOT NULL,
  `note` varchar(256) NOT NULL DEFAULT '' COMMENT 'for note',
  `admin_id` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_usage_records`
--

CREATE TABLE `tbl_usage_records` (
  `id` int(11) NOT NULL,
  `router_id` int(11) NOT NULL,
  `username` varchar(64) NOT NULL,
  `interface` varchar(20) NOT NULL DEFAULT 'hotspot',
  `tx_bytes` bigint(20) DEFAULT 0,
  `rx_bytes` bigint(20) DEFAULT 0,
  `last_seen` datetime NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_usage_sessions`
--

CREATE TABLE `tbl_usage_sessions` (
  `id` int(11) NOT NULL,
  `router_id` int(11) NOT NULL,
  `username` varchar(64) NOT NULL,
  `interface` varchar(20) NOT NULL DEFAULT 'hotspot',
  `session_id` varchar(64) NOT NULL,
  `last_rx` bigint(20) DEFAULT 0,
  `last_tx` bigint(20) DEFAULT 0,
  `start_time` datetime NOT NULL,
  `last_seen` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `session_rx` bigint(20) DEFAULT 0,
  `session_tx` bigint(20) DEFAULT 0,
  `ip_address` varchar(45) DEFAULT NULL COMMENT 'User IP address',
  `mac_address` varchar(17) DEFAULT NULL COMMENT 'User MAC address',
  `connection_type` varchar(20) DEFAULT 'hotspot' COMMENT 'hotspot or pppoe',
  `uptime_seconds` int(11) DEFAULT 0 COMMENT 'Session duration in seconds'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `id` int(10) UNSIGNED NOT NULL,
  `root` int(11) NOT NULL DEFAULT 0 COMMENT 'for sub account',
  `photo` varchar(128) NOT NULL DEFAULT '/admin.default.png',
  `username` varchar(45) NOT NULL DEFAULT '',
  `fullname` varchar(45) NOT NULL DEFAULT '',
  `password` varchar(64) NOT NULL,
  `phone` varchar(32) NOT NULL DEFAULT '',
  `email` varchar(128) NOT NULL DEFAULT '',
  `city` varchar(64) NOT NULL DEFAULT '' COMMENT 'kota',
  `subdistrict` varchar(64) NOT NULL DEFAULT '' COMMENT 'kecamatan',
  `ward` varchar(64) NOT NULL DEFAULT '' COMMENT 'kelurahan',
  `user_type` enum('SuperAdmin','Admin','Report','Agent','Sales') NOT NULL,
  `status` enum('Active','Inactive') NOT NULL DEFAULT 'Active',
  `data` text DEFAULT NULL COMMENT 'to put additional data',
  `last_login` datetime DEFAULT NULL,
  `login_token` varchar(40) DEFAULT NULL,
  `creationdate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`id`, `root`, `photo`, `username`, `fullname`, `password`, `phone`, `email`, `city`, `subdistrict`, `ward`, `user_type`, `status`, `data`, `last_login`, `login_token`, `creationdate`) VALUES
(1, 0, '/admin.default.png', 'admin', 'Administrator', 'd033e22ae348aeb5660fc2140aec35850c4da997', '', '', '', '', '', 'SuperAdmin', 'Active', NULL, '2025-09-29 13:56:45', '23161ae84f140f44bd1f92a4eca7ffd6bcfc467c', '2024-04-23 01:43:07');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_user_recharges`
--

CREATE TABLE `tbl_user_recharges` (
  `id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `username` varchar(32) NOT NULL,
  `plan_id` int(11) NOT NULL,
  `namebp` varchar(40) NOT NULL,
  `recharged_on` date NOT NULL,
  `recharged_time` time NOT NULL DEFAULT '00:00:00',
  `expiration` date NOT NULL,
  `time` time NOT NULL,
  `status` varchar(20) NOT NULL,
  `method` varchar(128) NOT NULL DEFAULT '',
  `routers` varchar(32) NOT NULL,
  `type` varchar(15) NOT NULL,
  `admin_id` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_voucher`
--

CREATE TABLE `tbl_voucher` (
  `id` int(11) NOT NULL,
  `type` enum('Hotspot','PPPOE') NOT NULL,
  `routers` varchar(32) NOT NULL,
  `id_plan` int(11) NOT NULL,
  `code` varchar(55) NOT NULL,
  `user` varchar(45) NOT NULL,
  `status` varchar(25) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `used_date` datetime DEFAULT NULL,
  `generated_by` int(11) NOT NULL DEFAULT 0 COMMENT 'id admin'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_widgets`
--

CREATE TABLE `tbl_widgets` (
  `id` int(11) NOT NULL,
  `orders` int(11) NOT NULL DEFAULT 99,
  `position` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1. top 2. left 3. right 4. bottom',
  `user` enum('Admin','Agent','Sales','Customer') NOT NULL DEFAULT 'Admin',
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `title` varchar(64) NOT NULL,
  `widget` varchar(64) NOT NULL DEFAULT '',
  `content` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_widgets`
--

INSERT INTO `tbl_widgets` (`id`, `orders`, `position`, `user`, `enabled`, `title`, `widget`, `content`) VALUES
(1, 1, 1, 'Admin', 1, 'Top Widget', 'top_widget', ''),
(2, 2, 1, 'Admin', 1, 'Default Info', 'default_info_row', ''),
(3, 1, 2, 'Admin', 1, 'Graph Monthly Registered Customers', 'graph_monthly_registered_customers', ''),
(4, 2, 2, 'Admin', 1, 'Graph Monthly Sales', 'graph_monthly_sales', ''),
(5, 3, 2, 'Admin', 1, 'Voucher Stocks', 'voucher_stocks', ''),
(6, 4, 2, 'Admin', 1, 'Customer Expired', 'customer_expired', ''),
(7, 1, 3, 'Admin', 1, 'Cron Monitor', 'cron_monitor', ''),
(8, 2, 3, 'Admin', 1, 'Mikrotik Cron Monitor', 'mikrotik_cron_monitor', ''),
(9, 3, 3, 'Admin', 1, 'Info Payment Gateway', 'info_payment_gateway', ''),
(10, 4, 3, 'Admin', 1, 'Graph Customers Insight', 'graph_customers_insight', ''),
(11, 5, 3, 'Admin', 1, 'Activity Log', 'activity_log', ''),
(30, 1, 1, 'Agent', 1, 'Top Widget', 'top_widget', ''),
(31, 2, 1, 'Agent', 1, 'Default Info', 'default_info_row', ''),
(32, 1, 2, 'Agent', 1, 'Graph Monthly Registered Customers', 'graph_monthly_registered_customers', ''),
(33, 2, 2, 'Agent', 1, 'Graph Monthly Sales', 'graph_monthly_sales', ''),
(34, 3, 2, 'Agent', 1, 'Voucher Stocks', 'voucher_stocks', ''),
(35, 4, 2, 'Agent', 1, 'Customer Expired', 'customer_expired', ''),
(36, 1, 3, 'Agent', 1, 'Cron Monitor', 'cron_monitor', ''),
(37, 2, 3, 'Agent', 1, 'Mikrotik Cron Monitor', 'mikrotik_cron_monitor', ''),
(38, 3, 3, 'Agent', 1, 'Info Payment Gateway', 'info_payment_gateway', ''),
(39, 4, 3, 'Agent', 1, 'Graph Customers Insight', 'graph_customers_insight', ''),
(40, 5, 3, 'Agent', 1, 'Activity Log', 'activity_log', ''),
(41, 1, 1, 'Sales', 1, 'Top Widget', 'top_widget', ''),
(42, 2, 1, 'Sales', 1, 'Default Info', 'default_info_row', ''),
(43, 1, 2, 'Sales', 1, 'Graph Monthly Registered Customers', 'graph_monthly_registered_customers', ''),
(44, 2, 2, 'Sales', 1, 'Graph Monthly Sales', 'graph_monthly_sales', ''),
(45, 3, 2, 'Sales', 1, 'Voucher Stocks', 'voucher_stocks', ''),
(46, 4, 2, 'Sales', 1, 'Customer Expired', 'customer_expired', ''),
(47, 1, 3, 'Sales', 1, 'Cron Monitor', 'cron_monitor', ''),
(48, 2, 3, 'Sales', 1, 'Mikrotik Cron Monitor', 'mikrotik_cron_monitor', ''),
(49, 3, 3, 'Sales', 1, 'Info Payment Gateway', 'info_payment_gateway', ''),
(50, 4, 3, 'Sales', 1, 'Graph Customers Insight', 'graph_customers_insight', ''),
(51, 5, 3, 'Sales', 1, 'Activity Log', 'activity_log', ''),
(60, 1, 2, 'Customer', 1, 'Account Info', 'account_info', ''),
(61, 3, 1, 'Customer', 1, 'Active Internet Plan', 'active_internet_plan', ''),
(62, 4, 1, 'Customer', 1, 'Balance Transfer', 'balance_transfer', ''),
(63, 1, 1, 'Customer', 1, 'Unpaid Order', 'unpaid_order', ''),
(64, 2, 1, 'Customer', 1, 'Announcement', 'announcement', ''),
(65, 5, 1, 'Customer', 1, 'Recharge A Friend', 'recharge_a_friend', ''),
(66, 2, 2, 'Customer', 1, 'Voucher Activation', 'voucher_activation', '');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `nas`
--
ALTER TABLE `nas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `nasname` (`nasname`);

--
-- Indexes for table `nasreload`
--
ALTER TABLE `nasreload`
  ADD PRIMARY KEY (`nasipaddress`);

--
-- Indexes for table `radacct`
--
ALTER TABLE `radacct`
  ADD PRIMARY KEY (`radacctid`),
  ADD UNIQUE KEY `acctuniqueid` (`acctuniqueid`),
  ADD KEY `username` (`username`),
  ADD KEY `framedipaddress` (`framedipaddress`),
  ADD KEY `framedipv6address` (`framedipv6address`),
  ADD KEY `framedipv6prefix` (`framedipv6prefix`),
  ADD KEY `framedinterfaceid` (`framedinterfaceid`),
  ADD KEY `delegatedipv6prefix` (`delegatedipv6prefix`),
  ADD KEY `acctsessionid` (`acctsessionid`),
  ADD KEY `acctsessiontime` (`acctsessiontime`),
  ADD KEY `acctstarttime` (`acctstarttime`),
  ADD KEY `acctinterval` (`acctinterval`),
  ADD KEY `acctstoptime` (`acctstoptime`),
  ADD KEY `nasipaddress` (`nasipaddress`),
  ADD KEY `class` (`class`);

--
-- Indexes for table `radcheck`
--
ALTER TABLE `radcheck`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`(32));

--
-- Indexes for table `radgroupcheck`
--
ALTER TABLE `radgroupcheck`
  ADD PRIMARY KEY (`id`),
  ADD KEY `groupname` (`groupname`(32));

--
-- Indexes for table `radgroupreply`
--
ALTER TABLE `radgroupreply`
  ADD PRIMARY KEY (`id`),
  ADD KEY `groupname` (`groupname`(32));

--
-- Indexes for table `radius_daily_history`
--
ALTER TABLE `radius_daily_history`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_date` (`username`,`date`),
  ADD KEY `idx_username` (`username`),
  ADD KEY `idx_date` (`date`);

--
-- Indexes for table `radius_monthly_history`
--
ALTER TABLE `radius_monthly_history`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_month` (`username`,`year`,`month`),
  ADD KEY `idx_username` (`username`),
  ADD KEY `idx_year_month` (`year`,`month`);

--
-- Indexes for table `radpostauth`
--
ALTER TABLE `radpostauth`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`),
  ADD KEY `class` (`class`);

--
-- Indexes for table `radreply`
--
ALTER TABLE `radreply`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`(32));

--
-- Indexes for table `radusergroup`
--
ALTER TABLE `radusergroup`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`(32));

--
-- Indexes for table `rad_acct`
--
ALTER TABLE `rad_acct`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`),
  ADD KEY `framedipaddress` (`framedipaddress`),
  ADD KEY `acctsessionid` (`acctsessionid`),
  ADD KEY `nasipaddress` (`nasipaddress`);

--
-- Indexes for table `tbl_appconfig`
--
ALTER TABLE `tbl_appconfig`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_bandwidth`
--
ALTER TABLE `tbl_bandwidth`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_coupons`
--
ALTER TABLE `tbl_coupons`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Indexes for table `tbl_customers`
--
ALTER TABLE `tbl_customers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_customers_fields`
--
ALTER TABLE `tbl_customers_fields`
  ADD PRIMARY KEY (`id`),
  ADD KEY `customer_id` (`customer_id`);

--
-- Indexes for table `tbl_customers_inbox`
--
ALTER TABLE `tbl_customers_inbox`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_logs`
--
ALTER TABLE `tbl_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_message_logs`
--
ALTER TABLE `tbl_message_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_meta`
--
ALTER TABLE `tbl_meta`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_mpesa_transactions`
--
ALTER TABLE `tbl_mpesa_transactions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_payment_gateway`
--
ALTER TABLE `tbl_payment_gateway`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_plans`
--
ALTER TABLE `tbl_plans`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_pool`
--
ALTER TABLE `tbl_pool`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_port_pool`
--
ALTER TABLE `tbl_port_pool`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_routers`
--
ALTER TABLE `tbl_routers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_sms_logs`
--
ALTER TABLE `tbl_sms_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_transactions`
--
ALTER TABLE `tbl_transactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `invoice` (`invoice`);

--
-- Indexes for table `tbl_usage_records`
--
ALTER TABLE `tbl_usage_records`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_router` (`router_id`,`username`,`interface`),
  ADD KEY `idx_username` (`username`),
  ADD KEY `idx_last_seen` (`last_seen`),
  ADD KEY `idx_router` (`router_id`);

--
-- Indexes for table `tbl_usage_sessions`
--
ALTER TABLE `tbl_usage_sessions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_session` (`router_id`,`username`,`session_id`),
  ADD KEY `idx_router_username` (`router_id`,`username`),
  ADD KEY `idx_last_seen` (`last_seen`),
  ADD KEY `idx_online_status` (`username`,`last_seen`),
  ADD KEY `idx_ip_address` (`ip_address`),
  ADD KEY `idx_mac_address` (`mac_address`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_user_recharges`
--
ALTER TABLE `tbl_user_recharges`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_voucher`
--
ALTER TABLE `tbl_voucher`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_widgets`
--
ALTER TABLE `tbl_widgets`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `nas`
--
ALTER TABLE `nas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `radacct`
--
ALTER TABLE `radacct`
  MODIFY `radacctid` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `radcheck`
--
ALTER TABLE `radcheck`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `radgroupcheck`
--
ALTER TABLE `radgroupcheck`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `radgroupreply`
--
ALTER TABLE `radgroupreply`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `radius_daily_history`
--
ALTER TABLE `radius_daily_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `radius_monthly_history`
--
ALTER TABLE `radius_monthly_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `radpostauth`
--
ALTER TABLE `radpostauth`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `radreply`
--
ALTER TABLE `radreply`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `radusergroup`
--
ALTER TABLE `radusergroup`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `rad_acct`
--
ALTER TABLE `rad_acct`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_appconfig`
--
ALTER TABLE `tbl_appconfig`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=117;

--
-- AUTO_INCREMENT for table `tbl_bandwidth`
--
ALTER TABLE `tbl_bandwidth`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_coupons`
--
ALTER TABLE `tbl_coupons`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_customers`
--
ALTER TABLE `tbl_customers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_customers_fields`
--
ALTER TABLE `tbl_customers_fields`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_customers_inbox`
--
ALTER TABLE `tbl_customers_inbox`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_logs`
--
ALTER TABLE `tbl_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tbl_message_logs`
--
ALTER TABLE `tbl_message_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_meta`
--
ALTER TABLE `tbl_meta`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_mpesa_transactions`
--
ALTER TABLE `tbl_mpesa_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_payment_gateway`
--
ALTER TABLE `tbl_payment_gateway`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_plans`
--
ALTER TABLE `tbl_plans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_pool`
--
ALTER TABLE `tbl_pool`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_port_pool`
--
ALTER TABLE `tbl_port_pool`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_routers`
--
ALTER TABLE `tbl_routers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_sms_logs`
--
ALTER TABLE `tbl_sms_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_transactions`
--
ALTER TABLE `tbl_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_usage_records`
--
ALTER TABLE `tbl_usage_records`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_usage_sessions`
--
ALTER TABLE `tbl_usage_sessions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tbl_user_recharges`
--
ALTER TABLE `tbl_user_recharges`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_voucher`
--
ALTER TABLE `tbl_voucher`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_widgets`
--
ALTER TABLE `tbl_widgets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
