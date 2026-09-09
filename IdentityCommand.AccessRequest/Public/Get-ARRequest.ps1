# .ExternalHelp IdentityCommand.AccessRequest-help.xml
function Get-ARRequest {
    [CmdletBinding(DefaultParameterSetName = 'byQuery')]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byId'
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('id')]
        [String]$requestId,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byQuery'
        )]
        [ValidateLength(1, 10240)]
        [String]$filter,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byFilterCriteria'
        )]
        [ValidateSet('STARTING', 'RUNNING', 'PENDING', 'FINISHED', 'EXPIRED')]
        [String]$requestState,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byFilterCriteria'
        )]
        [ValidateSet('APPROVED', 'REJECTED', 'CANCELED', 'FAILED', 'UNKNOWN')]
        [String]$requestResult,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byFilterCriteria'
        )]
        [ValidateNotNullOrEmpty()]
        [String]$createdBy,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byFilterCriteria'
        )]
        [ValidateNotNullOrEmpty()]
        [String]$updatedBy,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byFilterCriteria'
        )]
        [datetime]$createdAfter,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byFilterCriteria'
        )]
        [datetime]$createdBefore,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byQuery'
        )]
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byFilterCriteria'
        )]
        [ValidateLength(1, 10240)]
        [String]$freeText,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byQuery'
        )]
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byFilterCriteria'
        )]
        [ValidateRange(0, 1000)]
        [int]$limit,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byQuery'
        )]
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byFilterCriteria'
        )]
        [ValidateRange(0, 10000)]
        [int]$offset,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byQuery'
        )]
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byFilterCriteria'
        )]
        [ValidateSet('CREATOR', 'APPROVER')]
        [String]$requestRole,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byQuery'
        )]
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byFilterCriteria'
        )]
        [ValidateLength(1, 10240)]
        [String]$sort
    )

    begin { }#begin

    process {

        if ($PSCmdlet.ParameterSetName -eq 'byId') {

            $URI = "$($ISPSSSession.tenant_url)/api/workflows/requests/$requestId"

            #Send Request
            Invoke-IDRestMethod -Uri $URI -Method GET

        } else {

            $URI = "$($ISPSSSession.tenant_url)/api/workflows/requests"

            $boundParameters = $PSBoundParameters | Get-Parameter -ParametersToRemove requestState, requestResult, createdBy, updatedBy, createdAfter, createdBefore

            if ($PSCmdlet.ParameterSetName -eq 'byFilterCriteria') {

                $FilterClause = @()

                foreach ($Field in 'requestState', 'requestResult', 'createdBy', 'updatedBy') {
                    if ($PSBoundParameters.ContainsKey($Field)) {
                        $FilterClause += @{ Field = $Field; Operator = 'eq'; Value = $PSBoundParameters[$Field] }
                    }
                }

                #The service renders a filtered timestamp as 'yyyy-MM-dd HH:mm:ss'
                if ($PSBoundParameters.ContainsKey('createdAfter')) {
                    $FilterClause += @{ Field = 'createdAt'; Operator = 'ge'; Value = $createdAfter.ToString('yyyy-MM-dd HH:mm:ss') }
                }

                if ($PSBoundParameters.ContainsKey('createdBefore')) {
                    $FilterClause += @{ Field = 'createdAt'; Operator = 'le'; Value = $createdBefore.ToString('yyyy-MM-dd HH:mm:ss') }
                }

                if ($FilterClause.Count -gt 0) {
                    $boundParameters['filter'] = ConvertTo-ARFilterString -Filter $FilterClause
                }

            }

            $URI = Add-QueryString -URI $URI -Parameter $boundParameters

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method GET

            if ($null -ne $result) {

                Get-PagedResult -InitialResult $result -URI $URI -Style Offset -ResultProperty 'items' -TotalResponseKey 'totalCount'

            }

        }

    }#process

    end { }#end

}
