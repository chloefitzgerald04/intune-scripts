
$path = "C:\OSDCloud"
$exists = Test-path -Path $path

if ($exists -eq $True){
    Write-host "$path exists"
    Exit 1
}elseif($exists -eq $False){
    Write-host "$path does not exist"
    Exit 0
} else {
    write-host "Error"
    Exit 1
}