
$ChocoName = "OneDrive"
C:\ProgramData\chocolatey\bin\choco.exe uninstall $ChocoName -y
Unregister-ScheduledTask -TaskName ("Update " + $ChocoName + " on startup") -Confirm:$false