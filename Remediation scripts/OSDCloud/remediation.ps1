$path = "C:\OSDCloud"
$exists = Test-path -Path $path

if ($exists -eq $False){
    Write-host "$path does not exist. Exiting..."
    Exit 0
}elseif($exists -eq $True){
    Write-host "$path found."
    Remove-Item -path $path -Force -Recurse
    if ((test-path -Path $path) -eq $False){
        Write-host "$path removed"
        exit 0
    } else {
        Exit 1
    }
} else {
    write-host "Error"
    Exit 1
}