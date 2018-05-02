TITLE DraperFeed
Z:
cd "Z:\Stock File Fetcher\StockFeed\DraperFeed\Scripts"
ftp -s:login.txt 62.255.240.235

%comspec% /C "Z:\Stock File Fetcher\StockFeed\DraperFeed\Scripts\SaveAsTxt.vbs"

"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\StockFeed\DraperFeed" --fileMask "*draper.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "FALSE				0	5" --replace ""

cd "Z:\Stock File Fetcher\StockFeed\DraperFeed"
findstr "[[A-Z] [0-9] ,]" draper.txt > drapergrep.txt
del draper.txt
ren drapergrep.txt draper.txt
del drapergrep.txt

move draper.txt "Z:\Stock File Fetcher\Upload"

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
echo .>> draper.txt
