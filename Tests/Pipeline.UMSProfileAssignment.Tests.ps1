$Script:ProjectRoot = Resolve-Path ('{0}\..' -f $PSScriptRoot)
$Script:ModuleRoot = Split-Path (Resolve-Path ('{0}\*\*.psm1' -f $Script:ProjectRoot))
$Script:ModuleName = Split-Path $Script:ModuleRoot -Leaf
$Script:ModuleManifest = Resolve-Path ('{0}/{1}.psd1' -f $Script:ModuleRoot, $Script:ModuleName)
$Script:SpecialName = $MyInvocation.MyCommand.Name.Replace(".Tests.ps1", "")
Import-Module ( '{0}/{1}.psm1' -f $Script:ModuleRoot, $Script:ModuleName) -Force

Describe "$Script:SpecialName Integration Tests" -Tag "IntegrationTests" {
  $Cfg = Import-PowerShellDataFile -Path ('{0}\Tests\IntegrationTestsConfig.psd1' -f $Script:ProjectRoot)
  $Credential = Import-Clixml -Path $Cfg.CredPath

  $PSDefaultParameterValues = @{
    '*-UMS*:Credential'       = $Credential
    '*-UMS*:Computername'     = $Cfg.Computername
    '*-UMS*:TCPPort'          = $Cfg.TCPPort
    '*-UMS*:SecurityProtocol' = $Cfg.SecurityProtocol
    '*-UMS*:Confirm'          = $False
  }

  $WebSession = New-UMSAPICookie
  $PSDefaultParameterValues += @{
    '*-UMS*:WebSession' = $WebSession
  }

  Context "ValueFromPipeline" {

    $TestCfg = (($Cfg.Tests).where{ $_.Special -eq $SpecialName }).ParameterSets.ValueFromPipeline

    It "doesn't throw" {
      $NewAssignmentParams = $TestCfg.NewAssignmentParams
      $RemoveAssignmentParams = $TestCfg.RemoveAssignmentParams
      Write-Host $Params1.Mac
      { $Script:Result = @(
          $null = [pscustomobject]$NewAssignmentParams |
          New-UMSProfileAssignment -ReceiverId $NewAssignmentParams.ReceiverId -ReceiverType $NewAssignmentParams.ReceiverType | Tee-Object -Variable 'NewUMSProfileAssignment' |
          Remove-UMSProfileAssignment -ReceiverId $RemoveAssignmentParams.ReceiverId -ReceiverType $RemoveAssignmentParams.ReceiverType | Tee-Object -Variable 'RemoveUMSProfileAssignment'
          $NewUMSProfileAssignment
          $RemoveUMSProfileAssignment
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

    It "Result should be Equivalent to Expected" {
      [array]$Expected = foreach ($item In $TestCfg.Expected)
      {
        New-Object psobject -Property $item
      }
      Assert-Equivalent -Actual $Result -Expected $Expected -Options @{
        ExcludedPaths = $TestCfg.Options.ExcludedPaths
      }
    }
    $Result = ''
  }

  Context "ValueFromPipelineByPropertyName" {

    $TestCfg = (($Cfg.Tests).where{ $_.Special -eq $SpecialName }).ParameterSets.ValueFromPipelineByPropertyName

    It "doesn't throw" {
      $NewAssignmentParams = $TestCfg.NewAssignmentParams
      $RemoveAssignmentParams = $TestCfg.RemoveAssignmentParams
      Write-Host $Params1.Mac
      { $Script:Result = @(
          $null = (($NewAssignmentParams.Id |
              New-UMSProfileAssignment -ReceiverId $NewAssignmentParams.ReceiverId -ReceiverType $NewAssignmentParams.ReceiverType | Tee-Object -Variable 'NewUMSProfileAssignment').Id |
            Remove-UMSProfileAssignment -ReceiverId $RemoveAssignmentParams.ReceiverId -ReceiverType $RemoveAssignmentParams.ReceiverType | Tee-Object -Variable 'RemoveUMSProfileAssignment').Id
          $NewUMSProfileAssignment
          $RemoveUMSProfileAssignment
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

    It "Result should be Equivalent to Expected" {
      [array]$Expected = foreach ($item In $TestCfg.Expected)
      {
        New-Object psobject -Property $item
      }
      Assert-Equivalent -Actual $Result -Expected $Expected -Options @{
        ExcludedPaths = $TestCfg.Options.ExcludedPaths
      }
    }
    $Result = ''

  }

}