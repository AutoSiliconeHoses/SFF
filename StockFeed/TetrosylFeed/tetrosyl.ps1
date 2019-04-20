Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANStetrosyl.txt" -Force
$Host.UI.RawUI.WindowTitle = "TetrosylFeed"

Function alter($sku,$edit) {
  (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\tetrosyl.txt') -replace "$sku`t`t`t`t.+", "$sku`t`t`t`t$edit`targreplace" | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\tetrosyl.txt'
}

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts"
If (Test-Path -Path 'tetrosyl.csv') {del tetrosyl.csv}

"Acquiring File"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Dropzone\Tetrosyl"
If (Test-Path -Path 'tetrosyl.csv') {del tetrosyl.csv}
gc *.csv | sc tetrosyl.csv
If (!(Test-Path -Path tetrosyl.csv)) {
	"tetrosyl.csv has not been found and may have already been run."
	sleep 2
	EXIT
}
move tetrosyl.csv "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts"
del *.txt

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts"
If (Test-Path -Path tlmacro2.xlsm) {del tlmacro2.xlsm}
cp tlmacro.xlsm tlmacro2.xlsm

"Processing File"
"OpenAndSave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\OpenAndSave.ps1" /C

# cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed"
"Cleaning File"
Import-CSV "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\alterations.csv" | select sku,qty | ? {$_.sku.endswith("-TL")} | % {alter $_.sku $_.qty}
# (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\tetrosyl.txt').replace("FALSE`t`t`t`t0`targreplace", "") | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\tetrosyl.txt'
# (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\tetrosyl.txt').replace("?-TL`t`t`t`t0`targreplace", "") | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\tetrosyl.txt'
# (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\tetrosyl.txt')|?{$_.Trim(" `t")}| sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\tetrosyl.txt'

"Moving File to Upload folder"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed"
move tetrosyl.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
Stop-Transcript
