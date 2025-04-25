

Install-Script -Name Get-WindowsAutopilotInfo -Force
$AutopilotParams = @{
    Online = $true
    TenantId = ''
    AppId = ''
    AppSecret = ''
    GroupTag = ''
    Assign = $true
}
Get-WindowsAutoPilotInfo @AutopilotParams

