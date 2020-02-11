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
$Result = (Get-UMSDeviceDirectory -Id 503 -Filter children).DirectoryChildren
$Result

<#
$Result = New-UMSDeviceDirectory -Name 'QandA' # 01
#>