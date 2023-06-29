$PackageName = "Wallpaper"
$Version = 1

$Path_oneICT= "$Env:Programfiles\oneICT\EndpointManager"
Start-Transcript -Path "$Path_oneICT\Log\$PackageName-install.log" -Force

New-item -itemtype directory -force -path "$Path_oneICT\Data"

$BG_LocalImage = "$Path_oneICT\Data\bg.jpg"
Copy-item -path ".\Data\bg.jpg" -destination $BG_LocalImage -Force

# Wallpaper diese Zeile legt das Wallpaper fix
# .\Data\Set-Screen.ps1 -BackgroundSource $BG_LocalImage

# LockScreen
# .\Data\Set-Screen.ps1 -LockScreenSource $BG_LocalImage

########################################################################################
# Update the background of the desktop
########################################################################################

$BG_LocalImage = "$Env:Programfiles\oneICT\EndpointManager\Data\bg.jpg"
Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name wallpaper -value $BG_LocalImage
rundll32.exe user32.dll, UpdatePerUserSystemParameters 1, True


New-Item -Path "$Path_oneICT\Validation\$PackageName" -ItemType "file" -Force -Value $Version

Stop-Transcript
