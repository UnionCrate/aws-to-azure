
#Get-ExecutionPolicy
# Enable scripts to run on this system
Set-ExecutionPolicy unrestricted

# Install Powershell Get to facilitate installing packages from PowerShellGallery.com
Install-Module -Name PowerShellGet -Force

#Installation of Azure Active Directory Module
Install-Module -Name AzureAD -Force