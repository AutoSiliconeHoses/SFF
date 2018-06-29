$excel = New-Object -ComObject "Excel.Application"
$excel.DisplayAlerts = $FALSE

  $file = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\Scripts\FPS_LEEDS.xlsx"
  $stockworkbook = $excel.Workbooks.Open($file)
    $worksheet = $stockworkbook.sheets.item(1)
      $range = $worksheet.UsedRange
      $rows = $range.Rows.Count - 1
      $extendrange = "A2:F$rows"
  $stockworkbook.Save()

  $file = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\Scripts\fpsreference.xlsx'
  $workbook = $excel.Workbooks.Open($file)
    $worksheet = $workbook.Worksheets.Item(1)
      $worksheet.Rows("3:" + $worksheet.Rows.Count).EntireRow.Delete
      $worksheet.Range($extendrange).FillDown()
      $columns = 1, 2, 3, 4, 5, 6
      $worksheet.UsedRange.Removeduplicates($columns)
    $workbook.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\fps_leeds.txt", -4158)
  $workbook.Close()
  $stockworkbook.Close()
$excel.Quit()
