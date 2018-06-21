cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed"
$excel = New-Object -ComObject "Excel.Application"
$excel.DisplayAlerts = $FALSE

#FPS_LEEDS.xlsx to fps_leeds.txt
$stockfile = $excel.Workbooks.Open("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\Scripts\FPS_LEEDS.xlsx")
$stocksheet = $stockfile.sheets.item(1)
$stockrange = $stocksheet.UsedRange
$stockrows = $stockrange.Rows.Count - 1
$extendrange = "A2:F$stockrows"
$workbook.Save()

$file = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\Scripts\fpsreference.xlsx'
$workbook = $excel.Workbooks.Open($file)
$worksheet = $workbook.Worksheets.Item(1)
$worksheet.Rows("3:" + $worksheet.Rows.Count).EntireRow.Delete
$worksheet.Range($extendrange).FillDown()
$columns = 1, 2, 3, 4, 5, 6
$worksheet.UsedRange.Removeduplicates($columns)
$workbook.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\fps_leeds.txt", -4158)
$workbook.Close()

#FPS_LEEDS.xlsx to fps_stock.txt
$file = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\Scripts\FPS_STOCK.csv'
$workbook = $excel.Workbooks.Open($file)
$workbook.Save()

$file = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\Scripts\fpsreference2.xlsx'
$workbook = $excel.Workbooks.Open($file)
$worksheet = $workbook.Worksheets.Item(1)
$worksheet.Rows("3:" + $worksheet.Rows.Count).EntireRow.Delete
$worksheet.Range($extendrange).FillDown()
$columns = 1, 2, 3, 4, 5, 6
$worksheet.UsedRange.Removeduplicates($columns)
$workbook.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\fps_stock.txt", -4158)
$workbook.Close()

$excel.Quit()
