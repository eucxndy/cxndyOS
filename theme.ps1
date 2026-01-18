$ErrorActionPreference = "SilentlyContinue"

if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { exit }

$themePath = "C:\Windows\Resources\Themes\cxndyOS.theme"

if (-not (Test-Path $themePath)) { exit }

New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes" -Force | Out-Null
Set-ItemProperty `
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes" `
    DefaultTheme $themePath

New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes" -Force | Out-Null
Set-ItemProperty `
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes" `
    CurrentTheme $themePath

New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Force | Out-Null
Set-ItemProperty `
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" `
    NoThemesTab 1

rundll32.exe user32.dll,UpdatePerUserSystemParameters
Stop-Process -Name explorer -Force
Start-Process explorer
