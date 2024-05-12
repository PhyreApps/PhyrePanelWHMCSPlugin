<form action="clientarea.php" method="post" target="_blank">
    <input type="hidden" name="action" value="productdetails" />
    <input type="hidden" name="id" value="{$serviceid}" />
    <input type="hidden" name="dosinglesignon" value="1" />
    <input type="submit" value="{if $producttype=="hostingaccount"}{$LANG.phyrelogin}{else}{$LANG.phyrewhmlogin}{/if}" class="btn btn-primary modulebutton" />
    <input type="button" value="{$LANG.phyrewebmaillogin}" onClick="window.open('http{if $serversecure}s{/if}://{if $serverhostname}{$serverhostname}{else}{$serverip}{/if}:{if $serversecure}2096{else}2095{/if}/')" class="btn btn-default modulebutton" />
</form>

