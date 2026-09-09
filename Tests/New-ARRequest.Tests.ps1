BeforeAll {
    $Script:ARModuleName = 'IdentityCommand.AccessRequest'

    #Get Current Directory
    $Here = Split-Path -Parent $PSCommandPath

    #Resolve Path to Module Directory
    $ModulePath = Resolve-Path "$Here\..\$Script:ARModuleName"

    #Define Path to Module Manifest
    $ManifestPath = Join-Path "$ModulePath" "$Script:ARModuleName.psd1"

    if ( -not (Get-Module -Name $Script:ARModuleName -All)) {

        Import-Module -Name "$ManifestPath" -ArgumentList $true -Force -ErrorAction Stop

    }
}

Describe 'New-ARRequest' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:ARModuleName -MockWith {
            [pscustomobject]@{ requestId = '8a45155d'; requestState = 'PENDING'; requestResult = 'UNKNOWN' }
        }

        InModuleScope -ModuleName $Script:ARModuleName {
            $ISPSSSession = [ordered]@{
                tenant_url = 'https://somedomain.uar.cyberark.cloud'
                User       = $null
                TenantId   = 'SomeTenant'
                SessionId  = 'SomeSession'
                WebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
            }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
        }

        $Script:response = New-ARRequest -targetCategory CLOUD_CONSOLE -requestType ON_DEMAND -requestDetails @{ reason = 'SomeReason'; locationType = 'Azure' }
    }

    Context 'Request' {

        It 'sends request' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:ARModuleName -Times 1 -Exactly -Scope It
        }

        It 'sends request to expected endpoint' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:ARModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.uar.cyberark.cloud/api/workflows/requests'
            } -Times 1 -Exactly -Scope It
        }

        It 'uses expected method' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:ARModuleName -ParameterFilter {
                $Method -eq 'POST'
            } -Times 1 -Exactly -Scope It
        }

        It 'sends the target category in the body' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:ARModuleName -ParameterFilter {
                ($Body | ConvertFrom-Json).targetCategory -eq 'CLOUD_CONSOLE'
            } -Times 1 -Exactly -Scope It
        }

        It 'sends the request details in the body' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:ARModuleName -ParameterFilter {
                ($Body | ConvertFrom-Json).requestDetails.reason -eq 'SomeReason'
            } -Times 1 -Exactly -Scope It
        }

        It 'omits the request type when not supplied' {
            $null = New-ARRequest -targetCategory CLOUD_CONSOLE -requestDetails @{ reason = 'SomeReason' }
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:ARModuleName -ParameterFilter {
                ($Body | ConvertFrom-Json).PSObject.Properties.Name -notcontains 'requestType'
            } -Times 1 -Exactly -Scope It
        }

        It 'does not send a request when WhatIf is specified' {
            $null = New-ARRequest -targetCategory CLOUD_CONSOLE -requestDetails @{ reason = 'NotCreated' } -WhatIf
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:ARModuleName -ParameterFilter {
                $Body -match 'NotCreated'
            } -Times 0 -Exactly -Scope It
        }
    }

    Context 'Response' {

        It 'provides output' {
            $Script:response | Should -Not -BeNullOrEmpty
        }

        It 'outputs the created request' {
            $Script:response.requestId | Should -Be '8a45155d'
        }
    }

}
