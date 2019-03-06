---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version: https://github.com/IGEL-Community/PSIGEL/blob/master/Docs/Get-UMSThinclientAssignment.md
schema: 2.0.0
---

# Get-UMSThinclientAssignment

## SYNOPSIS
Gets the profile and master profile assignments.

## SYNTAX

```
Get-UMSThinclientAssignment [-Computername] <String> [[-TCPPort] <Int32>] [[-ApiVersion] <Int32>]
 [[-WebSession] <Object>] [-TCID] <Int32> [<CommonParameters>]
```

## DESCRIPTION
Gets the profile and master profile assignments for the specified thin client, in order of their application from UMS via API.

## EXAMPLES

### Example 1
```powershell
$Computername = 'UMSSERVER'
$Params = @{
  Computername = $Computername
  WebSession   = New-UMSAPICookie -Computername $Computername
  TCID         = 2433
}
Get-UMSThinclientAssignment @Params
```
```
assignee                  receiver                      assignmentPosition links
--------                  --------                      ------------------ -----
@{id=472; type=profile}   @{id=2433; type=tc}                            0 {@{rel=assigned; href=https://umsserver:8443/umsapi/v3/profiles/472}, @{rel=receiver; href=https://umsserver:8...
@{id=76686; type=profile} @{id=76023; type=tcdirectory}                  1 {@{rel=assigned; href=https://umsserver:8443/umsapi/v3/profiles/76686}, @{rel=receiver; href=https://umsserver...
@{id=480; type=profile}   @{id=50; type=tcdirectory}                     2 {@{rel=assigned; href=https://umsserver:8443/umsapi/v3/profiles/480}, @{rel=receiver; href=https://umsserver:8...
@{id=478; type=profile}   @{id=50; type=tcdirectory}                     3 {@{rel=assigned; href=https://umsserver:8443/umsapi/v3/profiles/478}, @{rel=receiver; href=https://umsserver:8...
@{id=451; type=profile}   @{id=49; type=tcdirectory}                     4 {@{rel=assigned; href=https://umsserver:8443/umsapi/v3/profiles/451}, @{rel=receiver; href=https://umsserver:8...
```
Gets the profile and master profile assignments for Thinclient with TCID 2433.

### Example 2
```powershell
2433 | Get-UMSThinclientAssignment -Computername 'UMSSERVER'
```

Gets the profile and master profile assignments for Thinclient with TCID 2433.

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

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TCID
ID of the Thinclient assignments for

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
