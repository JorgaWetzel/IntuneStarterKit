# Pfade zu den Dateien
$PathCFG = "${env:USERPROFILE}\AppData\Local\CTI\CTI.cfg"
$PathBAK = "${env:USERPROFILE}\AppData\Local\CTI\CTI.back"
$Pathv2 = "${env:USERPROFILE}\AppData\Local\CTI\CTI.v2"

# Jede Datei löschen, wenn sie existiert
foreach ($path in $PathCFG, $PathBAK, $Pathv2) {
    if (Test-Path $path) {
        Remove-Item $path -ErrorAction Stop
        Write-Output "Die Datei $path wurde gelöscht."
    } else {
        Write-Output "Die Datei $path existiert nicht und kann nicht gelöscht werden."
    }
}
