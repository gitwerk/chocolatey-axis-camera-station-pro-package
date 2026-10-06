$ErrorActionPreference = 'Stop'

$version  = '6.18.27687'
$checksum = '43A8BB41C13B96B722E14AF7E1701E5A971E9D408C83AB50DD6C4CD6AFFA7C91'

$pp = Get-PackageParameters

$eulaUrl = 'https://www.axis.com/legal/acs-download'
if (-not $pp.ContainsKey('AcceptEula')) {
  throw "AXIS Camera Station Pro may only be downloaded after accepting the Axis license agreement: $eulaUrl. Read it, then re-run with --params `"'/AcceptEula'`" to accept it."
}

# Axis redirects downloads to its EULA page; the page's continue link carries a short-lived token
$url = "https://www.axis.com/ftp/pub_soft/cam_srv/cam_station_pro/$($version -replace '\.', '_')/AXISCameraStationProClient_$version.msi"
$request = [System.Net.WebRequest]::Create($url)
$request.Method = 'HEAD'
$request.AllowAutoRedirect = $false
$response = $request.GetResponse()
$location = $response.Headers['Location']
$response.Close()
if ($location -match 'return=([^&]+)') {
  $url = "https://www.axis.com$([Uri]::UnescapeDataString($Matches[1]))"
}

# Documented AXIS Camera Station Pro MSI properties (all default to 1 in the MSI)
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
  -Url64bit $url `
  -Checksum64 $checksum `
  -ChecksumType64 'sha256' `
  -SoftwareName 'AXIS Camera Station Pro*' `
  -SilentArgs "/qn /norestart $propertyArgs /l*v `"$logFile`"" `
  -ValidExitCodes @(0, 1641, 3010)
