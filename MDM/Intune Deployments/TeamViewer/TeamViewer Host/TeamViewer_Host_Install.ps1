# Variables
$FileName = "TeamViewer_Host.msi"
$MSIPath = [System.IO.Path]::Combine($PSScriptRoot, $FileName)
$SettingName = "TV_Config.tvopt"
$SettingPath = [System.IO.Path]::Combine($PSScriptRoot, $SettingName)

$AssignmentID = "Place Assignment Id here"
$ConfigID = "Place Config ID here"
$ConfigString = "CUSTOMCONFIGID={0}" -f $ConfigID
$SettingsFile = "SETTINGSFILE=`"{0}`"" -f $SettingPath


#Write-Output $MSIPath
try {
    $InstallStr = "/i `"{0}`" /qn {1} {2}" -f $MSIPath, $ConfigString, $SettingsFile
    Start-Process "msiexec.exe" -ArgumentList $InstallStr -Wait -ErrorAction Stop
    Start-Sleep -Seconds 30
    Start-Process "C:\Program Files\TeamViewer\TeamViewer.exe" -ArgumentList "assignment --id $AssignmentID"
}
catch {
    # prints out error message to txt file
    $_.Exception.Message, $_.CategoryInfo, $_.FullyQualifiedErrorId, ($_.ScriptStackTrace -replace '^'), $Error[0].Exception.GetType().FullName | out-file -filepath "C:\IntuneUserLogs\TV_Host_ErrorMessage.txt"
}
