$downloadUrl = "https://wwcom.ch/downloads/cti.msi"
$downloadPath = "C:\Temp\cti.msi"
$installArguments = "/qn /norestart"

# Datei herunterladen
Write-Host "Herunterladen der Datei von $downloadUrl ..."
Invoke-WebRequest -Uri $downloadUrl -OutFile $downloadPath

# MSI-Installation
taskkill /f /im cti.exe
Write-Host "Installiere cti.msi ..."
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$downloadPath`" $installArguments" -Wait

# Bereinigung
Write-Host "Bereinigung ..."
Remove-Item -Path $downloadPath
