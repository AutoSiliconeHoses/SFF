Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSfebi.txt" -Force -NoClobber
$Host.UI.RawUI.WindowTitle = "FebiFeed"
Z:
cd "Z:\Stock File Fetcher\StockFeed\GUI\Dropzone\Febi
copy febi.csv "Z:\Stock File Fetcher\StockFeed\FebiFeed\Scripts"

cd "Z:\Stock File Fetcher\Upload"
If (Test-Path -Path febi.txt) {del febi.txt}

"Processing File"
"OpenAndSave.ps1"
& "Z:\Stock File Fetcher\StockFeed\FebiFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning Files"
(gc 'Z:\Stock File Fetcher\StockFeed\FebiFeed\febi.txt').replace("FALSE`t`t`t`t0`targreplace", "") | sc 'Z:\Stock File Fetcher\StockFeed\FebiFeed\febi.txt'
(gc 'Z:\Stock File Fetcher\StockFeed\FebiFeed\febi.txt')|?{$_.Trim(" `t")} | sc 'Z:\Stock File Fetcher\StockFeed\FebiFeed\febi.txt'

"Moving File to Upload folder"
cd "Z:\Stock File Fetcher\StockFeed\FebiFeed"
move febi.txt "Z:\Stock File Fetcher\Upload"
Stop-Transcript
