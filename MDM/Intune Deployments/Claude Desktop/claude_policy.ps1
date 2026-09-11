<#
.SYNOPSIS
    Applies Claude Desktop enterprise registry policies.
    Standalone script deployed separately in Intune — run independently of the install script.
    Safe to re-run at any time to update or restore policy values.
    Deploy via Intune in SYSTEM context, 64-bit PowerShell.
#>
 
[CmdletBinding()]
param()
 
$ErrorActionPreference = "Stop"
$LogPath = "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\Claude-Policy.log"
 
function Write-Log {
    param([string]$Message)
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$ts  $Message" | Tee-Object -FilePath $LogPath -Append | Write-Verbose
}
 
Write-Log "Applying Claude Desktop enterprise policies..."
 
$regPath = "HKLM:\SOFTWARE\Policies\Claude"
New-Item -Path $regPath -Force | Out-Null
 
# Auto-updates ON — Claude self-manages, no IT involvement needed
Set-ItemProperty -Path $regPath -Name "disableAutoUpdates"                  -Value 0  -Type DWord
# Notify users and enforce restart within 72 hours
Set-ItemProperty -Path $regPath -Name "autoUpdaterEnforcementHours"         -Value 72 -Type DWord
 
# Cowork — requires Virtual Machine Platform to be enabled
Set-ItemProperty -Path $regPath -Name "secureVmFeaturesEnabled"             -Value 1  -Type DWord
 
# Extensions — do NOT set these to 0 if using the in-app allowlist
Set-ItemProperty -Path $regPath -Name "isDesktopExtensionEnabled"           -Value 1  -Type DWord
Set-ItemProperty -Path $regPath -Name "isDesktopExtensionDirectoryEnabled"  -Value 1  -Type DWord
 
# MCP servers and Claude Code
Set-ItemProperty -Path $regPath -Name "isLocalDevMcpEnabled"                -Value 1  -Type DWord
Set-ItemProperty -Path $regPath -Name "isClaudeCodeForDesktopEnabled"       -Value 1  -Type DWord
 
Write-Log "All policies applied successfully."
Write-Output "Claude policies applied."
exit 0