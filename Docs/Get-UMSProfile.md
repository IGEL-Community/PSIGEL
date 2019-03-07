---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version: https://github.com/IGEL-Community/PSIGEL/blob/master/Docs/Get-UMSProfile.md
schema: 2.0.0
---

# Get-UMSProfile

## SYNOPSIS
Get profiles.

## SYNTAX

### All (Default)
```
Get-UMSProfile [-Computername] <String> [[-TCPPort] <Int32>] [[-ApiVersion] <Int32>]
 [-SecurityProtocol <String[]>] [-WebSession] <Object> [<CommonParameters>]
```

### Id
```
Get-UMSProfile [-Computername] <String> [[-TCPPort] <Int32>] [[-ApiVersion] <Int32>]
 [-SecurityProtocol <String[]>] [-WebSession] <Object> [-Id <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Gets profiles from UMS via API.

## EXAMPLES

### Example 1
```
$Computername = 'UMSSERVER'
$Params = @{
  Computername = $Computername
  WebSession   = New-UMSAPICookie -Computername $Computername
}
Get-UMSProfile @Params

firmwareID        : 8
isMasterProfile   : False
overridesSessions : False
id                : 84629
name              : Test2
parentID          : 28793
movedToBin        : False
objectType        : profile
links             : {}

firmwareID        : 30
isMasterProfile   : False
overridesSessions : False
id                : 86995
name              : 07|Update_PartialUpdate_LanguagePackGerman|UDW
parentID          : 11726
movedToBin        : False
objectType        : profile
links             : {}
```

Gets information on all profiles on the UMS instance.

### Example 2
```
499, 501 | Get-UMSProfile -Computername 'UMSSERVER'
```

Gets information on the profile with ProfileID 499 and 501.

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
Default value: False
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
