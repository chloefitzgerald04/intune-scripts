﻿Start-Transcript -path C:\temp\cmd-remediate.txt

New-PSDrive HKU Registry HKEY_USERS | out-null

$username = Get-WmiObject Win32_Process -Filter "Name='explorer.exe'" | ForEach-Object { $_.GetOwner() } | Select-Object -Unique -Expand User
$sid = (New-Object System.Security.Principal.NTAccount("azuread\$username")).Translate([System.Security.Principal.SecurityIdentifier]).value


$key = "HKU:$sid\Software\Policies\Microsoft\Windows\system"
$val = (Get-Item "HKU:$sid\Software\Policies\Microsoft\Windows\system")
$reg = Get-Itemproperty -Path $key -Name DisableCMD -erroraction 'silentlycontinue'

if (-not($reg)) {
    Write-Host "CMD registry key was not created, creating it now!"
    New-Item -path "HKU:$sid\Software\Policies\Microsoft\Windows" -name "System"
    New-Itemproperty -path "HKU:$sid\Software\Policies\Microsoft\Windows\system" -name "DisableCMD" -value "1" -PropertyType "dword"
    exit 1
} else {
    Write-Host "CMD Registry key configured to 1"
    Set-ItemProperty -path "HKU:$sid\Software\Policies\Microsoft\Windows\system" -name "DisableCMD" -value "1"
    Exit 0  
}
