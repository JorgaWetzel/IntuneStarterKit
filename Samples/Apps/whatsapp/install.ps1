$ProgramName = "whatsapp"

$Path_oneICT = "$Env:Programfiles\oneICT"
Start-Transcript -Path "$Path_oneICT\Log\$ProgramName-install.log" -Force

$ChocoPrg_Version = [System.Version](C:\ProgramData\chocolatey\choco.exe --version)
if ($ChocoPrg_Version -gt [System.Version]"2.0") {
    $localprograms = C:\ProgramData\chocolatey\choco.exe list
} else {
    $localprograms = C:\ProgramData\chocolatey\choco.exe list -lo
}

if ($localprograms -like "*$ProgramName*") {
    C:\ProgramData\chocolatey\choco.exe upgrade $ProgramName -y
} else {
    C:\ProgramData\chocolatey\choco.exe install $ProgramName -y
}

Stop-Transcript
