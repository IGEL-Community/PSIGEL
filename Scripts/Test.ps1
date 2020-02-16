$UMSCredPath = 'C:\Credentials\UmsRmdb.cred'

$PSDefaultParameterValues = @{
  'New-UMSAPICookie:Credential' = Import-Clixml -Path $UMSCredPath
  '*-UMS*:Computername'         = '192.168.56.1'
  '*-UMS*:TCPPort'              = 9443
  #'*-UMS*:SecurityProtocol'     = 'Tls'
}
$PSDefaultParameterValues += @{
  '*-UMS*:WebSession' = (New-UMSAPICookie)
}

$Result = ''
#$Result = (Get-UMSProfile).Count
#$Result = Get-UMSProfileDirectory | Sort-Object -Property Id -Descending | Select-Object -First 2
#$Result = (Get-UMSProfileDirectory -Id 533 -Filter children).DirectoryChildren
#$Result = (Get-UMSDeviceAssignment -Id 577).Count
$Result = Get-UMSDevice
$Result1 = Get-UMSDevice | Select-Object -First 9
$Result

Assert-Equivalent -Actual $Result -Expected $Result1

<#
$Result = New-UMSDeviceDirectory -Name 'QandA' # 01
#>