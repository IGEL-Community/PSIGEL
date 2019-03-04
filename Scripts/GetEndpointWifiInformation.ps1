$UMSCredPath = 'C:\Credentials\UmsRmdb.cred'
$UMSUser = 'rmdb'
$UMSPassword = Get-Content $UMSCredPath | ConvertTo-SecureString
$RootCredPath = 'C:\Credentials\TCRoot.cred'
$RootCredential = (Import-Clixml -Path $RootCredPath)

[Int]$DirID = 141

$PSDefaultParameterValues = @{
  '*-UMS*:Credential'   = (New-Object System.Management.Automation.PsCredential($UMSUser, $UMSPassword))
  '*-UMS*:Computername' = 'igelrmserver.acme.org'
}

$WebSession = New-UMSAPICookie

$PSDefaultParameterValues += @{
  '*-UMS*:WebSession' = $WebSession
}

$DirColl = (Get-UMSThinclientDirectory -DirID $DirID -Children).DirectoryChildren
$EndPointColl = $DirColl.where{$_.objectType -eq 'tc'}.id | Get-UMSThinclient -Details online
$OnlineEndPointColl = $EndPointColl.Where{$_.online -eq 'True'}

$UpdateConfigurationColl = $OnlineEndPointColl |
  Invoke-Parallel -RunspaceTimeout 10 -ScriptBlock {
  $SshSession = New-SSHSession -Computername $_.Name -Credential $Using:RootCredential -AcceptKey
  Get-EPWifiConnection -SSHSession $SshSession
  $null = Remove-SSHSession -SSHSession $SshSession
}

$UpdateConfigurationColl |
  Select-Object Host, Interface, ESSID, Mode, Frequency, AccessPoint, BitRate, @{
  name       = 'LinkQuality'
  expression = { [Int]([Int]($_.LinkQuality -replace ('/.*', '')) / [Int]($_.LinkQuality -replace ('^\d{2,3}/', '')) * 100) }
}, SignalLevel |
  Sort-Object -Property @{
  Expression = {[Int]$_.LinkQuality}
}, @{
  Expression = {[Int]$_.BitRate}
}, @{
  Expression = {[Int]$_.SignalLevel}
} |
  Format-Table -AutoSize

