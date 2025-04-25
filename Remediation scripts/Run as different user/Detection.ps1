﻿Start-Transcript -path C:\temp\runas-detect.txt
$ErrorActionPreference= 'silentlycontinue'


New-PSDrive HKU Registry HKEY_USERS | out-null


$username = Get-WmiObject Win32_Process -Filter "Name='explorer.exe'" | ForEach-Object { $_.GetOwner() } | Select-Object -Unique -Expand User
$sid = (New-Object System.Security.Principal.NTAccount("azuread\$username")).Translate([System.Security.Principal.SecurityIdentifier]).value

$val = (Get-Item "HKU:$sid\Software\Policies\Microsoft\Windows\Explorer")

try {

    $value = $val.GetValue("ShowRunasDifferentuserinStart")

    if ($value -eq 1) {
        Write-Host "Reg configured correctly"
        exit 0

    } else {
        Write-Host "Reg set to 0 or DWORD not present"
        exit 1
    }
  #Catches whether $val is null (ie key doesn't exist and exits)
} catch [System.Management.Automation.RuntimeException]{ 
    Write-Host "Key not present"
    exit 1

}



