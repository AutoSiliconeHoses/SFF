#Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSworkshopwarehouse.txt" -Force -NoClobber
$Host.UI.RawUI.WindowTitle = "WorkshopWarehouseFeed"

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed\Scripts"
If (Test-Path -Path workshopwarehouse.xls) {del workshopwarehouse.xls}
If (Test-Path -Path workshopwarehouse.xlsx) {del workshopwarehouse.xlsx}

"Acquiring File"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Dropzone\Workshop Warehouse"
copy workshopwarehouse.xls "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed\Scripts"

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed\Scripts"
"OpenAndSave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning File"
(GC '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed\workshopwarehouse.txt').replace("FALSE`t`t`t`t0`targreplace", "") | SC '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed\workshopwarehouse.txt'
(GC '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed\workshopwarehouse.txt')|?{$_.Trim(" `t")}|SC '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed\workshopwarehouse.txt'

"Moving File to Upload folder"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed"
move workshopwarehouse.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
If (Test-Path -Path workshopwarehouse.txt) {del workshopwarehouse.txt}
#Stop-Transcript
