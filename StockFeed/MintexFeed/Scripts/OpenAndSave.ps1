$excel = New-Object -ComObject "Excel.Application"
$excel.DisplayAlerts = $FALSE

  $file = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\MintexFeed\Scripts\mintex.csv"
  $workbook = $excel.Workbooks.Open($file)
    $worksheet = $workbook.Sheets.Item(1)
      $range = $worksheet.UsedRange
      $rows = $range.Rows.Count -1
      $extendrange = "A2:F$rows"
  $workbook.Save()
  $workbook.Saved = $True

  $file = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\MintexFeed\Scripts\mxreference.xlsx"
  $workbook = $excel.Workbooks.Open($file)
    $worksheet = $workbook.Worksheets.Item(1)
    $worksheet.Rows("3:" + $worksheet.Rows.Count).EntireRow.Delete
    $worksheet.Range($extendrange).FillDown()
      $columns = 1, 2, 3, 4, 5, 6
    $worksheet.UsedRange.Removeduplicates($columns)
  $workbook.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\MintexFeed\mintex.txt", -4158)
  $workbook.Save()
  $workbook.Saved = $True
  $workbook.Close()
  
$excel.Quit()
[System.Runtime.Interopservices.Marshal]::FinalReleaseComObject($excel)
