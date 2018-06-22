Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSdraper.txt" -Force 
$Host.UI.RawUI.WindowTitle = "DraperFeed"

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\Scripts"

"Acquiring File"
ftp -s:login.txt 62.255.240.235
If (Test-Path -Path draper.csv) {del draper.csv}
Rename-Item stock.csv draper.csv

"Processing File"
"OpenAndSave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning File"
(gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\draper.txt').replace("FALSE`t`t`t`t0`targreplace", "") | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\draper.txt'

"Moving File to Upload folder"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed"
move draper.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
Stop-Transcript
