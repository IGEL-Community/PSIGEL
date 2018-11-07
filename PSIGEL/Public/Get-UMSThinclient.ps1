function Get-UMSThinclient
{
  <#
      .Synopsis
      Gets Thinclient from API.

      .DESCRIPTION
      Gets Thinclient from API.

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port API (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter WebSession
      Websession Cookie

      .Parameter Details
      Detailed of information on all thin clients ('short','full','inventory','online'; Default:'short').

      .PARAMETER TCID
      ThinclientID to search for

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      Get-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession -Details 'full'
      #Gets detailed information on all online thin clients.

      .EXAMPLE
      Get-UMSThinclient -Computername 'UMSSERVER' -TCID 2433
      #Gets short information on thin clients with TCID 2433.

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER'
      2433, 2344 | Get-UMSThinclient -Computername 'UMSSERVER' -WebSession $WebSession -Details 'shadow'
      #Gets shadow-information on Thinclient with TCID 2433, 2433

  #>

  [cmdletbinding()]
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

    [ValidateSet('short', 'full', 'online', 'shadow')]
    [String]
    $Details = 'short',

    [Parameter(ValueFromPipeline)]
    [int]
    $TCID = 0
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
    
    Switch ($Details)
    {
      'short'
      {
        $URLEnd = ''
      }
      'full'
      {
        $URLEnd = '?facets=details'
      }
      'online'
      {
        $URLEnd = '?facets=online'
      }
      'shadow'
      {
        $URLEnd = '?facets=shadow'
      }
    }
    Switch ($TCID)
    {
      0
      {
        $Uri = 'https://{0}:{1}/umsapi/v{2}/thinclients{3}' -f $Computername, $TCPPort, $ApiVersion, $URLEnd
      }
      default
      {
        $Uri = 'https://{0}:{1}/umsapi/v{2}/thinclients/{3}{4}' -f $Computername, $TCPPort, $ApiVersion, $TCID, $URLEnd
      }

    }
    Invoke-UMSRestMethodWebSession -WebSession $WebSession -Uri $Uri -Method 'Get'
  }
  End
  {
  }
}
