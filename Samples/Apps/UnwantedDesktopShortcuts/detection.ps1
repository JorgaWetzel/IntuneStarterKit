$Shortcuts2Remove = "Google Chrome.lnk", "VLC media player.lnk", "Adobe Acrobat.lnk", "Zoom.lnk", "Firefox.lnk", "PDFCreator.lnk", "TeamViewer.lnk", "Microsoft Edge.lnk"
$DesktopPath = "C:\Users\*\Desktop\*" # Public and User Desktop: "C:\Users\*\Desktop\*", for Public Desktop shortcuts only: "C:\Users\Public\Desktop" 
$ShortcutsOnClient = Get-ChildItem $DesktopPath
$ShortcutsUnwanted = $ShortcutsOnClient | Where-Object -FilterScript {$_.Name -in $Shortcuts2Remove }

if (!$ShortcutsUnwanted) {
	Write-Host "All good, no shortcuts found. "
	exit 0
}else{
	Write-Host "Unwanted shortcut detected."
	Exit 1
}
