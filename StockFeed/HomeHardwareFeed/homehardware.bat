Z:
cd "Z:\Stock File Fetcher\Upload"
If exist homehardware.txt del homehardware.txt
::This deletes the existing upload file if it exists

cd "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts"
if exist combine.csv del combine.csv
::This deletes the old stock file if it exists

ftp -s:login.txt 195.74.141.134
::This automatically connects to the Home Hardware FTP server and downloads both stock files

move Primary1.csv "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed"
move Primary15.csv "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed"
cd "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed"
copy *.csv combine.csv
move combine.csv "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts"
del Primary1.csv
del Primary15.csv
::This combines the stock .csv files into one single file

cd "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts"
"Z:\Stock File Fetcher\StockFeed\Programs\csv2xlsx_386.exe" -infile combine.csv -outfile combine.xlsx -colsep ","
::This converts combine.csv to an .xlsx file

%comspec% /C "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\OpenAndSave.vbs"
::This is a .vbs script that opens and saves reference.xlsx in order to update its values according to the new stock file

%comspec% /C "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\OpenAndSave2.vbs"
::This is a .vbs script that opens and saves reference2.xlsx in order to update its values according to the new stock file

%comspec% /C "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\OpenAndSave3.vbs"
::This is a .vbs script that opens and saves macro.xlsm in order to update its values according to the new stock file

if exist macro2.xlsm del macro2.xlsm
copy macro.xlsm macro2.xlsm
::This creates a new macro2.xlsm, as the macro is single-use and nukes any formulae currently in the spreadsheet

%comspec% /C "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\RunMacro.vbs"
::This is a .vbs script that opens macro2.xlsm and runs a macro that removes duplicate SKUs while summing the quantity values

%comspec% /C "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\SaveAsTxt.vbs"
::This is a .vbs script that saves reference3.xlsx as a .txt file using the "Save As" function without opening the interface

"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed" --fileMask "*upload.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "FALSE				0	4" --replace ""
"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed" --fileMask "*upload.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "?stock_no-HH				0	4" --replace ""
"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed" --fileMask "*upload.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "?-HH				0	4						" --replace ""
"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed" --fileMask "*upload.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "#VALUE!				0	4" --replace ""
::This uses an open-source tool to find all the "FALSE" records and delete them, leaving a blank space

cd "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed"
findstr "[[A-Z] [0-9] ,]" upload.txt > grep.txt
del upload.txt
ren grep.txt homehardware.txt
del grep.txt
::This uses the Windows equivalent of the GREP function found in UNIX to remove all empty lines frome the upload file

move homehardware.txt "Z:\Stock File Fetcher\Upload"
::This moves the final upload file to the Stock File Fetcher folder so that it can be submitted to Amazon

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
echo .>> homehardware.txt
