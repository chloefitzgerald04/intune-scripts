Start-Transcript -path C:\temp\runas-remediate.txt

New-PSDrive HKU Registry HKEY_USERS | out-null


$username = Get-WmiObject Win32_Process -Filter "Name='explorer.exe'" | ForEach-Object { $_.GetOwner() } | Select-Object -Unique -Expand User
$sid = (New-Object System.Security.Principal.NTAccount("azuread\$username")).Translate([System.Security.Principal.SecurityIdentifier]).value




$Key = "HKU:$sid\Software\Policies\Microsoft\Windows\Explorer"
$reg = Get-Itemproperty -Path "HKU:$sid\Software\Policies\Microsoft\Windows\Explorer" -Name ShowRunasDifferentuserinStart



if (-not($reg)) {
    Write-Host "RunAs reg does not exist, creating..."
    New-Item -path "HKU:$sid\Software\Policies\Microsoft\Windows" -name "Explorer" | out-null
    New-Itemproperty -path $Key -name "ShowRunasDifferentuserinStart" -value "1" -PropertyType "dword" | out-null
} else {
    Write-Host "RunAs reg exists but value is not 1, changing..."
    Set-ItemProperty -path "HKU:$sid\Software\Policies\Microsoft\Windows\Explorer" -name "ShowRunasDifferentuserinStart" -value "1" | out-null
}

$val = (Get-Item "HKU:$sid\Software\Policies\Microsoft\Windows\Explorer")
$value = $val.GetValue("ShowRunasDifferentuserinStart")

if ($value -eq 1) {
    Write-Host "Reg configured correctly"
    exit 0
} else {
    Write-Host "Reg configuring failed"
    exit 1
}
