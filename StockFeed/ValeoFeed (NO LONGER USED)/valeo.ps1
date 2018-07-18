Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSvaleo.txt" -Force
$Host.UI.RawUI.WindowTitle = $title = 'ValeoFeed'

"Acquiring File"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Dropzone\Valeo"
If (!(Test-Path -Path "VALEO_stock.csv")) {
	"No valeo file found. Aborting."
	Start-Sleep 2
	EXIT
}
copy "VALEO_stock.csv" "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ValeoFeed\Scripts"

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ValeoFeed\Scripts"
"Processing File"
"OpenAndsave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ValeoFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning File"
# (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt').replace("FALSE`t`t`t`t0`targreplace", "") | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt'
# (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt').replace("#VALUE!`t`t`t`t20`targreplace", "") | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt'
# (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt').replace("C`t`t`t`t20`targreplace", "") | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt'
# (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt')|?{$_.Trim(" `t")}|sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt'

"Moving File to Upload folder"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ValeoFeed"
move valeo.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
Stop-Transcript
