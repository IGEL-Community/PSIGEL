#Requires -Modules Posh-SSH
function Get-DeviceWifiConnection
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
    $PatternESSID = 'ESSID(:|=)\"(?<ESSID>.*)\"'
    $PatternMode = 'Mode(:|=)(?<Mode>[^\s]*)'
    $PatternFrequency = 'Frequency(:|=)(?<Frequency>[^\s]*)\s(?<Unit>[^\s]*)'
    $PatternAccessPoint = 'Access Point:\s(?<AccessPoint>[^\s]*)'
    $PatternBitRate = 'Bit Rate(:|=)(?<BitRate>[^\s]*)\s(?<Unit>[^\s]*)'
    $PatternTxPower = 'Tx-Power(:|=)(?<TxPower>[^\s]*)\s(?<Unit>[^\s]*)'
    #$PatternLinkQuality = 'Link Quality(:|=)(?<LinkQuality>[^\s]*)'
    $PatternLinkQualityActual = 'Link Quality(:|=)(?<LinkQualityActual>\d+)'
    $PatternLinkQualityMax = 'Link Quality(:|=)\d*\/(?<LinkQualityMax>\d+)'
    $PatternSignalLevel = 'Signal level(:|=)(?<SignalLevel>[^\s]*)\s(?<Unit>[^\s]*)'
  }
  process
  {
    try
    {
      $CommandResultColl = Invoke-SSHCommandStream -SSHSession $SSHSession -Command $Command
      $Properties = [ordered]@{
        Host      = [String]$SSHSession.Host
        Interface = [String]$Interface
      }
      foreach ($CommandResult in $CommandResultColl)
      {
        if ($CommandResult -match $PatternESSID)
        {
          $Properties.ESSID = [String]$matches.ESSID
        }
        if ($CommandResult -match $PatternMode)
        {
          $Properties.Mode = [String]$matches.Mode
        }
        if ($CommandResult -match $PatternFrequency)
        {
          $Properties.Frequency = [Single]$matches.Frequency
        }
        if ($CommandResult -match $PatternAccessPoint)
        {
          $Properties.AccessPoint = [String]$matches.AccessPoint
        }
        if ($CommandResult -match $PatternBitRate)
        {
          $Properties.BitRate = [Int]$matches.BitRate
        }
        if ($CommandResult -match $PatternTxPower)
        {
          $Properties.TxPower = [Int]$matches.TxPower
        }
        if ($CommandResult -match $PatternLinkQualityActual)
        {
          $Properties.LinkQualityActual = [Int]$matches.LinkQualityActual
        }
        if ($CommandResult -match $PatternLinkQualityMax)
        {
          $Properties.LinkQualityMax = [Int]$matches.LinkQualityMax
        }
        if ($CommandResult -match $PatternSignalLevel)
        {
          $Properties.SignalLevel = [Int]$matches.SignalLevel
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