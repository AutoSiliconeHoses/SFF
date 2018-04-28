$file = Dir 'Z:\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\reference2.xlsx'
$excl = New-Object -ComObject "Excel.Application"
  $wrkb = $excl.Workbooks.Open($file)
    $excl.DisplayAlerts = $TRUE
    $wrkb.SaveAs("Z:\Stock File Fetcher\StockFeed\ToolBankFeed\toolbank.txt", -4158)
  $wrkb.Close()
$excl.Quit()
