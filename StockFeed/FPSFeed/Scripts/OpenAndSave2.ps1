$excel = New-Object -ComObject "Excel.Application"
$excel.DisplayAlerts = $FALSE

  "Converting File"
  #Define input and Output
  $csv = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\Scripts\FPS_STOCK.csv"
  $xlsx = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\Scripts\FPS_STOCK.xlsx"
  $delimiter = ","

  # Create a new Excel workbook with one empty sheet
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
	$workbook.Close()

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
    $workbook.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\fps_stock.txt", -4158)
  $workbook.Close()
$excel.Quit()
