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

Describe 'Get-ARRequest' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:ARModuleName -MockWith {
            [pscustomobject]@{
                'items'      = @([pscustomobject]@{ requestId = '8a45155d'; requestState = 'PENDING'; requestResult = 'UNKNOWN' })
                'count'      = 1
                'totalCount' = 1
            }
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

        $Script:response = Get-ARRequest
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
                $Method -eq 'GET'
            } -Times 1 -Exactly -Scope It
        }

        It 'requests a single access request by id' {
            $null = Get-ARRequest -requestId '8a45155d'
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:ARModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.uar.cyberark.cloud/api/workflows/requests/8a45155d'
            } -Times 1 -Exactly -Scope It
        }

        It 'sends request with expected query string' {
            $null = Get-ARRequest -limit 50 -requestRole APPROVER -sort 'createdAt'
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:ARModuleName -ParameterFilter {
                ($URI -match 'limit=50') -and ($URI -match 'requestRole=APPROVER')
            } -Times 1 -Exactly -Scope It
        }

        It 'passes a supplied filter expression through unaltered' {
            $null = Get-ARRequest -filter '((requestState eq finished) and (priority gt 5))'
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:ARModuleName -ParameterFilter {
                [uri]::UnescapeDataString($URI) -match '\(\(requestState eq finished\) and \(priority gt 5\)\)'
            } -Times 1 -Exactly -Scope It
        }

        It 'builds a filter expression from a single criterion' {
            $null = Get-ARRequest -requestState PENDING
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:ARModuleName -ParameterFilter {
                [uri]::UnescapeDataString($URI) -match '\(requestState eq PENDING\)'
            } -Times 1 -Exactly -Scope It
        }

        It 'builds a parenthesised filter expression from several criteria' {
            $null = Get-ARRequest -requestState FINISHED -requestResult APPROVED
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:ARModuleName -ParameterFilter {
                [uri]::UnescapeDataString($URI) -match '\(\(requestState eq FINISHED\) and \(requestResult eq APPROVED\)\)'
            } -Times 1 -Exactly -Scope It
        }

        It 'quotes a filter value which is not a bare word' {
            $null = Get-ARRequest -createdBy 'John.Doe@cyberark.com'
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:ARModuleName -ParameterFilter {
                [uri]::UnescapeDataString($URI) -match "createdBy eq 'John.Doe@cyberark.com'"
            } -Times 1 -Exactly -Scope It
        }

        It 'renders a date criterion in the format the service documents' {
            $null = Get-ARRequest -createdAfter ([datetime]'2026-01-15T09:30:00')
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:ARModuleName -ParameterFilter {
                [uri]::UnescapeDataString($URI) -match "createdAt ge '2026-01-15 09:30:00'"
            } -Times 1 -Exactly -Scope It
        }

        It 'does not send the filter criteria as query parameters of their own' {
            $null = Get-ARRequest -requestState PENDING
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:ARModuleName -ParameterFilter {
                ($URI -match 'filter=') -and ($URI -notmatch 'requestState=')
            } -Times 1 -Exactly -Scope It
        }

        It 'does not send a filter when no criteria are supplied' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:ARModuleName -ParameterFilter {
                $URI -notmatch 'filter='
            } -Times 1 -Exactly -Scope It
        }

        It 'does not accept a filter expression alongside filter criteria' {
            { Get-ARRequest -filter '(a eq b)' -requestState PENDING } | Should -Throw
        }
    }

    Context 'Response' {

        It 'provides output' {
            $Script:response | Should -Not -BeNullOrEmpty
        }

        It 'outputs the items of the response' {
            $Script:response.requestId | Should -Be '8a45155d'
        }

        It 'follows pagination until the reported total is collected' {
            Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:ARModuleName -MockWith {
                [pscustomobject]@{ 'items' = @([pscustomobject]@{ requestId = 'SECOND' }); 'count' = 1; 'totalCount' = 2 }
            } -ParameterFilter { $URI -match 'offset=' }

            Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:ARModuleName -MockWith {
                [pscustomobject]@{ 'items' = @([pscustomobject]@{ requestId = 'FIRST' }); 'count' = 1; 'totalCount' = 2 }
            } -ParameterFilter { $URI -notmatch 'offset=' }

            (Get-ARRequest | Measure-Object).Count | Should -Be 2
        }

        It 'does not page a request for a single access request' {
            $null = Get-ARRequest -requestId '8a45155d'
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:ARModuleName -ParameterFilter {
                $URI -match '/requests/8a45155d$'
            } -Times 1 -Exactly -Scope It
        }
    }

}
