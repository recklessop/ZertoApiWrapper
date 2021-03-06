<# .ExternalHelp ./en-us/ZertoApiWrapper-help.xml #>
function Get-ZertoProtectedVm {
    [cmdletbinding( DefaultParameterSetName = "main" )]
    param (
        [Parameter(
            ParameterSetName = "vmIdentifier",
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "vmIdentifier(s) for which to return information"
        )]
        [ValidateNotNullOrEmpty()]
        [Alias("vmId")]
        [string[]]$vmIdentifier,
        [Parameter(
            ParameterSetName = "filter",
            HelpMessage = "The name of the VPG which protects the virtual machine."
        )]
        [ValidateNotNullOrEmpty()]
        [string]$vpgName,
        [Parameter(
            ParameterSetName = "filter",
            HelpMessage = "The name of the virtual machine."
        )]
        [ValidateNotNullOrEmpty()]
        [string]$vmName,
        [Parameter(
            ParameterSetName = "filter",
            HelpMessage = "The status of the VPG. Please see Zerto API documentation for possible values."
        )]
        [ValidateNotNullOrEmpty()]
        [string]$status,
        [Parameter(
            ParameterSetName = "filter",
            HelpMessage = "The substatus of the VPG, for example the VPG is in a bitmap sync. For the description of substatuses, refer to the Zerto Virtual Manager Administration Guide. Please see Zerto API documentation for possible values."
        )]
        [ValidateNotNullOrEmpty()]
        [string]$substatus,
        [Parameter(
            ParameterSetName = "filter",
            HelpMessage = "The ZORG for this VPG."
        )]
        [ValidateNotNullOrEmpty()]
        [string]$organizationName,
        [Parameter(
            ParameterSetName = "filter",
            HelpMessage = "The priority specified for the VPG. Possible values are: 'Low', 'Medium', or 'High'"
        )]
        [ValidateSet("Low", "Medium", "High")]
        [string]$priority,
        [Parameter(
            ParameterSetName = "filter",
            HelpMessage = "The protected site type. Please see Zerto API documentation for possible values."
        )]
        [ValidateNotNullOrEmpty()]
        [string]$protectedSiteType,
        [Parameter(
            ParameterSetName = "filter",
            HelpMessage = "The recovery site type. Please see Zerto API documentation for possible values."
        )]
        [ValidateNotNullOrEmpty()]
        [string]$recoverySiteType,
        [Parameter(
            ParameterSetName = "filter",
            HelpMessage = "The identifier of the protected site where the VPG virtual machines are protected."
        )]
        [ValidateNotNullOrEmpty()]
        [Alias("protectedSiteId")]
        [string]$protectedSiteIdentifier,
        [Parameter(
            ParameterSetName = "filter",
            HelpMessage = "The identifier of the recovery site where the VPG virtual machines are recovered."
        )]
        [ValidateNotNullOrEmpty()]
        [Alias("recoverySiteId")]
        [string]$recoverySiteIdentifier
    )

    begin {
        $baseUri = "vms"
        $returnObject = @()
    }

    process {
        # Select the operation based on the ParameterSetName
        switch ( $PSCmdlet.ParameterSetName ) {
            # Return all protected VMs if no parameters are requested
            "main" {
                $returnObject = Invoke-ZertoRestRequest -uri $baseUri
            }

            # Return information based on the vmIdentifer(s) provided.
            "vmIdentifier" {
                $returnObject = foreach ( $id in $vmIdentifier ) {
                    $uri = "{0}/{1}" -f $baseUri, $id
                    Invoke-ZertoRestRequest -uri $uri
                }
            }

            # If a search is requested, build the query string and return values.
            "filter" {
                $filter = Get-ZertoApiFilter -filterTable $PSBoundParameters
                $uri = "{0}{1}" -f $baseUri, $filter
                $returnObject = Invoke-ZertoRestRequest -uri $uri
            }
        }
    }

    end {
        return $returnObject
    }
}
