---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version: https://github.com/IGEL-Community/PSIGEL/blob/master/Docs/Get-EPUpdateConfiguration.md
schema: 2.0.0
---

# Get-EPUpdateConfiguration

## SYNOPSIS
Get update configuration details from IGEL EndPoint.

## SYNTAX

```
Get-EPUpdateConfiguration [-SSHSession] <Object> [<CommonParameters>]
```

## DESCRIPTION
Get update configuration details from IGEL EndPoint with firmware 10+ via SSH Connection.
Requires Module Posh-SSH.

## EXAMPLES

### Example 1
```
$Params = @{
  SSHSession = New-SSHSession -ComputerName $ComputerName -Credential (Get-Credential) -AcceptKey
}
Get-EPUpdateConfiguration @Params

Host     : TC012345
Protocol : http
Hostname : UMSSERVER.acme.org
Port     : 9080
Username : igelums
Password : 00a3439e23423e182e5c2g
Path     : ums_filetransfer/IGEL_Universal_Desktop_LX-10.03.570
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
