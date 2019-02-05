
#Get-ExecutionPolicy
# Enable scripts to run on this system
Set-ExecutionPolicy unrestricted

#Install Nuget Package provider
Install-PackageProvider -Name NuGet -Force

# Install Powershell Get to facilitate installing packages from PowerShellGallery.com
Install-Module -Name PowerShellGet -Force 


# Install Powershell Get to facilitate installing packages from PowerShellGallery.com
Install-Module -Name PowerShellGet -Force

#Installation of Azure Active Directory Module
Install-Module -Name AzureAD -Force

#Installation of Azure RM Module
Install-Module -Name AzureRM
