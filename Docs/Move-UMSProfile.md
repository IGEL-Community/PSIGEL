---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version:
schema: 2.0.0
---

# Move-UMSProfile

## SYNOPSIS
Moves Profiles into the specified Profile Directory via API

## SYNTAX

```
Move-UMSProfile [-Computername] <String> [[-TCPPort] <Int32>] [[-ApiVersion] <Int32>] [[-WebSession] <Object>]
 [-ProfileID] <Int32> [-DDIRID] <Int32> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Moves Profiles into the specified Profile Directory via API

## EXAMPLES

### BEISPIEL 1
```
$Computername = 'UMSSERVER'
```

$Params = @{
  Computername = $Computername
  WebSession   = New-UMSAPICookie -Computername $Computername
  DDIRID       = 49339
  ProfileID    = 48440
  Confirm      = $true
}
Move-UMSProfile @Params
Moves Profile with ID 48440 into the Profile Directory with ID 48440 and prompts for confirmation

### BEISPIEL 2
```
48440, 48442 | Move-UMSProfile -Computername 'UMSSERVER' -DDIRID 28793
```

Moves Profiles into the specified Profile Directory

## PARAMETERS

### -Computername
Computername of the UMS Server

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TCPPort
TCP Port API (Default: 8443)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
Position: 3
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
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProfileID
ProfileIDs to move

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: 0
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -DDIRID
DDIRID to move to

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
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