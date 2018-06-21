#Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSstax.txt" -Force -NoClobber
$Host.UI.RawUI.WindowTitle = "StaxFeed"

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxFeed\Scripts"
"Acquiring File"

If (!(Test-Path -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxFeed\Scripts\stock.csv")) {
  "There has been an issue collecting the stock file."
  EXIT
}

If (Test-Path -Path stax.csv) {del stax.csv}
Rename-Item stock.csv stax.csv

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxFeed"
If (Test-Path -Path stax.txt) {del stax.txt}

"Processing File"
"OpenAndSave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxFeed\Scripts\OpenAndSave.ps1" /C

#"Cleaning File"
#(Get-Content '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxFeed\stax.txt').replace("FALSE`t`t`t`t0`targreplace", "") | Set-Content '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxFeed\stax.txt'
#(GC '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxFeed\stax.txt')|?{$_.Trim(" `t")}|SC '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxFeed\stax.txt'

"Moving File to Upload folder"
move stax.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
#Stop-Transcript
