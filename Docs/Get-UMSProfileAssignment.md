---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version: https://github.com/IGEL-Community/PSIGEL/blob/master/Docs/Get-UMSProfileAssignment.md
schema: 2.0.0
---

# Get-UMSProfileAssignment

## SYNOPSIS
Get the thinclients and directories the profile is assigned to.

## SYNTAX

```
Get-UMSProfileAssignment [-Computername] <String> [[-TCPPort] <Int32>] [[-ApiVersion] <Int32>]
 [-WebSession] <Object> [-ProfileID] <Int32> [<CommonParameters>]
```

## DESCRIPTION
Get the thinclients and directories the profile is assigned to from UMS via API.

## EXAMPLES

### BEISPIEL 1
```
$Computername = 'UMSSERVER'
$Params = @{
  Computername = $Computername
  WebSession   = New-UMSAPICookie -Computername $Computername
  ProfileID    = 471
}
Get-UMSProfileAssignment @Params
```

```
id    type
--    ----
4108  tc
4110  tc
4112  tc
4114  tc
```

Gets the thin clients and the directories the profile with ProfileID 471 is assigned to.

### BEISPIEL 2
```
471 | Get-UMSProfileAssignment -Computername 'UMSSERVER'
```

Gets the thin clients and the directories the profile with ProfileID 471 is assigned to.

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
TCP Port (Default: 8443)

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

Required: True
Position: 4
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
Position: 5
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
