function Update-UMSProfileName
{
  <#
      .Synopsis
      Updates a profile name.

      .DESCRIPTION
      Updates a profile name.

      .PARAMETER Computername
      Computername of the UMS Server
      
      .PARAMETER TCPPort
      TCP Port (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (2 or 3, Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER ProfileID
      ProfileID of the profile to update name
     
      .Parameter Name
      New Name of the profile
      
      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER' -Username rmdb
      Update-UMSProfileName -Computername $Computername -WebSession $WebSession -ProfileID 100 -Name 'NewProfileName'
      Updates profile name to 'NewProfileName'
      
      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER' -Username rmdb
      $UpdateUMSProfileNameParams = @{
          Computername  = 'UMSSERVER'
          WebSession    = $WebSession
          ProfileID     = 100
          Name          = 'NewProfileName'
        }
      Update-UMSProfileName @UpdateUMSProfileNameParams
      Updates profile name to 'NewProfileName'
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
    
    [Parameter(Mandatory, ValueFromPipeline)]
    [int]
    $ProfileID,
    
    [String]
    $Name
  )
	
  Begin
  {
  }
  Process
  {   
    
    $Body = [ordered]@{
        name = $Name
      } | ConvertTo-Json
        
    $SessionURL = 'https://{0}:{1}/umsapi/v{2}/profiles/{3}' -f $Computername, $TCPPort, $ApiVersion, $ProfileID

    $ThinclientsJSONCollParams = @{
      Uri         = $SessionURL
      Headers     = @{}
      Body        = '{0}' -f $Body
      ContentType = 'application/json'
      Method      = 'Put'
      WebSession  = $WebSession
    }

    $ThinclientsJSONColl = Invoke-RestMethod @ThinclientsJSONCollParams
    $ThinclientsJSONColl
  }
  End
  {
  }
}

