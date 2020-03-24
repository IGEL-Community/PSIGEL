function Get-UMSPropertyCast
{
  <#
  .EXAMPLE
  Get-UMSPropertyCast -APIObjectColl $APIObjectColl -CastedPropertyColl $CastedPropertyColl

  #>

  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    $APIObjectColl,

    [Parameter(Mandatory)]
    $PropertyColl
  )

  begin
  {
  }
  process
  {
    $Result = foreach ($APIObject in $APIObjectColl)
    {
      $CastedPropertyColl = @{ }
      foreach ($StringProperty in $PropertyColl.String)
      {
        $Name = $StringProperty
        if ($APIObject.($StringProperty))
        {
          $Value = [String]$APIObject.($StringProperty)
          $CastedPropertyColl.Add($Name, $Value)
        }
      }
      foreach ($IntProperty in $PropertyColl.Int)
      {
        $Name = $IntProperty
        if ($APIObject.($IntProperty))
        {
          $Value = [Int]$APIObject.($IntProperty)
          $CastedPropertyColl.Add($Name, $Value)
        }
      }
      foreach ($BoolProperty in $PropertyColl.Bool)
      {
        $Name = $BoolProperty
        $Value = [System.Convert]::ToBoolean($APIObject.($BoolProperty))
        $CastedPropertyColl.Add($Name, $Value)
      }
      foreach ($DatetimeProperty in $PropertyColl.Datetime)
      {
        $Name = $DatetimeProperty
        if ($APIObject.($DatetimeProperty))
        {
          $Value = [System.Convert]::ToDateTime($APIObject.($DatetimeProperty))
          $CastedPropertyColl.Add($Name, $Value)
        }
      }
      foreach ($ArrayProperty in $PropertyColl.Array)
      {
        $Name = $ArrayProperty
        if ($APIObject.($ArrayProperty))
        {
          $Value = [array]$APIObject.($ArrayProperty)
          $CastedPropertyColl.Add($Name, $Value)
        }
      }
      foreach ($XmlProperty in $PropertyColl.Xml)
      {
        $Name = $XmlProperty
        if ($APIObject.($XmlProperty))
        {
          $Value = [xml]$APIObject.($XmlProperty)
          $CastedPropertyColl.Add($Name, $Value)
        }
      }
      foreach ($ObjectProperty in $PropertyColl.Object)
      {
        $Name = $ObjectProperty
        if ($APIObject.($ObjectProperty))
        {
          $Value = [pscustomobject]$APIObject.($ObjectProperty)
          $CastedPropertyColl.Add($Name, $Value)
        }
      }
      New-Object psobject -Property $CastedPropertyColl
    }
    $Result
  }
  end
  {
  }
}