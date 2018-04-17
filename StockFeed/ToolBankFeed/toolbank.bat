Z:
cd "Z:\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts"
ftp -s:login.txt 195.74.141.134
::This automatically logs in to the ToolBank FTP server and downloads the stock file

rename Availability20D.csv stock.csv
::This renames the stock file so that it fits into all the other garbage I copied from the Stax script

"Z:\Stock File Fetcher\StockFeed\Programs\csv2xlsx_386.exe" -infile stock.csv -outfile stock.xlsx -colsep ","
del stock.csv
::This converts the stock file to .xlsx format so that it can be referenced by the Stock sheet

cd "Z:\Stock File Fetcher\Upload"
If exist toolbank.txt del toolbank.txt
::This deletes the existing reference file if it exists

%comspec% /C "Z:\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\OpenAndSave2.vbs"
::This is a .vbs script that opens and saves reference2.xlsx in order to update its values according to the new stock file

%comspec% /C "Z:\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\OpenAndSave.vbs"
::This is a .vbs script that opens and saves reference.xlsx in order to update its values according to the new stock file

%comspec% /C "Z:\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\SaveAsTxt.vbs"
::This is a .vbs script that saves reference.xlsx as a .txt file using the "Save As" function without opening the interface

"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\StockFeed\ToolBankFeed" --fileMask "*toolbank.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "FALSE				0	4" --replace ""
::This uses an open-source tool to find all the "FALSE" records and delete them, leaving a blank space

cd "Z:\Stock File Fetcher\StockFeed\ToolBankFeed"
findstr "[[A-Z] [0-9] ,]" toolbank.txt > toolbankgrep.txt
ren toolbankgrep.txt toolbank.txt
del toolbankgrep.txt
::This uses the Windows equivalent of the GREP function found in UNIX to remove all empty lines from the upload file

move toolbank.txt "Z:\Stock File Fetcher\Upload"
::This moves the final upload file to the Stock File Fetcher folder so that it can be submitted to Amazon

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
echo .>> toolbank.txt
