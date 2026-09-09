#The completer helper functions live in IdentityCommand's Private folder, which the psm1 loads
#into this module's scope.

#region Registration

#Requests are identified by an opaque uuid, so label the completion with the target category and
#state rather than leaving the caller to recognise the id.
Register-ArgumentCompleter -ParameterName 'requestId' -ScriptBlock (
    Get-ArgumentCompleter -RetrievalCommand 'Get-ARRequest' -ValueProperty 'requestId' -LabelProperty 'requestState'
) -CommandName @(
    'Approve-ARRequest'
    'Deny-ARRequest'
    'Get-ARRequest'
    'Stop-ARRequest'
)

#endregion Registration
