Install-Module OSD -Force


Set-OSDCloudTemplate -Name 'WinPE Intune'
New-OSDCloudWorkspace -WorkspacePath C:\ProgramData\OSDCloud\

#Cleanup Languages
$KeepTheseDirs = @('boot','efi','en-gb','sources','fonts','resources')
Get-ChildItem "$(Get-OSDCloudWorkspace)\Media" | Where {$_.PSIsContainer} | Where {$_.Name -notin $KeepTheseDirs} | Remove-Item -Recurse -Force
Get-ChildItem "$(Get-OSDCloudWorkspace)\Media\Boot" | Where {$_.PSIsContainer} | Where {$_.Name -notin $KeepTheseDirs} | Remove-Item -Recurse -Force
Get-ChildItem "$(Get-OSDCloudWorkspace)\Media\EFI\Microsoft\Boot" | Where {$_.PSIsContainer} | Where {$_.Name -notin $KeepTheseDirs} | Remove-Item -Recurse -Force
New-Item -ItemType Directory -Path "$(Get-OSDCloudWorkspace)\Media\OSDCloud\Automate"

#Build WinPE to start OSDCloudGUI automatically
#Edit-OSDCloudWinPE -UseDefaultWallpaper -StartOSDCloudGUI
Edit-OSDCloudWinPE -StartOSDCloud "-OSVersion 'Windows 11' -OSBuild 24H2 -OSEdition Pro -OSLanguage en-gb -OSActivation Retail -ZTI -Restart"
