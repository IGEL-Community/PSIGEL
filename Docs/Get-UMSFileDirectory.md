---
external help file: PSIGEL-help.xml
Module Name: PSIGEL
online version: https://github.com/IGEL-Community/PSIGEL/blob/master/Docs/Get-UMSFile.md
schema: 2.0.0
---

# Get-UMSFileDirectory

## SYNOPSIS
Get File Directories.

## SYNTAX

```
Get-UMSFileDirectory [-ServerInstance] <String> [-Database] <String> [-Schema] <String>
 [[-Credential] <PSCredential>] [[-DirID] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Get File Directories from UMS DB via Invoke-SQLcmd2.

## EXAMPLES

### Example 1
```powershell
$Params = @{
  Credential     = Get-Credential
  ServerInstance = 'SQLSERVER\RMDB'
  Database       = 'RMDB'
  Schema         = 'igelums'
}
Get-UMSFileDirectory @Params
```

```
DIRID NAME MEMBEROF MOVEDTOBIN
----- ---- -------- ----------
50192 Dir1
```

Gets all File Directories

### Example 2
```powershell
50194 | Get-UMSFileDirectory -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums'
```

Gets File Directories with DirID "50194"

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
ID of Directoriy to get

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
