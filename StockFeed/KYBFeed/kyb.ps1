Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSkyb.txt" -Force
$Host.UI.RawUI.WindowTitle = "KYBFeed"

Function alter($sku,$edit) {
  (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\HomeHardwareFeed\homehardware.txt') -replace "$sku`t`t`t`t.+", "$sku`t`t`t`t$edit`targreplace" | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\HomeHardwareFeed\homehardware.txt'
}

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Dropzone\KYB"
If (!(Test-Path -Path kyb.csv)) {
	"kyb.csv has not been found and may have already been run."
	sleep 2
	EXIT
}
If (Test-Path -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KYBFeed\Scripts\kyb.csv") {del "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KYBFeed\Scripts\kyb.csv"}
move kyb.csv "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KYBFeed\Scripts"

cd "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
If (Test-Path -Path kyb.txt) {del kyb.txt}

"Processing File"
"OpenAndSave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KYBFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning File"
Import-CSV "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\alterations.csv" | select sku,qty | ? {$_.sku.endswith("-KYB")} | % {alter $_.sku $_.qty}

"Moving File to Upload folder"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KYBFeed"
If (Test-Path -Path "\\DISKSTATION\Feeds\Dropship\Scripts\KB\KB.txt") {del "\\DISKSTATION\Feeds\Dropship\Scripts\KB\KB.txt"}
copy "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KYBFeed\kyb.txt" "\\DISKSTATION\Feeds\Dropship\Scripts\KB\KB.txt"
move "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KYBFeed\kyb.txt" "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
Stop-Transcript
