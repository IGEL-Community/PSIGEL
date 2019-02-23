function Get-UMSProfileDirectory
{
  [CmdletBinding(DefaultParameterSetName = 'All')]
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

    [Switch]
    $Children,

    [Parameter(ValueFromPipeline, ParameterSetName = 'ID')]
    [Int]
    $DIRID
  )

  Begin
  {
    $UriArray = @($Computername, $TCPPort, $ApiVersion)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/directories/profiledirectories/' -f $UriArray)
  }
  Process
  {
    $Params = @{
      WebSession       = $WebSession
      Method           = 'Get'
      ContentType      = 'application/json'
      Headers          = @{}
      SecurityProtocol = ($SecurityProtocol -join ',')
    }
    Switch ($PSCmdlet.ParameterSetName)
    {
      'All'
      {
        Switch ($Children)
        {
          $false
          {
            $Params.Add('Uri', ('{0}' -f $BaseURL))
          }
          default
          {
            $Params.Add('Uri', ('{0}?facets=children' -f $BaseURL))
          }
        }
      }
      'ID'
      {
        Switch ($Children)
        {
          $false
          {
            $Params.Add('Uri', ('{0}/{1}' -f $BaseURL, $DIRID))
          }
          default
          {
            $Params.Add('Uri', ('{0}/{1}?facets=children' -f $BaseURL, $DIRID))
          }
        }
      }
    }
    Invoke-UMSRestMethodWebSession @Params
  }
  End
  {
  }
}