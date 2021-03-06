$Script:ProjectRoot = Resolve-Path ('{0}\..' -f $PSScriptRoot)
$Script:ModuleRoot = Split-Path (Resolve-Path ('{0}\*\*.psm1' -f $Script:ProjectRoot))
$Script:ModuleName = Split-Path $Script:ModuleRoot -Leaf
$Script:ModuleManifest = Resolve-Path ('{0}/{1}.psd1' -f $Script:ModuleRoot, $Script:ModuleName)
$Script:ScriptName = $MyInvocation.MyCommand.Name.Replace(".Tests.ps1", "")
Import-Module ( '{0}/{1}.psm1' -f $Script:ModuleRoot, $Script:ModuleName) -Force

Describe "$Script:ScriptName Unit Tests" -Tag 'UnitTests' {

  Context "Basics" {

    It "Is valid Powershell (Has no script errors)" {
      $Content = Get-Content -Path ( '{0}\Public\{1}.ps1' -f $Script:ModuleRoot, $Script:ScriptName) -ErrorAction Stop
      $ErrorColl = $Null
      $Null = [System.Management.Automation.PSParser]::Tokenize($Content, [ref]$ErrorColl)
      $ErrorColl | Should -HaveCount 0
    }

    [object[]]$Params = (Get-ChildItem function:\$Script:ScriptName).Parameters.Keys
    $KnownParameters = 'Computername', 'TCPPort', 'ApiVersion', 'SecurityProtocol', 'WebSession', 'Mac', 'FirmwareId', 'Name',
    'ParentId', 'Site', 'Department', 'CostCenter', 'LastIP', 'Comment', 'AssetId', 'InserviceDate', 'SerialNumber'

    It "Should contain our specific parameters" {
      (@(Compare-Object -ReferenceObject $KnownParameters -DifferenceObject $Params -IncludeEqual |
          Where-Object SideIndicator -eq "==").Count) | Should Be $KnownParameters.Count
    }
  }

  InModuleScope $Script:ModuleName {

    $PSDefaultParameterValues = @{
      '*:WebSession'   = New-MockObject -Type 'System.Management.Automation.PSCustomObject'
      '*:Computername' = 'igelrmserver.acme.org'
      '*:Confirm'      = $false
    }

    Context "General Execution" {

      Mock 'Invoke-UMSRestMethod' { }

      It "New-UMSDevice -Mac '001122334455' -FirmwareId 2 -LastIP '192.168.0.1' Should not throw" {
        { New-UMSDevice -Mac '001122334455' -FirmwareId 2 -LastIP '192.168.0.1' } | Should -Not -Throw
      }
    }

    Context "All" {

      Mock 'Invoke-UMSRestMethod' {
        (
          [pscustomobject]@{
            message  = 'Thin client successfully inserted.'
            id       = '2'
            name     = 'NameNew'
            parentID = -1
          }
        )
      }

      $Result = New-UMSDevice -Mac '001122334455' -FirmwareId 2 -LastIP '192.168.0.1'

      It 'Assert Invoke-UMSRestMethod is called exactly 1 time' {
        $AMCParams = @{
          CommandName = 'Invoke-UMSRestMethod'
          Times       = 1
          Exactly     = $true
        }
        Assert-MockCalled @AMCParams
      }

      It 'Result should have type pscustomobject' {
        $Result | Should -HaveType ([pscustomobject])
      }

      It 'Result should have 1 element' {
        @($Result).Count | Should BeExactly 1
      }

      It 'Result.Id should be exactly 2' {
        $Result.Id | Should Be 2
      }

      It 'Result.Id should have type [Int]' {
        $Result.Id | Should -HaveType [Int]
      }
    }

    Context "Whatif" {

      Mock 'Invoke-UMSRestMethod' { }

      $Result = New-UMSDevice -Mac '001122334455' -FirmwareId 2 -LastIP '192.168.0.1' -WhatIf

      It 'Assert Invoke-UMSRestMethod is called exactly 0 times' {
        $AMCParams = @{
          CommandName = 'Invoke-UMSRestMethod'
          Times       = 0
          Exactly     = $true
        }
        Assert-MockCalled @AMCParams
      }

      It 'Result should be null or empty' {
        $Result | Should BeNullOrEmpty
      }
    }

    Context "Error Handling" {
      Mock 'Invoke-UMSRestMethod' { throw 'Error' }

      It "New-UMSDevice -Mac '001122334455' -FirmwareId 2 -LastIP '192.168.0.1' -ApiVersion 10 -ErrorAction Stop Should throw" {
        { New-UMSDevice -Mac '001122334455' -FirmwareId 2 -LastIP '192.168.0.1' -ApiVersion 10 -ErrorAction Stop } | Should -Throw
      }

      It 'Result should be null or empty' {
        $Result | Should BeNullOrEmpty
      }
    }
  }
}

Describe "$Script:ScriptName Integration Tests" -Tag "IntegrationTests" {
  $Cfg = Import-PowerShellDataFile -Path ('{0}\Tests\Config.psd1' -f $Script:ProjectRoot)
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
  }

  $WebSession = New-UMSAPICookie
  $PSDefaultParameterValues += @{
    '*-UMS*:WebSession' = $WebSession
  }

  Context "ParameterSetName Default" {

    $TestCfg = (($Cfg.Tests).where{ $_.Name -eq $ScriptName }).ParameterSets.Default

    It "doesn't throw" {
      $Params1 = $TestCfg.Params1
      $Params2 = $TestCfg.Params2
      { $Script:Result = @(
          New-UMSDevice @Params1
          New-UMSDevice @Params2
        ) } | Should Not Throw
    }

    It 'Result should not be null or empty' {
      $Result | Should not BeNullOrEmpty
    }

    It 'Result[0].Id should have type [Int]' {
      $Result[0].Id | Should -HaveType [Int]
    }

    It 'Result[0].Mac should have type [String]' {
      $Result[0].Mac | Should -HaveType [String]
    }

    It 'Result[0].Message should have type [String]' {
      $Result[0].Message | Should -HaveType [String]
    }

    It 'Result[0].Name should have type [String]' {
      $Result[0].Name | Should -HaveType [String]
    }

    It 'Result[0].ParentId should have type [Int]' {
      $Result[0].ParentId | Should -HaveType [Int]
    }

    It "Result should be Equivalent to Expected" {
      $Expected = foreach ($item In $TestCfg.Expected)
      {
        New-Object psobject -Property $item
      }
      Assert-Equivalent -Actual $Result -Expected $Expected -Options @{
        ExcludedPaths = $TestCfg.Options.ExcludedPaths
      }
    }

  }
}