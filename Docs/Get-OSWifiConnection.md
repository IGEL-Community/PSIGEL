---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version:
schema: 2.0.0
---

# Get-OSWifiConnection

## SYNOPSIS
Gets wifi connection from a device.

## SYNTAX

```
Get-OSWifiConnection [-SSHSession] <Object> [[-Interface] <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets wifi connection from a device via Posh-SSH.

## EXAMPLES

### Example 1

Get WiFi connection from device with name V10-01:

```powershell
$Params = @{
  ComputerName = 'V10-01'
  Credential   = Get-Credential
  AcceptKey    = $true
}
$SSHSession = New-SSHSession @Params

Get-OSUpdateConfiguration -SSHSession $SSHSession

Host              : V10-01
Interface         : wlan0
ESSID             : WLAN-0123456
Mode              : Managed
Frequency         : 5,18
AccessPoint       : 00:42:6D:36:F8:E8
BitRate           : 18
TxPower           : 20
LinkQualityActual : 68
LinkQualityMax    : 70
SignalLevel       : -42
```

## PARAMETERS

### -Interface
Wifi interface of the device

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: wlan0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SSHSession
Posh-SSH SSHSession

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

### System.String

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
