#Requires -Modules Posh-SSH
function Get-OSFirmware
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
      $Properties = [ordered]@{
        'Version' = [string]$CommandResultColl
      }
      $Result = New-Object psobject -Property $Properties
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