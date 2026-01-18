$ErrorActionPreference = "SilentlyContinue"

$src = "."
$dst = "C:\ProgramData\Microsoft\User Account Pictures"

if (Test-Path $dst) {
    Copy-Item "$src\user*.png" $dst -Force
    Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\AccountPictures" -Recurse -Force
}
