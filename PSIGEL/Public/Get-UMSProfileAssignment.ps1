function Get-UMSProfileAssignment
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

    [Parameter(ValueFromPipeline, ParameterSetName = 'ID')]
    [int]
    $ProfileID
  )
  Begin
  {
    #$UriArray = @($Computername, $TCPPort, $ApiVersion)
    $UriArray = @($Computername, $TCPPort, $ApiVersion, $ProfileID, $UriEnd)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/assignments' -f $UriArray)
  }
  Process
  {
    $UriEndColl = ('thinclients', 'tcdirectories')
    $Params = @{
      WebSession       = $WebSession
      Method           = 'Get'
      ContentType      = 'application/json'
      Headers          = @{}
      SecurityProtocol = ($SecurityProtocol -join ',')
    }

    $TCIDColl = foreach ($UriEnd in $UriEndColl)
    {
      #$UriArray = @($Computername, $TCPPort, $ApiVersion, $ProfileID, $UriEnd)
      $UriArray.Add($UriEnd)
      $Params.Uri = 'https://{0}:{1}/umsapi/v{2}/profiles/{3}/assignments/{4}/' -f $UriArray
      $HrefColl = (Invoke-RestMethod @Params).links |
        Where-Object -Property rel -EQ 'receiver' |
        Select-Object -Property href

      Switch ($UriEnd)
      {
        'thinclients'
        {
          $Type = 'tc'
        }
        'tcdirectories'
        {
          $Type = 'tcdirectory'
        }
      }

      foreach ($Href in $HrefColl)
      {
        $Properties = @{
          id   = ([regex]::match(($Href.href), "\d{1,}\s*$")).Value
          type = $Type
        }
        New-Object -TypeName PsObject -Property $Properties
      }
    }
    $TCIDColl
  }
  End
  {
  }
}

