param (
	[string]$videoName = (Read-Host "Video Name:")
)

function Get-Clipboard([switch] $Lines) {
	if($Lines) {
		$cmd = {
			Add-Type -Assembly PresentationCore
			[Windows.Clipboard]::GetText() -replace "`r", '' -split "`n"
		}
	} else {
		$cmd = {
			Add-Type -Assembly PresentationCore
			[Windows.Clipboard]::GetText()
		}
	}
	if([threading.thread]::CurrentThread.GetApartmentState() -eq 'MTA') {
		& powershell -Sta -Command $cmd
	} else {
		& $cmd
	}
}

$source = (Get-Clipboard)
$url = [System.Text.RegularExpressions.Regex]::Match($source, "(?<=hd_src_no_ratelimit:`")[^`"]+")

Write-Host $url

Invoke-WebRequest -Outfile "$videoName.mp4" -Uri "$url" -TimeoutSec 600
