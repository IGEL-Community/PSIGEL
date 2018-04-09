function Get-UMSProfileAssignment
{
  <#
      .Synopsis
      Gets the thin clients the profile is assigned to.

      .DESCRIPTION
      Gets the thin clients the profile is assigned to.

      .PARAMETER Computername
      Computername of the UMS Server
      
      .PARAMETER TCPPort
      TCP Port (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (2 or 3, Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER ProfileID
      ProfileID to search for
      
      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER' -Username rmdb
      Get-UMSProfileAssignment -Computername 'UMSSERVER' -WebSession $WebSession -ProfileID 471
      Gets the thin clients the profile with ProfileID 471 is assigned to.
      
      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER' -Username rmdb
      471 | Get-UMSProfileAssignment -Computername 'UMSSERVER' -WebSession $WebSession
      Gets the thin clients the profile with ProfileID 471 is assigned to.
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
    $WebSession,

    [Parameter(ValueFromPipeline)]
    [int]
    $ProfileID = 0
  )
	
  Begin
  {
  }
  Process
  {   

    $SessionURL = 'https://{0}:{1}/umsapi/v{2}/profiles/{3}/assignments/thinclients' -f $Computername, $TCPPort, $ApiVersion, $ProfileID


    $ThinclientsJSONCollParams = @{
      Uri         = $SessionURL
      Headers     = @{}
      ContentType = 'application/json; charset=utf-8'
      Method      = 'Get'
      WebSession  = $WebSession
    }

    $HrefColl = (Invoke-RestMethod @ThinclientsJSONCollParams).links |
      Where-Object -Property rel -EQ 'receiver' | 
      Select-Object -Property href
      
    $TCIDColl = foreach ($Href in $HrefColl)
    {
      ([regex]::match(($Href.href),"\d{1,}\s*$")).Value
    }
    
    $TCIDColl

  }
  End
  {
  }
}

