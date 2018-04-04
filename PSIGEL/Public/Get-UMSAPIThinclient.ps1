function Get-UMSAPIThinclient
{
  <#
      .Synopsis
      Gets Thinclient from Rest API

      .DESCRIPTION
      Gets Thinclient from Rest API

      .PARAMETER Computername
      Computername of the UMS Server
      
      .PARAMETER TCPPort
      TCP Port (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (1,2 or3, Default: 3)

      .Parameter WebSession
      Websession Cookie

      .Parameter Details
      Detailed of information on all thin clients ('short','full','inventory','online'; Default:'short').

      .PARAMETER TCID
      ThinclientID to search for
      
      .EXAMPLE
      $WebSession = New-UMSRestApiCookie -Computername 'SRVUMS02' -Username rmdb
      Get-UMSAPIThinclient -Computername 'SRVUMS02' -WebSession $WebSession -Details 'full' | Out-GridView
      Gets detailed information on all online thin clients.

      .EXAMPLE
      $WebSession = New-UMSRestApiCookie -Computername 'SRVUMS02' -Username rmdb
      Get-UMSAPIThinclient -Computername 'SRVUMS02' -WebSession $WebSession -TCID 2433
      Gets short information on thin clients with TCID 2433.
      
      .EXAMPLE
      $WebSession = New-UMSRestApiCookie -Computername 'SRVUMS02' -Username rmdb
      2433 | Get-UMSAPIThinclient -Computername 'SRVUMS02' -WebSession $WebSession -Details 'shadow'
      Gets shadow-information on Thinclient with TCID 2433. 
  #>
  
  [cmdletbinding()]
  param
  ( 
    [Parameter( Mandatory)]
    [String]
    $Computername,

    [ValidateRange(0,49151)]
    [Int]
    $TCPPort = 8443,
   
    [ValidateSet(1,2,3)]
    [Int]
    $ApiVersion = 3,
    
    [Parameter(Mandatory)]
    $WebSession,
    
    [ValidateSet('short','full','online','shadow')]
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
        $SessionURL = 'https://{0}:{1}/umsapi/v{2}/thinclients{3}' -f $Computername, $TCPPort, $ApiVersion, $URLEnd
      }
      default
      {
        $SessionURL = 'https://{0}:{1}/umsapi/v{2}/thinclients/{3}{4}' -f $Computername, $TCPPort, $ApiVersion, $TCID, $URLEnd
      }

    }

    $ThinclientsJSONCollParams = @{
      Uri         = $SessionURL
      Headers     = @{}
      ContentType = 'application/json; charset=utf-8'
      Method      = 'Get'
      WebSession  = $WebSession
    }

    $ThinclientsJSONColl = Invoke-RestMethod @ThinclientsJSONCollParams
    $ThinclientsJSONColl

  }
  End
  {
  }
}

