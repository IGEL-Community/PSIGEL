Import-Module C:\GitHub\PSIGEL\PSIGEL\PSIGEL.psd1 -Force
$UMSCredPath = 'C:\Credentials\UmsRmdb.cred'

$PSDefaultParameterValues = @{
  'New-UMSAPICookie:Credential' = Import-Clixml -Path $UMSCredPath
  '*-UMS*:Computername'         = 'igelrmserver'
  '*-UMS*:TCPPort'              = 9443
  #'*-UMS*:SecurityProtocol'     = 'Tls'
}

$WebSession = New-UMSAPICookie
$PSDefaultParameterValues += @{
  '*-UMS*:WebSession' = $WebSession
}

$Params1 = @{
  Mac        = '0A00000000FF'
  Name       = 'PipelineDevice'
  FirmwareId = 1
  ParentId   = -1
}

#$Params1.Mac -match '^([0-9a-f]{12})$'

$Result = ''
$Result = $Params1 | New-UMSDevice
#$Result = $Params1.Mac | New-UMSDevice -FirmwareId 1
$Result
#($Result[0].MovedToBin).Gettype()


<#
Assert-Equivalent -Actual $Result -Expected $Result1
$Result = New-UMSDeviceDirectory -Name 'QandA' # 01
#>