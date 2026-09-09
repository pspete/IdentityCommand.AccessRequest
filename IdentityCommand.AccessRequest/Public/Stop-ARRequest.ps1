# .ExternalHelp IdentityCommand.AccessRequest-help.xml
function Stop-ARRequest {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('id')]
        [String]$requestId,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateLength(1, 4096)]
        [String]$cancelReason
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/workflows/requests/$requestId/cancel"

        $body = $PSBoundParameters | Get-Parameter -ParametersToRemove requestId | ConvertTo-Json -Depth 8

        if ($PSCmdlet.ShouldProcess($requestId, 'Cancel Access Request')) {

            #Send Request
            Invoke-IDRestMethod -Uri $URI -Method POST -Body $body

        }

    }#process

    end { }#end

}
