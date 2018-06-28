Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANStoolbank.txt" -Force
$Host.UI.RawUI.WindowTitle = 'ToolBankFeed'

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts"

If (Test-Path -Path "Availability20D.csv"){del Availability20D.csv}
If (Test-Path -Path "toolbank.csv"){del toolbank.csv}

"Acquiring File"
ftp -s:login.txt 195.74.141.134

Rename-Item Availability20D.csv toolbank.csv

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
