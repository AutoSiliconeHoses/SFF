saps 'Outlook' -WindowStyle Hidden -ErrorAction SilentlyContinue -ArgumentList '/profile "Stocks" '
sleep 5
$Outlook = New-Object -ComObject Outlook.Application
$Mail = $Outlook.CreateItem(0)
$Mail.To = "gib@autosiliconehoses.com"
$Mail.Subject = "Alteration File Reminder"
$FileData = (Import-Csv "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\alterations.csv" | Format-Table | Out-String).replace("`n","<br/>")
$link = "<a href='\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\alterations.csv'>\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\alterations.csv</a>"
$body = "Below is the altrerations file found at $link<br/>Please make sure that the file is up top date.<br/><br/>$FileData"
$Mail.HTMLBody = $body
$Mail.importance = 2
$Mail.Send()
$Outlook.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($Outlook)
$Outlook = $null
