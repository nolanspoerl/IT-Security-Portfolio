# These commands find the mail delegates assocaited with a user.
# Run each command one at a time. Connect to Exchange first.

Connect-ExchangeOnline

$user = "user@domain.com"
Write-Host "`n=== Send As Delegates ===" -ForegroundColor Cyan
Get-RecipientPermission $user |
Where-Object {
    $_.AccessRights -contains "SendAs" -and
    $_.Trustee -notmatch "NT AUTHORITY"
} |
Select Trustee, AccessRights


$user = "user@domain.com"
Write-Host "`n=== Full Access Delegates ===" -ForegroundColor Cyan
Get-MailboxPermission $user |
Where-Object {
    $_.IsInherited -eq $false -and
    $_.User -notlike "NT AUTHORITY\SELF"
} |
Select User, AccessRights


$user = "user@domain.com"
Write-Host "`n=== Send on Behalf Delegates ===" -ForegroundColor Cyan
(Get-Mailbox $user).GrantSendOnBehalfTo |
Select Name
