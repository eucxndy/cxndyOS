$ErrorActionPreference = "SilentlyContinue"

# ===============================
# WINVER / BRANDING INTERNO
# ===============================
$cv = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"

Set-ItemProperty $cv "RegisteredOrganization" "cxndyOS"
Set-ItemProperty $cv "RegisteredOwner" "cxndyOS"

# Remove strings do Atlas se existirem
Remove-ItemProperty $cv "AtlasEdition" -ErrorAction SilentlyContinue
Remove-ItemProperty $cv "AtlasVersion" -ErrorAction SilentlyContinue

# ===============================
# OEM INFORMATION (Configurações > Sobre)
# ===============================
$oem = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation"

New-Item $oem -Force | Out-Null

Set-ItemProperty $oem "Manufacturer" "cxndyOS"
Set-ItemProperty $oem "Model" "cxndyOS"
Set-ItemProperty $oem "SupportPhone" ""
Set-ItemProperty $oem "SupportURL" ""
Set-ItemProperty $oem "SupportHours" ""
Set-ItemProperty $oem "Logo" ""

# ===============================
# NOME DO SISTEMA (EXIBIÇÃO)
# ===============================
$sys = "HKLM:\SYSTEM\CurrentControlSet\Control\SystemInformation"

New-Item $sys -Force | Out-Null
Set-ItemProperty $sys "SystemProductName" "cxndyOS"
Set-ItemProperty $sys "SystemManufacturer" "cxndyOS"

# ===============================
# REMOVE RESÍDUOS DO ATLAS (CASO EXISTAM)
# ===============================
$atlasKeys = @(
    "HKLM:\SOFTWARE\AtlasOS",
    "HKLM:\SOFTWARE\Atlas",
    "HKCU:\Software\AtlasOS",
    "HKCU:\Software\Atlas"
)

foreach ($k in $atlasKeys) {
    Remove-Item $k -Recurse -Force
}

# ===============================
# FORÇA ATUALIZAÇÃO DE CACHE
# ===============================
Stop-Process -Name explorer -Force
Start-Process explorer
