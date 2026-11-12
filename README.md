# AXIS Camera Station Pro Client Chocolatey Package
![Chocolatey Version](https://img.shields.io/chocolatey/v/axis-camera-station-pro-client?label=chocolatey)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/gitwerk/chocolatey-axis-camera-station-pro-package/main.yml)

This repository contains the source of a Chocolatey package that installs and updates the [AXIS Camera Station Pro](https://www.axis.com/products/axis-camera-station-pro) client (client only, no server). The installer is the official client MSI from Axis; the package downloads it and verifies its SHA256 checksum.

> **AXIS Camera Station 5 vs. Pro:** Pro uses the same Windows Installer upgrade code as the AXIS Camera Station 5 client, so installing this package upgrades an existing ACS 5 client to Pro. The ACS 5 client is packaged separately as [`axis-camera-station-client`](https://github.com/gitwerk/chocolatey-axis-camera-station-package). Don't install both on the same machine.

## Installation
Axis only provides the installer after its [license agreement](https://www.axis.com/legal/acs-download) has been accepted. The package requires license acceptance, so by installing it you accept the Axis license agreement:

```bash
choco upgrade axis-camera-station-pro-client
```

The package follows the link from the Axis license page (a short-lived download token) and still verifies the MSI's SHA256 checksum.

### Package parameters
| Parameter | Effect |
|---|---|
| `/Telemetry` | Allow Axis to collect usage data (off by default) |
| `/DisableTls` | Let the installer turn off TLS 1.0/1.1 system-wide, after a reboot (off by default) |
| `/NoFirewall` | Don't create Windows Firewall rules |
| `/NoDesktopShortcut` | Don't create a desktop shortcut |

```bash
choco upgrade axis-camera-station-pro-client --params "'/NoDesktopShortcut'"
```

The client is never started or added to autostart by a silent install. The installer language is detected from the system's regional settings. Chocolatey does not remember package parameters on upgrade unless `useRememberedArgumentsForUpgrades` is enabled:

```bash
choco feature enable -n useRememberedArgumentsForUpgrades
```

## Updating the package
Every Monday the `Check for New Version` workflow (`update.yml`) compares the packaged version with Axis's latest version. When Axis has a newer one, it downloads the MSI, updates `$version` and `$checksum` in `tools/chocolateyinstall.ps1`, and opens a pull request. Merging the pull request starts `Tag Release` (`release.yml`), which tags the version and runs the publish workflow. You can also run `Check for New Version` by hand.

The repository setting *Settings → Actions → General → Allow GitHub Actions to create and approve pull requests* must be enabled.

To update by hand:
1. Look up the new version in https://www.axis.com/ftp/pub_soft/cam_srv/cam_station_pro/latest/ver.txt (e.g. `6.18.27687`). Axis publishes each release in a versioned folder such as `.../cam_station_pro/6_18_27687/AXISCameraStationProClient_6.18.27687.msi`.
2. Download the client MSI (in a browser, accepting the license page) and compute its checksum:
   ```powershell
   Get-FileHash .\AXISCameraStationProClient_6.18.27687.msi -Algorithm SHA256
   ```
3. Update `$version` and `$checksum` in `tools/chocolateyinstall.ps1`.
4. Commit and push to `master`:
   ```bash
   git commit -am "Update to 6.18.27687"
   git push
   ```

`Tag Release` then tags the version and publishes the package to Chocolatey. You can also run the publish workflow by hand (`workflow_dispatch`) with an existing tag.

## Contributing
Issues and pull requests are welcome.
