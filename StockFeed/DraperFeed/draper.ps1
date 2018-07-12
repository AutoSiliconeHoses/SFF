Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSdraper.txt" -Force
$Host.UI.RawUI.WindowTitle = "DraperFeed"

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\Scripts"
If (Test-Path -Path draper.csv) {del draper.csv}

"Acquiring File"
. "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\ftp.ps1"
gc login.txt | ForEach-Object{Invoke-Expression $_}
$LocalFile = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\Scripts\draper.csv"
FTP-Download $RemoteFile $Username $Password $LocalFile

. "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\timestamp.ps1"
$dt = Get-FileDateTime $RemoteFile $Username $Password
Add-Content "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\ScheduleTracking\DPSCHEDULE.txt" ($dt)

"Processing File"
"OpenAndSave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning File"
# (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\draper.txt').replace("FALSE`t`t`t`t0`targreplace", "") | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\draper.txt'

"Moving File to Upload folder"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed"
move draper.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
Stop-Transcript
