$Host.UI.RawUI.WindowTitle = 'ValeoFeed'
Z:
cd "Z:\Stock File Fetcher\StockFeed\GUI\Dropzone\Valeo"

copy "VALEO_stock.csv" "Z:\Stock File Fetcher\StockFeed\ValeoFeed\Scripts"

cd "Z:\Stock File Fetcher\Upload"
If (Test-Path -Path 'valeo.txt') {del valeo.txt}

"OpenAndsave2.ps1"
& "Z:\Stock File Fetcher\StockFeed\ValeoFeed\Scripts\OpenAndSave2.ps1" /C
"OpenAndsave.ps1"
& "Z:\Stock File Fetcher\StockFeed\ValeoFeed\Scripts\OpenAndSave.ps1" /C
"SaveAsTxt.ps1"
& "Z:\Stock File Fetcher\StockFeed\ValeoFeed\Scripts\SaveAsTxt.ps1" /C

"Cleaning Files"
(Cat 'Z:\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt').replace("FALSE`t`t`t`t0`t4", "") | SC 'Z:\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt'
(Cat 'Z:\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt').replace("#VALUE!`t`t`t`t20`t4", "") | SC 'Z:\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt'
(Cat 'Z:\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt').replace("C`t`t`t`t20`t4", "") | SC 'Z:\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt'

cd "Z:\Stock File Fetcher\StockFeed\ValeoFeed"
findstr "[[A-Z] [0-9] ,]" valeo.txt > valeogrep.txt
del valeo.txt

Rename-Item valeogrep.txt valeo.txt
If (Test-Path -Path "toolbank.txt") {
  'It does stick around'
  del toolbank.txt
}

move valeo.txt "Z:\Stock File Fetcher\Upload"

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
New-Item valeo.txt -ItemType file
