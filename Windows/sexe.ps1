# iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/ndknitor/preconfig/main/Windows/sexe.ps1')) -url <exe_url> -path <C:\Program Files\Service\service.exe> -name <service_name> -dname <service_displayname>

param (
    [string]$url,
    [string]$path,
    [string]$name,
    [string]$dname,
    [string]$nssmUrl = "https://nssm.cc/release/nssm-2.24.zip"
)

# Ensure the script is running with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "You need to run this script as an Administrator."
    exit
}

# Create necessary directories
$exeDirectory = Split-Path $path -Parent
if (-not (Test-Path -Path $exeDirectory)) {
    New-Item -ItemType Directory -Path $exeDirectory | Out-Null

    $nssmDirectory = "C:\nssm"
    if (-not (Test-Path -Path $nssmDirectory)) {
        New-Item -ItemType Directory -Path $nssmDirectory | Out-Null
    }

    # Download NSSM
    $nssmZipPath = "$nssmDirectory\nssm.zip"
    Invoke-WebRequest -Uri $nssmUrl -OutFile $nssmZipPath

    # Extract NSSM
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($nssmZipPath, $nssmDirectory)
}

# Download the executable
Invoke-WebRequest -Uri $url -OutFile $path

# Path to NSSM executable
$nssmpath = "$nssmDirectory\nssm-2.24\win64\nssm.exe"

# Check if the service already exists
$service = Get-Service -Name $name -ErrorAction SilentlyContinue

try {
    if ($service -eq $null) {
        # Create a new service using NSSM
        & $nssmpath install $name $path
        & $nssmpath set $name DisplayName $dname
        & $nssmpath set $name Start SERVICE_AUTO_START
        Write-Host "Service created successfully using NSSM."
    } else {
        Write-Host "Service already exists. Updating the executable path and ensuring it's set to auto start."
        # Update the executable path
        & $nssmpath set $name Application $path
        & $nssmpath set $name Start SERVICE_AUTO_START
    }

    # Start the service
    Start-Service -Name $name
    Write-Host "Service started successfully."
} catch {
    Write-Error "An error occurred: $_"
}
