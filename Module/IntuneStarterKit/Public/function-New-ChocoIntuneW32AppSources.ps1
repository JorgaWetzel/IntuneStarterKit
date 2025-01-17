function New-ChocoIntuneW32AppSources {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline,Position=0)]
        [ValidateScript({Test-path $_})]
        [String]$JsonFile,

        [Parameter(Mandatory=$false)]
        [ValidateScript({Test-Path $_})]
        [String]$PackagePath=$env:TEMP
    )

    process {
        $jsonFullName = (get-item $JsonFile).FUllName
        $packageObj = get-content $jsonFullName | ConvertFrom-Json -ErrorAction Stop
        $pkgFolder = New-Item (Join-Path $PackagePath -ChildPath $packageObj.PackageName) -ItemType DIrectory -Force
        $imageFilePath = Get-ChocoImage -ImageUrl $packageObj.ImageUrl -DownloadLocation $pkgFolder
        $installCmd = "C:\ProgramData\chocolatey\bin\choco.exe install " + $packageObj.PackageName + " -y"
        $uninstallCmd = "C:\ProgramData\chocolatey\bin\choco.exe uninstall " + $packageObj.PackageName + " -y"
        $detectCmd = @"
try {
    `$chocoExe = (Get-Command "choco.exe" -ErrorAction Stop  | Where-Object { `$_.CommandType -eq "Application" }).Source
    Write-Verbose "Detected Chocolatey executable in: `$chocoExe"
}
catch [System.Management.Automation.CommandNotFoundException] {
    `$chocoExe = Join-Path `$env:ALLUSERSPROFILE -ChildPath "chocolatey\bin\choco.exe"
}
`$cmdReturn = Invoke-Expression "`$chocoExe list --local-only $($packageObj.PackageName)"
if (`$cmdReturn -eq "0 packages installed.")
{
    return
}
else
{
    "app detected"
    return 0
}
"@

        #$installCmd | Out-File -FilePath (Join-Path $pkgFolder.FullName -ChildPath ($packageObj.PackageName + "_install.cmd")) -Encoding utf8NoBOM
        [System.IO.File]::WriteAllLines((Join-Path $pkgFolder.FullName -ChildPath ($packageObj.PackageName + "_install.cmd")),$installCmd)
        #$uninstallCmd |Out-File -FilePath (Join-Path $pkgFolder.FullName -ChildPath ($packageObj.PackageName + "_uninstall.cmd")) -Encoding utf8NoBOM
        [System.IO.File]::WriteAllLines((Join-Path $pkgFolder.FullName -ChildPath ($packageObj.PackageName + "_uninstall.cmd")),$uninstallCmd)
        #$detectCmd | Out-File -FilePath (Join-Path $pkgFolder.FullName -ChildPath ($packageObj.PackageName + "_detect.ps1"))
        [System.IO.File]::WriteAllLines((Join-Path $pkgFolder.FullName -ChildPath ($packageObj.PackageName + "_detect.ps1")),$detectCmd)
        #$imageFilePath = Get-ChocoImage -ImageUrl $packageObj.ImageUrl -DownloadLocation $pkgFolder

        $returnObj = 1 | Select-Object @{Name = "ApplicationDisplayName";Expression = {$packageObj.PackageName}},
                                        @{Name = "InstallCommandline";Expression = {$installCmd}},
                                        @{Name = "UninstallCommandline";Expression = {$uninstallCmd}},
                                        @{Name = "DetectionScriptPath";Expression = {Join-Path $pkgFolder.FullName -ChildPath ($packageObj.PackageName + "_detect.ps1")}},
                                        @{Name = "IconFilePath";Expression = {$imageFilePath}}
        return $returnObj
    }
}