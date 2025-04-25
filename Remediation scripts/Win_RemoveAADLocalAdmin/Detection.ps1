$username = whoami
$group = "administrators"

$group_members = get-localgroupmember -name $group
$sid = (New-Object System.Security.Principal.NTAccount($username)).Translate([System.Security.Principal.SecurityIdentifier]).value

if ( -not $sid.StartsWith("S-1-12-1-")){ 
    Write-host "Logged in user is not an Entra Account"
    exit 0
} else {


if (($username -in $group_members.name -or $sid -in $group_members.name)){
    
    Write-host "Logged in Entra user is local administrator" 
    exit 1         

    } else {

        Write-host "Logged in Entra user is standard user"
        exit 0

    }

}
