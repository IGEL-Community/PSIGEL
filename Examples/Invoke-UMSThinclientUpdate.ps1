function Invoke-UMSThinclientUpdate
{
  <#
      .Synopsis
      Triggers Update on Shutdown on Thinclients

      .DESCRIPTION
      Gets thinclients from UMS-DB which have a lower firmware-version than their respective associated (direct or per directory)
      Update-Profile or Universal Firmware Update. Selects those which reported to UMS in specified time, given total and / or per
      Directory number AND online (Ping).
      Sets Comment to those Thinclients, which is criterium in a view which is assigned to a "update on shutdown" job. The execution of this
      job ist then triggerd.
      If Thinclients are Updated via Buddy-Update, there is a view for Buddies and a "WakeUp"-Job for this view, which is triggered to execute as well.

      .PARAMETER ServerInstance
      SQL ServerInstance  for the UMS-DB (e.g. 'SQLSERVER\RMDB')

      .PARAMETER UpdateViewID
      ID of the View for the Update-Comment

      .PARAMETER UpdateJobID
      ID of the "Update on shutdown" Job

      .PARAMETER WakeupViewID
      ID of the View for the Buddies to WakeUp

      .PARAMETER WakeupJobID
      ID of the "WakeUp" Job

      .PARAMETER NumberTotal
      Total number of Thinclients tu Update

      .PARAMETER NumberPerDirName
      Number of Thinclients to Update per Directory

      .PARAMETER Comment
      Comment to tag Thinclients for Update

      .PARAMETER JobDelay
      Minutes to delay the execution of the jobs after script execution.

      .EXAMPLE
      $Props = @{
      ServerInstance   = 'SQLSERVER\RMDB'
      UpdateViewID     = 513333
      UpdateJobID      = 513339
      WakeupViewID     = 513934
      WakeupJobID      = 515266
      NumberTotal      = 10
      NumberPerDirName = 2
      Comment          = 'Update'
      JobDelay         = 2
      }
      Invoke-UMSThinclientUpdate @Props

  #>

  param
  (
    [string]
    [Parameter(Mandatory)]
    $ServerInstance,

    [Parameter(Mandatory)]
    [int]
    $UpdateViewID,

    [Parameter(Mandatory)]
    [int]
    $UpdateJobID,

    [Parameter(Mandatory)]
    [int]
    $WakeupViewID,

    [Parameter(Mandatory)]
    [int]
    $WakeupJobID,

    [Parameter(Mandatory)]
    [int]
    $NumberTotal,

    [Parameter(Mandatory)]
    [int]
    $NumberPerDirName,

    [string]
    [Parameter(Mandatory)]
    $Comment,

    [int]
    $JobDelay = 2
  )

  [datetime]$LogTime = (Get-Date -Format 'yyyy-MM-dd 00:00:00')

  $TCIDColl =  (Get-UMSThinclientWithComment -ServerInstance $ServerInstance -Comment $Comment).TCID
  if ($TCIDColl)
  {
    Update-UMSThinclientComment -ServerInstance $ServerInstance -TCIDColl $TCIDColl
  }

  $UMSThinclientToUpdateParams = @{
    ServerInstance   = $ServerInstance
    NumberTotal      = $NumberTotal
    NumberPerDirName = $NumberPerDirName
    LogTime          = $LogTime
  }
  $UMSThinclientToUpdate = Get-UMSThinclientToUpdate @UMSThinclientToUpdateParams

  if ($UMSThinclientToUpdate)
  {
    $UMSThinclientToUpdate.TCID |
    Update-UMSThinclientComment -ServerInstance $ServerInstance -Comment $Comment

    $StartDate = (Get-Date -Date ((Get-Date).AddMinutes($JobDelay)) -Format 'yyyy-MM-ddTHH:mm:ss')

    $UpdateJobID, $WakeupJobID | Update-UMSJobStartDate -ServerInstance $ServerInstance -Startdate $StartDate
  }
}