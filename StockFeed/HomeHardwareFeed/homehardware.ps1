$Host.UI.RawUI.WindowTitle = "HomeHardwareFeed"
Set-PSDebug -Trace 2
Z:
cd "Z:\Stock File Fetcher\Upload"
If (Test-Path -Path homehardware.txt) {del homehardware.txt}

cd "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts"
If (Test-Path -Path combine.csv) {del combine.csv}

ftp -s:login.txt 195.74.141.134
move Primary1.csv "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed"
move Primary15.csv "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed"

cd "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed"
copy *.csv combine.csv
move combine.csv "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts"
If (Test-Path -Path Primary1.csv) {del Primary1.csv}
If (Test-Path -Path Primary15.csv) {del Primary15.csv}

If (Test-Path -Path macro2.xlsm) {del macro2.xlsm}
copy macro.xlsm macro2.xlsm

"RunMacro.ps1"
& "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\RunMacro.ps1" /C
"SaveAsTxt.ps1"
& "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\SaveAsTxt.ps1" /C

(Get-Content 'Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\homehardware.txt').replace("FALSE`t`t`t`t0`t4", "") | Set-Content 'Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\homehardware.txt'
(Get-Content 'Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\homehardware.txt').replace("?stock_no-HH`t`t`t`t0`t4", "") | Set-Content 'Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\homehardware.txt'
(Get-Content 'Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\homehardware.txt').replace("?-HH`t`t`t`t0`t4`t`t`t`t`t`t", "") | Set-Content 'Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\homehardware.txt'
(Get-Content 'Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\homehardware.txt').replace("#VALUE!`t`t`t`t0`t4", "") | Set-Content 'Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\homehardware.txt'

cd "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed"
findstr "[[A-Z] [0-9] ,]" homehardware.txt > homehardwaregrep.txt
If (Test-Path -Path homehardware.txt) {del homehardware.txt}
Rename-Item homehardwaregrep.txt homehardware.txt
If (Test-Path -Path homehardwaregrep.txt) {del homehardwaregrep.txt}

move homehardware.txt "Z:\Stock File Fetcher\Upload"

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
echo .>> homehardware.txt
