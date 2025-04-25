Start-Transcript -path C:\temp\cmd-detect.txt

New-PSDrive HKU Registry HKEY_USERS | out-null


$username = Get-WmiObject Win32_Process -Filter "Name='explorer.exe'" | ForEach-Object { $_.GetOwner() } | Select-Object -Unique -Expand User
$sid = (New-Object System.Security.Principal.NTAccount("azuread\$username")).Translate([System.Security.Principal.SecurityIdentifier]).value

$regkey = (Get-Item "HKU:$sid\Software\Policies\Microsoft\Windows\system")

try {
    
    # Tries to get value of DWORD
    $value = $regkey.GetValue("DisableCMD")

    if ($value -eq 1) {
        Write-Host "CMD is blocked"
        exit 0

    } else {
        Write-Host "DWORD not found or set to 0"
        exit 1
    }

  #Catches whether $val is null (ie key doesn't exist and exits)
} catch [System.Management.Automation.RuntimeException]{ 
    Write-Host "Key not present"
    exit 1

}
