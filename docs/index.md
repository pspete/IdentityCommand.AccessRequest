---
title: IdentityCommand.AccessRequest
subtitle: PowerShell for Idira Access Requests
hide_hero: true
---

<div class="has-text-centered mb-6">
  <img src="{{ '/AccessRequest/media/images/IdentityCommand.AccessRequest.png' | relative_url }}" alt="IdentityCommand.AccessRequest" width="471">
</div>

**IdentityCommand.AccessRequest** is a PowerShell module that provides a set of easy-to-use commands, allowing you to interact with the **Idira Access Request API** from within the PowerShell environment.

It builds on [IdentityCommand]({{ '/' | relative_url }}) for authentication - see [Getting Started]({{ '/AccessRequest/getting-started/' | relative_url }}) to install and connect, and the [command reference]({{ '/AccessRequest/commands/' | relative_url }}) for every command.

## Access Requests

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

## Raising a Request

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

## Approving and Rejecting

Requests assigned to you as an approver are handled with `Approve-ARRequest` and `Deny-ARRequest`. Once one assigned approver has handled a request, no other can:

```powershell
Approve-ARRequest -requestId $id -finalizationReason 'All requirements met'

Get-ARRequest -requestState PENDING -requestRole APPROVER | Deny-ARRequest -finalizationReason 'Raise a change record first'
```
