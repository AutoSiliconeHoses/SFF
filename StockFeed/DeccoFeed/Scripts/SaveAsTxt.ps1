$file = Dir 'Z:\Stock File Fetcher\StockFeed\DeccoFeed\Scripts\reference.xlsx'
$excl = New-Object -ComObject "Excel.Application"
  $wrkb = $excl.Workbooks.Open($file)
    $excl.DisplayAlerts = $FALSE
    $wrkb.SaveAs("Z:\Stock File Fetcher\StockFeed\DeccoFeed\decco.txt", -4158)
  $wrkb.Close()
$excl.Quit()
