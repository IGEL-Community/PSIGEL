function Get-UMSStatus
{
  <#
      .Synopsis
      Gets diagnostic information about the UMS instance.

      .DESCRIPTION
      Gets diagnostic information about the UMS instance.

      .PARAMETER Computername
      Computername of the UMS Server
      
      .PARAMETER TCPPort
      TCP Port (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (2 or 3, Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER TCID
      ThinclientID to search for
      
      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER' -Username rmdb
      Get-UMSStatus -Computername 'UMSSERVER' -WebSession $WebSession

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
   
    [ValidateSet(2,3)]
    [Int]
    $ApiVersion = 3,
    
    [Parameter(Mandatory)]
    $WebSession
  )
	
  Begin
  {
  }
  Process
  {   

    $SessionURL = 'https://{0}:{1}/umsapi/v{2}/serverstatus' -f $Computername, $TCPPort, $ApiVersion


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

