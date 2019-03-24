<# .ExternalHelp ./en-us/ZertoApiWrapper-help.xml #>
function Get-ZertoFlrSession{
    [cmdletbinding( defaultParameterSetName = "main" )]
    param(
        [Parameter(
            ParameterSetName = "filter",
            HelpMessage = "The VMIdentifier of the VM for which you want to return Jflr Sessions."
        )]
        [string]$vmIdentifier,
        [Parameter(
            ParameterSetName = "flrSessionId",
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The identifier or identifiers of the event for which information is returned.")]
        [string[]]$flrSessionId
    )

    begin {
        $baseUri = "flrs"
        $returnObject = @()
    }

    process {
        # Process based on the ParameterSetName Used
        switch ( $PSCmdlet.ParameterSetName ) {
            # If no params are supplied, return all Events
            "main" {
                $uri = "{0}" -f $baseUri
                $returnObject = Invoke-ZertoRestRequest -uri $uri
            }

            # If one or more flrIdentifiers are supplied, run a foreach loop to get them all
            "flrSessionId" {
                $returnObject = foreach ( $id in $flrSessionId ) {
                    $uri = "{0}/{1}" -f $baseUri, $id
                    Invoke-ZertoRestRequest -uri $uri
                }
            }

            # If a filter is applied, create the filter and return the events that fall in that filter
            "filter" {
                $filter = Get-ZertoApiFilter -filterTable $PSBoundParameters
                $uri = "{0}{1}" -f $baseUri, $filter
                $returnObject = Invoke-ZertoRestRequest -uri $uri
            }

            # If a different ParameterSet is called, use the ParameterSet name to determine the URI and call it.
            default {
                $uri = "{0}/{1}" -f $baseUri, $PSCmdlet.ParameterSetName.ToLower()
                $returnObject = Invoke-ZertoRestRequest -uri $uri
            }
        }
    }

    end {
        return $returnObject
    }
}
