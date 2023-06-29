$ProgramName = "whatsapp"

$ChocoPrg_Version = [System.Version](C:\ProgramData\chocolatey\choco.exe --version)
if ($ChocoPrg_Version -gt [System.Version]"2.0") {
    $ChocoPrg_Existing = C:\ProgramData\chocolatey\choco.exe list
} else {
    $ChocoPrg_Existing = C:\ProgramData\chocolatey\choco.exe list -lo
}

if ($ChocoPrg_Existing -like "*$ProgramName*") {
    Write-Host "Found it!"
    exit 0
} else {
    exit 1
}
