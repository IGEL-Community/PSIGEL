---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version: https://github.com/IGEL-Community/PSIGEL/Docs/Reference/Move-UMSProfileDirectory.md
schema: 2.0.0
---

# Move-UMSProfileDirectory

## SYNOPSIS
Moves a profile directory to profile directory.

## SYNTAX

```
Move-UMSProfileDirectory [-Computername] <String> [[-TCPPort] <Int32>] [[-ApiVersion] <Int32>]
 [[-SecurityProtocol] <String[]>] [-WebSession] <Object> [-Id] <Int32> [-DestId] <Int32> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Moves a profile directory to profile directory via API.

## EXAMPLES

### Example 1

Move the profile directory with the ID 417 to the profile directory with the ID 230:

```powershell
Move-UMSProfileDirectory -ComputerName 'igelrmserver' -WebSession $WebSession -Id 417 -DestId 230

 Id Message
 -- -------
417 successful.
```

### Example 2

Move to profile directory with the name '01' to the profile directory with the name '02':

```powershell
$PSDefaultParameterValues = @{
  '*-UMS*:Credential'   = (Get-Credential)
  '*-UMS*:Computername' = 'igelrmserver'
}
$PSDefaultParameterValues += @{
  '*-UMS*:WebSession' = New-UMSAPICookie
}

(Get-UMSProfileDirectory).where{$_.Name -eq '01'} |
  Move-UMSProfileDirectory -DestId ((Get-UMSProfileDirectory).where{$_.name -eq '02'})[0].Id

 Id Message
 -- -------
417 successful.
```

## PARAMETERS

### -ApiVersion
API Version to use

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:
Accepted values: 3

Required: False
Position: 2
Default value: 3
Accept pipeline input: False
Accept wildcard characters: False
```

### -Computername
Computername of the UMS Server

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DestId
ID of the destination profile directory

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
ID of the profile directory

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -SecurityProtocol
Set SSL/TLS protocol

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: Tls12, Tls11, Tls, Ssl3

Required: False
Position: 3
Default value: Tls12
Accept pipeline input: False
Accept wildcard characters: False
```

### -TCPPort
TCP Port API

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 8443
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebSession
Websession Cookie

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Int32

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
