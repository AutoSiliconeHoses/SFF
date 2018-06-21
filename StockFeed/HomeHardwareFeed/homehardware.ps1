#Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANShh.txt" -Force 
$Host.UI.RawUI.WindowTitle = "HomeHardwareFeed"

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts"
"Acquiring Files"
ftp -s:login.txt 195.74.141.134
move Primary1.csv "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\HomeHardwareFeed"
move Primary15.csv "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\HomeHardwareFeed"

"Combining Files"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\HomeHardwareFeed"
gc *.csv | sc ".\Scripts\homehardware.csv"

If (Test-Path -Path Primary1.csv) {del Primary1.csv}
If (Test-Path -Path Primary15.csv) {del Primary15.csv}

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts"
If (Test-Path -Path hhmacro2.xlsm) {del hhmacro2.xlsm}
copy hhmacro.xlsm hhmacro2.xlsm

"Processing File"
"OpenAndSave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning file"
$textfile = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\HomeHardwareFeed\homehardware.txt'
(gc $textfile).replace("FALSE`t`t`t`t0`targreplace", "").replace("-HH`t`t`t`t0`targreplace", "").replace("stock_no-HH`t`t`t`t50`targreplace", "") | sc $textfile

"Cleaning folder"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\HomeHardwareFeed"
If (Test-Path -Path Primary1.csv) {del Primary1.csv}
If (Test-Path -Path Primary15.csv) {del Primary15.csv}

"Moving File to Upload folder"
move homehardware.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
#Stop-Transcript
