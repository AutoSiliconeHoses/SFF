Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANStoolbank.txt" -Force
$Host.UI.RawUI.WindowTitle = 'ToolBankFeed'

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts"
If (Test-Path -Path "toolbank.csv"){del toolbank.csv}

"Acquiring File"
. "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\ftp.ps1"
gc login.txt | ForEach-Object{Invoke-Expression $_}

$LocalFile = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\toolbank.csv"
FTP-Download $RemoteFile $Username $Password $LocalFile

. "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\timestamp.ps1"
$dt = Get-FileDateTime $RemoteFile $Username $Password
Add-Content "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\ScheduleTracking\TBSCHEDULE.txt" ($dt)

"Processing File"
"OpenAndSave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning File"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed"
# (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed\toolbank.txt').replace("FALSE`t`t`t`t0`targreplace", "") | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed\toolbank.txt'
# (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed\toolbank.txt')|?{$_.Trim(" `t")}|sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed\toolbank.txt'

"Moving File to Upload folder"
move toolbank.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
Stop-Transcript
