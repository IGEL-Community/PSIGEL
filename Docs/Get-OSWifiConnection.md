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
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

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
