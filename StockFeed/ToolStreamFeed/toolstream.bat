Z:
cd "Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\Scripts"
ftp -s:login.txt ftp.toolstream.com
::This script opens up s browser window so the user can add the stock file to their basket and download it, which is quite frankly the daftest system I've seen while making these

cd "Z:\Stock File Fetcher\StockFeed\ToolStreamFeed"
If exist toolstream.txt del toolstream.txt
::This deletes the existing upload file if it exists

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
findstr "[[A-Z] [0-9] ,]" toolstream.txt > toolstreamgrep.txt
del toolstream.txt
ren toolstreamgrep.txt toolstream.txt
del toolstreamgrep.txt
::This uses the Windows equivalent of the GREP function found in UNIX to remove all empty lines from the upload file

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
echo .>> toolstream.txt
