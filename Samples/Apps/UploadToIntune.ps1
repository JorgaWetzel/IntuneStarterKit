$OverWrite = $true

$currentUserProfile = $env:USERPROFILE
$modulePath = Join-Path -Path $currentUserProfile -ChildPath "oneICT AG\Technik - Deployment\_Intune\IntuneStarterKit\Github\IntuneStarterKit\Module\IntuneStarterKit"
Import-Module -Name $modulePath -Verbose -Force

Connect-ISK
Connect-MSIntuneGraph -TenantID "oneict.onmicrosoft.com"
Add-ISKApps -Path (Join-Path -Path (Get-Location) -ChildPath "_ChocoApps")
Add-ISKApps -Path "C:\Users\JorgaWetzel\oneICT AG\Technik - Deployment\_Intune\IntuneStarterKit\Github\IntuneStarterKit\Samples\Apps"
