$DSC = [IO.Path]::DirectorySeparatorChar
$PSIGELPath = 'GitHub{0}PSIGEL{0}PSIGEL{0}PSIGEL.psd1' -f $DSC

$PSDefaultParameterValues = @{
  '*-UMS*:Computername' = 'igelrmserver'
  '*-UMS*:TCPPort'      = 9443
  '*-UMS*:Confirm'      = $False
  #'*-UMS*:SecurityProtocol'     = 'Tls'
}

if (($PSEdition -eq 'Core' -and $IsWindows) -or ($PSEdition -eq 'Desktop' -and ($PSVersionTable.PSVersion.Major -eq 5 -and $PSVersionTable.PSVersion.Minor -eq 1)))
{
  # PS7 on Windows or Windows PowerShell 5.1
  Import-Module -FullyQualifiedName ('C:\{0}' -f $PSIGELPath) -Force
  $PSDefaultParameterValues.Add('New-UMSAPICookie:Credential', (Import-Clixml -Path 'C:\Credentials\UmsRmdb.cred'))
}
elseif ($PSEdition -eq 'core' -and (-Not $IsWindows) )
{
  # PS7 on Linux OR MacOS
  Import-Module -FullyQualifiedName ('/mnt/c/{0}' -f $PSIGELPath) -Force
  # Dont use the following method in production, since on linux the clixml file is not encrypted
  $PSDefaultParameterValues.Add('New-UMSAPICookie:Credential', (Import-Clixml -Path '/mnt/c/Credentials/UmsRmdbWsl.cred'))
}

$WebSession = New-UMSAPICookie

if ($WebSession)
{
  $PSDefaultParameterValues += @{
    '*-UMS*:WebSession' = $WebSession
  }
  #<#
  $Result = ''
  $Result = Get-UMSDeviceAssignment -Id 505
  #$Result = Get-UMSDevice
  #$Result = Get-UMSFirmware
  $Result

  Remove-UMSAPICookie #-Verbose

}
#>



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