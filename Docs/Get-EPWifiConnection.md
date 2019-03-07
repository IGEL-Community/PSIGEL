---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version: https://github.com/IGEL-Community/PSIGEL/blob/master/Docs/Get-EPWifiConnection.md
schema: 2.0.0
---

# Get-EPWifiConnection

## SYNOPSIS
Get Wifi connection details from IGEL EndPoint.

## SYNTAX

```
Get-EPWifiConnection [-SSHSession] <Object> [-Interface <String>] [<CommonParameters>]
```

## DESCRIPTION
Get Wifi connection details from IGEL EndPoint via SSH Connection.
Requires Module Posh-SSH.

## EXAMPLES

### Example 1
```
$Params = @{
  SHSSession = New-SSHSession -ComputerName $ComputerName -Credential (Get-Credential) -AcceptKey
  Interface  = 'wlan0'
}
Get-EPWifiConnection @Params

Host        : TC012345
Interface   : wlan0
ESSID       : WLAN12345
Mode        : Managed
Frequency   : 5.54
AccessPoint : E8:C8:C7:AD:DA:B8
BitRate     : 6
TxPower     : 26
LinkQuality : 56/70
SignalLevel : -54
```

## PARAMETERS

### -SSHSession
SSH Session to use

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Interface
Interface to query

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Wlan0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
