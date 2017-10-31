
# Checking Hyper-V feature installation status
Write-Host "Checking Hyper-V feature installation status..."
$featureStatus  = Get-WindowsOptionalFeature -Online -FeatureName:Microsoft-Hyper-V
if ($featureStatus.Online -ne $true)
{
     # Install Hyper-V on Windows 10, system reboot will be require to complete this operation.
    Write-Host "Installing Hyper-V feature, reboot will require to complete this operation..."
    Enable-WindowsOptionalFeature -Online -FeatureName:Microsoft-Hyper-V -All  
}
Write-Host "Hyper-V feature is already installed..."
Write-Host "Setting up downoad URL"
$url ="https://download.docker.com/win/stable/Docker%20for%20Windows%20Installer.exe"
$output = '.\Docker for Windows Installer.exe'
Write-Host "Downloading Docker for Windows"
Invoke-WebRequest -Uri $url -OutFile $output
Write-Host "Starting Docker installation..."
& '.\Docker for Windows Installer.exe'
Write-Host " Docker installation Completed..."
docker --version