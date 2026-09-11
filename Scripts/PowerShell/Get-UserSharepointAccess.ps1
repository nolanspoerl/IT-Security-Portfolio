# This script pulls the sharepoint sites that a specific user has access to. 

Connect-SPOService

# user you want to chcek.

>> $userEmail = "user@email.com"
>>
>> Write-Host "Checking SharePoint access for:" $userEmail
>> Write-Host "----------------------------------------"
>>
>> # Get all sites (excluding OneDrive)
>> $sites = Get-SPOSite -Limit All | Where-Object {
>>     $_.Url -notlike "*-my.sharepoint.com*"
>> }
>>
>> $results = @()
>>
>> foreach ($site in $sites) {
>>     try {
>>         # Try to get the user from the site
>>         $user = Get-SPOUser -Site $site.Url -LoginName $userEmail -ErrorAction SilentlyContinue
>>
>>         if ($user) {
>>             $results += [PSCustomObject]@{
>>                 SiteTitle = $site.Title
>>                 SiteUrl   = $site.Url
>>                 Login     = $user.LoginName
>>                 Groups    = ($user.Groups -join ", ")
>>             }
>>         }
>>     }
>>     catch {
>>         Write-Host "Skipped:" $site.Url
>>     }
>> }
>>
>> # Output
>> if ($results.Count -eq 0) {
>>     Write-Host "No site access found."
>> } else {
>>     $results | Format-Table -AutoSize
>> }
