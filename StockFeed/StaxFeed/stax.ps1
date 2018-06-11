Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSstax.txt" -Force -NoClobber
$Host.UI.RawUI.WindowTitle = "StaxFeed"
Z:
cd "Z:\Stock File Fetcher\StockFeed\StaxFeed\Scripts"
"Acquiring File"
Invoke-RestMethod https://www.staxtradecentres.co.uk/feeds/1.3/stock.csv?key=6p5x4hytd6 -OutFile stock.csv

If (!(Test-Path -Path "Z:\Stock File Fetcher\StockFeed\StaxFeed\Scripts\stock.csv")) {
  "There has been an issue collecting the stock file."
  EXIT
}

If (Test-Path -Path stax.csv) {del stax.csv}
Rename-Item stock.csv stax.csv

cd "Z:\Stock File Fetcher\StockFeed\StaxFeed"
If (Test-Path -Path stax.txt) {del stax.txt}

"Processing File"
"OpenAndSave.ps1"
& "Z:\Stock File Fetcher\StockFeed\StaxFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning File"
(Get-Content 'Z:\Stock File Fetcher\StockFeed\StaxFeed\stax.txt').replace("FALSE`t`t`t`t0`targreplace", "") | Set-Content 'Z:\Stock File Fetcher\StockFeed\StaxFeed\stax.txt'
(GC 'Z:\Stock File Fetcher\StockFeed\StaxFeed\stax.txt')|?{$_.Trim(" `t")}|SC 'Z:\Stock File Fetcher\StockFeed\StaxFeed\stax.txt'

"Moving File to Upload folder"
move stax.txt "Z:\Stock File Fetcher\Upload"
Stop-Transcript
