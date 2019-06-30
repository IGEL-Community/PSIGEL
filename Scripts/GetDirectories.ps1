$UMSCredPath = 'C:\Credentials\UmsRmdb.cred'

$PSDefaultParameterValues = @{
  'New-UMSAPICookie:Credential' = Import-Clixml -Path $UMSCredPath
  '*-UMS*:Computername'         = 'igelrmserver'
}
$PSDefaultParameterValues += @{
  '*-UMS*:WebSession' = (New-UMSAPICookie)
}

#$DeviceColl = Get-UMSDevice
$DeviceDirectoryColl = Get-UMSDeviceDirectory
$StartDirectoryColl = ($DeviceDirectoryColl).where{@(1917) -contains $_.Id}

function Get-Coll
{
  param (
    $id
  )

  $Coll = @()

  $Coll += ($DeviceDirectoryColl).where{$_.Id -eq $id}

  $ChildDirColl = ($DeviceDirectoryColl).where{$_.ParentId -eq $id}

  foreach ($ChildDir in $ChildDirColl)
  {
    $childColl = Get-Coll -id $ChildDir.Id
    $Coll += $childColl
  }
  $Coll
}

$Result = foreach ($StartDirectory in $StartDirectoryColl)
{
  Get-Coll -id $StartDirectory.Id
}

$Result
