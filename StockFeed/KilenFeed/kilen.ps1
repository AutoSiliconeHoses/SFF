#Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSkilen.txt" -Force -NoClobber
$Host.UI.RawUI.WindowTitle = "KilenFeed"

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KilenFeed\Scripts"
If (Test-Path -Path kilen.csv) {del kilen.csv}

"Acquiring File"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Dropzone\Kilen"
copy kilen.csv "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KilenFeed\Scripts"

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KilenFeed\Scripts"
"Processing File"
(cat '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KilenFeed\Scripts\kilen.csv').replace(";", ",") | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KilenFeed\Scripts\kilen.csv'
"OpenAndSave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KilenFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning File"
(cat '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KilenFeed\kilen.txt').replace("FALSE`t`t`t`t0`targreplace", "") | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KilenFeed\kilen.txt'
(GC '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KilenFeed\kilen.txt')|?{$_.Trim(" `t")}|SC '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KilenFeed\kilen.txt'


"Moving File to Upload folder"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KilenFeed"
move kilen.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
If (Test-Path -Path kilen.txt) {del kilen.txt}
#Stop-Transcript
