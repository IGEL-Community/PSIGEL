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
      $CommandResultColl = (Invoke-SSHCommandStream -SSHSession $SSHSession -Command $Command) -replace ('\s', '')
    }
    catch
    {
      Write-Output -InputObject $PSItem.Exception.Message
    }
    $Properties = [ordered]@{
      'Version' = [string]$CommandResultColl
    }
    $Result = New-Object psobject -Property $Properties
    $Result
  }
  end
  {
  }
}