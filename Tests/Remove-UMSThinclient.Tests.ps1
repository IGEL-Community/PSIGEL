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

    [object[]]$Params = (Get-ChildItem function:\$Script:FunctionName).Parameters.Keys
    $KnownParameters = 'Computername', 'TCPPort', 'ApiVersion', 'SecurityProtocol', 'WebSession', 'Id', 'Online'

    It "Should contain our specific parameters" {
      (@(Compare-Object -ReferenceObject $KnownParameters -DifferenceObject $Params -IncludeEqual |
            Where-Object SideIndicator -eq "==").Count) | Should Be $KnownParameters.Count
    }
  }

  InModuleScope $Script:ModuleName {

    $PSDefaultParameterValues = @{
      '*:WebSession'   = New-MockObject -Type 'System.Management.Automation.PSCustomObject'
      '*:Computername' = 'dummyserver'
      '*:Confirm'      = $false
    }

    Context "General Execution" {

      Mock 'Invoke-UMSRestMethodWebSession' {}

      It "Remove-UMSThinclient -Id 2 Should not throw" {
        { Remove-UMSThinclient -Id 2 } | Should -Not -Throw
      }
    }

    Context "ParmeterSet Offline" {

      Mock 'Invoke-UMSRestMethodWebSession' {
        (
          [pscustomobject]@{
            message = 'Offline deletion successful'
          }
        )
      }

      $Result = Remove-UMSThinclient -Id 2

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

      It "Result.Message should be exactly 'Offline deletion successful.'" {
        $Result.Message | Should Be 'Offline deletion successful.'
      }

      It 'Result.Id should be exactly 2' {
        $Result.Id | Should Be 2
      }

      It 'Result.Id should have type [int]' {
        $Result.Id | Should -HaveType [int]
      }
    }

    Context "ParameterSet Online" {

      Mock 'Invoke-UMSRestMethodWebSession' {
        (
          [pscustomobject]@{
            CommandExecList = (
              @{
                execID   = 'ID-PM-MH-WIN7-UMS-63885-1424682219085-5-0'
                mac      = '008064AD82FB'
                message  = 'OK'
                exectime = '1424698605821'
                state    = 'SUCCESS'
              }
            )
          }
        )
      }

      $Result = Remove-UMSThinclient -Id 2

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

      It "Result.CommandExecList.Message should be exactly 'OK.'" {
        $Result.CommandExecList.Message | Should Be 'OK.'
      }

      It 'Result.CommandExecList.Id should be exactly 2' {
        $Result.CommandExecList.Id | Should Be 2
      }

      It 'Result.Id should have type [int]' {
        $Result.Id | Should -HaveType [int]
      }
    }

    Context "Whatif" {

      Mock 'Invoke-UMSRestMethodWebSession' {}

      $Result = Remove-UMSProfileAssignment -Id 2 -ReceiverId 2 -ReceiverType 'tcdirectory' -WhatIf

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

    Context "Confirm" -Tag Interactive {

      Mock 'Invoke-UMSRestMethodWebSession' {
        (
          [pscustomobject]@{
            message = 'Offline deletion successful'
          }
        )
      }

      $Result = Remove-UMSThinclient -Id 2 -Confirm:$true

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
      Mock 'Invoke-UMSRestMethodWebSession' {throw 'Error'}

      It "Remove-UMSThinclient -Id 2 -ApiVersion 10 -ErrorAction Stop Should throw" {
        { Remove-UMSThinclient -Id 2 -ApiVersion 10 -ErrorAction Stop } | Should -Throw
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

  $UMS = Get-Content -Raw -Path ('{0}\Tests\UMS.json' -f $Script:ProjectRoot) |
    ConvertFrom-Json
  $CredPath = $UMS.CredPath
  $Password = Get-Content $CredPath | ConvertTo-SecureString
  $Credential = New-Object System.Management.Automation.PSCredential($UMS.User, $Password)
  $ID = 552

  $PSDefaultParameterValues = @{
    '*-UMS*:Credential'       = $Credential
    '*-UMS*:Computername'     = $UMS.Computername
    '*-UMS*:SecurityProtocol' = $UMS.SecurityProtocol
    '*-UMS*:Confirm'          = $false
    '*-UMS*:Id'               = $Id
  }

  $WebSession = New-UMSAPICookie -Credential $Credential
  $PSDefaultParameterValues += @{
    '*-UMS*:WebSession' = $WebSession
  }

  Context "ParameterSetName All" {

    It "doesn't throw" {
      { $Script:Result = Remove-UMSProfile } | Should Not Throw
    }

    It 'Result should not be null or empty' {
      $Result | Should not BeNullOrEmpty
    }

    It 'Result[0].Id should be have type [int]' {
      $Result[0].Id | Should -HaveType [int]
    }

    It "Result[0].Id should be exactly $Id" {
      $Result[0].Id | Should -BeExactly $Id
    }
  }
}