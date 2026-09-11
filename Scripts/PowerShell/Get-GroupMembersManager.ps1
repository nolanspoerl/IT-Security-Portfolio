# This script pulls the manager for each member of a group in Entra ID. Just specify the group ID and the CSV Path.



$GroupId = "GROUP ID HERE"
$CsvPath = "C:\PowerShell Exports\GroupMembersManager.csv"

Connect-MgGraph

$members = Get-MgGroupMember -GroupId $GroupId -All |
    Where-Object { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.user' }

$result = foreach ($m in $members) {

    # Get user and expand manager
    $u = Get-MgUser -UserId $m.Id -Property UserPrincipalName -ExpandProperty Manager

    # Default response
    $managerUPN = "No manager assigned"

    # If manager exists, pull the UPN
    if (
        $u.Manager -and
        $u.Manager.AdditionalProperties.ContainsKey("userPrincipalName")
    ) {
        $managerUPN = $u.Manager.AdditionalProperties["userPrincipalName"]
    }

    [pscustomobject]@{
        UserUPN    = $u.UserPrincipalName
        ManagerUPN = $managerUPN
    }
}

$ExportDir = Split-Path $CsvPath -Parent
if (-not (Test-Path $ExportDir)) {
    New-Item -ItemType Directory -Path $ExportDir | Out-Null
}

$result |
    Select-Object UserUPN, ManagerUPN |
    Export-Csv -Path $CsvPath -NoTypeInformation -Encoding UTF8

Write-Host "Export complete: $CsvPath" -ForegroundColor Green