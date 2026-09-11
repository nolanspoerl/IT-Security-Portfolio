
# OpenVPN - Microsoft Intune Deployment

This package demonstrates the deployment of **OpenVPN** to Windows endpoints using Microsoft Intune as a Win32 application.

## Package Contents Needed

- `OpenVPN.msi` - OpenVPN installer (not provided here, can be found on their site).
- `OpenVPNInstall.ps1` - PowerShell installation/configuration script (provided here). **You must replace the two names specific to your OpenVPN installer and .ovpn file here FIRST.**
- `CompanyVPN.ovpn` - OpenVPN configuration profile (your specific OpenVPN config file for your environment).

## Creating the Intune Package

Place the PowerShell script, `.ovpn` configuration file, and OpenVPN `.msi` installer in the same source directory.

Use the **Microsoft Win32 Content Prep Tool (`IntuneWinAppUtil.exe`)** to package the deployment files.

The utility packages the source directory into an `.intunewin` file that can be uploaded to Microsoft Intune as a **Windows app (Win32)**.

## Deployment Process

1. Download the appropriate OpenVPN MSI installer.
2. Add the `.msi`, PowerShell installation script, and `.ovpn` configuration file to the source directory.
3. Run `IntuneWinAppUtil.exe` to create the `.intunewin` package.
4. Upload the package to Microsoft Intune.
5. Configure the PowerShell script as the installation command.
6. Configure application requirements and detection rules (Use the detection script I have here. Make sure to replace 'YourConfigFile' with the one in your environment).
7. Assign the application to the appropriate device/user groups.
8. Test and validate the deployment before production rollout.
