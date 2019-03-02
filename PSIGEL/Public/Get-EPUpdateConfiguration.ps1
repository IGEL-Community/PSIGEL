#Requires -Modules Posh-SSH
function Get-EPUpdateConfiguration
{
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    $SSHSession
  )

  begin
  {
    $Command = 'cat /wfs/updateconf.ini'
    $PatternColl = [ordered]@{
      Protocol = 'protocol=\"(?<Protocol>.*)\"'
      Hostname = 'hostname=\"(?<Hostname>.*)\"'
      Port     = 'port=\"(?<Port>.*)\"'
      Username = 'username=\"(?<Username>.*)\"'
      Password = 'password=\"(?<Password>.*)\"'
      Path     = 'path=\"(?<Path>.*)\"'
    }
  }
  process
  {
    try
    {
      $CommandResultColl = Invoke-SSHCommandStream -SSHSession $SSHSession -Command $Command
      $Properties = [ordered]@{
        Host = $SSHSession.Host
      }
      foreach ($Pattern in $PatternColl.GetEnumerator())
      {
        foreach ($CommandResult in $CommandResultColl)
        {
          if ($CommandResult -match $Pattern.Value)
          {
            $Properties.($Pattern.Key) = $matches.($Pattern.Key)
          }
        }
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