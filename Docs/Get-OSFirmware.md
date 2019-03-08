---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version:
schema: 2.0.0
---

# Get-OSFirmware

## SYNOPSIS
Gets firmware from a device.

## SYNTAX

```
Get-OSFirmware [-SSHSession] <Object> [<CommonParameters>]
```

## DESCRIPTION
Gets firmware from a device via Posh-SSH.

## EXAMPLES

### Example 1

Get firmware from device with name V10-01:

```powershell
PS C:\> $Params = @{
  ComputerName = 'V10-01'
  Credential   = Get-Credential
  AcceptKey    = $true
}
$SSHSession = New-SSHSession @Params

Get-OSFirmware -SSHSession $SSHSession
```

Output:

```console
Version
-------
10.05.500.01
```

## PARAMETERS

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

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
