# .ExternalHelp IdentityCommand.AccessRequest-help.xml
function New-ARRequest {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('CLOUD_CONSOLE')]
        [String]$targetCategory,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('ON_DEMAND', 'DUAL_CONTROL')]
        [String]$requestType,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [hashtable]$requestDetails
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/workflows/requests"

        $body = $PSBoundParameters | Get-Parameter | ConvertTo-Json -Depth 8

        if ($PSCmdlet.ShouldProcess($targetCategory, 'Create Access Request')) {

            #Send Request
            Invoke-IDRestMethod -Uri $URI -Method POST -Body $body

        }

    }#process

    end { }#end

}
