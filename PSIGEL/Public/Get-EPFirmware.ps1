#Requires -Modules Posh-SSH
function Get-EPFirmware
{
  <#
    .SYNOPSIS
    Get Firmware from IGEL EndPoint via SSH.

    .DESCRIPTION
    Get Firmware from IGEL EndPoint via SSH.

    .PARAMETER SSHSession
    SSH Session to use

    .EXAMPLE
    $Params = @{
      SSHSession = New-SSHSession -ComputerName $ComputerName -Credential (Get-Credential) -AcceptKey
    }
    Get-EPFirmware @Params
  #>

  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true,
      ValueFromPipeline = $true,
      Position = 0)]
    $SSHSession
  )

  begin
  {
  }
  process
  {
    $Command = "cat /etc/firmware"
    try
    {
      $Result = Invoke-SSHCommandStream -SSHSession $SSHSession -Command $Command
      $Result -replace ('\s', '')
    }
    catch
    {
      Write-Output -InputObject $PSItem.Exception.Message
    }
  }
  end
  {
  }
}