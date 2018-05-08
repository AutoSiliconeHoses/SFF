TITLE ToolStreamFeed
Z:
cd "Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\Scripts"
ftp -s:login.txt ftp.toolstream.com

cd "Z:\Stock File Fetcher\StockFeed\ToolStreamFeed"
If exist toolstream.txt del toolstream.txt

%comspec% /C "Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\Scripts\SaveAsTxt.vbs"

cd "Z:\Stock File Fetcher\StockFeed\ToolStreamFeed"

"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\StockFeed\ToolStreamFeed" --fileMask "*toolstream.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "FALSE				0	4" --replace ""
"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\StockFeed\ToolStreamFeed" --fileMask "*toolstream.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "FALSE				20	4" --replace ""
"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\StockFeed\ToolStreamFeed" --fileMask "*toolstream.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "FALSE				#REF!	4" --replace ""
"Z:\Stock File Fetcher\StockFeed\Programs\fnr.exe" --cl --dir "Z:\Stock File Fetcher\StockFeed\ToolStreamFeed" --fileMask "*toolstream.txt*" --excludeFileMask "*.dll, *.exe" --caseSensitive --find "#REF!				#REF!	4" --replace ""

findstr "[[A-Z] [0-9] ,]" toolstream.txt > toolstreamgrep.txt
del toolstream.txt
ren toolstreamgrep.txt toolstream.txt
del toolstreamgrep.txt

move toolstream.txt "Z:\Stock File Fetcher\Upload"

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
echo .>> toolstream.txt
