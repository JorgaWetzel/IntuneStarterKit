$PackageName = "WindowsPackageManager"
$Path_local = "$Env:Programfiles\oneICT"
Start-Transcript -Path "$Path_local\Log\uninstall\$PackageName-uninstall.log" -Force

Remove-AppPackage -Package "Microsoft.DesktopAppInstaller"

Stop-Transcript
