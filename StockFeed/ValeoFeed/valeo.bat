TITLE ValeoFeed
Z:
cd "Z:\Stock File Fetcher\StockFeed\GUI\Dropzone\Valeo"

copy "VALEO_stock.csv" "Z:\Stock File Fetcher\StockFeed\ValeoFeed\Scripts"

cd "Z:\Stock File Fetcher\StockFeed\ValeoFeed\Scripts"
"Z:\Stock File Fetcher\StockFeed\Programs\csv2xlsx_386.exe" -infile "VALEO_stock.csv" -outfile stock.xlsx -colsep ","
del "VALEO_stock.csv"

cd "Z:\Stock File Fetcher\Upload"
If exist valeo.txt del valeo.txt

%comspec% /C "Z:\Stock File Fetcher\StockFeed\ValeoFeed\Scripts\OpenAndSave2.vbs"
%comspec% /C "Z:\Stock File Fetcher\StockFeed\ValeoFeed\Scripts\OpenAndSave.vbs"
%comspec% /C "Z:\Stock File Fetcher\StockFeed\ValeoFeed\Scripts\SaveAsTxt.vbs"

"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\StockFeed\ValeoFeed" --fileMask "*valeo.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "FALSE				0	5" --replace ""
"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\StockFeed\ValeoFeed" --fileMask "*valeo.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "#VALUE!				20	5" --replace ""
"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\StockFeed\ValeoFeed" --fileMask "*valeo.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "C				20	5" --replace ""

cd "Z:\Stock File Fetcher\StockFeed\ValeoFeed"
findstr "[[A-Z] [0-9] ,]" valeo.txt > valeogrep.txt
del valeo.txt
ren valeogrep.txt valeo.txt
del valeogrep.txt

move valeo.txt "Z:\Stock File Fetcher\Upload"

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
echo .>> valeo.txt
