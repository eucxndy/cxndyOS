$ErrorActionPreference = "SilentlyContinue"

$wall = "C:\Windows\Web\Wallpaper\cxndyOS\cxndyOS.jpg"

if (-not (Test-Path $wall)) { exit }

Set-ItemProperty "HKCU:\Control Panel\Desktop" `
    Wallpaper $wall

Set-ItemProperty "HKCU:\Control Panel\Desktop" `
    WallpaperStyle 10

Set-ItemProperty "HKCU:\Control Panel\Desktop" `
    TileWallpaper 0

Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Lock Screen" `
    SlideshowEnabled 0

Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Lock Screen" `
    CreativeId "{00000000-0000-0000-0000-000000000000}"

rundll32.exe user32.dll,UpdatePerUserSystemParameters
