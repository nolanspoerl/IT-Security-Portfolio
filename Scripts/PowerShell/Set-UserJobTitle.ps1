# This script bulk changes user's job titles in Entra ID by pulling from a CSV.
# Create a CSV with Column A=UserPrincipalName and column B=JobTitle.

Connect-MgGraph -Scopes "User.ReadWrite.All"

# Import CSV
$users = Import-Csv "pathToCSVHere"

foreach ($user in $users) {
    Write-Host "Updating $($user.UserPrincipalName) to '$($user.JobTitle)'..."

    Update-MgUser `
        -UserId $user.UserPrincipalName `
        -JobTitle $user.JobTitle
}