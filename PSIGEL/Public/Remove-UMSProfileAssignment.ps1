﻿function Remove-UMSProfileAssignment
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

    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [Int]
    $Id,

    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [Int]
    $ReceiverId,

    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [ValidateSet('tc', 'tcdirectory')]
    [String]
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
      $APIObjectColl = Invoke-UMSRestMethodWebSession @Params
    }
    $Result = foreach ($APIObject in $APIObjectColl)
    {
      $Properties = [ordered]@{
        'Message'      = [String]('{0}.' -f $APIObject.Message)
        'Id'           = [Int]$Id
        'ReceiverId'   = [Int]$ReceiverId
        'ReceiverType' = [String]$ReceiverType
      }
      New-Object psobject -Property $Properties
    }
    $Result
  }
  End
  {
  }
}

