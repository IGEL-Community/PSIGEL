function New-UMSThinclient
{
  <#
      .Synopsis
      Creates a new thinclient from Rest API.

      .DESCRIPTION
      Creates a new thinclient from Rest API.

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .Parameter Mac
      Mac-Address in format '001122AABBCC'

      .Parameter FirmwareID
      FirmwareID of the Thinclient

      .Parameter Name
      Hostname of the Thinclient

      .Parameter ParentID
      ID of the parent directory of the thinclient (Default: -1)

      .Parameter Site
      Thinclient Attribute Site

      .Parameter Department
      Thinclient Attribute Department

      .Parameter CostCenter
      Thinclient Attribute CostCenter

      .Parameter LastIP
      Thinclient Attribute LastIP

      .Parameter Comment
      Thinclient Attribute Comment

      .Parameter AssetID
      Thinclient Attribute AssetID

      .Parameter InserviceDate
      Thinclient Attribute InserviceDate

      .Parameter SerialNumber
      Thinclient Attribute SerialNumber

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      New-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession -Mac '012345678910' -FirmwareID 9
      Creates new thinclient with mac, name and firmwareid (minimal requirements) in the root directory.

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      $NewUMSThinclientParams = @{
      Computername  = 'UMSSERVER'
      WebSession    =  $WebSession
      Mac           = '012345678910'
      FirmwareID    = 9
      Name          = 'TC012345'
      ParentID      = 772
      Site          = 'Leipzig'
      Department    = 'Marketing'
      CostCenter    = '50100'
      LastIP        = '192.168.0.10'
      Comment       = 'New Thinclient'
      AssetID       = '012345'
      InserviceDate = '01.01.2018'
      SerialNumber  = '12A3B4C56B12345A6BC'
      }
      New-UMSThinclient @NewUMSThinclientParams
      Creates new thinclient with all possible attributes.
  #>

  [cmdletbinding()]
  param
  (
    [Parameter( Mandatory)]
    [String]
    $Computername,

    [ValidateRange(0, 65535)]
    [Int]
    $TCPPort = 8443,

    [ValidateSet(2, 3)]
    [Int]
    $ApiVersion = 3,

    $WebSession,

    [Parameter(Mandatory)]
    [String]
    $Mac,

    [Parameter(Mandatory)]
    [int]
    $FirmwareID,

    [String]
    $Name,

    [int]
    $ParentID = '-1',

    [String]
    $Site,

    [String]
    $Department,

    [String]
    $CostCenter,

    [ValidateScript( {$_ -match [IPAddress]$_})]
    [String]
    $LastIP,

    [String]
    $Comment,

    [String]
    $AssetID,

    [String]
    $InserviceDate,

    [ValidateLength(19, 19)]
    [String]
    $SerialNumber
  )

  Begin
  {
  }
  Process
  {
    Switch ($WebSession)
    {
      $null
      {
        $WebSession = New-UMSAPICookie -Computername $Computername
      }
    }
    $Body = [ordered]@{
      mac           = $Mac
      firmwareID    = $FirmwareID
      name          = $Name
      parentID      = $ParentID
      site          = $Site
      department    = $Department
      costCenter    = $CostCenter
      lastIP        = $LastIP
      comment       = $Comment
      assetID       = $AssetID
      inserviceDate = $InserviceDate
      serialNumber  = $SerialNumber
    } | ConvertTo-Json
    $SessionURL = 'https://{0}:{1}/umsapi/v{2}/thinclients/' -f $Computername, $TCPPort, $ApiVersion

    Invoke-UMSRestMethodWebSession -WebSession $WebSession -SessionURL $SessionURL -BodyWavy $Body -Method 'Put'
  }
  End
  {
  }
}

