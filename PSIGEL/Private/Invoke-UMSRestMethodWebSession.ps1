function Invoke-UMSRestMethodWebSession
{
  <#
    .SYNOPSIS
    Invoke-RestMethod Wrapper for UMS API

    .DESCRIPTION
    Invoke-RestMethod Wrapper for UMS API

    .EXAMPLE
    Invoke-UMSRestMethodWebSession -WebSession $WebSession -SessionUrl $SessionURL -Method 'Get'

    .EXAMPLE
    Invoke-UMSRestMethodWebSession -WebSession $WebSession -SessionURL $SessionURL -Body -Method 'Get'

    .NOTES
     n.a.
    #>

  [CmdletBinding(DefaultParameterSetName = 'NoBody')]
  param (
    [Parameter(Mandatory)]
    $WebSession,

    [Parameter(Mandatory)]
    [string]
    $SessionURL,

    [Parameter(ParameterSetName = 'BodyWavy')]
    [string]
    $BodyWavy,

    [Parameter(ParameterSetName = 'BodySquareWavy')]
    [string]
    $BodySquareWavy,

    [Parameter(Mandatory)]
    [ValidateSet('Get', 'Post', 'Put', 'Delete')]
    [string]
    $Method
  )

  begin
  {
  }
  process
  {
    switch ($PSCmdlet.ParameterSetName)
    {
      BodyWavy
      {
        $Params = @{
          Uri         = $SessionURL
          Headers     = @{}
          Body        = '{0}' -f $Body
          ContentType = 'application/json'
          Method      = $Method
          WebSession  = $WebSession
        }
      }
      BodySquareWavy
      {
        $Params = @{
          Uri         = $SessionURL
          Headers     = @{}
          Body        = '[{0}]' -f $Body
          ContentType = 'application/json'
          Method      = $Method
          WebSession  = $WebSession
        }
      }
      NoBody
      {
        $Params = @{
          Uri         = $SessionURL
          Headers     = @{}
          ContentType = 'application/json'
          Method      = $Method
          WebSession  = $WebSession
        }
      }
    }
    Invoke-RestMethod @Params
  }
  end
  {
  }
}