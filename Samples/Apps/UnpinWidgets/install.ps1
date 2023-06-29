$registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$registryValueName = "TaskbarDa"
$registryValue = 0

try {
    if (!(Test-Path -Path $registryPath)) {
        New-Item -Path $registryPath -Force | Out-Null
    }
    
    Set-ItemProperty -Path $registryPath -Name $registryValueName -Value $registryValue -Type DWORD -ErrorAction Stop
    Write-Host "Widgets wurden erfolgreich von der Taskleiste gelöst." -ForegroundColor Green
} catch {
    New-ItemProperty -Path $registryPath -Name $registryValueName -Value $registryValue -Type DWORD -Force | Out-Null
    Write-Host "Es ist ein Fehler aufgetreten. Die Widgets konnten nicht von der Taskleiste gelöst werden." -ForegroundColor Red
}
