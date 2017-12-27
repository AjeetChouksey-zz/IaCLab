<# Custom Script for Windows #>


New-Item -ItemType Directory -Name VSCodeSetup -path c:\
Invoke-WebRequest "https://go.microsoft.com/fwlink/?Linkid=852157" -OutFile "C:\VSCodeSetup\VSCodeSetup-x64-1.19.1.exe"
&  C:\VSCodeSetup\VSCodeSetup-x64-1.19.1.exe