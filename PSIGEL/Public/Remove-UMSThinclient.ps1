function Remove-UMSThinclient
{
  [cmdletbinding(SupportsShouldProcess, ConfirmImpact = 'High', DefaultParameterSetName = 'Offline')]
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

    [Parameter(ParameterSetName = 'Online')]
    [Switch]
    $Online
  )

  Begin
  {
    $UriArray = @($Computername, $TCPPort, $ApiVersion)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/thinclients' -f $UriArray)
  }
  Process
  {
    $Params = @{
      WebSession       = $WebSession
      Method           = 'Delete'
      ContentType      = 'application/json'
      Headers          = @{}
      SecurityProtocol = ($SecurityProtocol -join ',')
    }
    Switch ($PsCmdlet.ParameterSetName)
    {
      'Offline'
      {
        $Params.Add('Uri', ('{0}/{1}/deletetcoffline' -f $BaseURL, $Id))
      }
      'Online'
      {
        $Params.Add('Uri', ('{0}/{1}' -f $BaseURL, $Id))
      }
    }
    if ($PSCmdlet.ShouldProcess('TCID: {0}' -f $TCID))
    {
      $APIObjectColl = Invoke-UMSRestMethodWebSession @Params
    }
    $Result = foreach ($APIObject in $APIObjectColl)
    {
      Switch ($PsCmdlet.ParameterSetName)
      {
        'Offline'
        {
          $Properties = [ordered]@{
            'Message' = [string]('{0}.' -f $APIObject.Message)
            'Id'      = [int]$Id
          }
        }
        'Online'
        {
          $Properties = [ordered]@{
            'Message'  = [string]('{0}.' -f $APIObject.CommandExecList.message)
            'Id'       = [int]$Id
            'ExecId'   = [int]$APIObject.CommandExecList.execID
            'Mac'      = [string]$APIObject.CommandExecList.mac
            'ExecTime' = [int]$APIObject.CommandExecList.exectime
            'State'    = [string]$APIObject.CommandExecList.state
          }
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

