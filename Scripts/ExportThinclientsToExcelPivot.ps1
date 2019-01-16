$UMSCredPath = 'C:\Credentials\UmsRmdb.cred'
$UMSUser = 'rmdb'
$UMSPassword = Get-Content $UMSCredPath | ConvertTo-SecureString
$RootCredPath = 'C:\Credentials\TCRoot.cred'
$RootCredential = (Import-Clixml -Path $RootCredPath)

$PSDefaultParameterValues = @{
  '*-UMS*:Credential'   = (New-Object System.Management.Automation.PsCredential($UMSUser, $UMSPassword))
  '*-UMS*:Computername' = 'srvums02.bfw.local'
}

$WebSession = New-UMSAPICookie

$PSDefaultParameterValues += @{
  '*-UMS*:WebSession' = $WebSession
}

$TCColl = Get-UMSThinclient -Details full
$TCColl | Group-Object -Property productId

$ExportExcelParams = @{
  Path              = 'C:\Temp\demo.xlsx'
  KillExcel         = $true
  WorksheetName     = 'Endpoints'
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
