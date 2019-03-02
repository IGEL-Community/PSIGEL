#Requires -Modules Posh-SSH
function Get-EPWifiConnection
{
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    $SSHSession,

    [Parameter(ValueFromPipelineByPropertyName)]
    [String]
    $Interface = 'wlan0'
  )

  begin
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
  }
  process
  {
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
    $Result = New-Object psobject -Property $Properties
    $Result
  }
  end
  {
  }
}