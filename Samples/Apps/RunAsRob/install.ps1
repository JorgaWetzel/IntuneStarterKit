﻿$ProgramName = "RunAsRob"
$Path_oneICT = "$Env:Programfiles\oneICT"
Start-Transcript -Path "$Path_oneICT\Log\$ProgramName-install.log" -Force

$localprograms = C:\ProgramData\chocolatey\choco.exe list --localonly
if ($localprograms -like "*$ProgramName*"){
    C:\ProgramData\chocolatey\choco.exe upgrade $ProgramName -y -source=oneICT
}else{
    C:\ProgramData\chocolatey\choco.exe install $ProgramName -y -source=oneICT
}

Stop-Transcript
