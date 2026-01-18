[Setup]
AppName=cxndyOS
AppVersion=1.0
DefaultDirName={autopf}\cxndyOS
DisableDirPage=yes
DisableProgramGroupPage=yes
DisableWelcomePage=yes
DisableFinishedPage=yes
Uninstallable=no
PrivilegesRequired=admin
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
OutputBaseFilename=cxndyOS-Setup
Compression=lzma2
SolidCompression=yes

[Files]
Source: "cxndyOS.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "wallpaper.jpg"; DestDir: "{app}"; Flags: ignoreversion
Source: "cursor\*"; DestDir: "{app}\cursor"; Flags: recursesubdirs ignoreversion

[Run]
Filename: "powershell.exe"; \
Parameters: "-NoProfile -ExecutionPolicy Bypass -File ""{app}\cxndyOS.ps1"""; \
Flags: runhidden waituntilterminated