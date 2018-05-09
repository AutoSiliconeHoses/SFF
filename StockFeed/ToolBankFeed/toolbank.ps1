$Host.UI.RawUI.WindowTitle = 'ToolBankFeed'
Z:
cd "Z:\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts"

If (Test-Path -Path "Availability20D.csv"){del Availability20D.csv}
If (Test-Path -Path "stock.csv") {del stock.csv}

ftp -s:login.txt 195.74.141.134
Rename-Item Availability20D.csv stock.csv

cd "Z:\Stock File Fetcher\StockFeed\ToolBankFeed"
"OpenAndsave2.ps1"
& "Z:\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\OpenAndSave2.ps1" /C
"OpenAndsave.ps1"
& "Z:\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\OpenAndSave.ps1" /C
"SaveAsTxt.ps1"
& "Z:\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\SaveAsTxt.ps1" /C

"Cleaning files"
del ".\Scripts\stock.csv"
(Get-Content 'Z:\Stock File Fetcher\StockFeed\ToolBankFeed\toolbank.txt').replace("FALSE`t`t`t`t0`t4", "") | Set-Content 'Z:\Stock File Fetcher\StockFeed\ToolBankFeed\toolbank.txt'

If (Test-Path -Path "toolbankgrep.txt") {del toolbankgrep.txt}

findstr "[[A-Z] [0-9] ,]" toolbank.txt > toolbankgrep.txt
If (Test-Path -Path "toolbank.txt") {del toolbank.txt}

Rename-Item toolbankgrep.txt toolbank.txt

move toolbank.txt "Z:\Stock File Fetcher\Upload"

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
New-Item toolbank.txt -ItemType file
