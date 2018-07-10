$excel = New-Object -ComObject "Excel.Application"
$excel.DisplayAlerts = $FALSE
  $file = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoFeed\Scripts\decco.xml"
  $workbook = $excel.Workbooks.Open($file)
  $workbook.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoFeed\Scripts\decco.csv", 6)

  $file = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoFeed\Scripts\decco.csv"
  $workbook = $excel.Workbooks.Open($file)
    $worksheet = $Workbook.sheets.item(1)
      $range = $worksheet.UsedRange
      $rows = $range.Rows.Count - 6
      $extendrange = "A2:F$rows"
  $workbook.Save()
  $workbook.Saved = $True

  "`tdcmacro.xlsm"
  $file = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoFeed\Scripts\dcmacro.xlsm"
  $workbook = $excel.Workbooks.Open($file)
    $worksheet = $workbook.Worksheets.Item(1)
    $worksheet.Rows("2:" + $worksheet.Rows.Count).EntireRow.Delete
    $worksheet.Range($extendrange).FillDown()
  $workbook.Save()
  $workbook.Saved = $True

  cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoFeed\Scripts"
  copy dcmacro.xlsm dcmacro2.xlsm

  "`tdcmacro2.xlsm"
  $file = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoFeed\Scripts\dcmacro2.xlsm"
  $workbook = $excel.Workbooks.Open($file)
    $worksheet = $workbook.Worksheets.Item(1)
    $excel.run("CombineRows")
  $workbook.Save()
  $workbook.Saved = $True

  "`tdcreference.xlsx"
  $file = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoFeed\Scripts\dcreference.xlsx"
  $workbook = $excel.Workbooks.Open($file)
    $worksheet = $workbook.worksheets.item(1)
    $worksheet.Rows("3:" + $worksheet.Rows.Count).EntireRow.Delete
    $worksheet.Range($extendrange).FillDown()
      $columns = 1, 2, 3, 4, 5, 6
    $worksheet.UsedRange.Removeduplicates($columns)
  $workbook.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoFeed\decco.txt", -4158)
  $workbook.Save()
  $workbook.Saved = $True
  $workbook.Close()

$excel.Quit()
[System.Runtime.Interopservices.Marshal]::FinalReleaseComObject($excel)
