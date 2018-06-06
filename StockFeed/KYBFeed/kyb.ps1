$Host.UI.RawUI.WindowTitle = "KYBFeed"
Z:
cd "Z:\Stock File Fetcher\StockFeed\GUI\Dropzone\KYB"
copy kyb.csv "Z:\Stock File Fetcher\StockFeed\KYBFeed\Scripts"

cd "Z:\Stock File Fetcher\Upload"
If (Test-Path -Path kyb.txt) {del kyb.txt}

"Processing File"
"OpenAndSave.ps1"
& "Z:\Stock File Fetcher\StockFeed\KYBFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning Files"
(Get-Content 'Z:\Stock File Fetcher\StockFeed\KYBFeed\kyb.txt').replace("FALSE`t`t`t`t0`targreplace", "") | Set-Content 'Z:\Stock File Fetcher\StockFeed\KYBFeed\kyb.txt'
(GC 'Z:\Stock File Fetcher\StockFeed\KYBFeed\kyb.txt')|?{$_.Trim(" `t")}|SC 'Z:\Stock File Fetcher\StockFeed\KYBFeed\kyb.txt'

"Moving File to Upload folder"
cd "Z:\Stock File Fetcher\StockFeed\KYBFeed"
move kyb.txt "Z:\Stock File Fetcher\Upload"
