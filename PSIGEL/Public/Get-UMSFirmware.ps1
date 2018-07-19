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

      .PARAMETER FirmwareID
      ThinclientID to search for

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      Get-UMSFirmware -Computername 'UMSSERVER' -WebSession $WebSession
      Gets information on all firmwares known to the UMS.

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      9, 7 | Get-UMSFirmware -Computername 'UMSSERVER' -WebSession $WebSession
      Gets information on firmwares with FirmwareIDs 9 and 7.

      .EXAMPLE
      $Credential = Get-Credential -Message 'Enter your credentials'
      Get-UMSFirmware -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums' -FirmwareID 7 -Credential $Credential
      Asks for Credential and gets Firmware with FirmwareID 7

      .EXAMPLE
      9, 7 | Get-UMSFirmware -ServerInstance 'SQLSERVER\RMDB' -Database 'RMDB' -Schema 'igelums'
      Gets information on firmwares with FirmwareIDs 9 and 7.

  #>

  [cmdletbinding()]
  param
  (
    [Parameter( Mandatory, ParameterSetName = 'API')]
    [String]
    $Computername,

    [Parameter(ParameterSetName = 'API')]
    [ValidateRange(0, 49151)]
    [Int]
    $TCPPort = 8443,

    [Parameter(ParameterSetName = 'API')]
    [ValidateSet(3)]
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
    [ValidateNotNull()]
    [System.Management.Automation.PSCredential]
    [System.Management.Automation.Credential()]
    $Credential = (Get-Credential -Message 'Enter your credentials'),

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
            (Invoke-UMSRestMethodWebSession -WebSession $WebSession -SessionURL $SessionURL -Method 'Get').FwResource
          }
          default
          {
            $SessionURL = 'https://{0}:{1}/umsapi/v{2}/firmwares/{3}' -f $Computername, $TCPPort, $ApiVersion, $FirmwareID
            Invoke-UMSRestMethodWebSession -WebSession $WebSession -SessionURL $SessionURL -Method 'Get'
          }
        }
      }
      SQL
      {
        $InvokeSqlcmd2Params = @{
          ServerInstance = $ServerInstance
          Database       = $Database
          Credential     = $Credential
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