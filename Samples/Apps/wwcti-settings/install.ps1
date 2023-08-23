   
function Find-InTextFile {
    [CmdletBinding(DefaultParameterSetName = 'NewFile')]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({Test-Path -Path $_ -PathType 'Leaf'})]
        [string[]]$FilePath,
        [Parameter(Mandatory = $true)]
        [string]$Find,
        [Parameter()]
        [string]$Replace,
        [Parameter(ParameterSetName = 'NewFile')]
        [ValidateScript({ Test-Path -Path ($_ | Split-Path -Parent) -PathType 'Container' })]
        [string]$NewFilePath,
        [Parameter(ParameterSetName = 'NewFile')]
        [switch]$Force
    )
    begin {
        $Find = [regex]::Escape($Find)
    }
    process {
        try {
            foreach ($File in $FilePath) {
                if ($Replace) {
                    if ($NewFilePath) {
                        if ((Test-Path -Path $NewFilePath -PathType 'Leaf') -and $Force.IsPresent) {
                            Remove-Item -Path $NewFilePath -Force
                            (Get-Content $File) -replace $Find, $Replace | Add-Content -Path $NewFilePath -Force
                        } elseif ((Test-Path -Path $NewFilePath -PathType 'Leaf') -and !$Force.IsPresent) {
                            Write-Warning "The file at '$NewFilePath' already exists and the -Force param was not used"
                        } else {
                            (Get-Content $File) -replace $Find, $Replace | Add-Content -Path $NewFilePath -Force
                        }
                    } else {
                        (Get-Content $File) -replace $Find, $Replace | Add-Content -Path "$File.tmp" -Force
                        Remove-Item -Path $File
                        Move-Item -Path "$File.tmp" -Destination $File
                    }
                } else {
                    Select-String -Path $File -Pattern $Find
                }
            }
        } catch {
            Write-Error $_.Exception.Message
        }
    }
}

if (Get-Process cti -ErrorAction SilentlyContinue) {
    taskkill /f /im cti.exe
}


$path = "${env:USERPROFILE}\AppData\Local\CTI"
If(!(test-path $path))
{
New-Item -Path "${env:USERPROFILE}\AppData\Local\CTI" -ItemType Directory
}

$cticfg = @"
<?xml version="1.0" encoding="UTF-8"?>
<CONFIG Server="80.89.218.120" User="UserToChange" Password="PWToChange" mode="3" prefix1="0041" preventTLS="0" active_identity="1" numListViews="1" always48khz="1" onlyInternalLevels="0" doNotCloseAudio="0" playbackName="Lautsprecher (Jabra Link 380)" playbackName2="Lautsprecher (Jabra Link 380)" playbackDrv="WMME" playbackDrv2="WMME" captureName="Mikrofon (Jabra Link 380)" captureName2="Mikrofon (Jabra Link 380)" captureDrv="WMME" captureDrv2="WMME" ringName="Lautsprecher (Jabra Link 380)" ringName2="Lautsprecher (Jabra Link 380)" ringDrv="WMME" ringDrv2="WMME" ringInternalFile="C:\Program Files (x86)\cti\ringstd.wav" ringGroupFile="C:\Program Files (x86)\cti\ringstd.wav" ringDirectFile="C:\Program Files (x86)\cti\ringstd.wav" maxCalls="1" enableHID="1" enableHID2="1" enableNC="1" jabraRingerWorkaround="0" jabraPickupWorkaround="0" jabraMuteWorkaround="1" jabraMuteWorkaround2="0" echoCanceller="1" hkey1="CONTROL" hkey2="F12" hkey3="CONTROL+ALT" hkey4="F1" AutoStartTapi="0" AutoStartCallto="0" action_url="" action_url_accept="" compact_view="1" disableAutoUpdate="1" use_green_bullet="1" idle_timeout="0" detect_screen_lock="1" MainFormX="337" MainFormY="348" lv0w="250"/>
"@

$ctibak = @"
<?xml version="1.0" encoding="utf-8"?><CONFIG />
"@

$ctiv2 = @"
done
"@

$PathCFG = "${env:USERPROFILE}\AppData\Local\CTI\CTI.cfg"
[IO.File]::WriteAllLines($PathCFG, $cticfg)

$PathBAK = "${env:USERPROFILE}\AppData\Local\CTI\CTI.back"
[IO.File]::WriteAllLines($PathBAK, $ctibak)

$Pathv2 = "${env:USERPROFILE}\AppData\Local\CTI\CTI.v2"
[IO.File]::WriteAllLines($Pathv2, $ctiv2)

# Abrufen des aktuellen Benutzernamens
$email = cmd.exe /c whoami /upn
    
# Extrahiere den Benutzernamen aus der E-Mail-Adresse
$username = $email -replace '@saentisgastro.ch', ''

# Erstelle das Passwort aus dem ersten Buchstaben des Benutzernamens und der Position im Alphabet des Buchstabens nach dem Punkt
$first_letter = $username.Substring(0, 1).ToLower()
$position = [int][char]$first_letter - 96
# Extrahiere den Buchstaben nach dem Punkt (wenn vorhanden) oder den ersten Buchstaben nach dem "@"
$dot_position = $username.IndexOf('.')
if ($dot_position -ne -1) {
    $letter_after_dot = $username.Substring($dot_position + 1, 1).ToLower()
} else {
    $letter_after_dot = $username.Substring(0, 1).ToLower()
}
$letter_value = [int][char]$letter_after_dot - 96
$value = "$position$letter_value"
# Berechne die Quersumme
$checksum = ($value.ToCharArray() | ForEach-Object { [int]$_ - 48 } | Measure-Object -Sum).Sum
$password = "SGAS-$value$checksum"

write-Host "useranme ist: "$username
write-Host "PW ist: " $password

# Wenn der Benutzer in der Zuordnung enthalten ist, wenden Sie die Änderungen an
Find-InTextFile -FilePath "${env:USERPROFILE}\AppData\Local\CTI\CTI.cfg" -Find 'UserToChange' -Replace $username
Find-InTextFile -FilePath "${env:USERPROFILE}\AppData\Local\CTI\CTI.cfg" -Find 'Password="PWToChange"' -Replace ('Password="' + $password + '"')

