# Ende des aktiven Teams-Prozesses
if (Get-Process Teams -ErrorAction SilentlyContinue) {
    Get-Process Teams | Stop-Process -Force
}

# "openAsHidden"-Option in der Teams-Konfigurationsdatei zurücksetzen
$teamsConfigPath = "$env:APPDATA\Microsoft\Teams\desktop-config.json"

if (Test-Path -Path $teamsConfigPath) {
    $teamsConfigContent = Get-Content -Path $teamsConfigPath -ErrorAction Stop
    $teamsConfigContent = $teamsConfigContent -replace '"openAsHidden":true', '"openAsHidden":false'
    $teamsConfigContent | Set-Content -Path $teamsConfigPath -ErrorAction Stop
}

# Teams starten
$teamsExecutablePath = "$env:LOCALAPPDATA\Microsoft\Teams\Update.exe"

Start-Process -FilePath $teamsExecutablePath -ArgumentList '--processStart "Teams.exe" --process-start-args "--system-initiated"' -WindowStyle Normal -NoNewWindow
