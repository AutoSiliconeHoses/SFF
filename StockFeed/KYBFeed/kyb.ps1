$Host.UI.RawUI.WindowTitle = "KYBFeed"
Z:
cd "Z:\Stock File Fetcher\StockFeed\GUI\Dropzone\KYB"
copy "KYBSTOCK.csv" "Z:\Stock File Fetcher\StockFeed\KYBFeed\Scripts"

cd "Z:\Stock File Fetcher\Upload"
If (Test-Path -Path kyb.txt) {del kyb.txt}

"Processing File"
"OpenAndSave.ps1"
& "Z:\Stock File Fetcher\StockFeed\KYBFeed\Scripts\OpenAndSave.ps1" /C
"SaveAsTxt.ps1"
& "Z:\Stock File Fetcher\StockFeed\KYBFeed\Scripts\SaveAsTxt.ps1" /C

"Cleaning Files"
(Get-Content 'Z:\Stock File Fetcher\StockFeed\KYBFeed\kyb.txt').replace("FALSE`t`t`t`t0`t4", "") | Set-Content 'Z:\Stock File Fetcher\StockFeed\KYBFeed\kyb.txt'

cd "Z:\Stock File Fetcher\StockFeed\KYBFeed"
findstr "[[A-Z] [0-9] ,]" kyb.txt > kybgrep.txt

If (Test-Path -Path kyb.txt) {del kyb.txt}
Rename-Item kybgrep.txt kyb.txt
If (Test-Path -Path kybgrep.txt) {del kybgrep.txt}

"Moving File to Upload folder"
move kyb.txt "Z:\Stock File Fetcher\Upload"

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
New-Item kyb.txt -ItemType file
"Succesful"
