---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version: https://github.com/IGEL-Community/PSIGEL/blob/master/Docs/Get-UMSProfileDirectory.md
schema: 2.0.0
---

# Get-UMSProfileDirectory

## SYNOPSIS
Get Profile Directories.

## SYNTAX

### All (Default)
```
Get-UMSProfileDirectory -Computername <String> [-TCPPort <Int32>] [-ApiVersion <Int32>]
 [-SecurityProtocol <String[]>] -WebSession <Object> [-Filter <String>] [<CommonParameters>]
```

### Id
```
Get-UMSProfileDirectory -Computername <String> [-TCPPort <Int32>] [-ApiVersion <Int32>]
 [-SecurityProtocol <String[]>] -WebSession <Object> [-Filter <String>] [-Id <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Get Profile Directories from UMS via API.

## EXAMPLES

### Example 1
```
$Computername = 'UMSSERVER'
$Params = @{
  Computername = $Computername
  WebSession   = New-UMSAPICookie -Computername $Computername
}
Get-UMSProfileDirectory @Params

id         : 477
name       : 04_Network
parentID   : 421
movedToBin : False
objectType : profiledirectory
links      : {}

id         : 446
name       : 01_Sessions
parentID   : 421
movedToBin : False
objectType : profiledirectory
links      : {}
```

Gets information on all Profile Directories

### Example 2
```
(446 | Get-UMSProfileDirectory -Computername 'UMSSERVER' -Children).DirectoryChildren

objectType id
---------- --
profile    449
profile    10780
profile    450
```

Gets children of the Profile Directory with ID 446

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
TCP Port API (Default: 8443)

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
