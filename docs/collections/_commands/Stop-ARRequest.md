---
external help file: IdentityCommand.AccessRequest-help.xml
Module Name: IdentityCommand.AccessRequest
online version:
schema: 2.0.0
---

# Stop-ARRequest

## SYNOPSIS
Cancels an open access request

## SYNTAX

```
Stop-ARRequest [-requestId] <String> [[-cancelReason] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Cancels an open access request.

A request can only be cancelled by the user who raised it, and only while it is still cancellable - pending, before an approver has handled it, or fulfilled, before the approved access window starts.

Request identifiers come from `Get-ARRequest`, and pipe into this command.

## EXAMPLES

### Example 1
```
Stop-ARRequest -requestId 8a45155d-0273-4bc8-8d45-9fe3f4d4de6d -cancelReason 'No longer needed'
```

Cancels the specified access request

### Example 2
```
Get-ARRequest -requestState PENDING -requestRole CREATOR | Stop-ARRequest -cancelReason 'Raised in error'
```

Cancels every pending request you raised

## PARAMETERS

### -requestId
The identifier of the access request to cancel.

```yaml
Type: String
Parameter Sets: (All)
Aliases: id

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -cancelReason
The reason for cancelling the request.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
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
