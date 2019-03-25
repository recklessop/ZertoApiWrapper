<# .ExternalHelp ./en-us/ZertoApiWrapper-help.xml #>
# Work in progress Currently not working
function Start-ZertoFlrMountDisk {
    [cmdletbinding()]
    param(
        #provide vmname or vmid
        [Parameter(
            HelpMessage = "Name of the Virtual Machine"
        )]
        [string]$vmName,
        [Parameter(
            HelpMessage = "Virtual Machine's Zerto Id."
        )]
        [alias("vmId")]
        [string]$vmIdentifier,
        [Parameter(
            HelpMessage = "Virtual Machine SCSI or IDE volume ie (ex. SCSI0:0).",
            Mandatory = $true
        )]
        [string]$vmVolumeIdentifier,
        # vpgid is optional if using vmname
        [Parameter(
            HelpMessage = "VPG Identifier that the VM is in."
        )]
        [string]$vpgId,
        [Parameter(
            HelpMessage = "Checkpoint Identifer to mount",
            Mandatory = $true
        )]
        [alias("checkpointId")]
        [string]$checkpointIdentifier
    )


    begin {
        $baseUri = "flrs"

        $body = @{}
        $jflrbody = [ordered]@{}
        foreach ($key in $PSBoundParameters.Keys) {
            if ($key -notlike 'vpgId' -or $key -notlike 'vmName') {
                $body[$key] = $PSBoundParameters["$key"]
            }
        }
        if ($PSBoundParameters.ContainsKey('vmName')) {
            $vminfo = Get-ZertoProtectedVm -vmName $vmname
            $vpgId = $vminfo.vmIdentifier
            Write-host $vminfo
            $body['vmIdentifier'] = $vminfo.vmIdentifier
            $body['vpgIdentifier'] = $vminfo.VpgIdentifier
        }
        #$body.Remove($body.Keys['vmName'])
        $vminfo = Get-ZertoProtectedVm -vmIdentifier $body['vmIdentifier']
        $body['vpgIdentifier'] = $vminfo.VpgIdentifier

        $jflrbody["jflr"] = $body
        $jflrbody | ConvertTo-Json
    }

    process {
        foreach ($vm in $vmId) {
            $uri = "{0}" -f $baseUri
            $returnObject = Invoke-ZertoRestRequest -uri $uri -body $($jflrbody | convertto-json) -method "PUT"
        }
    }

    end {
        return $returnObject
    }
}