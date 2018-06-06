$Host.UI.RawUI.WindowTitle = "HomeHardwareFeed"
Z:
cd "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts"
"Acquiring Files"
ftp -s:login.txt 195.74.141.134
move Primary1.csv "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed"
move Primary15.csv "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed"

"Combining Files"
cd "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed"
cat *.csv | sc ".\Scripts\homehardware.csv"

If (Test-Path -Path Primary1.csv) {del Primary1.csv}
If (Test-Path -Path Primary15.csv) {del Primary15.csv}

cd "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts"
If (Test-Path -Path hhmacro2.xlsm) {del hhmacro2.xlsm}
copy hhmacro.xlsm hhmacro2.xlsm

"Processing File"
"OpenAndSave.ps1"
& "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning file"
(cat 'Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\homehardware.txt').replace("FALSE`t`t`t`t0`targreplace", "").replace("-HH`t`t`t`t0`targreplace", "").replace("stock_no-HH`t`t`t`t0`targreplace", "") | sc 'Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\homehardware.txt'

"Cleaning folder"
cd "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed"
If (Test-Path -Path Primary1.csv) {del Primary1.csv}
If (Test-Path -Path Primary15.csv) {del Primary15.csv}

"Moving File to Upload folder"
move homehardware.txt "Z:\Stock File Fetcher\Upload"
