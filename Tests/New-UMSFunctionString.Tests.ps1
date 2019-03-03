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
      $Content = Get-Content -Path ( '{0}\Private\{1}.ps1' -f $Script:ModuleRoot, $Script:FunctionName) -ErrorAction Stop
      $ErrorColl = $Null
      $Null = [System.Management.Automation.PSParser]::Tokenize($Content, [ref]$ErrorColl)
      $ErrorColl | Should -HaveCount 0
    }

    [object[]]$params = (Get-ChildItem function:\$Script:FunctionName).Parameters.Keys
    $KnownParameters = 'Facet'

    It "Should contain our specific parameters" {
      (@(Compare-Object -ReferenceObject $KnownParameters -DifferenceObject $params -IncludeEqual |
            Where-Object SideIndicator -eq "==").Count) | Should Be $KnownParameters.Count
    }
  }

  InModuleScope $Script:ModuleName {

    Context "General Execution" {

      It "New-UMSFunctionString -Facet 'short' Should not throw" {
        { New-UMSFunctionString -Facet 'short'} | Should -Not -Throw
      }

      It "New-UMSFunctionString -Facet 'nonexisting' -ErrorAction Stop Should throw" {
        { New-UMSFunctionString -Facet 'nonexisting' -ErrorAction Stop } | Should -Throw
      }

    }

    Context "Facet short" {

      $Result = New-UMSFunctionString -Facet short

      It 'Result should have type String' {
        $Result | Should -HaveType ([String])
      }

      It 'Result should have 1 element' {
        @($Result).Count | Should BeExactly 1
      }

      It "Result should be exactly '?facets=short'" {
        $Result | Should BeExactly '?facets=short'
      }
    }

  }
}
