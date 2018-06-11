Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSdecco.txt" -Force -NoClobber
$Host.UI.RawUI.WindowTitle = "DeccoFeed"
Z:
cd "Z:\Stock File Fetcher\StockFeed\DeccoFeed\Scripts"
If (Test-Path -Path decco.csv) {del decco.csv}
cd "Z:\Stock File Fetcher\StockFeed\DeccoFeed"
If (Test-Path -Path unzipped) {del unzipped -recurse}

"Acquiring File"
cd "Z:\Stock File Fetcher\StockFeed\GUI\Dropzone\Decco"
copy decco.zip "Z:\Stock File Fetcher\StockFeed\DeccoFeed"

"Extracting File"
cd "Z:\Stock File Fetcher\StockFeed\DeccoFeed"

Expand-Archive "Z:\Stock File Fetcher\StockFeed\DeccoFeed\decco.zip" -DestinationPath "Z:\Stock File Fetcher\StockFeed\DeccoFeed\unzipped" -Force
If (Test-Path -Path decco.zip) {del decco.zip}

"Renaming File"
cd "Z:\Stock File Fetcher\StockFeed\DeccoFeed\unzipped"
Get-ChildItem "Z:\Stock File Fetcher\StockFeed\DeccoFeed\unzipped\*.xls" | ForEach-Object{
    $a=$_.fullname
    $b="decco.xml"
    Rename-Item -path $a -NewName $b
}

move decco.xml "Z:\Stock File Fetcher\StockFeed\DeccoFeed\Scripts" -Force
cd ..\
If (Test-Path -Path unzipped) {del unzipped -recurse}
cd "Z:\Stock File Fetcher\StockFeed\DeccoFeed\Scripts"
If (Test-Path -Path dcmacro2.xlsm) {del dcmacro2.xlsm}
copy dcmacro.xlsm dcmacro2.xlsm

"Processing File"
cd "Z:\Stock File Fetcher\StockFeed\DeccoFeed\Scripts"
& "Z:\Stock File Fetcher\StockFeed\DeccoFeed\Scripts\OpenAndSave.ps1" /C
If (Test-Path -Path decco.xml) {del decco.xml}

"Cleaning File"
(cat 'Z:\Stock File Fetcher\StockFeed\DeccoFeed\decco.txt').replace("FALSE`t`t`t`t0`targreplace", "") | sc 'Z:\Stock File Fetcher\StockFeed\DeccoFeed\decco.txt'
(cat 'Z:\Stock File Fetcher\StockFeed\DeccoFeed\decco.txt').replace("FALSE-DC`t`t`t`t0`targreplace", "") | sc 'Z:\Stock File Fetcher\StockFeed\DeccoFeed\decco.txt'
"Moving File to Upload folder"
cd "Z:\Stock File Fetcher\StockFeed\DeccoFeed"
move decco.txt "Z:\Stock File Fetcher\Upload"
Stop-Transcript
