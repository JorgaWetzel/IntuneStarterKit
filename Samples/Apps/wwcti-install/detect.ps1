if (Test-Path "C:\Program Files (x86)\cti\cti.exe") {
    Write-Host "Die Datei cti.exe existiert."
    exit 0
}else{exit 1}