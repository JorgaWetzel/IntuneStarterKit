$ProgramName = "7zip"
$Path_oneICT = "$Env:Programfiles\oneICT"
Start-Transcript -Path "$Path_oneICT\Log\uninstall\$PackageName-uninstall.log" -Force

C:\ProgramData\chocolatey\choco.exe uninstall $ProgramName -y

Stop-Transcript
