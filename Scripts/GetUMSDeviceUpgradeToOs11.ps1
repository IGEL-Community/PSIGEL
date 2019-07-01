<#

- Gets all devices and all firmwares from UMS
- throws out all 'legacy' devices (non-IGEL devices)
- looks for devices with product ids from $SupportedDeviceCollJson
- categorizes devices with OS11 and higher as non upgradeble

IGEL Devices That Can Be Upgraded to IGEL OS 11
CPU with 64-bit support
≥ 2 GB RAM
≥ 2 GB Flash
No VIA graphics adapter
https://kb.igel.com/igelos-10.05.800/en/igel-devices-that-can-be-upgraded-to-igel-os-11-14686133.html

#>
#$Path = '{0}\IGELDevicesAbleToUpgradeToOS11-{1}.xlsx' -f $Env:TEMP, ((Get-Date).ToString('s') -replace '(-|:)', '')

$SupportedDeviceCollJson = @'
{
  "ProductId":
  [
    "UD2-LX 40",
    "UD3-LX 51",
    "UD3-LX 50",
    "UD5-LX 50",
    "UD6-LX 51",
    "UD7-LX 10",
    "UD9-LX 41",
    "UD9-LX 40",
    "IZ2 40",
    "IZ3 51",
    "IZ3 50"
  ]
}
'@
$SupportedDeviceColl = $SupportedDeviceCollJson | ConvertFrom-Json

$PSDefaultParameterValues = @{
  '*-UMS*:Credential'       = (Get-Credential)
  '*-UMS*:Computername'     = 'igelrmserver'
  '*-UMS*:SecurityProtocol' = 'Tls12'
}

$PSDefaultParameterValues += @{
  '*UMS*:WebSession' = (New-UMSAPICookie)
}

$FirmwareColl = Get-UMSFirmware

$DeviceColl = Get-UMSDevice -Filter details |
Where-Object { ($_.ProductId) -and ($_.DeviceType -notmatch '^Legacy') }
Select-Object -Property Name, Id, FirmwareId, MemorySize, FlashSize, OsType, DeviceType, ProductId, @{
  name       = 'ProductIdParsed'
  expression =
  {
    ([regex]::match($_.ProductId, "^(UD(2|3|5|6|7|9)-LX\s\d{2,2})")).value
  }
}, @{
  name       = 'Codec'
  expression =
  {
    ([regex]::match($_.ProductId, "(a|c|ac)$")).value
  }
}

$JoinObjectParams = @{
  Left              = $DeviceColl
  LeftJoinProperty  = 'FirmwareId'
  Right             = $FirmwareColl
  RightJoinProperty = 'Id'
  RightProperties   = 'Product', 'Version', 'FirmwareTyp'
  Type              = 'AllInLeft'
}
$DeviceFirmwareColl = Join-Object @JoinObjectParams

$AddMemberParams = @{
  MemberType = 'NoteProperty'
  Name       = 'Upgrade to OS11'
  PassThru   = $True
  Force      = $True
}

$Result = foreach ($Device in $DeviceFirmwareColl)
{
  if (($SupportedDeviceColl.ProductId -contains $Device.ProductIdParsed) -and ($Device.Version -lt '11.0.0'))
  {
    $Device | Add-Member @AddMemberParams -Value $True
  }
  else
  {
    $Device | Add-Member @AddMemberParams -Value $False
  }
}

$Result | Out-GridView
