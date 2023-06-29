$File = "C:\ProgramData\Debloat\removebloat.ps1"
if (Test-Path $File) {
    write-output "detected, exiting"
    exit 0
}
else {
    exit 1
}