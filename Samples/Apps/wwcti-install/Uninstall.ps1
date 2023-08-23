# Uninstall
$Uninstall = @(

    "/X"
    "{F0B626D7-10F0-4462-9362-B175B868B828}"
	"/q"
)

Start-Process "msiexec.exe" -ArgumentList $Uninstall -Wait -NoNewWindow