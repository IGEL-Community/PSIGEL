function Get-UMSProfileDirectory
{
  [CmdletBinding(DefaultParameterSetName = 'All')]
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

    [ValidateSet('children')]
    [String]
    $Facets,

    [Parameter(ValueFromPipeline, ParameterSetName = 'Id')]
    [Int]
    $Id
  )

  Begin
  {
    $UriArray = @($Computername, $TCPPort, $ApiVersion)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/directories/profiledirectories/' -f $UriArray)
    if ($Facets)
    {
      $FunctionString = Get-UMSFunctionString -Facets $Facets
    }
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
    Switch ($PSCmdlet.ParameterSetName)
    {
      'All'
      {
        $Params.Add('Uri', ('{0}{1}' -f $BaseURL, $FunctionString))
        $Json = (Invoke-UMSRestMethodWebSession @Params).SyncRoot
      }
      'Id'
      {
        $Params.Add('Uri', ('{0}/{1}{2}' -f $BaseURL, $Id, $FunctionString))
        $Json = Invoke-UMSRestMethodWebSession @Params
      }
    }
    $Result = foreach ($item in $Json)
    {
      $Properties = [ordered]@{
        'Id'         = [int]$item.id
        'Name'       = [string]$item.name
        'ParentId'   = [int]$item.parentID
        'MovedToBin' = [System.Convert]::ToBoolean($item.movedToBin)
        'ObjectType' = [string]$item.objectType
      }
      switch ($Facets)
      {
        'children'
        {
          $DirectoryChildren = foreach ($child in $item.DirectoryChildren)
          {
            $ChildProperties = [ordered]@{
              'ObjectType' = [string]$child.objectType
              'Id'         = [int]$child.id
            }
            New-Object psobject -Property $ChildProperties
          }
          $Properties += [ordered]@{
            'DirectoryChildren' = $DirectoryChildren
          }
        }
      }
      New-Object psobject -Property $Properties
    }
    $Result
  }
  End
  {
  }
}