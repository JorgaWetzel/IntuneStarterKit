$PackageName = "HPImageAssistant"
$ProgramFiles = [Environment]::GetFolderPath([Environment+SpecialFolder]::ProgramFiles)
$Path_local = Join-Path $ProgramFiles "oneICT"
$LogPath = Join-Path $Path_local "Log"
$HPImageAssistantPath = Join-Path $ProgramFiles "HPImageAssistant"

Start-Transcript -Path (Join-Path $LogPath "$PackageName-install.log") -Force
$ErrorActionPreference = 'Stop'

try {
    Start-Process "hp-hpia-5.1.9.exe" -ArgumentList "/s /e /f `"$HPImageAssistantPath`"" -Wait
}
catch {
    Write-Host "_____________________________________________________________________"
    Write-Host "ERROR"
    Write-Host "$_"
    Write-Host "_____________________________________________________________________"
}

Stop-Transcript