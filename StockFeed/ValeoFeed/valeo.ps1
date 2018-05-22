$Host.UI.RawUI.WindowTitle = 'ValeoFeed'
Z:
cd "Z:\Stock File Fetcher\StockFeed\GUI\Dropzone\Valeo"
"Acquiring File"
copy "VALEO_stock.csv" "Z:\Stock File Fetcher\StockFeed\ValeoFeed\Scripts"

cd "Z:\Stock File Fetcher\Upload"
If (Test-Path -Path 'valeo.txt') {del valeo.txt}

cd "Z:\Stock File Fetcher\StockFeed\ValeoFeed\Scripts"
"Processing File"
"OpenAndsave.ps1"
& "Z:\Stock File Fetcher\StockFeed\ValeoFeed\Scripts\OpenAndSave.ps1" /C
"SaveAsTxt.ps1"
& "Z:\Stock File Fetcher\StockFeed\ValeoFeed\Scripts\SaveAsTxt.ps1" /C

"Cleaning File"
(Cat 'Z:\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt').replace("FALSE`t`t`t`t0`t4", "") | SC 'Z:\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt'
(Cat 'Z:\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt').replace("#VALUE!`t`t`t`t20`t4", "") | SC 'Z:\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt'
(Cat 'Z:\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt').replace("C`t`t`t`t20`t4", "") | SC 'Z:\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt'

cd "Z:\Stock File Fetcher\StockFeed\ValeoFeed"
findstr "[[A-Z] [0-9] ,]" valeo.txt > valeogrep.txt
del valeo.txt

Rename-Item valeogrep.txt valeo.txt
If (Test-Path -Path "valeo.txt") {del toolbank.txt}

"Moving File to Upload folder"
move valeo.txt "Z:\Stock File Fetcher\Upload"
