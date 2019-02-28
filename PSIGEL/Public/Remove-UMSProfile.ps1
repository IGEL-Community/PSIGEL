function Remove-UMSProfile
{
  [cmdletbinding(SupportsShouldProcess, ConfirmImpact = 'High')]
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
    [int]
    $Id
  )

  Begin
  {
    $UriArray = @($Computername, $TCPPort, $ApiVersion, $Id)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/profiles/{3}' -f $UriArray)
  }
  Process
  {
    $Params = @{
      WebSession       = $WebSession
      Uri              = $BaseURL
      Method           = 'Delete'
      ContentType      = 'application/json'
      Headers          = @{}
      SecurityProtocol = ($SecurityProtocol -join ',')
    }
    if ($PSCmdlet.ShouldProcess('ProfileID: {0}' -f $Id))
    {
      $APIObjectColl = Invoke-UMSRestMethodWebSession @Params
    }
    $Result = foreach ($APIObject in $APIObjectColl)
    {
      if ($APIObject.Message -match '^(?<Message>Deleted profile) with id (?<Id>\d+)$')
      {
        $Properties = [ordered]@{
          'Message' = [string]('{0}.' -f $Matches.Message)
          'Id'      = [int]$Matches.Id
        }
      }
      New-Object psobject -Property $Properties
    }
    $Result
  }
  End
  {
  }
}

