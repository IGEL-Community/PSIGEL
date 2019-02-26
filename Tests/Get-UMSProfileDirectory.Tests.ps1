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
    $KnownParameters = 'Computername', 'TCPPort', 'ApiVersion', 'SecurityProtocol', 'WebSession', 'Facets', 'DIRID'

    It "Should contain our specific parameters" {
      (@(Compare-Object -ReferenceObject $KnownParameters -DifferenceObject $params -IncludeEqual |
            Where-Object SideIndicator -eq "==").Count) | Should Be $KnownParameters.Count
    }
  }

  InModuleScope $Script:ModuleName {

    $PSDefaultParameterValues = @{
      '*:WebSession'   = New-MockObject -Type 'System.Management.Automation.PSCustomObject'
      '*:Computername' = 'dummyserver'
    }

    Context "General Execution" {

      Mock 'Invoke-UMSRestMethodWebSession' {}

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

      It 'Result.id should be exactly 2' {
        $Result.id | Should Be 2
      }

      It 'Result.id should have type [int]' {
        $Result.id | Should -HaveType [int]
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

      $Result = Get-UMSProfileDirectory -DIRID 2

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

      It 'Result.id should be exactly 2' {
        $Result.id | Should Be 2
      }

      It 'Result.id should have type [int]' {
        $Result.id | Should -HaveType [int]
      }
    }

    Context "Facets children" {

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
      Mock 'Get-UMSFunctionString' {}

      $Result = Get-UMSProfileDirectory -DIRID 2 -Facets children

      It 'Assert Get-UMSFunctionString is called exactly 1 time' {
        $AMCParams = @{
          CommandName = 'Get-UMSFunctionString'
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

      It 'Result.DirectoryChildren[0].id should be exactly 2' {
        $Result.DirectoryChildren[0].id | Should Be 2
      }

      It 'Result.DirectoryChildren[0].id should have type [int]' {
        $Result.DirectoryChildren[0].id | Should -HaveType [int]
      }
    }

    Context "Error Handling" {
      Mock 'Invoke-UMSRestMethodWebSession' {throw 'Error'}

      it 'should throw Error' {
        { Get-UMSProfileDirectory } | should throw 'Error'
      }

      It 'Result should be null or empty' {
        $Result | Should BeNullOrEmpty
      }
    }
  }
}

Describe "$Script:FunctionName Integration Tests" -Tags "IntegrationTests" {
  BeforeAll {
    if ($null -ne $Result)
    {
      Clear-Variable -Name $Result
    }
  }

  $User = 'igelums'
  $CredPath = 'C:\Credentials\UMSRmdb.cred'
  $Password = Get-Content $CredPath | ConvertTo-SecureString
  $Credential = New-Object System.Management.Automation.PSCredential($User, $Password)

  $PSDefaultParameterValues = @{
    '*-UMS*:Credential'       = $Credential
    '*-UMS*:Computername'     = 'localhost'
    '*-UMS*:SecurityProtocol' = 'Tls12'
  }

  $WebSession = New-UMSAPICookie -Credential $Credential
  $PSDefaultParameterValues += @{
    '*-UMS*:WebSession' = $WebSession
  }

  Context "ParameterSetName All" {

    It "doesn't throw" {
      { Get-UMSProfileDirectory -DIRID 69} | Should Not Throw
    }

    $Result = Get-UMSProfileDirectory -DIRID 69

    It 'Result should not be null or empty' {
      $Result | Should not BeNullOrEmpty
    }

    It 'Result[0].id should be have type [int]' {
      $Result[0].Id | Should -HaveType [int]
    }

    It 'Result[0].name should be have type [string]' {
      $Result[0].name | Should -HaveType [string]
    }

    It 'Result[0].name should not be null or empty' {
      $Result[0].name | Should -Not -BeNullOrEmpty
    }
  }
}