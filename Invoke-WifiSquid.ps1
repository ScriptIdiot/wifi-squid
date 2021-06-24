Write-Host "
       ^
     /   \
     \   /
     |   |
     |   |
     | 0 |
    // ||\\
   (( // ||
    \\))  \\
   //||    ))
   ( ))   //
    //   ((

";
Write-Host "Invoke-WifiSquid by @0xblacklight`n";

# GRAB THE WIFI CONFIG XML FILES AND LOOP OVER THEM. SUPPY DIRECTORY NAME IN VARIABLE
# TODO: ALLOW COMMAND LINE ARG TO SPECIFY 
$dirName = "C:\programdata\Microsoft\Wlansvc\Profiles\Interfaces" # INTERFACES LIST

# FIND INTERFACE DIRECTORIES
$ifaceFolders = Get-ChildItem $dirName;
for ($i = 0; $i -lt $ifaceFolders.Count; $i++) {

    $fullPathToConfigs = "$($dirName)\$($ifaceFolders[$i])";
    Write-Host "Found full path to interface folder: $($fullPathToConfigs)`n";

    # FIND XML FILES
    Write-Host "Found XML Files:";
    $networkConfigs = Get-ChildItem $fullPathToConfigs;

    # LOOP THROUGH NETWORK CONFIGS
    for ($j = 0; $j -lt $networkConfigs.Count; $j++) {

        $fullPathToConfig = "$($fullPathToConfigs)\$($networkConfigs[$j])"
        Write-Host "`t$($networkConfigs[$j])";

        # PARSE XML AND GET THE CONFIG
        [xml]$wifiConfig = Get-Content $fullPathToConfig;
        $networkName = $wifiConfig.WLANProfile.name;
        $keyType = $wifiConfig.WLANProfile.MSM.security.sharedKey.keyType;
        $isProtected = $wifiConfig.WLANProfile.MSM.security.sharedKey.protected;
        $keyMaterial = $wifiConfig.WLANProfile.MSM.security.sharedKey.keyMaterial;

        Write-Host "`t`tSSID: $($networkName)";
        Write-Host "`t`tKey Type: $($keytype)";
        Write-Host "`t`tIs Protected? $($isProtected)";
        Write-Host "`t`tKey Material: $($keymaterial)";

        if (!$keymaterial -or !$isProtected -or !$keyMaterial) {
            Write-Host "`t`tMay be an enterprise network! Checking registry for credentials...";
            <#
            User
            HKCU\Software\Microsoft\Wlansvc\UserData\Profiles\[GUID]

            Machine
            HKLM\Software\Microsoft\Wlansvc\UserData\Profiles\[GUID]#>
        }


    }

}