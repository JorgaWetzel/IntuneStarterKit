$ProgramName = "WindowsUpdates"
$Version = 1

$Path_oneICT = "$Env:Programfiles\oneICT"
Start-Transcript -Path "$Path_oneICT\Log\$ProgramName-install.log" -Force

Write-Host "Setting script execution policy and to TLS1.2" -ForegroundColor Blue -BackgroundColor Yellow
        Set-ExecutionPolicy -ExecutionPolicy Bypass -Force -Scope Process
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

Install-Module WriteAscii -Force       
Install-Module PSWindowsUpdate -Force


Write-Ascii -InputObject "Installing available Windows and optional updates"
Write-Host "Installing PSWindowsUpdate Module. Installing ALL available Windows and Optional Updates, including any feature updates." -ForegroundColor Blue -BackgroundColor Yellow
Get-WindowsUpdate -Install -AcceptAll -IgnoreReboot | Select InstallResult, Title, Description | Format-Table

# Validation file
New-Item -Path "$Path_oneICT\Validation\$PackageName" -ItemType "file" -Force -Value $Version

Stop-Transcript