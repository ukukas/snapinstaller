$installer = Resolve-Path ".\esa-snap_all_windows-x64_8_0.exe"
$varfile = Resolve-Path ".\response.varfile"

$snap_config_file = Resolve-Path ".\config\snap.properties"
$rcp_config_file = Resolve-Path ".\config\rcp.properties"
$update_config_file = Resolve-Path ".\config\autoupdate.properties"

$snap_config_dir = "C:\Users\Default\.snap\etc"
$rcp_config_dir = "C:\Users\Default\AppData\Roaming\SNAP\config\Preferences\org\esa\snap\snap"
$update_config_dir = "C:\Users\Default\AppData\Roaming\SNAP\config\Preferences\org\netbeans\modules"

$arglist = "-q -varfile $varfile"

Start-Process -FilePath $installer -ArgumentList $arglist -NoNewWindow -Wait

New-Item -Path $snap_config_dir -ItemType "directory" -Force
New-Item -Path $rcp_config_dir -ItemType "directory" -Force
New-Item -Path $update_config_dir -ItemType "directory" -Force

Copy-Item -Path $snap_config_file -Destination $snap_config_dir -Force
Copy-Item -Path $rcp_config_file -Destination $rcp_config_dir -Force
Copy-Item -Path $update_config_file -Destination $update_config_dir -Force
