$ErrorActionPreference = "SilentlyContinue"

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { exit }

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$baseDir = "C:\cxndyOS"
$cursorDir = "$baseDir\cursor"

New-Item $baseDir -ItemType Directory -Force | Out-Null
New-Item $cursorDir -ItemType Directory -Force | Out-Null

Copy-Item "$scriptDir\wallpaper.jpg" "$baseDir\wallpaper.jpg" -Force
Copy-Item "$scriptDir\cursor\*" $cursorDir -Recurse -Force

New-Item "HKCU:\System\GameConfigStore" -Force | Out-Null
Set-ItemProperty "HKCU:\System\GameConfigStore" GameDVR_Enabled 0
Set-ItemProperty "HKCU:\System\GameConfigStore" GameDVR_FSEBehaviorMode 2
Set-ItemProperty "HKCU:\System\GameConfigStore" GameDVR_HonorUserFSEBehaviorMode 1

New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Force | Out-Null
Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" AllowGameDVR 0

New-Item "HKLM:\SOFTWARE\Microsoft\Windows\Dwm" -Force | Out-Null
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\Dwm" OverlayTestMode 5
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\Dwm" AlwaysHibernateThumbnails 0

bcdedit /set useplatformclock false | Out-Null
bcdedit /set disabledynamictick yes | Out-Null
bcdedit /set tscsyncpolicy Enhanced | Out-Null

powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61
powercfg -hibernate off

$services = @(
"SysMain","DiagTrack","dmwappushservice","WSearch",
"MapsBroker","lfsvc","RemoteRegistry","RetailDemo"
)

foreach ($s in $services) {
    $svc = Get-Service $s
    if ($svc) {
        if ($svc.Status -ne "Stopped") { Stop-Service $s -Force }
        Set-Service $s -StartupType Disabled
    }
}

Get-ScheduledTask | Where-Object {
    $_.TaskPath -like "\Microsoft\Windows\Application Experience*" -or
    $_.TaskPath -like "\Microsoft\Windows\Customer Experience Improvement Program*" -or
    $_.TaskPath -like "\Microsoft\Windows\Feedback*"
} | Disable-ScheduledTask

New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Force | Out-Null
Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" AllowTelemetry 0

New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Force | Out-Null
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" GlobalUserDisabled 1

$mm = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
Set-ItemProperty $mm NetworkThrottlingIndex 0xffffffff
Set-ItemProperty $mm SystemResponsiveness 0

$games = "$mm\Tasks\Games"
New-Item $games -Force | Out-Null
Set-ItemProperty $games "Priority" 8
Set-ItemProperty $games "Scheduling Category" "High"
Set-ItemProperty $games "GPU Priority" 8

$mouse = "HKCU:\Control Panel\Mouse"
Set-ItemProperty $mouse MouseSpeed 0
Set-ItemProperty $mouse MouseThreshold1 0
Set-ItemProperty $mouse MouseThreshold2 0
Set-ItemProperty $mouse MouseSensitivity 10

$kbd = "HKCU:\Control Panel\Keyboard"
Set-ItemProperty $kbd KeyboardDelay 0
Set-ItemProperty $kbd KeyboardSpeed 31

$visual = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
New-Item $visual -Force | Out-Null
Set-ItemProperty $visual VisualFXSetting 2

Set-ItemProperty "HKCU:\Control Panel\Desktop" MenuShowDelay 0

$adv = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Set-ItemProperty $adv ForegroundFlashCount 0
Set-ItemProperty $adv ForegroundLockTimeout 0
Set-ItemProperty $adv TaskbarSmallIcons 1

New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications" -Force | Out-Null
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications" ToastEnabled 0

New-Item "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Force | Out-Null
Set-ItemProperty "HKCU:\Software\Policies\Microsoft\Windows\Explorer" DisableNotificationCenter 1

$theme = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
New-Item $theme -Force | Out-Null
Set-ItemProperty $theme AppsUseLightTheme 0
Set-ItemProperty $theme SystemUsesLightTheme 0
Set-ItemProperty $theme EnableTransparency 0

Set-ItemProperty "HKCU:\Control Panel\Desktop" Wallpaper "$baseDir\wallpaper.jpg"
New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Force | Out-Null
Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" LockScreenImage "$baseDir\wallpaper.jpg"

$cur = "HKCU:\Control Panel\Cursors"
Set-ItemProperty $cur Arrow "$cursorDir\arrow.cur"
Set-ItemProperty $cur Hand "$cursorDir\hand.cur"
Set-ItemProperty $cur IBeam "$cursorDir\text.cur"
Set-ItemProperty $cur Wait "$cursorDir\busy.ani"
Set-ItemProperty $cur AppStarting "$cursorDir\busy.ani"
Set-ItemProperty $cur SchemeSource 2

$SafeAppx = @(
"Microsoft.XboxApp",
"Microsoft.XboxGamingOverlay",
"Microsoft.XboxIdentityProvider",
"Microsoft.XboxSpeechToTextOverlay",
"Microsoft.GetHelp",
"Microsoft.Getstarted",
"Microsoft.MicrosoftOfficeHub",
"Microsoft.MixedReality.Portal",
"Microsoft.People",
"Microsoft.SkypeApp",
"Microsoft.WindowsFeedbackHub",
"Microsoft.ZuneMusic",
"Microsoft.ZuneVideo",
"Microsoft.3DBuilder",
"Microsoft.MSPaint",
"Microsoft.BingWeather",
"Microsoft.BingNews"
)

foreach ($app in $SafeAppx) {
    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage
    Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq $app | Remove-AppxProvisionedPackage -Online
}

Stop-Process explorer -Force
Start-Process explorer
rundll32.exe user32.dll,UpdatePerUserSystemParameters