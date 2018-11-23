function Get-UMSThinclientDirectoryAssignment
{
  [cmdletbinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
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

    [Parameter(Mandatory, ValueFromPipeline)]
    [int]
    $DIRID
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
    
    $UriArray = @($Computername, $TCPPort, $ApiVersion, $DIRID)
    $Uri = 'https://{0}:{1}/umsapi/v{2}/directories/tcdirectories/{3}/assignments/profiles' -f $UriArray

    $Params = @{
      WebSession  = $WebSession
      Method      = 'Get'
      ContentType = 'application/json'
      Headers     = @{}
      Uri         = $Uri
    }
    Invoke-UMSRestMethodWebSession @Params
  }
  End
  {
  }
}