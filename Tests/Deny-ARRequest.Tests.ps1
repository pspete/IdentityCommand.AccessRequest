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

Describe 'Deny-ARRequest' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:ARModuleName -MockWith {
            [pscustomobject]@{ requestId = '8a45155d'; requestResult = 'REJECTED' }
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

        $Script:response = Deny-ARRequest -requestId '8a45155d' -finalizationReason 'SomeReason'
    }

    Context 'Request' {

        It 'sends request' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:ARModuleName -Times 1 -Exactly -Scope It
        }

        It 'sends request to expected endpoint' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:ARModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.uar.cyberark.cloud/api/workflows/requests/8a45155d/finalize'
            } -Times 1 -Exactly -Scope It
        }

        It 'uses expected method' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:ARModuleName -ParameterFilter {
                $Method -eq 'POST'
            } -Times 1 -Exactly -Scope It
        }

        It 'sends a result of REJECTED in the body' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:ARModuleName -ParameterFilter {
                ($Body | ConvertFrom-Json).result -eq 'REJECTED'
            } -Times 1 -Exactly -Scope It
        }

        It 'sends the finalization reason in the body' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:ARModuleName -ParameterFilter {
                ($Body | ConvertFrom-Json).finalizationReason -eq 'SomeReason'
            } -Times 1 -Exactly -Scope It
        }

        It 'sends a result even when no reason is supplied' {
            $null = Deny-ARRequest -requestId 'NOREASON'
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:ARModuleName -ParameterFilter {
                ($URI -match 'NOREASON') -and (($Body | ConvertFrom-Json).result -eq 'REJECTED')
            } -Times 1 -Exactly -Scope It
        }

        It 'does not send the request id in the body' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:ARModuleName -ParameterFilter {
                ($Body | ConvertFrom-Json).PSObject.Properties.Name -notcontains 'requestId'
            } -Times 1 -Exactly -Scope It
        }

        It 'accepts the request id from the pipeline by property name' {
            [pscustomobject]@{ requestId = 'OTHER' } | Deny-ARRequest
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:ARModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.uar.cyberark.cloud/api/workflows/requests/OTHER/finalize'
            } -Times 1 -Exactly -Scope It
        }

        It 'does not send a request when WhatIf is specified' {
            $null = Deny-ARRequest -requestId 'NOTFINALIZED' -WhatIf
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:ARModuleName -ParameterFilter {
                $URI -match 'NOTFINALIZED'
            } -Times 0 -Exactly -Scope It
        }
    }

    Context 'Response' {

        It 'provides output' {
            $Script:response | Should -Not -BeNullOrEmpty
        }

        It 'outputs the finalized request' {
            $Script:response.requestResult | Should -Be 'REJECTED'
        }
    }

}
