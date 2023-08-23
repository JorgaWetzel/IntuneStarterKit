$ProgramName = "WindowsUpdates"
$Path_oneICT = "$Env:Programfiles\oneICT"

Write-Host "Restoring script execution policy and TLS settings" -ForegroundColor Blue -BackgroundColor Yellow
Set-ExecutionPolicy -ExecutionPolicy Restricted -Force -Scope Process
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Ssl3 -bor [System.Net.SecurityProtocolType]::Tls -bor [System.Net.SecurityProtocolType]::Tls11 -bor [System.Net.SecurityProtocolType]::Tls12

Write-Host "Uninstalling PSWindowsUpdate Module" -ForegroundColor Blue -BackgroundColor Yellow
Uninstall-Module -Name PSWindowsUpdate -Force

Write-Host "Removing log and validation files" -ForegroundColor Blue -BackgroundColor Yellow
Remove-Item -Path "$Path_oneICT\Log\$ProgramName-install.log" -Force
Remove-Item -Path "$Path_oneICT\Validation\$ProgramName" -Force

Write-Host "Deinstallation abgeschlossen." -ForegroundColor Green
s