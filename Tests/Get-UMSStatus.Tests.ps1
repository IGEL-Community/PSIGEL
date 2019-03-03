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
    $KnownParameters = 'Computername', 'TCPPort', 'ApiVersion', 'SecurityProtocol', 'WebSession'

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

      It 'Get-UMSStatus Should not throw' {
        { Get-UMSStatus } | Should -Not -Throw
      }

      It 'Get-UMSStatus -ApiVersion 10 Stop Should throw' {
        { Get-UMSStatus -ApiVersion 10 -ErrorAction Stop } | Should -Throw
      }
    }

    Context "All" {

      Mock 'Invoke-UMSRestMethodWebSession' {
        [pscustomobject]@{
          rmGuiServerVersion = '6.01.100'
          buildNumber        = '40023'
          activeMQVersion    = '5.6.0'
          derbyVersion       = '10.12.1.1'
          serverUUID         = '472dc383-45d2-47ec-9743-c3441c461425'
          server             = 'igelrmserver.acme.org'
        }
      }

      $Result = Get-UMSStatus

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

      It 'Result.BuildNumber should be exactly 40023' {
        $Result.BuildNumber | Should Be 40023
      }

      It 'Result.BuildNumber should have type [int]' {
        $Result.BuildNumber | Should -HaveType [int]
      }
    }

    Context "Error Handling" {
      Mock 'Invoke-UMSRestMethodWebSession' {throw 'Error'}

      it 'should throw Error' {
        { Get-UMSStatus } | should throw 'Error'
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
  $RmGuiServerVersion = $UMS.UMSStatus.RmGuiServerVersion
  $BuildNumber = $UMS.UMSStatus.BuildNumber

  $PSDefaultParameterValues = @{
    '*-UMS*:Credential'       = $Credential
    '*-UMS*:Computername'     = $UMS.Computername
    '*-UMS*:SecurityProtocol' = $UMS.SecurityProtocol
  }

  $WebSession = New-UMSAPICookie -Credential $Credential
  $PSDefaultParameterValues += @{
    '*-UMS*:WebSession' = $WebSession
  }

  Context "ParameterSetName All" {

    It "doesn't throw" {
      { $Script:Result = Get-UMSStatus } | Should Not Throw
    }

    It 'Result should not be null or empty' {
      $Result | Should not BeNullOrEmpty
    }

    It 'Result.RmGuiServerVersionshould be have type [String]' {
      $Result.RmGuiServerVersion | Should -HaveType [String]
    }

    It "Result.RmGuiServerVersion should be exactly $RmGuiServerVersion" {
      $Result.RmGuiServerVersion | Should -BeExactly $RmGuiServerVersion
    }

    It 'Result.BuildNumber should be have type [Int]' {
      $Result.BuildNumber | Should -HaveType [Int]
    }

    It "Result.BuildNumber should be exactly $BuildNumber" {
      $Result.BuildNumber | Should -BeExactly $BuildNumber
    }
  }
}