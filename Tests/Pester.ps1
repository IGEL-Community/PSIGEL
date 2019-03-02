$Script = 'E:\GitHub\PSIGEL\Tests\Get-EPWifiConnection.Tests.ps1'
$CodeCoverage = 'E:\GitHub\PSIGEL\PSIGEL\Public\Get-EPWifiConnection.ps1'
Invoke-Pester -Script $Script -CodeCoverage $CodeCoverage -Tag UnitTests


<#
Invoke-Pester -Script $Script -Tag IntegrationTests
#>


$Script:ProjectRoot = Resolve-Path ('{0}\..' -f $PSScriptRoot)
$Script:ModuleRoot = Split-Path (Resolve-Path ('{0}\*\*.psm1' -f $Script:ProjectRoot))
$Script:ModuleName = Split-Path $Script:ModuleRoot -Leaf
$Script:ModuleManifest = Resolve-Path ('{0}/{1}.psd1' -f $Script:ModuleRoot, $Script:ModuleName)
$Script:FunctionName = $MyInvocation.MyCommand.Name.Replace(".Tests.ps1", "")