TITLE ToolBankFeed
Z:
cd "Z:\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts"
ftp -s:login.txt 195.74.141.134
rename Availability20D.csv stock.csv

"Z:\Stock File Fetcher\StockFeed\Programs\csv2xlsx_386.exe" -infile stock.csv -outfile stock.xlsx -colsep ","
del stock.csv

cd "Z:\Stock File Fetcher\Upload"
If exist toolbank.txt del toolbank.txt

%comspec% /C "Z:\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\OpenAndSave2.vbs"
%comspec% /C "Z:\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\OpenAndSave.vbs"
%comspec% /C "Z:\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\SaveAsTxt.vbs"

"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\StockFeed\ToolBankFeed" --fileMask "*toolbank.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "FALSE				0	5" --replace ""

cd "Z:\Stock File Fetcher\StockFeed\ToolBankFeed"
findstr "[[A-Z] [0-9] ,]" toolbank.txt > toolbankgrep.txt
del toolbank.txt
ren toolbankgrep.txt toolbank.txt
del toolbankgrep.txt

move toolbank.txt "Z:\Stock File Fetcher\Upload"

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
echo .>> toolbank.txt
