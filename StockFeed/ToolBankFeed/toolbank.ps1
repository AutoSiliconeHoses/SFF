$Host.UI.RawUI.WindowTitle = 'ToolBankFeed'
Z:
cd "Z:\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts"

If (Test-Path -Path "Availability20D.csv"){del Availability20D.csv}
If (Test-Path -Path "stock.csv"){del stock.csv}

"Acquiring File"
ftp -s:login.txt 195.74.141.134
Rename-Item Availability20D.csv stock.csv -force

cd "Z:\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts"
"Processing File"
"OpenAndsave.ps1"
& "Z:\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\OpenAndSave.ps1" /C

cd "Z:\Stock File Fetcher\StockFeed\ToolBankFeed"
"Cleaning File"
del ".\Scripts\stock.csv"
(Get-Content 'Z:\Stock File Fetcher\StockFeed\ToolBankFeed\toolbank.txt').replace("FALSE`t`t`t`t0`targreplace", "") | Set-Content 'Z:\Stock File Fetcher\StockFeed\ToolBankFeed\toolbank.txt'

If (Test-Path -Path "toolbankgrep.txt") {del toolbankgrep.txt}

findstr "[[A-Z] [0-9] ,]" toolbank.txt > toolbankgrep.txt
If (Test-Path -Path "toolbank.txt") {del toolbank.txt}

Rename-Item toolbankgrep.txt toolbank.txt

"Moving File to Upload folder"
move toolbank.txt "Z:\Stock File Fetcher\Upload"
