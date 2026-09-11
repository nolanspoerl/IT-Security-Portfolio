# Set file names
$MsiFile   = "YourOpenVPNInstaller.msi"
$OvpnFile  = "YourConfigFile.ovpn"

# Get the folder where the script is running
$SourcePath = Split-Path -Parent $PSCommandPath

# Build full paths
$MsiPath  = Join-Path $SourcePath $MsiFile
$OvpnPath = Join-Path $SourcePath $OvpnFile

# OpenVPN config directory
$ConfigDir = "C:\Program Files\OpenVPN\config"

# Create config directory if missing
if (!(Test-Path $ConfigDir)) {
    New-Item -Path $ConfigDir -ItemType Directory -Force | Out-Null
}

# Install MSI silently
Start-Process "msiexec.exe" -ArgumentList "/i `"$MsiPath`" /qn /norestart" -Wait

# Copy the OVPN file
Copy-Item -Path $OvpnPath -Destination $ConfigDir -Force
