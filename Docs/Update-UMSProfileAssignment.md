---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version: https://github.com/IGEL-Community/PSIGEL/blob/master/Docs/Update-UMSProfileAssignment.md
schema: 2.0.0
---

# Update-UMSProfileAssignment

## SYNOPSIS
Assigns a profile to a Thinclient or a tThinclient directory.

## SYNTAX

### TC
```
Update-UMSProfileAssignment -Computername <String> [-TCPPort <Int32>] [-ApiVersion <Int32>]
 [-WebSession <Object>] -ProfileID <Int32> -TCID <Int32> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Dir
```
Update-UMSProfileAssignment -Computername <String> [-TCPPort <Int32>] [-ApiVersion <Int32>]
 [-WebSession <Object>] -ProfileID <Int32> -DirID <Int32> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Assigns a profile to a Thinclient or a tThinclient directory.

## EXAMPLES

### Example 1
```powershell
$Params = @{
$WebSession   = New-UMSAPICookie -Computername 'UMSSERVER'
  $Computername = 'UMSSERVER'
  $WebSession   = $WebSession
  $ProfileID    = 470
  $TCID         = 48426
}
Update-UMSProfileAssignment @Params
```
Assigns the profile with ProfilID 470 to thin client with TCID 48426.

### Example 2
```powershell
Update-UMSProfileAssignment -Computername 'UMSSERVER' -ProfileID 471 -DirID 300
```

Assigns the profile with ProfilID 471 to thin client directory with DirID 300'

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
Accept pipeline input: False
Accept wildcard characters: False
```

### -TCID
Thinclient ID to apply profile to

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
Directory ID to apply profile to

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
