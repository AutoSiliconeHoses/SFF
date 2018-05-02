TITLE HomeHardwareFeed
Z:
cd "Z:\Stock File Fetcher\Upload"
If exist homehardware.txt del homehardware.txt

cd "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts"
if exist combine.csv del combine.csv

ftp -s:login.txt 195.74.141.134

move Primary1.csv "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed"
move Primary15.csv "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed"
cd "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed"
copy *.csv combine.csv
move combine.csv "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts"
del Primary1.csv
del Primary15.csv

cd "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts"
"Z:\Stock File Fetcher\StockFeed\Programs\csv2xlsx_386.exe" -infile combine.csv -outfile combine.xlsx -colsep ","

%comspec% /C "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\OpenAndSave.vbs"
%comspec% /C "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\OpenAndSave2.vbs"

if exist macro2.xlsm (del macro2.xlsm)
copy macro.xlsm macro2.xlsm

%comspec% /C "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\RunMacro.vbs"
%comspec% /C "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\SaveAsTxt.vbs"

"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed" --fileMask "*homehardware.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "FALSE				0	5" --replace ""
"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed" --fileMask "*homehardware.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "?stock_no-HH				0	5" --replace ""
"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed" --fileMask "*homehardware.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "?-HH				0	5						" --replace ""
"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed" --fileMask "*homehardware.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "#VALUE!				0	5" --replace ""

cd "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed"
findstr "[[A-Z] [0-9] ,]" homehardware.txt > homehardwaregrep.txt
del homehardware.txt
ren homehardwaregrep.txt homehardware.txt
del homehardwaregrep.txt
move homehardware.txt "Z:\Stock File Fetcher\Upload"

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
echo .>> homehardware.txt
