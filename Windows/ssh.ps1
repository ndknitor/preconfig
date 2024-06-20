#Powershell 
$publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3"
$authorizedKeysPath = "C:\ProgramData\ssh\administrators_authorized_keys"
if (-Not (Test-Path $authorizedKeysPath)) {
    # Create the authorized keys file if it does not exist
    New-Item -Path $authorizedKeysPath -ItemType File -Force
}
Add-Content -Path $authorizedKeysPath -Value $PublicKey
Write-Output "Public key has been added to $authorizedKeysPath."
icacls.exe "C:\ProgramData\ssh\administrators_authorized_keys" /inheritance:r /grant "Administrators:F" /grant "SYSTEM:F"
