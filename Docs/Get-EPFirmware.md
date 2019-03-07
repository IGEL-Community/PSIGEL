---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version: https://github.com/IGEL-Community/PSIGEL/blob/master/Docs/Get-EPFirmware.md
schema: 2.0.0
---

# Get-EPFirmware

## SYNOPSIS
Get Firmware from IGEL EndPoint.

## SYNTAX

```
Get-EPFirmware [-SSHSession] <Object> [<CommonParameters>]
```

## DESCRIPTION
Get Firmware from IGEL EndPoint via SSH Connection.
Requires Module Posh-SSH.

## EXAMPLES

### Example 1
```
$Params = @{
  SSHSession = New-SSHSession -ComputerName $ComputerName -Credential (Get-Credential) -AcceptKey
}
Get-EPFirmware @Params

4.14.300.01
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
