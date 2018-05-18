$Host.UI.RawUI.WindowTitle = "DraperFeed"
Z:
cd "Z:\Stock File Fetcher\StockFeed\DraperFeed\Scripts"

"Acquiring File"
ftp -s:login.txt 62.255.240.235

"Processing File"
"OpenAndSave.ps1"
& "Z:\Stock File Fetcher\StockFeed\DraperFeed\Scripts\OpenAndSave.ps1" /C
"SaveAsTxt.ps1"
& "Z:\Stock File Fetcher\StockFeed\DraperFeed\Scripts\SaveAsTxt.ps1" /C

"Cleaning File"
(cat 'Z:\Stock File Fetcher\StockFeed\DraperFeed\draper.txt').replace("FALSE`t`t`t`t0`t4", "") | sc 'Z:\Stock File Fetcher\StockFeed\DraperFeed\draper.txt'

cd "Z:\Stock File Fetcher\StockFeed\DraperFeed"
findstr "[[A-Z] [0-9] ,]" draper.txt > drapergrep.txt

If (Test-Path -Path draper.txt) {del draper.txt}
Rename-Item drapergrep.txt draper.txt
del drapergrep.txt

"Moving File to Upload folder"
move draper.txt "Z:\Stock File Fetcher\Upload"

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
New-Item draper.txt -ItemType file
1
