$ProgramName = "WindowsUpdates"
$Version = 1

$Path_oneICT = Get-Content -Path "$Env:Programfiles\oneICT\Validation\$PackageName"

if($Path_oneICT -eq $Version){
    Write-Host "Found it!"
    exit 0
} else {
    exit 1
}