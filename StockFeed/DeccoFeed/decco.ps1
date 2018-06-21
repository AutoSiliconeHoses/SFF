If (Test-Path -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSdecco.txt") {del "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSdecco.txt" -ErrorAction SilentlyContinue}
Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSdecco.txt" -Force -NoClobber -ErrorAction SilentlyContinue
$Host.UI.RawUI.WindowTitle = "DeccoFeed"

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoFeed\Scripts"
If (Test-Path -Path decco.csv) {del decco.csv}
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoFeed"
If (Test-Path -Path unzipped) {del unzipped -recurse}

"Acquiring File"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Dropzone\Decco"
copy decco.zip "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoFeed"

"Extracting File"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoFeed"

Expand-Archive "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoFeed\decco.zip" -DestinationPath "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoFeed\unzipped" -Force
If (Test-Path -Path decco.zip) {del decco.zip}

"Renaming File"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoFeed\unzipped"
Get-ChildItem *.xls | ForEach-Object{
    $a=$_.fullname
    $b="decco.xml"
    Rename-Item -path $a -NewName $b
}

move decco.xml "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoFeed\Scripts" -Force
cd ..\
If (Test-Path -Path unzipped) {del unzipped -recurse}
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoFeed\Scripts"
If (Test-Path -Path dcmacro2.xlsm) {del dcmacro2.xlsm}
copy dcmacro.xlsm dcmacro2.xlsm

"Processing File"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoFeed\Scripts"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoFeed\Scripts\OpenAndSave.ps1" /C
If (Test-Path -Path decco.xml) {del decco.xml}

"Cleaning File"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoFeed"
(gc 'decco.txt').replace("FALSE`t`t`t`t0`targreplace", "") | sc 'decco.txt'
(gc 'decco.txt').replace("FALSE-DC`t`t`t`t0`targreplace", "") | sc 'decco.txt'
(gc 'decco.txt')|?{$_.Trim(" `t")}| sc 'decco.txt'

"Moving File to Upload folder"
move decco.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
Stop-Transcript
