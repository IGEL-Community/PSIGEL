function Get-UMSProfileAssignment
{
  <#
    .Synopsis
    Gets the thinclients and directories the profile is assigned to.

    .DESCRIPTION
    Gets the thinclients and directories the profile is assigned to.

    .PARAMETER Computername
    Computername of the UMS Server

    .PARAMETER TCPPort
    TCP Port (Default: 8443)

    .PARAMETER ApiVersion
    API Version to use (Default: 3)

    .Parameter WebSession
    Websession Cookie

    .PARAMETER ProfileID
    ProfileID to search for

    .EXAMPLE
    $Computername = 'UMSSERVER'
    $Params = @{
      Computername = $Computername
      WebSession   = New-UMSAPICookie -Computername $Computername
      ProfileID    = 471
    }
    Get-UMSProfileAssignment @Params
    #Gets the thin clients and the directories the profile with ProfileID 471 is assigned to.

    .EXAMPLE
    471 | Get-UMSProfileAssignment -Computername 'UMSSERVER'
    #Gets the thin clients and the directories the profile with ProfileID 471 is assigned to.
#>
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

