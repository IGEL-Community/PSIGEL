function Remove-UMSProfileAssignment
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

    [Parameter(Mandatory, ValueFromPipeline)]
    [int]
    $Id,

    [Parameter(Mandatory)]
    [int]
    $ReceiverId,

    [Parameter(Mandatory)]
    [ValidateSet('tc', 'tcdirectory')]
    [string]
    $ReceiverType
  )

  Begin
  {
    $UriArray = @($Computername, $TCPPort, $ApiVersion, $Id)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/profiles/{3}' -f $UriArray)
  }
  Process
  {
    Switch ($ReceiverType)
    {
      'tc'
      {
        $Uri = '{0}/assignments/thinclients/{1}' -f $BaseURL, $ReceiverId
      }
      'tcdirectory'
      {
        $Uri = '{0}/assignments/tcdirectories/{1}' -f $BaseURL, $ReceiverId
      }
    }
    $Params = @{
      WebSession       = $WebSession
      Uri              = $Uri
      Method           = 'Delete'
      ContentType      = 'application/json'
      Headers          = @{}
      SecurityProtocol = ($SecurityProtocol -join ',')
    }
    $SPArray = @($Id, $ReceiverId, $ReceiverType)
    if ($PSCmdlet.ShouldProcess(('Id: {0}, ReceiverID {1}, ReceiverType: {2}' -f $SPArray)))
    {
      $Json = Invoke-UMSRestMethodWebSession @Params
    }
    $Result = foreach ($item in $Json)
    {
      $Properties = [ordered]@{
        'Message'      = [string]('{0}.' -f $item.Message)
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

