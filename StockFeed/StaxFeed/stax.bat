C:
cd %userprofile%\Downloads
if exist "stock.csv" (del "stock.csv")

Z:

cd "Z:\Stock File Fetcher\StockFeed\StaxFeed\Scripts"
start /min download.html
::This checks the Downloads folder for the stock file and deletes it, downloading a new one and closing the Chrome window after 10 seconds

C:

cd %userprofile%\Downloads
:waitloop
if exist "stock.csv" goto waitloopend
goto waitloop
:waitloopend
::This loop checks for the new stock file to appear in the Downloads folder

move stock.csv "Z:\Stock File Fetcher\StockFeed\StaxFeed\Scripts"
::This moves the new stock file to the Scripts folder

Z:

cd "Z:\Stock File Fetcher\StockFeed\StaxFeed\Scripts"
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

"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\Upload" --fileMask "*stax.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "FALSE				0	4" --replace ""
::This uses an open-source tool to find all the "FALSE" records and delete them, leaving a blank space

cd "Z:\Stock File Fetcher\Upload"
findstr "[[A-Z] [0-9] ,]" stax.txt > grep.txt
del stax.txt
ren grep.txt stax.txt
del grep.txt
::This uses the Windows equivalent of the GREP function found in UNIX to remove all empty lines from the upload file

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
echo .>> stax.txt