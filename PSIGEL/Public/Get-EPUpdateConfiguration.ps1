#Requires -Modules Posh-SSH
function Get-EPUpdateConfiguration
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
    $Command = 'cat /wfs/updateconf.ini'
    $PatternColl = [ordered]@{
      Protocol = 'protocol=\"(?<Protocol>.*)\"'
      Hostname = 'hostname=\"(?<Hostname>.*)\"'
      Port     = 'port=\"(?<Port>.*)\"'
      Username = 'username=\"(?<Username>.*)\"'
      Password = 'password=\"(?<Password>.*)\"'
      Path     = 'path=\"(?<Path>.*)\"'
    }
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
      New-Object psobject -Property $Properties
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