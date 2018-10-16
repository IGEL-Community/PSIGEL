<#
      .Synopsis
      Removes multiple profiles assigned direct to a Thinclient, when only one is needed .

      .DESCRIPTION
      In UMS you can apply profiles directly, but you cannot dissociate them via administrative tasks.
      If you in this way apply profiles on a view which is defined by a directory, and then move Thinclients to another directory, it may happen,
      that those Thinclients do have more profiles applied than useful.
      In this script you can define profiles which are not meant to be applied parallel to one Thinclient and dissociate them all.
      Administrative Tasks can then apply the correct ones again.

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port API (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

  #>

param
(
  [String]
  $Computername = 'UMSSERVER',

  [ValidateRange(0, 65535)]
  [Int]
  $TCPPort = 8443,

  [ValidateSet(3)]
  [Int]
  $ApiVersion = 3
)

$WebSession = (New-UMSAPICookie -Computername $Computername)

$PSDefaultParameterValues = @{
  '*:Computername' = $Computername
  '*:WebSession'   = $WebSession
  '*:Confirm'      = $true
}

$UpdateProfileColl = @{
  H1_LX10 = @{
    ProfileId = 474
  }
  H1_LX4  = @{
    ProfileId = 470
  }
  H1_LX5  = @{
    ProfileId = 472
  }
  H1_OS10 = @{
    ProfileId = 473
  }
  H6_LX10 = @{
    ProfileId = 72345
  }
  H6_LX4  = @{
    ProfileId = 464
  }
  H6_LX5  = @{
    ProfileId = 471
  }
}

if ($UpdateProfileColl)
{
  $UpdateProfileColl = foreach ($UpdateProfile in $UpdateProfileColl.GetEnumerator())
  {
    $TCColl = $UpdateProfile.Value.Values |
      Get-UMSProfileAssignment |
      Where-Object {$_.type -eq 'tc'}
    foreach ($TC in $TCColl)
    {
      $Properties = @{
        ProfileId = $UpdateProfile.Value.Values
        TCID      = $TC.id
      }
      New-Object -TypeName psobject -Property $Properties
    }
  }
}

if ($UpdateProfileColl)
{
  $GroupedProfileColl = $UpdateProfileColl |
    Group-Object -Property TCID |
    Where-Object -Property Count -ge 2
  if ($GroupedProfileColl)
  {
    $ProfileTCColl = foreach ($GroupedProfile in $GroupedProfileColl)
    {
      $Properties = @{
        ProfileId = $GroupedProfile.Group.ProfileId
        TCID      = $GroupedProfile.Name
      }
      New-Object -TypeName psobject -Property $Properties
    }
  }
}

if ($ProfileTCColl)
{
  foreach ($ProfileTC in $ProfileTCColl)
  {
    foreach ($ProfileID in $ProfileTC.ProfileId )
    {
      $ProfileId |
        Remove-UMSProfileAssignment -TCID $ProfileTC.TCID -Confirm
      Write-Output ('Profile with ID {0} was removed from Thinclient with ID {1}' -f $ProfileId, $ProfileTC.TCID )
    }
  }
}
else
{
  Write-Output 'No Profile is assigned more than once to one ThinClient.'
}