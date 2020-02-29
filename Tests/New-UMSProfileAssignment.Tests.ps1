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
    $KnownParameters = 'Computername', 'TCPPort', 'ApiVersion', 'SecurityProtocol', 'WebSession', 'Id', 'ReceiverId', 'ReceiverType'

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

      It "New-UMSProfileAssignment -Id 2 -ReceiverId 2 -ReceiverType 'tc'" {
        { New-UMSProfileAssignment -Id 2 -ReceiverId 2 -ReceiverType 'tc' } | Should -Not -Throw
      }

      It 'New-UMSProfileAssignment -ApiVersion 10 Stop Should throw' {
        { New-UMSProfileAssignment -ApiVersion 10 -ErrorAction Stop } | Should -Throw
      }

    }

    Context "tc" {

      Mock 'Invoke-UMSRestMethodWebSession' {
        (
          [pscustomobject]@{
            message = '1 asssignments successfully assigned'
          }
        )
      }

      $Result = New-UMSProfileAssignment -Id 2 -ReceiverId 2 -ReceiverType 'tc'

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

      It "Result[0].Message should be exactly '1 asssignments successfully assigned.'" {
        $Result[0].Message | Should BeExactly '1 asssignments successfully assigned.'
      }
    }

    Context "tcdirectory" {

      Mock 'Invoke-UMSRestMethodWebSession' {
        (
          [pscustomobject]@{
            message = '1 asssignments successfully assigned'
          }
        )
      }

      $Result = $Result = New-UMSProfileAssignment -Id 2 -ReceiverId 2 -ReceiverType 'tcdirectory'

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

      It "Result[0].Message should be exactly '1 asssignments successfully assigned.'" {
        $Result[0].Message | Should BeExactly '1 asssignments successfully assigned.'
      }
    }

    Context "Whatif" {

      Mock 'Invoke-UMSRestMethodWebSession' { }

      $Result = New-UMSProfileAssignment -Id 2 -ReceiverId 2 -ReceiverType 'tc' -WhatIf

      It 'Assert Invoke-UMSRestMethodWebSession is called exactly 0 times' {
        $AMCParams = @{
          CommandName = 'Invoke-UMSRestMethodWebSession'
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
      Mock 'Invoke-UMSRestMethodWebSession' { throw 'Error' }

      It 'should throw Error' {
        { New-UMSProfileAssignment  -Id 2 -ReceiverId 2 -ReceiverType 'tc' } | Should throw 'Error'
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
  }

  $WebSession = New-UMSAPICookie
  $PSDefaultParameterValues += @{
    '*-UMS*:WebSession' = $WebSession
  }

  Context "ParameterSetName All" {

    It "doesn't throw" {
      { $Script:Result = @(
          New-UMSProfileAssignment -Id 538 -ReceiverId 504 -ReceiverType tcdirectory
          538 | New-UMSProfileAssignment -ReceiverId 577 -ReceiverType tc
        ) } | Should Not Throw
    }

    It 'Result should not be null or empty' {
      $Result | Should not BeNullOrEmpty
    }

    It 'Result[0].Id should have type [Int]' {
      $Result[0].Id | Should -HaveType [Int]
    }

    It 'Result[0].Message should have type [String]' {
      $Result[0].Message | Should -HaveType [String]
    }

    It 'Result[0].ReceiverId should have type [Int]' {
      $Result[0].ReceiverId | Should -HaveType [Int]
    }

    It 'Result[0].ReceiverType should have type [String]' {
      $Result[0].ReceiverType | Should -HaveType [String]
    }

    It "Result should be Equivalent to Expected" {
      $Expected = foreach ($item In $($Cfg.Tests.'New-UMSProfileAssignment'))
      {
        New-Object psobject -Property $item
      }
      Assert-Equivalent -Actual $Result -Expected $Expected
    }

  }
}