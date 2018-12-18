Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSmintex.txt" -Force  -ErrorAction SilentlyContinue
$Host.UI.RawUI.WindowTitle = $title = "MintexFeed"

Function alter($sku,$edit) {
  (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\MintexFeed\mintex.txt') -replace "$sku`t`t`t`t.+", "$sku`t`t`t`t$edit`targreplace" | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\MintexFeed\mintex.txt'
}

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\MintexFeed\Scripts"
If (Test-Path -Path mintex.csv) {del mintex.csv}
If (Test-Path -Path unzipped) {del unzipped -recurse}

"Acquiring File"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Dropzone\Mintex"
If (!(Test-Path -Path mintex.zip)) {
	"mintex.zip has not been found and may have already been run."
	sleep 2
	EXIT
}
move mintex.zip "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\MintexFeed\Scripts"

"Extracting File"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\MintexFeed\Scripts"
Expand-Archive "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\MintexFeed\Scripts\mintex.zip" -DestinationPath "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\MintexFeed\Scripts\unzipped" -Force
If (Test-Path -Path mintex.zip) {del mintex.zip}

"Renaming File"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\MintexFeed\Scripts\unzipped"
gci *.csv | % {
    ren -path $_.fullname -NewName "mintex.csv"
    move mintex.csv "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\MintexFeed\Scripts" -Force
}

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\MintexFeed\Scripts"
If (Test-Path -Path unzipped) {del unzipped -recurse}

"Removing Whitespace"
(gc mintex.csv).replace(" ", "") | sc mintex.csv

"Processing File"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\MintexFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning File"
Import-CSV "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\alterations.csv" | select sku,qty | % {alter $_.sku $_.qty}

"Moving File to Upload folder"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\MintexFeed"
If (Test-Path -Path "\\DISKSTATION\Feeds\Dropship\Scripts\MX\MX.txt") {del "\\DISKSTATION\Feeds\Dropship\Scripts\MX\MX.txt"}
copy "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\MintexFeed\mintex.txt" "\\DISKSTATION\Feeds\Dropship\Scripts\MX\MX.txt"
move "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\MintexFeed\mintex.txt" "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
Stop-Transcript
