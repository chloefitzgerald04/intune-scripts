$username = whoami
$group = "administrators"

$group_members = get-localgroupmember -name $group
$sid = (New-Object System.Security.Principal.NTAccount($username)).Translate([System.Security.Principal.SecurityIdentifier]).value

if ( -not $sid.StartsWith("S-1-12-1-")){ 
    Write-host "Logged in user is not an Entra Account"
    exit 0
} else {


if (($username -in $group_members.name -or $sid -in $group_members.name))
    {
    
        try {
                Remove-LocalGroupMember -group $group -Member $username
                Write-host "$username removed from $group."
                exit 0 
            }
        catch [PrincipalNotFound]{
                Remove-LocalGroupMember -group $group -Member $sid
                exit 0
              }
        catch {
                Write-host "Could not remove $username from $group."
                exit 1
               }       

    } else {

        Write-host "$username is already a standard user."
        exit 0

    }

}
