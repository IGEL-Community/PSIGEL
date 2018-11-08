function Update-UMSThinclient
{
  <#
      .Synopsis
      Updates properties of a Thinclient from Rest API.

      .DESCRIPTION
      Updates properties of a Thinclient from Rest API.

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
      $Computername = 'UMSSERVER'
      $Params = @{
        Computername  = 'UMSSERVER'
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
      Update-UMSThinclient @Params
      #Updates thinclient with all possible attributes.

      .EXAMPLE
      Update-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession -TCID 48426 -Comment ''
      #Removes comment of the thinclient to TC030564.

      .EXAMPLE
      Update-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession -TCID 48426 -Name 'TC030564'
      #Upates name of the thinclient to TC030564.
  #>

  [cmdletbinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
  param
  (
    [Parameter(Mandatory)]
    [String]
    $Computername,

    [ValidateRange(0, 65535)]
    [Int]
    $TCPPort = 8443,

    [ValidateSet(3)]
    [Int]
    $ApiVersion = 3,

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
    if ($null -eq $WebSession)
    {
      $WebSession = New-UMSAPICookie -Computername $Computername
    }

    $UriArray = @($Computername, $TCPPort, $ApiVersion, $TCID)
    $Uri = 'https://{0}:{1}/umsapi/v{2}/thinclients/{3}' -f $UriArray

    $BodyHashTable = @{}
    if ($Name)
    {
      $BodyHashTable.name = $Name
    }
    if ($Site)
    {
      $BodyHashTable.site = $Site
    }
    if ($Department)
    {
      $BodyHashTable.department = $Department
    }
    if ($CostCenter)
    {
      $BodyHashTable.costCenter = $CostCenter
    }
    if ($LastIP)
    {
      $BodyHashTable.lastIP = $LastIP
    }
    if ($Comment)
    {
      $BodyHashTable.comment = $Comment
    }
    else
    {
      if ($null -ne $Comment)
      {
        $BodyHashTable.comment = $Comment
      }
    }
    if ($AssetID)
    {
      $BodyHashTable.assetID = $AssetID
    }
    if ($InserviceDate)
    {
      $BodyHashTable.inserviceDate = $InserviceDate
    }
    if ($SerialNumber)
    {
      $BodyHashTable.serialNumber = $SerialNumber
    }

    $Body = ConvertTo-Json $BodyHashTable

    $Params = @{
      WebSession  = $WebSession
      Uri         = $Uri
      Body        = $Body
      Method      = 'Put'
      ContentType = 'application/json'
      Headers     = @{}
    }

    if ($PSCmdlet.ShouldProcess('TCID: {0}' -f $TCID))
    {
      Invoke-UMSRestMethodWebSession @Params
    }
  }
  End
  {
  }
}

