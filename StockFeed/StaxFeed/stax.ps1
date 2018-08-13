Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSstax.txt" -Force
$Host.UI.RawUI.WindowTitle = $title = "StaxFeed"

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxFeed\Scripts"
"Acquiring File"
If (Test-Path -Path stax.csv) {del stax.csv}
Invoke-RestMethod https://www.staxtradecentres.co.uk/feeds/1.3/stock.csv?key=6p5x4hytd6 -OutFile stax.csv
If (!(Test-Path -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxFeed\Scripts\stax.csv")) {
  "There has been an issue collecting the stock file."
  EXIT
}

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxFeed"
If (Test-Path -Path stax.txt) {del stax.txt}

"Processing File"
"OpenAndSave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning File"
(gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxFeed\stax.txt') -replace "724835-SX`t`t`t`t.+", "724835-SX`t`t`t`t0`targreplace" | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxFeed\stax.txt'
(gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxFeed\stax.txt') -replace "674085-SX`t`t`t`t.+", "674085-SX`t`t`t`t50`targreplace" | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxFeed\stax.txt'
(gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxFeed\stax.txt') -replace "366501-SX`t`t`t`t.+", "366501-SX`t`t`t`t50`targreplace" | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxFeed\stax.txt'
#(gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxFeed\stax.txt')|?{$_.Trim(" `t")}|sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxFeed\stax.txt'

"Moving File to Upload folder"
If (Test-Path -Path "\\DISKSTATION\Feeds\Dropship\Scripts\SX\SX.txt") {del "\\DISKSTATION\Feeds\Dropship\Scripts\SX\SX.txt"}
copy "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxFeed\stax.txt" "\\DISKSTATION\Feeds\Dropship\Scripts\SX\SX.txt"
move "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxFeed\stax.txt" "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
Stop-Transcript
