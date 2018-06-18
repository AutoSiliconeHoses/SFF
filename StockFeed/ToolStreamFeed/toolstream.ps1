#Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANStoolstream.txt" -Force -NoClobber
$Host.UI.RawUI.WindowTitle = "ToolStreamFeed"
Z:
cd "Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\Scripts"
"Acquiring File"
ftp -s:login.txt ftp.toolstream.com

cd "Z:\Stock File Fetcher\StockFeed\ToolStreamFeed"
If (Test-Path -Path "toolstream.txt") {del toolstream.txt}
"Processing File"
"OpenAndSave.ps1"
& "Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\Scripts\OpenAndSave.ps1" /C

cd "Z:\Stock File Fetcher\StockFeed\ToolStreamFeed"

"Cleaning File"
(Get-Content 'Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt').replace("FALSE`t`t`t`t0`targreplace", "") | Set-Content 'Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt'
(Get-Content 'Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt').replace("FALSE`t`t`t`t20`targreplace", "") | Set-Content 'Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt'
(Get-Content 'Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt').replace("#REF!`t`t`t`t#REF!`targreplace", "") | Set-Content 'Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt'
(Get-Content 'Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt').replace("FALSE`t`t`t`t#REF!`targreplace", "") | Set-Content 'Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt'
(GC 'Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt')|?{$_.Trim(" `t")}|SC 'Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt'

"Moving File to Upload folder"
move toolstream.txt "Z:\Stock File Fetcher\Upload"
#Stop-Transcript
