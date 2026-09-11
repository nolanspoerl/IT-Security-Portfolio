
# TeamViewer Host - Microsoft Intune Deployment

This project demonstrates deploying **TeamViewer Host** to Windows endpoints using Microsoft Intune as a Win32 application. This is an example and how-to deploy as the files provided are different for each teamviewer environment.

## Package Contents

A typical deployment package may contain:

- `TeamViewer_Host.msi` - TeamViewer Host installer
- `TeamViewer_Host_Install.ps1` - Installation and assignment script
- `TV_Config.tvopt` - Optional TeamViewer configuration file from an existing teamviewer host.

## Configuration

Before using the deployment, update the template values to match your environment.

### TeamViewer Host Install Script

Fill in the appropriate values for:

- **Installer file name** - Update `$FileName` if your MSI uses a different filename.
- **Configuration file name** - Update `$SettingName` if you use a different `.tvopt` filename.
- **TeamViewer Assignment ID** - Replace `$AssignmentID` with your organization's assignment ID.
- **TeamViewer Configuration ID** - Replace `$ConfigID` with your organization's configuration ID.

Example:

```powershell
$FileName = "TeamViewer_Host.msi"
$SettingName = "TV_Config.tvopt"

$AssignmentID = "<YOUR-TEAMVIEWER-ASSIGNMENT-ID>"
$ConfigID = "<YOUR-TEAMVIEWER-CONFIG-ID>"
```

The installer, configuration file, and PowerShell script should be placed in the same package directory when the script references them using `$PSScriptRoot`.

## Intune Deployment

Typical deployment steps:

1. Download the appropriate TeamViewer Host MSI from your management console.
2. Place the MSI and required PowerShell/configuration files in the deployment source folder.
3. Fill in the required Assignment ID, Configuration ID, and file names.
4. Test the installation and configuration in a lab or test environment.
5. Use the Microsoft Win32 Content Prep Tool to create the `.intunewin` package.
6. Upload the package to Microsoft Intune as a **Windows app (Win32)**.
7. Configure the install command and detection rules.
8. Assign the application to a test group.
9. Validate installation, configuration, and TeamViewer assignment.
10. Deploy to production after successful testing.

## Example Package Structure

```text
TeamViewer_Host/
├── TeamViewer_Host.msi
├── TeamViewer_Host_Install.ps1
├── Push-TVConfig.ps1
└── TV_Config.tvopt
```

## Security & Privacy

This example is intended for portfolio and lab use.

> **Note:** TeamViewer deployment parameters and configuration options can vary by product and version. Validate the deployment against the TeamViewer version being used before production deployment.
