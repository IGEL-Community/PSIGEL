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
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      Get-UMSThinclientDirectory -Computername 'UMSSERVER' -WebSession $WebSession
      #Gets information on all Thin Client Directories.

      .EXAMPLE
      (50 | Get-UMSThinclientDirectory -Computername 'UMSSERVER' -Children).DirectoryChildren
      #Gets children of thinclient directory with DirID 50.
  #>

  [CmdletBinding()]
  param
  (
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

    [Parameter(ValueFromPipeline)]
    [int]
    $DirID
  )

  Begin
  {
  }
  Process
  {
    Switch ($WebSession)
    {
      $null
      {
        $WebSession = New-UMSAPICookie -Computername $Computername
      }
    }
    $BaseURL = 'https://{0}:{1}/umsapi/v{2}/directories/tcdirectories' -f $Computername, $TCPPort, $ApiVersion
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
    Switch ($DirID)
    {
      0
      {
        $SessionURL = '{0}{1}' -f $BaseURL, $URLEnd
        (Invoke-UMSRestMethodWebSession -WebSession $WebSession -SessionURL $SessionURL -Method 'Get').SyncRoot
      }
      default
      {
        $SessionURL = '{0}/{1}{2}' -f $BaseURL, $DirID, $URLEnd
        Invoke-UMSRestMethodWebSession -WebSession $WebSession -SessionURL $SessionURL -Method 'Get'
      }
    }
  }
  End
  {
  }
}

