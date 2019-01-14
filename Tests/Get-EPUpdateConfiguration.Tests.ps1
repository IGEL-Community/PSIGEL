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
    $KnownParameters = 'SSHSession'

    It "Should contain our specific parameters" {
      (@(Compare-Object -ReferenceObject $KnownParameters -DifferenceObject $params -IncludeEqual |
            Where-Object SideIndicator -eq "==").Count) | Should Be $KnownParameters.Count
    }
  }

  Context "Code Execution" {
    Mock 'Invoke-SSHCommandStream' {
      @'
[UPDATECONF]
protocol="https"
hostname="UMSSERVER.acme.org"
port="8443"
username="IGEL_INTERNAL_FIRMWAREUPDATE_USER"
password="00254322502457243420006e1a6d5d3e50275c2f0e60413a1f7f00275c2e8c7d5e2a587e5e290f"
path="/ums_filetransfer/IGEL_Universal_Desktop_LX-4.14.300"
'@
    }
    Mock 'Write-Output' {}

    $Result = Get-EPUpdateConfiguration

    It 'Assert Invoke-SSHCommandStream is called exactly 1 time' {
      $AMCParams = @{
        CommandName = 'Invoke-SSHCommandStream'
        Times       = 1
        Exactly     = $true
      }
      Assert-MockCalled @AMCParams
    }

    It 'Result should have all propertie Host populated' {
      ($Result | Get-Member).where{$_.Name -eq 'Host'} | Should be $true
    }
    It 'Result should have all propertie Protocol populated' {
      ($Result | Get-Member).where{$_.Name -eq 'Protocol'} | Should be $true
    }
    It 'Result should have all propertie Hostname populated' {
      ($Result | Get-Member).where{$_.Name -eq 'Hostname'} | Should be $true
    }
    It 'Result should have all propertie Port populated' {
      ($Result | Get-Member).where{$_.Name -eq 'Port'} | Should be $true
    }
    It 'Result should have all propertie Username populated' {
      ($Result | Get-Member).where{$_.Name -eq 'Username'} | Should be $true
    }
    It 'Result should have all propertie Password populated' {
      ($Result | Get-Member).where{$_.Name -eq 'Password'} | Should be $true
    }
    It 'Result should have all propertie Path populated' {
      ($Result | Get-Member).where{$_.Name -eq 'Path'} | Should be $true
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

    $Result = Get-EPUpdateConfiguration

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