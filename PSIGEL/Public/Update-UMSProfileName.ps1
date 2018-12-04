function Update-UMSProfileName
{
  [cmdletbinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
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
    $ProfileID,

    [Parameter(Mandatory)]
    [String]
    $Name
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

    $UriArray = @($Computername, $TCPPort, $ApiVersion, $ProfileID)
    $Uri = 'https://{0}:{1}/umsapi/v{2}/profiles/{3}' -f $UriArray

    $Body = ConvertTo-Json @{
      name = $Name
    }

    $Params = @{
      WebSession  = $WebSession
      Uri         = $Uri
      Body        = $Body
      Method      = 'Put'
      ContentType = 'application/json'
      Headers     = @{}
    }

    if ($PSCmdlet.ShouldProcess(('ProfileID: {0}, new name: {1}' -f $ProfileID, $Name)))
    {
      Invoke-UMSRestMethodWebSession @Params
    }
  }
  End
  {
  }
}