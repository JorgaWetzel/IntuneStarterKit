# Überprüfen, ob der Wert vorhanden ist
if ((Get-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name wallpaper).wallpaper -eq '$Env:Programfiles\oneICT\EndpointManager\Data\bg.jpg') {
    Write-Host "Der Wert ist vorhanden."
}
else {
    Write-Host "Der Wert ist nicht vorhanden."
    return 1
}