param
(
  [ValidateSet('All', 'UnitTests', 'IntegrationTests')]
  [String]
  #$Tags = 'All'
  $Tags = 'UnitTests'
  #$Tags = 'IntegrationTests'
)
$ProjectRoot = Resolve-Path ('{0}\..' -f $PSScriptRoot)
$ModuleRoot = Split-Path (Resolve-Path ('{0}\*\*.psm1' -f $ProjectRoot))
$ModuleName = Split-Path $ModuleRoot -Leaf
$OutputPath = '{0}\Tests\Data' -f $ProjectRoot


$UMS = Get-Content -Raw -Path ('{0}\Tests\UMS.json' -f $ProjectRoot) |
ConvertFrom-Json


$PSDefaultParameterValues = @{
  '*:Computername'              = $UMS.Computername
  #'New-UMSAPICookie:Credential' = Import-Clixml -Path $UMS.Credpath
  '*-UMS*:TCPPort'              = [Int]$UMS.TCPPort
  '*-UMS*:SecurityProtocol'     = $UMS.SecurityProtocol
  '*-UMS*:Confirm'              = $false
  #'Invoke-Pester:Show'          = 'Failed'
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

#$WebSession = New-UMSAPICookie -Credential $Credential
$PSDefaultParameterValues += @{
  #'*-UMS*:WebSession' = $WebSession
  '*-UMS*:WebSession' = (New-UMSAPICookie)
}

Invoke-Pester -Script ('{0}\Tests\{1}.Tests.ps1' -f $ProjectRoot, $ModuleName) -OutputFile ('{0}\{1}.Tests.xml' -f $OutputPath, $ModuleName)

foreach ($Function in $UMS.TestOrder.Public)
{
  $IVPParams = @{
    Script     = '{0}\Tests\{1}.Tests.ps1' -f $ProjectRoot, $Function
    OutputFile = '{0}\{1}.Tests.xml' -f $OutputPath, $Function
  }
  switch ($Tags)
  {
    'All'
    {
      $IVPParams.CodeCoverage = '{0}\{1}\Public\{2}.ps1' -f $ProjectRoot, $ModuleName, $Function
    }
    'UnitTests'
    {
      $IVPParams.Tag = 'UnitTests'
      $IVPParams.CodeCoverage = '{0}\{1}\Public\{2}.ps1' -f $ProjectRoot, $ModuleName, $Function
    }
    'IntegrationTests'
    {
      $IVPParams.Tag = 'IntegrationTests'
    }
  }
  Invoke-Pester @IVPParams
}
