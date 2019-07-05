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

      Mock 'Invoke-UMSRestMethodWebSession' {}

      It "New-UMSDevice -Mac '001122334455' -FirmwareId 2 -LastIP '192.168.0.1' Should not throw" {
        { New-UMSDevice -Mac '001122334455' -FirmwareId 2 -LastIP '192.168.0.1' } | Should -Not -Throw
      }
    }

    Context "All" {

      Mock 'Invoke-UMSRestMethodWebSession' {
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

    Context "Whatif" {

      Mock 'Invoke-UMSRestMethodWebSession' {}

      $Result = New-UMSDevice -Mac '001122334455' -FirmwareId 2 -LastIP '192.168.0.1' -WhatIf

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

      It "New-UMSDevice -Mac '001122334455' -FirmwareId 2 -LastIP '192.168.0.1' -ApiVersion 10 -ErrorAction Stop Should throw" {
        { New-UMSDevice -Mac '001122334455' -FirmwareId 2 -LastIP '192.168.0.1' -ApiVersion 10 -ErrorAction Stop } | Should -Throw
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
  $Credential = Import-Clixml -Path $UMS.CredPath
  $Name = $UMS.UMSDevice[2].NameNew
  $Mac = $UMS.UMSDevice[2].MacNew
  $FirmwareId = $UMS.UMSDevice[2].FirmwareIdNew
  $ParentId = $UMS.UMSDevice[2].ParentId

  $PSDefaultParameterValues = @{
    '*-UMS*:Credential'       = $Credential
    '*-UMS*:Computername'     = $UMS.Computername
    '*-UMS*:SecurityProtocol' = $UMS.SecurityProtocol
    '*-UMS*:Name'             = $Name
    '*-UMS*:Mac'              = $Mac
    '*-UMS*:FirmwareId'       = $FirmwareId
    '*-UMS*:ParentId'         = $ParentId
  }

  $WebSession = New-UMSAPICookie
  $PSDefaultParameterValues += @{
    '*-UMS*:WebSession' = $WebSession
  }

  Context "ParameterSetName All" {

    It "doesn't throw" {
      { $Script:Result = New-UMSDevice } | Should Not Throw
    }

    It 'Result should not be null or empty' {
      $Result | Should not BeNullOrEmpty
    }

    It 'Result[0].Id should have type [Int]' {
      $Result[0].Id | Should -HaveType [Int]
    }

    It "Result[0].Name should be exactly $Name" {
      $Result[0].Name | Should -BeExactly $Name
    }

    It "Result[0].Mac should be exactly $Mac" {
      $Result[0].Mac | Should -BeExactly $Mac
    }

    It "Result[0].ParentId should be exactly $ParentId" {
      $Result[0].ParentId | Should -BeExactly $ParentId
    }
  }
}