#requires -Version 3.0
function Get-UMSFirmware
{
  <#
      .Synopsis
      Gets information on all firmwares known to the UMS.

      .DESCRIPTION
      Gets information on all firmwares known to the UMS.

      .PARAMETER Computername
      Computername of the UMS Server
      
      .PARAMETER TCPPort
      TCP Port (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (2 or 3, Default: 3)

      .Parameter WebSession
      Websession Cookie

      .PARAMETER FirmwareID
      ThinclientID to search for
      
      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER' -Username rmdb
      Get-UMSFirmware -Computername 'UMSSERVER' -WebSession $WebSession | Out-Gridview
      Gets information on all firmwares known to the UMS to Out-Gridview.

      .EXAMPLE
      $WebSession = New-UMSAPICookie -Computername 'UMSSERVER' -Username rmdb
      9, 7 | Get-UMSFirmware -Computername 'UMSSERVER' -WebSession $WebSession
      Gets information on firmwares with FirmwareIDs 9 and 7.

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
    $FirmwareID = 0
  )
	
  Begin
  {
  }
  Process
  {   
    Switch ($FirmwareID)
    {
      0
      {
        $SessionURL = 'https://{0}:{1}/umsapi/v{2}/firmwares' -f $Computername, $TCPPort, $ApiVersion
        $InvokeRestMethodParams = @{
          Uri         = $SessionURL
          Headers     = @{}
          ContentType = 'application/json; charset=utf-8'
          Method      = 'Get'
          WebSession  = $WebSession
        }
        (Invoke-RestMethod @InvokeRestMethodParams).FwResource
      }
      default
      {
        $SessionURL = 'https://{0}:{1}/umsapi/v{2}/firmwares/{3}' -f $Computername, $TCPPort, $ApiVersion, $FirmwareID
        $InvokeRestMethodParams = @{
          Uri         = $SessionURL
          Headers     = @{}
          ContentType = 'application/json; charset=utf-8'
          Method      = 'Get'
          WebSession  = $WebSession
        }
        Invoke-RestMethod @InvokeRestMethodParams
      }
    }
  }
  End
  {
  }
}

