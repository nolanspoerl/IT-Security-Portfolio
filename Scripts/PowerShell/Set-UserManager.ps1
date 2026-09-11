# This script bulk updates user's manager in Entra ID. Currently not available using the bulk update feature in Entra ID, so PowerShell is needed. Must have Microsoft Graph Powershell SDK installed. Have CSV Formatted with Column A named UserUPN with user's UPN and Column B named ManagerUPN with UPN of their manager.

# Connect to Graph using a Global Admin account or User Admin account.
Connect-MgGraph

$csvPath = "*PATH TO CSV HERE (ex: C:\TEMP\Managers.csv)*"
$users = Import-Csv $csvPath

foreach ($row in $users) {

    if ([string]::IsNullOrWhiteSpace($row.ManagerUPN)) {
        Write-Host "Skipping $($row.UserUPN) – no manager listed" -ForegroundColor Yellow
        continue
    }

    try {
        $user = Get-MgUser -UserId $row.UserUPN -ErrorAction Stop
        $manager = Get-MgUser -UserId $row.ManagerUPN -ErrorAction Stop

        Set-MgUserManagerByRef `
            -UserId $user.Id `
            -BodyParameter @{
                "@odata.id" = "https://graph.microsoft.com/v1.0/users/$($manager.Id)"
            }

        Write-Host "Set manager for $($row.UserUPN) → $($row.ManagerUPN)" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed for $($row.UserUPN): $($_.Exception.Message)" -ForegroundColor Red
    }
}