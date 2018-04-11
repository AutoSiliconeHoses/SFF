Z:
cd "Z:\Stock File Fetcher\StockFeed\GUI\Dropzone\Tetrosyl
if exist parts_stock.csv (del "parts_stock.csv")
if exist non_parts_stock.csv (del "non_parts_stock.csv")
if exist combine.csv (del "combine.csv")
::This deletes any old Tetrosyl stock files from the Dropzone

%SystemRoot%\explorer.exe "z:\Stock File Fetcher\StockFeed\GUI\Dropzone\Tetrosyl"
::This opens the correct Dropzone folder in Explorer on the newly-mapped network drive

:parts
if exist "parts_stock.csv" goto partsend
goto parts
:partsend
:nonparts
if exist "non_parts_stock.csv" goto nonpartsend
goto nonparts
:nonpartsend
:express
if exist "ASH-STOCK.csv" goto expressend
goto express
:expressend
::These loops wait for the new stock files to be moved to the Dropzone

copy *.csv combine.csv
move combine.csv "Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts"
::This combines the stock .csv files into one single file

cd "Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts"
"Z:\Stock File Fetcher\StockFeed\Programs\csv2xlsx_386.exe" -infile combine.csv -outfile combine.xlsx -colsep ","
::This converts combine.csv to an .xlsx file

cd "Z:\Stock File Fetcher\Upload"
If exist tetrosyl.txt del tetrosyl.txt
::This deletes the existing reference file if it exists

%comspec% /C "Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\OpenAndSave.vbs"
::This is a .vbs script that opens and saves reference.xlsx in order to update its values according to the new stock file

%comspec% /C "Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\RunMacro.vbs"
::This is a .vbs script that opens macro.xlsm and runs a macro without opening the interface

%comspec% /C "Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\SaveAsTxt.vbs"
::This is a .vbs script that saves reference.xlsx as a .txt file using the "Save As" function without opening the interface

"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\StockFeed\tetrosylFeed" --fileMask "*upload.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "FALSE				0	4" --replace ""
"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\StockFeed\tetrosylFeed" --fileMask "*upload.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "?-TL				0	4" --replace ""
::This uses an open-source tool to find all the "FALSE" records and delete them, leaving a blank space

cd "Z:\Stock File Fetcher\StockFeed\TetrosylFeed"
findstr "[[A-Z] [0-9] ,]" upload.txt > grep.txt
del upload.txt
ren grep.txt tetrosyl.txt
del grep.txt
::This uses the Windows equivalent of the GREP function found in UNIX to remove all empty lines from the upload file

move tetrosyl.txt "Z:\Stock File Fetcher\Upload"
::This moves the final upload file to the Stock File Fetcher folder so that it can be submitted to Amazon

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
echo .>> tetrosyl.txt
