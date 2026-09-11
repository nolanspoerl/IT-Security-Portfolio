<#
.SYNOPSIS
    Fully removes Claude Desktop from all users.
    Cleans provisioned packages, registry policies, user data,
    and Start Menu shortcuts. Deploy via Intune in SYSTEM context.
#>
 
[CmdletBinding()]
param()
 
$ErrorActionPreference = "SilentlyContinue"
$LogPath = "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\Claude-Uninstall.log"
 
function Write-Log {
    param([string]$Message)
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$ts  $Message" | Tee-Object -FilePath $LogPath -Append | Write-Verbose
}
 
Write-Log "Starting Claude Desktop uninstall..."
 
# ── 1. Kill running Claude processes ────────────────────────────────────
Write-Log "Stopping Claude processes..."
Get-Process -Name "Claude*" -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Log "Stopping: $($_.Name) (PID $($_.Id))"
    $_ | Stop-Process -Force
}
Start-Sleep -Seconds 2
 
# ── 2. Remove provisioned package (stops new users getting it) ──────────
Write-Log "Removing provisioned package..."
Get-AppxProvisionedPackage -Online |
    Where-Object { $_.DisplayName -like "*Claude*" } |
    ForEach-Object {
        Write-Log "Removing provisioned: $($_.DisplayName)"
        Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName -AllUsers
    }
 
# ── 3. Remove installed package for all existing users ───────────────────
Write-Log "Removing installed packages for all users..."
Get-AppxPackage -AllUsers |
    Where-Object { $_.Name -like "*Claude*" } |
    ForEach-Object {
        Write-Log "Removing: $($_.Name) v$($_.Version)"
        Remove-AppxPackage -Package $_.PackageFullName -AllUsers
    }
 
# ── 4. Remove enterprise registry policies ───────────────────────────────
Write-Log "Removing registry policies..."
$regPath = "HKLM:\SOFTWARE\Policies\Claude"
if (Test-Path $regPath) {
    Remove-Item -Path $regPath -Recurse -Force
    Write-Log "Registry key removed."
}
 
# ── 5. Remove per-user app data for all profiles ─────────────────────────
Write-Log "Cleaning user profile data..."
$userProfiles = Get-ChildItem "C:\Users" -Directory -ErrorAction SilentlyContinue
foreach ($profile in $userProfiles) {
    $paths = @(
        "$($profile.FullName)\AppData\Roaming\Claude"
        "$($profile.FullName)\AppData\Local\Claude"
        "$($profile.FullName)\AppData\Local\Packages\AnthropicPBC.Claude*"
    )
    foreach ($p in $paths) {
        Get-Item $p -ErrorAction SilentlyContinue | ForEach-Object {
            Write-Log "Removing: $($_.FullName)"
            Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}
 
# ── 6. Remove shared program data ────────────────────────────────────────
$sharedPaths = @("$env:ProgramData\Claude", "$env:ProgramData\AnthropicPBC")
foreach ($p in $sharedPaths) {
    if (Test-Path $p) {
        Write-Log "Removing shared data: $p"
        Remove-Item $p -Recurse -Force -ErrorAction SilentlyContinue
    }
}
 
# ── 7. Remove Start Menu shortcuts ───────────────────────────────────────
$startMenuPaths = @(
    "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Claude*"
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Claude*"
)
foreach ($p in $startMenuPaths) {
    Get-Item $p -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Log "Removing shortcut: $($_.FullName)"
        Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
    }
}
 
Write-Log "Uninstall complete."
Write-Output "Claude Desktop uninstalled successfully."
exit 0