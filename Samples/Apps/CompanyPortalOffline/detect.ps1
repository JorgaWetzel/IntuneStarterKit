# Pfad zum gewünschten Paket
$packagePath = "C:\Program Files\WindowsApps\Microsoft.CompanyPortal_11.2.119.0_neutral_~_8wekyb3d8bbwe"

# Überprüfen, ob das Verzeichnis existiert
if (Test-Path $packagePath) {
    Write-Output "Das Paket ist installiert."
} else {
    Write-Output "Das Paket ist nicht installiert."
}
