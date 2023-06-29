$ProgramPath = "C:\Program Files\HPImageAssistant\HPImageAssistant.exe"
$ProgramVersion_target = '5.1.8.221' 
$ProgramVersion_current = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($ProgramPath).FileVersion

if($ProgramVersion_current -eq $ProgramVersion_target){
    Write-Host "Found it!"
    exit 0
} else {
    Write-Host "Not found!"
    exit 1}