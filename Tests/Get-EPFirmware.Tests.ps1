$Script:ProjectRoot = Resolve-Path ('{0}\..' -f $PSScriptRoot)
$Script:ModuleRoot = Split-Path (Resolve-Path ('{0}\*\*.psm1' -f $Script:ProjectRoot))
$Script:ModuleName = Split-Path $Script:ModuleRoot -Leaf
$Script:ModuleManifest = Resolve-Path ('{0}/{1}.psd1' -f $Script:ModuleRoot, $Script:ModuleName)
$Script:CommandName = $MyInvocation.MyCommand.Name.Replace(".Tests.ps1", "")

Describe "$Script:CommandName Unit Tests" -Tag 'UnitTests' {
  Context "Validate parameters" {
    BeforeAll {
      Get-Module -All -Name $Script:ModuleName | Remove-Module -Force -ErrorAction 'Ignore'
      Import-Module ( '{0}/{1}.psm1' -f $Script:ModuleRoot, $Script:ModuleName) -Force
      $Global:ConfirmPreference = 'None'
    }

    [object[]]$params = (Get-ChildItem function:\$Script:CommandName).Parameters.Keys
    $KnownParameters = 'SSHSession'

    It "Should contain our specific parameters" {
      (@(Compare-Object -ReferenceObject $KnownParameters -DifferenceObject $params -IncludeEqual |
            Where-Object SideIndicator -eq "==").Count) | Should Be $KnownParameters.Count
    }

    Mock -CommandName 'Invoke-SSHCommandStream' -MockWith {'ddd'}

    $result = Get-EPFirmware -SSHSession 1

    It "mock test" {
      $result | Should Be 'ddd'
    }
  }
}