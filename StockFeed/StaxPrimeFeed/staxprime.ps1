$Host.UI.RawUI.WindowTitle = "StaxPrimeFeed"
Z:
cd "Z:\Stock File Fetcher\StockFeed\StaxPrimeFeed\Scripts"
"Acquiring File"
Invoke-RestMethod https://www.staxtradecentres.co.uk/feeds/1.3/stock.csv?key=6p5x4hytd6 -OutFile stock.csv

If (!(Test-Path -Path "Z:\Stock File Fetcher\StockFeed\StaxPrimeFeed\Scripts\stock.csv")) {
  "There has been an issue collecting the stock file."
  EXIT
}

If (Test-Path -Path staxprime.csv) {del staxprime.csv}
Rename-Item stock.csv staxprime.csv

cd "Z:\Stock File Fetcher\StockFeed\StaxPrimeFeed"
If (Test-Path -Path staxprime.txt) {del staxprime.txt}

"Processing File"
"OpenAndSave.ps1"
& "Z:\Stock File Fetcher\StockFeed\StaxPrimeFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning File"
(Get-Content 'Z:\Stock File Fetcher\StockFeed\StaxPrimeFeed\staxprime.txt').replace("FALSE`t`t`t`t0", "") | Set-Content 'Z:\Stock File Fetcher\StockFeed\StaxPrimeFeed\staxprime.txt'
(GC 'Z:\Stock File Fetcher\StockFeed\StaxPrimeFeed\staxprime.txt')|?{$_.Trim(" `t")}|SC 'Z:\Stock File Fetcher\StockFeed\StaxPrimeFeed\staxprime.txt'

"Moving File to Upload folder"
move staxprime.txt "Z:\Stock File Fetcher\Upload"
