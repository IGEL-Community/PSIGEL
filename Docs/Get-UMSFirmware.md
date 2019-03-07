---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version: https://github.com/IGEL-Community/PSIGEL/blob/master/Docs/Get-UMSFirmware.md
schema: 2.0.0
---

# Get-UMSFirmware

## SYNOPSIS
Get information on all firmwares.

## SYNTAX

### All (Default)
```
Get-UMSFirmware [-Computername] <String> [[-TCPPort] <Int32>] [[-ApiVersion] <Int32>]
 [-SecurityProtocol <String[]>] [-WebSession] <Object> [<CommonParameters>]
```

### Id
```
Get-UMSFirmware [-Computername] <String> [[-TCPPort] <Int32>] [[-ApiVersion] <Int32>]
 [-SecurityProtocol <String[]>] [-WebSession] <Object> [-Id <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Gets information on all firmwares from UMS via API.

## EXAMPLES

### Example 1
```
$Computername = 'UMSSERVER'
$Params = @{
  Computername = $Computername
  WebSession   = New-UMSAPICookie -Computername $Computername
}
Get-UMSFirmware @Params

id           : 35
product      : IGEL Universal Desktop LX
version      : 5.13.100.01
firmwareType : LX
links        : {}

id           : 36
product      : IGEL Universal Desktop W10
version      : 4.02.110
firmwareType : XP
links        : {}

id           : 38
product      : IGEL Universal Desktop OS 3
version      : 10.05.100.01
firmwareType : LX
links        : {}
```

Gets information on all firmwares known to the UMS.

### Example 2
```
9, 7 | Get-UMSFirmware -Computername 'UMSSERVER'
```

Gets information on firmwares with FirmwareIDs 9 and 7.

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

### -Id
{{Fill Id Description}}

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -SecurityProtocol
{{Fill SecurityProtocol Description}}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
