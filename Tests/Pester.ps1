$ProjectRoot = Resolve-Path ('{0}\..' -f $PSScriptRoot)
$ModuleRoot = Split-Path (Resolve-Path ('{0}\*\*.psm1' -f $ProjectRoot))
$ModuleName = Split-Path $ModuleRoot -Leaf


$UMS = Get-Content -Raw -Path ('{0}\Tests\UMS.json' -f $ProjectRoot) |
  ConvertFrom-Json
$Password = Get-Content $UMS.CredPath | ConvertTo-SecureString
$Credential = New-Object System.Management.Automation.PSCredential($UMS.User, $Password)

$PSDefaultParameterValues = @{
  '*:Computername'          = $UMS.Computername
  '*-UMS*:TCPPort'          = [Int]$UMS.TCPPort
  '*-UMS*:SecurityProtocol' = $UMS.SecurityProtocol
  '*-UMS*:Confirm'          = $false
}

<#
$IgelRmGuiServerService = Get-Service -Name 'IGELRMGUIServer'
switch ($IgelRmGuiServerService)
{
  $false
  {
    throw "Service $IgelRmGuiServerService not found!"
  }
  {$_.Status -eq 'Stopped'}
  {
    "Stopped"
    $i = 0
    $IgelRmGuiServerService | Start-Service -ErrorAction Stop
    do
    {
      Start-Sleep -Seconds 3
      $i++
      if ($i -ge 10)
      {
        throw "TCPPort $UMS.TCPPort not responding!"
      }
    }
    until ((Test-NetConnection -Port $UMS.TCPPort).TcpTestSucceeded -eq $true )
  }
}
#>

$WebSession = New-UMSAPICookie -Credential $Credential
$PSDefaultParameterValues += @{
  '*-UMS*:WebSession' = $WebSession
}

#Invoke-Pester -Script $Script -CodeCoverage $CodeCoverage -Tag UnitTests
#Invoke-Pester -Script $Script -Tag IntegrationTests

foreach ($Function in $UMS.TestOrder.Public)
{
  $IVPParams = @{
    Script       = '{0}\Tests\{1}.Tests.ps1' -f $ProjectRoot, $Function
    CodeCoverage = '{0}\{1}\Public\{2}.ps1' -f $ProjectRoot, $ModuleName, $Function
    Tag          = 'UnitTests'
    Show         = 'Summary'
  }
  Invoke-Pester @IVPParams
}