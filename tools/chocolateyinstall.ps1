$ErrorActionPreference = 'Stop'

$version  = '5.59.56000'
$checksum = 'F827DD1F1F560792A4A32C97521158EABD94557FF12F5B2EBCE63EDD27384F97'

$pp = Get-PackageParameters

# Documented AXIS Camera Station MSI properties (all default to 1 in the MSI)
$properties = @{
  LAUNCHCLIENT           = 0
  FEEDBACKPERMISSION     = [int]$pp.ContainsKey('Telemetry')
  DISABLETLSPERMISSION   = [int]$pp.ContainsKey('DisableTls')
  FIREWALLPERMISSION     = [int](-not $pp.ContainsKey('NoFirewall'))
  INSTALLDESKTOPSHORTCUT = [int](-not $pp.ContainsKey('NoDesktopShortcut'))
}
$propertyArgs = ($properties.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join ' '

$logFile = "$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.MsiInstall.log"

Install-ChocolateyPackage -PackageName $env:ChocolateyPackageName `
  -FileType 'msi' `
  -Url64bit "https://www.axis.com/ftp/pub_soft/cam_srv/cam_station/$($version -replace '\.', '_')/AXISCameraStationClient_$version.msi" `
  -Checksum64 $checksum `
  -ChecksumType64 'sha256' `
  -SoftwareName 'AXIS Camera Station Client*' `
  -SilentArgs "/qn /norestart $propertyArgs /l*v `"$logFile`"" `
  -ValidExitCodes @(0, 1641, 3010)
