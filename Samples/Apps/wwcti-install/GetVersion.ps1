# Webseite mit den Versionsinformationen
$url = "https://wwcom.ch/downloads/versions.txt"

# Hole den Inhalt der Webseite
$response = Invoke-WebRequest -Uri $url

# Extrahiere den Text aus der Antwort
$content = $response.Content

# Finde die Zeile, die die Versionsnummer für cti_win_msi enthält
$versionLine = $content -split "`n" | Where-Object { $_ -match "cti_win_msi" }

# Extrahiere die Versionsnummer aus der Zeile
$version = $versionLine -split ";" | Select-Object -Index 3
