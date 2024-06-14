@echo off
setlocal

:: Check if URL is provided
if "%~1"=="" (
    echo Error: URL is required.
    echo Usage: %~nx0 http://ca-host/ca.crt
    exit /b 1
)

set "URL=%~1"
set "TEMP_CERT=%TEMP%\ca-cert.crt"

:: Download the certificate
echo Downloading certificate from %URL%...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%URL%', '%TEMP_CERT%')"
if %errorlevel% neq 0 (
    echo Error: Failed to download certificate.
    exit /b 1
)

:: Install the certificate
echo Installing certificate...
certutil -addstore -f "Root" "%TEMP_CERT%"
if %errorlevel% neq 0 (
    echo Error: Failed to install certificate.
    del "%TEMP_CERT%"
    exit /b 1
)

:: Clean up temporary certificate file
del "%TEMP_CERT%"

echo Certificate installed successfully.
endlocal
