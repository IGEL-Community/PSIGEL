#requires -Modules 'Posh-SSH'
function Remove-EPSSHSession
{
  <#
    .SYNOPSIS
    Remove-SSHSession Wrapper for IGEL EndPoints

    .DESCRIPTION
    Remove-SSHSession Wrapper for IGEL EndPoints

    .EXAMPLE
    $Params = @{
      SessionId = ((Get-SSHSession -ComputerName $ComputerName).SessionId)[0]
    }
    Remove-EPSSHSEssion @Params

    .EXAMPLE
    $Params = @{
      SSHSession = New-SSHSession -ComputerName $ComputerName -Credential (Get-Credential) -AcceptKey
    }
    Remove-EPSSHSEssion @Params
  #>

  [CmdletBinding()]
  param (
    [Parameter(ParameterSetName = 'ID')]
    [Int]
    $SessionId,

    [Parameter(ParameterSetName = 'Session')]
    $SSHSession
  )

  begin
  {
  }
  process
  {
    try
    {
      switch ($PSCmdlet.ParameterSetName)
      {
        'ID'
        {
          Remove-SSHSession -SessionId $SessionId
        }
        'Session'
        {
          Remove-SSHSession -SSHSession $SSHSession
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