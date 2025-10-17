$bytesAPI = [System.IO.File]::ReadAllBytes('C:\Users\user\Downloads\NtApiDotNet.dll')
$bytesObjM = [System.IO.File]::ReadAllBytes('C:\Users\user\Downloads\NtObjectManager.dll')
$d = [System.Reflection.Assembly]::Load($bytesAPI)
$e = [System.Reflection.Assembly]::Load($bytesObjM)
Import-Module $d
Import-Module $e

$Token= Get-NtToken -Primary
$Token.SetPrivilege([NtApiDotNet.TokenPrivilegeValue[]]"SeDebugPrivilege", [NtApiDotNet.PrivilegeAttributes]"Enabled")
$Token.Privileges | Where-Object {$_.name -eq "SeDebugPrivilege"}
Start-Service Trustedinstaller
$ti_process = Get-NtProcess -Name "TrustedInstaller.exe" | Select-Object -First 1
$config = New-Object NtApiDotNet.Win32.Win32ProcessConfig
$config.CommandLine = "powershell"
$config.CreationFlags = [NtApiDotNet.Win32.CreateProcessFlags]::NewConsole
$config.ParentProcess = $ti_process
[NtApiDotNet.Win32.Win32Process]::CreateProcess($config)
