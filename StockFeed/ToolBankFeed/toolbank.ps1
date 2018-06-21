#Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANStoolbank.txt" -Force -NoClobber
$Host.UI.RawUI.WindowTitle = 'ToolBankFeed'

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts"

If (Test-Path -Path "Availability20D.csv"){del Availability20D.csv}
If (Test-Path -Path "toolbankstock.csv"){del toolbankstock.csv}
If (Test-Path -Path "toolbank.csv"){del toolbank.csv}

"Acquiring File"
ftp -s:login.txt 195.74.141.134

If (Test-Path -Path toolbankstock.txt) {del toolbankstock.txt}
Rename-Item Availability20D.csv toolbankstock.txt

"Processing File"
"OpenAndSave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\OpenAndSave.ps1" /C

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed"
"Cleaning File"
(GC '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed\toolbank.txt').replace("FALSE`t`t`t`t0`targreplace", "") | SC '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed\toolbank.txt'
(GC '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed\toolbank.txt')|?{$_.Trim(" `t")}|SC '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed\toolbank.txt'

"Moving File to Upload folder"
move toolbank.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
#Stop-Transcript
