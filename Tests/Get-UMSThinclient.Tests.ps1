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
    $KnownParameters = 'Computername', 'TCPPort', 'ApiVersion', 'WebSession', 'Facets', 'TCID'

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

      #$Result = Get-UMSThinclient

      It 'Get-UMSThinclient Should not throw' {
        { Get-UMSThinclient } | Should -Not -Throw
      }

      It 'Get-UMSThinclient -Details Error -ErrorAction Stop Should throw' {
        { Get-UMSThinclient -Details Error -ErrorAction Stop } | Should -Throw
      }

    }

    Context "ParameterSetName All" {

      Mock 'Invoke-UMSRestMethodWebSession' {
        [pscustomobject]@{
          SyncRoot = @{
            mac        = '0123456789AB'
            firmwareID = '1'
            lastIP     = '192.168.0.1'
            id         = '2'
            name       = 'endpoint01'
            parentID   = '3'
            movedToBin = 'False'
            objectType = 'tc'
            links      = '{}'
          }
        }
      }
      Mock 'Get-UMSFunctionString' {}

      $Result = Get-UMSThinclient

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

      It 'Result.id should be exactly 2' {
        $Result.id | Should BeExactly 2
      }
    }

    Context "ParameterSetName ID" {

      Mock 'Invoke-UMSRestMethodWebSession' {
        [pscustomobject]@{
          mac        = '0123456789AB'
          firmwareID = '1'
          lastIP     = '192.168.0.1'
          id         = '2'
          name       = 'endpoint01'
          parentID   = '3'
          movedToBin = 'False'
          objectType = 'tc'
          links      = '{}'
        }
      }
      Mock 'Get-UMSFunctionString' {}

      $Result = Get-UMSThinclient -TCID 2

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

      It 'Result.id should be exactly 2' {
        $Result.id | Should BeExactly 2
      }
    }

    Context "Facets online" {

      Mock 'Invoke-UMSRestMethodWebSession' {
        [pscustomobject]@{
          mac        = '0123456789AB'
          firmwareID = '1'
          lastIP     = '192.168.0.1'
          online     = 'False'
          id         = '2'
          name       = 'endpoint01'
          parentID   = '3'
          movedToBin = 'False'
          objectType = 'tc'
        }
      }
      Mock 'Get-UMSFunctionString' {}

      $Result = Get-UMSThinclient -TCID 2 -Facets online

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

      It 'Result.online should be exactly $false' {
        $Result.online | Should Be $false
      }

      It 'Result.online should have type [bool]' {
        $Result.online | Should -HaveType [bool]
      }
    }

    Context "Facets shadow" {

      Mock 'Invoke-UMSRestMethodWebSession' {
        [pscustomobject]@{
          mac          = '0123456789AB'
          firmwareID   = '1'
          lastIP       = '192.168.0.1'
          shadowSecret = @{
            certificate = '-----BEGIN CERTIFICATE-----..-----END CERTIFICATE-----'
            password    = '80a4f77b-552e-488d-b077-4f34ac59028e'
          }
          id           = '2'
          name         = 'endpoint01'
          parentID     = '3'
          movedToBin   = 'False'
          objectType   = 'tc'
        }
      }
      Mock 'Get-UMSFunctionString' {}

      $Result = Get-UMSThinclient -TCID 2 -Facets shadow

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

      It 'Result.shadowSecret should have type [pscustomobject]' {
        $Result.shadowSecret | Should -HaveType [pscustomobject]
      }
    }

    Context "Facets details" {

      Mock 'Invoke-UMSRestMethodWebSession' {
        [pscustomobject]@{
          mac                       = '0123456789AB'
          firmwareID                = '1'
          lastIP                    = '192.168.0.1'
          comment                   = 'comment'
          productId                 = 'UC1-LX'
          cpuSpeed                  = '1608'
          cpuType                   = 'Intel(R) Core(TM) i7-7Y75 CPU @ 1.30GHz'
          deviceType                = 'Legacy x86 system'
          deviceSerialNumber        = '0'
          osType                    = 'IGEL Linux 11 (Kernel Version 4.18.20)'
          flashSize                 = '1985'
          memorySize                = '1990'
          networkSpeed              = '100'
          graphicsChipset0          = 'VMware Inc. Abstract VGA II Adapter'
          graphicsChipset1          = ''
          monitorVendor1            = ''
          monitorModel1             = ''
          monitorSerialnumber1      = ''
          monitorNativeResolution1  = ''
          monitor1YearOfManufacture = ''
          monitor1WeekOfManufacture = ''
          monitorVendor2            = ''
          monitorModel2             = ''
          monitorSerialnumber2      = ''
          monitorSize2              = '0,0'
          monitorNativeResolution2  = ''
          monitor2YearOfManufacture = ''
          monitor2WeekOfManufacture = ''
          biosVendor                = 'innotek GmbH'
          biosVersion               = 'VirtualBox'
          biosDate                  = '12/01/2006'
          totalUsagetime            = '5433000'
          totalUptime               = '5472000'
          lastBoottime              = '2019-02-20 14:19'
          batteryLevel              = '97'
          id                        = '2'
          name                      = 'endpoint01'
          parentID                  = '3'
          movedToBin                = 'False'
          objectType                = 'tc'
        }
      }
      Mock 'Get-UMSFunctionString' {}

      $Result = Get-UMSThinclient -TCID 2 -Facets details

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

      It 'Result.networkSpeed should have type [int]' {
        $Result.networkSpeed | Should -HaveType [int]
      }

      It 'Result.lastBoottime should have type [datetime]' {
        $Result.lastBoottime | Should -HaveType [datetime]
      }
    }

    Context "Error Handling" {
      Mock 'Invoke-UMSRestMethodWebSession' {throw 'Error'}

      it 'should throw Error' {
        { Get-UMSThinclient } | should throw 'Error'
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
      { Get-UMSThinclient }  | Should Not Throw
    }

    $Result = Get-UMSThinclient

    It 'Result should not be null or empty' {
      $Result | Should not BeNullOrEmpty
    }

    It 'Result.id should be have type [int]' {
      $Result[0].id | Should -HaveType [int]
    }
  }
}