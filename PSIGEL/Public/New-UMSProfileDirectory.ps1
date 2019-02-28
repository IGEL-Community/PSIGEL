function New-UMSProfileDirectory
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

    [ValidateSet('Tls12', 'Tls11', 'Tls', 'Ssl3')]
    [String[]]
    $SecurityProtocol = 'Tls12',

    [Parameter(Mandatory)]
    $WebSession,

    [Parameter(Mandatory, ValueFromPipeline)]
    [String]
    $Name
  )

  Begin
  {
    $UriArray = @($Computername, $TCPPort, $ApiVersion)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/directories/profiledirectories' -f $UriArray)
  }
  Process
  {
    $Body = ConvertTo-Json @{
      name = $Name
    }
    $Params = @{
      WebSession  = $WebSession
      Uri         = $BaseURL
      Body        = $Body
      Method      = 'Put'
      ContentType = 'application/json'
      Headers     = @{}
    }
    if ($PSCmdlet.ShouldProcess('Name: {0}' -f $Name))
    {
      $APIObjectColl = Invoke-UMSRestMethodWebSession @Params
    }
    $Result = foreach ($APIObject in $APIObjectColl )
    {
      $Properties = [ordered]@{
        'Message' = [string]$APIObject.message
        'Id'      = [int]$APIObject.id
        'Name'    = [string]$APIObject.name
      }
      New-Object psobject -Property $Properties
    }
    $Result
  }
  End
  {
  }
}