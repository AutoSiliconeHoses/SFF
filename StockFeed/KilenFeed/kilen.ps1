$Host.UI.RawUI.WindowTitle = "KilenFeed"
Z:
cd "Z:\Stock File Fetcher\StockFeed\KilenFeed\Scripts"
If (Test-Path -Path kilen.csv) {del kilen.csv}

cd "Z:\Stock File Fetcher\StockFeed\GUI\Dropzone\Kilen"
copy kilen.csv "Z:\Stock File Fetcher\StockFeed\KilenFeed\Scripts"

"Cleaning Files"
cd "Z:\Stock File Fetcher\StockFeed\KilenFeed\Scripts"
& "Z:\Stock File Fetcher\StockFeed\KilenFeed\Scripts\SaveAsTxt.ps1" /C

(cat 'Z:\Stock File Fetcher\StockFeed\KilenFeed\kilen.txt').replace("FALSE`t`t`t`t0`t4", "") | sc 'Z:\Stock File Fetcher\StockFeed\KilenFeed\kilen.txt'

cd "Z:\Stock File Fetcher\StockFeed\KilenFeed"
findstr "[[A-Z] [0-9] ,]" kilen.txt > kilengrep.txt
If (Test-Path -Path kilen.txt) {del kilen.txt}
Rename-Item kilengrep.txt kilen.txt
If (Test-Path -Path kilengrep.txt) {del kilengrep.txt}

move kilen.txt "Z:\Stock File Fetcher\Upload"
If (Test-Path -Path kilen.txt) {del kilen.txt}

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
New-Item kilen.txt -ItemType file
