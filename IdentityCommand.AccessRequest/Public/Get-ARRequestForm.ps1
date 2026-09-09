# .ExternalHelp IdentityCommand.AccessRequest-help.xml
function Get-ARRequestForm {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('CLOUD_CONSOLE')]
        [String]$targetCategory,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('ON_DEMAND', 'DUAL_CONTROL')]
        [String]$requestType
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/workflows/request-forms"

        $URI = Add-QueryString -URI $URI -Parameter ($PSBoundParameters | Get-Parameter)

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $result) {

            $result.requestForms

        }

    }#process

    end { }#end

}
