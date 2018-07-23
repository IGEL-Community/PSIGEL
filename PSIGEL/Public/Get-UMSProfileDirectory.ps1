function Get-UMSProfileDirectory
{
  <#
      .Synopsis
      Gets information on a specific Profile Directory via API

      .DESCRIPTION
      Gets information on a specific Profile Directory via API

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port API (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER Children
      Switch for recursively listing children (Default false)

      .PARAMETER DIRID
      DIRIDs to get information of

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      Get-UMSProfileDirectory -Computername 'UMSSERVER' -WebSession $WebSession
      #Gets information on all Profile Directories

      .EXAMPLE
      (Get-UMSProfileDirectory -Computername 'UMSSERVER' -Children).DirectoryChildren
      #Gets information on all children of the Profile Directories

      .EXAMPLE
      Get-UMSProfileDirectory -Computername 'UMSSERVER' -DIRID 421
      #Gets information on a specific Profile Directory

      .EXAMPLE
      (421 | Get-UMSProfileDirectory -Computername 'UMSSERVER' -Children).DirectoryChildren
      #Gets children off Profile Directory with DirID 421.

  #>

  [cmdletbinding(SupportsShouldProcess, ConfirmImpact = 'Medium', DefaultParameterSetName = 'Overview')]
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

    [Switch]
    $Children,

    [Parameter(ParameterSetName = 'DIR', Mandatory, ValueFromPipeline)]
    [Int]
    $DIRID
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
    $BaseURL = 'https://{0}:{1}/umsapi/v{2}/directories/profiledirectories/' -f $Computername, $TCPPort, $ApiVersion
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
    $SessionURL = ('{0}/{1}' -f $BaseURL, $URLEnd)
    Invoke-UMSRestMethodWebSession -WebSession $WebSession -SessionURL $SessionURL -Method 'Get'
  }
  End
  {
  }
}