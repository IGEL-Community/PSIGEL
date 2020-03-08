Import-Module C:\GitHub\PSIGEL\PSIGEL\PSIGEL.psd1 -Force
$UMSCredPath = 'C:\Credentials\UmsRmdb.cred'

$PSDefaultParameterValues = @{
  'New-UMSAPICookie:Credential' = Import-Clixml -Path $UMSCredPath
  '*-UMS*:Computername'         = 'igelrmserver'
  '*-UMS*:TCPPort'              = 9443
  '*-UMS*:Confirm'              = $False
  #'*-UMS*:SecurityProtocol'     = 'Tls'
}

$WebSession = New-UMSAPICookie
$PSDefaultParameterValues += @{
  '*-UMS*:WebSession' = $WebSession
}

$NewParams = @{
  Name = 'NewDeviceDirectory02'
}
$MoveParams = @{
  DestId = 502 # PSIGEL
}
$UpdateParams = @{
  Name = 'UpdatedDeviceDirectory02'
}

#<#
$Result = @(
  $null = ((($NewParams.Name |
        New-UMSDeviceDirectory | Tee-Object -Variable 'NewUMSDeviceDirectory').Id |
      Move-UMSDeviceDirectory @MoveParams | Tee-Object -Variable 'MoveUMSDeviceDirectory').Id |
    Update-UMSDeviceDirectory @UpdateParams | Tee-Object -Variable 'UpdateUMSDeviceDirectory').Id |
  Remove-UMSDeviceDirectory | Tee-Object -Variable 'RemoveUMSDeviceDirectory'
  $NewUMSDeviceDirectory
  $MoveUMSDeviceDirectory
  $UpdateUMSDeviceDirectory
  $RemoveUMSDeviceDirectory
)
$Result
#>

<#
  $NewParams = @{
    Mac        = '0A00000000FF'
    Name       = 'NewDevice'
    FirmwareId = 1
    ParentId   = -1
  }
  $MoveParams = @{
    Id     = 540 # eff
    DestId = 527
  }
  $UpdateParams = @{
    Name = 'UpdatedProfile'
  }
  $RemoveParams = @{
    Confirm = $false
  }
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
$Result = @(
  $null = [pscustomobject]$NewParams |
  New-UMSDevice | Tee-Object -Variable 'NewUMSDevice' |
  Move-UMSDevice @MoveParams | Tee-Object -Variable 'MoveUMSDevice' |
  Update-UMSDevice @UpdateParams | Tee-Object -Variable 'UpdateUMSDevice' |
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