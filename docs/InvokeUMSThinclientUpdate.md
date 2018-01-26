# Invoke-UMSThinclientUpdate

The way to automatically update IGEL Linux Thinclients is to create a view and assigne it to a job which than starts the update on the Thinclients in the view on given time and date.
That is not a really flexible way to update, if you want to update all of your Thinclients, but not all at once. Either you have to edit your view to include a certain directory or criteria.

Most of our Thinclients are Linux-Devices, connected via WLAN and a large part of them use a Connectivity Foot with a B/G-Module. Since a concurrent update via WLAN on the same AccessPoint with several B/G-WLAN-Thinclients is very error prone (disconnects), I was looking for an other solution:

- non intrusive for the enduser
- restrictable number per directory (approximately 1 AccessPoint per Room / Directory)
- restrictable total number
- customizable job start time
- possibility to wake up firmware-update buddies

*Since we only just started using Windows-Devices and use less than 25 of them, those devices are not considered here.*

**Preparations**

* Determine Update-Comment
* Create View for all Thinclients with Update-Comment
![CommentUpdateView](/docs/images/CommentUpdateView.png)
* Create Job for the Update-Comment View to execute "Update on Shutdown"
![CommentUpdateJobShutDownOnUpdate](/docs/images/CommentUpdateJobShutDownOnUpdate.png)
* Create View for all Firmware-Update-Buddies (via profile  assigment)
![BuddyUpdateProfileView](/docs/images/BuddyUpdateProfileView.png)
* Create Job for the Update-Buddies to execute "WakeUp"
![BuddyUpdateProfileJob](/docs/images/BuddyUpdateProfileJob.png)

* Get the ID of Views and Jobs
![GetViewID](/docs/images/GetViewID.png)

**Procedure**

* Remove Update-Comment on all Thinclients
* Get all the Thinclients which are eligable for an update and are online
    * Parameterize number Thinclients to update in total
    * Parameterize number Thinclients to update per directories
    * Parameterize minutes to delay execution of the Jobs
* Set Update-Comment on these Thinclients
* Set Start Time for the "Update on Shutdown" and "WakeUp" Jobs

**Invoke-UMSThinclientUpdate for a total of 10 devices and 2 devices per directory**

      $Props = @{
          ServerInstance    = 'SQLSERVER\RMDB'
          UpdateViewID      = 513333
          UpdateJobID       = 513339
          WakeupViewID      = 513934
          WakeupJobID       = 515266
          NumberTotal       = 10
          NumberPerDirName  = 2
          Comment           = 'Update'
          JobDelay          = 2
        }
      Invoke-UMSThinclientUpdate @Props

**Scheduling**

You can use [Register-ScheduledJob](https://docs.microsoft.com/en-us/powershell/module/psscheduledjob/register-scheduledjob?view=powershell-5.1) to schedule this function.
