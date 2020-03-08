$Script:ProjectRoot = Resolve-Path ('{0}\..' -f $PSScriptRoot)
$Script:ModuleRoot = Split-Path (Resolve-Path ('{0}\*\*.psm1' -f $Script:ProjectRoot))
$Script:ModuleName = Split-Path $Script:ModuleRoot -Leaf
$Script:ModuleManifest = Resolve-Path ('{0}/{1}.psd1' -f $Script:ModuleRoot, $Script:ModuleName)
$Script:FunctionName = $MyInvocation.MyCommand.Name.Replace(".Tests.ps1", "")
Import-Module ( '{0}/{1}.psm1' -f $Script:ModuleRoot, $Script:ModuleName) -Force

Describe "$Script:FunctionName Integration Tests" -Tag "IntegrationTests" {
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

    $TestCfg = (($Cfg.Tests).where{ $_.Function -eq $FunctionName }).ParameterSets.ValueFromPipeline

    It "doesn't throw" {
      $NewParams = $TestCfg.NewParams
      $MoveParams = $TestCfg.MoveParams
      $UpdateParams = $TestCfg.UpdateParams
      Write-Host $Params1.Mac
      { $Script:Result = @(
          $null = [pscustomobject]$NewParams |
          New-UMSDevice | Tee-Object -Variable 'NewUMSDevice' |
          Move-UMSDevice @MoveParams | Tee-Object -Variable 'MoveUMSDevice' |
          Update-UMSDevice @UpdateParams | Tee-Object -Variable 'UpdateUMSDevice' |
          Remove-UMSDevice | Tee-Object -Variable 'RemoveUMSDevice'
          $NewUMSDevice
          $MoveUMSDevice
          $UpdateUMSDevice
          $RemoveUMSDevice
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


    $TestCfg = (($Cfg.Tests).where{ $_.Function -eq $FunctionName }).ParameterSets.ValueFromPipelineByPropertyName

    It "doesn't throw" {
      $NewParams = $TestCfg.NewParams
      $MoveParams = $TestCfg.MoveParams
      $UpdateParams = $TestCfg.UpdateParams
      { $Script:Result = @(
          $null = ((($NewParams.Mac |
                New-UMSDevice -FirmwareId $NewParams.FirmwareId | Tee-Object -Variable 'NewUMSDevice').Id |
              Move-UMSDevice @MoveParams | Tee-Object -Variable 'MoveUMSDevice').Id |
            Update-UMSDevice @UpdateParams | Tee-Object -Variable 'UpdateUMSDevice').Id |
          Remove-UMSDevice | Tee-Object -Variable 'RemoveUMSDevice'
          $NewUMSDevice
          $MoveUMSDevice
          $UpdateUMSDevice
          $RemoveUMSDevice
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