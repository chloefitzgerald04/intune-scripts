$ErrorActionPreference= 'silentlycontinue'


$Key = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
$reg = Get-Itemproperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name HiberbootEnabled



if (-not($reg)) {
    Write-Host "Reg reg does not exist, creating..."
    New-Itemproperty -path $Key -name "HiberbootEnabled" -value "0" -PropertyType "dword" | out-null
} else {
    Write-Host "Reg reg exists but value is not 0, changing..."
    Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -name "HiberbootEnabled" -value "0" | out-null
}

$val = (Get-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power")
$value = $val.GetValue("HiberbootEnabled")

if ($value -eq 0) {
    Write-Host "Reg configured correctly"
    exit 0
} else {
    Write-Host "Reg configuring failed"
    exit 1
}
