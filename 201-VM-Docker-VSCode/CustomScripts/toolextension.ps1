### Install Chrome, Git and VisualStudio Code from PoserShell Gallary 

#Install Script: download script
 Install-Script -Name install-git -Force -Scope AllUsers
 Install-Script -Name install-VSCode -Force -Scope AllUsers

 # Install Tools
Install-git
Install-VSCode

#Install-Chrome

$Path = $env:TEMP;
$Installer = "chrome_installer.exe";
Invoke-WebRequest "http://dl.google.com/chrome/install/375.126/chrome_installer.exe" -OutFile $Path\$Installer;
Start-Process -FilePath $Path\$Installer -Args "/silent /install" -Verb RunAs -Wait;
Remove-Item $Path\$Installer

#Restart Server
Restart-Computer  -ComputerName localhost -Force 