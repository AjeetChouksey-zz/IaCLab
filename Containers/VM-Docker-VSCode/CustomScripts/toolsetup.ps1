$Path = $env:TEMP;

 $Installer = "chrome_installer.exe";
  Invoke-WebRequest "http://dl.google.com/chrome/install/375.126/chrome_installer.exe" -OutFile $Path\$Installer; 
  Start-Process -FilePath $Path\$Installer -Args "/silent /install" -Verb RunAs -Wait;
   Remove-Item $Path\$Installer

  $GITInstaller = "Git-2.15.1.2-64-bit.exe";
  Invoke-WebRequest "https://github.com/git-for-windows/git/releases/download/v2.15.1.windows.2/Git-2.15.1.2-64-bit.exe" -OutFile $Path\$GITInstaller; 
  Start-Process -FilePath $Path\$GITInstaller -Args "/silent /install" -Verb RunAs -Wait; 
  Remove-Item $Path\$GITInstaller

  $VSInstaller = "VSCodeSetup-x64-1.19.1.exe";
  Invoke-WebRequest "https://go.microsoft.com/fwlink/?Linkid=852157" -OutFile $Path\$VSInstaller; 
  Start-Process -FilePath $Path\$VSInstaller -Args "/silent /install" -Verb RunAs -Wait; 
  Remove-Item $Path\$VSInstaller