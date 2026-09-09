---
external help file: IdentityCommand.AccessRequest-help.xml
Module Name: IdentityCommand.AccessRequest
online version:
schema: 2.0.0
---

# Get-ARRequestForm

## SYNOPSIS
Gets the structure of an access request form

## SYNTAX

```
Get-ARRequestForm [-targetCategory] <String> [-requestType] <String> [<CommonParameters>]
```

## DESCRIPTION
Gets the form structure for a target category and request type - the questions to answer, their data types, whether each is required, and the validation rules which apply.

The request structure varies by target category, so call this before `New-ARRequest` and build the `-requestDetails` of the new request from the keys it returns.

## EXAMPLES

### Example 1
```
Get-ARRequestForm -targetCategory CLOUD_CONSOLE -requestType ON_DEMAND
```

Gets the form structure for an on-demand cloud console request

### Example 2
```
(Get-ARRequestForm -targetCategory CLOUD_CONSOLE -requestType DUAL_CONTROL).requestForm.questions |
    Where-Object required -eq $true | Select-Object key, title, valueType
```

Lists the required questions of the dual control cloud console form

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
The access request workflow type.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 
Accepted values: ON_DEMAND, DUAL_CONTROL

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```


### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
