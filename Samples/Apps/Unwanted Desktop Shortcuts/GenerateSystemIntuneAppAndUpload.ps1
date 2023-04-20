# Install-Module -Name "IntuneWin32App"


# Überprüfen, ob das Modul Microsoft.Graph.Intune installiert ist
if (-not (Get-Module -Name Microsoft.Graph.Intune -ListAvailable)) {
    # Wenn das Modul nicht gefunden wird, installieren Sie es
    Write-Host "Das Modul Microsoft.Graph.Intune wird installiert ..."
    Install-Module -Name Microsoft.Graph.Intune -Scope CurrentUser -Force
}

# Überprüfen, ob das Modul IntuneWin32App installiert ist
if (-not (Get-Module -Name IntuneWin32App -ListAvailable)) {
    # Wenn das Modul nicht gefunden wird, installieren Sie es
    Write-Host "Das Modul IntuneWin32App wird installiert ..."
    Install-Module -Name IntuneWin32App -Scope CurrentUser -Force
}

# Dateien, die überprüft werden sollen
$filesToCheck = @("Parameter.txt", "detect.ps1", "install.ps1", "uninstall.ps1")

# Prüfen, ob die angegebenen Dateien vorhanden sind
foreach ($file in $filesToCheck) {
    if (Test-Path $file) {
        Write-Host "$file gefunden."
    } else {
        Write-Host "$file nicht gefunden."
    }
}

# Prüfen, ob eine PNG- oder JPG-Datei vorhanden ist
$pngFiles = Get-ChildItem -Filter *.png
$jpgFiles = Get-ChildItem -Filter *.jpg

if (($pngFiles.Count -gt 0) -or ($jpgFiles.Count -gt 0)) {
    Write-Host "Eine PNG- oder JPG-Datei wurde gefunden."
} else {
    Write-Host "Es wurde keine PNG- oder JPG-Datei gefunden."
}

# Ordnername, der überprüft werden soll
$folderToCheck = "Expand"

# Prüfen, ob der angegebene Ordner vorhanden ist
if (Test-Path $folderToCheck) {
    # Falls vorhanden, den Ordner löschen
    Remove-Item -Recurse -Force $folderToCheck
} 

Connect-MSIntuneGraph -TenantID "eskimotextilag.onmicrosoft.com"

$currentFolder = Get-Item -Path ".\"
$currentPath = (Get-Item -Path ".\").FullName
$AppName = $currentFolder.Name
$MasterPath = Split-Path $currentPath -Parent
$SourceFolder = "$MasterPath\$AppName"
$SetupFile = "install.ps1"
$InstallCommandLine = "%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\install.ps1"
$UninstallCommandLine = "%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\uninstall.ps1"
$DetectionScriptFile  = "$currentFolder\detect.ps1"
$ImageFile = ForEach ($Ext in @("*.jpg", "*.bmp", "*.png")) { Get-ChildItem -Path (Get-Location) -Filter $Ext -File | ForEach-Object { Write-Output $_.FullName } }
$Icon = New-IntuneWin32AppIcon -FilePath $ImageFile
$Description = (Get-Content (Join-Path (Get-Location) "Parameter.txt") | Where-Object { $_.StartsWith("Description=") } | Select-Object -First 1).Substring("Description=".Length); Write-Output "Description: $Description"
$Publisher = "oneICT"
$IntuneWinFile = ForEach ($Ext in @("*.intunewin")) { Get-ChildItem -Path (Get-Location) -Filter $Ext -Recurse -File | ForEach-Object { Write-Output $_.FullName } }
$DetectionRule = New-IntuneWin32AppDetectionRuleScript -ScriptFile $DetectionScriptFile -EnforceSignatureCheck $false -RunAs32Bit $false
$RequirementRule = New-IntuneWin32AppRequirementRule -Architecture "All" -MinimumSupportedWindowsRelease "2004"  
$Dependency = (Get-Content (Join-Path (Get-Location) "Parameter.txt") | Where-Object { $_.StartsWith("Dependency=") } | Select-Object -First 1).Substring("Dependency=".Length); Write-Output "Dependency: $Dependency"


Remove-Item -Path $currentPath\*.intunewin
$Win32AppPackage = New-IntuneWin32AppPackage -SourceFolder $SourceFolder -SetupFile $SetupFile -OutputFolder $currentPath -Verbose -Confirm:$false

$AppUpload = $Win32App = Add-IntuneWin32App -FilePath $IntuneWinFile -DisplayName $AppName -Description $Description -Publisher $Publisher -InstallExperience "system" -Icon $Icon -RestartBehavior "suppress" -DetectionRule $DetectionRule -RequirementRule $RequirementRule -InstallCommandLine $InstallCommandLine -UninstallCommandLine $UninstallCommandLine -Verbose -CompanyPortalFeaturedApp $True
# Add assignment for all users
Add-IntuneWin32AppAssignmentAllUsers -ID $AppUpload.id -Intent "available" -Notification "showAll" -Verbose
# Add assignment for all devices
Add-IntuneWin32AppAssignmentAllDevices -ID $AppUpload.id -Intent "required" -Notification "showAll" -Verbose  <# Action when all if and elseif conditions are false #>

try{
    # Check dependency
    if($Dependency){
        Write-Host "  Processing $Dependency to $AppName" -ForegroundColor Cyan
        $UploadedApp = Get-IntuneWin32App | where {$_.DisplayName -eq $AppName} | select name, id
        $DependendProgram = Get-IntuneWin32App | where {$_.DisplayName -eq $Dependency} | select name, id
        $Dependency2 = New-IntuneWin32AppDependency -id $DependendProgram.id -DependencyType AutoInstall
        $UploadProcess = Add-IntuneWin32AppDependency -id $AppUpload.id -Dependency $Dependency2
        Write-Host "  Added dependency $Dependency to $AppName" -ForegroundColor Cyan
    }
}catch{
    Write-Host "Error adding dependency for $AppName" -ForegroundColor Red
    $_
}