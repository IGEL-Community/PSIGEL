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

    [Parameter(ValueFromPipeline, ParameterSetName = 'ID')]
    [Int]
    $DIRID
  )

  Begin
  {
    $UriArray = @($Computername, $TCPPort, $ApiVersion)
    $BaseURL = ('https://{0}:{1}/umsapi/v{2}/directories/profiledirectories/' -f $UriArray)
    if ($null -ne $Facets)
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
      'ID'
      {
        $Params.Add('Uri', ('{0}/{1}{2}' -f $BaseURL, $TCID, $FunctionString))
        $Json = Invoke-UMSRestMethodWebSession @Params
      }
    }
    $Result = foreach ($item in $Json)
    {
      $Properties = [ordered]@{
        'id'         = [int]$item.id
        'name'       = [string]$item.name
        'parentID'   = [int]$item.parentID
        'movedToBin' = [System.Convert]::ToBoolean($item.movedToBin)
        'objectType' = [string]$item.objectType
      }
      switch ($Facets)
      {
        'children'
        {
          $DirectoryChildren = foreach ($child in $item.DirectoryChildren)
          {
            $ChildProperties = [ordered]@{
              'objectType' = [string]$child.objectType
              'id'         = [int]$child.id
            }
            New-Object psobject -Property $Properties
          }
          $ChildProperties += [ordered]@{
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