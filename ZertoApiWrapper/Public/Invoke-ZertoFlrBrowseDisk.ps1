<# .ExternalHelp ./en-us/ZertoApiWrapper-help.xml #>
function Invoke-ZertoFlrBrowseDisk {
    [cmdletbinding()]
    param(
        [Parameter(
            HelpMessage = "Name(s) of the VPG(s) to commit.",
            Mandatory = $true
        )]
        [string]$flrSessionId,
        [Parameter(
            HelpMessage = "Disk Path",
            Mandatory = $true
        )]
        [string]$fsPath,
        [Parameter(
            HelpMessage = "Use this parameter to set the file system type.",
            Mandatory = $true
        )]
        [string]$fsType
    )

    begin {
        $baseUri = "flrs"
        $path = "$fsPath $fsType"
        write-host $path
        $body = @{"Path" = $path}
    }

    process {
        # for the given flr session identifier, return information on the file or path and its content.
        $uri = "{0}/{1}/browse" -f $baseUri, $flrSessionId
        Invoke-ZertoRestRequest -uri $uri -body $($body | convertto-json) -method "POST"
    }

    end {
        # Nothing to do
    }
}