cd$teamsConfigPath = "$env:APPDATA\Microsoft\Teams\desktop-config.json"

if (Test-Path -Path $teamsConfigPath) {
    $teamsConfigContent = Get-Content -Path $teamsConfigPath -Raw -ErrorAction Stop

    if ($teamsConfigContent -match '"openAsHidden":\s*true') {
        Write-Host "Die Einstellung 'openAsHidden' ist korrekt konfiguriert."
        exit 0
    } else {
        Write-Host "Die Einstellung 'openAsHidden' ist nicht korrekt konfiguriert."
        exit 1
    }
} else {
    Write-Host "Fehler: Die Teams-Konfigurationsdatei wurde nicht gefunden."
    exit 1
}
