Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSkilen.txt" -Force
$Host.UI.RawUI.WindowTitle = $title = "KilenFeed"

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KilenFeed\Scripts"
If (Test-Path -Path kilen.csv) {del kilen.csv}

"Acquiring File"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Dropzone\Kilen"
If (!(Test-Path -Path kilen.csv)) {
	"kilen.csv has not been found and may have already been run."
	Start-Sleep 2
	EXIT
}
move kilen.csv "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KilenFeed\Scripts"

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KilenFeed\Scripts"
"Processing File"
(gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KilenFeed\Scripts\kilen.csv').replace(";", ",") | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KilenFeed\Scripts\kilen.csv'
"OpenAndSave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KilenFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning File"
(gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KilenFeed\kilen.txt').replace("FALSE`t`t`t`t0`targreplace", "") | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KilenFeed\kilen.txt'
(gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KilenFeed\kilen.txt')|?{$_.Trim(" `t")}|sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KilenFeed\kilen.txt'


"Moving File to Upload folder"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KilenFeed"
move kilen.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
If (Test-Path -Path kilen.txt) {del kilen.txt}
Stop-Transcript
