$ErrorActionPreference = "SilentlyContinue"

if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { exit }

$img = "C:\Windows\Web\Wallpaper\cxndyOS\cxndyOS.jpg"

if (Test-Path $img) {
    New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Force | Out-Null
    Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" LockScreenImage $img
}

$systemData = "C:\ProgramData\Microsoft\Windows\SystemData"

if (Test-Path $systemData) {
    takeown /f $systemData /r /d y | Out-Null
    icacls $systemData /grant Administrators:F /t | Out-Null
    Get-ChildItem $systemData -Force | Remove-Item -Recurse -Force
}

$cdm = "$env:LOCALAPPDATA\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState"

if (Test-Path $cdm) {
    Remove-Item "$cdm\*" -Recurse -Force
}

Remove-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Lock Screen" -Recurse -Force
Remove-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\Creative" -Recurse -Force

Stop-Process -Name explorer -Force
Start-Process explorer
