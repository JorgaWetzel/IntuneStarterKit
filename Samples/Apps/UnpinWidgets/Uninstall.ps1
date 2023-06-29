$registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$registryValueName = "TaskbarDa"

try {
    if (Test-Path -Path $registryPath) {
        Remove-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop
        Write-Host "Die Einstellung wurde erfolgreich deinstalliert." -ForegroundColor Green
        exit 0
    } else {
        Write-Host "Die Einstellung ist nicht installiert und muss nicht deinstalliert werden." -ForegroundColor Yellow
        exit 0
    }
} catch {
    Write-Host "Fehler beim Deinstallieren der Einstellung." -ForegroundColor Red
    exit 1
}
