param
(
  [ValidateSet('All', 'UnitTests', 'IntegrationTests')]
  [String]
  $Tags = 'UnitTests',

  [String[]]
  $Show = ('Header', 'Summary', 'Failed'),

  [Switch]
  $EnableExit = $false
)
$DSC = [IO.Path]::DirectorySeparatorChar
$ProjectRoot = Resolve-Path ('{1}{0}..' -f $DSC, $PSScriptRoot)
$ModuleRoot = Split-Path (Resolve-Path ('{1}{0}*{0}*.psm1' -f $DSC, $ProjectRoot))
$ModuleName = Split-Path $ModuleRoot -Leaf
$OutputPath = '{1}{0}Tests{0}Data' -f $DSC, $ProjectRoot
Import-Module ( '{1}{0}{2}.psm1' -f $DSC, $Script:ModuleRoot, $Script:ModuleName) -Force

$Cfg = Import-PowerShellDataFile -Path ('{1}{0}Tests{0}Config.psd1' -f $DSC, $Script:ProjectRoot)

# PS7 on Windows
if (($PSEdition -eq 'Desktop') -and ($PSVersionTable.PSVersion.Major -eq 7))
{
  Import-Module ('{0}\7\Modules\CimCmdlets\CimCmdlets.psd1' -f [Environment]::GetEnvironmentVariable('ProgramFiles')) -Force
}

if ($Tags -contains { 'IntegrationTest ' -or 'All' })
{
  if ($IsLinux)
  {
    $Credential = Import-Clixml -Path $Cfg.CredPathWsl
  }
  else
  {
    $Credential = Import-Clixml -Path $Cfg.CredPath
  }
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

foreach ($Test in $Cfg.Tests)
{
  $IVPParams = @{ }
  $IVPParams.Add('Tags', $Tags)
  $IVPParams.Add('Show', $Show)
  $IVPParams.Add('EnableExit', $EnableExit)
  $IVPParams.Add('Script', ('{1}{0}Tests{0}{2}.Tests.ps1' -f $DSC, $ProjectRoot, $Test.Name))
  switch ($Test)
  {
    ( { $PSItem.CodeCoveragePath } )
    {
      $IVPParams.Add('CodeCoverage', ('{1}{0}{2}{0}{3}{0}{4}.ps1' -f $DSC, $ProjectRoot, $ModuleName, $PSItem.CodeCoveragePath, $Test.Name))
      $IVPParams.Add('Outputfile', ('{1}{0}{2}.Tests.xml' -f $DSC, $OutputPath, $Test.Name))
    }
  }
  Invoke-Pester @IVPParams
}
