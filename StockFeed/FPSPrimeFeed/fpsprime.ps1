If (Test-Path -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSfpsprime.txt") {del "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSfpsprime.txt" -ErrorAction SilentlyContinue}
Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSfpsprime.txt" -Force  -ErrorAction SilentlyContinue
$Host.UI.RawUI.WindowTitle = "FPSPrimeFeed"

Function alter($sku,$edit) {
  (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\fpsleedsprime.txt') -replace "$sku`t`t`t`t.+", "$sku`t`t`t`t$edit`targreplace" | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\fpsleedsprime.txt'
}

$thistime = (Get-Date).Hour
$day = (Get-Date).DayOfWeek.Value__
$timecheck = (7 -le $thistime) -and ($thistime -lt 12)
$daycheck = (1 -le $day) -and ($day -le 5)
$working = $timecheck -and $daycheck

# $working = $FALSE

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSPrimeFeed\Scripts"
If (Test-Path -Path FPS_LEEDS.xlsx) {del FPS_LEEDS.xlsx}

"Acquiring File"
copy "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Dropzone\FPS Prime\FPS_LEEDS.xlsx" "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSPrimeFeed\Scripts" -ErrorAction SilentlyContinue

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSPrimeFeed\Scripts"
If (!(Test-Path -Path FPS_LEEDS.xlsx)) {"FPS_LEEDS.xlsx has not been found and may have already been run."}
If (Test-Path -Path FPS_LEEDS.xlsx) {
	"FPS_LEEDS.xlsx found."
	If (!$working) {
		"OpenAndSave.ps1"
		& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSPrimeFeed\Scripts\OpenAndSave.ps1" /C
	}
	If ($working) {
		"SaveZero.ps1"
		& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSPrimeFeed\Scripts\SaveZero.ps1" /C
	}
}

If (Test-Path -Path FPS_LEEDS.txt) {del FPS_LEEDS.txt}

"Cleaning File"
Import-CSV "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\alterations.csv" | select sku,qty | ? {$_.sku.endswith("-FPS-PRIME")} | % {alter $_.sku $_.qty}

"Moving File to Upload folder"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSPrimeFeed"
move *.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload" -ErrorAction SilentlyContinue
Stop-Transcript
