param
(
  [ValidateSet('All', 'UnitTests', 'IntegrationTests')]
  [String]
  $Tags = 'UnitTests',

  #[ValidateSet('Default', 'Passed', 'Failed', 'Pending', 'Skipped', 'Inconclusive', 'Describe', 'Context', 'Summary')]
  [String[]]
  $Show = 'Summary, Failed',

  [Switch]
  $EnableExit = $false
)
$ProjectRoot = Resolve-Path ('{0}\..' -f $PSScriptRoot)
$ModuleRoot = Split-Path (Resolve-Path ('{0}\*\*.psm1' -f $ProjectRoot))
$ModuleName = Split-Path $ModuleRoot -Leaf
$OutputPath = '{0}\Tests\Data' -f $ProjectRoot
Import-Module ( '{0}/{1}.psm1' -f $Script:ModuleRoot, $Script:ModuleName) -Force

$Cfg = Import-PowerShellDataFile -Path ('{0}\Tests\Config.psd1' -f $Script:ProjectRoot)
$Credential = Import-Clixml -Path $Cfg.CredPath

# PS7 on Windows
#Import-Module 'C:\Program Files\PowerShell\7\Modules\CimCmdlets\CimCmdlets.psd1'

if ($Tags -contains { 'IntegrationTest ' -or 'All' })
{

  $PSDefaultParameterValues = @{
    '*-UMS*:Credential'       = $Credential
    '*-UMS*:Computername'     = $Cfg.Computername
    '*-UMS*:TCPPort'          = $Cfg.TCPPort
    '*-UMS*:SecurityProtocol' = $Cfg.SecurityProtocol
    '*-UMS*:Confirm'          = $false
  }

  $PSDefaultParameterValues += @{
    '*-UMS*:WebSession' = (New-UMSAPICookie)
  }

}

$PSDefaultParameterValues += @{
  'Invoke-Pester:Show'       = $Show
  'Invoke-Pester:EnableExit' = $EnableExit
}

foreach ($Test in $Cfg.Tests)
{
  $IVPParams = @{ }
  switch ($Test)
  {
    ( { $PSItem.All } )
    {
      Write-Host $Test.All
      $IVPParams.Script = '{0}\Tests\{1}.Tests.ps1' -f $ProjectRoot, $Test.All
      $IVPParams.OutputFile = '{0}\{1}.Tests.xml' -f $OutputPath, $Test.All
      switch ($Tags)
      {
        'All'
        {
          $IVPParams.CodeCoverage = '{0}\{1}\Public\{2}.ps1' -f $ProjectRoot, $ModuleName, $Test.All
          Invoke-Pester @IVPParams
        }
        'UnitTests'
        {
          $IVPParams.Tag = 'UnitTests'
          $IVPParams.CodeCoverage = '{0}\{1}\Public\{2}.ps1' -f $ProjectRoot, $ModuleName, $Test.All
          Invoke-Pester @IVPParams
        }
        'IntegrationTests'
        {
          $IVPParams.Tag = 'IntegrationTests'
          Invoke-Pester @IVPParams
        }
      }
    }
    ( { $PSItem.IntegrationTests } )
    {
      Write-Host $Test.IntegrationTests
      $IVPParams.Script = '{0}\Tests\{1}.Tests.ps1' -f $ProjectRoot, $Test.IntegrationTests
      $IVPParams.OutputFile = '{0}\{1}.Tests.xml' -f $OutputPath, $Test.IntegrationTests
      switch ($Tags)
      {
        'All'
        {
          $IVPParams.Tag = 'IntegrationTests'
          Invoke-Pester @IVPParams
        }
        'IntegrationTests'
        {
          $IVPParams.Tag = 'IntegrationTests'
          Invoke-Pester @IVPParams
        }
      }
    }
    ( { $PSItem.UnitTests } )
    {
      Write-Host $Test.UnitTests
      $IVPParams.Script = '{0}\Tests\{1}.Tests.ps1' -f $ProjectRoot, $Test.UnitTests
      $IVPParams.OutputFile = '{0}\{1}.Tests.xml' -f $OutputPath, $Test.UnitTests
      switch ($Tags)
      {
        'All'
        {
          $IVPParams.CodeCoverage = '{0}\{1}\Public\{2}.ps1' -f $ProjectRoot, $ModuleName, $Test.UnitTests
          Invoke-Pester @IVPParams
        }
        'UnitTests'
        {
          $IVPParams.CodeCoverage = '{0}\{1}\Public\{2}.ps1' -f $ProjectRoot, $ModuleName, $Test.UnitTests
          Invoke-Pester @IVPParams
        }
      }
    }
    ( { $PSItem.PrivateUnitTests } )
    {
      Write-Host $Test.PrivateUnitTests
      $IVPParams.Script = '{0}\Tests\{1}.Tests.ps1' -f $ProjectRoot, $Test.PrivateUnitTests
      $IVPParams.OutputFile = '{0}\{1}.Tests.xml' -f $OutputPath, $Test.PrivateUnitTests
      switch ($Tags)
      {
        'All'
        {
          $IVPParams.CodeCoverage = '{0}\{1}\Private\{2}.ps1' -f $ProjectRoot, $ModuleName, $Test.PrivateUnitTests
          Invoke-Pester @IVPParams
        }
        'UnitTests'
        {
          $IVPParams.CodeCoverage = '{0}\{1}\Private\{2}.ps1' -f $ProjectRoot, $ModuleName, $Test.PrivateUnitTests
          Invoke-Pester @IVPParams
        }
      }
    }
    ( { $PSItem.General } )
    {
      Write-Host $Test.General
      $IVPParams.Script = '{0}\Tests\{1}.Tests.ps1' -f $ProjectRoot, $Test.General
      $IVPParams.OutputFile = '{0}\{1}.Tests.xml' -f $OutputPath, $Test.General
      switch ($Tags)
      {
        'All'
        {
          Invoke-Pester @IVPParams
        }
        'UnitTests'
        {
          Invoke-Pester @IVPParams
        }
      }
    }
  }
}
