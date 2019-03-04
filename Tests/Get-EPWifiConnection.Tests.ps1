$Script:ProjectRoot = Resolve-Path ('{0}\..' -f $PSScriptRoot)
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
    $KnownParameters = 'SSHSession', 'Interface'

    It "Should contain our specific parameters" {
      (@(Compare-Object -ReferenceObject $KnownParameters -DifferenceObject $params -IncludeEqual |
            Where-Object SideIndicator -eq "==").Count) | Should Be $KnownParameters.Count
    }
  }

  Context "Code Execution" {
    Mock 'Invoke-SSHCommandStream' {
      @'
'@
    }
    Mock 'Write-Output' {}

    $Result = Get-EPWifiConnection -Interface 'wlan0'

    It 'Assert Invoke-SSHCommandStream is called exactly 1 time' {
      $AMCParams = @{
        CommandName = 'Invoke-SSHCommandStream'
        Times       = 1
        Exactly     = $true
      }
      Assert-MockCalled @AMCParams
    }

    It 'All result properties should be populated' {
      ($Result | Get-Member).where{$_.Name -eq 'Protocol'} | Should be $true
      ($Result | Get-Member).where{$_.Name -eq 'Hostname'} | Should be $true
      ($Result | Get-Member).where{$_.Name -eq 'Port'} | Should be $true
      ($Result | Get-Member).where{$_.Name -eq 'Username'} | Should be $true
      ($Result | Get-Member).where{$_.Name -eq 'Password'} | Should be $true
      ($Result | Get-Member).where{$_.Name -eq 'Path'} | Should be $true
    }

    It 'All result properties should have type string' {
      $Result.Protocol | Should -HaveType ([String])
      $Result.Hostname | Should -HaveType ([String])
      $Result.Port | Should -HaveType ([String])
      $Result.Username | Should -HaveType ([String])
      $Result.Password | Should -HaveType ([String])
      $Result.Path | Should -HaveType ([String])
    }

    It 'Result should have type PSCustomObject' {
      $Result | Should -HaveType ([System.Management.Automation.PSCustomObject])
    }

    It 'Result Count should be 1' {
      @($Result).Count | Should Be 1
    }

    It 'Assert Write-Output is called exactly 0 times' {
      $AMCParams = @{
        CommandName = 'Write-Output'
        Times       = 0
        Exactly     = $true
      }
      Assert-MockCalled @AMCParams
    }
  }

  Context "Error Handling" {
    Mock 'Invoke-SSHCommandStream' {throw 'Error'}
    Mock 'Write-Output' {}

    $Result = Get-EPWifiConnection -Interface 'wlan0'

    It 'Assert Write-Output is called exactly 1 time' {
      $AMCParams = @{
        CommandName = 'Write-Output'
        Times       = 1
        Exactly     = $true
      }
      Assert-MockCalled @AMCParams
    }

    It 'Result should be null or empty' {
      $Result | Should BeNullOrEmpty
    }
  }
}

Describe "$Script:FunctionName Integration Tests" -Tag "IntegrationTests" {
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