---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version: https://github.com/IGEL-Community/PSIGEL/blob/master/Docs/Get-UMSThinclientDirectoryAssignment.md
schema: 2.0.0
---

# Get-UMSThinclientDirectoryAssignment

## SYNOPSIS
Get the profile and master profile assignments.

## SYNTAX

```
Get-UMSThinclientDirectoryAssignment [-Computername] <String> [[-TCPPort] <Int32>] [[-ApiVersion] <Int32>]
 [[-WebSession] <Object>] [-DIRID] <Int32> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Get the profile and master profile assignments for the specified Thinclient directory,
in order of their application from UMS via API.

## EXAMPLES

### BEISPIEL 1
```
$Computername = 'UMSSERVER'
$Params = @{
  Computername = $Computername
  WebSession   = New-UMSAPICookie -Computername $Computername
  DIRID        = 772
}
Get-UMSThinclientDirectoryAssignment @Params
```
```
assignee                 receiver                    assignmentPosition links
--------                 --------                    ------------------ -----
@{id=423; type=profile}  @{id=772; type=tcdirectory}                  0 {}
@{id=431; type=profile}  @{id=772; type=tcdirectory}                  1 {}
@{id=436; type=profile}  @{id=772; type=tcdirectory}                  2 {}
@{id=438; type=profile}  @{id=772; type=tcdirectory}                  3 {}
@{id=441; type=profile}  @{id=772; type=tcdirectory}                  4 {}
@{id=444; type=profile}  @{id=772; type=tcdirectory}                  5 {}
```
Gets the profile and master profile assignments for Thinclient Directory 772

### BEISPIEL 2
```
774 | Get-UMSThinclientDirectoryAssignment -Computername 'UMSSERVER'
```

Gets the profile and master profile assignments for the Thinclient Directory with ID 774

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

### -DIRID
ID of the Thinclient Directory to get assignments for

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
