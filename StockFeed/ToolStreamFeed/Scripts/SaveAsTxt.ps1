$file = Dir 'Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\Scripts\reference.xlsx'
$excl = New-Object -ComObject "Excel.Application"
  $wrkb = $excl.Workbooks.Open($file)
    $excl.DisplayAlerts = $FALSE
    $wrkb.SaveAs("Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt", -4158)
  $wrkb.Close()
$excl.Quit()
