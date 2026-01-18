Set-ExecutionPolicy Bypass -Scope Process -Force
$ErrorActionPreference = "SilentlyContinue"

# Parar serviços que interferem
$services = @(
    "AppXSvc",
    "ClipSVC",
    "StateRepository",
    "wuauserv",
    "BITS"
)

foreach ($s in $services) {
    Stop-Service -Name $s -Force -ErrorAction SilentlyContinue
}

# Remover Appx de todos os usuários
Get-AppxPackage -AllUsers | ForEach-Object {
    Remove-AppxPackage -Package $_.PackageFullName -AllUsers
}

# Remover Appx provisionados
Get-AppxProvisionedPackage -Online | ForEach-Object {
    Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName
}

# Remover Winget manualmente (caso fique preso)
Get-AppxPackage -AllUsers Microsoft.DesktopAppInstaller | Remove-AppxPackage -AllUsers

# Limpar cache Appx
Remove-Item "C:\ProgramData\Microsoft\Windows\AppRepository\StateRepository-*" -Force -Recurse

# Limpar cache da Store
Remove-Item "C:\Program Files\WindowsApps" -Force -Recurse

# Limpar perfis de usuários quebrados
Get-CimInstance Win32_UserProfile | Where-Object {
    $_.Special -eq $false -and $_.Loaded -eq $false
} | Remove-CimInstance

# Limpar tarefas UWP órfãs
Get-ScheduledTask | Where-Object {
    $_.TaskPath -like "\Microsoft\Windows\AppxDeploymentClient*"
} | Unregister-ScheduledTask -Confirm:$false

# Resetar flags de setup
reg delete "HKLM\SYSTEM\Setup" /v CmdLine /f
reg delete "HKLM\SYSTEM\Setup" /v OOBEInProgress /f
reg delete "HKLM\SYSTEM\Setup" /v SetupType /f

# Recriar chaves padrão
reg add "HKLM\SYSTEM\Setup" /v SetupType /t REG_DWORD /d 0 /f

# Reiniciar serviços
foreach ($s in $services) {
    Start-Service -Name $s -ErrorAction SilentlyContinue
}
