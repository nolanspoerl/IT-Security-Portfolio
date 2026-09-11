$serial = (Get-CimInstance Win32_BIOS).SerialNumber
Write-Output $serial
exit 1  # exit 1 = "detected issue" = output shows in portal