TITLE StaxFeed

Z:
cd "Z:\Stock File Fetcher\StockFeed\StaxFeed\Scripts"
powershell -command "Invoke-RestMethod https://www.staxtradecentres.co.uk/feeds/1.3/stock.csv?key=6p5x4hytd6 -OutFile stock.csv"
::This uses powershell to download the stock.csv using cURL

If NOT exist "Z:\Stock File Fetcher\StockFeed\StaxFeed\Scripts\stock.csv" (
  echo "There has been an issue collecting the stock file."
  PAUSE
  cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
  echo .>> stax.txt
  EXIT
)
::This handles any errors that may appear

"Z:\Stock File Fetcher\StockFeed\Programs\csv2xlsx_386.exe" -infile "Z:\Stock File Fetcher\StockFeed\StaxFeed\Scripts\stock.csv" -outfile "Z:\Stock File Fetcher\StockFeed\StaxFeed\Scripts\stock.xlsx" -colsep ","
del stock.csv
::This converts the stock file to .xlsx format so that it can be referred to by the "reference" files

cd "Z:\Stock File Fetcher\StockFeed\StaxFeed"
If exist stax.txt del stax.txt
::This deletes the existing upload file if it exists

%comspec% /C "Z:\Stock File Fetcher\StockFeed\StaxFeed\Scripts\OpenAndSave.vbs"
::This is a .vbs script that opens and saves reference.xlsx in order to update its values according to the new stock file

%comspec% /C "Z:\Stock File Fetcher\StockFeed\StaxFeed\Scripts\OpenAndSave2.vbs"
::This is a .vbs script that opens and saves reference2.xlsx in order to update its values according to the new stock file

%comspec% /C "Z:\Stock File Fetcher\StockFeed\StaxFeed\Scripts\SaveAsTxt.vbs"
::This is a .vbs script that saves reference.xlsx as a .txt file using the "Save As" function without opening the interface

move stax.txt "Z:\Stock File Fetcher\Upload"
::This moves the final upload file to the Stock File Fetcher folder so that it can be submitted to Amazon

"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\Upload" --fileMask "*stax.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "FALSE				0	5" --replace ""
::This uses an open-source tool to find all the "FALSE" records and delete them, leaving a blank space

cd "Z:\Stock File Fetcher\Upload"
findstr "[[A-Z] [0-9] ,]" stax.txt > staxgrep.txt
del stax.txt
ren staxgrep.txt stax.txt
del staxgrep.txt
::This uses the Windows equivalent of the GREP function found in UNIX to remove all empty lines from the upload file

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
echo .>> stax.txt
