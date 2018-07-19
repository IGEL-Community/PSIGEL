#requires -Version 3.0
function Get-UMSThinclientDirectory
{
  <#
      .Synopsis
      Gets information on Thin Client Directories from API or MSSQL.

      .DESCRIPTION
      Gets information on Thin Client Directories from API or MSSQL.

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER ServerInstance
      SQL ServerInstance  for the UMS-DB (e.g. 'SQLSERVER\RMDB')

      .PARAMETER Database
      SQL Database  for the UMS-DB (e.g. 'RMDB')

      .PARAMETER Schema
      SQL Schema  for the UMS-DB (e.g. 'igelums')

      .PARAMETER Credential
      Specifies A PSCredential for SQL Server Authentication connection to an instance of the Database Engine.
      If -Credential is not specified, Invoke-Sqlcmd attempts a Windows Authentication connection using the Windows account running the PowerShell session.

      .PARAMETER DirID
      DirID to search for

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      Get-UMSThinclientDirectory -Computername 'UMSSERVER' -WebSession $WebSession
      Gets information on all Thin Client Directories.

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      Get-UMSThinclientDirectory -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums' -Children
      Gets information on all Thin Client Directories, listing their children.

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      (50 | Get-UMSThinclientDirectory -Computername 'UMSSERVER' -WebSession $WebSession -Children).DirectoryChildren
      Gets information on Thin client directories with DirID 50, listing their children.

      .EXAMPLE
      50 | Get-UMSThinclientDirectory -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums'
      Gets information on Thin client directories with DirId 50.
  #>

  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory, ParameterSetName = 'API')]
    [String]
    $Computername,

    [Parameter(ParameterSetName = 'API')]
    [ValidateRange(0, 65535)]
    [Int]
    $TCPPort = 8443,

    [Parameter(ParameterSetName = 'API')]
    [ValidateSet(3)]
    [Int]
    $ApiVersion = 3,

    [Parameter(ParameterSetName = 'API')]
    $WebSession,

    [Parameter(ParameterSetName = 'API')]
    [switch]
    $Children,

    [Parameter(Mandatory, ParameterSetName = 'SQL')]
    [String]
    $ServerInstance,

    [Parameter(Mandatory, ParameterSetName = 'SQL')]
    [String]
    $Database,

    [Parameter(Mandatory, ParameterSetName = 'SQL')]
    [String]
    $Schema,

    [Parameter(ParameterSetName = 'SQL')]
    [ValidateNotNull()]
    [System.Management.Automation.PSCredential]
    [System.Management.Automation.Credential()]
    $Credential,

    [Parameter(ValueFromPipeline)]
    [int]
    $DirID
  )

  Begin
  {
  }
  Process
  {
    switch ($PSCmdlet.ParameterSetName)
    {
      API
      {
        Switch ($WebSession)
        {
          $null
          {
            $WebSession = New-UMSAPICookie -Computername $Computername
          }
        }
        $BaseURL = 'https://{0}:{1}/umsapi/v{2}/directories/tcdirectories' -f $Computername, $TCPPort, $ApiVersion
        Switch ($Children)
        {
          $false
          {
            $URLEnd = ''
          }
          default
          {
            $URLEnd = '?facets=children'
          }
        }
        Switch ($DirID)
        {
          0
          {
            $SessionURL = '{0}{1}' -f $BaseURL, $URLEnd
            (Invoke-UMSRestMethodWebSession -WebSession $WebSession -SessionURL $SessionURL -Method 'Get').SyncRoot
          }
          default
          {
            $SessionURL = '{0}/{1}{2}' -f $BaseURL, $DirID, $URLEnd
            Invoke-UMSRestMethodWebSession -WebSession $WebSession -SessionURL $SessionURL -Method 'Get'
          }
        }
      }
      SQL
      {
        Switch ($Credential)
        {
          $null
          {
            $Credential = (Get-Credential -Message 'Enter your credentials')
          }
        }
        switch ($DirID)
        {
          0
          {
            $Query = (@'
DECLARE @DIRTCDIR TABLE
(
	TCID int,
	DIRID int,
	NAME varchar(30),
	MEMBEROF int,
	MOVEDTOBIN datetime
)
INSERT INTO @DIRTCDIR (TCID, DIRID, NAME, MEMBEROF, MOVEDTOBIN)
SELECT  [{0}].[{1}].THINCLIENTISINDIRECTORY.TCID AS TCID,
[{0}].[{1}].DIRECTORIES.DIRID AS DIRID,
[{0}].[{1}].DIRECTORIES.NAME AS NAME,
[{0}].[{1}].DIRECTORIES.MEMBEROF AS MEMBEROF,
[{0}].[{1}].DIRECTORIES.MOVEDTOBIN AS MOVEDTOBIN
FROM  [{0}].[{1}].THINCLIENTISINDIRECTORY
RIGHT OUTER JOIN
[{0}].[{1}].DIRECTORIES ON [{0}].[{1}].THINCLIENTISINDIRECTORY.DIRID = [{0}].[{1}].DIRECTORIES.DIRID
SELECT * FROM @DIRTCDIR
'@ -f $Database, $Schema)
          }
          default
          {
            $Query = (@'
DECLARE @DIRTCDIR TABLE
(
	TCID int,
	DIRID int,
	NAME varchar(30),
	MEMBEROF int,
	MOVEDTOBIN datetime
)
INSERT INTO @DIRTCDIR (TCID, DIRID, NAME, MEMBEROF, MOVEDTOBIN)
SELECT  [{0}].[{1}].THINCLIENTISINDIRECTORY.TCID AS TCID,
[{0}].[{1}].DIRECTORIES.DIRID AS DIRID,
[{0}].[{1}].DIRECTORIES.NAME AS NAME,
[{0}].[{1}].DIRECTORIES.MEMBEROF AS MEMBEROF,
[{0}].[{1}].DIRECTORIES.MOVEDTOBIN AS MOVEDTOBIN
FROM  [{0}].[{1}].THINCLIENTISINDIRECTORY
RIGHT OUTER JOIN
[{0}].[{1}].DIRECTORIES ON [{0}].[{1}].THINCLIENTISINDIRECTORY.DIRID = [{0}].[{1}].DIRECTORIES.DIRID
SELECT * FROM @DIRTCDIR
WHERE DIRID = {2}
'@ -f $Database, $Schema, $DirID)
          }
        }
        $QueryColl = Invoke-Sqlcmd2 -ServerInstance $ServerInstance -Database $Database -Credential $Credential -Query $Query
        $GroupedQueryColl = $QueryColl | Group-Object -Property DIRID
        $UMSThinclientDirectory = foreach ($GroupedQuery in $GroupedQueryColl)
        {
          $TCIDColl = foreach ($TCID in (($GroupedQuery.Group).TCID))
          {
            if ($TCID -isnot [DBNull])
            {
              $TCIDCollProperties = @{
                objectType = 'tc'
                id         = $TCID
              }
              New-Object -TypeName PSObject -Property $TCIDCollProperties
            }
          }
          $Properties = @{
            DirectoryChildren = $TCIDColl
            id                = ($GroupedQuery.Group).DIRID | Select-Object -First 1
            name              = ($GroupedQuery.Group).Name | Select-Object -First 1
            parentID          = ($GroupedQuery.Group).MEMBEROF | Select-Object -First 1
            movedToBin        = ($GroupedQuery.Group).MOVEDTOBIN | Select-Object -First 1
            objectType        = 'tcdirectory'
          }
          New-Object -TypeName PSObject -Property $Properties
        }
        $UMSThinclientDirectory
      }
    }
  }
  End
  {
  }
}

