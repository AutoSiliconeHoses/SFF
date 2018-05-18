$Host.UI.RawUI.WindowTitle = "TetrosylFeed"
Z:
cd "Z:\Stock File Fetcher\StockFeed\GUI\Dropzone\Tetrosyl"
"Acquiring File"
if (Test-Path -Path 'combine.csv') {del combine.csv}
cat *.csv | sc combine.csv

If (Test-Path -Path 'Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\combine.csv') {del 'Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\combine.csv'}
move combine.csv "Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts"

cd "Z:\Stock File Fetcher\StockFeed\TetrosylFeed"

"Processing File"
"OpenAndSave.ps1"
& "Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\OpenAndSave.ps1" /C
"RunMacro.ps1"
& "Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\RunMacro.ps1" /C
"SaveAsTxt.ps1"
& "Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\SaveAsTxt.ps1" /C

"Cleaning File"
(Get-Content 'Z:\Stock File Fetcher\StockFeed\TetrosylFeed\tetrosyl.txt').replace("FALSE`t`t`t`t0`t4", "") | Set-Content 'Z:\Stock File Fetcher\StockFeed\TetrosylFeed\tetrosyl.txt'
(Get-Content 'Z:\Stock File Fetcher\StockFeed\TetrosylFeed\tetrosyl.txt').replace("?-TL`t`t`t`t0`t4", "") | Set-Content 'Z:\Stock File Fetcher\StockFeed\TetrosylFeed\tetrosyl.txt'

cd "Z:\Stock File Fetcher\StockFeed\TetrosylFeed"
findstr "[[A-Z] [0-9] ,]" tetrosyl.txt > tetrosylgrep.txt
If (Test-Path -Path 'tetrosyl.txt') {del tetrosyl.txt}
Rename-Item tetrosylgrep.txt tetrosyl.txt

"Moving File to Upload folder"
move tetrosyl.txt "Z:\Stock File Fetcher\Upload"

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
New-Item tetrosyl.txt -ItemType file
