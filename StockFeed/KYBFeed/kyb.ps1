Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSkyb.txt" -Force
$Host.UI.RawUI.WindowTitle = "KYBFeed"

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Dropzone\KYB"
If (!(Test-Path -Path kyb.csv)) {
	"kyb.csv has not been found and may have already been run."
	Start-Sleep 2
	EXIT
}
If (Test-Path -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KYBFeed\Scripts\kyb.csv") {del "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KYBFeed\Scripts\kyb.csv"}
move kyb.csv "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KYBFeed\Scripts"

cd "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
If (Test-Path -Path kyb.txt) {del kyb.txt}

"Processing File"
"OpenAndSave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KYBFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning Files"
# (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KYBFeed\kyb.txt').replace("FALSE`t`t`t`t0`targreplace", "") | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KYBFeed\kyb.txt'
# (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KYBFeed\kyb.txt')|?{$_.Trim(" `t")}|sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KYBFeed\kyb.txt'

"Moving File to Upload folder"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KYBFeed"
move kyb.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
Stop-Transcript
