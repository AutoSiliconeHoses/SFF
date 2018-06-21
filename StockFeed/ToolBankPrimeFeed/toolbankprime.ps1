#Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANStoolbankprime.txt" -Force 
$Host.UI.RawUI.WindowTitle = 'ToolBankPrimeFeed'

# Time check conditions
$thistime = (Get-Date).Hour
$day = (Get-Date).DayOfWeek.Value__
$timecheck = (7 -le $thistime) -and ($thistime -lt 12)
$daycheck = (1 -le $day) -and ($day -le 5)
$result = $timecheck -and $daycheck

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\Scripts"

If (Test-Path -Path "Availability20D.csv"){del Availability20D.csv}
If (Test-Path -Path "toolbankprimestock.csv"){del toolbankprimestock.csv}
If (Test-Path -Path "toolbankprime.csv"){del toolbankprime.csv}

"Acquiring File"
ftp -s:login.txt 195.74.141.134

If (Test-Path -Path toolbankprimestock.txt) {del toolbankprimestock.txt}
Rename-Item Availability20D.csv toolbankprimestock.txt

"Processing File"
"timecheck = $timecheck"
"daycheck = $daycheck"
"result = $result"
If ($result) {
  "SaveZero.ps1"
  & "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\Scripts\SaveZero.ps1" /C
}
If (!$result) {
  "OpenAndSave.ps1"
  & "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\Scripts\OpenAndSave.ps1" /C
}
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed"
"Cleaning File"
(gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\toolbankprime.txt').replace("FALSE`t`t`t`t0", "") | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\toolbankprime.txt'
(gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\toolbankprime.txt')|?{$_.Trim(" `t")}|sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\toolbankprime.txt'

"Moving File to Upload folder"
move toolbankprime.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
#Stop-Transcript
