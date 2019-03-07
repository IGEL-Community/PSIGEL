---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version: https://github.com/IGEL-Community/PSIGEL/blob/master/Docs/Get-UMSThinclientDirectory.md
schema: 2.0.0
---

# Get-UMSThinclientDirectory

## SYNOPSIS
Get Thinclient Directories.

## SYNTAX

### All (Default)
```
Get-UMSThinclientDirectory -Computername <String> [-TCPPort <Int32>] [-ApiVersion <Int32>]
 [-SecurityProtocol <String[]>] -WebSession <Object> [-Filter <String>] [<CommonParameters>]
```

### Id
```
Get-UMSThinclientDirectory -Computername <String> [-TCPPort <Int32>] [-ApiVersion <Int32>]
 [-SecurityProtocol <String[]>] -WebSession <Object> [-Filter <String>] [-Id <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Get Thinclient Directories from UMS via API.

## EXAMPLES

### Example 1
```
$Computername = 'UMSSERVER'
$Params = @{
  Computername = $Computername
  WebSession   = New-UMSAPICookie -Computername $Computername
}
Get-UMSThinclientDirectory @Params

id         : 274
name       : Room1
parentID   : 220
movedToBin : False
objectType : tcdirectory
links      : {}

id         : 275
name       : Room2
parentID   : 220
movedToBin : False
objectType : tcdirectory
links      : {}
```

Gets all Thinclient Directories.

### Example 2
```
(Get-UMSThinclientDirectory -Computername 'UMSSERVER' -DirID 220 -Children).DirectoryChildren | Select-Object -First 10

objectType  id
----------  --
tcdirectory 221
tcdirectory 222
tcdirectory 223
tcdirectory 224
tcdirectory 225
tcdirectory 226
tcdirectory 227
tcdirectory 228
tcdirectory 229
tcdirectory 230
```

Gets all children of the Thinclient Directory with ID 220, selects first 10.

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

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
{{Fill Filter Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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
