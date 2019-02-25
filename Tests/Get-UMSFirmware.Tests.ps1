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
    $KnownParameters = 'Computername', 'TCPPort', 'ApiVersion', 'SecurityProtocol', 'WebSession', 'FirmwareID'

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

      It 'Get-UMSFirmware Should not throw' {
        { Get-UMSFirmware } | Should -Not -Throw
      }

      It 'Get-UMSFirmware -Details Error -ErrorAction Stop Should throw' {
        { Get-UMSFirmware -Details Error -ErrorAction Stop } | Should -Throw
      }

    }

    Context "ParameterSetName All" {

      Mock 'Invoke-UMSRestMethodWebSession' {
        [pscustomobject]@{
          FwResource = @{
            id           = '2'
            product      = 'IGEL OS 11'
            version      = '11.01.100.01'
            firmwareType = 'LX'
            links        = '{}'
          }
        }
      }

      $Result = Get-UMSFirmware

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
        $Result.id | Should BeExactly 2
      }

      It 'Result.id should have type [int]' {
        $Result.id | Should -HaveType [int]
      }
    }

    Context "ParameterSetName ID" {

      Mock 'Invoke-UMSRestMethodWebSession' {
        [pscustomobject]@{
          id           = '2'
          product      = 'IGEL OS 11'
          version      = '11.01.100.01'
          firmwareType = 'LX'
          links        = '{}'
        }
      }

      $Result = Get-UMSFirmware -FirmwareID 2

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
        $Result.id | Should BeExactly 2
      }

      It 'Result.id should have type [int]' {
        $Result.id | Should -HaveType [int]
      }
    }

    Context "Error Handling" {
      Mock 'Invoke-UMSRestMethodWebSession' {throw 'Error'}

      it 'should throw Error' {
        { Get-UMSFirmware } | should throw 'Error'
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
      { Get-UMSFirmware }  | Should Not Throw
    }

    $Result = Get-UMSFirmware

    It 'Result should not be null or empty' {
      $Result | Should not BeNullOrEmpty
    }

    It 'Result.id should be have type [int]' {
      $Result[0].id | Should -HaveType [int]
    }

    It 'Result.firmwareType should be have type [string]' {
      $Result[0].firmwareType | Should -HaveType [string]
    }

    It 'Result.firmwareType should not be null or empty' {
      $Result[0].firmwareType | Should -Not -BeNullOrEmpty
    }
  }
}