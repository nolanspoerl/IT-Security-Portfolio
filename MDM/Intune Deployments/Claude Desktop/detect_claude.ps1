# Detection script — returns exit 0 (detected) or exit 1 (not detected)
$pkg = Get-AppxPackage -AllUsers | Where-Object { $_.Name -like "*Claude*" }
if ($pkg) {
    Write-Output "Claude Desktop detected: $($pkg.Version)"
    exit 0
} else {
    exit 1
}