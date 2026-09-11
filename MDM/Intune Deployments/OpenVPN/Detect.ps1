$possibleRoots = @(
    (Get-ItemProperty -Path "HKLM:\SOFTWARE\OpenVPN" -ErrorAction SilentlyContinue).InstallLocation,
    (Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\OpenVPN" -ErrorAction SilentlyContinue).InstallLocation,
    Join-Path $env:ProgramFiles "OpenVPN",
    Join-Path ${env:ProgramFiles(x86)} "OpenVPN"
) | Where-Object { $_ -and (Test-Path $_) } | Select-Object -Unique

$found = $false
foreach ($root in $possibleRoots) {
    if (Test-Path (Join-Path $root "config\YourConfigFile.ovpn")) { $found = $true; break }
    if (Test-Path (Join-Path $root "config-auto\YourConfigFile.ovpn")) { $found = $true; break }
}

if ($found) { exit 0 } else { exit 1 }