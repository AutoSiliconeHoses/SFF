$file = Dir 'Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\' -Recurse | ? {$_.Name -eq "macro2.xlsm"} | Select -ExpandProperty FullName
$excl = New-Object -ComObject "Excel.Application"
  $wrkb = $excl.Workbooks.Open($file)
    $excl.DisplayAlerts = $FALSE
    $excl.Run("CombineRows")
  $wrkb.Close()
$excl.Quit()
