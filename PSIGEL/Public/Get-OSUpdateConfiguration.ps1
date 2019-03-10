#Requires -Modules Posh-SSH
function Get-OSUpdateConfiguration
{
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    $SSHSession
  )

  begin
  {
    $Command = 'cat /wfs/updateconf.ini'
    $PatternProtocol = 'protocol=\"(?<Protocol>.*)\"'
    $PatternHostname = 'hostname=\"(?<Hostname>.*)\"'
    $PatternPort = 'port=\"(?<Port>.*)\"'
    $PatternUsername = 'username=\"(?<Username>.*)\"'
    $PatternPassword = 'password=\"(?<Password>.*)\"'
    $PatternPath = 'path=\"(?<Path>.*)\"'
  }
  process
  {
    try
    {
      $CommandResultColl = Invoke-SSHCommandStream -SSHSession $SSHSession -Command $Command
      $Properties = [ordered]@{
        Host = [String]$SSHSession.Host
      }
      foreach ($CommandResult in $CommandResultColl)
      {
        if ($CommandResult -match $PatternProtocol)
        {
          $Properties.Protocol = [String]$matches.Protocol
        }
        if ($CommandResult -match $PatternHostname)
        {
          $Properties.Hostname = [String]$matches.Hostname
        }
        if ($CommandResult -match $PatternPort)
        {
          $Properties.Port = [Int]$matches.Port
        }
        if ($CommandResult -match $PatternUsername)
        {
          $Properties.Username = [String]$matches.Username
        }
        if ($CommandResult -match $PatternPassword)
        {
          $Properties.Password = [String]$matches.Password
        }
        if ($CommandResult -match $PatternPath)
        {
          $Properties.Path = [String]$matches.Path
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