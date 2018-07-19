function Get-UMSThinclient
{
  <#
      .Synopsis
      Gets Thinclient from API or MSSQL

      .DESCRIPTION
      Gets Thinclient from API or MSSQL

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port API (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .Parameter Details
      Detailed of information on all thin clients ('short','full','inventory','online'; Default:'short').

      .PARAMETER ServerInstance
      SQL ServerInstance  for the UMS-DB (e.g. 'SQLSERVER\RMDB')

      .PARAMETER Database
      SQL Database  for the UMS-DB (e.g. 'RMDB')

      .PARAMETER Schema
      SQL Schema  for the UMS-DB (e.g. 'igelums')

      .PARAMETER Credential
      Specifies A PSCredential for SQL Server Authentication connection to an instance of the Database Engine.
      If -Credential is not specified, Invoke-Sqlcmd attempts a Windows Authentication connection using the Windows account running the PowerShell session.

      .PARAMETER TCID
      ThinclientID to search for

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      Get-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession -Details 'full'
      Gets detailed information on all online thin clients.

      .EXAMPLE
      Get-UMSThinclient -Computername 'UMSSERVER' -TCID 2433
      Gets short information on thin clients with TCID 2433.

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      2433 | Get-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession -Details 'shadow'
      Gets shadow-information on Thinclient with TCID 2433.

      .EXAMPLE
      Get-UMSThinclient -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums'
      Gets all Thinclients

      .EXAMPLE
      $Credential = Get-Credential -Message 'Enter your credentials'
      Get-UMSThinclient -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums' -TCID 2433 -Credential $Credential
      Asks for Credential and gets Thinclient with TCID 2433

      .EXAMPLE
      2433, 2629 | Get-UMSThinclient -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums'
      Gets Thinclient with TCID 2433 and 2629
  #>

  [cmdletbinding()]
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
    $WebSession = $false,

    [Parameter(ParameterSetName = 'API')]
    [ValidateSet('short', 'full', 'online', 'shadow')]
    [String]
    $Details = 'short',

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
    $Credential = (Get-Credential -Message 'Enter your credentials'),

    [Parameter(ValueFromPipeline)]
    [int]
    $TCID = 0
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
          $false
          {
            $WebSession = New-UMSAPICookie -Computername $Computername
          }
        }
        Switch ($Details)
        {
          'short'
          {
            $URLEnd = ''
          }
          'full'
          {
            $URLEnd = '?facets=details'
          }
          'online'
          {
            $URLEnd = '?facets=online'
          }
          'shadow'
          {
            $URLEnd = '?facets=shadow'
          }
        }
        Switch ($TCID)
        {
          0
          {
            $SessionURL = 'https://{0}:{1}/umsapi/v{2}/thinclients{3}' -f $Computername, $TCPPort, $ApiVersion, $URLEnd
          }
          default
          {
            $SessionURL = 'https://{0}:{1}/umsapi/v{2}/thinclients/{3}{4}' -f $Computername, $TCPPort, $ApiVersion, $TCID, $URLEnd
          }

        }
        Invoke-UMSRestMethodWebSession -WebSession $WebSession -SessionURL $SessionURL -Method 'Get'
      }
      SQL
      {
        Switch ($TCID)
        {
          0
          {
            $Query = @"
SELECT *
FROM [$Database].[$Schema].[THINCLIENT] TC, [$Database].[$Schema].[THINCLIENTISINDIRECTORY] TD, [$Database].[$Schema].[FIRMWARE] FW
WHERE TC.TCID = TD.TCID
AND TC.FIRMWAREID = FW.FIRMWAREID
"@
          }
          default
          {
            $Query = (@"
SELECT *
FROM [$Database].[$Schema].[THINCLIENT] TC, [$Database].[$Schema].[THINCLIENTISINDIRECTORY] TD, [$Database].[$Schema].[FIRMWARE] FW
WHERE TC.TCID = TD.TCID
AND TC.FIRMWAREID = FW.FIRMWAREID
AND TC.TCID = '{0}'
"@ -f $TCID)
          }
        }
        Invoke-Sqlcmd2 -ServerInstance $ServerInstance -Database $Database -Credential $Credential -Query $Query
      }
    }
  }
  End
  {
  }
}
