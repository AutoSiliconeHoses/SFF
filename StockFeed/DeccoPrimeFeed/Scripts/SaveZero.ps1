$excel = New-Object -ComObject "Excel.Application"
$excel.DisplayAlerts = $FALSE
  $file = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoPrimeFeed\Scripts\deccoprime.xml"
  $workbook = $excel.Workbooks.Open($file)
  $workbook.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoPrimeFeed\Scripts\deccoprime.csv", 6)

  $file = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoPrimeFeed\Scripts\deccoprime.csv"
  $workbook = $excel.Workbooks.Open($file)
    $worksheet = $Workbook.sheets.item(1)
      $range = $worksheet.UsedRange
      $rows = $range.Rows.Count - 6
      $extendrange = "A2:F$rows"
  $workbook.Save()
  $workbook.Saved = $True

  cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoPrimeFeed\Scripts"
  cp dcpmacro.xlsm dcpmacro2.xlsm

  "`tdcpzero.xlsx"
  $file = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoPrimeFeed\Scripts\dcpzero.xlsx"
  $workbook = $excel.Workbooks.Open($file)
    $worksheet = $workbook.worksheets.item(1)
    $worksheet.Rows("3:" + $worksheet.Rows.Count).EntireRow.Delete
    $worksheet.Range($extendrange).FillDown()
    $columns = 1..6
    $worksheet.UsedRange.Removeduplicates($columns)
  $workbook.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoPrimeFeed\deccoprime.txt", -4158)
  $workbook.Save()
  $workbook.Saved = $True
  $workbook.Close()

$excel.Quit()
[System.Runtime.Interopservices.Marshal]::FinalReleaseComObject($excel)
