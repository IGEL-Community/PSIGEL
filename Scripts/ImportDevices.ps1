$UMSCredPath = 'C:\Credentials\UmsRmdb.cred'

$PSDefaultParameterValues = @{
  'New-UMSAPICookie:Credential' = Import-Clixml -Path $UMSCredPath
  '*-UMS*:Computername'         = 'igelrmserver'
  #'*-UMS*:SecurityProtocol'     = 'Tls'
}
$PSDefaultParameterValues += @{
  '*-UMS*:WebSession' = (New-UMSAPICookie)
}

$IGELImportFile = 'C:\Temp\2000000-000010.csv'
$AssetExportFile = 'C:\Temp\Asset.csv'

$IGELImportColl = Import-Csv -Delimiter ';' -Path $IGELImportFile
$AssetExportColl = Import-Csv -Delimiter ';' -Path $AssetExportFile

$MajorVersion = 10
$FirmwareId = (((Get-UMSFirmware).where{$_.Version.Major -eq $MajorVersion} |
      Sort-Object -Property Version -Descending)[0]).Id

$NewDeviceCollParams = @{
  Left              = $IGELImportColl
  LeftJoinProperty  = 'Serien-Nr. '
  LeftProperties    = 'Serien-Nr. ', 'Mac-Adressen'
  Right             = $AssetExportColl
  RightJoinProperty = 'Serien_Nr'
  RightProperties   = 'Inventar_Nr'
  Type              = 'AllInBoth'
}
$NewDeviceColl = Join-Object @NewDeviceCollParams

foreach ($NewDevice in $NewDeviceColl)
{
  $NewDeviceParams = @{
    Mac          = $NewDevice.'Mac-Adressen'
    FirmwareId   = $FirmwareId
    Name         = 'TC{0}' -f $NewDevice.Inventar_Nr
    SerialNumber = $NewDevice.'Serien-Nr. '
  }
  New-UMSDevice @NewDeviceParams -Confirm
}