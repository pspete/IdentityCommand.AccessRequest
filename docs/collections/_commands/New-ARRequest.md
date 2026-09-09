---
external help file: IdentityCommand.AccessRequest-help.xml
Module Name: IdentityCommand.AccessRequest
online version:
schema: 2.0.0
---

# New-ARRequest

## SYNOPSIS
Creates an access request

## SYNTAX

```
New-ARRequest [-targetCategory] <String> [[-requestType] <String>] [-requestDetails] <Hashtable>
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates an access request for a target category.

The keys required in `-requestDetails` vary by target category and request type, and are described by the service rather than fixed by this module - call `Get-ARRequestForm` first and build the hashtable from the questions it returns.

## EXAMPLES

### Example 1
```
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

Creates an on-demand request for access to an Azure role

### Example 2
```
New-ARRequest -targetCategory CLOUD_CONSOLE -requestType DUAL_CONTROL -requestDetails @{
    locationType    = 'AWS'
    targetId        = 'arn:aws:sso:::permissionSet/ssoins-1234567890abcdef/ps-fedcba0987654321'
    workspaceId     = '123456789012'
    orgId           = '123456789012'
    timezone        = 'UTC'
    requestDate     = '2026-10-01'
    timeFrom        = '09:00'
    requestEndDate  = '2026-10-01'
    timeTo          = '17:00'
    priority        = 'Medium'
    reason          = 'Investigate the production alert'
}
```

Creates a dual control request for an AWS permission set

## PARAMETERS

### -targetCategory
The category of target access is being requested for.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 
Accepted values: CLOUD_CONSOLE

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -requestType
The access request workflow type. The service defaults to `ON_DEMAND`.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 
Accepted values: ON_DEMAND, DUAL_CONTROL

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -requestDetails
The answers to the request form questions, as returned by `Get-ARRequestForm` for this target category and request type.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs. The cmdlet is not run.

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

## OUTPUTS

## NOTES

## RELATED LINKS
