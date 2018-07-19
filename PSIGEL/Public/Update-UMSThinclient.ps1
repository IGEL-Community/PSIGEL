function Update-UMSThinclient
{
  <#
      .Synopsis
      Updates a thinclient from Rest API.

      .DESCRIPTION
      Updates a thinclient from Rest API.

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER TCID
      ThinclientID of the thinclient to update

      .Parameter Name
      Hostname of the Thinclient

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
      Update-UMSThinclient -Computername $Computername -WebSession $WebSession -TCID 100 -Site 'Berlin'
      Upates site of the thinclient to Berlin.

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      $UpdateUMSThinclientParams = @{
      Computername  = 'UMSSERVER'
      WebSession    = $WebSession
      TCID          = 100
      Name          = 'TC012345'
      ParentID      = '772'
      Site          = 'Leipzig'
      Department    = 'Marketing'
      CostCenter    = '50100'
      LastIP        = '192.168.0.10'
      Comment       = 'New Thinclient'
      AssetID       = '012345'
      InserviceDate = '01.01.2018'
      SerialNumber  = '12A3B4C56B12345A6BC'
      }
      Update-UMSThinclient @UpdateUMSThinclientParams
      Updates thinclient with all possible attributes.
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

    [ValidateSet(3)]
    [Int]
    $ApiVersion = 3,

    [Parameter(Mandatory)]
    $WebSession,

    [Parameter(Mandatory, ValueFromPipeline)]
    [int]
    $TCID,

    [String]
    $Name,

    [String]
    $Site,

    [String]
    $Department,

    [String]
    $CostCenter,

    [ValidatePattern('^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$')]
    [String]
    $LastIP,

    [String]
    $Comment,

    [String]
    $AssetID,

    [String]
    $InserviceDate,

    [ValidateLength(19,19)]
    [String]
    $SerialNumber
  )

  Begin
  {
  }
  Process
  {
    $HashTable = [ordered]@{}
    if ($Name)
    {
      $HashTable += @{
        name = $Name
      }
    }
    if ($Site)
    {
      $HashTable += @{
        site = $Site
      }
    }
    if ($Department)
    {
      $HashTable += @{
        department = $Department
      }
    }
    if ($CostCenter)
    {
      $HashTable += @{
        costCenter = $CostCenter
      }
    }
    if ($LastIP)
    {
      $HashTable += @{
        lastIP = $LastIP
      }
    }
    if ($Comment)
    {
      $HashTable += @{
        comment = $Comment
      }
    }
    if ($AssetID)
    {
      $HashTable += @{
        assetID = $AssetID
      }
    }
    if ($InserviceDate)
    {
      $HashTable += @{
        inserviceDate = $InserviceDate
      }
    }
    if ($SerialNumber)
    {
      $HashTable += @{
        serialNumber = $SerialNumber
      }
    }

    $Body = $HashTable | ConvertTo-Json

    $SessionURL = 'https://{0}:{1}/umsapi/v{2}/thinclients/{3}' -f $Computername, $TCPPort, $ApiVersion, $TCID

    $ThinclientsJSONCollParams = @{
      Uri         = $SessionURL
      Headers     = @{}
      Body        = '{0}' -f $Body
      ContentType = 'application/json'
      Method      = 'Put'
      WebSession  = $WebSession
    }

    $ThinclientsJSONColl = Invoke-RestMethod @ThinclientsJSONCollParams
    $ThinclientsJSONColl
  }
  End
  {
  }
}

