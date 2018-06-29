Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSfebi.txt" -Force
$Host.UI.RawUI.WindowTitle = "FebiFeed"

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FebiFeed\Scripts"
If (Test-Path -Path febi.csv) {del febi.csv}

"Acquiring File"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Dropzone\Febi"
If (!(Test-Path -Path febi.csv)) {
	"febi.csv has not been found and may have already been run."
	Start-Sleep 2
	EXIT
}
move febi.csv "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FebiFeed\Scripts"

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FebiFeed\Scripts"
"Processing File"
(gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FebiFeed\Scripts\febi.csv').replace(";", ",") | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FebiFeed\Scripts\febi.csv'
"OpenAndSave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FebiFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning File"
# (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FebiFeed\febi.txt').replace("FALSE`t`t`t`t0`targreplace", "") | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FebiFeed\febi.txt'
# (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FebiFeed\febi.txt')|?{$_.Trim(" `t")}|sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FebiFeed\febi.txt'


"Moving File to Upload folder"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FebiFeed"
move febi.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
If (Test-Path -Path febi.txt) {del febi.txt}
Stop-Transcript
