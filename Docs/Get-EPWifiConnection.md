# Get-EPWifiConnection

Get Wifi connection details from IGEL EndPoint via SSH.

## PARAMETER

### -SSHSession <Object>

SSH Session to use

```code
Required: True
Position: 0
Default value: False
Accept pipeline input: True
Accept wildcard characters: False
```

### -Interface <String>

Interface to query

```code
Required: False
Position: Named
Default value: 'wlan0'
Accept pipeline input: False
Accept wildcard characters: False
```

## Syntax

```powershell
Get-EPWifiConnection [-SSHSession] <Object> [-Interface <String>] [<CommonParameters>]
```

## EXAMPLE

```powershell
$Properties = @{
  SSHSession = New-SSHSession -ComputerName 'TC01234' -Credential (Get-Credential) -AcceptKey
  Interface  = 'wlan0'
}
Get-EPWifiConnection @Params
```

```console
Host        : TC01234
Interface   : wlan0
ESSID       : WLAN1234
Mode        : Managed
Frequency   : 5.3
AccessPoint : 00:24:5C:29:E8:F8
BitRate     : 48
TxPower     : 20
LinkQuality : 62/70
SignalLevel : -48
```

## Output

System.Management.Automation.PSObject