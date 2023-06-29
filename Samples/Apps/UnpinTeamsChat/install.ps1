$registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$registryValueName = "TaskbarMn"
$registryValue = 0

try {
    if (!(Test-Path -Path $registryPath)) {
        New-Item -Path $registryPath -Force | Out-Null
    }
    
    Set-ItemProperty -Path $registryPath -Name $registryValueName -Value $registryValue -Type DWORD -ErrorAction Stop
    Write-Host "Der Chat wurde erfolgreich von der Taskleiste gelöst." -ForegroundColor Green
} catch {
    New-ItemProperty -Path $registryPath -Name $registryValueName -Value $registryValue -Type DWORD -Force | Out-Null
    Write-Host "Es ist ein Fehler aufgetreten. Der Chat konnte nicht von der Taskleiste gelöst werden." -ForegroundColor Red
}
