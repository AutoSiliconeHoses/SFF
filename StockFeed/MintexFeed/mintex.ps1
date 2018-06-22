Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSmintex.txt" -Force  -ErrorAction SilentlyContinue
$Host.UI.RawUI.WindowTitle = "MintexFeed"

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\MintexFeed\Scripts"
If (Test-Path -Path mintex.csv) {del mintex.csv}
If (Test-Path -Path unzipped) {del unzipped -recurse}

"Acquiring File"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Dropzone\Mintex"
copy mintex.zip "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\MintexFeed\Scripts"

"Extracting File"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\MintexFeed\Scripts"
Expand-Archive "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\MintexFeed\Scripts\mintex.zip" -DestinationPath "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\MintexFeed\Scripts\unzipped" -Force
If (Test-Path -Path mintex.zip) {del mintex.zip}

"Renaming File"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\MintexFeed\Scripts\unzipped"
Get-ChildItem *.csv | ForEach-Object {
    $a=$_.fullname
    $b="mintex.csv"
    Rename-Item -path $a -NewName $b
    move mintex.csv "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\MintexFeed\Scripts" -Force
}

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\MintexFeed\Scripts"
If (Test-Path -Path unzipped) {del unzipped -recurse}

"Removing whitespace"
(gc mintex.csv).replace(" ", "") | sc mintex.csv

"Processing File"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\MintexFeed\Scripts\OpenAndSave.ps1" /C

"Moving File to Upload folder"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\MintexFeed"
move mintex.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
Stop-Transcript
