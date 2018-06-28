$excel = new-object -ComObject Excel.Application
$excel.DisplayAlerts = $false

$file = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxFeed\Scripts\stax.csv"
$workbook = $excel.Workbooks.Open($file)
$worksheet = $workbook.sheets.item(1)
$range = $worksheet.UsedRange
$rows = $range.Rows.Count - 3
$extendrange = "A2:F$rows"
$Workbook.Save()

$file = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxFeed\Scripts\sxreference.xlsx"
$workbook = $excel.Workbooks.Open($file)
$worksheet = $workbook.Worksheets.Item(1)
$worksheet.Rows("3:" + $worksheet.Rows.Count).EntireRow.Delete
$worksheet.Range($extendrange).FillDown()
$columns = 1, 2, 3, 4, 5, 6
$worksheet.UsedRange.Removeduplicates($columns)
$workbook.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxFeed\stax.txt", -4158)
$workbook.Close()
$excel.Quit()
