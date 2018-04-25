TITLE DeccoFeed
Z:
cd "Z:\Stock File Fetcher\StockFeed\GUI\Dropzone\Decco"

copy decco.zip "Z:\Stock File Fetcher\StockFeed\DeccoFeed"

cd "Z:\Stock File Fetcher\StockFeed\DeccoFeed"
If exist decco.txt del decco.txt

cd "Z:\Stock File Fetcher\StockFeed\DeccoFeed"
ren decco.zip file.zip
"Z:\Stock File Fetcher\StockFeed\Programs\unzip.exe" "Z:\Stock File Fetcher\StockFeed\DeccoFeed\file.zip"

del file.zip
ren *.xls stock.xml
move stock.xml "Z:\Stock File Fetcher\StockFeed\DeccoFeed\Scripts"
cd "Z:\Stock File Fetcher\StockFeed\DeccoFeed\Scripts"

%comspec% /C "Z:\Stock File Fetcher\StockFeed\DeccoFeed\Scripts\OpenAndSave.vbs"
%comspec% /C "Z:\Stock File Fetcher\StockFeed\DeccoFeed\Scripts\OpenAndSave2.vbs"
%comspec% /C "Z:\Stock File Fetcher\StockFeed\DeccoFeed\Scripts\SaveAsTxt.vbs"

"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\StockFeed\DeccoFeed" --fileMask "*decco.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "FALSE				0	5" --replace ""

cd "Z:\Stock File Fetcher\StockFeed\DeccoFeed"
findstr "[[A-Z] [0-9] ,]" decco.txt > deccogrep.txt
del decco.txt
ren deccogrep.txt decco.txt
del deccogrep.txt

move decco.txt "Z:\Stock File Fetcher\Upload"

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
echo .>> decco.txt
