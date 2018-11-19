---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version:
schema: 2.0.0
---

# Get-UMSThinclient

## SYNOPSIS
Gets Thinclient from API.

## SYNTAX

```
Get-UMSThinclient [[-Computername] <String>] [[-TCPPort] <Int32>] [[-ApiVersion] <Int32>]
 [[-WebSession] <Object>] [[-Details] <String>] [[-TCID] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Gets Thinclient from API.

## EXAMPLES

### BEISPIEL 1
```
$Computername = 'UMSSERVER'
```

$Params = @{
  Computername = $Computername
  WebSession   = New-UMSAPICookie -Computername $Computername
  Details      = 'full'
}
Get-UMSThinclient @Params
Gets detailed information on all online thin clients.

### BEISPIEL 2
```
Get-UMSThinclient -Computername 'UMSSERVER' -TCID 2433
```

Gets short information on thin clients with TCID 2433.

### BEISPIEL 3
```
$WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
```

2433, 2344 | Get-UMSThinclient -Computername 'UMSSERVER' -Details 'shadow'
Gets shadow-information on Thinclient with TCID 2433, 2433

## PARAMETERS

### -Computername
Computername of the UMS Server

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
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

### -Details
Detailed of information on all thin clients ('short','full','inventory','online'; Default:'short').

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: Short
Accept pipeline input: False
Accept wildcard characters: False
```

### -TCID
ThinclientID to search for

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
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
