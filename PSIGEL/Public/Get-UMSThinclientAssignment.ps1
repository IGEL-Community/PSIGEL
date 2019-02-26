function Get-UMSThinclientAssignment
{
  [CmdletBinding()]
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
    $TCID
  )

  Begin
  {
    $UriArray = @($Computername, $TCPPort, $ApiVersion)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/thinclients' -f $UriArray)
  }
  Process
  {
    $Params = @{
      WebSession       = $WebSession
      Uri              = '{0}/{1}/assignments/profiles' -f $BaseURL, $TCID
      Method           = 'Get'
      ContentType      = 'application/json'
      Headers          = @{}
      SecurityProtocol = ($SecurityProtocol -join ',')
    }
    $Json = Invoke-UMSRestMethodWebSession @Params
    $Result = foreach ($item in $Json)
    {
      $ProfileColl = foreach ($child in $item)
      {
        $ProfileProperties = [ordered]@{
          'assigneeId'         = [int]$child.assignee.id
          'assigneeType'       = [string]$child.assignee.type
          'receiverId'         = [int]$child.receiver.id
          'receiverType'       = [string]$child.receiver.type
          'assignmentPosition' = [int]$child.assignmentPosition
        }
        New-Object psobject -Property $ProfileProperties
      }
      $ProfileColl
    }
    $Result
  }
  End
  {
  }
}

