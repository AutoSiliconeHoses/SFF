TITLE TetrosylFeed
Z:
cd "Z:\Stock File Fetcher\StockFeed\GUI\Dropzone\Tetrosyl"
if exist combine.csv (del "combine.csv")

copy *.csv combine.csv
move combine.csv "Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts"

cd "Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts"
copy macro.xlsm macro2.xlsm

%comspec% /C "Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\RunMacro.vbs"
%comspec% /C "Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\SaveAsTxt.vbs"

del macro2.xlsm

"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\StockFeed\tetrosylFeed" --fileMask "*tetrosyl.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "FALSE				0	4" --replace ""
"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\StockFeed\tetrosylFeed" --fileMask "*tetrosyl.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "?-TL				0	4" --replace ""

cd "Z:\Stock File Fetcher\StockFeed\TetrosylFeed"
findstr "[[A-Z] [0-9] ,]" tetrosyl.txt > tetrosylgrep.txt
del tetrosyl.txt
ren tetrosylgrep.txt tetrosyl.txt
del tetrosylgrep.txt

move tetrosyl.txt "Z:\Stock File Fetcher\Upload"

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
echo .>> tetrosyl.txt
