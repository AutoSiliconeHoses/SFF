$excel = New-Object -ComObject Excel.Application
$excel.DisplayAlerts = $false

  $file =  "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\Scripts\draper.csv"
  $workbook = $excel.Workbooks.Open($file)
    $worksheet = $workbook.sheets.item(1)
      $range = $worksheet.UsedRange
      $rows = $range.Rows.Count - 1
      $extendrange = "A2:F$rows"
  $workbook.Save()
  $workbook.Saved = $True

  $file =  "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\Scripts\dpreference.xlsx"
  $workbook = $excel.Workbooks.Open($file)
    $worksheet = $workbook.Worksheets.Item(1)
    $worksheet.Rows("3:" + $worksheet.Rows.Count).EntireRow.Delete
    $worksheet.Range($extendrange).FillDown()
      $columns = 1, 2, 3, 4, 5, 6
    $worksheet.UsedRange.Removeduplicates($columns)
  $workbook.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\draper.txt", -4158)
  $workbook.Save()
  $workbook.Saved = $True
  $workbook.Close()

$excel.Quit()
[System.Runtime.Interopservices.Marshal]::FinalReleaseComObject($excel)
