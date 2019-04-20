FPSIf (Test-Path -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSfps.txt") {del "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSfps.txt" -ErrorAction SilentlyContinue}
Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSfps.txt" -Force  -ErrorAction SilentlyContinue
$Host.UI.RawUI.WindowTitle = "FPSFeed"

Function alter($sku,$edit) {
  (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\fps_leeds.txt') -replace "$sku`t`t`t`t.+", "$sku`t`t`t`t$edit`targreplace" | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\fps_leeds.txt'
  (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\fps_stock.txt') -replace "$sku`t`t`t`t.+", "$sku`t`t`t`t$edit`targreplace" | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\fps_stock.txt'
}

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\Scripts"
If (Test-Path -Path FPS_LEEDS.xlsx) {del FPS_LEEDS.xlsx}
If (Test-Path -Path FPS_STOCK.csv) {del FPS_STOCK.csv}
If (Test-Path -Path FPS_STOCK.xlsx) {del FPS_STOCK.xlsx}
If (Test-Path -Path fps_complete.csv) {del fps_complete.csv}

"Acquiring File"
move "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Dropzone\FPS\FPS_LEEDS.xlsx" "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\Scripts" -ErrorAction SilentlyContinue
move "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Dropzone\FPS\FPS_STOCK.csv" "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\Scripts" -ErrorAction SilentlyContinue

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\Scripts"
If (!(Test-Path -Path FPS_LEEDS.xlsx)) {"FPS_LEEDS.xlsx has not been found and may have already been run."}
If (Test-Path -Path FPS_LEEDS.xlsx) {
	"FPS_LEEDS.xlsx found."
	"OpenAndSave.ps1"
	& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\Scripts\OpenAndSave.ps1" /C
}

If (!(Test-Path -Path FPS_STOCK.csv)) {"FPS_STOCK.csv has not been found and may have already been run."}
If (Test-Path -Path FPS_STOCK.csv) {
	"FPS_STOCK.csv found."
	"OpenAndSave2.ps1"
	& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\Scripts\OpenAndSave2.ps1" /C
}

# cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed"
# gc fps_stock.scv,fps_leeds.csv | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\fps_complete.csv'

"Cleaning File"
Import-CSV "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\alterations.csv" | select sku,qty | ? {$_.sku.endswith("-FPS")} | % {alter $_.sku $_.qty}

If (Test-Path -Path FPS_STOCK.csv) {del FPS_STOCK.csv}
If (Test-Path -Path fps_leeds.txt) {del fps_leeds.txt}
If (Test-Path -Path fps_stock.txt) {del fps_stock.txt}
If (Test-Path -Path fpscombined.txt) {del fpscombined.txt}

"Moving File to Upload folder"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed"
If (Test-Path -Path "\\DISKSTATION\Feeds\Dropship\Scripts\FPS\FPS.txt") {del "\\DISKSTATION\Feeds\Dropship\Scripts\FPS\FPS.txt"}
copy "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\fps_stock.txt" "\\DISKSTATION\Feeds\Dropship\Scripts\FPS\FPS.txt"
move *.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload" -ErrorAction SilentlyContinue
Stop-Transcript
