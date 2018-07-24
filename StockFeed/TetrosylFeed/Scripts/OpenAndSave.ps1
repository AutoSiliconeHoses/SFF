$excel = New-Object -ComObject "Excel.Application"
$excel.DisplayAlerts = $FALSE

  $file = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\tetrosyl.csv'
  $workbook = $excel.Workbooks.Open($file)
    $worksheet = $workbook.sheets.item(1)
      $range = $worksheet.UsedRange
      $rows = $range.Rows.Count - 1
      $extendrange = "A1:F$rows"
  $workbook.Save()
  $workbook.Saved = $True

  $file = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\tlmacro.xlsm"
  $workbook = $excel.Workbooks.Open($file)
    $worksheet = $workbook.Worksheets.Item(1)
    $worksheet.Rows("2:" + $worksheet.Rows.Count).EntireRow.Delete
    $worksheet.Range($extendrange).FillDown()
  $workbook.Save()
  $workbook.Saved = $True

  cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts"
  copy tlmacro.xlsm tlmacro2.xlsm

  "`ttlmacro2.xlsm"
  $file = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\tlmacro2.xlsm'
  $workbook = $excel.Workbooks.Open($file)
    $worksheet = $workbook.sheets.item(1)
      $range = $worksheet.UsedRange
      $rows = $range.Rows.Count
      $extendrange = "A1:F$rows"
    $excel.run("CombineRows")
  $workbook.Save()
  $workbook.Saved = $True

  "`ttlreference.xlsx"
  $file = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\tlreference.xlsx'
  $workbook = $excel.Workbooks.Open($file)
    $worksheet = $workbook.Worksheets.Item(1)
      $extendrange = "A2:F$rows"
    $worksheet.Rows("3:" + $worksheet.Rows.Count).EntireRow.Delete
    $worksheet.Range($extendrange).FillDown()
    $columns = 1..6
    $worksheet.UsedRange.Removeduplicates($columns)
  $workbook.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\tetrosyl.txt", -4158)
  $workbook.Save()
  $workbook.Saved = $True
  $workbook.Close()

$excel.Quit()
[System.Runtime.Interopservices.Marshal]::FinalReleaseComObject($excel)
