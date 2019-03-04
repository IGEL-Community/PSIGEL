function Get-UMSThinclientDirectoryAssignment
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
    $Id
  )

  Begin
  {
    $UriArray = @($Computername, $TCPPort, $ApiVersion)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/directories/tcdirectories' -f $UriArray)
  }
  Process
  {
    $Params = @{
      WebSession       = $WebSession
      Uri              = ('{0}/{1}/assignments/profiles' -f $BaseURL, $Id)
      Method           = 'Get'
      ContentType      = 'application/json'
      Headers          = @{}
      SecurityProtocol = ($SecurityProtocol -join ',')
    }
    $APIObjectColl = Invoke-UMSRestMethodWebSession @Params
    $Result = foreach ($APIObject in $APIObjectColl)
    {
      $ProfileColl = foreach ($child in $APIObject)
      {
        $ProfileProperties = [ordered]@{
          'Id'                 = [int]$Id
          'ReceiverId'         = [int]$child.receiver.id
          'ReceiverType'       = [string]$child.receiver.type
          'AssigneeId'         = [int]$child.assignee.id
          'AssigneeType'       = [string]$child.assignee.type
          'AssignmentPosition' = [int]$child.assignmentPosition
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