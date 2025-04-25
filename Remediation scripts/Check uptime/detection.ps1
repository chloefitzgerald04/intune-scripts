$uptime_days = "7"



$now = Get-Date
$last_boot = get-ciminstance -class win32_operatingsystem | select -expand lastbootuptime
$uptime = new-timespan -start (get-date ($last_boot)) -end ($now)

if ([int]$uptime.days -ge $uptime_days){

    Write-host "Device has been on for too long"
    Write-host "Uptime:" $uptime
    Write-host "Last boot: $last_boot"
    exit 0

} elseif ([int]$uptime.days -lt $uptime_days){

    Write-host "Device has been on for less than $uptime_days days."
    exit 1
}
