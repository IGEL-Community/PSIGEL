$Script:ProjectRoot = Resolve-Path ('{0}\..' -f $PSScriptRoot)
$Script:ModuleRoot = Split-Path (Resolve-Path ('{0}\*\*.psm1' -f $Script:ProjectRoot))
$Script:ModuleName = Split-Path $Script:ModuleRoot -Leaf
$Script:ModuleManifest = Resolve-Path ('{0}/{1}.psd1' -f $Script:ModuleRoot, $Script:ModuleName)
$Script:FunctionName = $MyInvocation.MyCommand.Name.Replace(".Tests.ps1", "")
Import-Module ( '{0}/{1}.psm1' -f $Script:ModuleRoot, $Script:ModuleName)

Describe "$Script:FunctionName Unit Tests" -Tag 'UnitTests' {
  InModuleScope $Script:ModuleName {
    BeforeAll {
      $Global:ConfirmPreference = 'None'
      #. ( '{0}\Public\{1}.ps1' -f $Script:ModuleRoot, $Script:FunctionName)
      $PSDefaultParameterValues = @{
        '*:WebSession' = New-MockObject -Type 'System.Management.Automation.PSCustomObject'
      }
    }

    Context "Parameter Validation" {

      [object[]]$params = (Get-ChildItem function:\$Script:FunctionName).Parameters.Keys
      $KnownParameters = 'Computername', 'TCPPort', 'ApiVersion', 'WebSession', 'Details', 'TCID'

      It "Should contain our specific parameters" {
        (@(Compare-Object -ReferenceObject $KnownParameters -DifferenceObject $params -IncludeEqual |
              Where-Object SideIndicator -eq "==").Count) | Should Be $KnownParameters.Count
      }
    }

    Context "Code Execution" {
      Mock 'New-UMSAPICookie' {}
      Mock 'Invoke-UMSRestMethodWebSession' {}
      Mock 'Write-Output' {}

      $Result = Get-UMSThinclient -Computername 'Computername' -WebSession $null

      It 'Assert New-UMSAPICookie is called exactly 1 time' {
        $AMCParams = @{
          CommandName = 'New-UMSAPICookie'
          Times       = 1
          Exactly     = $true
        }
        Assert-MockCalled @AMCParams
      }

      It 'Result should be without white spaces' {
        $Result | Should BeExactly '1Aa.:!'
      }

      It 'Result should have type string' {
        $Result | Should -HaveType ([string])
      }

      It 'Result Count should be 1' {
        @($Result).Count | Should Be 1
      }

      It 'Assert Write-Output is called exactly 0 times' {
        $AMCParams = @{
          CommandName = 'Write-Output'
          Times       = 0
          Exactly     = $true
        }
        Assert-MockCalled @AMCParams
      }
    }

    Context "Error Handling" {
      Mock 'New-UMSAPICookie' {throw 'Error'}
      Mock 'Invoke-UMSRestMethodWebSession' {throw 'Error'}
      Mock 'Write-Output' {}

      $Result = Get-UMSThinclient

      It 'Assert Write-Output is called exactly 1 time' {
        $AMCParams = @{
          CommandName = 'Write-Output'
          Times       = 1
          Exactly     = $true
        }
        Assert-MockCalled @AMCParams
      }

      It 'Result should be null or empty' {
        $Result | Should BeNullOrEmpty
      }
    }
  }
}

Describe "$Script:FunctionName Integration Tests" -Tags "IntegrationTests" {
  <#
  BeforeAll {
    $Global:ConfirmPreference = 'None'
    . ( '{0}\Public\{1}.ps1' -f $Script:ModuleRoot, $Script:FunctionName)
    $PSDefaultParameterValues = @{
      #'*:SSHSession' = New-MockObject -Type 'SSH.SshSession'
    }
  }
  It "doesn't throw" {
    { Get-UMSThinclient }  | Should Not Throw
  }
  #>
}