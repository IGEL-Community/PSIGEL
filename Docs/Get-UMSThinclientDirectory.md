---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version:
schema: 2.0.0
---

# Get-UMSThinclientDirectory

## SYNOPSIS
Gets information on Thin Client Directories from API.

## SYNTAX

### Overview (Default)
```
Get-UMSThinclientDirectory -Computername <String> [-TCPPort <Int32>] [-ApiVersion <Int32>]
 [-WebSession <Object>] [-Children] [<CommonParameters>]
```

### DIR
```
Get-UMSThinclientDirectory -Computername <String> [-TCPPort <Int32>] [-ApiVersion <Int32>]
 [-WebSession <Object>] [-Children] -DirID <Int32> [<CommonParameters>]
```

## DESCRIPTION
Gets information on Thin Client Directories from API.

## EXAMPLES

### BEISPIEL 1
```
$Computername = 'UMSSERVER'
```

$Params = @{
  Computername = $Computername
  WebSession   = New-UMSAPICookie -Computername $Computername
}
Get-UMSThinclientDirectory @Params
Gets information on all Thinclient Directories

### BEISPIEL 2
```
(Get-UMSThinclientDirectory -Computername 'UMSSERVER' -Children).DirectoryChildren | Select-Object -First 10
```

Gets information on all children of the thinclient Directories, selects first 10

### BEISPIEL 3
```
Get-UMSThinclientDirectory -Computername 'UMSSERVER' -DIRID 772
```

Gets information on a specific Thinclient Directory

### BEISPIEL 4
```
(772 | Get-UMSThinclientDirectory -Computername 'UMSSERVER' -Children).DirectoryChildren
```

Gets children of Thinclient Directory with DirID 772.

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

### -DirID
DirID to search for

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
