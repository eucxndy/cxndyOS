$ErrorActionPreference = "SilentlyContinue"

$cursorPath = "C:\Windows\Cursors\cxndyOS"

if (-not (Test-Path $cursorPath)) { exit }

$reg = "HKCU:\Control Panel\Cursors"

Set-ItemProperty $reg Arrow        "$cursorPath\arrow.cur"
Set-ItemProperty $reg Hand         "$cursorPath\hand.cur"
Set-ItemProperty $reg IBeam        "$cursorPath\text.cur"
Set-ItemProperty $reg Wait         "$cursorPath\busy.ani"
Set-ItemProperty $reg AppStarting  "$cursorPath\busy.ani"
Set-ItemProperty $reg Crosshair    "$cursorPath\cross.cur"
Set-ItemProperty $reg Help         "$cursorPath\help.cur"
Set-ItemProperty $reg SizeAll      "$cursorPath\move.cur"
Set-ItemProperty $reg SizeNESW     "$cursorPath\nesw.cur"
Set-ItemProperty $reg SizeNS       "$cursorPath\ns.cur"
Set-ItemProperty $reg SizeNWSE     "$cursorPath\nwse.cur"
Set-ItemProperty $reg SizeWE       "$cursorPath\we.cur"
Set-ItemProperty $reg UpArrow      "$cursorPath\up.cur"

Set-ItemProperty $reg SchemeSource 2

rundll32.exe user32.dll,UpdatePerUserSystemParameters
