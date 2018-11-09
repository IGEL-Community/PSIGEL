#r equires -Modules 'Posh-SSH'
function Invoke-EPSSHCommandStream
{
  <#
    .SYNOPSIS
    Invoke-SSHCommandStream Wrapper for IGEL EndPoints

    .DESCRIPTION
    Invoke-SSHCommandStream Wrapper for IGEL EndPoints

    .EXAMPLE
    $Params = @{
      SessionId = ((Get-SSHSession -ComputerName $ComputerName).SessionId)[0]
      Command   = {cat /etc/firmware}
    }
    Invoke-EPSSHCommandStream @Params

    .EXAMPLE
    $Params = @{
      SSHSession = New-SSHSession -ComputerName $ComputerName -Credential (Get-Credential) -AcceptKey
      Command   = {cat /etc/firmware}
    }
    Invoke-EPSSHCommandStream @Params
  #>

  [CmdletBinding()]
  param (
    [Parameter(ParameterSetName = 'ID')]
    [Int]
    $SessionId,

    [Parameter(ParameterSetName = 'Session')]
    $SSHSession,

    [Parameter(Mandatory)]
    $Command
  )

  begin
  {
  }
  process
  {
    $Params = @{
      Command     = $Command
      ErrorAction = 'Stop'
    }
    try
    {
      switch ($PSCmdlet.ParameterSetName)
      {
        'ID'
        {
          $Params.SessionId = $SessionId
          Invoke-SSHCommandStream @Params
        }
        'Session'
        {
          $Params.SSHSession = $SSHSession
          Invoke-SSHCommandStream @Params
        }
      }
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