If (Test-Path -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSfps.txt") {del "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSfps.txt" -ErrorAction SilentlyContinue}
Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSfps.txt" -Force  -ErrorAction SilentlyContinue
$Host.UI.RawUI.WindowTitle = "FPSFeed"

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\Scripts"
If (Test-Path -Path FPS_LEEDS.xlsx) {del FPS_LEEDS.xlsx}
If (Test-Path -Path FPS_STOCK.csv) {del FPS_STOCK.csv}
If (Test-Path -Path FPS_STOCK.xlsx) {del FPS_STOCK.xlsx}

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

If (Test-Path -Path FPS_STOCK.csv) {del FPS_STOCK.csv}
If (Test-Path -Path fps_leeds.txt) {del fps_leeds.txt}
If (Test-Path -Path fps_stock.txt) {del fps_stock.txt}
If (Test-Path -Path fpscombined.txt) {del fpscombined.txt}

"Moving File to Upload folder"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed"
move *.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload" -ErrorAction SilentlyContinue
Stop-Transcript
