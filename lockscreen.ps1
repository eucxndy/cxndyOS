$img = "C:\Windows\Web\Wallpaper\cxndyOS\cxndyOS.jpg"
New-Item (Split-Path $img) -ItemType Directory -Force | Out-Null
Copy-Item ".\cxndyOS.jpg" $img -Force

New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Force | Out-Null
Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" LockScreenImage $img
