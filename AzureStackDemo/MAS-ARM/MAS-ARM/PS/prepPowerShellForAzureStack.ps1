# Returns a list of PowerShell module repositories that are registered for the current user.
Get-PSRepository

# Before installing the required version, make sure that you uninstall any existing Azure PowerShell modules.
Get-Module -ListAvailable | where-Object {$_.Name -like “Azure*”} | Uninstall-Module

# Install the AzureRM.Bootstrapper module.
Install-Module -Name AzureRm.BootStrapper

# Installs and imports the API Version Profile required by Azure Stack into the current PowerShell session.
Use-AzureRmProfile -Profile 2017-03-09-profile

# Install the Azure Stack-specific PowerShell modules such as AzureStackAdmin, and AzureStackStorage.
Install-Module -Name AzureStack -RequiredVersion 1.2.9

# To confirm the installation of AzureRM modules.
Get-Module -ListAvailable | where-Object {$_.Name -like “Azure*”}