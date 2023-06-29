$Shortcuts2Remove = "Google Chrome.lnk", "VLC media player.lnk", "Adobe Acrobat.lnk", "Zoom.lnk", "Firefox.lnk", "PDFCreator.lnk", "TeamViewer.lnk", "Microsoft Edge.lnk"
$DesktopPath = "C:\Users\*\Desktop\*" # Public and User Desktop: "C:\Users\*\Desktop\*", for Public Desktop shortcuts only: "C:\Users\Public\Desktop" 
$ShortcutsOnClient = Get-ChildItem $DesktopPath

try{
    $($ShortcutsOnClient | Where-Object -FilterScript {$_.Name -in $Shortcuts2Remove }) | Remove-Item -Force
    Write-Host "Unwanted shortcut(s) removed."
}catch{
    Write-Error "Error removing shortcut(s)"
}
