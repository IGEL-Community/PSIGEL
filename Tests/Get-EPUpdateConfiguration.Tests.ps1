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
protocol="http"
hostname="igelrmserver.acme.org"
port="8443"
username="igelums"
password="00a8430e21213a154e5c2f"
path="ums_filetransfer/IGEL_Universal_Desktop_LX-10.05.500"
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

    It 'Result Count should be 1' {
      @($Result).Count | Should Be 1
    }

    It 'Result should have type [pscustomobject]' {
      $Result | Should -HaveType [pscustomobject]
    }

    It 'Result.Protocol should be exactly http' {
      $Result.Protocol | Should BeExactly 'http'
    }

    It 'Result.Hostname should be exactly igelrmserver.acme.org' {
      $Result.Hostname | Should BeExactly 'igelrmserver.acme.org'
    }

    It 'Result.Port should have type [Int]' {
      $Result.Port | Should -HaveType [Int]
    }

    It 'Result.Port should be exactly 8443' {
      $Result.Port | Should BeExactly 8443
    }

    It 'Result.Username should be exactly igelums' {
      $Result.Username | Should BeExactly 'igelums'
    }

    It 'Result.Password should be exactly 00a8430e21213a154e5c2f' {
      $Result.Password | Should BeExactly '00a8430e21213a154e5c2f'
    }

    It 'Result.Path should be exactly ums_filetransfer/IGEL_Universal_Desktop_LX-10.05.500' {
      $Result.Path | Should BeExactly 'ums_filetransfer/IGEL_Universal_Desktop_LX-10.05.500'
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