# Enrolling Autopilot Devices with Entra App

Often to enroll a HWID into Autopilot you either need to use `Get-WindowsAutopilotInfo` to add the HWID to a csv then manually upload that into the Intune Management Portal or use the `-online` flag entering in credentials on each device. You can however use an Entra app to enroll devices without needing to enter credentials and MFA each time- this can be done with a 365 App. 


## Creating the Entra App

1. Navigate to the Entra admin center > Identity > Applications > App Registrations.
2. Add a new application and create your own application.
3. Give it a sensible name and select "Accounts in this organizational directory only (Home only - Single tenant)"
4. In API Permissions, add MS Graph application permission for the following
	`DeviceManagementServiceConfig.ReadWrite.All` 
	`DeviceManagementManagedDevices.ReadWrite.All`
6. Grant admin consent for the organisation.
7. Copy `Application (client) ID` and `Directory (tenant) ID`



## Adding a secret

1. Certificates and secrets in the App settings and add a New Client Secret
2. Add a description and desired duration.
3. Copy the Secret value not ID.

## Incorporating into a script
You can incorporate the app into a script for zero touch deployment into an ISO or other deployment methods such as WDS or OSDCloud. 
``` powershell
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
```

### Extra: App manifest
Modify the App manifest to speed up adding the permissions by replacing the requiredResourceAccess
```json
"requiredResourceAccess": [
		{
			"resourceAppId": "00000003-0000-0000-c000-000000000000",
			"resourceAccess": [
			{
				"id": "e1fe6dd8-ba31-4d61-89e7-88639da4683d",
				"type": "Scope"
			},
			{
				"id": "243333ab-4d21-40cb-a475-36241daa0842",
				"type": "Role"
			},
			{
				"id": "5ac13192-7ace-4fcf-b828-1a26f28068ee",
				"type": "Role"
			}
		]
	}
],

```

