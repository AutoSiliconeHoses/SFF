Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSdeccoprime.txt" -Force  -ErrorAction SilentlyContinue
$Host.UI.RawUI.WindowTitle = "DeccoPrimeFeed"

# Time check conditions
$thistime = (Get-Date).Hour
$day = (Get-Date).DayOfWeek.Value__
$timecheck = (7 -le $thistime) -and ($thistime -lt 12)
$daycheck = (1 -le $day) -and ($day -le 5)
$working = $timecheck -and $daycheck

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoPrimeFeed\Scripts"
If (Test-Path -Path deccoprime.csv) {del deccoprime.csv}
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoPrimeFeed"
If (Test-Path -Path unzipped) {del unzipped -recurse}

"Acquiring File"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Dropzone\Decco Prime"
If (!(Test-Path -Path deccoprime.zip)) {
	"deccoprime.zip has not been found and may have already been run."
	sleep 2
	EXIT
}
copy deccoprime.zip "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoPrimeFeed"

"Extracting File"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoPrimeFeed"

Expand-Archive "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoPrimeFeed\deccoprime.zip" -DestinationPath "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoPrimeFeed\unzipped" -Force
If (Test-Path -Path deccoprime.zip) {del deccoprime.zip}

Function alter($sku,$edit) {
  (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoPrimeFeed\deccoprime.txt') -replace "$sku`t`t`t`t.+", "$sku`t`t`t`t$edit`targreplace" | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoPrimeFeed\deccoprime.txt'
}

"Renaming File"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoPrimeFeed\unzipped"
gci *.xls | % {
    $a=$_.fullname
    $b="deccoprime.xml"
    ren -path $a -NewName $b
}

move deccoprime.xml "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoPrimeFeed\Scripts" -Force
cd ..\
If (Test-Path -Path unzipped) {del unzipped -recurse}
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoPrimeFeed\Scripts"
If (Test-Path -Path dcpmacro2.xlsm) {del dcpmacro2.xlsm}
cp dcpmacro.xlsm dcpmacro2.xlsm

"Processing File"
"timecheck = $timecheck"
"daycheck = $daycheck"
"working = $working"
If ($working) {
  "SaveZero.ps1"
  & "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoPrimeFeed\Scripts\SaveZero.ps1" /C
}
If (!$working) {
  "OpenAndSave.ps1"
  & "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoPrimeFeed\Scripts\OpenAndSave.ps1" /C
}
If (Test-Path -Path deccoprime.xml) {del deccoprime.xml}

"Cleaning File"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoPrimeFeed"
Import-CSV "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\alterations.csv" | select sku,qty | ? {$_.sku.endswith("-DC-PRIME")} | % {alter $_.sku $_.qty}

"Moving File to Upload folder"
move "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoPrimeFeed\deccoprime.txt" "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
Stop-Transcript
