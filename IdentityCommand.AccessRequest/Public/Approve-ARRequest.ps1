# .ExternalHelp IdentityCommand.AccessRequest-help.xml
function Approve-ARRequest {
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
        [String]$finalizationReason
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/workflows/requests/$requestId/finalize"

        $boundParameters = $PSBoundParameters | Get-Parameter -ParametersToRemove requestId
        $boundParameters['result'] = 'APPROVED'

        $body = $boundParameters | ConvertTo-Json -Depth 8

        if ($PSCmdlet.ShouldProcess($requestId, 'Approve Access Request')) {

            #Send Request
            Invoke-IDRestMethod -Uri $URI -Method POST -Body $body

        }

    }#process

    end { }#end

}
