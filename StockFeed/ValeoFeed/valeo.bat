TITLE ValeoFeed
Z:
cd "Z:\Stock File Fetcher\StockFeed\GUI\Dropzone\Valeo"
if exist "VALEO_stock.csv" (del "VALEO_stock.csv")
::This deletes any old Valeo stock files from the Dropzone

%SystemRoot%\explorer.exe "Z:\Stock File Fetcher\StockFeed\GUI\Dropzone\Valeo"
::This opens the correct Dropzone folder in Explorer on the newly-mapped network drive

:waitloop
if exist "VALEO_stock.csv" goto waitloopend
goto waitloop
:waitloopend
::This loop waits for the new stock file to be moved to the Dropzone

move "VALEO_stock.csv" "Z:\Stock File Fetcher\StockFeed\ValeoFeed\Scripts"

cd "Z:\Stock File Fetcher\StockFeed\ValeoFeed\Scripts"
"Z:\Stock File Fetcher\StockFeed\Programs\csv2xlsx_386.exe" -infile "VALEO_stock.csv" -outfile stock.xlsx -colsep ","
del "VALEO_stock.csv"
::This converts the stock file to .xlsx format so that it can be referenced by the Stock sheet

cd "Z:\Stock File Fetcher\Upload"
If exist valeo.txt del valeo.txt
::This deletes the existing upload file if it exists

%comspec% /C "Z:\Stock File Fetcher\StockFeed\ValeoFeed\Scripts\OpenAndSave2.vbs"
::This is a .vbs script that opens and saves reference2.xlsx in order to update its values according to the new stock file

%comspec% /C "Z:\Stock File Fetcher\StockFeed\ValeoFeed\Scripts\OpenAndSave.vbs"
::This is a .vbs script that opens and saves reference.xlsx in order to update its values according to the new stock file

%comspec% /C "Z:\Stock File Fetcher\StockFeed\ValeoFeed\Scripts\SaveAsTxt.vbs"
::This is a .vbs script that saves reference.xlsx as a .txt file using the "Save As" function without opening the interface

"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\StockFeed\ValeoFeed" --fileMask "*valeo.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "FALSE				0	4" --replace ""
"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\StockFeed\ValeoFeed" --fileMask "*valeo.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "#VALUE!				20	4" --replace ""
"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\StockFeed\ValeoFeed" --fileMask "*valeo.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "C				20	4" --replace ""
::This uses an open-source tool to find all the "FALSE", "VALUE" & "C" records and deletes them, leaving a blank space

cd "Z:\Stock File Fetcher\StockFeed\ValeoFeed"
findstr "[[A-Z] [0-9] ,]" valeo.txt > valeogrep.txt
del valeo.txt
ren valeogrep.txt valeo.txt
del valeogrep.txt
::This uses the Windows equivalent of the GREP function found in UNIX to remove all empty lines from the upload file

move valeo.txt "Z:\Stock File Fetcher\Upload"
::This moves the final upload file to the Stock File Fetcher folder so that it can be submitted to Amazon

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
echo .>> valeo.txt
