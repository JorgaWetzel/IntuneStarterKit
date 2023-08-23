try{
	$EXE_url = "https://wwcom.ch/downloads/cti.msi"
	$EXE_meta = Invoke-WebRequest -method "Head" $EXE_url | Select Headers -ExpandProperty Headers

	$EXE_onlineDT = [DateTime]::ParseExact($($EXE_meta."Last-Modified"), "ddd, dd MMM yyyy HH:mm:ss 'GMT'", [System.Globalization.CultureInfo]::InvariantCulture)
	$EXE_onlineDTS = $EXE_onlineDT.ToString("yyyy-MM-dd")

	$EXE_uninstall = Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object{$_.Publisher -eq "wwcom ag"}
	if(!$EXE_uninstall){
		Write-Output "cti not installed"
		exit 1
	}
	$EXE_installDT = [DateTime]::ParseExact($($EXE_uninstall.InstallDate), "yyyyMMdd", $null)
	$EXE_installDTS = $EXE_installDT.ToString("yyyy-MM-dd")

	if($EXE_onlineDTS -gt $EXE_installDTS){
		Write-Output "cti update available"
		exit 1
	}else{
		Write-Output "cti is up-to-date"
		exit 0
	}

}catch{
	Write-Error $_
}