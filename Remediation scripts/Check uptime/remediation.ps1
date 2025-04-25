[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null
function Display-ToastNotification() {
    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null
    #$ToastXML = New-Object -TypeName Windows.Data.Xml.Dom.XmlDocument
    #$ToastXML.LoadXml($Toast.OuterXml)
    #$App = 'Microsoft.WindowsTerminal_8wekyb3d8bbwe!App'
    #$toast1 = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($app).Show($ToastXml)

    #$ToastMessage = [Windows.UI.Notifications.ToastNotification]::New($ToastXML)
    #[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($app).Show($ToastMessage)

    $Launcherid = "Microsoft.WindowsTerminal_8wekyb3d8bbwe!App" 
    $Action_Node = $ActionTemplate.toast.actions
    [void]$ToastTemplate.toast.AppendChild($ToastTemplate.ImportNode($Action_Node, $true))
    $ToastXml = [Windows.Data.Xml.Dom.XmlDocument]::New()
    $ToastXml.LoadXml($ToastTemplate.OuterXml)
    $ToastMessage = [Windows.UI.Notifications.ToastNotification]::New($ToastXML)
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($LauncherID).Show($ToastMessage)
}



$Picture1_Base64 = "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"
$BadgeImage = "$env:TEMP\badgePicture.png"
[byte[]]$Bytes = [convert]::FromBase64String($Picture1_Base64)
[System.IO.File]::WriteAllBytes($BadgeImage,$Bytes)
$LogoImage = "$env:TEMP\badgePicture.png"


$Scenario = 'reminder'

$AttributionText = "Lanesystems"
$HeaderText = "Please restart your computer"
$TitleText = "Your device has not restarted in $($uptime.hours) days"
$BodyText2 = "Please save your work and restart your device soon or schedule a restart below."

[xml]$Toasttemplate = @"
    <toast duration="long" scenario="default" useButtonStyle="true" launch=''>
    <visual>
    <binding template="ToastGeneric">
        <image id="1" placement="appLogoOverride" hint-crop="circle" src="$LogoImage"/>
        <text placement="attribution">$AttributionText</text>
        <text>$HeaderText</text>
        <group>
            <subgroup>
                <text hint-style="title" hint-wrap="true" >$TitleText</text>
            </subgroup>
        </group>
        <group>
            <subgroup>     
                <text hint-style="body" hint-wrap="true" >$BodyText2</text>
            </subgroup>
        </group>
    </binding>
    </visual>

</toast>
"@
[xml]$ActionTemplate = @"
<toast>
    <actions>
        <input id="delay" type="selection" defaultInput="15">
            <selection id="0" content="Now"/>
            <selection id="15" content="15 minutes"/>
            <selection id="60" content="1 hour"/>
            <selection id="240" content="4 hours"/>
            <selection id="480" content="8 hours"/>
        </input>
        <action activationType="system" arguments="dismiss" content="Dismiss"/>
        <action activationType="foreground" arguments="powershell.exe -c notepad.exe C:\test.txt" content="Restart Now"/>
        <action activationType="foreground" arguments="powershell.exe -c notepad.exe C:\$input.txt" hint-inputId="delay"/>
    </actions>
</toast>
"@
$input = Get-ToastInput -hintInputId $hintInputId



$uptime_days = "1"

$cim = Get-CimInstance win32_operatingsystem
$uptime = (Get-Date) - ($cim.LastBootUpTime)

if ([int]$uptime.hours -ge $uptime_days){

    Write-host "Device has been on for too long"
    $uptime_seconds = [math]::Round($uptime.TotalSeconds,0)
    $ts =  [timespan]::fromseconds($uptime_seconds)
    write-host "Uptime: "("{0:dd\:hh\:mm}" -f $ts)
    Write-host "Last boot: $last_boot"
    Display-ToastNotification
    #exit 1

} elseif ([int]$uptime.hours -lt $uptime_days){

    Write-host "Device has been on for less than $uptime_days days."
    #exit 0
}









