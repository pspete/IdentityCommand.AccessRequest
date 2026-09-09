# IdentityCommand.AccessRequest

**IdentityCommand.AccessRequest** is a PowerShell module that provides a set of easy-to-use commands, allowing you to interact with the **CyberArk Access Request API** from within the PowerShell environment.

| Main Branch              | Latest Build             | CodeFactor                 | Coverage                     | PowerShell Gallery        | License                      |
| ------------------------ | ------------------------ | -------------------------- | ---------------------------- | ------------------------- | ---------------------------- |
| [![appveyor][]][av-site] | [![tests][]][tests-site] | [![codefactor][]][cf-site] | [![codecov][]][codecov-link] | [![psgallery][]][ps-site] | [![license][]][license-link] |

[appveyor]: https://ci.appveyor.com/api/projects/status/q2av77njofnsul92/branch/main?svg=true
[av-site]: https://ci.appveyor.com/project/pspete/IdentityCommand-AccessRequest/branch/main
[psgallery]: https://img.shields.io/powershellgallery/v/IdentityCommand.AccessRequest.svg
[ps-site]: https://www.powershellgallery.com/packages/IdentityCommand.AccessRequest
[tests]: https://img.shields.io/appveyor/tests/pspete/IdentityCommand-AccessRequest.svg
[tests-site]: https://ci.appveyor.com/project/pspete/IdentityCommand-AccessRequest
[downloads]: https://img.shields.io/powershellgallery/dt/IdentityCommand.AccessRequest.svg?color=blue
[cf-site]: https://www.codefactor.io/repository/github/pspete/IdentityCommand.AccessRequest
[codefactor]: https://www.codefactor.io/repository/github/pspete/IdentityCommand.AccessRequest/badge
[codecov]: https://codecov.io/gh/pspete/IdentityCommand.AccessRequest/branch/main/graph/badge.svg
[codecov-link]: https://codecov.io/gh/pspete/IdentityCommand.AccessRequest
[license]: https://img.shields.io/github/license/pspete/IdentityCommand.AccessRequest.svg
[license-link]: https://github.com/pspete/IdentityCommand.AccessRequest/blob/main/LICENSE

## Using the Module

The module requires authentication to the CyberArk Identity platform using the `IdentityCommand` module.

The `IdentityCommand` module must be installed and available in order to use `IdentityCommand.AccessRequest`.

### Access Requests Authentication

The `Connect-ARTenant` command initialises the bearer token used for module operations against the Access Requests service.

If an Identity session already exists (established with the `IdentityCommand` module's `New-IDSession` or `New-IDPlatformToken`), it is used as-is:

```powershell
# Resolve the Access Requests url automatically from the shared services subdomain
Connect-ARTenant -tenant_subdomain sometenant

# Or provide the Access Requests tenant url directly
Connect-ARTenant -tenant_url https://sometenant.uar.cyberark.cloud
```

Otherwise, provide a credential and `Connect-ARTenant` authenticates to CyberArk Identity for you - the Identity tenant url is discovered from the same subdomain / url:

```powershell
# Interactive user authentication (any MFA challenges are handled by IdentityCommand)
Connect-ARTenant -tenant_subdomain sometenant -Credential $Credential

# Non-interactive service user authentication via an OAuth platform token
Connect-ARTenant -tenant_subdomain sometenant -Credential $ServiceUserCredential -PlatformToken
```

### Access Requests

`Get-ARRequest` returns the requests you can see - those you raised, and those assigned to you as an approver. Narrow by role, or by any of the filter criteria:

```powershell
# Everything visible to you
Get-ARRequest

# Just the ones waiting on your approval
Get-ARRequest -requestState PENDING -requestRole APPROVER

# Raised by a given user in the last week
Get-ARRequest -createdBy 'John.Doe@cyberark.com' -createdAfter (Get-Date).AddDays(-7)

# A single request
Get-ARRequest -requestId 8a45155d-0273-4bc8-8d45-9fe3f4d4de6d
```

Those criteria are assembled into the filter expression the service expects. For anything they do not express, `-filter` takes an expression directly - note the service requires every expression to be complete within parentheses:

```powershell
Get-ARRequest -filter "((requestState eq finished) and (priority gt 5))"
```

### Raising a Request

The questions a request must answer vary by target category and request type, and the service describes them rather than the module fixing them. Ask for the form first, then build `-requestDetails` from the keys it returns:

```powershell
$Form = Get-ARRequestForm -targetCategory CLOUD_CONSOLE -requestType ON_DEMAND
$Form.requestForm.questions | Where-Object required -eq $true | Select-Object key, title, valueType

New-ARRequest -targetCategory CLOUD_CONSOLE -requestType ON_DEMAND -requestDetails @{
    locationType = 'Azure'
    roleId       = '/providers/Microsoft.Authorization/roleDefinitions/3ae3fb29-0000-4ccd-bf80-542e7b26e081'
    workspaceId  = 'subscriptions/15380d28-0024-4c6c-8a19-fb1dcf4d9a0d'
    orgId        = '30ddc194-66d2-4bc9-adc2-154977bb0419'
    reason       = 'I need access to change the subscription settings.'
    priority     = 'Low'
    requestDate  = '2026-09-30'
    timezone     = 'Europe/London'
    timeFrom     = '09:00'
    timeTo       = '17:00'
}
```

A request you raised can be cancelled while it is still open - before an approver has handled it, or before the approved access window starts:

```powershell
Get-ARRequest -requestState PENDING -requestRole CREATOR | Stop-ARRequest -cancelReason 'Raised in error'
```

### Approving and Rejecting

Requests assigned to you as an approver are handled with `Approve-ARRequest` and `Deny-ARRequest`. Once one assigned approver has handled a request, no other can:

```powershell
Approve-ARRequest -requestId $id -finalizationReason 'All requirements met'

Get-ARRequest -requestState PENDING -requestRole APPROVER | Deny-ARRequest -finalizationReason 'Raise a change record first'
```

## Module Commands

| Command              | Description                                         |
| -------------------- | --------------------------------------------------- |
| `Connect-ARTenant`   | Authenticate to the Access Requests service         |
| `Get-ARRequest`      | Get access requests                                 |
| `Get-ARRequestForm`  | Get the structure of an access request form         |
| `New-ARRequest`      | Create an access request                            |
| `Stop-ARRequest`     | Cancel an open access request                       |
| `Approve-ARRequest`  | Approve an open access request                      |
| `Deny-ARRequest`     | Reject an open access request                       |
| `Get-ARModuleData`   | Get the module version & session configuration data |

## Installation

### Prerequisites

- Requires Powershell Core (recommended), or Windows PowerShell (version 5.1)
- A CyberArk Identity tenant with the Access Requests service enabled
- An Account to Access CyberArk Identity

### Install Options

Users can install IdentityCommand.AccessRequest from GitHub or the PowerShell Gallery.

Choose any of the following ways to download the module and install it:

#### Option 1: Install from PowerShell Gallery

This is the easiest and most popular way to install the module:

1. Open a PowerShell prompt

2. Run the following command:

```powershell
Install-Module -Name IdentityCommand.AccessRequest -Scope CurrentUser
```

#### Option 2: Manual Install

The module files can be manually copied to one of your PowerShell module directories.

Use the following command to get the paths to your local PowerShell module folders:

```powershell

$env:PSModulePath.split(';')

```

The module files must be placed in one of the listed directories, in a folder called `IdentityCommand.AccessRequest`.

More: [about_PSModulePath](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_psmodulepath)

The module files are available to download using a variety of methods:

##### PowerShell Gallery

- Download from the module from the [PowerShell Gallery](https://www.powershellgallery.com/packages/IdentityCommand.AccessRequest/):
  - Run the PowerShell command `Save-Module -Name IdentityCommand.AccessRequest -Path C:\temp`
  - Copy the `C:\temp\IdentityCommand.AccessRequest` folder to your "Powershell Modules" directory of choice.

##### IdentityCommand.AccessRequest Release

- [Download the latest GitHub release](https://github.com/pspete/IdentityCommand.AccessRequest/releases/latest)
  - Unblock & Extract the archive
  - Rename the extracted `IdentityCommand.AccessRequest-v#.#.#` folder to `IdentityCommand.AccessRequest`
  - Copy the `IdentityCommand.AccessRequest` folder to your "Powershell Modules" directory of choice.

##### IdentityCommand.AccessRequest Branch

- [Download the `main` branch](https://github.com/pspete/IdentityCommand.AccessRequest/archive/refs/heads/main.zip)
  - Unblock & Extract the archive
  - Copy the `IdentityCommand.AccessRequest` (`\<Archive Root>\IdentityCommand.AccessRequest-main\IdentityCommand.AccessRequest`) folder to your "Powershell Modules" directory of choice.

#### Verification

Validate Install:

```powershell

Get-Module -ListAvailable IdentityCommand.AccessRequest

```

Import the module:

```powershell

Import-Module IdentityCommand.AccessRequest

```

List Module Commands:

```powershell

Get-Command -Module IdentityCommand.AccessRequest

```

Get detailed information on specific commands:

```powershell

Get-Help Connect-ARTenant -Full

```

## Sponsorship

Please support continued development; consider sponsoring <a href="https://github.com/sponsors/pspete"> @pspete on GitHub Sponsors</a>

## Changelog

All notable changes to this project will be documented in the [Changelog](CHANGELOG.md)

## Author

- **Pete Maan** - [pspete](https://github.com/pspete)

## License

This project is [licensed under the MIT License](LICENSE.md).

## Contributing

Any and all contributions to this project are appreciated.

See the [CONTRIBUTING.md](CONTRIBUTING.md) for a few more details.

## Support

_IdentityCommand.AccessRequest_ is neither developed nor supported by CyberArk; any official support channels offered by the vendor are not appropriate for seeking help with the _IdentityCommand.AccessRequest_ module.

Help and support should be sought by [opening an issue][new-issue].

[new-issue]: https://github.com/pspete/IdentityCommand.AccessRequest/issues/new

Priority support could be considered for <a href="https://github.com/sponsors/pspete">sponsors of @pspete</a>, <a href="mailto:pspete@pspete.dev">contact us</a> to discuss options.
