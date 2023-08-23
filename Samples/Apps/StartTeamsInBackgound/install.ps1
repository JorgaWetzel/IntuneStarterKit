$FilePath = "C:\Users\$env:Username\AppData\Local\Microsoft\Teams\Update.exe"
Start-Process -FilePath $FilePath

Start-Sleep -Seconds 10

# Ende des aktiven Teams-Prozesses
if (Get-Process Teams -ErrorAction SilentlyContinue) {
    Get-Process Teams | Stop-Process -Force
}

# "openAsHidden"-Option in der Teams-Konfigurationsdatei setzen
$teamsConfigPath = "$env:APPDATA\Microsoft\Teams\desktop-config.json"

if (Test-Path -Path $teamsConfigPath) {
    $teamsConfigContent = Get-Content -Path $teamsConfigPath -ErrorAction Stop
    $teamsConfigContent = $teamsConfigContent -replace '"openAsHidden":false', '"openAsHidden":true'
    $teamsConfigContent | Set-Content -Path $teamsConfigPath -ErrorAction Stop
}

# Teams im Hintergrund starten
$teamsExecutablePath = "$env:LOCALAPPDATA\Microsoft\Teams\Update.exe"

Start-Process -FilePath $teamsExecutablePath -ArgumentList '--processStart "Teams.exe" --process-start-args "--system-initiated"' -WindowStyle Hidden
