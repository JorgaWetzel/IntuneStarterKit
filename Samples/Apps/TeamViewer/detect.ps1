$ProgramName = "TeamViewer"

try {
    $chocoExe = (Get-Command "choco.exe" -ErrorAction Stop  | Where-Object { $_.CommandType -eq "Application" }).Source
    Write-Verbose "Detected Chocolatey executable in: $chocoExe"
}
catch [System.Management.Automation.CommandNotFoundException] {
    $chocoExe = Join-Path $env:ALLUSERSPROFILE -ChildPath "chocolatey\bin\choco.exe"
}
$cmdReturn = Invoke-Expression "$chocoExe list --local-only $ProgramName"
if ($cmdReturn -eq "0 packages installed.")
{
    return
}
else
{
    "app detected"
    return 0
}