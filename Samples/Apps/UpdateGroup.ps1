$rootPath = Get-Location
$targetFile = "Parameter.txt"
$searchText = "Group="

# Funktion zum Überprüfen und Hinzufügen des Eintrags
function AddGroupToParameterFile($filePath) {
    # Den Inhalt der Datei lesen
    $content = Get-Content -Path $filePath -Raw

    # Überprüfen, ob der Eintrag bereits vorhanden ist
    if ($content -notmatch $searchText) {
        # Eintrag hinzufügen
        $newContent = "$content`n$searchText"

        # Den aktualisierten Inhalt in die Datei schreiben
        Set-Content -Path $filePath -Value $newContent
        Write-Host "Eintrag wurde zur Datei '$filePath' hinzugefügt."
    }
}

# Alle Unterordner durchsuchen
Get-ChildItem -Path $rootPath -Recurse -Directory | ForEach-Object {
    $filePath = Join-Path $_.FullName $targetFile

    # Überprüfen, ob die Parameterdatei existiert
    if (Test-Path -Path $filePath) {
        AddGroupToParameterFile -filePath $filePath
    }
}
