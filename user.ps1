$pics = "C:\ProgramData\Microsoft\User Account Pictures"
Copy-Item ".\user*.png" $pics -Force

Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\AccountPictures" -Recurse -Force
