function Get-UMSThinclientDirectory
{
  <#
      .Synopsis
      Gets information on Thin Client Directories from API.

      .DESCRIPTION
      Gets information on Thin Client Directories from API.

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER Children
      Switch for recursively listing children (Default false)

      .PARAMETER DirID
      DirID to search for

      .EXAMPLE
      $Computername = 'UMSSERVER'
      $Params = @{
        Computername = $Computername
        WebSession   = New-UMSAPICookie -Computername $Computername
      }
      Get-UMSThinclientDirectory @Params
      #Gets information on all Thinclient Directories

      .EXAMPLE
      (Get-UMSThinclientDirectory -Computername 'UMSSERVER' -Children).DirectoryChildren | Select-Object -First 10
      #Gets information on all children of the thinclient Directories, selects first 10

      .EXAMPLE
      Get-UMSThinclientDirectory -Computername 'UMSSERVER' -DIRID 772
      #Gets information on a specific Thinclient Directory

      .EXAMPLE
      (772 | Get-UMSThinclientDirectory -Computername 'UMSSERVER' -Children).DirectoryChildren
      #Gets children of Thinclient Directory with DirID 772.
  #>

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

