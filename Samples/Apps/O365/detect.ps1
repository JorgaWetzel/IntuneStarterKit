# Pfad zum Registrierungsschlüssel
$registryPath = "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\"

# Überprüfung, ob der Schlüssel existiert
if (Test-Path $registryPath) {
    Write-Output "Der Schlüssel $registryPath existiert."
    exit 0
} else {
    Write-Output "Der Schlüssel $registryPath existiert nicht."
    exit 1
}
