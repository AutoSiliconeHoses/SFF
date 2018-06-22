Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANStoolstream.txt" -Force
$Host.UI.RawUI.WindowTitle = "ToolStreamFeed"

"Acquiring File"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\Scripts"
If (Test-Path - Path "toolstream.xlsx") {del "toolstream.xlsx"}
If (Test-Path - Path "Product Content And Pricing Information ENGLISH.xlsx") {del "Product Content And Pricing Information ENGLISH.xlsx"}

ftp -s:login.txt ftp.toolstream.com
Rename-Item "Product Content And Pricing Information ENGLISH.xls" "toolstream.xlsx"

"OpenAndSave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\Scripts\OpenAndSave.ps1" /C


"Cleaning File"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed"
(gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt').replace("FALSE`t`t`t`t0`targreplace", "") | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt'
(gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt').replace("FALSE`t`t`t`t20`targreplace", "") | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt'
(gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt').replace("#REF!`t`t`t`t#REF!`targreplace", "") | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt'
(gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt').replace("FALSE`t`t`t`t#REF!`targreplace", "") | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt'
(gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt')|?{$_.Trim(" `t")}|sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt'

"Moving File to Upload folder"
move toolstream.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
Stop-Transcript
