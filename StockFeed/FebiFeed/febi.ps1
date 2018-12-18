Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSfebi.txt" -Force
$Host.UI.RawUI.WindowTitle = $title = "FebiFeed"

Function alter($sku,$edit) {
  (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FebiFeed\febi.txt') -replace "$sku`t`t`t`t.+", "$sku`t`t`t`t$edit`targreplace" | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FebiFeed\febi.txt'
}

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FebiFeed\Scripts"
If (Test-Path -Path febi.csv) {del febi.csv}

"Acquiring File"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Dropzone\Febi"
If (!(Test-Path -Path febi.csv)) {
	"febi.csv has not been found and may have already been run."
	sleep 2
	EXIT
}
move febi.csv "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FebiFeed\Scripts"

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FebiFeed\Scripts"
"Processing File"
(gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FebiFeed\Scripts\febi.csv').replace(";", ",") | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FebiFeed\Scripts\febi.csv'
"OpenAndSave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FebiFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning File"
Import-CSV "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\alterations.csv" | select sku,qty | % {alter $_.sku $_.qty}

"Moving File to Upload folder"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FebiFeed"
If (Test-Path -Path "\\DISKSTATION\Feeds\Dropship\Scripts\FI\FI.txt") {del "\\DISKSTATION\Feeds\Dropship\Scripts\FI\FI.txt"}
copy "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FebiFeed\febi.txt" "\\DISKSTATION\Feeds\Dropship\Scripts\FI\FI.txt"
move "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FebiFeed\febi.txt" "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
Stop-Transcript
