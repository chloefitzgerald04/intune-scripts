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



$Picture1_Base64 = "" #convert image file into base64
$BadgeImage = "$env:TEMP\badgePicture.png"
[byte[]]$Bytes = [convert]::FromBase64String($Picture1_Base64)
[System.IO.File]::WriteAllBytes($BadgeImage,$Bytes)
$LogoImage = "$env:TEMP\badgePicture.png"


$Scenario = 'reminder'

$AttributionText = "X"
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









