#requires -Version 3.0
function Get-UMSFirmware
{
  <#
      .Synopsis
      Gets information on all firmwares known to the UMS from API or MSSQL.

      .DESCRIPTION
      Gets information on all firmwares known to the UMS from API or MSSQL.

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (2 or 3, Default: 3)

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

      .PARAMETER FirmwareID
      ThinclientID to search for

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER' -Username rmdb
      Get-UMSFirmware -Computername 'UMSSERVER' -WebSession $WebSession | Out-Gridview
      Gets information on all firmwares known to the UMS to Out-Gridview.

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER' -Username rmdb
      9, 7 | Get-UMSFirmware -Computername 'UMSSERVER' -WebSession $WebSession
      Gets information on firmwares with FirmwareIDs 9 and 7.

      .EXAMPLE
      $Credential = Get-Credential -Message 'Enter your credentials'
      Get-UMSFirmware -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums' -FirmwareID 7 -Credential $Credential
      Asks for Credential and gets Firmware with FirmwareID 7

      .EXAMPLE
      9, 7 | Get-UMSThinclient -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums'
      Gets information on firmwares with FirmwareIDs 9 and 7.

  #>

  [cmdletbinding()]
  param
  (
    [Parameter( Mandatory, ParameterSetName = 'API')]
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
    $FirmwareID = 0
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
        Switch ($FirmwareID)
        {
          0
          {
            $SessionURL = 'https://{0}:{1}/umsapi/v{2}/firmwares' -f $Computername, $TCPPort, $ApiVersion
            $InvokeRestMethodParams = @{
              Uri         = $SessionURL
              Headers     = @{}
              ContentType = 'application/json; charset=utf-8'
              Method      = 'Get'
              WebSession  = $WebSession
            }
            (Invoke-RestMethod @InvokeRestMethodParams).FwResource
          }
          default
          {
            $SessionURL = 'https://{0}:{1}/umsapi/v{2}/firmwares/{3}' -f $Computername, $TCPPort, $ApiVersion, $FirmwareID
            $InvokeRestMethodParams = @{
              Uri         = $SessionURL
              Headers     = @{}
              ContentType = 'application/json; charset=utf-8'
              Method      = 'Get'
              WebSession  = $WebSession
            }
            Invoke-RestMethod @InvokeRestMethodParams
          }
        }
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

        switch ($FirmwareID)
        {
          0
          {
            $Query = @"
SELECT *
FROM [$Database].[$Schema].[FIRMWARE]
"@
            Invoke-Sqlcmd2 @InvokeSqlcmd2Params -Query $Query
          }
          default
          {
            $Query = (@"
SELECT *
FROM [$Database].[$Schema].[FIRMWARE]
WHERE FIRMWAREID = '{0}'
"@ -f $FirmwareID)
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

