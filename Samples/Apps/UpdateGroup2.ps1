$rootPath = "C:\Users\JorgaWetzel\oneICT AG\Technik - Deployment\_Intune\IntuneStarterKit\Github\IntuneStarterKit\Samples\Apps" # Ersetze dies durch den tatsächlichen Pfad zum Stammordner

# Rekursiv alle Parameter.txt-Dateien durchsuchen
$files = Get-ChildItem -Path $rootPath -Filter "Parameter.txt" -Recurse -File

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw

    # Ersetze den alten Gruppenabschnitt
    $content = $content -replace "Group=\r?\nGroup=\d+", "Group="

    # Speichere die aktualisierten Inhalte zurück in die Datei
    $content | Set-Content $file.FullName
}
