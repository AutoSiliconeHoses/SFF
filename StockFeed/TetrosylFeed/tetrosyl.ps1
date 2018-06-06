$Host.UI.RawUI.WindowTitle = "TetrosylFeed"
Z:
cd "Z:\Stock File Fetcher\StockFeed\GUI\Dropzone\Tetrosyl"
"Acquiring File"
if (Test-Path -Path 'tetrosyl.csv') {del tetrosyl.csv}
cat *.csv | sc tetrosyl.csv

If (Test-Path -Path 'Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\tetrosyl.csv') {del 'Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\tetrosyl.csv'}
move tetrosyl.csv "Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts"

cd "Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts"
If (Test-Path -Path tlmacro2.xlsm) {del tlmacro2.xlsm}
copy tlmacro.xlsm tlmacro2.xlsm

"Processing File"
"OpenAndSave.ps1"
& "Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\OpenAndSave.ps1" /C

cd "Z:\Stock File Fetcher\StockFeed\TetrosylFeed"
"Cleaning File"
(gc 'Z:\Stock File Fetcher\StockFeed\TetrosylFeed\tetrosyl.txt').replace("FALSE`t`t`t`t0`targreplace", "") | sc 'Z:\Stock File Fetcher\StockFeed\TetrosylFeed\tetrosyl.txt'
(gc 'Z:\Stock File Fetcher\StockFeed\TetrosylFeed\tetrosyl.txt').replace("?-TL`t`t`t`t0`targreplace", "") | sc 'Z:\Stock File Fetcher\StockFeed\TetrosylFeed\tetrosyl.txt'
(gc 'Z:\Stock File Fetcher\StockFeed\TetrosylFeed\tetrosyl.txt')|?{$_.Trim(" `t")}| sc 'Z:\Stock File Fetcher\StockFeed\TetrosylFeed\tetrosyl.txt'

"Moving File to Upload folder"
cd "Z:\Stock File Fetcher\StockFeed\TetrosylFeed"
move tetrosyl.txt "Z:\Stock File Fetcher\Upload"
