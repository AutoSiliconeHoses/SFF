$Host.UI.RawUI.WindowTitle = "StaxFeed"
Z:
cd "Z:\Stock File Fetcher\StockFeed\StaxFeed\Scripts"
"Downloading Stock File"
Invoke-RestMethod https://www.staxtradecentres.co.uk/feeds/1.3/stock.csv?key=6p5x4hytd6 -OutFile stock.csv

If (!(Test-Path -Path "Z:\Stock File Fetcher\StockFeed\StaxFeed\Scripts\stock.csv")) {
  "There has been an issue collecting the stock file."
  EXIT
}

cd "Z:\Stock File Fetcher\StockFeed\StaxFeed"
If (Test-Path -Path stax.txt) {del stax.txt}

"SaveAsTxt.ps1"
& "Z:\Stock File Fetcher\StockFeed\StaxFeed\Scripts\SaveAsTxt.ps1" /C

"Cleaning Files"
(Get-Content 'Z:\Stock File Fetcher\StockFeed\StaxFeed\stax.txt').replace("FALSE`t`t`t`t0`t4", "") | Set-Content 'Z:\Stock File Fetcher\StockFeed\StaxFeed\stax.txt'

findstr "[[A-Z] [0-9] ,]" stax.txt > staxgrep.txt
If (Test-Path -Path stax.txt) {del stax.txt}
Rename-Item staxgrep.txt stax.txt
If (Test-Path -Path staxgrep.txt) {del staxgrep.txt}

move stax.txt "Z:\Stock File Fetcher\Upload"

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
New-Item stax.txt -ItemType file
