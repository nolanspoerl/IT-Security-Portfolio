
This package is used to bulk update device ownership status from Personal to Corporate.

1. Export a .CSV file from Intune with your Device Id's to be converted from Personal to Corp (use the filter in UI).
2. Format CSV file similar to the one here.
3. Use the IntuneWinAppUtility to wrap up all files.
4. Set install command to Start-ConvertToCorporate.ps1 in Intune.

This work is based off the original contributor: https://github.com/jmanuelng/MEM_ConvertToCorporate
