$Script:ProjectRoot = Resolve-Path ('{0}\..' -f $PSScriptRoot)
$Script:ModuleRoot = Split-Path (Resolve-Path ('{0}\*\*.psm1' -f $Script:ProjectRoot))
$Script:ModuleName = Split-Path $Script:ModuleRoot -Leaf
$Script:ModuleManifest = Resolve-Path ('{0}/{1}.psd1' -f $Script:ModuleRoot, $Script:ModuleName)
$Script:FunctionName = $MyInvocation.MyCommand.Name.Replace(".Tests.ps1", "")
Import-Module ( '{0}/{1}.psm1' -f $Script:ModuleRoot, $Script:ModuleName)

Describe "$Script:FunctionName Unit Tests" -Tag 'UnitTests' {

  Context "Basics" {

    It "Is valid Powershell (Has no script errors)" {
      $Content = Get-Content -Path ( '{0}\Public\{1}.ps1' -f $Script:ModuleRoot, $Script:FunctionName) -ErrorAction Stop
      $ErrorColl = $Null
      $Null = [System.Management.Automation.PSParser]::Tokenize($Content, [ref]$ErrorColl)
      $ErrorColl | Should -HaveCount 0
    }

    [object[]]$params = (Get-ChildItem function:\$Script:FunctionName).Parameters.Keys
    $KnownParameters = 'Computername', 'TCPPort', 'ApiVersion', 'SecurityProtocol', 'WebSession', 'Id'

    It "Should contain our specific parameters" {
      (@(Compare-Object -ReferenceObject $KnownParameters -DifferenceObject $params -IncludeEqual |
            Where-Object SideIndicator -eq "==").Count) | Should Be $KnownParameters.Count
    }
  }

  InModuleScope $Script:ModuleName {

    $PSDefaultParameterValues = @{
      '*:WebSession'                        = New-MockObject -Type 'System.Management.Automation.PSCustomObject'
      '*:Computername'                      = 'igelrmserver.acme.org'
      'Get-UMSDeviceDirectoryAssignment:Id' = 2
    }

    Context "General Execution" {

      Mock 'Invoke-UMSRestMethodWebSession' {}

      It 'Get-UMSDeviceDirectoryAssignment Should not throw' {
        { Get-UMSDeviceDirectoryAssignment } | Should -Not -Throw
      }

      It 'Get-UMSDeviceDirectoryAssignment -ApiVersion 10 Stop Should throw' {
        { Get-UMSDeviceDirectoryAssignment -ApiVersion 10 -ErrorAction Stop } | Should -Throw
      }

    }

    Context "All" {

      Mock 'Invoke-UMSRestMethodWebSession' {
        (
          [pscustomobject]@{
            assignee           = @{
              id   = '2'
              type = 'profile'
            }
            receiver           = @{
              id   = '2'
              type = 'tcdirectory'
            }
            assignmentPosition = 0
          }
        )
      }

      $Result = Get-UMSDeviceDirectoryAssignment -Id 2

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

      It 'Result[0] should have type [pscustomobject]' {
        $Result[0] | Should -HaveType [pscustomobject]
      }

      It 'Result[0].Id should be exactly 2' {
        $Result[0].Id | Should BeExactly 2
      }

      It 'Result[0].Id should have type [Int]' {
        $Result[0].Id | Should -HaveType [Int]
      }

    }

    Context "Error Handling" {
      Mock 'Invoke-UMSRestMethodWebSession' {throw 'Error'}

      it 'should throw Error' {
        { Get-UMSDeviceDirectoryAssignment } | should throw 'Error'
      }

      It 'Result should be null or empty' {
        $Result | Should BeNullOrEmpty
      }
    }
  }
}

Describe "$Script:FunctionName Integration Tests" -Tag "IntegrationTests" {
  $UMS = Get-Content -Raw -Path ('{0}\Tests\UMS.json' -f $Script:ProjectRoot) |
    ConvertFrom-Json
  $Credential = Import-Clixml -Path $UMS.CredPath
  $Id = $UMS.UMSDeviceDirectoryAssignment[0].Id
  $ReceiverType = $UMS.UMSDeviceDirectoryAssignment.ReceiverType
  $AssigneeId = $UMS.UMSDeviceDirectoryAssignment.AssigneeId

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
      { $Script:Result = Get-UMSDeviceDirectoryAssignment } | Should Not Throw
    }

    It 'Result should not be null or empty' {
      $Result | Should not BeNullOrEmpty
    }

    It 'Result.Id should have type [Int]' {
      $Result.Id | Should -HaveType [Int]
    }

    It "Result.Id should be exactly $UMS.UMSDeviceDirectoryAssignment.Id" {
      $Result.Id | Should -BeExactly $UMS.UMSDeviceDirectoryAssignment.Id
    }

    It 'Result.ReceiverType should have type [String]' {
      $Result.ReceiverType | Should -HaveType [String]
    }

    It "Result.ReceiverType should be exactly $ReceiverType)" {
      $Result.ReceiverType | Should -BeExactly $ReceiverType
    }

    It 'Result.AssigneeID should have type [Int]' {
      $Result.AssigneeID | Should -HaveType [Int]
    }

    It "Result.AssigneeID should be exactly $AssigneeId)" {
      $Result.AssigneeID | Should -BeExactly $AssigneeId
    }
  }
}