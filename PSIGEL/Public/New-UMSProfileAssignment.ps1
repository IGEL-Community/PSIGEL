function New-UMSProfileAssignment
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
    [int]
    $Id,

    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [int]
    $ReceiverId,

    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [ValidateSet('tc', 'tcdirectory')]
    [string]
    $ReceiverType
  )

  Begin
  {
    $UriArray = @($Computername, $TCPPort, $ApiVersion, $Id)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/profiles/{3}' -f $UriArray)
    #$Uri = 'https://{0}:{1}/umsapi/v{2}/profiles/{3}/assignments/{4}' -f $UriArray
  }
  Process
  {
    Switch ($ReceiverType)
    {
      'tc'
      {
        $Uri = '{0}/assignments/thinclients' -f $BaseURL
      }
      'tcdirectory'
      {
        $Uri = '{0}/assignments/tcdirectories' -f $BaseURL
      }
    }
    $Body = ConvertTo-Json @(
      @{
        assignee = @{
          id   = $Id
          type = 'profile'
        }
        receiver = @{
          id   = $ReceiverID
          type = $ReceiverType
        }
      }
    )
    $Params = @{
      WebSession       = $WebSession
      Uri              = $Uri
      Body             = $Body
      Method           = 'Put'
      ContentType      = 'application/json'
      Headers          = @{}
      SecurityProtocol = ($SecurityProtocol -join ',')
    }

    $SPArray = @($Id, $ReceiverId, $ReceiverType)
    if ($PSCmdlet.ShouldProcess(('Id: {0}, ReceiverId: {1}, ReceiverType: {2}' -f $SPArray)))
    {
      $APIObjectColl = Invoke-UMSRestMethodWebSession @Params
    }
    $Result = foreach ($APIObject in $APIObjectColl)
    {
      $Properties = [ordered]@{
        'Message'      = [string]('{0}.' -f $APIObject.Message)
        'Id'           = [int]$Id
        'ReceiverId'   = [int]$ReceiverId
        'ReceiverType' = [string]$ReceiverType
      }
      New-Object psobject -Property $Properties
    }
    $Result
  }
  End
  {
  }
}

