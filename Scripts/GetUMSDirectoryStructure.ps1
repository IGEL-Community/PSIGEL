<#
      .Synopsis
      Gets Endpoint Directory Structure from API

      .DESCRIPTION
      Gets Endpoint Directory Structure from API. Expects 4 Tier-Directory Structure (e.g. Base / Organisation / Campus / Room)

      .PARAMETER Computername
      Computername of the UMS Server

      .PARAMETER TCPPort
      TCP Port (Default: 8443)

      .PARAMETER ApiVersion
      API Version to use (Default: 3)

      .Parameter FilePath
      Path to File (Default $env:TMP)

      .PARAMETER FileName
      Name of generated csv-file

      .Parameter WebSession
      Websession Cookie, if not specified (Default) credential are asked for and cookie gets created
  #>

Param
(
  [String]
  $Computername = 'igelrmserver.acme.org',

  [ValidateRange(0, 65535)]
  [Int]
  $TCPPort = 8443,

  [ValidateSet(3)]
  [Int]
  $ApiVersion = 3,

  [ValidateScript( {Test-Path -Path $_ -PathType Container})]
  [String]
  $FilePath = $env:TMP,

  [String]
  $Filename = 'UMSDirectories.csv',

  $WebSession = $false,

  $SecurityProtocol = 'Tls'
)

Switch ($WebSession)
{
  $false
  {
    $WebSession = New-UMSAPICookie -Computername $Computername
  }
}

$DirColl = Get-UMSEndpointDirectory -Computername $Computername -WebSession $WebSession
$Tier1Coll = $DirColl | Where-Object {
  $_.parentID -eq -1
}
$UMSDirectoryStructure = foreach ($Tier1 in $Tier1Coll)
{
  $Tier2Coll = $DirColl | Where-Object {
    $_.parentID -eq $Tier1.id
  }
  foreach ($Tier2 in $Tier2Coll)
  {
    $Tier3Coll = $DirColl | Where-Object {
      $_.parentID -eq $Tier2.id
    }
    foreach ($Tier3 in $Tier3Coll)
    {
      $Tier4Coll = $DirColl | Where-Object {
        $_.parentID -eq $Tier3.id
      }
      foreach ($Tier4 in $Tier4Coll)
      {
        $UMSDirectoriesProps = @{
          'Tier1Name' = $Tier1.name
          'Tier1Id'   = $Tier1.id
          'Tier2Name' = $Tier2.name
          'Tier2Id'   = $Tier2.id
          'Tier3Name' = $Tier3.name
          'Tier3Id'   = $Tier3.id
          'Tier4Name' = $Tier4.name
          'Tier4Id'   = $Tier4.id
        }
        New-Object -TypeName PSObject -Property $UMSDirectoriesProps
      }
    }
  }
}
$Null = $UMSDirectoryStructure = $UMSDirectoryStructure |
  Select-Object -Property Tier1Name, Tier2Name, Tier3Name, Tier4Name |
  Sort-Object -Property Tier1Name, Tier2Name, Tier3Name, Tier4Name |
  ConvertTo-Csv -Delimiter ';' -NoTypeInformation |
  ForEach-Object {
  $_ -replace "`"", ''
}
[IO.File]::WriteAllLines(('{0}\{1}' -f $FilePath, $Filename), $UMSDirectoryStructure)
