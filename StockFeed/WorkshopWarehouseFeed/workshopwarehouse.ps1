#Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSworkshopwarehouse.txt" -Force -NoClobber
$Host.UI.RawUI.WindowTitle = "WorkshopWarehouseFeed"
Z:
cd "Z:\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed\Scripts"
If (Test-Path -Path workshopwarehouse.xls) {del workshopwarehouse.xls}
If (Test-Path -Path workshopwarehouse.xlsx) {del workshopwarehouse.xlsx}

"Acquiring File"
cd "Z:\Stock File Fetcher\StockFeed\GUI\Dropzone\Workshop Warehouse"
copy workshopwarehouse.xls "Z:\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed\Scripts"

cd "Z:\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed\Scripts"
"OpenAndSave.ps1"
& "Z:\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning File"
(GC 'Z:\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed\workshopwarehouse.txt').replace("FALSE`t`t`t`t0`targreplace", "") | SC 'Z:\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed\workshopwarehouse.txt'
(GC 'Z:\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed\workshopwarehouse.txt')|?{$_.Trim(" `t")}|SC 'Z:\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed\workshopwarehouse.txt'

"Moving File to Upload folder"
cd "Z:\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed"
move workshopwarehouse.txt "Z:\Stock File Fetcher\Upload"
If (Test-Path -Path workshopwarehouse.txt) {del workshopwarehouse.txt}
#Stop-Transcript
