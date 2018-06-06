$Host.UI.RawUI.WindowTitle = "DraperFeed"
Z:
cd "Z:\Stock File Fetcher\StockFeed\DraperFeed\Scripts"

"Acquiring File"
ftp -s:login.txt 62.255.240.235
If (Test-Path -Path draper.csv) {del draper.csv}
Rename-Item stock.csv draper.csv

"Processing File"
"OpenAndSave.ps1"
& "Z:\Stock File Fetcher\StockFeed\DraperFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning File"
(cat 'Z:\Stock File Fetcher\StockFeed\DraperFeed\draper.txt').replace("FALSE`t`t`t`t0`targreplace", "") | sc 'Z:\Stock File Fetcher\StockFeed\DraperFeed\draper.txt'

"Moving File to Upload folder"
cd "Z:\Stock File Fetcher\StockFeed\DraperFeed"
move draper.txt "Z:\Stock File Fetcher\Upload"
