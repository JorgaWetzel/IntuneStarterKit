function Connect-ISK {
    <#
    .SYNOPSIS
        Connect to the MgGraph with permissions needed by the IntuneStarterKit Module

    .DESCRIPTION
        Connect to the MgGraph with permissions needed by the IntuneStarterKit Module
        

    #>

    param (

    )


    try{
        
        # disconnect previous sessions
        if(Get-MgContext){Disconnect-MgGraph} 

        Connect-MgGraph -Scopes "User.Read.All","Group.ReadWrite.All","DeviceManagementServiceConfig.ReadWrite.All","DeviceManagementConfiguration.Read.All","DeviceManagementConfiguration.ReadWrite.All","DeviceManagementManagedDevices.PrivilegedOperations.All","DeviceManagementManagedDevices.ReadWrite.All","DeviceManagementRBAC.ReadWrite.All","DeviceManagementApps.ReadWrite.All","DeviceManagementConfiguration.ReadWrite.All","DeviceManagementServiceConfig.ReadWrite.All","Group.ReadWrite.All","Directory.Read.All","openid"
        # Connect-MgGraph -Scopes "DeviceManagementApps.Read.All, DeviceManagementApps.ReadWrite.All"
        Connect-MgGraph
        Connect-MSGraph -Quiet 

        # Create Acces Token for MSIntuneGraph
        Write-Verbose "Connect to MS Intune Enviroment via Connect-MSIntuneGraph"
        $Current_MgContext = Get-MgContext
        $Global:AccessToken = Get-MsalToken -ClientID $Current_MgContext.ClientId -TenantId $Current_MgContext.TenantId

        $Global:AuthenticationHeader = @{
                    "Content-Type" = "application/json"
                    "Authorization" = $AccessToken.CreateAuthorizationHeader()
                    "ExpiresOn" = $AccessToken.ExpiresOn.LocalDateTime
                }
        Write-Verbose $Global:AuthenticationHeader 
        #Connect-MSIntuneGraph -TenantID $(Get-MgContext).Tenantid | Out-Null
        
    }catch{
        Write-Error $_
    }


    try 
    {
      Connect-AzureAD
    }
    catch 
    {
      $exception = $_.Exception.Message
      exit;
    }

    

    
}