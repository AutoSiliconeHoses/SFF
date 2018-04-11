C:
cd %userprofile%\Downloads
if exist "file.zip" (del "file.zip")
::This checks the Downloads folder for the stock file and deletes it, for all must serve the cycle

Z:

cd "Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\Scripts"
start download.html
::This script opens up s browser window so the user can add the stock file to their basket and download it, which is quite frankly the daftest system I've seen while making these

C:

cd %userprofile%\Downloads
:waitloop
if exist "file.zip" goto waitloopend
goto waitloop
:waitloopend
::This loop eagerly awaits the new stock file's arrival in the Downloads folder

move file.zip "Z:\Stock File Fetcher\StockFeed\ToolStreamFeed"
::This moves the new stock file to the Scripts folder

Z:

cd "Z:\Stock File Fetcher\StockFeed\ToolStreamFeed"
If exist toolstream.txt del toolstream.txt
::This deletes the existing upload file if it exists

"Z:\Stock File Fetcher\StockFeed\Programs\unzip.exe" "Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\file.zip"
::This uses an open-source tool to unzip the stock file

cd "Z:\Stock File Fetcher\StockFeed\ToolStreamFeed"
del file.zip
cd "Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\pricing"
move "Product Content And Pricing Information ENGLISH.xls" "Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\Scripts"
cd "Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\Scripts"
rd /s /q "Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\pricing"
::This moves the stock sheet out of its folder and deletes the folder because it looks unsightly, and we can't have that now can we

%comspec% /C "Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\Scripts\OpenAndSave.vbs"
::This is a .vbs script that opens and saves reference.xlsx in order to update its values according to the new stock file

%comspec% /C "Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\Scripts\SaveAsTxt.vbs"
::This is a .vbs script that saves reference.xlsx as a .txt file using the "Save As" function without opening the interface

cd "Z:\Stock File Fetcher\StockFeed\ToolStreamFeed"
move toolstream.txt "Z:\Stock File Fetcher\Upload"
::This moves the final upload file to the Stock File Fetcher folder so that it can be submitted to Amazon

"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\Upload" --fileMask "*toolstream.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "FALSE				0	4" --replace ""
"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\Upload" --fileMask "*toolstream.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "FALSE				20	4" --replace ""
"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\Upload" --fileMask "*toolstream.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "#REF!				#REF!	4" --replace ""
::This uses an open-source tool to find all the "FALSE" records and delete them, leaving a blank space

cd "Z:\Stock File Fetcher\Upload"
findstr "[[A-Z] [0-9] ,]" toolstream.txt > grep.txt
del toolstream.txt
ren grep.txt toolstream.txt
del grep.txt
::This uses the Windows equivalent of the GREP function found in UNIX to remove all empty lines from the upload file

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
echo .>> toolstream.txt
