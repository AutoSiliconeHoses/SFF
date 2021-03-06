$excel = New-Object -ComObject Excel.Application
$excel.DisplayAlerts = $false

  $file = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed\Scripts\workshopwarehouse.xls"
  $workbook = $excel.Workbooks.Open($file)
    $worksheet = $workbook.sheets.item(1)
      $range = $worksheet.UsedRange
      $rows = $range.Rows.Count - 1
      $extendrange = "A2:F$rows"
  $workbook.Save()
  $workbook.Saved = $True
  $workbook.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed\Scripts\workshopwarehouse.xlsx", 51)

  $file = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed\Scripts\workshopwarehouse.xlsx"
  $workbook = $excel.Workbooks.Open($file)
  $workbook.Save()
  $workbook.Saved = $True

  $workbook = $excel.Workbooks.Open('\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed\Scripts\wwreference.xlsx')
    $worksheet = $workbook.Worksheets.Item(1)
    $worksheet.Rows("3:" + $worksheet.Rows.Count).EntireRow.Delete
    $worksheet.Range($extendrange).FillDown()
    $worksheet = $workbook.Worksheets.Item(1)
    $columns = 1..6
    $worksheet.UsedRange.Removeduplicates($columns)
  $workbook.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed\workshopwarehouse.txt", -4158)
  $workbook.Save()
  $workbook.Saved = $True
  $workbook.Close()

$excel.Quit()
[System.Runtime.Interopservices.Marshal]::FinalReleaseComObject($excel)
