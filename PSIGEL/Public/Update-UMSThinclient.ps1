function Update-UMSThinclient
{
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

    [Parameter(ParameterSetName = 'Set')]
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
    Switch ($PsCmdlet.ParameterSetName)
    {
      'Set'
      {
        break
      }
      Default
      {
        throw "Specify at least one property to update!"
      }
    }
    
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

