Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSkyb.txt" -Force
$Host.UI.RawUI.WindowTitle = $title = "KYBFeed"

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

"Moving File to Upload folder"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KYBFeed"
move kyb.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
Stop-Transcript
