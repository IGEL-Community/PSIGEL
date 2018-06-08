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
      API Version to use (2 or 3, Default: 3)

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
      
      Get-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession -Details 'full' | Out-GridView
      Gets detailed information on all online thin clients.

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER' -Username rmdb
      Get-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession -TCID 2433
      Gets short information on thin clients with TCID 2433.
      
      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER' -Username rmdb
      2433 | Get-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession -Details 'shadow'
      Gets shadow-information on Thinclient with TCID 2433.

      .EXAMPLE
      Get-UMSThinclient -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums' | Out-GridView
      Gets all Thinclients
      
      .EXAMPLE
      $Credential = Get-Credential -Message 'Enter your credentials'
      Get-UMSThinclient -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums' -TCID 2433 -Credential $Credential
      Asks for Credential and gets Thinclient with TCID 2433
      
      .EXAMPLE
      2433 | Get-UMSThinclient -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums'
      Gets Thinclient with TCID 2433
  #>
  
  [cmdletbinding()]
  param
  ( 
    [Parameter(Mandatory, ParameterSetName = 'API')]
    [String]
    $Computername,

    [Parameter(ParameterSetName = 'API')]
    [ValidateRange(0,49151)]
    [Int]
    $TCPPort = 8443,
   
    [Parameter(ParameterSetName = 'API')]
    [ValidateSet(2,3)]
    [Int]
    $ApiVersion = 3,
    
    [Parameter(Mandatory, ParameterSetName = 'API')]
    $WebSession,
    
    [Parameter(ParameterSetName = 'API')]
    [ValidateSet('short','full','online','shadow')]
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
    [PSCredential]
    $Credential,
    
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

        $ThinclientsJSONCollParams = @{
          Uri         = $SessionURL
          Headers     = @{}
          ContentType = 'application/json; charset=utf-8'
          Method      = 'Get'
          WebSession  = $WebSession
        }

        $ThinclientsJSONColl = Invoke-RestMethod @ThinclientsJSONCollParams
        $ThinclientsJSONColl
      }
      SQL
      {
        if ($Credential)
        {
          $InvokeSqlcmd2Params = @{
            ServerInstance = $ServerInstance
            Database       = $Database
            Credential     = $Credential
          }
        }
        else
        {
          $InvokeSqlcmd2Params = @{
            ServerInstance = $ServerInstance
            Database       = $Database
          }
        }
        
        switch ($TCID)
        {
          0
          {
            $Query = @"
SELECT *
FROM [$Database].[$Schema].[THINCLIENT] TC, [$Database].[$Schema].[THINCLIENTISINDIRECTORY] TD, [$Database].[$Schema].[FIRMWARE] FW
WHERE TC.TCID = TD.TCID
AND TC.FIRMWAREID = FW.FIRMWAREID
"@
            Invoke-Sqlcmd2 @InvokeSqlcmd2Params -Query $Query
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
            Invoke-Sqlcmd2 @InvokeSqlcmd2Params -Query $Query
          }
        }
      }
    }

  }
  End
  {
  }
}
