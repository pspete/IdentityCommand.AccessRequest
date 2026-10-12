# Change Log

All notable changes to this project will be documented in this file.

## Unreleased

### Added

- Commands find the Access Requests service url from the `IdentityCommand` session on first use, so no connection step is needed after `New-IDSession` or `New-IDPlatformToken`. Commands follow a later `New-IDSession` or `New-IDPlatformToken`, and fail after `Close-IDSession` until you authenticate again.

### Changed

- CI caches the PowerShell modules it installs, so dependency installs skip the PowerShell Gallery on a cache hit.

### Removed

- `Connect-ARTenant`. Authenticate with `New-IDSession` or `New-IDPlatformToken` from `IdentityCommand` instead.

## [0.1.0] - 2026-10-07

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

