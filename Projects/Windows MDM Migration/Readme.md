# Intune Tenant-to-Tenant Device Migration (Workspace ONE/domain joined → Intune)

Automates moving Windows devices from **Workspace ONE (AirWatch)** and **on-prem Active Directory** to **Entra ID + Intune**, with no manual steps for the end user. The user's existing profile, files and settings are kept and handed over to their new cloud account.

Based on the open-source Intune Device Migration solution by **Steve Weiner**, adapted to remove Workspace ONE enrollment and to unjoin the domain. His work can be found here: https://stevecapacity.github.io/intune-device-migration-documentation/.

**All sensitive data has been redacted.**

## End-user experience

1. A lock screen message tells the user the device is being migrated and will reboot.
2. The device reboots automatically, sometimes more than once.
3. The user signs in with their new email address.
4. Their desktop, files and settings are exactly as they left them. Company Portal is installed and the device is managed by Intune.

No IT visit, re-imaging or profile copy is needed.

## How it works

| Stage | Script | Runs | What it does |
|---|---|---|---|
| 1 | `startMigrate.ps1` | On deployment (SYSTEM) | Collects device and user info, finds the user in the target tenant, removes Workspace ONE, unjoins the domain, installs the provisioning package, schedules the next stages, reboots |
| 2 | `reboot.ps1` | At boot (SYSTEM) | Assigns the existing user profile to the new Entra account, cleans cached identities, restores normal sign-in, reboots |
| 3 | `postMigrate.ps1` | At first user sign-in (SYSTEM) | Sets the Intune primary user and group tag, handles BitLocker, registers the device in Autopilot, installs Company Portal, cleans up |

### What gets removed
- **Workspace ONE / AirWatch:** Intelligent Hub, the SFD agent, the AirWatch app, enrollment registry keys, scheduled tasks, certificates and data folders.
- **Active Directory:** the device is unjoined from the domain using a temporary local admin account. `postMigrate.ps1` deletes that account at the end.

### What gets added
- **Entra join + Intune enrollment** through a provisioning package (PPKG) with a bulk enrollment token.
- **Autopilot registration** in the target tenant, so future resets go through Autopilot.
- **Company Portal**, installed silently.

## Files

| File | Purpose |
|---|---|
| `startMigrate.ps1` | Entry point and main migration logic |
| `reboot.ps1` / `reboot.xml` | Profile handover script and its boot-time scheduled task |
| `postMigrate.ps1` / `postMigrate.xml` | Final configuration script and its sign-in scheduled task |
| `userFinder.xml` | Fallback task that prompts the user to sign in if their account can't be matched automatically |
| `config.example.json` | Template for your settings. Copy it to `config.json` |

### Not included (supply your own)
- **Provisioning package (`.ppkg`):** build it in Windows Configuration Designer with a bulk enrollment token for your tenant. **Never commit it.** It can enroll devices into your tenant.
- **`Company Portal Installer.exe`:** download it from Microsoft and place it in the package folder.
- **`config.json`:** holds your tenant details and app secret. **Never commit it.**

## Configuration

```json
{
  "localPath": "C:\\ProgramData\\IntuneMigration",
  "logPath": "C:\\ProgramData\\IntuneMigration\\Logs",
  "regPath": "HKLM\\SOFTWARE\\IntuneMigration",
  "groupTag": "",
  "bitlocker": "MIGRATE",
  "targetTenant": {
    "tenantName": "<target-tenant>.onmicrosoft.com",
    "clientId": "<app-registration-client-id>",
    "clientSecret": "<app-registration-secret>"
  }
}
```

- `bitlocker`: `MIGRATE` backs up the recovery key to Entra ID. `DECRYPT` turns BitLocker off.
- `groupTag`: the Autopilot group tag to apply. Leave it empty to carry over the existing one.

**App registration:** the Graph application permissions needed to read users and devices, update devices and manage Intune/Autopilot devices (for example `User.Read.All`, `Device.ReadWrite.All`, `DeviceManagementManagedDevices.ReadWrite.All`, `DeviceManagementServiceConfig.ReadWrite.All`).

## Deployment

1. Put the scripts, XML files, `config.json`, the `.ppkg` and the Company Portal installer in one folder.
2. Package and deploy it to target devices. Run it in 64-bit PowerShell:
   ```
   %WinDir%\Sysnative\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File startMigrate.ps1
   ```
3. Logs are written to the `logPath` set in `config.json`.

## Notes
- Test on a small pilot group first.
- Rotate the app secret after each migration wave.
- The migration folder, scheduled tasks and temporary admin account are removed automatically when the migration finishes.
