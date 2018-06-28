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
    $workbook.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\Scripts\fps_leeds.txt", -4158)
  $workbook.Close()
  $stockworkbook.Close()
  
  "Converting File"
  #Define input and Output
  $csv = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\Scripts\FPS_STOCK.csv"
  $xlsx = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\Scripts\FPS_STOCK.xlsx"
  $delimiter = ","

  # Create a new Excel workbook with one empty sheet
  $excel = New-Object -ComObject excel.application
  $workbook = $excel.Workbooks.Add(1)
  $worksheet = $workbook.worksheets.Item(1)

  $TxtConnector = ("TEXT;" + $csv)
  $Connector = $worksheet.QueryTables.add($TxtConnector,$worksheet.Range("A1"))
  $query = $worksheet.QueryTables.item($Connector.name)
  $query.TextFileOtherDelimiter = $delimiter
  $query.TextFileParseType  = 1
  $query.TextFileColumnDataTypes = ,2 * $worksheet.Cells.Columns.Count
  $query.AdjustColumnWidth = 1

  # Execute & delete the import query
  $query.Refresh()
  $query.Delete()

  # Save & close the Workbook as XLSX.
  $Workbook.SaveAs($xlsx,51)
  $excel.Quit()

  $file = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\Scripts\FPS_STOCK.xlsx'
  $workbook = $excel.Workbooks.Open($file)
    $worksheet = $workbook.sheets.item(1)
      $range = $worksheet.UsedRange
      $rows = $range.Rows.Count - 1
      $extendrange = "A1:F$rows"
  $workbook.Save()

  $file = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\Scripts\fpsreference2.xlsx'
  $workbook = $excel.Workbooks.Open($file)
    $worksheet = $workbook.Worksheets.Item(1)
      $worksheet.Rows("2:" + $worksheet.Rows.Count).EntireRow.Delete
      $worksheet.Range($extendrange).FillDown()
      $columns = 1, 2, 3, 4, 5, 6
      $worksheet.UsedRange.Removeduplicates($columns)
    $workbook.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\Scripts\fps_stock.txt", -4158)
  $workbook.Close()

  "Combining files"
  cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\Scripts"
  gc fps_leeds.txt,fps_stock.txt | sc fpscombined.txt

  # Below is a simple Removeduplicates that changes the file
  $file = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\Scripts\fpscombined.txt'
  $workbook = $excel.Workbooks.Open($file)
    $worksheet = $workbook.Worksheets.Item(1)
      $columns = 1, 2, 3, 4, 5, 6
      $worksheet.UsedRange.Removeduplicates($columns)
    $workbook.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\fps.txt", -4158)
  $workbook.Close()

$excel.Quit()
