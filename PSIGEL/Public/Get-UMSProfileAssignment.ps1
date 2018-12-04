function Get-UMSProfileAssignment
{
  [cmdletbinding()]
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

    [Parameter(Mandatory)]
    $WebSession,

    [Parameter(Mandatory, ValueFromPipeline)]
    [int]
    $ProfileID
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

    $UriEndColl = ('thinclients', 'tcdirectories')
    $Params = @{
      WebSession  = $WebSession
      Method      = 'Get'
      ContentType = 'application/json'
      Headers     = @{}
    }

    $TCIDColl = foreach ($UriEnd in $UriEndColl)
    {
      $UriArray = @($Computername, $TCPPort, $ApiVersion, $ProfileID, $UriEnd)
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

