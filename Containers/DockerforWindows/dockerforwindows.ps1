param(
    [ValidateSet('community', 'enterprise') ]    
    [string]$edition='community',
    [ValidateSet('stable', 'edge') ]    
    [string]$channelForWindows10='stable',
    [string]$win10StableURL='https://download.docker.com/win/stable/Docker%20for%20Windows%20Installer.exe',
    [string]$win10EdgeURL='https://download.docker.com/win/edge/Docker%20for%20Windows%20Installer.exe',
    [string]$winServerURL='https://download.docker.com/components/engine/windows-server/17.06/docker-17.06.2-ee-5.zip'
)

Write-Host "Getting OS details..." -ForegroundColor Green
$osType = (Get-WmiObject Win32_OperatingSystem).Name
# if OS is Windows 10
if($osType  -match 'Microsoft Windows 10')
{
    Write-Host "Setting up download URL for Windows 10 "+$channelForWindows10+" channel"
    if($channelForWindows10 -eq 'edge')
    {
         $url = $win10EdgeURL
    }
    else
    {
         $url = $win10StableURL
    }        
    $output = '.\Docker for Windows Installer.exe'
    Write-Host "Downloading Docker for Windows" -ForegroundColor Green
    Invoke-WebRequest -Uri $url -OutFile $output
    Write-Host "Starting Docker installation..."  -ForegroundColor Green
    & '.\Docker for Windows Installer.exe'     
}
elseif ($osType -match 'Microsoft Windows Server')
{
    Write-Host "Checking Docker Service Status" -ForegroundColor Green
    $svrStatus = (Get-Service -Name 'Docker').Status        
    if(($svrStatus -eq "Stopped") -and ((Test-Path $env:ProgramFiles\docker\docker.exe) -eq $false))
    {
        Write-Host "Getting Started for"$osType
        # Enable Docker Feature. This will require rebooting
        Write-Host "Looking for Windows Container feature"
        if((Get-WindowsFeature -name Containers).Installed -eq $false)
           {
                Write-Host "Enabling Windows Container Feature" -ForegroundColor Green                
                $null = Install-WindowsFeature containers 
                Start-Sleep 10
                Write-Host "Rebooting System" -ForegroundColor Red
                Restart-Computer -Force
            }
        # Install Docker module and package
        Write-Host "Installing Docker module and package" -ForegroundColor Green
        Install-Module DockerProvider -Force
        Install-Package Docker -ProviderName DockerProvider -Force
        if((Test-Path  c:\docker\docker-17.06.2-ee-5.zip) -eq $false)
        {
            New-Item -name 'docker' -path 'c:\' -type "directory" -Force
            Write-Host "Downloding Docker" -ForegroundColor Green   
            invoke-webrequest -UseBasicparsing -Outfile c:\docker\docker-17.06.2-ee-5.zip $winServerURL            
        }
        Write-Host "Unzipping" -ForegroundColor Green
        Expand-Archive c:\docker\docker-17.06.2-ee-5.zip -DestinationPath $Env:ProgramFiles -Force    -ErrorAction SilentlyContinue                    
        # Add Docker to the path for the current session.
        Write-Host "Setting up env:path for the current session" -ForegroundColor Green
        $env:path += ";$env:ProgramFiles\docker"
        # Optionally, modify PATH to persist across sessions.
        Write-Host "Modifying env:path to persist across sessions" -ForegroundColor Green
        $newPath = "$env:ProgramFiles\docker;" +[Environment]::GetEnvironmentVariable("PATH",[EnvironmentVariableTarget]::Machine) 
        [Environment]::SetEnvironmentVariable("PATH", $newPath,[EnvironmentVariableTarget]::Machine)
        Write-Host "Registring Docker Deamon" -ForegroundColor Green
        dockerd --register-service
        Write-Host "Starting Docker Service" -ForegroundColor Green
        Start-Service docker
        docker --version
    }
    elseif(($svrStatus -eq "Stopped") -and ((Test-Path $env:ProgramFiles\docker\docker.exe) -eq $true))
    {
        Write-Host "Docker Service is already registred, but not running. Starting Docker Service" -ForegroundColor Green
        Start-Service docker
        docker --version
    }       
    else
    {
        docker --version
    } 
}
else
{
    Write-Host "Error..." -ForegroundColor Red
}





