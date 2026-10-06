# AXIS Camera Station Client Chocolatey Package
![Chocolatey Version](https://img.shields.io/chocolatey/v/axis-camera-station-client?label=chocolatey)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/gitwerk/chocolatey-axis-camera-station-package/main.yml)

This repository contains the source of a Chocolatey package that installs and updates the [AXIS Camera Station 5](https://www.axis.com/products/axis-camera-station) client (client only, no server). The installer is the official client MSI from Axis; the package downloads it and verifies its SHA256 checksum.

## Installation
```bash
choco upgrade axis-camera-station-client
```

### Package parameters
| Parameter | Effect |
|---|---|
| `/Telemetry` | Allow Axis to collect usage data (off by default) |
| `/DisableTls` | Let the installer turn off TLS 1.0/1.1 system-wide, after a reboot (off by default) |
| `/NoFirewall` | Don't create Windows Firewall rules |
| `/NoDesktopShortcut` | Don't create a desktop shortcut |

```bash
choco upgrade axis-camera-station-client --params "'/NoDesktopShortcut'"
```

The client is never started after a silent install. The installer language is detected from the system's regional settings. Chocolatey does not remember package parameters on upgrade unless `useRememberedArgumentsForUpgrades` is enabled:

```bash
choco feature enable -n useRememberedArgumentsForUpgrades
```

These parameters map to the MSI properties documented by Axis in [Installation parameters – AXIS Camera Station Microsoft installer](https://www.axis.com/dam/public/76/4b/d4/installation-parameters-microsoft-installer-en-GB+en-US-416222.pdf).

## Updating the package
1. Look up the new version in https://www.axis.com/ftp/pub_soft/cam_srv/cam_station/latest/ver.txt (e.g. `5.59.56000`). Axis publishes each release in a versioned folder such as `.../cam_station/5_59_56000/AXISCameraStationClient_5.59.56000.msi`.
2. Download the client MSI and compute its checksum:
   ```powershell
   Get-FileHash .\AXISCameraStationClient_5.59.56000.msi -Algorithm SHA256
   ```
3. Update `$version` and `$checksum` in `tools/chocolateyinstall.ps1`.
4. Commit, then tag the commit with the same version and push it with the tag:
   ```bash
   git commit -am "Update to 5.59.56000"
   git tag 5.59.56000
   git push
   git push origin 5.59.56000
   ```

GitHub Actions builds the package and publishes it to Chocolatey when the tag is pushed. You can also run the workflow by hand (`workflow_dispatch`) with a tag.

## Contributing
Issues and pull requests are welcome.
