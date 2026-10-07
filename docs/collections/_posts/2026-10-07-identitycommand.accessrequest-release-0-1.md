---
title: "IdentityCommand.AccessRequest Release 0.1"
date: 2026-10-07 00:00:00
version: 0.1.0
tags:
  - Release Notes
  - Connect-ARTenant
  - Get-ARRequest
  - Get-ARRequestForm
  - New-ARRequest
  - Stop-ARRequest
  - Approve-ARRequest
  - Deny-ARRequest
  - Get-ARModuleData
---

## [0.1.0]

### Added

- Initial release of `IdentityCommand.AccessRequest`, wrapping the CyberArk Access Request API.
- `Connect-ARTenant`: authenticate to the Access Requests service, resolving the service url from a
  shared services subdomain via platform discovery, or from a url supplied directly.
- `Get-ARRequest`: get a single access request by id, or a filtered list. Filter criteria
  (`-requestState`, `-requestResult`, `-createdBy`, `-updatedBy`, `-createdAfter`, `-createdBefore`)
  are assembled into the service's filter expression; `-filter` takes an expression directly.
  Results are paginated automatically.
- `Get-ARRequestForm`: get the form structure - questions, types and validation rules - for a target
  category and request type.
- `New-ARRequest`: raise an access request.
- `Stop-ARRequest`: cancel an open access request.
- `Approve-ARRequest`, `Deny-ARRequest`: finalize a request assigned to you as an approver.
- `Get-ARModuleData`: get the module version and session configuration data.
