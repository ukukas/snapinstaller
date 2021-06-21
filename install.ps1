$installer = Resolve-Path ".\esa-snap_all_windows-x64_8_0.exe"
$varfile = Resolve-Path ".\response.varfile"
$mirror = Resolve-Path ".\step.esa.int"

$snapexe = "C:\Program Files\snap\bin\snap64.exe"
$process = "snap64"

$snap_config_file = Resolve-Path ".\config\snap.properties"
$rcp_config_file = Resolve-Path ".\config\rcp.properties"
$autoupdate_config_file = Resolve-Path ".\config\autoupdate.properties"

$snap_config_dir = "C:\Users\Default\.snap\etc"
$rcp_config_dir = "C:\Users\Default\AppData\Roaming\SNAP\config\Preferences\org\esa\snap\snap"
$autoupdate_config_dir = "C:\Users\Default\AppData\Roaming\SNAP\config\Preferences\org\netbeans\modules"

Start-Process -FilePath $installer -ArgumentList "-q -varfile $varfile" -NoNewWindow -Wait

New-Item -Path $snap_config_dir -ItemType "directory" -Force
New-Item -Path $rcp_config_dir -ItemType "directory" -Force
New-Item -Path $autoupdate_config_dir -ItemType "directory" -Force

Copy-Item -Path $snap_config_file -Destination $snap_config_dir -Force
Copy-Item -Path $rcp_config_file -Destination $rcp_config_dir -Force
Copy-Item -Path $autoupdate_config_file -Destination $autoupdate_config_dir -Force

$core_update_filename = "snap_update_center.properties"
$toolboxes_update_filename = "snap_toolboxes_update_center.properties"
$supported_update_filename = "snap_supported_plugins_update_center.properties"
$community_update_filename = "snap_community_plugins_update_center.properties"

$core_update_xml = Join-Path $mirror "updatecenter\8.0\snap\updates.xml.gz"
$toolboxes_update_xml = Join-Path $mirror "updatecenter\8.0\snap-toolboxes\updates.xml.gz"
$supported_update_xml = Join-Path $mirror "updatecenter\8.0\snap-supported-plugins\updates.xml.gz"
$community_update_xml = Join-Path $mirror "updatecenter\8.0\snap-community-plugins\updates.xml.gz"

$core_update_content = "url=file:/" + ($core_update_xml -replace "\\","/")
$toolboxes_update_content = "url=file:/" + ($toolboxes_update_xml -replace "\\","/")
$supported_update_content = "url=file:/" + ($supported_update_xml -replace "\\","/")
$community_update_content = "url=file:/" + ($community_update_xml -replace "\\","/")

$update_config_dir = Join-Path $env:APPDATA "SNAP\config\Preferences\org\netbeans\modules\autoupdate"

New-Item -Path (Join-Path $update_config_dir $core_update_filename) -ItemType "file" -Value $core_update_content -Force
New-Item -Path (Join-Path $update_config_dir $toolboxes_update_filename) -ItemType "file" -Value $toolboxes_update_content -Force
New-Item -Path (Join-Path $update_config_dir $supported_update_filename) -ItemType "file" -Value $supported_update_content -Force
New-Item -Path (Join-Path $update_config_dir $community_update_filename) -ItemType "file" -Value $community_update_content -Force

& "$snapexe --console suppress --nosplash --nogui --modules --update-all" | ForEach-Object {
    if ($_ -eq "updates=0") {
        Get-Process -Name $process -ErrorAction SilentlyContinue | Stop-Process -Force
    }
}

Remove-Item -Path (Join-Path $env:APPDATA "SNAP") -Recurse -Force