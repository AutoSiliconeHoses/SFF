Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSstaxprime.txt" -Force -NoClobber
$Host.UI.RawUI.WindowTitle = "StaxPrimeFeed"

# Time check conditions
$thistime = (Get-Date).Hour
$day = (Get-Date).DayOfWeek.Value__
$timecheck = (8 -le $thistime) -and ($thistime -lt 13)
$daycheck = (1 -le $day) -and ($day -le 5)
$result = $timecheck -and $daycheck

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
"timecheck = $timecheck"
"daycheck = $daycheck"
"result = $result"
If ($result) {
  "SaveZero.ps1"
  & "Z:\Stock File Fetcher\StockFeed\StaxPrimeFeed\Scripts\SaveZero.ps1" /C
}
If (!$result) {
  "OpenAndSave.ps1"
  & "Z:\Stock File Fetcher\StockFeed\StaxPrimeFeed\Scripts\OpenAndSave.ps1" /C
}

"Cleaning File"
(gc 'Z:\Stock File Fetcher\StockFeed\StaxPrimeFeed\staxprime.txt').replace("FALSE`t`t`t`t0", "") | sc 'Z:\Stock File Fetcher\StockFeed\StaxPrimeFeed\staxprime.txt'
(gc 'Z:\Stock File Fetcher\StockFeed\StaxPrimeFeed\staxprime.txt')|?{$_.Trim(" `t")}| sc 'Z:\Stock File Fetcher\StockFeed\StaxPrimeFeed\staxprime.txt'

"Moving File to Upload folder"
move staxprime.txt "Z:\Stock File Fetcher\Upload"
Stop-Transcript
