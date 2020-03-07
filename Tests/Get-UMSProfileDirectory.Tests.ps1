$Script:ProjectRoot = Resolve-Path ('{0}\..' -f $PSScriptRoot)
$Script:ModuleRoot = Split-Path (Resolve-Path ('{0}\*\*.psm1' -f $Script:ProjectRoot))
$Script:ModuleName = Split-Path $Script:ModuleRoot -Leaf
$Script:ModuleManifest = Resolve-Path ('{0}/{1}.psd1' -f $Script:ModuleRoot, $Script:ModuleName)
$Script:FunctionName = $MyInvocation.MyCommand.Name.Replace(".Tests.ps1", "")
Import-Module ( '{0}/{1}.psm1' -f $Script:ModuleRoot, $Script:ModuleName) -Force

Describe "$Script:FunctionName Unit Tests" -Tag 'UnitTests' {

  Context "Basics" {

    It "Is valid Powershell (Has no script errors)" {
      $Content = Get-Content -Path ( '{0}\Public\{1}.ps1' -f $Script:ModuleRoot, $Script:FunctionName) -ErrorAction Stop
      $ErrorColl = $Null
      $Null = [System.Management.Automation.PSParser]::Tokenize($Content, [ref]$ErrorColl)
      $ErrorColl | Should -HaveCount 0
    }

    [object[]]$params = (Get-ChildItem function:\$Script:FunctionName).Parameters.Keys
    $KnownParameters = 'Computername', 'TCPPort', 'ApiVersion', 'SecurityProtocol', 'WebSession', 'Filter', 'Id'

    It "Should contain our specific parameters" {
      (@(Compare-Object -ReferenceObject $KnownParameters -DifferenceObject $params -IncludeEqual |
          Where-Object SideIndicator -eq "==").Count) | Should Be $KnownParameters.Count
    }
  }

  InModuleScope $Script:ModuleName {

    $PSDefaultParameterValues = @{
      '*:WebSession'   = New-MockObject -Type 'System.Management.Automation.PSCustomObject'
      '*:Computername' = 'igelrmserver.acme.org'
    }

    Context "General Execution" {

      Mock 'Invoke-UMSRestMethodWebSession' { }

      It 'Get-UMSProfileDirectory Should not throw' {
        { Get-UMSProfileDirectory } | Should -Not -Throw
      }

      It 'Get-UMSProfileDirectory -ApiVersion 10 Stop Should throw' {
        { Get-UMSProfileDirectory -ApiVersion 10 -ErrorAction Stop } | Should -Throw
      }

    }

    Context "ParameterSetName All" {

      Mock 'Invoke-UMSRestMethodWebSession' {
        [pscustomobject]@{
          SyncRoot = @{
            id         = '2'
            name       = 'ProfileName'
            parentID   = '20'
            movedToBin = 'false'
            objectType = 'profiledirectory'
          }
        }
      }

      $Result = Get-UMSProfileDirectory

      It 'Assert Invoke-UMSRestMethodWebSession is called exactly 1 time' {
        $AMCParams = @{
          CommandName = 'Invoke-UMSRestMethodWebSession'
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

    Context "ParameterSetName ID" {

      Mock 'Invoke-UMSRestMethodWebSession' {
        [pscustomobject]@{
          id         = '2'
          name       = 'ProfileName'
          parentID   = '20'
          movedToBin = 'false'
          objectType = 'profiledirectory'
        }
      }

      $Result = Get-UMSProfileDirectory -Id 2

      It 'Assert Invoke-UMSRestMethodWebSession is called exactly 1 time' {
        $AMCParams = @{
          CommandName = 'Invoke-UMSRestMethodWebSession'
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

    Context "Filter children" {

      Mock 'Invoke-UMSRestMethodWebSession' {
        [pscustomobject]@{
          DirectoryChildren = @(
            @{
              objectType = 'profile'
              id         = '2'
            }
            @{
              objectType = 'profile'
              id         = '2'
            }
          )
          id                = '2'
          name              = 'ProfileName'
          parentID          = '20'
          movedToBin        = 'false'
          objectType        = 'profiledirectory'
        }
      }
      Mock 'New-UMSFilterString' { }

      $Result = Get-UMSProfileDirectory -Id 2 -Filter children

      It 'Assert New-UMSFilterString is called exactly 1 time' {
        $AMCParams = @{
          CommandName = 'New-UMSFilterString'
          Times       = 1
          Exactly     = $true
        }
        Assert-MockCalled @AMCParams
      }

      It 'Assert Invoke-UMSRestMethodWebSession is called exactly 1 time' {
        $AMCParams = @{
          CommandName = 'Invoke-UMSRestMethodWebSession'
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

      It 'Result.DirectoryChildren[0].Id should be exactly 2' {
        $Result.DirectoryChildren[0].Id | Should Be 2
      }

      It 'Result.DirectoryChildren[0].Id should have type [Int]' {
        $Result.DirectoryChildren[0].Id | Should -HaveType [Int]
      }
    }

    Context "Error Handling" {
      Mock 'Invoke-UMSRestMethodWebSession' { throw 'Error' }

      it 'should throw Error' {
        { Get-UMSProfileDirectory } | should throw 'Error'
      }

      It 'Result should be null or empty' {
        $Result | Should BeNullOrEmpty
      }
    }
  }
}

Describe "$Script:FunctionName Integration Tests" -Tag "IntegrationTests" {
  $Cfg = Import-PowerShellDataFile -Path ('{0}\Tests\IntegrationTestsConfig.psd1' -f $Script:ProjectRoot)
  $Credential = Import-Clixml -Path $Cfg.CredPath

  $PSDefaultParameterValues = @{
    '*-UMS*:Credential'       = $Credential
    '*-UMS*:Computername'     = $Cfg.Computername
    '*-UMS*:TCPPort'          = $Cfg.TCPPort
    '*-UMS*:SecurityProtocol' = $Cfg.SecurityProtocol
    '*-UMS*:Confirm'          = $False
  }

  $WebSession = New-UMSAPICookie
  $PSDefaultParameterValues += @{
    '*-UMS*:WebSession' = $WebSession
  }

  Context "ParameterSetName Default" {

    $TestCfg = (($Cfg.Tests).where{ $_.Function -eq $FunctionName }).ParameterSets.Default

    It "doesn't throw" {
      { $Script:Result = @(
          Get-UMSProfileDirectory
        ) } | Should Not Throw
    }

    It 'Result should not be null or empty' {
      $Result | Should not BeNullOrEmpty
    }

    It 'Result[0].Id should have type [Int]' {
      $Result[0].Id | Should -HaveType [Int]
    }

    It 'Result[0].Name should have type [String]' {
      $Result[0].Name | Should -HaveType [String]
    }

    It 'Result[0].MovedToBin should have type [Bool]' {
      $Result[0].MovedToBin | Should -HaveType [Bool]
    }

    It "Result should be Equivalent to Expected" {
      [array]$Expected = foreach ($item In $TestCfg.Expected)
      {
        New-Object psobject -Property $item
      }
      Assert-Equivalent -Actual $Result -Expected $Expected -Options @{
        ExcludedPaths = $TestCfg.Options.ExcludedPaths
      }
    }
  }

  Context "ParameterSetName Children" {

    $Script:Result = ''
    $TestCfg = (($Cfg.Tests).where{ $_.Function -eq $FunctionName }).ParameterSets.Children

    It "doesn't throw" {
      $Params1 = $TestCfg.Params1
      { $Script:Result = @(
          Get-UMSProfileDirectory @Params1
        ) } | Should Not Throw
    }

    It 'Result should not be null or empty' {
      $Result | Should not BeNullOrEmpty
    }

    It 'Result[0].Id should have type [Int]' {
      $Result[0].Id | Should -HaveType [Int]
    }

    It 'Result[0].Name should have type [String]' {
      $Result[0].Name | Should -HaveType [String]
    }

    It 'Result[0].MovedToBin should have type [Bool]' {
      $Result[0].MovedToBin | Should -HaveType [Bool]
    }

    It "Result should be Equivalent to Expected" {
      [array]$Expected = foreach ($item In $TestCfg.Expected)
      {
        New-Object psobject -Property $item
      }
      Assert-Equivalent -Actual $Result -Expected $Expected -Options @{
        ExcludedPaths = $TestCfg.Options.ExcludedPaths
      }
    }
  }

}