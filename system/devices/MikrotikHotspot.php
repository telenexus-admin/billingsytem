<?php

/**
 *  PHP Mikrotik Billing (https://github.com/hotspotbilling/phpnuxbill/)
 *  by https://t.me/ibnux
 *
 * This is Core, don't modification except you want to contribute
 * better create new plugin
 **/

use PEAR2\Net\RouterOS;

class MikrotikHotspot
{

    // show Description
    function description()
    {
        return [
            'title' => 'Mikrotik Hotspot',
            'description' => 'To handle connection between PHPNuxBill with Mikrotik Hotspot',
            'author' => 'ibnux',
            'url' => [
                'Github' => 'https://github.com/hotspotbilling/phpnuxbill/',
                'Telegram' => 'https://t.me/phpnuxbill',
                'Donate' => 'https://paypal.me/ibnux'
            ]
        ];
    }


    function add_customer($customer, $plan)
    {
        $mikrotik = $this->info($plan['routers']);
        $client = $this->getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);
        $this->removeHotspotUser($client, $customer['username']);
        // Always remove active session/cookie so new profile is applied immediately.
        $this->removeHotspotActiveUser($client, $customer['username']);
        $this->addHotspotUser($client, $plan, $customer);
    }
	
	function sync_customer($customer, $plan)
	{
		$mikrotik = $this->info($plan['routers']);
		$client = $this->getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);
		$t = ORM::for_table('tbl_user_recharges')->where('username', $customer['username'])->where('status', 'on')->find_one();
		if ($t) {
			$printRequest = new RouterOS\Request('/ip/hotspot/user/print');
			$printRequest->setArgument('.proplist', '.id,limit-uptime,limit-bytes-total');
			$printRequest->setQuery(RouterOS\Query::where('name', $customer['username']));
			$userInfo = $client->sendSync($printRequest);
			$id = $userInfo->getProperty('.id');
			$uptime = $userInfo->getProperty('limit-uptime');
			$data = $userInfo->getProperty('limit-bytes-total');
			if (!empty($id) && (!empty($uptime) || !empty($data))) {
				$setRequest = new RouterOS\Request('/ip/hotspot/user/set');
				$setRequest->setArgument('numbers', $id);
				$setRequest->setArgument('profile', $t['namebp']);
				$client->sendSync($setRequest);
                // Force re-auth so customer session gets the updated purchased profile.
                $this->removeHotspotActiveUser($client, $customer['username']);
			} else {
				$this->add_customer($customer, $plan);
			}
		}
	}


    function remove_customer($customer, $plan)
    {
        $mikrotik = $this->info($plan['routers']);
        $client = $this->getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);
        if (!empty($plan['plan_expired'])) {
            $p = ORM::for_table("tbl_plans")->find_one($plan['plan_expired']);
            if($p){
                $this->add_customer($customer, $p);
                $this->removeHotspotActiveUser($client, $customer['username']);
                return;
            }
        }
        $this->removeHotspotUser($client, $customer['username']);
        $this->removeHotspotActiveUser($client, $customer['username']);
    }

    // customer change username
    public function change_username($plan, $from, $to)
    {
        $mikrotik = $this->info($plan['routers']);
        $client = $this->getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);
        //check if customer exists
        $printRequest = new RouterOS\Request('/ip/hotspot/user/print');
        $printRequest->setArgument('.proplist', '.id');
        $printRequest->setQuery(RouterOS\Query::where('name', $from));
        $id = $client->sendSync($printRequest)->getProperty('.id');

        if (!empty($id)) {
            $setRequest = new RouterOS\Request('/ip/hotspot/user/set');
            $setRequest->setArgument('numbers', $id);
            $setRequest->setArgument('name', $to);
            $client->sendSync($setRequest);
            //disconnect then
            $this->removeHotspotActiveUser($client, $from);
        }
    }

    function add_plan($plan)
    {
        $mikrotik = $this->info($plan['routers']);
        $client = $this->getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);
        $bw = ORM::for_table("tbl_bandwidth")->find_one($plan['id_bw']);
        if ($bw['rate_down_unit'] == 'Kbps') {
            $unitdown = 'K';
        } else {
            $unitdown = 'M';
        }
        if ($bw['rate_up_unit'] == 'Kbps') {
            $unitup = 'K';
        } else {
            $unitup = 'M';
        }
        $rate = $bw['rate_up'] . $unitup . "/" . $bw['rate_down'] . $unitdown;
        if (!empty(trim($bw['burst']))) {
            $rate .= ' ' . $bw['burst'];
        }
		if ($bw['rate_up'] == '0' || $bw['rate_down'] == '0') {
			$rate = '';
		}
        $addRequest = new RouterOS\Request('/ip/hotspot/user/profile/add');
        $client->sendSync(
            $addRequest
                ->setArgument('name', $plan['name_plan'])
                ->setArgument('shared-users', $plan['shared_users'])
                ->setArgument('rate-limit', $rate)
                ->setArgument('keepalive-timeout', '100')
                ->setArgument('status-autorefresh', '1m')
        );
    }

    function online_customer($customer, $router_name)
    {
        $mikrotik = $this->info($router_name);
        $client = $this->getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);
        $printRequest = new RouterOS\Request(
            '/ip hotspot active print',
            RouterOS\Query::where('user', $customer['username'])
        );
        $id =  $client->sendSync($printRequest)->getProperty('.id');
        return $id;
    }

    function connect_customer($customer, $ip, $mac_address, $router_name)
    {
        $mikrotik = $this->info($router_name);
        $client = $this->getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);
        $addRequest = new RouterOS\Request('/ip/hotspot/active/login');
        $client->sendSync(
            $addRequest
                ->setArgument('user', $customer['username'])
                ->setArgument('password', $customer['password'])
                ->setArgument('ip', $ip)
                ->setArgument('mac-address', $mac_address)
        );
    }

    function disconnect_customer($customer, $router_name)
    {
        $mikrotik = $this->info($router_name);
        $client = $this->getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);
        $printRequest = new RouterOS\Request(
            '/ip hotspot active print',
            RouterOS\Query::where('user', $customer['username'])
        );
        $id = $client->sendSync($printRequest)->getProperty('.id');
        $removeRequest = new RouterOS\Request('/ip/hotspot/active/remove');
        $client->sendSync(
            $removeRequest
                ->setArgument('numbers', $id)
        );
    }


    function update_plan($old_plan, $new_plan)
    {
        $mikrotik = $this->info($new_plan['routers']);
        $client = $this->getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);

        $printRequest = new RouterOS\Request(
            '/ip hotspot user profile print .proplist=.id',
            RouterOS\Query::where('name', $old_plan['name_plan'])
        );
        $profileID = $client->sendSync($printRequest)->getProperty('.id');
        if (empty($profileID)) {
            $this->add_plan($new_plan);
        } else {
            $bw = ORM::for_table("tbl_bandwidth")->find_one($new_plan['id_bw']);
            if ($bw['rate_down_unit'] == 'Kbps') {
                $unitdown = 'K';
            } else {
                $unitdown = 'M';
            }
            if ($bw['rate_up_unit'] == 'Kbps') {
                $unitup = 'K';
            } else {
                $unitup = 'M';
            }
            $rate = $bw['rate_up'] . $unitup . "/" . $bw['rate_down'] . $unitdown;
            if (!empty(trim($bw['burst']))) {
                $rate .= ' ' . $bw['burst'];
            }
			if ($bw['rate_up'] == '0' || $bw['rate_down'] == '0') {
				$rate = '';
			}
            $setRequest = new RouterOS\Request('/ip/hotspot/user/profile/set');
            $client->sendSync(
                $setRequest
                    ->setArgument('numbers', $profileID)
                    ->setArgument('name', $new_plan['name_plan'])
                    ->setArgument('shared-users', $new_plan['shared_users'])
                    ->setArgument('rate-limit', $rate)
                    ->setArgument('on-login', $new_plan['on_login'])
                    ->setArgument('on-logout', $new_plan['on_logout'])
            );
        }
    }

    function remove_plan($plan)
    {
        $mikrotik = $this->info($plan['routers']);
        $client = $this->getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);
        $printRequest = new RouterOS\Request(
            '/ip hotspot user profile print .proplist=.id',
            RouterOS\Query::where('name', $plan['name_plan'])
        );
        $profileID = $client->sendSync($printRequest)->getProperty('.id');
        $removeRequest = new RouterOS\Request('/ip/hotspot/user/profile/remove');
        $client->sendSync(
            $removeRequest
                ->setArgument('numbers', $profileID)
        );
    }

    function info($name)
    {
        return ORM::for_table('tbl_routers')->where('name', $name)->find_one();
    }

    function getClient($ip, $user, $pass)
    {
        global $_app_stage;
        if ($_app_stage == 'Demo') {
            return null;
        }
        $iport = explode(":", $ip);
        return new RouterOS\Client($iport[0], $user, $pass, ($iport[1]) ? $iport[1] : null);
    }

    function removeHotspotUser($client, $username)
    {
        global $_app_stage;
        if ($_app_stage == 'Demo') {
            return null;
        }
        $printRequest = new RouterOS\Request(
            '/ip hotspot user print .proplist=.id',
            RouterOS\Query::where('name', $username)
        );
        $userID = $client->sendSync($printRequest)->getProperty('.id');
        $removeRequest = new RouterOS\Request('/ip/hotspot/user/remove');
        $client->sendSync(
            $removeRequest
                ->setArgument('numbers', $userID)
        );
    }

    function addHotspotUser($client, $plan, $customer)
    {
        global $_app_stage;
        if ($_app_stage == 'Demo') {
            return null;
        }
        $addRequest = new RouterOS\Request('/ip/hotspot/user/add');
        if ($plan['typebp'] == "Limited") {
            if ($plan['limit_type'] == "Time_Limit") {
                if ($plan['time_unit'] == 'Hrs')
                    $timelimit = $plan['time_limit'] . ":00:00";
                else
                    $timelimit = "00:" . $plan['time_limit'] . ":00";
                $client->sendSync(
                    $addRequest
                        ->setArgument('name', $customer['username'])
                        ->setArgument('profile', $plan['name_plan'])
                        ->setArgument('password', $customer['password'])
                        ->setArgument('comment', $customer['fullname'] . ' | ' . implode(', ', User::getBillNames($customer['id'])))
                        ->setArgument('email', $customer['email'])
                        ->setArgument('limit-uptime', $timelimit)
                );
            } else if ($plan['limit_type'] == "Data_Limit") {
                if ($plan['data_unit'] == 'GB')
                    $datalimit = $plan['data_limit'] . "000000000";
                else
                    $datalimit = $plan['data_limit'] . "000000";
                $client->sendSync(
                    $addRequest
                        ->setArgument('name', $customer['username'])
                        ->setArgument('profile', $plan['name_plan'])
                        ->setArgument('password', $customer['password'])
                        ->setArgument('comment', $customer['fullname'] . ' | ' . implode(', ', User::getBillNames($customer['id'])))
                        ->setArgument('email', $customer['email'])
                        ->setArgument('limit-bytes-total', $datalimit)
                );
            } else if ($plan['limit_type'] == "Both_Limit") {
                if ($plan['time_unit'] == 'Hrs')
                    $timelimit = $plan['time_limit'] . ":00:00";
                else
                    $timelimit = "00:" . $plan['time_limit'] . ":00";
                if ($plan['data_unit'] == 'GB')
                    $datalimit = $plan['data_limit'] . "000000000";
                else
                    $datalimit = $plan['data_limit'] . "000000";
                $client->sendSync(
                    $addRequest
                        ->setArgument('name', $customer['username'])
                        ->setArgument('profile', $plan['name_plan'])
                        ->setArgument('password', $customer['password'])
                        ->setArgument('comment', $customer['fullname'] . ' | ' . implode(', ', User::getBillNames($customer['id'])))
                        ->setArgument('email', $customer['email'])
                        ->setArgument('limit-uptime', $timelimit)
                        ->setArgument('limit-bytes-total', $datalimit)
                );
            }
        } else {
            $client->sendSync(
                $addRequest
                    ->setArgument('name', $customer['username'])
                    ->setArgument('profile', $plan['name_plan'])
                    ->setArgument('comment', $customer['fullname'] . ' | ' . implode(', ', User::getBillNames($customer['id'])))
                    ->setArgument('email', $customer['email'])
                    ->setArgument('password', $customer['password'])
            );
        }
    }

    function setHotspotUser($client, $user, $pass)
    {
        global $_app_stage;
        if ($_app_stage == 'Demo') {
            return null;
        }
        $printRequest = new RouterOS\Request('/ip/hotspot/user/print');
        $printRequest->setArgument('.proplist', '.id');
        $printRequest->setQuery(RouterOS\Query::where('name', $user));
        $id = $client->sendSync($printRequest)->getProperty('.id');

        $setRequest = new RouterOS\Request('/ip/hotspot/user/set');
        $setRequest->setArgument('numbers', $id);
        $setRequest->setArgument('password', $pass);
        $client->sendSync($setRequest);
    }

    function setHotspotUserPackage($client, $username, $plan_name)
    {
        global $_app_stage;
        if ($_app_stage == 'Demo') {
            return null;
        }
        $printRequest = new RouterOS\Request('/ip/hotspot/user/print');
        $printRequest->setArgument('.proplist', '.id');
        $printRequest->setQuery(RouterOS\Query::where('name', $username));
        $id = $client->sendSync($printRequest)->getProperty('.id');

        $setRequest = new RouterOS\Request('/ip/hotspot/user/set');
        $setRequest->setArgument('numbers', $id);
        $setRequest->setArgument('profile', $plan_name);
        $client->sendSync($setRequest);
    }

    function removeHotspotActiveUser($client, $username)
    {
        global $_app_stage;
        if ($_app_stage == 'Demo') {
            return null;
        }

        // Step 1 — Remove all active sessions.
        $onlineRequest = new RouterOS\Request('/ip/hotspot/active/print');
        $onlineRequest->setArgument('.proplist', '.id');
        $onlineRequest->setQuery(RouterOS\Query::where('user', $username));
        $activeUsers = $client->sendSync($onlineRequest);
        foreach ($activeUsers as $activeUser) {
            $id = $activeUser->getProperty('.id');
            if (!empty($id)) {
                $removeRequest = new RouterOS\Request('/ip/hotspot/active/remove');
                $removeRequest->setArgument('numbers', $id);
                $client->sendSync($removeRequest);
            }
        }

        // Step 2 — Collect MAC + IP from host entries, then remove them.
        // We collect before removing so we can clean ARP + DHCP lease after.
        $hostRequest = new RouterOS\Request('/ip/hotspot/host/print');
        $hostRequest->setArgument('.proplist', '.id,mac-address,address');
        $hostRequest->setQuery(RouterOS\Query::where('user', $username));
        $hosts      = $client->sendSync($hostRequest);
        $clientMacs = [];
        foreach ($hosts as $host) {
            $hostId = $host->getProperty('.id');
            $mac    = (string) $host->getProperty('mac-address');
            if (!empty($hostId)) {
                $removeHost = new RouterOS\Request('/ip/hotspot/host/remove');
                $removeHost->setArgument('numbers', $hostId);
                $client->sendSync($removeHost);
            }
            if (!empty($mac)) {
                $clientMacs[] = $mac;
            }
        }

        // Step 3 — Remove hotspot cookies.
        $cookieRequest = new RouterOS\Request('/ip/hotspot/cookie/print');
        $cookieRequest->setArgument('.proplist', '.id');
        $cookieRequest->setQuery(RouterOS\Query::where('user', $username));
        $cookies = $client->sendSync($cookieRequest);
        foreach ($cookies as $cookie) {
            $cookieId = $cookie->getProperty('.id');
            if (!empty($cookieId)) {
                $removeCookie = new RouterOS\Request('/ip/hotspot/cookie/remove');
                $removeCookie->setArgument('numbers', $cookieId);
                $client->sendSync($removeCookie);
            }
        }

        // Step 4 — Remove ARP entry + DHCP lease for each client MAC.
        // This forces the device to renew its IP address, which triggers the
        // OS-level captive portal detection ("Sign in to network" prompt)
        // on Android, iOS, and Windows — even for HTTPS-only devices.
        foreach ($clientMacs as $mac) {
            // Remove ARP entry
            $arpPrint = new RouterOS\Request('/ip/arp/print');
            $arpPrint->setArgument('.proplist', '.id');
            $arpPrint->setQuery(RouterOS\Query::where('mac-address', $mac));
            $arpResponses = $client->sendSync($arpPrint);
            foreach ($arpResponses as $arpEntry) {
                $arpId = $arpEntry->getProperty('.id');
                if (!empty($arpId)) {
                    $arpRemove = new RouterOS\Request('/ip/arp/remove');
                    $arpRemove->setArgument('numbers', $arpId);
                    $client->sendSync($arpRemove);
                }
            }

            // Remove DHCP lease so device requests a fresh IP on next connection
            $leasePrint = new RouterOS\Request('/ip/dhcp-server/lease/print');
            $leasePrint->setArgument('.proplist', '.id');
            $leasePrint->setQuery(RouterOS\Query::where('mac-address', $mac));
            $leaseResponses = $client->sendSync($leasePrint);
            foreach ($leaseResponses as $lease) {
                $leaseId = $lease->getProperty('.id');
                if (!empty($leaseId)) {
                    $leaseRemove = new RouterOS\Request('/ip/dhcp-server/lease/remove');
                    $leaseRemove->setArgument('numbers', $leaseId);
                    $client->sendSync($leaseRemove);
                }
            }
        }
    }

    function getIpHotspotUser($client, $username)
    {
        global $_app_stage;
        if ($_app_stage == 'Demo') {
            return null;
        }
        $printRequest = new RouterOS\Request(
            '/ip hotspot active print',
            RouterOS\Query::where('user', $username)
        );
        return $client->sendSync($printRequest)->getProperty('address');
    }
}
