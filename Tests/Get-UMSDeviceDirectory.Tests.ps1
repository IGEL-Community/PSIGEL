$Script:ProjectRoot = Resolve-Path ('{0}\..' -f $PSScriptRoot)
$Script:ModuleRoot = Split-Path (Resolve-Path ('{0}\*\*.psm1' -f $Script:ProjectRoot))
$Script:ModuleName = Split-Path $Script:ModuleRoot -Leaf
$Script:ModuleManifest = Resolve-Path ('{0}/{1}.psd1' -f $Script:ModuleRoot, $Script:ModuleName)
$Script:FunctionName = $MyInvocation.MyCommand.Name.Replace(".Tests.ps1", "")
Import-Module ( '{0}/{1}.psm1' -f $Script:ModuleRoot, $Script:ModuleName)

Describe "$Script:FunctionName Unit Tests" -Tag 'UnitTests' {

  BeforeAll {
    if ($null -ne $Result)
    {
      Clear-Variable -Name $Result
    }
  }

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

      Mock 'Invoke-UMSRestMethodWebSession' {}

      It 'Get-UMSDeviceDirectory Should not throw' {
        { Get-UMSDeviceDirectory } | Should -Not -Throw
      }

      It 'Get-UMSDeviceDirectory -ApiVersion 10 Stop Should throw' {
        { Get-UMSDeviceDirectory -ApiVersion 10 -ErrorAction Stop } | Should -Throw
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
            objectType = 'tcdirectory'
          }
        }
      }

      $Result = Get-UMSDeviceDirectory

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
          objectType = 'tcdirectory'
        }
      }

      $Result = Get-UMSDeviceDirectory -Id 2

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
          objectType        = 'tcdirectory'
        }
      }
      Mock 'New-UMSFilterString' {}

      $Result = Get-UMSDeviceDirectory -Id 2 -Filter children

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
      Mock 'Invoke-UMSRestMethodWebSession' {throw 'Error'}

      it 'should throw Error' {
        { Get-UMSDeviceDirectory } | should throw 'Error'
      }

      It 'Result should be null or empty' {
        $Result | Should BeNullOrEmpty
      }
    }
  }
}

Describe "$Script:FunctionName Integration Tests" -Tag "IntegrationTests" {
  BeforeAll {
    if ($null -ne $Result)
    {
      Clear-Variable -Name $Result
    }
  }

  $UMS = Get-Content -Raw -Path ('{0}\Tests\UMS.json' -f $Script:ProjectRoot) |
    ConvertFrom-Json
  $CredPath = $UMS.CredPath
  $Password = Get-Content $CredPath | ConvertTo-SecureString
  $Credential = New-Object System.Management.Automation.PSCredential($UMS.User, $Password)
  $Id = $UMS.UMSDeviceDirectory[0].Id
  $Name = $UMS.UMSDeviceDirectory[0].Name

  $PSDefaultParameterValues = @{
    '*-UMS*:Credential'       = $Credential
    '*-UMS*:Computername'     = $UMS.Computername
    '*-UMS*:SecurityProtocol' = $UMS.SecurityProtocol
    '*-UMS*:Id'               = $Id
  }

  $WebSession = New-UMSAPICookie -Credential $Credential
  $PSDefaultParameterValues += @{
    '*-UMS*:WebSession' = $WebSession
  }

  Context "ParameterSetName All" {

    It "doesn't throw" {
      { $Script:Result = Get-UMSDeviceDirectory } | Should Not Throw
    }

    It 'Result should not be null or empty' {
      $Result | Should not BeNullOrEmpty
    }

    It 'Result.Id should have type [Int]' {
      $Result.Id | Should -HaveType [Int]
    }

    It "Result.Id should be exactly $Id" {
      $Result.Id | Should -BeExactly $Id
    }

    It 'Result.Name should have type [String]' {
      $Result.Name | Should -HaveType [String]
    }

    It "Result.Name should be exactly $Name" {
      $Result.Name | Should -BeExactly $Name
    }
  }
}