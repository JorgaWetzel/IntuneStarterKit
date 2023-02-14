$ProgramName = "Office365Business"
$Path_oneICT = "$Env:Programfiles\oneICT"
Start-Transcript -Path "$Path_oneICT\Log\$ProgramName-install.log" -Force

$localprograms = C:\ProgramData\chocolatey\choco.exe list --localonly
if ($localprograms -like "*$ProgramName*"){
    C:\ProgramData\chocolatey\choco.exe upgrade $ProgramName -y --forcex86 --params "'/productid:O365ProPlusRetail /exclude:Groove Lync OneDrive OneNote  Publisher /language:de-DE /updates:FALSE /eula:FALSE'"
}else{
    C:\ProgramData\chocolatey\choco.exe install $ProgramName -y --forcex86 --params "'/productid:O365ProPlusRetail /exclude:Groove Lync OneDrive OneNote  Publisher /language:de-DE /updates:FALSE /eula:FALSE'"
}

Stop-Transcript