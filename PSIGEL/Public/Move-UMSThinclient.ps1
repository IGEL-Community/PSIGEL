function Move-UMSThinclient
{
  [cmdletbinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
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

    [ValidateSet('Tls12', 'Tls11', 'Tls', 'Ssl3')]
    [String[]]
    $SecurityProtocol = 'Tls12',

    [Parameter(Mandatory)]
    $WebSession,

    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [int]
    $Id,

    [Parameter(Mandatory)]
    [int]
    $DDirId
  )

  Begin
  {
    $UriArray = @($Computername, $TCPPort, $ApiVersion)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/directories/tcdirectories' -f $UriArray)
  }
  Process
  {
    $Body = ConvertTo-Json @(
      @{
        id   = $Id
        type = "tc"
      }
    )
    $Params = @{
      WebSession       = $WebSession
      Uri              = ('{0}/{1}?operation=move' -f $BaseURL, $DDirId)
      Body             = $Body
      Method           = 'Put'
      ContentType      = 'application/json'
      Headers          = @{}
      SecurityProtocol = ($SecurityProtocol -join ',')
    }
    if ($PSCmdlet.ShouldProcess(('TCID: {0} to DDIRID: {1}' -f $Id, $DDirId)))
    {
      $Json = Invoke-UMSRestMethodWebSession @Params
    }
    $Result = foreach ($item in $Json)
    {
      $Properties = [ordered]@{
        'Id'      = [int]$item.id
        'Results' = [string]$item.results
      }
      New-Object psobject -Property $Properties
    }
    $Result
  }
  End
  {
  }
}