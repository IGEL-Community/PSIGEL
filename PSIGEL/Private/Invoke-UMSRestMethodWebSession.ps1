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
          Body        = '{0}' -f $BodyWavy
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
          Body        = '[{0}]' -f $BodySquareWavy
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
    try
    {
      Invoke-RestMethod @Params -ErrorAction Stop
    }
    catch [System.Net.WebException]
    {
      switch ($($PSItem.Exception.Response.StatusCode.value__))
      {
        400
        {
          Write-Warning -Message ('Error executing IMI RestAPI request. SessionURL: {0} Method: {1}' -f $SessionURL, $Method)
        }
        401
        {
          Write-Warning -Message ('Error logging in, it seems as you have entered invalid credentials. SessionURL: {0} Method: {1}' -f $SessionURL, $Method)
        }
        403
        {
          Write-Warning -Message ('Error logging in, it seems as you have not subscripted this version of IMI. SessionURL: {0} Method: {1}' -f $SessionURL, $Method)
        }
        default
        {
          Write-Warning -Message ('Some error occured see HTTP status code for further details. SessionURL: {0} Method: {1}' -f $SessionURL, $Method)
        }
      }
    }
  }
  end
  {
  }
}