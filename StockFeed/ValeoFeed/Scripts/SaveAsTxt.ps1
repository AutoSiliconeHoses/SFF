$file = Dir 'Z:\Stock File Fetcher\StockFeed\ValeoFeed\Scripts\reference.xlsx'
$excl = New-Object -ComObject "Excel.Application"
  $wrkb = $excl.Workbooks.Open($file)
    $excl.DisplayAlerts = $FALSE
    $wrkb.SaveAs("Z:\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt", -4158)
  $wrkb.Close()
$excl.Quit()
