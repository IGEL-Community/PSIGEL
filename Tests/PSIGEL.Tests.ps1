$ProjectRoot = Resolve-Path ('{0}\..' -f $PSScriptRoot)
$ModuleRoot = Split-Path (Resolve-Path ('{0}\*\*.psm1' -f $ProjectRoot))
$ModuleRoot
$ModuleName = Split-Path $ModuleRoot -Leaf
$ModuleManifest = Resolve-Path ('{0}/{1}.psd1' -f $ModuleRoot, $ModuleName)

Describe "General project validation: $ModuleName" {

  Context 'Basic Module Testing' {
    $Scripts = Get-ChildItem $ModuleRoot -Include *.ps1, *.psm1, *.psd1 -Recurse

    $TestCase = $Scripts | Foreach-Object {
      @{
        File = $_
      }
    }
    It "Script <file> should be valid powershell" -TestCases $TestCase {
      param(
        $File
      )

      $File.Fullname | Should Exist

      $ContentColl = Get-Content -Path $File.Fullname -ErrorAction Stop
      $ErrorColl = $Null
      $Null = [System.Management.Automation.PSParser]::Tokenize($ContentColl, [ref]$ErrorColl)
      $ErrorColl.Count | Should Be 0
    }

    It "Module '$ModuleName' can import cleanly" {
      {Import-Module ( '{0}/{1}.psm1' -f $ModuleRoot, $ModuleName) } | Should Not Throw
    }
  }

  Context 'Manifest Testing' {
    It 'Valid Module Manifest' {
      {
        $Script:Manifest = Test-ModuleManifest -Path $ModuleManifest -ErrorAction Stop -WarningAction SilentlyContinue
      } | Should Not Throw
    }
    It 'Valid Manifest Name' {
      $Script:Manifest.Name | Should be $ModuleName
    }
    It 'Generic Version Check' {
      $Script:Manifest.Version -as [Version] | Should Not BeNullOrEmpty
    }
    It 'Valid Manifest Description' {
      $Script:Manifest.Description | Should Not BeNullOrEmpty
    }
    It 'Valid Manifest Root Module' {
      $Script:Manifest.RootModule | Should Be ('{0}.psm1' -f $ModuleName)
    }
    It 'Valid Manifest GUID' {
      $Script:Manifest.Guid | Should be '4834fbc2-faf6-469c-b685-0195954fd878'
    }
    It 'No Format File' {
      $Script:Manifest.ExportedFormatFiles | Should BeNullOrEmpty
    }
  }

  Context 'Public Functions' {
    $PublicFunctions = (Get-ChildItem -Path ('{0}\Public' -f $ModuleRoot) -Filter *.ps1 |
        Select-Object -ExpandProperty Name ) -replace '\.ps1$'

    $TestCase = $PublicFunctions | Foreach-Object {
      @{
        FunctionName = $_
      }
    }

    It "Function <FunctionName> should be in manifest" -TestCases $testCase {
      param(
        $FunctionName
      )

      $ManifestFunctions = $Manifest.ExportedFunctions.Keys
      $FunctionName -in $ManifestFunctions | Should Be $true
    }

    It 'Proper Number of Functions Exported compared to Manifest' {
      $ExportedCount = Get-Command -Module $ModuleName -CommandType Function |
        Measure-Object | Select-Object -ExpandProperty Count
      $ManifestCount = $Manifest.ExportedFunctions.Count
      $ExportedCount | Should be $ManifestCount
    }

    It 'Proper Number of Functions Exported compared to Files' {
      $ExportedCount = Get-Command -Module $ModuleName -CommandType Function |
        Measure-Object | Select-Object -ExpandProperty Count
      $FileCount = Get-ChildItem -Path ('{0}\Public' -f $ModuleRoot) -Filter *.ps1 |
        Measure-Object | Select-Object -ExpandProperty Count
      $ExportedCount | Should be $FileCount
    }
  }

  Context 'Private
   Functions' {
    $PrivateFunctions = (Get-ChildItem -Path ('{0}\Private' -f $ModuleRoot) -Filter *.ps1 |
        Select-Object -ExpandProperty Name ) -replace '\.ps1$'
    $TestCase = $PrivateFunctions | Foreach-Object {
      @{
        FunctionName = $_
      }
    }

    It "Private function <FunctionName> is not directly accessible outside the module" -TestCases $testCase {
      param(
        $FunctionName
      )
      { . ('\{0}' -f $FunctionName) } | Should Throw
    }
  }
}