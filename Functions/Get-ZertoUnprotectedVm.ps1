function Get-ZertoUnprotectedVm {
    [cmdletbinding()]
    $uri = "virtualizationsites/{0}/vms" -f $(Get-ZertoLocalSite).siteidentifier
    Invoke-ZertoRestRequest -uri $uri
}
