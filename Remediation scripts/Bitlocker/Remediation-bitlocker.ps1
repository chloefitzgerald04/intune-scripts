
Start-Transcript -Path C:\temp\bitlocker.txt  -IncludeInvocationHeade
# Bitlocker for only C drive

########################### - Variables - ###############################

$drive = "C"
$status = Get-bitlockervolume -MountPoint $drive
$Pin = ConvertTo-SecureString "123456" -AsPlainText -Force
$encryption_strength = "Aes256"
#########################################################################
########################## - Functions - ################################

function Upload-BitlockerKey {

    $Recoverykeyid = ((Get-BitLockerVolume -MountPoint $drive).keyprotector | where-object {$_.KeyProtectorType -eq "RecoveryPassword" }).KeyProtectorId
    BackupToAAD-BitLockerKeyProtector -MountPoint $drive -KeyProtectorId $Recoverykeyid

}

#########################################################################







if($status.ProtectionStatus -eq "On"){
    # Confirms that bitlocker is enabled and active. but checks to make sure that its set up correctly.

    if($status.KeyProtector -like "TpmPin"){

        Upload-BitlockerKey
        Write-host "${drive}:  encryption enabled. Uploaded to AAD with recovery key ID:$recoverykeyid"
        exit 0
    }else{
        Upload-BitlockerKey
        Write-host "${drive}: encrypted but no PIN assigned. Current keyprotectors are:"$status.KeyProtector
        Enable-BitLocker -MountPoint $drive -EncryptionMethod $encryption_strength  -Pin $Pin -TPMandPinProtector -UsedSpaceOnly -SkipHardwareTest
        exit 1
    }
}elseif($status.ProtectionStatus -eq "off"){
    # Bitlocker is disabled. Checking to see that status of encryption- might just be taking a while for it to encrypt.

    if($status.VolumeStatus -eq "EncryptionInProgress"){
        Upload-BitlockerKey
        Write-host "${drive}: drive currently encrypting. Encryption percentage:"$status.encryptionpercentage"%"
        exit 0
    }elseif($status.VolumeStatus -eq "DecryptionInProgess"){
        Upload-BitlockerKey
        Write-host "${drive}: drive currently decrypting. Encryption percentage:"$status.encryptionpercentage"%"
        Enable-BitLocker -MountPoint $drive -EncryptionMethod $encryption_strength  -Pin $Pin -TPMandPinProtector -UsedSpaceOnly -SkipHardwareTest
        exit 1
    }elseif($status.VolumeStatus -eq "FullyDecrypted"){
        Write-Host "${drive}: drive not encrypted. Starting remediation. Not protected and status FullyDecrypted"
        Enable-BitLocker -MountPoint $drive -EncryptionMethod $encryption_strength  -Pin $Pin -TPMandPinProtector -UsedSpaceOnly -SkipHardwareTest
        exit 1

    }elseif($status.EncryptionPercentage -eq "100"){
        Write-Host "${drive}: drive is encrypted but not enabled. Starting remediation. Check keyprotectors"$status.KeyProtector
        Enable-BitLocker -MountPoint $drive -EncryptionMethod $encryption_strength  -Pin $Pin -TPMandPinProtector -UsedSpaceOnly -SkipHardwareTest
        exit 1

    }

}else{
    # Something wrong but we know drive definitely isn't encrypted. Either that or my PS skills are severely lacking.
    Write-host "General error. ${drive}: drive not encrypted."
    exit 1

}
