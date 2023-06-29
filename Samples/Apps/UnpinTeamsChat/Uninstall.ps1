$registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$registryValueName = "TaskbarMn"
$originalRegistryValue = 1

try {
    if (!(Test-Path -Path $registryPath)) {
        New-Item -Path $registryPath -Force | Out-Null
    }

    Set-ItemProperty -Path $registryPath -Name $registryValueName -Value $originalRegistryValue -Type DWORD -ErrorAction Stop
    $actualValue = (Get-ItemProperty -Path $registryPath -Name $registryValueName).$registryValueName
    if ($actualValue -eq $originalRegistryValue) {
        Write-Host "Die Einstellung wurde erfolgreich zurückgesetzt." -ForegroundColor Green
        exit 0
    } else {
        Write-Host "Fehler: Die Einstellung konnte nicht korrekt zurückgesetzt werden." -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "Es ist ein Fehler aufgetreten. Die Einstellung konnte nicht zurückgesetzt werden." -ForegroundColor Red
    exit 1
}
