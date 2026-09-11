<#
.SYNOPSIS
    Downloads and installs the latest Claude Desktop MSIX.
    Enables Cowork via Virtual Machine Platform.
    Deploy via Intune in SYSTEM context, 64-bit PowerShell.
    NOTE: Registry policies are applied separately via claude_policy.ps1.
#>
 
[CmdletBinding()]
param()
 
$ErrorActionPreference = "Stop"
$LogPath = "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\Claude-Install.log"
 
function Write-Log {
    param([string]$Message)
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$ts  $Message" | Tee-Object -FilePath $LogPath -Append | Write-Verbose
}
 
# ── 1. Virtual Machine Platform (required for Cowork) ──────────────────
Write-Log "Checking Virtual Machine Platform..."
$vmp = Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
if ($vmp.State -ne "Enabled") {
    Write-Log "Enabling Virtual Machine Platform..."
    Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All -NoRestart
    Write-Log "Enabled. Reboot may be required."
} else {
    Write-Log "Virtual Machine Platform already enabled."
}
 
# ── 2. Architecture detection ───────────────────────────────────────────
$arch = if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64") { "arm64" } else { "x64" }
$msixUrl = "https://claude.ai/api/desktop/win32/$arch/msix/latest/redirect"
Write-Log "Architecture: $arch"
 
# ── 3. Download latest MSIX ─────────────────────────────────────────────
$tmpFile = Join-Path $env:TEMP "Claude_latest_$arch.msix"
Write-Log "Downloading from $msixUrl..."
# Use system proxy and increase timeout to handle corporate proxy/firewall in SYSTEM context
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$webClient = New-Object System.Net.WebClient
$webClient.Proxy = [System.Net.WebRequest]::GetSystemWebProxy()
$webClient.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
try {
    $webClient.DownloadFile($msixUrl, $tmpFile)
    Write-Log "Download complete. Size: $((Get-Item $tmpFile).Length) bytes"
} catch {
    Write-Log "Download failed: $_"
    exit 1
}
 
# ── 4. Machine-wide provisioned install (all users, no per-user step) ──
Write-Log "Provisioning Claude Desktop for all users..."
Add-AppxProvisionedPackage -Online -PackagePath $tmpFile -SkipLicense -Regions "all"
Write-Log "Provisioning complete."
 
# ── 5. Cleanup ──────────────────────────────────────────────────────────
Remove-Item $tmpFile -Force -ErrorAction SilentlyContinue
Write-Log "Install complete. Deploy claude_policy.ps1 separately to apply enterprise policies."