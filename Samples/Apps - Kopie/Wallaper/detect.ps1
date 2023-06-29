# Überprüfen, ob der Wert vorhanden ist
if ((Get-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name wallpaper).wallpaper -eq 'C:\Program Files\oneICT\EndpointManager\Data\bg.jpg') {
    Write-Host "Der Wert ist vorhanden."
    exit 0
}
else {
    Write-Host "Der Wert ist nicht vorhanden."
    exit 1
}