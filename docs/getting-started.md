---
title: Getting Started
subtitle: Install IdentityCommand.AccessRequest and connect to Access Requests
---

## Prerequisites

- Requires Powershell Core (recommended), or Windows PowerShell (version 5.1)
- An Idira Identity tenant with the Access Requests service enabled
- An Account to Access Idira Identity
- The `IdentityCommand` module.

## Install Options

Install from the PowerShell Gallery:

```powershell
Install-Module -Name IdentityCommand.AccessRequest -Scope CurrentUser
```

Or download the [latest release](https://github.com/pspete/IdentityCommand.AccessRequest/releases), unblock and extract the archive, and copy the `IdentityCommand.AccessRequest` folder into a path listed in `$env:PSModulePath`.

## Authentication

The module requires authentication to the Idira Identity platform using the `IdentityCommand` module.

The `IdentityCommand` module must be installed and available in order to use `IdentityCommand.AccessRequest`.

The `Connect-ARTenant` command initialises the bearer token used for module operations against the Access Requests service.

If an Identity session already exists (established with the `IdentityCommand` module's `New-IDSession` or `New-IDPlatformToken`), it is used as-is:

```powershell
# Resolve the Access Requests url automatically from the shared services subdomain
Connect-ARTenant -tenant_subdomain sometenant

# Or provide the Access Requests tenant url directly
Connect-ARTenant -tenant_url https://sometenant.uar.cyberark.cloud
```

Otherwise, provide a credential and `Connect-ARTenant` authenticates to Idira Identity for you - the Identity tenant url is discovered from the same subdomain / url:

```powershell
# Interactive user authentication (any MFA challenges are handled by IdentityCommand)
Connect-ARTenant -tenant_subdomain sometenant -Credential $Credential

# Non-interactive service user authentication via an OAuth platform token
Connect-ARTenant -tenant_subdomain sometenant -Credential $ServiceUserCredential -PlatformToken
```
