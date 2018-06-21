If (Test-Path -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSfps.txt") {del "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSfps.txt" -ErrorAction SilentlyContinue}
Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSfps.txt" -Force -NoClobber -ErrorAction SilentlyContinue
$Host.UI.RawUI.WindowTitle = "FPSFeed"

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\Scripts"

If (Test-Path -Path FPS_LEEDS.xlsx) {del FPS_LEEDS.xlsx}
If (Test-Path -Path FPS_STOCK.csv) {del FPS_STOCK.csv}

"Acquiring File"
copy "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Dropzone\FPS\FPS_LEEDS.xlsx" "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\Scripts"
copy "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Dropzone\FPS\FPS_STOCK.csv" "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\Scripts"

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed"
If (Test-Path -Path fps.txt) {del fps.txt}
If (Test-Path -Path fps_leeds.txt) {del fps_leeds.txt}
If (Test-Path -Path fps_stock.txt) {del fps_stock.txt}

"OpenAndSave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\Scripts\OpenAndSave.ps1" /C

"Combining files"
gc fps_leeds.txt,fps_stock.txt | sc fps.txt
If (Test-Path -Path fps_leeds.txt) {del fps_leeds.txt}
If (Test-Path -Path fps_stock.txt) {del fps_stock.txt}

"Cleaning File"
(gc 'fps.txt').replace("FALSE`t`t`t`t0`targreplace", "") | sc 'fps.txt'
(gc 'fps.txt')|?{$_.Trim(" `t")}| sc 'fps.txt'

"Moving File to Upload folder"
move fps.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
Stop-Transcript
