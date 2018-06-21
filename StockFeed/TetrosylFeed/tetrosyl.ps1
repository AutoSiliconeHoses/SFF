#Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANStetrosyl.txt" -Force 
$Host.UI.RawUI.WindowTitle = "TetrosylFeed"

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Dropzone\Tetrosyl"
"Acquiring File"
if (Test-Path -Path 'tetrosyl.csv') {del tetrosyl.csv}
gc *.csv | sc tetrosyl.csv

If (Test-Path -Path '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\tetrosyl.csv') {del '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\tetrosyl.csv'}
move tetrosyl.csv "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts"

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts"
If (Test-Path -Path tlmacro2.xlsm) {del tlmacro2.xlsm}
copy tlmacro.xlsm tlmacro2.xlsm

"Processing File"
"OpenAndSave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\OpenAndSave.ps1" /C

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed"
"Cleaning File"
(gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\tetrosyl.txt').replace("FALSE`t`t`t`t0`targreplace", "") | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\tetrosyl.txt'
(gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\tetrosyl.txt').replace("?-TL`t`t`t`t0`targreplace", "") | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\tetrosyl.txt'
(gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\tetrosyl.txt')|?{$_.Trim(" `t")}| sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\tetrosyl.txt'

"Moving File to Upload folder"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed"
move tetrosyl.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
#Stop-Transcript
