Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSsealey.txt" -Force
$Host.UI.RawUI.WindowTitle = 'SealeyFeed'

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\SealeyFeed\Scripts"
If (Test-Path -Path "sealey.xlsx"){del sealey.xlsx}

"Acquiring File"
. "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\ftp.ps1"
gc login.txt | ForEach-Object{Invoke-Expression $_}
$LocalFile = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\SealeyFeed\Scripts\sealey.xlsx"
FTP-Download $RemoteFile $Username $Password $LocalFile

. "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\timestamp.ps1"
$dt = Get-FileDateTime $RemoteFile $Username $Password
Add-Content "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\ScheduleTracking\SYSCHEDULE.txt" ($dt)

"OpenAndSave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\SealeyFeed\Scripts\OpenAndSave.ps1" /C

"Moving File to Upload folder"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\SealeyFeed"
move sealey.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
Stop-Transcript
