$UMSCredPath = 'C:\Credentials\UmsRmdb.cred'
$UMSUser = 'rmdb'
$UMSPassword = Get-Content $UMSCredPath | ConvertTo-SecureString
#Id of the devicedirectory
[Int]$TcDirId = 999

$PSDefaultParameterValues = @{
  '*-UMS*:Credential'       = (New-Object System.Management.Automation.PsCredential($UMSUser, $UMSPassword))
  '*-UMS*:Computername'     = 'igelrmserver.acme.org'
  '*-UMS*:SecurityProtocol' = 'Tls12'
}

$WebSession = New-UMSAPICookie

$PSDefaultParameterValues += @{
  '*-UMS*:WebSession' = $WebSession
}

$DirColl = (Get-UMSDeviceDirectory -Id $TcDirId -Filter children).DirectoryChildren
$TCColl = $DirColl.where{$_.ObjectType -eq 'tc'} | Get-UMSDevice -Filter details

$ExportExcelParams = @{
  Path              = 'C:\Temp\demo.xlsx'
  KillExcel         = $true
  WorksheetName     = 'Devices'
  ClearSheet        = $true
  IncludePivotTable = $true
  PivotRows         = 'productId'
  PivotData         = @{
    "productId" = "Count"
  }
  IncludePivotChart = $true
  ChartType         = 'Pie'
  ShowPercent       = $false
  Show              = $true
}
$TCColl |
  Export-Excel @ExportExcelParams
