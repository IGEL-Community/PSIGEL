<#
  requires function Invoke-Parallel:
  https://raw.githubusercontent.com/RamblingCookieMonster/Invoke-Parallel/master/Invoke-Parallel/Invoke-Parallel.ps1
#>

[Int]$DeviceDirId = 75
[String]$Computername = 'igelrmserver'
#[String[]]$SecurityProtocol = 'Tls12'
[String[]]$SecurityProtocol = 'Tls'
[String]$UMSCPath = 'C:\Credentials\UmsRmdb.cred'
[String]$DeviceCPath = 'C:\Credentials\DeviceRoot.cred'
[Switch]$Online = $false
[String]$PathToInvokeParallel = '{0}\Invoke-Parallel.ps1' -f $PSScriptRoot

$PSDefaultParameterValues = @{
  '*-UMS*:Credential'       = (Import-Clixml -Path $UMSCPath)
  '*-UMS*:Computername'     = $Computername
  '*-UMS*:SecurityProtocol' = $SecurityProtocol
}

$PSDefaultParameterValues += @{
  '*-UMS*:WebSession' = (New-UMSAPICookie)
}

if (!(Get-Command Invoke-Parallel -ErrorAction SilentlyContinue))
{
  . $PathToInvokeParallel
}

$SSHCredential = (Import-Clixml -Path $DeviceCPath)

$DirColl = (Get-UMSDeviceDirectory -Id $DeviceDirId -Filter children).DirectoryChildren

switch ($Online)
{
  $true
  {
    $DeviceColl = ($DirColl.where{$_.ObjectType -eq 'tc'} | Get-UMSDevice -Filter online).where{$_.Online -eq $true}
  }
  Default
  {
    $DeviceColl = $DirColl.where{$_.ObjectType -eq 'tc'} | Get-UMSDevice
  }
}

$DeviceWifiColl = $DeviceColl |
  Invoke-Parallel -RunspaceTimeout 20 -ScriptBlock {
  $SshSession = New-SSHSession -Computername $_.Name -Credential $Using:SSHCredential -AcceptKey -ErrorAction SilentlyContinue
  if ($SshSession)
  {
    Get-OSWifiConnection -SSHSession $SshSession
    $null = Remove-SSHSession -SSHSession $SshSession
  }
}

$DeviceWifiColl | Select-Object Host, Interface, ESSID, Mode, Frequency, AccessPoint, BitRate, @{
  name       = 'LinkQuality'
  expression = { [math]::Round(($_.LinkQualityActual / $_.LinkQualityMax * 100), 0) }
}, SignalLevel |
  Sort-Object -Property LinkQuality, BitRate, SignalLevel -Descending |
  Format-Table -AutoSize