Z:
cd "Z:\Stock File Fetcher\StockFeed\GUI\Dropzone\KYB"
if exist "KYBSTOCK.csv" (del "KYBSTOCK.csv")
::This deletes any old KYB stock files from the Dropzone

%SystemRoot%\explorer.exe "Z:\Stock File Fetcher\StockFeed\GUI\Dropzone\KYB"
::This opens the correct Dropzone folder in Explorer on the newly-mapped network drive

:waitloop
if exist "KYBSTOCK.csv" goto waitloopend
goto waitloop
:waitloopend
::This loop waits for the new stock file to be moved to the Dropzone

move "KYBSTOCK.csv" "Z:\Stock File Fetcher\StockFeed\KYBFeed\Scripts"

cd "Z:\Stock File Fetcher\StockFeed\KYBFeed\Scripts"
"Z:\Stock File Fetcher\StockFeed\Programs\csv2xlsx_386.exe" -infile "KYBSTOCK.csv" -outfile stock.xlsx -colsep ","
del "KYBSTOCK.csv"
::This converts the stock file to .xlsx format so that it can be referenced by the Stock sheet

cd "Z:\Stock File Fetcher\Upload"
If exist kyb.txt del kyb.txt
::This deletes the existing upload file if it exists

%comspec% /C "Z:\Stock File Fetcher\StockFeed\KYBFeed\Scripts\OpenAndSave.vbs"
::This is a .vbs script that opens and saves reference.xlsx in order to update its values according to the new stock file

%comspec% /C "Z:\Stock File Fetcher\StockFeed\KYBFeed\Scripts\SaveAsTxt.vbs"
::This is a .vbs script that saves reference.xlsx as a .txt file using the "Save As" function without opening the interface

"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\StockFeed\KYBFeed" --fileMask "*upload.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "FALSE				0	4" --replace ""
::This uses an open-source tool to find all the "FALSE" records and delete them, leaving a blank space

cd "Z:\Stock File Fetcher\StockFeed\KYBFeed"
findstr "[[A-Z] [0-9] ,]" upload.txt > grep.txt
del upload.txt
ren grep.txt kyb.txt
del grep.txt
::This uses the Windows equivalent of the GREP function found in UNIX to remove all empty lines from the upload file

move kyb.txt "Z:\Stock File Fetcher\Upload"
::This moves the final upload file to the Stock File Fetcher folder so that it can be submitted to Amazon

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
echo .>> kyb.txt
