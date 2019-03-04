function Update-UMSProfileDirectory
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

    [ValidateSet('Tls12', 'Tls11', 'Tls', 'Ssl3')]
    [String[]]
    $SecurityProtocol = 'Tls12',

    [Parameter(Mandatory)]
    $WebSession,

    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [Int]
    $Id,

    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [String]
    $Name
  )

  Begin
  {
    $UriArray = @($Computername, $TCPPort, $ApiVersion, $Id)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/directories/profiledirectories/{3}' -f $UriArray)
  }
  Process
  {
    $Body = ConvertTo-Json @{
      name = $Name
    }
    $Params = @{
      WebSession       = $WebSession
      Uri              = $BaseURL
      Body             = $Body
      Method           = 'Put'
      ContentType      = 'application/json'
      Headers          = @{}
      SecurityProtocol = ($SecurityProtocol -join ',')
    }
    if ($PSCmdlet.ShouldProcess(('Id: {0}' -f $Id)))
    {
      $APIObjectColl = Invoke-UMSRestMethodWebSession @Params
    }
    $Result = foreach ($APIObject in $APIObjectColl)
    {
      $Properties = [ordered]@{
        'Message' = [String]$APIObject.message
        'Id'      = [Int]$Id
      }
      New-Object psobject -Property $Properties
    }
    $Result
  }
  End
  {
  }
}