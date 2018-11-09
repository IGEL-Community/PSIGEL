#requires -Modules 'Posh-SSH'
function New-EPSSHSession
{
  <#
    .SYNOPSIS
    New-SSHSession Wrapper for IGEL EndPoints

    .DESCRIPTION
    New-SSHSession Wrapper for IGEL EndPoints

    .EXAMPLE
    $Params = @{
      Computername = 'TC035681'
      Credential   = (Get-Credential)
    }
    New-EPSSHSession @Params
  #>

  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [String]
    $Computername,

    [ValidateNotNull()]
    [System.Management.Automation.PSCredential]
    [System.Management.Automation.Credential()]
    $Credential = (Get-Credential -Message 'Enter your credentials'),

    [switch]
    $AcceptKey
  )

  begin
  {
  }
  process
  {
    $Params = @{
      ComputerName = $Computername
      Credential   = $Credential
      AcceptKey    = $AcceptKey
      ErrorAction  = 'Stop'
    }
    try
    {
      New-SSHSession @Params
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