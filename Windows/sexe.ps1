# iex ((New-Object System.Net.WebClient).DownloadString('<script_url>')) -url <exe_url> -path <local_installation_exe_path> -name <service_name> -dname <service_displayname>

param (
    [string]$url,
    [string]$path,
    [string]$name,
    [string]$dname
)

# Download the executable
Invoke-WebRequest -Uri $url -OutFile $path

# Check if the service already exists
$service = Get-Service -Name $name -ErrorAction SilentlyContinue

if ($service -eq $null) {
    # Create a new service
    New-Service -Name $name -BinaryPathName $path -DisplayName $dname -StartupType Automatic
} else {
    Write-Host "Service already exists. Updating the executable path and ensuring it's set to auto start."
    # Update the executable path
    Set-Service -Name $name -BinaryPathName $path
    # Set the service to start automatically
    Set-Service -Name $name -StartupType Automatic
}

# Start the service
Start-Service -Name $name

Write-Host "Service installed and started successfully."
