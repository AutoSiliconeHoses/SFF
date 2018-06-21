#Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSvaleo.txt" -Force -NoClobber
$Host.UI.RawUI.WindowTitle = 'ValeoFeed'

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Dropzone\Valeo"
"Acquiring File"
copy "VALEO_stock.csv" "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ValeoFeed\Scripts"

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ValeoFeed\Scripts"
"Processing File"
"OpenAndsave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ValeoFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning File"
(Cat '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt').replace("FALSE`t`t`t`t0`targreplace", "") | SC '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt'
(Cat '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt').replace("#VALUE!`t`t`t`t20`targreplace", "") | SC '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt'
(Cat '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt').replace("C`t`t`t`t20`targreplace", "") | SC '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt'
(GC '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt')|?{$_.Trim(" `t")}|SC '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt'

"Moving File to Upload folder"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ValeoFeed"
move valeo.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
#Stop-Transcript
