function Add-ISKApps {
    <#
    .SYNOPSIS
        Connect to the MSGraph

    .DESCRIPTION
        Connect to the MSGraph
        
    .PARAMETER Path
        Path to the installwin(s), local or online

    .PARAMETER Publisher
        App publisher

    .PARAMETER DestinationPath
        Path where online files will be stored

    .PARAMETER AssignTo
        Assign configuration to group with specified ID

    .PARAMETER AppGroup
        If set, a install group will be added per app

    .PARAMETER AppGroupPrefix
        Prefix for the apps install group (if -AppGroup in in place)


    #>

    param (
        [parameter(Mandatory = $false, HelpMessage = "Path to the installwin(s), local or online")]
        [ValidateNotNullOrEmpty()]
        [string]$Path = "https://github.com/JorgaWetzel/IntuneStarterKit/tree/main/Samples/Apps",

        [parameter(Mandatory = $false, HelpMessage = "App publisher")]
        [ValidateNotNullOrEmpty()]
        [string]$Publisher = "oneICT",

        [parameter(Mandatory = $false, HelpMessage = "Path where online files will be stored")]
        [ValidateNotNullOrEmpty()]
        [string]$DestinationPath = "$env:temp\IntuneStarterKit\Apps\",

        [parameter(Mandatory = $false, HelpMessage = "Assign configuration to group with specified ID")]
        [ValidateNotNullOrEmpty()]
        [string]$AssignTo,

        [parameter(Mandatory = $false, HelpMessage = "If set, a install group will be added per app")]
        [ValidateNotNullOrEmpty()]
        [switch]$AppGroup, 

        [parameter(Mandatory = $false, HelpMessage = "Prefix for the apps install group (if -AppGroup in in place)")]
        [ValidateNotNullOrEmpty()]
        [string]$AppGroupPrefix = "APP-WIN-" 

    )


    try{

        if($Path -like "https://github.com/*"){
            Write-Verbose "Download files from GitHub: $Path"
            $Owner = $($Path.Replace("https://github.com/","")).Split("/")[0]
            $Repository = $($Path.Replace("https://github.com/$Owner/","")).Split("/")[0]
            $RepoPath = $($Path.Replace("https://github.com/$Owner/$Repository/tree/main/",""))

            Invoke-GitHubDownload -Owner $Owner -Repository $Repository -Path $RepoPath -DestinationPath $DestinationPath | Out-Null
            $PathLocal = $DestinationPath

        }else{
            if(Test-Path $Path){
                Write-Verbose "Found path: $Path"
                $PathLocal = $Path
            }else{
                Write-Error "Path not found: $Path"
                break
            }
        } 
        
        <# Get TenantID  #>
        Write-Verbose "Get Tenant ID"
        $uri = "https://graph.microsoft.com/v1.0/organization"
        $Method = "GET"
        $TenantID = (Invoke-MgGraphRequest -Method $Method -uri $uri).value.id
        
      
        
        # Create Acces Token for MSIntuneGraph
        Write-Verbose "Connect to MS Intune Enviroment via MsalToken"
        $Current_MgContext = Get-MgContext
        $Global:AccessToken = Get-MsalToken -ClientID $Current_MgContext.ClientId -TenantId $Current_MgContext.TenantId

        $Global:AuthenticationHeader = @{
                    "Content-Type" = "application/json"
                    "Authorization" = $AccessToken.CreateAuthorizationHeader()
                    "ExpiresOn" = $AccessToken.ExpiresOn.LocalDateTime
                }
        Write-Verbose "Token until: $($Global:AuthenticationHeader.ExpiresOn)"    
       
            
        $AllAppFolders = Get-ChildItem $PathLocal 
    
        foreach($AppFolder in $AllAppFolders){
            Write-Verbose "Processing App: $($AppFolder.Name)"
            
            # Read intunewin file
            $IntuneWinFile = (Get-ChildItem $AppFolder.FullName -Filter "*.intunewin").FullName
            #$IntuneWinFile = "install.intunewin"
    
            # Create requirement rule for all platforms and Windows 10 2004
            $RequirementRule = New-IntuneWin32AppRequirementRule -Architecture "x64" -MinimumSupportedWindowsRelease "2004"
    
            # Create PowerShell script detection rule
            $DetectionScriptFile = (Get-ChildItem $AppFolder.FullName -Filter "detect.ps1").FullName
            $DetectionRule = New-IntuneWin32AppDetectionRuleScript -ScriptFile $DetectionScriptFile -EnforceSignatureCheck $false -RunAs32Bit $false
            
            # install command
            $InstallCommandLine = "powershell.exe -ExecutionPolicy Bypass -File .\install.ps1"
            $UninstallCommandLine = "powershell.exe -ExecutionPolicy Bypass -File .\uninstall.ps1"

            # Read Parameters
            #$PathJson = "C:\Users\wksadmin\oneICT AG\Technik - Deployment\_N-Able\Intune\_GeneralApps\TeamViewer\TeamViewer.json"
            #$PathJson = (Get-ChildItem "$($AppFolder.FullName)\*" -Include "*.json" | Select-Object -First 1).FullName
            #$myJson = Get-Content -Raw -Path $PathJson | ConvertFrom-Json 
            #$myJson
            
            #$packageObj = get-content $PathJson | ConvertFrom-Json -Debug
            #@{Name = "ApplicationPublisherName";Expression = {$packageObj.Author}}

            # Read Parameters
            $PathParam = (Get-ChildItem "$($AppFolder.FullName)\*" -Include "Parameter.txt" | Select-Object -First 1).FullName

            if($PathParam){
                $values = Get-Content $PathParam | Out-String | ConvertFrom-StringData
                $values.Dependency
                $values.Description
                Write-Host "Add Dependency:" $values.Dependency -ForegroundColor Green
                Write-Host "Add Description:" $values.Description -ForegroundColor Green
            }else{
                Write-Host "Paramerter File not exist" -ForegroundColor Red
            }
            # check for png or jpg
            $Icon_path = (Get-ChildItem "$($AppFolder.FullName)\*" -Include "*.jpg", "*.png" | Select-Object -First 1).FullName
            if(!$Icon_path){
                $AppUpload = Add-IntuneWin32App -FilePath $IntuneWinFile -DisplayName $AppFolder.Name -Description $values.Description -Publisher $Publisher -InstallExperience "system" -RestartBehavior "suppress" -DetectionRule $DetectionRule -RequirementRule $RequirementRule -InstallCommandLine $InstallCommandLine -UninstallCommandLine $UninstallCommandLine
            }else{
                $Icon = New-IntuneWin32AppIcon -FilePath $Icon_path
                $AppUpload = Add-IntuneWin32App -FilePath $IntuneWinFile -DisplayName $AppFolder.Name -Description $values.Description -Publisher $Publisher -InstallExperience "system" -Icon $Icon -RestartBehavior "suppress" -DetectionRule $DetectionRule -RequirementRule $RequirementRule -InstallCommandLine $InstallCommandLine -UninstallCommandLine $UninstallCommandLine
            
            }
                       
            Write-Verbose $AppUpload
            # Add assignment for all users
            Add-IntuneWin32AppAssignmentAllUsers -ID $AppUpload.id -Intent "available" -Notification "showAll" -Verbose
            # Add assignment for all devices
            Add-IntuneWin32AppAssignmentAllDevices -ID $AppUpload.id -Intent "available" -Notification "showAll" -Verbose
                        
            $DependencyValue = $values.Dependency
            try{
                # Check dependency
                if($DependencyValue){
                    Write-Host "  Processing $DependencyValue to $AppFolder" -ForegroundColor Cyan
                    $UploadedApp = Get-IntuneWin32App | where {$_.DisplayName -eq $AppFolder} | select name, id
                    $DependendProgram = Get-IntuneWin32App | where {$_.DisplayName -eq $DependencyValue} | select name, id
                    $Dependency2 = New-IntuneWin32AppDependency -id $DependendProgram.id -DependencyType AutoInstall
                    $UploadProcess = Add-IntuneWin32AppDependency -id $AppUpload.id -Dependency $Dependency2
                    Write-Host "  Added dependency $DependencyValue to $AppFolder" -ForegroundColor Cyan
                }
            }catch{
                Write-Host "Error adding dependency for $AppFolder" -ForegroundColor Red
                $_
            }

            if($AppGroup){
                Write-Verbose "Assign App $($AppFolder.Name) to $AssignTo"
                $AppGrpName = "$AppGroupPrefix$($AppFolder.Name.replace(' ',''))"
                $AppGroupObj = New-MgGroup -DisplayName $AppGrpName -Description "Installation of win32 app $($AppFolder.Name)" -MailEnabled:$false -SecurityEnabled:$true -MailNickname $($AppFolder.Name.replace(' ',''))

                $AppAssigmentRequest = Add-IntuneWin32AppAssignmentGroup -Include -ID $AppUpload.id -GroupID $AppGroupObj.id -Intent "required" -Notification "showAll" 
                Write-Verbose $AppAssigmentRequest
                if($AssignTo){
                    New-MgGroupMember -GroupId $AppGroupObj.id -DirectoryObjectId $AssignTo
                }
            }elseif($AssignTo){
                $AppAssigmentRequest = Add-IntuneWin32AppAssignmentGroup -Include -ID $AppUpload.id -GroupID $AssignTo -Intent "required" -Notification "showAll"
                Write-Verbose $AppAssigmentRequest
            }

            Start-sleep -s 10
        }

        Write-Host "Apps imported: " -ForegroundColor Green
        $($AllAppFolders.Name)

    }catch{
        Write-Error $_
    }
    

    
}