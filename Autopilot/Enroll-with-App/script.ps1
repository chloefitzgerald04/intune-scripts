

$365_tenant_id = ""
$365_entra_app_id = ""
$365_entra_app_secret = ""
$365_autopilot_grouptag = ""

Install-Script -Name Get-WindowsAutopilotInfo -Force
$AutopilotParams = @{
    Online = $true
    TenantId = '$365_tenant_id'
    AppId = '$365_entra_app_id'
    AppSecret = '$365_entra_app_secret'
    GroupTag = '$365_autopilot_grouptag'
    Assign = $true
}
Get-WindowsAutoPilotInfo @AutopilotParams

