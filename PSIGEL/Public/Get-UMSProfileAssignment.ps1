function Get-UMSProfileAssignment
{
  [CmdletBinding(DefaultParameterSetName = 'Thinclient')]
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

    [Parameter(ValueFromPipeline, Mandatory)]
    [int]
    $ProfileID,

    [Parameter(ValueFromPipeline, ParameterSetName = 'Directory')]
    [switch]
    $Directory
  )
  Begin
  {
    $UriArray = @($Computername, $TCPPort, $ApiVersion)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/profiles' -f $UriArray)
  }
  Process
  {
    $Params = @{
      WebSession       = $WebSession
      Method           = 'Get'
      ContentType      = 'application/json'
      Headers          = @{}
      SecurityProtocol = ($SecurityProtocol -join ',')
    }

    Switch ($PsCmdlet.ParameterSetName)
    {
      'Thinclient'
      {
        $Params.Add('Uri', ('{0}/{1}/assignments/thinclients' -f $BaseURL, $ProfileID))
      }
      'Directory'
      {
        $Params.Add('Uri', ('{0}/{1}/assignments/tcdirectories' -f $BaseURL, $ProfileID))
      }
    }
    $Json = (Invoke-UMSRestMethodWebSession @Params).SyncRoot

    $Result = foreach ($item in $Json)
    {
      $Properties = [ordered]@{
        'assigneeId'   = [int]$item.assigneeId.id
        'assigneeType' = [string]$item.assigneeId.objectType
        'receiverId'   = [int]$item.receiverId.id
        'receiverType' = [string]$item.receiverId.objectType
      }
      New-Object psobject -Property $Properties
    }
    $Result
  }
  End
  {
  }
}