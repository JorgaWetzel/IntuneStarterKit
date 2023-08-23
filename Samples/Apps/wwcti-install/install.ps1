# Download and install cti
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

# Zielverzeichnis
$destination = "C:\Program Files (x86)\cti\"
# Kopiere alle .wav Dateien aus dem aktuellen Verzeichnis ins Zielverzeichnis
Copy-Item -Path .\*.wav -Destination $destination

#Start-Sleep -Seconds 2
#Start-Process "C:\Program Files (x86)\cti\cti.exe"
#Start-Sleep -Seconds 4
#taskkill /f /im cti.exe

netsh advfirewall firewall add rule name="cti" dir=out action=allow program="C:\Program Files (x86)\cti\cti.exe" enable=yes

# start-process -FilePath "C:\Program Files\zander tools\RZUpdate.exe" -ArgumentList "wwphone"
# Download here https://wiki.wwcom.ch/display/WPW/Downloads


