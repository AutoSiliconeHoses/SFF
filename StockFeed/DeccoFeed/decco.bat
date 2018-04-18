TITLE DeccoFeed
Z:
cd "Z:\Stock File Fetcher\StockFeed\GUI\Dropzone\Decco"
del *.xls
::This deletes any old Decco stock files from the Dropzone

%SystemRoot%\explorer.exe "Z:\Stock File Fetcher\StockFeed\GUI\Dropzone\Decco"
::This opens the correct Dropzone folder in Explorer on the newly-mapped network drive

:waitloop
if exist *.zip goto waitloopend
goto waitloop
:waitloopend
::This loop waits for the new stock file to be moved to the Dropzone

move *.zip "Z:\Stock File Fetcher\StockFeed\DeccoFeed"
::This moves the new stock file to the correct folder

cd "Z:\Stock File Fetcher\StockFeed\DeccoFeed"
If exist decco.txt del decco.txt
::This deletes the existing upload file if it exists

cd "Z:\Stock File Fetcher\StockFeed\DeccoFeed"
ren *.zip file.zip

"Z:\Stock File Fetcher\StockFeed\Programs\unzip.exe" "Z:\Stock File Fetcher\StockFeed\DeccoFeed\file.zip"
::This uses an open-source tool to unzip the stock file

del file.zip
ren *xls stock.xls
move stock.xls "Z:\Stock File Fetcher\StockFeed\DeccoFeed\Scripts"
cd "Z:\Stock File Fetcher\StockFeed\DeccoFeed\Scripts"

%comspec% /C "Z:\Stock File Fetcher\StockFeed\DeccoFeed\Scripts\OpenAndSave.vbs"

%comspec% /C "Z:\Stock File Fetcher\StockFeed\DeccoFeed\Scripts\SaveAsTxt.vbs"

cd "Z:\Stock File Fetcher\StockFeed\DeccoFeed"
move decco.txt "Z:\Stock File Fetcher\Upload"

findstr "[[A-Z] [0-9] ,]" decco.txt > deccogrep.txt
del decco.txt
ren deccogrep.txt decco.txt
del deccogrep.txt

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
echo .>> decco.txt
