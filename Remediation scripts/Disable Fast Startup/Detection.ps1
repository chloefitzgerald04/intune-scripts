$ErrorActionPreference= 'silentlycontinue'
$val = (Get-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power")

try {

    $value = $val.GetValue("HiberbootEnabled")

    if ($value -eq 0) {
        Write-Host "Reg configured correctly"
        exit 0

    } else {
        Write-Host "Reg set to 1 or DWORD not present"
        exit 1
    }
  #Catches whether $val is null (ie key doesn't exist and exits)
} catch [System.Management.Automation.RuntimeException]{ 
    Write-Host "Key not present"
    exit 1

}
