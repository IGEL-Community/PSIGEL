function Get-EPUpdateConfiguration
{
  <#
    .SYNOPSIS
    Get update configuration details from IGEL EndPoint with firmware 10+ via SSH.

    .DESCRIPTION
    Get update configuration details from IGEL EndPoint with firmware 10+ via SSH.

    .PARAMETER SSHSession
    SSH Session to use

    .EXAMPLE
    $Properties = @{
      SSHSession = New-SSHSession -ComputerName $ComputerName -Credential (Get-Credential) -AcceptKey
    }
    Get-EPUpdateConfiguration @Params
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
    }
    catch
    {
      Write-Output -InputObject $PSItem.Exception.Message
    }

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
  end
  {
  }
}