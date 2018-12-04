function Get-UMSThinclientDirectory
{
  [cmdletbinding(DefaultParameterSetName = 'Overview')]
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

    [switch]
    $Children,

    [Parameter(ParameterSetName = 'DIR', Mandatory, ValueFromPipeline)]
    [int]
    $DirID
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
    
    $Params = @{
      WebSession  = $WebSession
      Method      = 'Get'
      ContentType = 'application/json'
      Headers     = @{}
    }

    $BUArray = @($Computername, $TCPPort, $ApiVersion)
    $BaseURL = 'https://{0}:{1}/umsapi/v{2}/directories/tcdirectories/' -f $BUArray

    Switch ($PSCmdlet.ParameterSetName)
    {
      'Overview'
      {
        Switch ($Children)
        {
          $false
          {
            $URLEnd = ''
          }
          default
          {
            $URLEnd = '?facets=children'
          }
        }
      }
      'DIR'
      {
        Switch ($Children)
        {
          $false
          {
            $URLEnd = ('{0}' -f $DIRID)
          }
          default
          {
            $URLEnd = ('{0}?facets=children' -f $DIRID)
          }
        }
      }
    }

    $Params.Uri = '{0}/{1}' -f $BaseURL, $URLEnd
    Invoke-UMSRestMethodWebSession @Params
  }
  End
  {
  }
}

