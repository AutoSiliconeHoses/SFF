$excel = new-object -ComObject Excel.Application
$excel.DisplayAlerts = $false

$stockfile = $excel.Workbooks.Open("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxFeed\Scripts\stax.csv")
$stocksheet = $stockfile.sheets.item("stax")
$stockrange = $stocksheet.UsedRange
$stockrows = $stockrange.Rows.Count - 3
$extendrange = "A2:F$stockrows"
$stockfile.Save()

$workbook = $excel.Workbooks.Open("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxFeed\Scripts\sxreference.xlsx")
$worksheet = $workbook.Worksheets.Item(1)
$worksheet.Rows("3:" + $worksheet.Rows.Count).EntireRow.Delete
$worksheet.Range($extendrange).FillDown()
$columns = 1, 2, 3, 4, 5, 6
$worksheet.UsedRange.Removeduplicates($columns)
$workbook.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxFeed\stax.txt", -4158)

$workbook.Close()
$excel.Quit()
