<#############################################################
 #                                                           #
 # DeployTemplate.ps1										 #
 #                                                           #
 #############################################################>

<#
 .Synopsis
	The script creates a new resource group in Azure Stack subscription and deploys resources based on template file and parameters file.

 .Requirements
	Azure PowerShell modules must be installed in order to run the script (https://www.microsoft.com/web/handlers/webpi.ashx/getinstaller/WindowsAzurePowershellGet.3f.3f.3fnew.appids).
 .Parameter ResourceGroupLocation
	Sets Azure region for the deployment. Default region is 'westeurope'.
 .Parameter DeployIndex
	Sets a number for the deployment iteration.
 .Parameter ResourceGroupPrefix
	Used to form resource group name and deployment name.  
 .Parameter AzureUserName
	Azure Active Directory tenant user name. This account is used to deploy all resources and should have necessary permissions. 
 .Parameter AzureUserPassword
	Azure Active Directory tenant password. 

.Example
     If no parameters are provided, default values are used.

     .\DeployTemplate.ps1 

.Example
     This example creates 'Open-RG02' resource group in West Europe region and starts deployment with the name 'Open-RG-Dep02'.

     .\DeployTemplate.ps1 -ResourceGroupLocation 'westeurope' -DeployIndex '02' -ResourceGroupPrefix 'Open-RG' -AzureUserName 'admin@mytenant.onmicrosoft.com' -AzureUserPassword 'P@ssw0rd!@#$%' 
#>


Param(
	[string] $ResourceGroupLocation = "local",
	[string] $DeployIndex = "04",
	[string] $ResourceGroupPrefix = "MAS-RG",
	[string] $AzureUserName = "tenant04@mas201706.onmicrosoft.com",
	[string] $AzureUserPassword = "@zureSt@ck"
)

# Change to the tools directory
cd C:\AzureStack-Tools-master

# After downloading the tools, navigate to the downloaded folder and import the Connect PowerShell module by using the following command: 
Import-Module .\Connect\AzureStack.Connect.psm1


# Use this command to access the user portal.
Add-AzureStackAzureRmEnvironment `
  -Name "AzureStackUser" `
  -ArmEndpoint "https://management.local.azurestack.external"

# Use this command to get the GUID value in the user's environment. 
$TenantID = Get-DirectoryTenantID `
  -AADTenantName "mas201706.onmicrosoft.com" `
  -EnvironmentName AzureStackUser

# Prepare credentials and login to Azure subscription. 
$AadPass = ConvertTo-SecureString $AzureUserPassword -AsPlainText -Force
$AadCred = New-Object System.Management.Automation.PSCredential ($AzureUserName, $Aadpass)

# Use this command to sign-in to the user portal.
Login-AzureRmAccount `
  -EnvironmentName "AzureStackUser" `
  -TenantId $TenantID `
  -Credential $AadCred

# Prepare environment variables.  
$ResourceGroupName = $ResourceGroupPrefix + $DeployIndex
$DeploymentName = $ResourceGroupPrefix + "-Dep" + $DeployIndex
$TemplateUri = "C:\Users\Darya\Desktop\DevCon201706-master\DevCon201706-master\MAS-ARM\MAS-ARM\azure04.json"
$TemplateParameterUri = "C:\Users\Darya\Desktop\DevCon201706-master\DevCon201706-master\MAS-ARM\MAS-ARM\azure04.parameters.json"
$TemplateFile = "C:\Users\Darya\Desktop\DevCon201706-master\DevCon201706-master\MAS-ARM\MAS-ARM\azure04.json"
$TemplateParametersFile = "C:\Users\Darya\Desktop\DevCon201706-master\DevCon201706-master\MAS-ARM\MAS-ARM\azure04.parameters.json"

# Create a new resource group in given region.  
New-AzureRmResourceGroup -Name $ResourceGroupName -Location $ResourceGroupLocation -Verbose -Force

# Start a new deployment in created resource group using local files.
New-AzureRmResourceGroupDeployment -Name $DeploymentName `
                                       -ResourceGroupName $ResourceGroupName `
                                       -TemplateFile $TemplateFile `
                                       -TemplateParameterFile $TemplateParametersFile `
                                       -Verbose
#