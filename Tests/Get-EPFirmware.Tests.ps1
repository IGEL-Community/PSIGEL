﻿$Script:ProjectRoot = Resolve-Path ('{0}\..' -f $PSScriptRoot)
$Script:ModuleRoot = Split-Path (Resolve-Path ('{0}\*\*.psm1' -f $Script:ProjectRoot))
$Script:ModuleName = Split-Path $Script:ModuleRoot -Leaf
$Script:ModuleManifest = Resolve-Path ('{0}/{1}.psd1' -f $Script:ModuleRoot, $Script:ModuleName)
$Script:FunctionName = $MyInvocation.MyCommand.Name.Replace(".Tests.ps1", "")

Describe "$Script:FunctionName Unit Tests" -Tag 'UnitTests' {
  BeforeAll {
    $Global:ConfirmPreference = 'None'
    . ( '{0}\Public\{1}.ps1' -f $Script:ModuleRoot, $Script:FunctionName)
    $PSDefaultParameterValues = @{
      '*:SSHSession' = New-MockObject -Type 'SSH.SshSession'
    }
  }

  Context "Parameter Validation" {

    [object[]]$params = (Get-ChildItem function:\$Script:FunctionName).Parameters.Keys
    $KnownParameters = 'SSHSession'

    It "Should contain our specific parameters" {
      (@(Compare-Object -ReferenceObject $KnownParameters -DifferenceObject $params -IncludeEqual |
            Where-Object SideIndicator -eq "==").Count) | Should Be $KnownParameters.Count
    }
  }

  Context "Code Execution" {
    Mock 'Invoke-SSHCommandStream' {' 1  Aa.: ! '}
    Mock 'Write-Output' {}

    $Result = Get-EPFirmware

    It 'Assert Invoke-SSHCommandStream is called exactly 1 time' {
      $AMCParams = @{
        CommandName = 'Invoke-SSHCommandStream'
        Times       = 1
        Exactly     = $true
      }
      Assert-MockCalled @AMCParams
    }

    It 'Should remove white spaces' {
      $Result | Should BeExactly '1Aa.:!'
    }

    It 'Assert Write-Output is called exactly 0 times' {
      $AMCParams = @{
        CommandName = 'Write-Output'
        Times       = 0
        Exactly     = $true
      }
      Assert-MockCalled @AMCParams
    }

    It 'Should have type string' {
      $Result | Should -HaveType ([string])
    }
  }

  Context "Error Handling" {
    Mock 'Invoke-SSHCommandStream' {throw 'Error'}
    Mock 'Write-Output' {}

    Get-EPFirmware

    It 'Assert Write-Output is called exactly 1 time' {
      $AMCParams = @{
        CommandName = 'Write-Output'
        Times       = 1
        Exactly     = $true
      }
      Assert-MockCalled @AMCParams
    }
  }
}

Describe "$Script:FunctionName Integration Tests" -Tags "IntegrationTests" {
  <#
  BeforeAll {
    $Global:ConfirmPreference = 'None'
    . ( '{0}\Public\{1}.ps1' -f $Script:ModuleRoot, $Script:FunctionName)
    $PSDefaultParameterValues = @{
      #'*:SSHSession' = New-MockObject -Type 'SSH.SshSession'
    }
  }
  It "doesn't throw" {
    { Get-EPFirmware }  | Should Not Throw
  }
  #>
}