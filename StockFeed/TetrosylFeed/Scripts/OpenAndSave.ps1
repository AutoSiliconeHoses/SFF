$file = Dir 'Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\' -Recurse | ? {$_.Name -eq "stock.csv"} | Select -ExpandProperty FullName
$excl = New-Object -ComObject "Excel.Application"
  $wrkb = $excl.Workbooks.Open($file)
    $excl.DisplayAlerts = $FALSE
    $wrkb.Save()
  $wrkb.Close()
$excl.Quit()
