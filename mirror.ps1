$wget = Resolve-Path ".\wget.exe"
$url = "http://step.esa.int/updatecenter/8.0/"
$reject = "index*"

$arglist = "--mirror --no-parent --reject $reject $url"

Start-Process -FilePath $wget -ArgumentList $arglist -NoNewWindow -Wait