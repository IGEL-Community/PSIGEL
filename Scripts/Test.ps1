Import-Module C:\GitHub\PSIGEL\PSIGEL\PSIGEL.psd1 -Force
$UMSCredPath = 'C:\Credentials\UmsRmdb.cred'

$PSDefaultParameterValues = @{
  'New-UMSAPICookie:Credential' = Import-Clixml -Path $UMSCredPath
  '*-UMS*:Computername'         = 'igelrmserver'
  '*-UMS*:TCPPort'              = 9443
  '*-UMS*:Confirm'              = $False
  #'*-UMS*:SecurityProtocol'     = 'Tls'
}
$PSDefaultParameterValues += @{
  '*-UMS*:WebSession' = New-UMSAPICookie
}

$Result = ''
$Result = Get-UMSDeviceAssignment -Id 505
$Result



<#

$NewParams = @{
  Mac        = '0A00000000AA'
  Name       = 'NewDevice01'
  FirmwareId = 1
  ParentId   = -1
}
$MoveParams = @{
  DestId = 502 # PSIGEL
}
$UpdateParams = @{
  Name = 'UpdatedDevice01'
}

$Result = @(
  $null = [pscustomobject]$NewParams |
  New-UMSDevice | Tee-Object -Variable 'NewUMSDevice' |
  Move-UMSDevice @MoveParams | Tee-Object -Variable 'MoveUMSDevice' |
  Update-UMSDevice @UpdateParams | Tee-Object -Variable 'UpdateUMSDevice' |
  Get-UMSDevice | Tee-Object -Variable 'GetUMSDevice' |
  Start-UMSDevice | Tee-Object -Variable 'StartUMSDevice' |
  Send-UMSDeviceSetting | Tee-Object -Variable 'SendUMSDeviceSettings' |
  Remove-UMSDevice | Tee-Object -Variable 'RemoveUMSDevice'

  $NewUMSDevice
  $MoveUMSDevice
  $UpdateUMSDevice
  $GetUMSDevice
  $StartUMSDevice
  $SendUMSDeviceSettings
  $RemoveUMSDevice
)
$Result
#>


#Get-UMSDevice -WebSession $Result

<#

  $Result = @(
    $null = ((($NewParams.Mac |
    New-UMSDevice -FirmwareId $NewParams.FirmwareId | Tee-Object -Variable 'NewUMSDevice').Id |
    Move-UMSDevice @MoveParams | Tee-Object -Variable 'MoveUMSDevice').Id |
    Update-UMSDevice @UpdateParams | Tee-Object -Variable 'UpdateUMSDevice').Id |
    Remove-UMSDevice @RemoveParams | Tee-Object -Variable 'RemoveUMSDevice'

    $NewUMSDevice
    $MoveUMSDevice
    $UpdateUMSDevice
    $RemoveUMSDevice
    )
    $Result
    #>





<#
$Result = ''
$Result
#>