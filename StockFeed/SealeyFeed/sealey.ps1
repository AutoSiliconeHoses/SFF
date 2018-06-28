Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSsealey.txt" -Force
$Host.UI.RawUI.WindowTitle = 'SealeyFeed'

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\SealeyFeed\Scripts"
If (Test-Path -Path "sealey.xlsx"){del sealey.xlsx}

"Acquiring File"
ftp -s:login.txt sealey.iweb-storage.com
Rename-Item Datacut.xlsx sealey.xlsx

"OpenAndSave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\SealeyFeed\Scripts\OpenAndSave.ps1" /C

"Moving File to Upload folder"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\SealeyFeed"
move sealey.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
Stop-Transcript
