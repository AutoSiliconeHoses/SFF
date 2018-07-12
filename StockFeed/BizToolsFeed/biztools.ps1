Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSbiztools.txt" -Force
$Host.UI.RawUI.WindowTitle = 'BizToolsFeed'

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\BizToolsFeed\Scripts"
If (Test-Path -Path "biztools.csv"){del biztools.csv}

"Acquiring File"
. "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\ftp.ps1"
gc login.txt | ForEach-Object{Invoke-Expression $_}

$LocalFile = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\BizToolsFeed\Scripts\biztools.csv"
FTP-Download $RemoteFile $Username $Password $LocalFile

"Processing File"
"OpenAndSave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\BizToolsFeed\Scripts\OpenAndSave.ps1" /C

# "Cleaning File"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\BizToolsFeed"
#(gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\BizToolsFeed\biztools.txt').replace("FALSE`t`t`t`t0`targreplace", "") | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\BizToolsFeed\biztools.txt'

"Moving File to Upload folder"
move biztools.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
Stop-Transcript
