---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version:
schema: 2.0.0
---

# Get-OSUpdateConfiguration

## SYNOPSIS
Gets firmware from a device.

## SYNTAX

```
Get-OSUpdateConfiguration [-SSHSession] <Object> [<CommonParameters>]
```

## DESCRIPTION
Gets update configuration from a device via Posh-SSH.

## EXAMPLES

### Example 1
```powershell
PS C:\> $Params = @{
  ComputerName = 'Device01'
  Credential   = Get-Credential
  AcceptKey    = $true
}
$SSHSession = New-SSHSession @Params

Get-OSUpdateConfiguration -SSHSession $SSHSession
```

Output:

```console
Host     : Device01
Protocol : http
Hostname : igelrmserver
Port     : 9080
Username : igelums
Password : 0009330f34121a177eb62d
Path     : ums_filetransfer/IGEL_Universal_Desktop_LX-10.05.500
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
