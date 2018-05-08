$Host.UI.RawUI.WindowTitle = "ToolStreamFeed"
Z:
cd "Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\Scripts"
ftp -s:login.txt ftp.toolstream.com

cd "Z:\Stock File Fetcher\StockFeed\ToolStreamFeed"
If (Test-Path -Path "toolstream.txt") {del toolstream.txt}
"OpenAndSave.ps1"
& "Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\Scripts\OpenAndSave.ps1" /C
"SaveAsTxt.ps1"
& "Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\Scripts\SaveAsTxt.ps1" /C

cd "Z:\Stock File Fetcher\StockFeed\ToolStreamFeed"

"Cleaning Files"
(Get-Content 'Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt').replace("FALSE`t`t`t`t0`t5", "") | Set-Content 'Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt'
(Get-Content 'Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt').replace("FALSE`t`t`t`t20`t5", "") | Set-Content 'Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt'
(Get-Content 'Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt').replace("#REF!`t`t`t`t#REF!`t5", "") | Set-Content 'Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt'
(Get-Content 'Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt').replace("FALSE`t`t`t`t#REF!`t5", "") | Set-Content 'Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt'

If (Test-Path -Path "toolstreamgrep.txt") {
  del toolstreamgrep.txt
}

findstr "[[A-Z] [0-9] ,]" toolstream.txt > toolstreamgrep.txt

If (Test-Path -Path "toolstream.txt") {del toolstream.txt}

Rename-Item toolstreamgrep.txt toolstream.txt

move toolstream.txt "Z:\Stock File Fetcher\Upload"

cd "Z:\Stock File Fetcher\StockFeed\GUI\Output"
New-Item toolstream.txt -ItemType file
