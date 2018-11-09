function Get-EPFirmware
{
  <#
    .SYNOPSIS
    Get Firmware from IGEL EndPoint via SSH.

    .DESCRIPTION
    Get Firmware from IGEL EndPoint via SSH.

    .EXAMPLE
    $Params = @{
      SSHSession = New-EPSSHSession -ComputerName TC035681 -Credential (Get-Credential) -AcceptKey
    }
    Get-EPFirmware @Params
  #>

  [CmdletBinding()]
  param (
    $SSHSession
  )

  begin
  {
  }
  process
  {
    $Command = {cat /etc/firmware}
    try
    {
      Invoke-EPSSHCommandStream -SSHSession $SSHSession -Command $Command
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