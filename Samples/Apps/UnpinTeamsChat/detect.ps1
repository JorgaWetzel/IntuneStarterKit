$registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$registryValueName = "TaskbarMn"
$registryValue = 0

try {
    if (!(Test-Path -Path $registryPath)) {
        New-Item -Path $registryPath -Force | Out-Null
    }

    Set-ItemProperty -Path $registryPath -Name $registryValueName -Value $registryValue -Type DWORD -ErrorAction Stop
    $actualValue = (Get-ItemProperty -Path $registryPath -Name $registryValueName).$registryValueName
    if ($actualValue -eq $registryValue) {
        Write-Host "Der Chat wurde erfolgreich von der Taskleiste gelöst." -ForegroundColor Green
        exit 0
    } else {
        Write-Host "Fehler: Die Einstellung wurde nicht korrekt angewendet." -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "Es ist ein Fehler aufgetreten. Der Chat konnte nicht von der Taskleiste gelöst werden." -ForegroundColor Red
    exit 1
}
