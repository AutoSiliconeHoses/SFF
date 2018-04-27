$Host.UI.RawUI.WindowTitle = "ToolBankFeed"
Set-PSDebug -Trace 1
Z:
cd "Z:\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts"
ftp -s:login.txt 195.74.141.134
Rename-Item Availability20D.csv stock.csv

& "Z:\Stock File Fetcher\StockFeed\Programs\csv2xlsx_386.exe" -infile stock.csv -outfile stock.xlsx -colsep ","
del stock.csv

cd "Z:\Stock File Fetcher\Upload"

If (Test-Path -Path "toolbank.txt"){
  del toolbank.txt
}

cd "Z:\Stock File Fetcher\StockFeed\ToolBankFeed"

"OpenAndSave2.vbs"
& "Z:\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\OpenAndSave2.vbs" /C
"OpenAndSave.vbs"
& "Z:\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\OpenAndSave.vbs" /C
"SaveAsTxt.vbs"
& "Z:\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\SaveAsTxt.vbs" /C
ls
"Replacing String"
(Get-Content 'Z:\Stock File Fetcher\StockFeed\ToolBankFeed\toolbank.txt').replace("FALSE`t`t`t`t0`t5", "")   | Set-Content 'Z:\Stock File Fetcher\StockFeed\ToolBankFeed\toolbank.txt'

If (Test-Path -Path "toolbankgrep.txt"){
  del toolbankgrep.txt
}

findstr "[[A-Z] [0-9] ,]" toolbank.txt > toolbankgrep.txt
If (Test-Path -Path "toolbank.txt"){
  del toolbank.txt
}
Rename-Item toolbankgrep.txt toolbank.txt

move toolbank.txt "Z:\Stock File Fetcher\Upload"

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
New-Item toolbank.txt -ItemType file