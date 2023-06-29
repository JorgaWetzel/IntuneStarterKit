$schtaskName = "Chocolatey Upgrade All"
$Version = "1"
$taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -like $schtaskName }
if($taskExists -and ($taskExists.Description -like "*V$Version*")) {
    Write-Host "Found it!"
    exit 0
} else {
    Write-Host "Not found!"
    exit 1}