$Host.UI.RawUI.WindowTitle = "DeccoFeed"
Z:
cd "Z:\Stock File Fetcher\StockFeed\DeccoFeed\Scripts"
cd "Z:\Stock File Fetcher\StockFeed\DeccoFeed"
If (Test-Path -Path unzipped) {del unzipped}

"Acquiring File"
cd "Z:\Stock File Fetcher\StockFeed\GUI\Dropzone\Decco"
copy decco.zip "Z:\Stock File Fetcher\StockFeed\DeccoFeed"

"Extracting File"
cd "Z:\Stock File Fetcher\StockFeed\DeccoFeed"
Rename-Item decco.zip file.zip
Expand-Archive "Z:\Stock File Fetcher\StockFeed\DeccoFeed\file.zip" -DestinationPath "Z:\Stock File Fetcher\StockFeed\DeccoFeed\unzipped" -Force

If (Test-Path -Path file.zip) {del file.zip}

"Renaming File"
cd "Z:\Stock File Fetcher\StockFeed\DeccoFeed\unzipped"
Get-ChildItem "Z:\Stock File Fetcher\StockFeed\DeccoFeed\unzipped\*.xls" | ForEach-Object{
    $a=$_.fullname
    $b="stock.xml"
    Rename-Item -path $a -NewName $b
}

move stock.xml "Z:\Stock File Fetcher\StockFeed\DeccoFeed\Scripts"
If (Test-Path -Path stock.xml) {del stock.xml}

"Processing File"
cd "Z:\Stock File Fetcher\StockFeed\DeccoFeed\Scripts"
& "Z:\Stock File Fetcher\StockFeed\DeccoFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning File"
(cat 'Z:\Stock File Fetcher\StockFeed\DeccoFeed\decco.txt').replace("FALSE`t`t`t`t0`t4", "") | sc 'Z:\Stock File Fetcher\StockFeed\DeccoFeed\decco.txt'

cd "Z:\Stock File Fetcher\StockFeed\DeccoFeed"
findstr "[[A-Z] [0-9] ,]" decco.txt > deccogrep.txt
If (Test-Path -Path decco.txt) {del decco.txt}
Rename-Item deccogrep.txt decco.txt
If (Test-Path -Path deccogrep.txt) {del deccogrep.txt}
