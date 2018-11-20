---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version: https://github.com/IGEL-Community/PSIGEL/blob/master/Docs/Remove-UMSProfileAssignment.md
schema: 2.0.0
---

# Remove-UMSProfileAssignment

## SYNOPSIS
Deletes assignment of the specified profile to the specified Thinclient or Thinclient directory.

## SYNTAX

### TC
```
Remove-UMSProfileAssignment -Computername <String> [-TCPPort <Int32>] [-ApiVersion <Int32>]
 [-WebSession <Object>] -ProfileID <Int32> -TCID <Int32> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Dir
```
Remove-UMSProfileAssignment -Computername <String> [-TCPPort <Int32>] [-ApiVersion <Int32>]
 [-WebSession <Object>] -ProfileID <Int32> -DirID <Int32> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Deletes assignment of the specified profile to the specified Thinclient or Thinclient directory.

## EXAMPLES

### BEISPIEL 1
```
$Computername = 'UMSSERVER'
$Params = @{
  Computername = $Computername
  WebSession   = New-UMSAPICookie -Computername $Computername
  ProfileID    = 470
  TCID         = 48426
}
Remove-UMSProfileAssignment @Params
```
Deletes assignment of profile with ProfileID 470 to the Thinclient with the TCID 48426.

### BEISPIEL 2
```
48170 | Remove-UMSProfileAssignment -Computername 'UMSSERVER' -DirID 185
```

Deletes assignment of profile with ProfileID 48170 to the Thinclient directory with the DirID 185.

## PARAMETERS

### -Computername
Computername of the UMS Server

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TCPPort
TCP Port (Default: 8443)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 8443
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiVersion
API Version to use (Default: 3)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 3
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebSession
Websession Cookie

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProfileID
ProfileID to search for

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -TCID
{{Fill TCID Description}}

```yaml
Type: Int32
Parameter Sets: TC
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DirID
{{Fill DirID Description}}

```yaml
Type: Int32
Parameter Sets: Dir
Aliases:

Required: True
Position: Named
Default value: 0
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
Position: Named
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
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
