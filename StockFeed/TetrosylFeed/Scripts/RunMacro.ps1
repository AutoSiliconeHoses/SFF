$file = Dir 'Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\' -Recurse | ? {$_.Name -eq "tlmacro.xlsm"} | Select -ExpandProperty FullName
$excl = New-Object -ComObject "Excel.Application"
  $wrkb = $excl.Workbooks.Open($file)
    $excl.DisplayAlerts = $FALSE
    $excl.Run("CombineRows")
  $wrkb.Close()
$excl.Quit()
