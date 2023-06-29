$rootPath = Get-Location
$targetFile = "Parameter.txt"
$searchText = "Group="

# Funktion zum Überprüfen und Aktualisieren des Eintrags
function RemoveGroupFromParameterFile($filePath) {
    # Den Inhalt der Datei lesen
    $content = Get-Content -Path $filePath -Raw

    # Überprüfen, ob der Eintrag vorhanden ist
    if ($content -match $searchText) {
        # Eintrag entfernen
        $newContent = $content -replace "$searchText.*", ""

        # Den aktualisierten Inhalt in die Datei schreiben
        Set-Content -Path $filePath -Value $newContent
        Write-Host "Eintrag wurde aus der Datei '$filePath' entfernt."
    }
}

# Alle Unterordner durchsuchen
Get-ChildItem -Path $rootPath -Recurse -Directory | ForEach-Object {
    $filePath = Join-Path $_.FullName $targetFile

    # Überprüfen, ob die Parameterdatei existiert
    if (Test-Path -Path $filePath) {
        RemoveGroupFromParameterFile -filePath $filePath
    }
}
