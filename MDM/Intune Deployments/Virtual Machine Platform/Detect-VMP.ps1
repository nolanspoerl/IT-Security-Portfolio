$feature = Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform

if ($feature.State -eq 'Enabled') {
    Write-Output "VirtualMachinePlatform is enabled"
    exit 0
} else {
    exit 1
}