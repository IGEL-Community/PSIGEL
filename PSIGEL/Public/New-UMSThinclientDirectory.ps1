function New-UMSThinclientDirectory
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

    [ValidateSet('Tls12', 'Tls11', 'Tls', 'Ssl3')]
    [String[]]
    $SecurityProtocol = 'Tls12',

    [Parameter(Mandatory)]
    $WebSession,

    [Parameter(Mandatory, ValueFromPipeline)]
    [String]
    $Name
  )

  Begin
  {
    $UriArray = @($Computername, $TCPPort, $ApiVersion)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/directories/tcdirectories' -f $UriArray)
  }
  Process
  {
    $Body = ConvertTo-Json @{
      name = $Name
    }
    $Params = @{
      WebSession       = $WebSession
      Uri              = $Uri
      Body             = $Body
      Method           = 'Put'
      ContentType      = 'application/json'
      Headers          = @{}
      SecurityProtocol = ($SecurityProtocol -join ',')
    }
    if ($PSCmdlet.ShouldProcess('Name: {0}' -f $Name))
    {
      $Json = Invoke-UMSRestMethodWebSession @Params
    }
    $Result = foreach ($item in $Json)
    {
      $Properties = [ordered]@{
        'Message' = [string]$item.message
        'Id'      = [int]$item.id
        'Name'    = [string]$item.name
      }
      New-Object psobject -Property $Properties
    }
    $Result
  }
  End
  {
  }
}