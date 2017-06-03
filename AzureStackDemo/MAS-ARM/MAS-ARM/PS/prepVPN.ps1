# Download Azure Stack tools from GitHub

# Change directory to the root directory 
cd C:\

# Download the tools archive
invoke-webrequest `
  https://github.com/Azure/AzureStack-Tools/archive/master.zip `
  -OutFile master.zip

# Expand the downloaded files
expand-archive master.zip `
  -DestinationPath . `
  -Force

# Change to the tools directory
cd C:\AzureStack-Tools-master

# After downloading the tools, navigate to the downloaded folder and import the Connect PowerShell module by using the following command: 
Import-Module .\Connect\AzureStack.Connect.psm1

# Configure VPN to Azure Stack PoC computer

#Change the IP address in the following command to match your Azure Stack host IP address
$hostIP = "185.58.223.113"

# Change the password in the following command to administrator password that is provided when deploying Azure Stack. 
$Password = ConvertTo-SecureString `
  "@zureSt@ck" `
  -AsPlainText `
  -Force

#Add host IP and certificate authority to the to trusted hosts
Set-Item wsman:\localhost\Client\TrustedHosts `
  -Value $hostIP `
  -Concatenate

Set-Item wsman:\localhost\Client\TrustedHosts `
  -Value mas-ca01.azurestack.local `
  -Concatenate

# Get host computer's NAT IP address
$natIp = "185.58.223.115" 

# Add VPN connection
Add-AzureStackVpnConnection `
  -ServerAddress $natIp `
  -Password $Password