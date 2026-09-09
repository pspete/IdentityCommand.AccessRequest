---
external help file: IdentityCommand.AccessRequest-help.xml
Module Name: IdentityCommand.AccessRequest
online version:
schema: 2.0.0
---

# Connect-ARTenant

## SYNOPSIS
Connects to a Access Requests tenant

## SYNTAX

### Subdomain (Default)
```
Connect-ARTenant [-tenant_subdomain] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### SubdomainCredential
```
Connect-ARTenant [-tenant_subdomain] <String> -Credential <PSCredential> [-PlatformToken] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### SubdomainSAML
```
Connect-ARTenant [-tenant_subdomain] <String> -SAMLResponse <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### URL
```
Connect-ARTenant [-tenant_url] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### URLCredential
```
Connect-ARTenant [-tenant_url] <String> -Credential <PSCredential> [-PlatformToken] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### URLSAML
```
Connect-ARTenant [-tenant_url] <String> -SAMLResponse <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Connects to a Access Requests tenant to be able to run IdentityCommand.AccessRequest module commands against it.

Provide either the ISPSS shared services subdomain (the Access Requests url is resolved automatically via platform discovery) or the Access Requests tenant url directly.

If an active `IdentityCommand` session is already present (established with `New-IDSession` or `New-IDPlatformToken`), it is used as-is.

Supply `-Credential` (or `-SAMLResponse`) and `Connect-ARTenant` will authenticate to CyberArk Identity first, replacing any existing session: the Identity tenant url is discovered from the same subdomain / url via platform discovery, then `New-IDSession` (interactive user, including any MFA challenges) or - with `-PlatformToken` - `New-IDPlatformToken` (OAuth `client_credentials`, for a service user) is invoked.

## EXAMPLES

### Example 1
```
Connect-ARTenant -tenant_subdomain sometenant
```

Resolves the Access Requests url for the `sometenant` shared services subdomain and connects to it, using the active `IdentityCommand` session, for subsequent module operations

### Example 2
```
Connect-ARTenant -tenant_url https://sometenant.uar.cyberark.cloud
```

Connects to the https://sometenant.uar.cyberark.cloud Access Requests tenant, using the active `IdentityCommand` session, for subsequent module operations

### Example 3
```
Connect-ARTenant -tenant_subdomain sometenant -Credential $Credential
```

When no active `IdentityCommand` session is present, discovers the CyberArk Identity url for the `sometenant` subdomain, authenticates the user in `$Credential` (completing any MFA challenges), resolves the Access Requests url and connects to it

### Example 4
```
Connect-ARTenant -tenant_subdomain sometenant -Credential $ServiceUserCredential -PlatformToken
```

When no active `IdentityCommand` session is present, authenticates non-interactively as a service user via an OAuth platform token, then connects to the `sometenant` Access Requests tenant

## PARAMETERS

### -tenant_subdomain
The ISPSS shared services subdomain of the Access Requests tenant.
The Access Requests url is resolved from platform discovery and used for subsequent operations.

```yaml
Type: String
Parameter Sets: Subdomain, SubdomainCredential, SubdomainSAML
Aliases: subdomain

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -tenant_url
The url of the Access Requests tenant

```yaml
Type: String
Parameter Sets: URL, URLCredential, URLSAML
Aliases: ars_url, uar_url

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Credential
Credential used to authenticate to CyberArk Identity. Authentication is performed even if an active `IdentityCommand` session is found, replacing it.
A user credential is used with `New-IDSession`; a service user credential is used with `New-IDPlatformToken` when `-PlatformToken` is also specified.

```yaml
Type: PSCredential
Parameter Sets: SubdomainCredential, URLCredential
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PlatformToken
Authenticate as a service user via `New-IDPlatformToken` (OAuth `client_credentials`) rather than the interactive `New-IDSession`.

```yaml
Type: SwitchParameter
Parameter Sets: SubdomainCredential, URLCredential
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SAMLResponse
SAML assertion used to authenticate to CyberArk Identity via `New-IDSession`. Authentication is performed even if an active `IdentityCommand` session is found, replacing it.

```yaml
Type: String
Parameter Sets: SubdomainSAML, URLSAML
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
