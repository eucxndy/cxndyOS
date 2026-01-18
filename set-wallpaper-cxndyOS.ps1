$ErrorActionPreference = "SilentlyContinue"

$wall = "C:\Windows\Web\Wallpaper\cxndyOS\cxndyOS.jpg"

if (-not (Test-Path $wall)) { exit }

New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Force | Out-Null

Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" `
    Wallpaper $wall

Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" `
    WallpaperStyle 10

Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" `
    LockScreenImage $wall

Set-ItemProperty "HKCU:\Control Panel\Desktop" `
    Wallpaper $wall

rundll32.exe user32.dll,UpdatePerUserSystemParameters