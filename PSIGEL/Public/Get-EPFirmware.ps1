#Requires -Modules Posh-SSH
function Get-EPFirmware
{
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    $SSHSession
  )

  begin
  {
    $Command = "cat /etc/firmware"
  }
  process
  {
    try
    {
      $Result = (Invoke-SSHCommandStream -SSHSession $SSHSession -Command $Command) -replace ('\s', '')
      $Result
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