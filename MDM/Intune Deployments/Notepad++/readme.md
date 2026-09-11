
# Notepad++ - Microsoft Intune Deployment

This package demonstrates deploying **Notepad++** to Windows devices using Microsoft Intune as a Win32 application.

## Package Contents

- `Install.ps1` - Installation script
- `Uninstall.ps1` - Uninstallation script
- `IntuneCommands.txt` - Intune install/uninstall commands
- `Installer.exe` - Notepad++ installer (not included)

## Deployment

1. Download the current Notepad++ installer from the official Notepad++ website.
2. Place the installer in the same folder as the PowerShell scripts.
3. Replace `Installer.exe` references with the **actual downloaded installer filename**.
4. Use Microsoft's **Intune Win32 Content Prep Tool (`IntuneWinAppUtil.exe`)** to wrap the deployment files into an `.intunewin` package.
5. Upload the resulting `.intunewin` file to Intune as a **Windows app (Win32)**.
6. Configure the appropriate detection rules and assignments.
7. Use the install and uninstall commands provided in `IntuneCommands.txt`.

## Notes

The Notepad++ installer has been intentionally removed from this repository. Download the appropriate installer directly from the official Notepad++ website before creating the deployment package.

The `.intunewin` package is also excluded, as it should be generated from the deployment source files using the Microsoft Win32 Content Prep Tool.
