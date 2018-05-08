TITLE KYBFeed
Z:
cd "Z:\Stock File Fetcher\StockFeed\GUI\Dropzone\KYB"

:waitloop
if exist "KYBSTOCK.csv" goto waitloopend
goto waitloop
:waitloopend

copy "KYBSTOCK.csv" "Z:\Stock File Fetcher\StockFeed\KYBFeed\Scripts"

cd "Z:\Stock File Fetcher\StockFeed\KYBFeed\Scripts"

cd "Z:\Stock File Fetcher\Upload"
If exist kyb.txt del kyb.txt

%comspec% /C "Z:\Stock File Fetcher\StockFeed\KYBFeed\Scripts\SaveAsTxt.vbs"

"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\StockFeed\KYBFeed" --fileMask "*kyb.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "FALSE				0	4" --replace ""

cd "Z:\Stock File Fetcher\StockFeed\KYBFeed"
findstr "[[A-Z] [0-9] ,]" kyb.txt > kybgrep.txt
del kyb.txt
ren kybgrep.txt kyb.txt
del kybgrep.txt

move kyb.txt "Z:\Stock File Fetcher\Upload"

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
echo .>> kyb.txt
