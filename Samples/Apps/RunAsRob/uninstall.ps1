$ProgramName = "RunAsRob"

$Path_oneICT = "$Env:Programfiles\_oneIT"
Start-Transcript -Path "$Path_oneICT\uninstall\$PackageName-uninstall.log" -Force

C:\ProgramData\chocolatey\choco.exe uninstall $ProgramName -y

Stop-Transcript
