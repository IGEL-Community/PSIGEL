---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version:
schema: 2.0.0
---

# Get-UMSProfileDirectory

## SYNOPSIS
Gets information on Profile Directories via API

## SYNTAX

### Overview (Default)
```
Get-UMSProfileDirectory -Computername <String> [-TCPPort <Int32>] [-ApiVersion <Int32>] [-WebSession <Object>]
 [-Children] [<CommonParameters>]
```

### DIR
```
Get-UMSProfileDirectory -Computername <String> [-TCPPort <Int32>] [-ApiVersion <Int32>] [-WebSession <Object>]
 [-Children] -DIRID <Int32> [<CommonParameters>]
```

## DESCRIPTION
Gets information on Profile Directories via API

## EXAMPLES

### BEISPIEL 1
```
$Computername = 'UMSSERVER'
```

$Params = @{
  Computername = $Computername
  WebSession   = New-UMSAPICookie -Computername $Computername
}
Get-UMSProfileDirectory @Params
Gets information on all Profile Directories

### BEISPIEL 2
```
(Get-UMSProfileDirectory -Computername 'UMSSERVER' -Children).DirectoryChildren
```

Gets information on all children of the Profile Directories

### BEISPIEL 3
```
Get-UMSProfileDirectory -Computername 'UMSSERVER' -DIRID 421
```

Gets information on a specific Profile Directory

### BEISPIEL 4
```
(421 | Get-UMSProfileDirectory -Computername 'UMSSERVER' -Children).DirectoryChildren
```

Gets children of Profile Directory with DirID 421.

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

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Children
Switch for recursively listing children (Default false)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DIRID
DIRIDs to get information of

```yaml
Type: Int32
Parameter Sets: DIR
Aliases:

Required: True
Position: Named
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
