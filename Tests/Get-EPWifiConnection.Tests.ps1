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
wlan0     IEEE 802.11  ESSID:"WLAN-0123456"
          Mode:Managed  Frequency:5.18 GHz  Access Point: 00:42:4C:24:E8:F9
          Bit Rate=54 Mb/s   Tx-Power=20 dBm
          Retry short  long limit:2   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality=66/70  Signal level=-44 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:17   Missed beacon:0
'@
    }
    Mock 'Write-Output' {}

    $Result = Get-DeviceWifiConnection

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

    It 'Result.ESSID should be exactly WLAN-0123456' {
      $Result.ESSID | Should BeExactly 'WLAN-0123456'
    }

    It 'Result.Mode should be exactly Managed' {
      $Result.Mode | Should BeExactly 'Managed'
    }

    It 'Result.Frequency should have type [Single]' {
      $Result.Frequency | Should -HaveType [Single]
    }

    It 'Result.Frequency should be exactly 5.18' {
      $Result.Frequency | Should BeExactly '5.18'
    }

    It 'Result.AccessPoint should be exactly 00:42:4C:24:E8:F9' {
      $Result.AccessPoint | Should BeExactly '00:42:4C:24:E8:F9'
    }

    It 'Result.BitRate should have type [Int]' {
      $Result.BitRate | Should -HaveType [Int]
    }
    
    It 'Result.BitRate should be exactly 54' {
      $Result.BitRate | Should BeExactly 54
    }
    
    It 'Result.TxPower should have type [Int]' {
      $Result.TxPower | Should -HaveType [Int]
    }

    It 'Result.TxPower should be exactly 20' {
      $Result.TxPower | Should BeExactly 20
    }

    It 'Result.LinkQualityActual should have type [Int]' {
      $Result.LinkQualityActual | Should -HaveType [Int]
    }

    It 'Result.LinkQualityActual should be exactly 66' {
      $Result.LinkQualityActual | Should BeExactly 66
    }

    It 'Result.LinkQualityMax should have type [Int]' {
      $Result.LinkQualityMax | Should -HaveType [Int]
    }

    It 'Result.LinkQualityMax should be exactly 70' {
      $Result.LinkQualityMax | Should BeExactly 70
    }

    It 'Result.SignalLevel should have type [Int]' {
      $Result.SignalLevel | Should -HaveType [Int]
    }

    It 'Result.SignalLevel should be exactly -44' {
      $Result.SignalLevel | Should BeExactly -44
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

    $Result = Get-DeviceWifiConnection -Interface 'wlan0'

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