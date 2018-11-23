#Requires -Modules Posh-SSH
function Get-EPWifiConnection
{
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true,
      ValueFromPipeline = $true,
      Position = 0)]
    $SSHSession,

    [string]
    $Interface = 'wlan0'
  )

  begin
  {
  }
  process
  {
    $Command = "iwconfig $Interface"
    $PatternColl = [ordered]@{
      ESSID       = 'ESSID(:|=)\"(?<ESSID>.*)\"'
      Mode        = 'Mode(:|=)(?<Mode>[^\s]*)'
      Frequency   = 'Frequency(:|=)(?<Frequency>[^\s]*)\s(?<Unit>[^\s]*)'
      AccessPoint = 'Access Point:\s(?<AccessPoint>[^\s]*)'
      BitRate     = 'Bit Rate(:|=)(?<BitRate>[^\s]*)\s(?<Unit>[^\s]*)'
      TxPower     = 'Tx-Power(:|=)(?<TxPower>[^\s]*)\s(?<Unit>[^\s]*)'
      LinkQuality = 'Link Quality(:|=)(?<LinkQuality>[^\s]*)'
      SignalLevel = 'Signal level(:|=)(?<SignalLevel>[^\s]*)\s(?<Unit>[^\s]*)'
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
      Host      = $SSHSession.Host
      Interface = $Interface
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