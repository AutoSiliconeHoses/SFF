Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSstaxprime.txt" -Force
$Host.UI.RawUI.WindowTitle = "StaxPrimeFeed"

Function alter($sku,$edit) {
  (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxPrimeFeed\staxprime.txt') -replace "$sku`t`t`t`t.+", "$sku`t`t`t`t$edit" | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxPrimeFeed\staxprime.txt'
}

# Time check conditions
$thistime = (Get-Date).Hour
$day = (Get-Date).DayOfWeek.Value__
$timecheck = (7 -le $thistime) -and ($thistime -lt 12)
$daycheck = (1 -le $day) -and ($day -le 5)
$working = $timecheck -and $daycheck

#Force
# $working = $FALSE

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
"working = $working"
If ($working) {
  "SaveZero.ps1"
  & "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxPrimeFeed\Scripts\SaveZero.ps1" /C
}
If (!$working) {
  "OpenAndSave.ps1"
  & "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxPrimeFeed\Scripts\OpenAndSave.ps1" /C
}

"Cleaning File"
Import-CSV "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\alterations.csv" | select sku,qty | ? {$_.sku.endswith("-SX-PRIME")} | % {alter $_.sku $_.qty}

"Moving Files to Upload folder"
gc staxprime.txt | sc "\\DISKSTATION\Feeds\Stock File Fetcher\Upload\staxprime.txt"

Stop-Transcript
