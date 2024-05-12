<link href="modules/servers/phyre/css/client.css" rel="stylesheet">
<script src="modules/servers/phyre/js/client.js"></script>

<div class="row">
    <div class="col-md-6">

        <div class="panel panel-default" id="PhyrePackagePanel">
            <div class="panel-heading">
                <h3 class="panel-title">{$LANG.Phyre.packageDomain}</h3>
            </div>
            <div class="panel-body text-center">

                <div class="phyre-package-details">
                    <em>{$groupname}</em>
                    <h4 style="margin:0;">{$product}</h4>
                    <a href="http://{$domain}" target="_blank">www.{$domain}</a>
                </div>

                <p>
                    <a href="http://{$domain}" class="btn btn-default btn-sm" target="_blank">{$LANG.visitwebsite}</a>
                    {if $domainId}
                        <a href="clientarea.php?action=domaindetails&id={$domainId}" class="btn btn-success btn-sm" target="_blank">{$LANG.managedomain}</a>
                    {/if}
                    <input type="button" onclick="popupWindow('whois.php?domain={$domain}','whois',650,420);return false;" value="{$LANG.whoisinfo}" class="btn btn-info btn-sm" />
                </p>

            </div>
        </div>

        {if $availableAddonProducts}
            <div class="panel panel-default" id="PhyreExtrasPurchasePanel">
                <div class="panel-heading">
                    <h3 class="panel-title">{$LANG.Phyre.addonsExtras}</h3>
                </div>
                <div class="panel-body text-center">

                    <form method="post" action="cart.php?a=add" class="form-inline">
                        <input type="hidden" name="serviceid" value="{$serviceid}" />
                        <select name="aid" class="form-control input-sm">
                        {foreach $availableAddonProducts as $addonId => $addonName}
                            <option value="{$addonId}">{$addonName}</option>
                        {/foreach}
                        </select>
                        <button type="submit" class="btn btn-default btn-sm">
                            <i class="fas fa-shopping-cart"></i>
                            {$LANG.Phyre.purchaseActivate}
                        </button>
                    </form>

                </div>
            </div>
        {/if}

    </div>
    <div class="col-md-6">

        <div class="panel panel-default" id="PhyreUsagePanel">
            <div class="panel-heading">
                <h3 class="panel-title">{$LANG.Phyre.usageStats}</h3>
            </div>
            <div class="panel-body text-center phyre-usage-stats">

                <div class="row">
                    <div class="col-sm-5 col-sm-offset-1 col-xs-6" id="diskUsage">
                        <strong>{$LANG.Phyre.diskUsage}</strong>
                        <br /><br />
                        <input type="text" value="{$diskpercent|substr:0:-1}" class="usage-dial" data-fgColor="#444" data-angleOffset="-125" data-angleArc="250" data-min="0" data-max="{if substr($diskpercent, 0, -1) > 100}{$diskpercent|substr:0:-1}{else}100{/if}" data-readOnly="true" data-width="100" data-height="80" />
                        <br /><br />
                        {$diskusage} M / {$disklimit} M
                    </div>
                    <div class="col-sm-5 col-xs-6" id="bandwidthUsage">
                        <strong>{$LANG.Phyre.bandwidthUsage}</strong>
                        <br /><br />
                        <input type="text" value="{$bwpercent|substr:0:-1}" class="usage-dial" data-fgColor="#d9534f" data-angleOffset="-125" data-angleArc="250" data-min="0" data-max="{if substr($bwpercent, 0, -1) > 100}{$bwpercent|substr:0:-1}{else}100{/if}" data-readOnly="true" data-width="100" data-height="80" />
                        <br /><br />
                        {$bwusage} M / {$bwlimit} M
                    </div>
                </div>

                {if $bwpercent|substr:0:-1 > 75}
                    <div class="text-danger limit-near">
                        {if $bwpercent|substr:0:-1 > 100}
                            {$LANG.Phyre.usageStatsBwOverLimit}
                        {else}
                            {$LANG.Phyre.usageStatsBwLimitNear}
                        {/if}
                        {if $packagesupgrade}
                            <a href="upgrade.php?type=package&id={$serviceid}" class="btn btn-xs btn-danger">
                                <i class="fas fa-arrow-circle-up"></i>
                                {$LANG.Phyre.usageUpgradeNow}
                            </a>
                        {/if}
                    </div>
                {elseif $diskpercent|substr:0:-1 > 75}
                    <div class="text-danger limit-near">
                        {if $diskpercent|substr:0:-1 > 100}
                            {$LANG.Phyre.usageStatsDiskOverLimit}
                        {else}
                            {$LANG.Phyre.usageStatsDiskLimitNear}
                        {/if}
                        {if $packagesupgrade}
                            <a href="upgrade.php?type=package&id={$serviceid}" class="btn btn-xs btn-danger">
                                <i class="fas fa-arrow-circle-up"></i>
                                {$LANG.Phyre.usageUpgradeNow}
                            </a>
                        {/if}
                    </div>
                {else}
                    <div class="text-info limit-near">
                        {$LANG.Phyre.usageLastUpdated} {$lastupdate}
                    </div>
                {/if}

                <script src="{$BASE_PATH_JS}/jquery.knob.js"></script>
                <script type="text/javascript">
                jQuery(function() {
                    jQuery(".usage-dial").knob({
                        'format': function (value) {
                            return value + '%';
                        }
                    });
                });
                </script>

            </div>
        </div>

    </div>
</div>

{foreach $hookOutput as $output}
    <div>
        {$output}
    </div>
{/foreach}

{if $systemStatus == 'Active'}

    <div class="panel panel-default" id="PhyreQuickShortcutsPanel">
        <div class="panel-heading">
            <h3 class="panel-title">{$LANG.Phyre.quickShortcuts}</h3>
        </div>
        <div class="panel-body text-center">

            <div class="row phyre-feature-row">
                <div class="col-sm-3 col-xs-6" id="PhyreEmailAccounts">
                    <a href="clientarea.php?action=productdetails&amp;id={$serviceid}&amp;dosinglesignon=1&amp;app=Email_Accounts" target="_blank">
                        <img src="modules/servers/phyre/img/email_accounts.png" />
                        {$LANG.Phyre.emailAccounts}
                    </a>
                </div>
                <div class="col-sm-3 col-xs-6" id="PhyreForwarders">
                    <a href="clientarea.php?action=productdetails&amp;id={$serviceid}&amp;dosinglesignon=1&amp;app=Email_Forwarders" target="_blank">
                        <img src="modules/servers/phyre/img/forwarders.png" />
                        {$LANG.Phyre.forwarders}
                    </a>
                </div>
                <div class="col-sm-3 col-xs-6" id="PhyreAutoResponders">
                    <a href="clientarea.php?action=productdetails&amp;id={$serviceid}&amp;dosinglesignon=1&amp;app=Email_AutoResponders" target="_blank">
                        <img src="modules/servers/phyre/img/autoresponders.png" />
                        {$LANG.Phyre.autoresponders}
                    </a>
                </div>
                <div class="col-sm-3 col-xs-6" id="PhyreFileManager">
                    <a href="clientarea.php?action=productdetails&amp;id={$serviceid}&amp;dosinglesignon=1&amp;app=FileManager_Home" target="_blank">
                        <img src="modules/servers/phyre/img/file_manager.png" />
                        {$LANG.Phyre.fileManager}
                    </a>
                </div>
            </div>
            <div class="row phyre-feature-row">
                <div class="col-sm-3 col-xs-6" id="PhyreBackup">
                    <a href="clientarea.php?action=productdetails&amp;id={$serviceid}&amp;dosinglesignon=1&amp;app=Backups_Home" target="_blank">
                        <img src="modules/servers/phyre/img/backup.png" />
                        {$LANG.Phyre.backup}
                    </a>
                </div>
                <div class="col-sm-3 col-xs-6" id="PhyreSubdomains">
                    <a href="clientarea.php?action=productdetails&amp;id={$serviceid}&amp;dosinglesignon=1&amp;app=Domains_SubDomains" target="_blank">
                        <img src="modules/servers/phyre/img/subdomains.png" />
                        {$LANG.Phyre.subdomains}
                    </a>
                </div>
                <div class="col-sm-3 col-xs-6" id="PhyreAddonDomains">
                    <a href="clientarea.php?action=productdetails&amp;id={$serviceid}&amp;dosinglesignon=1&amp;app=Domains_AddonDomains" target="_blank">
                        <img src="modules/servers/phyre/img/addon_domains.png" />
                        {$LANG.Phyre.addonDomains}
                    </a>
                </div>
                <div class="col-sm-3 col-xs-6" id="PhyreCronJobs">
                    <a href="clientarea.php?action=productdetails&amp;id={$serviceid}&amp;dosinglesignon=1&amp;app=Cron_Home" target="_blank">
                        <img src="modules/servers/phyre/img/cron_jobs.png" />
                        {$LANG.Phyre.cronJobs}
                    </a>
                </div>
            </div>
            <div class="row phyre-feature-row">
                <div class="col-sm-3 col-xs-6" id="PhyreMySQLDatabases">
                    <a href="clientarea.php?action=productdetails&amp;id={$serviceid}&amp;dosinglesignon=1&amp;app=Database_MySQL" target="_blank">
                        <img src="modules/servers/phyre/img/mysql_databases.png" />
                        {$LANG.Phyre.mysqlDatabases}
                    </a>
                </div>
                <div class="col-sm-3 col-xs-6" id="PhyrePhpMyAdmin">
                    <a href="clientarea.php?action=productdetails&amp;id={$serviceid}&amp;dosinglesignon=1&amp;app=Database_phpMyAdmin" target="_blank">
                        <img src="modules/servers/phyre/img/php_my_admin.png" />
                        {$LANG.Phyre.phpMyAdmin}
                    </a>
                </div>
                <div class="col-sm-3 col-xs-6" id="PhyreAwstats">
                    <a href="clientarea.php?action=productdetails&amp;id={$serviceid}&amp;dosinglesignon=1&amp;app=Stats_AWStats" target="_blank">
                        <img src="modules/servers/phyre/img/awstats.png" />
                        {$LANG.Phyre.awstats}
                    </a>
                </div>
            </div>

        </div>
    </div>

    <div class="panel panel-default" id="PhyreQuickEmailPanel">
        <div class="panel-heading">
            <h3 class="panel-title">{$LANG.Phyre.createEmailAccount}</h3>
        </div>
        <div class="panel-body">

            {include file="$template/includes/alert.tpl" type="success" msg=$LANG.Phyre.emailAccountCreateSuccess textcenter=true hide=true idname="emailCreateSuccess" additionalClasses="email-create-feedback"}

            {include file="$template/includes/alert.tpl" type="danger" msg=$LANG.Phyre.emailAccountCreateFailed|cat:' <span id="emailCreateFailedErrorMsg"></span>' textcenter=true hide=true idname="emailCreateFailed" additionalClasses="email-create-feedback"}

            <form id="frmCreateEmailAccount" onsubmit="doEmailCreate();return false">
                <input type="hidden" name="id" value="{$serviceid}" />
                <input type="hidden" name="email_quota" value="250" />
                <div class="row">
                    <div class="col-sm-6">
                        <div class="input-group">
                            <input type="text" name="email_prefix" class="form-control" placeholder="{$LANG.Phyre.usernamePlaceholder}">
                            <span class="input-group-addon">@{$domain}</span>
                        </div>
                    </div>
                    <div class="col-sm-3">
                        <input type="password" name="email_pw" class="form-control" placeholder="{$LANG.Phyre.passwordPlaceholder}">
                    </div>
                    <div class="col-sm-3">
                        <button type="submit" class="btn btn-primary btn-block" />
                            <i class="fas fa-plus" id="btnCreateLoader"></i>
                            {$LANG.Phyre.create}
                        </button>
                    </div>
                </div>
            </form>

        </div>
    </div>

{else}

    <div class="alert alert-warning text-center" role="alert" id="PhyreSuspendReasonPanel">
        {if $suspendreason}
            <strong>{$suspendreason}</strong><br />
        {/if}
        {$LANG.Phyre.packageNotActive} {$status}.<br />
        {if $systemStatus eq "Pending"}
            {$LANG.Phyre.statusPendingNotice}
        {elseif $systemStatus eq "Suspended"}
            {$LANG.Phyre.statusSuspendedNotice}
        {/if}
    </div>

{/if}

<div class="panel panel-default" id="PhyreBillingOverviewPanel">
    <div class="panel-heading">
        <h3 class="panel-title">{$LANG.Phyre.billingOverview}</h3>
    </div>
    <div class="panel-body">

        <div class="row">
            <div class="col-md-5">
                {if $firstpaymentamount neq $recurringamount}
                    <div class="row" id="firstPaymentAmount">
                        <div class="col-xs-6 text-right" >
                            {$LANG.firstpaymentamount}
                        </div>
                        <div class="col-xs-6">
                            {$firstpaymentamount}
                        </div>
                    </div>
                {/if}
                {if $billingcycle != $LANG.orderpaymenttermonetime && $billingcycle != $LANG.orderfree}
                    <div class="row" id="recurringAmount">
                        <div class="col-xs-6 text-right">
                            {$LANG.recurringamount}
                        </div>
                        <div class="col-xs-6">
                            {$recurringamount}
                        </div>
                    </div>
                {/if}
                <div class="row" id="billingCycle">
                    <div class="col-xs-6 text-right">
                        {$LANG.orderbillingcycle}
                    </div>
                    <div class="col-xs-6">
                        {$billingcycle}
                    </div>
                </div>
                <div class="row" id="paymentMethod">
                    <div class="col-xs-6 text-right">
                        {$LANG.orderpaymentmethod}
                    </div>
                    <div class="col-xs-6">
                        {$paymentmethod}
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="row" id="registrationDate">
                    <div class="col-xs-6 col-md-5 text-right">
                        {$LANG.clientareahostingregdate}
                    </div>
                    <div class="col-xs-6 col-md-7">
                        {$regdate}
                    </div>
                </div>
                <div class="row" id="nextDueDate">
                    <div class="col-xs-6 col-md-5 text-right">
                        {$LANG.clientareahostingnextduedate}
                    </div>
                    <div class="col-xs-6 col-md-7">
                        {$nextduedate}
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
{if $configurableoptions}
    <div class="panel panel-default" id="PhyreConfigurableOptionsPanel">
        <div class="panel-heading">
            <h3 class="panel-title">{$LANG.orderconfigpackage}</h3>
        </div>
        <div class="panel-body">
            {foreach from=$configurableoptions item=configoption}
                <div class="row">
                    <div class="col-md-5 col-xs-6 text-right">
                        <strong>{$configoption.optionname}</strong>
                    </div>
                    <div class="col-md-7 col-xs-6 text-left">
                        {if $configoption.optiontype eq 3}{if $configoption.selectedqty}{$LANG.yes}{else}{$LANG.no}{/if}{elseif $configoption.optiontype eq 4}{$configoption.selectedqty} x {$configoption.selectedoption}{else}{$configoption.selectedoption}{/if}
                    </div>
                </div>
            {/foreach}
        </div>
    </div>
{/if}
{if $customfields}
    <div class="panel panel-default" id="PhyreAdditionalInfoPanel">
        <div class="panel-heading">
            <h3 class="panel-title">{$LANG.additionalInfo}</h3>
        </div>
        <div class="panel-body">
            {foreach from=$customfields item=field}
                <div class="row">
                    <div class="col-md-5 col-xs-6 text-right">
                        <strong>{$field.name}</strong>
                    </div>
                    <div class="col-md-7 col-xs-6 text-left">
                        {if empty($field.value)}
                            {$LANG.blankCustomField}
                        {else}
                            {$field.value}
                        {/if}
                    </div>
                </div>
            {/foreach}
        </div>
    </div>
{/if}
