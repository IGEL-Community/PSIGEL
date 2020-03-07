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

$DirectoryColl = Get-UMSDeviceDirectory
$ElementColl = Get-UMSDevice

$Result = ''
#$Result = (Get-UMSProfile).Count
#$Result = Get-UMSProfileDirectory | Sort-Object -Property Id -Descending | Select-Object -First 2
#$Result = (Get-UMSProfileDirectory -Id 533 -Filter children).DirectoryChildren
#$Result = (Get-UMSDeviceAssignment -Id 577).Count
$Result = Get-UMSDirectoryRecursive -DirectoryColl $DirectoryColl -Id 511 -ElementColl $ElementColl
$Result
#($Result[0].MovedToBin).Gettype()


<#
Assert-Equivalent -Actual $Result -Expected $Result1
$Result = New-UMSDeviceDirectory -Name 'QandA' # 01
#>