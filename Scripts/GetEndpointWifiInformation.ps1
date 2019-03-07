$UMSCredPath = 'C:\Credentials\UmsRmdb.cred'
$UMSUser = 'rmdb'
$UMSPassword = Get-Content $UMSCredPath | ConvertTo-SecureString
$RootCredPath = 'C:\Credentials\TCRoot.cred'
$RootCredential = (Import-Clixml -Path $RootCredPath)
#Id of the thinclientdirectory
[Int]$TcDirId = 999

$PSDefaultParameterValues = @{
  '*-UMS*:Credential'       = (New-Object System.Management.Automation.PsCredential($UMSUser, $UMSPassword))
  '*-UMS*:Computername'     = 'igelrmserver.acme.org'
  '*-UMS*:SecurityProtocol' = 'Tls12'
}

$WebSession = New-UMSAPICookie

$PSDefaultParameterValues += @{
  '*-UMS*:WebSession' = $WebSession
}

$DirColl = (Get-UMSThinclientDirectory -Id $TcDirId -Filter children).DirectoryChildren
$EndPointColl = $DirColl.where{$_.ObjectType -eq 'tc'} | Get-UMSThinclient -Filter online
$OnlineEndPointColl = $EndPointColl.Where{$_.Online -eq $true}

$UpdateConfigurationColl = $OnlineEndPointColl |
  Invoke-Parallel -RunspaceTimeout 10 -ScriptBlock {
  $SshSession = New-SSHSession -Computername $_.Name -Credential $Using:RootCredential -AcceptKey
  Get-EPWifiConnection -SSHSession $SshSession
  $null = Remove-SSHSession -SSHSession $SshSession
}

$UpdateConfigurationColl | Select-Object Host, Interface, ESSID, Mode, Frequency, AccessPoint, BitRate, @{
  name       = 'LinkQuality'
  expression = { [math]::Round(($_.LinkQualityActual / $_.LinkQualityMax * 100), 0) }
}, SignalLevel |
  Sort-Object -Property LinkQuality, BitRate, SignalLevel -Descending |
  Format-Table -AutoSize