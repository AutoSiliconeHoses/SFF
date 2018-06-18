#Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSkilen.txt" -Force -NoClobber
$Host.UI.RawUI.WindowTitle = "KilenFeed"
Z:
cd "Z:\Stock File Fetcher\StockFeed\KilenFeed\Scripts"
If (Test-Path -Path kilen.csv) {del kilen.csv}

"Acquiring File"
cd "Z:\Stock File Fetcher\StockFeed\GUI\Dropzone\Kilen"
copy kilen.csv "Z:\Stock File Fetcher\StockFeed\KilenFeed\Scripts"

cd "Z:\Stock File Fetcher\StockFeed\KilenFeed\Scripts"
"Processing File"
(cat 'Z:\Stock File Fetcher\StockFeed\KilenFeed\Scripts\kilen.csv').replace(";", ",") | sc 'Z:\Stock File Fetcher\StockFeed\KilenFeed\Scripts\kilen.csv'
"OpenAndSave.ps1"
& "Z:\Stock File Fetcher\StockFeed\KilenFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning File"
(cat 'Z:\Stock File Fetcher\StockFeed\KilenFeed\kilen.txt').replace("FALSE`t`t`t`t0`targreplace", "") | sc 'Z:\Stock File Fetcher\StockFeed\KilenFeed\kilen.txt'
(GC 'Z:\Stock File Fetcher\StockFeed\KilenFeed\kilen.txt')|?{$_.Trim(" `t")}|SC 'Z:\Stock File Fetcher\StockFeed\KilenFeed\kilen.txt'


"Moving File to Upload folder"
cd "Z:\Stock File Fetcher\StockFeed\KilenFeed"
move kilen.txt "Z:\Stock File Fetcher\Upload"
If (Test-Path -Path kilen.txt) {del kilen.txt}
#Stop-Transcript
