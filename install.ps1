$installer = Resolve-Path ".\esa-snap_all_windows-x64_8_0.exe"
$varfile = Resolve-Path ".\response.varfile"

$arglist = "-q -varfile $varfile"

Start-Process -FilePath $installer -ArgumentList $arglist -NoNewWindow -Wait