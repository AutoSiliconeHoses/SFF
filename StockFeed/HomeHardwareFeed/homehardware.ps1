$Host.UI.RawUI.WindowTitle = "HomeHardwareFeed"
Z:
cd "Z:\Stock File Fetcher\Upload"
If (Test-Path -Path homehardware.txt) {del homehardware.txt}

cd "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts"
If (Test-Path -Path combine.csv) {del combine.csv}

ftp -s:login.txt 195.74.141.134
move Primary1.csv "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed"
move Primary15.csv "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed"

cd "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed"
cat *.csv | sc ".\Scripts\combine.csv"

If (Test-Path -Path Primary1.csv) {del Primary1.csv}
If (Test-Path -Path Primary15.csv) {del Primary15.csv}

cd "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts"
If (Test-Path -Path macro2.xlsm) {del macro2.xlsm}
copy macro.xlsm macro2.xlsm

"RunMacro.ps1"
& "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\RunMacro.ps1" /C
"SaveAsTxt.ps1"
& "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\SaveAsTxt.ps1" /C

"Cleaning file"
If (Test-Path -Path macro2.xlsm) {del macro2.xlsm}

(cat 'Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\homehardware.txt').replace("FALSE`t`t`t`t0`t4", "") | sc 'Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\homehardware.txt'
(cat 'Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\homehardware.txt').replace("-TL`t`t`t`t0`t4", "") | sc 'Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\homehardware.txt'

cd "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed"
findstr "[[A-Z] [0-9] ,]" homehardware.txt > homehardwaregrep.txt
If (Test-Path -Path homehardware.txt) {del homehardware.txt}
Rename-Item homehardwaregrep.txt homehardware.txt
If (Test-Path -Path homehardwaregrep.txt) {del homehardwaregrep.txt}

move homehardware.txt "Z:\Stock File Fetcher\Upload"

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
New-Item homehardware.txt -ItemType file
