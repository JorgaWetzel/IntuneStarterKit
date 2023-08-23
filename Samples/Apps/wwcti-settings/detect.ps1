# Pfad zur Datei
$file = "${env:USERPROFILE}\AppData\Local\CTI\CTI.cfg"

# Prüfen, ob die Datei existiert
if (Test-Path $file) {
    # Die Datei existiert, prüfen, ob sie den gesuchten Text enthält
    $content = Get-Content $file
    if ($content -match 'CONFIG User="') {
        Write-Output "Die Datei $file wurde korrekt gesetzt"
        exit 0
    } else {
        Write-Output "Die Datei $file wurde nicht korrekt gesetzt"
        exit 1
    }
} else {
    # Die Datei existiert nicht
    Write-Output "Die Datei $file existiert nicht."
    exit 1
}
