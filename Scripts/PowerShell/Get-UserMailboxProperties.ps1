# This script retrieves all the properties of a user's Excahnge mailbox.

Connect-ExchangeOnline -UserPrincipalName "ADMIN@EMAIL.COM" # Replace with Admin UPN.

$User = "USER@EMAIL.COM"  # Replace with the actual user UPN

# Get mailbox properties
$Mailbox = Get-Mailbox -Identity $User
# Get mailbox statistics
$Stats = Get-MailboxStatistics -Identity $User

# Display properties in Format-List
Write-Host "`nMailbox Properties for $User`n"
$Mailbox | Format-List DisplayName,PrimarySmtpAddress,RecipientTypeDetails,MailboxPlan,ProhibitSendQuota,ProhibitSendReceiveQuota,IssueWarningQuota,ArchiveStatus,RetentionPolicy,LitigationHoldEnabled

Write-Host "`nMailbox Statistics for $User`n"
$Stats | Format-List DisplayName,TotalItemSize,ItemCount,LastLogonTime
