Z:
cd "Z:\Stock File Fetcher\StockFeed\DraperFeed\Scripts"
ftp -s:login.txt 62.255.240.235

"Z:\Stock File Fetcher\StockFeed\Programs\csv2xlsx_386.exe" -infile stock.csv -outfile stock.xlsx -colsep ","
del stock.csv
::This converts the stock file to .xlsx format so that it can be referenced by the Stock sheet

cd "Z:\Stock File Fetcher\Upload"
If exist draper.txt del draper.txt
::This deletes the existing reference file if it exists

%comspec% /C "Z:\Stock File Fetcher\StockFeed\DraperFeed\Scripts\OpenAndSave.vbs"
::This is a .vbs script that opens and saves reference.xlsx in order to update its values according to the new stock file

%comspec% /C "Z:\Stock File Fetcher\StockFeed\DraperFeed\Scripts\SaveAsTxt.vbs"
::This is a .vbs script that saves reference.xlsx as a .txt file using the "Save As" function without opening the interface

"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\StockFeed\DraperFeed" --fileMask "*upload.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "FALSE				0	4" --replace ""
::This uses an open-source tool to find all the "FALSE" records and delete them, leaving a blank space

cd "Z:\Stock File Fetcher\StockFeed\DraperFeed"
findstr "[[A-Z] [0-9] ,]" upload.txt > grep.txt
del upload.txt
ren grep.txt draper.txt
del grep.txt
::This uses the Windows equivalent of the GREP function found in UNIX to remove all empty lines frome the upload file

move draper.txt "Z:\Stock File Fetcher\Upload"
::This moves the final upload file to the Stock File Fetcher folder so that it can be submitted to Amazon

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
echo .>> draper.txt
