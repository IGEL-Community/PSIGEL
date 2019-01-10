$Script:ProjectRoot = Resolve-Path ('{0}\..' -f $PSScriptRoot)
$Script:ModuleRoot = Split-Path (Resolve-Path ('{0}\*\*.psm1' -f $Script:ProjectRoot))
$Script:ModuleName = Split-Path $Script:ModuleRoot -Leaf
$Script:ModuleManifest = Resolve-Path ('{0}/{1}.psd1' -f $Script:ModuleRoot, $Script:ModuleName)
$Script:FunctionName = $MyInvocation.MyCommand.Name.Replace(".Tests.ps1", "")

Describe "$Script:FunctionName Unit Tests" -Tag 'UnitTests' {
  BeforeAll {
    Get-Module -All -Name $Script:ModuleName | Remove-Module -Force -ErrorAction 'Ignore'
    Import-Module ( '{0}/{1}.psm1' -f $Script:ModuleRoot, $Script:ModuleName) -Force
    $Global:ConfirmPreference = 'None'
  }
  Context "Validate parameters" {
    
    [object[]]$params = (Get-ChildItem function:\$Script:FunctionName).Parameters.Keys
    $KnownParameters = 'SSHSession'
    
    It "Should contain our specific parameters" {
      (@(Compare-Object -ReferenceObject $KnownParameters -DifferenceObject $params -IncludeEqual |
            Where-Object SideIndicator -eq "==").Count) | Should Be $KnownParameters.Count
    }
  }
  
  Context "xyz" {
    
    $PSDefaultParameterValues = @{
      '*:SSHSession' = New-MockObject -Type 'SSH.SshSession'
    }

    Mock 'Invoke-SSHCommandStream' {'4.14.300.01 '}
    
    $Result = Get-EPFirmware
    
    It 'calls Invoke-SSHCommandStream' {

      $AMCParams = @{
        CommandName = 'Invoke-SSHCommandStream'
        Times       = 1
        Exactly     = $true
      }
      Assert-MockCalled @AMCParams
    }
  }
}