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
    $KnownParameters = 'Computername', 'TCPPort', 'Credential', 'ApiVersion', 'SecurityProtocol'

    It "Should contain our specific parameters" {
      (@(Compare-Object -ReferenceObject $KnownParameters -DifferenceObject $params -IncludeEqual |
            Where-Object SideIndicator -eq "==").Count) | Should Be $KnownParameters.Count
    }
  }

  InModuleScope $Script:ModuleName {

    <#
    $PSDefaultParameterValues = @{
      '*-UMS*:Computername' = 'igelrmserver.acme.org'
      '*:Credential'        = New-MockObject -Type 'System.Management.Automation.PSCredential'
    }

    Context "General Execution" {

      New-UMSAPICookie -Credential $Credential
      It "New-UMSAPICookie" {
        { New-UMSAPICookie } | Should -Not -Throw
      }

      It 'New-UMSAPICookie -ApiVersion 10 Stop Should throw' {
        { New-UMSAPICookie -ApiVersion 10 -ErrorAction Stop } | Should -Throw
      }

    }

    Context "All" {

      Mock 'Invoke-UMSRestMethodWebSession' {
        (
          [pscustomobject]@{
            message = 'JSESSIONID=3FB2F3F6A089FE9029DFD6DAFEF146DC'
          }
        )
      }

      $Result = New-UMSAPICookie

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

      It 'Result[0].Id should have type [int]' {
        $Result[0].Id | Should -HaveType [int]
      }

      It "Result[0].Message should be exactly '1 asssignments successfully assigned.'" {
        $Result[0].Message | Should BeExactly '1 asssignments successfully assigned.'
      }
    }

    Context "Error Handling" {
      Mock 'Invoke-UMSRestMethodWebSession' {throw 'Error'}

      it 'should throw Error' {
        { New-UMSProfileAssignment -Id 2 -ReceiverId 2 -ReceiverType 'tc' } | should throw 'Error'
      }

      It 'Result should be null or empty' {
        $Result | Should BeNullOrEmpty
      }
    }
    #>
  }
}

Describe "$Script:FunctionName Integration Tests" -Tag "IntegrationTests" {
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
      { New-UMSProfileAssignment -Id 71} | Should Not Throw
    }

    $Result = New-UMSProfileAssignment -Id 71

    It 'Result should not be null or empty' {
      $Result | Should not BeNullOrEmpty
    }

    It 'Result[0].Id should be have type [int]' {
      $Result[0].Id | Should -HaveType [int]
    }

    It 'Result[0].Type should be have type [string]' {
      $Result[0].Type | Should -HaveType [string]
    }

    It 'Result[0].Type should not be null or empty' {
      $Result[0].Type | Should -Not -BeNullOrEmpty
    }
  }
}