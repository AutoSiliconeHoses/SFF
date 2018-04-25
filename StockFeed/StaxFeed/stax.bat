TITLE StaxFeed
Z:
cd "Z:\Stock File Fetcher\StockFeed\StaxFeed\Scripts"
powershell -command "Invoke-RestMethod https://www.staxtradecentres.co.uk/feeds/1.3/stock.csv?key=6p5x4hytd6 -OutFile stock.csv"

If NOT exist "Z:\Stock File Fetcher\StockFeed\StaxFeed\Scripts\stock.csv" (
  echo "There has been an issue collecting the stock file."
  PAUSE
  cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
  echo .>> stax.txt
  EXIT
)

"Z:\Stock File Fetcher\StockFeed\Programs\csv2xlsx_386.exe" -infile "Z:\Stock File Fetcher\StockFeed\StaxFeed\Scripts\stock.csv" -outfile "Z:\Stock File Fetcher\StockFeed\StaxFeed\Scripts\stock.xlsx" -colsep ","
del stock.csv

cd "Z:\Stock File Fetcher\StockFeed\StaxFeed"
If exist stax.txt del stax.txt

%comspec% /C "Z:\Stock File Fetcher\StockFeed\StaxFeed\Scripts\OpenAndSave.vbs"
%comspec% /C "Z:\Stock File Fetcher\StockFeed\StaxFeed\Scripts\OpenAndSave2.vbs"
%comspec% /C "Z:\Stock File Fetcher\StockFeed\StaxFeed\Scripts\SaveAsTxt.vbs"

move stax.txt "Z:\Stock File Fetcher\Upload"

"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\Upload" --fileMask "*stax.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "FALSE				0	5" --replace ""

cd "Z:\Stock File Fetcher\Upload"
findstr "[[A-Z] [0-9] ,]" stax.txt > staxgrep.txt
del stax.txt
ren staxgrep.txt stax.txt
del staxgrep.txt

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
echo .>> stax.txt
