TITLE StaxFeed
Z:
cd "Z:\Stock File Fetcher\StockFeed\StaxFeed\Scripts"
powershell -command "Invoke-RestMethod https://www.staxtradecentres.co.uk/feeds/1.3/stock.csv?key=6p5x4hytd6 -OutFile stock.csv"

If NOT exist "Z:\Stock File Fetcher\StockFeed\StaxFeed\Scripts\stock.csv" (
  echo "There has been an issue collecting the stock file."

  cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
  echo .>> stax.txt
  PAUSE
  EXIT
)

cd "Z:\Stock File Fetcher\StockFeed\StaxFeed"
If exist stax.txt del stax.txt

%comspec% /C "Z:\Stock File Fetcher\StockFeed\StaxFeed\Scripts\SaveAsTxt.vbs"

"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\StockFeed\StaxFeed" --fileMask "*stax.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "FALSE				0	4" --replace ""

findstr "[[A-Z] [0-9] ,]" stax.txt > staxgrep.txt
del stax.txt
ren staxgrep.txt stax.txt
del staxgrep.txt

move stax.txt "Z:\Stock File Fetcher\Upload"

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
echo .>> stax.txt
