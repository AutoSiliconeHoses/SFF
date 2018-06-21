#Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANStoolstream.txt" -Force -NoClobber
$Host.UI.RawUI.WindowTitle = "ToolStreamFeed"

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\Scripts"
"Acquiring File"
ftp -s:login.txt ftp.toolstream.com

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed"
If (Test-Path -Path "toolstream.txt") {del toolstream.txt}
"Processing File"
"OpenAndSave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\Scripts\OpenAndSave.ps1" /C

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed"

"Cleaning File"
(Get-Content '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt').replace("FALSE`t`t`t`t0`targreplace", "") | Set-Content '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt'
(Get-Content '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt').replace("FALSE`t`t`t`t20`targreplace", "") | Set-Content '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt'
(Get-Content '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt').replace("#REF!`t`t`t`t#REF!`targreplace", "") | Set-Content '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt'
(Get-Content '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt').replace("FALSE`t`t`t`t#REF!`targreplace", "") | Set-Content '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt'
(GC '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt')|?{$_.Trim(" `t")}|SC '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt'

"Moving File to Upload folder"
move toolstream.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
#Stop-Transcript
