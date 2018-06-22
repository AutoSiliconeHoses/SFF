Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSstaxprime.txt" -Force
$Host.UI.RawUI.WindowTitle = "StaxPrimeFeed"

# Time check conditions
$thistime = (Get-Date).Hour
$day = (Get-Date).DayOfWeek.Value__
$timecheck = (7 -le $thistime) -and ($thistime -lt 12)
$daycheck = (1 -le $day) -and ($day -le 5)
$result = $timecheck -and $daycheck

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxPrimeFeed\Scripts"
"Acquiring File"
If (Test-Path -Path staxprime.csv) {del staxprime.csv}
Invoke-RestMethod https://www.staxtradecentres.co.uk/feeds/1.3/stock.csv?key=6p5x4hytd6 -OutFile staxprime.csv
If (!(Test-Path -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxPrimeFeed\Scripts\staxprime.csv")) {
  "There has been an issue collecting the stock file."
  EXIT
}

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxPrimeFeed"
If (Test-Path -Path staxprime.txt) {del staxprime.txt}

"Processing File"
"timecheck = $timecheck"
"daycheck = $daycheck"
"result = $result"
If ($result) {
  "SaveZero.ps1"
  & "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxPrimeFeed\Scripts\SaveZero.ps1" /C
}
If (!$result) {
  "OpenAndSave.ps1"
  & "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxPrimeFeed\Scripts\OpenAndSave.ps1" /C
}

"Moving File to Upload folder"
move staxprime.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
Stop-Transcript
