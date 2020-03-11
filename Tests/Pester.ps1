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

$Cfg = Import-PowerShellDataFile -Path ('{0}\Tests\IntegrationTestsConfig.psd1' -f $Script:ProjectRoot)
$Credential = Import-Clixml -Path $Cfg.CredPath

$PSDefaultParameterValues = @{
  '*-UMS*:Credential'       = $Credential
  '*-UMS*:Computername'     = $Cfg.Computername
  '*-UMS*:TCPPort'          = $Cfg.TCPPort
  '*-UMS*:SecurityProtocol' = $Cfg.SecurityProtocol
  '*-UMS*:Confirm'          = $false
  'Invoke-Pester:Show'      = 'Failed'
}

$PSDefaultParameterValues += @{
  '*-UMS*:WebSession' = (New-UMSAPICookie)
}

Invoke-Pester -Script ('{0}\Tests\{1}.Tests.ps1' -f $ProjectRoot, $ModuleName) -OutputFile ('{0}\{1}.Tests.xml' -f $OutputPath, $ModuleName)

foreach ($Test in $Cfg.Tests)
{
  $IVPParams = @{
    Script     = '{0}\Tests\{1}.Tests.ps1' -f $ProjectRoot, $Test.Function
    OutputFile = '{0}\{1}.Tests.xml' -f $OutputPath, $Test.Function
  }
  switch ($Tags)
  {
    'All'
    {
      if ($Test.Function)
      {
        $IVPParams.CodeCoverage = '{0}\{1}\Public\{2}.ps1' -f $ProjectRoot, $ModuleName, $Test.Function
        Invoke-Pester @IVPParams
      }
    }
    'UnitTests'
    {
      if ($Test.Function)
      {
        $IVPParams.Tag = 'UnitTests'
        $IVPParams.CodeCoverage = '{0}\{1}\Public\{2}.ps1' -f $ProjectRoot, $ModuleName, $Test.Function
        Invoke-Pester @IVPParams
      }
    }
    'IntegrationTests'
    {
      $IVPParams.Tag = 'IntegrationTests'
      Invoke-Pester @IVPParams
    }
  }
}
