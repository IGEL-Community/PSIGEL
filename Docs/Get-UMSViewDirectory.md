---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version:
schema: 2.0.0
---

# Get-UMSViewDirectory

## SYNOPSIS
Gets View Directories from UMS-DB

## SYNTAX

```
Get-UMSViewDirectory [-ServerInstance] <String> [-Database] <String> [-Schema] <String>
 [[-Credential] <PSCredential>] [[-DirID] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Gets View Directories from UMS-DB

## EXAMPLES

### BEISPIEL 1
```
$Params = @{
```

Credential     = Get-Credential
  ServerInstance = 'SQLSERVER\RMDB'
  Database       = 'RMDB'
  Schema         = 'igelums'
}
Get-UMSViewDirectory @Params
Gets all View Directories

### BEISPIEL 2
```
557 | Get-UMSViewDirectory -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums'
```

Gets View Directories with DirID "557"

## PARAMETERS

### -ServerInstance
SQL ServerInstance for the UMS-DB (e.g.
'SQLSERVER\RMDB')

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

### -Database
SQL Database for the UMS-DB (e.g.
'RMDB')

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Schema
SQL Schema for the UMS-DB (e.g.
'igelums')

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
Specifies A PSCredential for SQL Server Authentication connection to an instance of the Database Engine.
If -Credential is not specified, Invoke-Sqlcmd attempts a Windows Authentication connection using the
Windows account running the PowerShell session.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DirID
{{Fill DirID Description}}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
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
