#Requires -Modules Posh-SSH
function Get-EPFirmware
{
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