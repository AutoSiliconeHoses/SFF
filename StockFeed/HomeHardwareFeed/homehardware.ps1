$Host.UI.RawUI.WindowTitle = "HomeHardwareFeed"
Z:
cd "Z:\Stock File Fetcher\Upload"
If (Test-Path -Path homehardware.txt) {del homehardware.txt}

cd "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts"
If (Test-Path -Path combine.csv) {del combine.csv}

"Acquiring Files"
ftp -s:login.txt 195.74.141.134
move Primary1.csv "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed"
move Primary15.csv "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed"

"Combining Files"
cd "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed"
cat *.csv | sc ".\Scripts\combine.csv"

If (Test-Path -Path Primary1.csv) {del Primary1.csv}
If (Test-Path -Path Primary15.csv) {del Primary15.csv}

cd "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts"
If (Test-Path -Path macro2.xlsm) {del macro2.xlsm}
copy macro.xlsm macro2.xlsm

"Processing File"
"OpenAndSave.ps1"
& "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning file"
(cat 'Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\homehardware.txt').replace("FALSE`t`t`t`t0`targreplace", "") | sc 'Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\homehardware.txt'
(cat 'Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\homehardware.txt').replace("-HH`t`t`t`t0`targreplace", "") | sc 'Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\homehardware.txt'
(cat 'Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\homehardware.txt').replace("stock_no-HH`t`t`t`t0`targreplace", "") | sc 'Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\homehardware.txt'

cd "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed"
findstr "[[A-Z] [0-9] ,]" homehardware.txt > homehardwaregrep.txt
If (Test-Path -Path homehardware.txt) {del homehardware.txt}
Rename-Item homehardwaregrep.txt homehardware.txt
If (Test-Path -Path homehardwaregrep.txt) {del homehardwaregrep.txt}

"Moving File to Upload folder"
move homehardware.txt "Z:\Stock File Fetcher\Upload"
