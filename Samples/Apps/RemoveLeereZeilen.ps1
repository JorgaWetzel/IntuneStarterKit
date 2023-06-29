$currentPath = Get-Location

# Rekursiv alle Parameter.txt-Dateien durchsuchen
$files = Get-ChildItem -Path $currentPath -Filter "Parameter.txt" -Recurse -File

foreach ($file in $files) {
    $content = Get-Content $file.FullName | Where-Object { $_ -match '\S' }

    # Speichere den aktualisierten Inhalt zurück in die Datei
    $content | Set-Content $file.FullName
}
