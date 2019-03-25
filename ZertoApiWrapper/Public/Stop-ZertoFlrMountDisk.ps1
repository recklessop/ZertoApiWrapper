<# .ExternalHelp ./en-us/ZertoApiWrapper-help.xml #>
function Stop-ZertoFlrMountDisk {
    [cmdletbinding()]
    param(
        [Parameter(
            HelpMessage = "Flr Session ID(s) to unmount.",
            Mandatory = $true
        )]
        [string[]]$flrSessionId
    )

    begin {
        $baseUri = "flrs"
    }

    process {
        # returns a task id for each delete task
        foreach ($flrId in $flrSessionId) {
            $uri = "{0}/{1}" -f $baseUri, $flrId
            Invoke-ZertoRestRequest -uri $uri -method "DELETE"
        }
    }

    end {
        # Nothing to do
    }
}