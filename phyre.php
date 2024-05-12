<?php

include_once __DIR__ . '/src/PhyreApi.php';

function phyre_MetaData()
{
    return array("DisplayName" => "Phyre", "APIVersion" => "1.1", "ListAccountsUniqueIdentifierDisplayName" => "Domain", "ListAccountsUniqueIdentifierField" => "domain", "ListAccountsProductField" => "configoption1");
}

function phyre_TestConnection($params)
{
    $phyreApi = new PhyreApi($params['serverip']);
    $phyreApi->setCredentials($params["serverusername"], $params["serverpassword"]);

    $getHostingPlans = $phyreApi->request('hosting-plans');

    if (isset($getHostingPlans['data']['hostingPlans'])) {
        return array("success" => true);
    }

    return array("error" => true);
}
function phyre_ListAccounts(array $params)
{
    $accounts = array();

    return array("success" => true, "accounts" => $accounts);
}
function phyre_CreateAccount($params)
{

    $phyreApi = new PhyreApi($params['serverip']);
    $phyreApi->setCredentials($params["serverusername"], $params["serverpassword"]);

    $phyreCustomerId = null;

    // Find Phyre customer by email
    $phyreCustomers = $phyreApi->request('customers');
    if (isset($phyreCustomers['data']['customers'])) {
        foreach ($phyreCustomers['data']['customers'] as $phyreCustomer) {
            if ($phyreCustomer['email'] == $params['clientsdetails']['email']) {
                $phyreCustomerId = $phyreCustomer['id'];
            }
        }
    }

    // Create Phyre customer if not found
    if (!$phyreCustomerId) {
        $createCustomer = $phyreApi->request('customers', [
            'name' => $params['clientsdetails']['firstname'] . ' ' . $params['clientsdetails']['lastname'],
            'email' => $params['clientsdetails']['email'],
        ], 'POST');
        if (isset($createCustomer['data']['customer'])) {
            $phyreCustomerId = $createCustomer['data']['customer']['id'];
        }
    }

    $hostingPlanId = 0;
    if (isset($params['configoption1'])) {
        $hostingPlanId = $params['configoption1'];
    }

    $hostingSubscriptionRequestData = [
        'customer_id' => $phyreCustomerId,
        'hosting_plan_id' => $hostingPlanId,
        'domain' => $params['domain'],
        'system_username' => $params['username'],
        'system_password' => $params['password'],
    ];

    $createHostingSubscription = $phyreApi->request('hosting-subscriptions', $hostingSubscriptionRequestData, 'POST');
    if (isset($createHostingSubscription['status']) && $createHostingSubscription['status'] == 'ok') {
        return "success";
    }
    if (isset($createHostingSubscription['status']) && $createHostingSubscription['status'] == 'error') {
        return $createHostingSubscription['message'];
    }

    return "error";
}
function phyre_TerminateAccount($params)
{
    try {
        $phyreApi = new PhyreApi($params['serverip']);
        $phyreApi->setCredentials($params["serverusername"], $params["serverpassword"]);

        $hostingSubscriptionId = null;
        $getHostingSubscriptions = $phyreApi->request('hosting-subscriptions',[]);
        if (isset($getHostingSubscriptions['data']['hostingSubscriptions'])) {
            foreach ($getHostingSubscriptions['data']['hostingSubscriptions'] as $hostingSubscription) {
                if ($hostingSubscription['domain'] == $params['domain']) {
                    $hostingSubscriptionId = $hostingSubscription['id'];
                }
            }
        }
        if (!$hostingSubscriptionId) {
            return "Hosting subscription not found";
        }

        $deleteHostingSubscriptions = $phyreApi->request('hosting-subscriptions/'.$hostingSubscriptionId,[], 'DELETE');
        if ($deleteHostingSubscriptions) {
            return "success";
        }

    } catch (\Exception $e) {
        return $e->getMessage();
    }

    return "error";
}
function phyre_ChangePassword($params)
{
    return "error";
}
function phyre_SuspendAccount($params)
{

    try {
        $phyreApi = new PhyreApi($params['serverip']);
        $phyreApi->setCredentials($params["serverusername"], $params["serverpassword"]);

        $hostingSubscriptionId = null;
        $getHostingSubscriptions = $phyreApi->request('hosting-subscriptions',[]);
        if (isset($getHostingSubscriptions['data']['hostingSubscriptions'])) {
            foreach ($getHostingSubscriptions['data']['hostingSubscriptions'] as $hostingSubscription) {
                if ($hostingSubscription['domain'] == $params['domain']) {
                    $hostingSubscriptionId = $hostingSubscription['id'];
                }
            }
        }
        if (!$hostingSubscriptionId) {
            return "Hosting subscription not found";
        }

        $deleteHostingSubscriptions = $phyreApi->request('hosting-subscriptions/'.$hostingSubscriptionId.'/suspend',[], 'POST');
        if ($deleteHostingSubscriptions) {
            return "success";
        }

    } catch (\Exception $e) {
        return $e->getMessage();
    }

    return "error";
}
function phyre_UnsuspendAccount($params)
{
    try {
        $phyreApi = new PhyreApi($params['serverip']);
        $phyreApi->setCredentials($params["serverusername"], $params["serverpassword"]);

        $hostingSubscriptionId = null;
        $getHostingSubscriptions = $phyreApi->request('hosting-subscriptions',[]);
        if (isset($getHostingSubscriptions['data']['hostingSubscriptions'])) {
            foreach ($getHostingSubscriptions['data']['hostingSubscriptions'] as $hostingSubscription) {
                if ($hostingSubscription['domain'] == $params['domain']) {
                    $hostingSubscriptionId = $hostingSubscription['id'];
                }
            }
        }
        if (!$hostingSubscriptionId) {
            return "Hosting subscription not found";
        }

        $deleteHostingSubscriptions = $phyreApi->request('hosting-subscriptions/'.$hostingSubscriptionId.'/unsuspend',[], 'POST');
        if ($deleteHostingSubscriptions) {
            return "success";
        }

    } catch (\Exception $e) {
        return $e->getMessage();
    }

    return "error";
}
function phyre_ChangePackage($params)
{
    return "success";
}

function phyre_GetUserCount(array $params)
{
    $totalCount = 111;
    $ownedAccounts = array();

    return array("success" => true, "totalAccounts" => $totalCount, "ownedAccounts" => $ownedAccounts);
}

function phyre_ConfigOptions(array $params)
{
    $resellerSimpleMode = $params["producttype"] == "reselleraccount";
    return array("Phyre Hosting Plan" => array("Type" => "text", "Size" => "25", "Loader" => "phyre_ListHostingPlans", "SimpleMode" => true), "Max FTP Accounts" => array("Type" => "text", "Size" => "5"), "Web Space Quota" => array("Type" => "text", "Size" => "5", "Description" => "MB"), "Max Email Accounts" => array("Type" => "text", "Size" => "5"), "Bandwidth Limit" => array("Type" => "text", "Size" => "5", "Description" => "MB"), "Dedicated IP" => array("Type" => "yesno"), "Shell Access" => array("Type" => "yesno", "Description" => "Tick to grant access"), "Max SQL Databases" => array("Type" => "text", "Size" => "5"), "CGI Access" => array("Type" => "yesno", "Description" => "Tick to grant access"), "Max Subdomains" => array("Type" => "text", "Size" => "5"), "Frontpage Extensions" => array("Type" => "yesno", "Description" => "Tick to grant access"), "Max Parked Domains" => array("Type" => "text", "Size" => "5"), "Phyre Theme" => array("Type" => "text", "Size" => "15"), "Max Addon Domains" => array("Type" => "text", "Size" => "5"), "Limit Reseller by Number" => array("Type" => "text", "Size" => "5", "Description" => "Enter max number of allowed accounts"), "Limit Reseller by Usage" => array("Type" => "yesno", "Description" => "Tick to limit by resource usage"), "Reseller Disk Space" => array("Type" => "text", "Size" => "7", "Description" => "MB", "SimpleMode" => $resellerSimpleMode), "Reseller Bandwidth" => array("Type" => "text", "Size" => "7", "Description" => "MB", "SimpleMode" => $resellerSimpleMode), "Allow DS Overselling" => array("Type" => "yesno", "Description" => "MB"), "Allow BW Overselling" => array("Type" => "yesno", "Description" => "MB"), "Reseller ACL List" => array("Type" => "text", "Size" => "20", "SimpleMode" => $resellerSimpleMode), "Add Prefix to Package" => array("Type" => "yesno", "Description" => "Add username_ to package name"), "Configure Nameservers" => array("Type" => "yesno", "Description" => "Setup Custom ns1/ns2 Nameservers"), "Reseller Ownership" => array("Type" => "yesno", "Description" => "Set the reseller to own their own account"));
}

function phyre_ListHostingPlans(array $params, $removeUsername = true)
{

    $phyreApi = new PhyreApi($params['serverip']);
    $phyreApi->setCredentials($params["serverusername"], $params["serverpassword"]);

    $getHostingPlans = $phyreApi->request('hosting-plans');

    if (isset($getHostingPlans['data']['hostingPlans'])) {
        $hostingPlans = [];
        foreach ($getHostingPlans['data']['hostingPlans'] as $hostingPlan) {
            $hostingPlans[$hostingPlan['id']] = $hostingPlan['name'];
        }
        return $hostingPlans;
    }

    return [];
}
