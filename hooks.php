<?php

add_hook("ClientAreaPrimarySidebar", -1, "phyre_defineSsoSidebarLinks");
function phyre_defineSsoSidebarLinks($sidebar)
{
    if (!$sidebar->getChild("Service Details Actions")) {
        return NULL;
    }
    $service = Menu::context("service");
    if ($service instanceof WHMCS\Service\Service && $service->product->module != "phyre") {
        return NULL;
    }
    $ssoPermission = checkContactPermission("productsso", true);
    $sidebar->getChild("Service Details Actions")->addChild("Login to Phyre", array("uri" => "clientarea.php?action=productdetails&id=" . $service->id . "&dosinglesignon=1" . ($service->product->type == "reselleraccount" ? "&app=Home" : ""), "label" => Lang::trans("phyrelogin"), "attributes" => $ssoPermission ? array("target" => "_blank") : array(), "disabled" => $service->status != "Active", "order" => 1));
    if ($service->product->type == "reselleraccount") {
        $sidebar->getChild("Service Details Actions")->addChild("Login to Phyre Reseller", array("uri" => "clientarea.php?action=productdetails&id=" . $service->id . "&dosinglesignon=1", "label" => Lang::trans("phyrewhmlogin"), "attributes" => $ssoPermission ? array("target" => "_blank") : array(), "disabled" => $service->status != "Active", "order" => 2));
    }
    $moduleInterface = new WHMCS\Module\Server();
    $moduleInterface->loadByServiceID($service->id);
    $serverParams = $moduleInterface->getServerParams($service->server);
    $domain = $serverParams["serverhostname"] ?: $serverParams["serverip"];
    $port = $serverParams["serversecure"] ? "2096" : "2095";
    $webmailUrl = $serverParams["serverhttpprefix"] . "://" . $domain . ":" . $port;
    $sidebar->getChild("Service Details Actions")->addChild("Login to Webmail", array("uri" => $webmailUrl, "label" => Lang::trans("phyrewebmaillogin"), "attributes" => array("target" => "_blank"), "disabled" => $service->status != "Active", "order" => 3));
}

