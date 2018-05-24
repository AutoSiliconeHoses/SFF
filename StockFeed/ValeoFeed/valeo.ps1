$Host.UI.RawUI.WindowTitle = 'ValeoFeed'
Z:
cd "Z:\Stock File Fetcher\StockFeed\GUI\Dropzone\Valeo"
"Acquiring File"
copy "VALEO_stock.csv" "Z:\Stock File Fetcher\StockFeed\ValeoFeed\Scripts"

cd "Z:\Stock File Fetcher\StockFeed\ValeoFeed\Scripts"
"Processing File"
"OpenAndsave.ps1"
& "Z:\Stock File Fetcher\StockFeed\ValeoFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning File"
(Cat 'Z:\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt').replace("FALSE`t`t`t`t0`targreplace", "") | SC 'Z:\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt'
(Cat 'Z:\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt').replace("#VALUE!`t`t`t`t20`targreplace", "") | SC 'Z:\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt'
(Cat 'Z:\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt').replace("C`t`t`t`t20`targreplace", "") | SC 'Z:\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt'

cd "Z:\Stock File Fetcher\StockFeed\ValeoFeed"
findstr "[[A-Z] [0-9] ,]" valeo.txt > valeogrep.txt
del valeo.txt
Rename-Item valeogrep.txt valeo.txt

"Moving File to Upload folder"
move valeo.txt "Z:\Stock File Fetcher\Upload"
