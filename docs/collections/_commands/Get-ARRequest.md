---
external help file: IdentityCommand.AccessRequest-help.xml
Module Name: IdentityCommand.AccessRequest
online version:
schema: 2.0.0
---

# Get-ARRequest

## SYNOPSIS
Gets access requests

## SYNTAX

### byQuery (Default)
```
Get-ARRequest [-filter <String>] [-freeText <String>] [-limit <Int32>] [-offset <Int32>]
 [-requestRole <String>] [-sort <String>] [<CommonParameters>]
```

### byFilterCriteria
```
Get-ARRequest [-requestState <String>] [-requestResult <String>] [-createdBy <String>]
 [-updatedBy <String>] [-createdAfter <DateTime>] [-createdBefore <DateTime>] [-freeText <String>]
 [-limit <Int32>] [-offset <Int32>] [-requestRole <String>] [-sort <String>] [<CommonParameters>]
```

### byId
```
Get-ARRequest -requestId <String> [<CommonParameters>]
```

## DESCRIPTION
Gets access requests - a single request by identifier, or a list narrowed by filter criteria.

Only the requester and the assigned approvers of a request can retrieve it. By default requests are returned for both roles; narrow with `-requestRole`.

Two ways to filter a list are offered. The `byFilterCriteria` set takes individual criteria and builds the service's filter expression for you, which covers the common cases. The `byQuery` set takes a `-filter` expression directly, for anything the criteria do not express.

Results are paginated automatically; every page is retrieved and the requests of each are returned.

## EXAMPLES

### Example 1
```
Get-ARRequest
```

Gets all access requests visible to you

### Example 2
```
Get-ARRequest -requestId 8a45155d-0273-4bc8-8d45-9fe3f4d4de6d
```

Gets the specified access request

### Example 3
```
Get-ARRequest -requestState PENDING -requestRole APPROVER
```

Gets the pending requests awaiting your approval

### Example 4
```
Get-ARRequest -createdBy 'John.Doe@cyberark.com' -createdAfter (Get-Date).AddDays(-7)
```

Gets the requests raised by the specified user in the last week

### Example 5
```
Get-ARRequest -filter "((requestState eq finished) and (priority gt 5))"
```

Gets requests matching a filter expression supplied directly

### Example 6
```
Get-ARRequest -requestState PENDING -requestRole APPROVER | Approve-ARRequest -finalizationReason 'All requirements met'
```

Approves every request awaiting your approval

## PARAMETERS

### -requestId
The identifier of a single access request to get.

```yaml
Type: String
Parameter Sets: byId
Aliases: id

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -filter
A filter expression, passed to the service as given. Every expression must be complete within parentheses, for example `((requestState eq finished) and (priority gt 5))`.

The supported operators are `is_null`, `is_not_null`, `is_true`, `is_false`, `eq`, `neq`, `contains`, `not_contains`, `sw`, `ew`, `gt`, `lt`, `ge`, `le` and `in`.

The filterable fields are `createdAt`, `calculatedRequestStartTime`, `createdBy`, `updatedAt`, `updatedBy`, `categoryType`, `requestState`, `requestResult`, `requestDetails`, `priority`, `locationType`, `finalizationReason`, `reason`, `workspaceName` and `approver.entityName`.

```yaml
Type: String
Parameter Sets: byQuery
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -requestState
Return only requests in this state.

```yaml
Type: String
Parameter Sets: byFilterCriteria
Aliases: 
Accepted values: STARTING, RUNNING, PENDING, FINISHED, EXPIRED

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -requestResult
Return only requests with this result.

```yaml
Type: String
Parameter Sets: byFilterCriteria
Aliases: 
Accepted values: APPROVED, REJECTED, CANCELED, FAILED, UNKNOWN

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -createdBy
Return only requests raised by this user.

```yaml
Type: String
Parameter Sets: byFilterCriteria
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -updatedBy
Return only requests last updated by this user.

```yaml
Type: String
Parameter Sets: byFilterCriteria
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -createdAfter
Return only requests created on or after this time.

```yaml
Type: DateTime
Parameter Sets: byFilterCriteria
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -createdBefore
Return only requests created on or before this time.

```yaml
Type: DateTime
Parameter Sets: byFilterCriteria
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -freeText
A free text search term applied to the retrieved requests.

```yaml
Type: String
Parameter Sets: byQuery, byFilterCriteria
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -limit
The maximum number of requests to return per request, up to 1000. The service returns 50 when not specified.

```yaml
Type: Int32
Parameter Sets: byQuery, byFilterCriteria
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -offset
The number of requests to skip before returning results.

```yaml
Type: Int32
Parameter Sets: byQuery, byFilterCriteria
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -requestRole
Return only the requests where you hold this role. Requests for both roles are returned when not specified.

```yaml
Type: String
Parameter Sets: byQuery, byFilterCriteria
Aliases: 
Accepted values: CREATOR, APPROVER

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -sort
The fields to sort the results by, in order. Sortable fields are `createdAt`, `calculatedRequestStartTime` and `updatedAt`. Ascending when not specified.

```yaml
Type: String
Parameter Sets: byQuery, byFilterCriteria
Aliases: 

Required: False
Position: Named
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
