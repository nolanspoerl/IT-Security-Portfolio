# -------------------------------
>> # Config
>> # -------------------------------
>> $SourcePath = Join-Path $env:APPDATA "SAP"
>>
>> # Get OneDrive path from registry (more reliable than $env:OneDrive)
>> $OneDrivePath = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\OneDrive" `
>>     -Name "UserFolder" -ErrorAction SilentlyContinue).UserFolder
>>
>> # Fallback to environment variable if registry lookup fails
>> if ([string]::IsNullOrEmpty($OneDrivePath)) {
>>     $OneDrivePath = $env:OneDriveCommercial
>> }
>> if ([string]::IsNullOrEmpty($OneDrivePath)) {
>>     $OneDrivePath = $env:OneDrive
>> }
>>
>> $DestinationRoot = Join-Path $OneDrivePath "SAP Backup"
>> $DestinationPath = Join-Path $DestinationRoot "SAP"
>>
>> # -------------------------------
>> # Validate SAP source folder
>> # -------------------------------
>> if (!(Test-Path $SourcePath)) {
>>     Write-Output "SAP source folder not found. Nothing to back up."
>>     exit 0
>> }
>>
>> # -------------------------------
>> # Create destination folder
>> # -------------------------------
>> if (!(Test-Path $DestinationRoot)) {
>>     New-Item -ItemType Directory -Path $DestinationRoot | Out-Null
>> }
>>
>> # -------------------------------
>> # Copy only if not already backed up
>> # -------------------------------
>> $Copied = $false
>>
>> if (!(Test-Path $DestinationPath)) {
>>     Copy-Item -Path $SourcePath -Destination $DestinationPath -Recurse -Force
>>     $Copied = $true
>> }
>>
>> # -------------------------------
>> # User Notification (WScript Popup)
>> # -------------------------------
>> if ($Copied -eq $true) {
>>
>>     Start-Sleep -Seconds 30
>>
>>     $wshell = New-Object -ComObject WScript.Shell
>>     $wshell.Popup(
>>         "SAP files backup completed to OneDrive > SAP Backup!",
>>         10,
>>         "Backup Complete",
>>         64
>>     )
>> }