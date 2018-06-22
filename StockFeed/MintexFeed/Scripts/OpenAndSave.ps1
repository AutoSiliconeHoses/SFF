$excel = New-Object -ComObject "Excel.Application"
$excel.DisplayAlerts = $FALSE
$excel.Visible = $false

$file = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\MintexFeed\Scripts\mintex.csv"
$stockfile = $excel.Workbooks.Open($file)
$stocksheet = $stockfile.sheets.item("mintex")
$stockrange = $stocksheet.UsedRange
$stockrows = $stockrange.Rows.Count
$extendrange = "A2:F$stockrows"
$stockfile.save()

$file =  '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\MintexFeed\Scripts\mxreference.xlsx'
$workbook = $excel.Workbooks.Open($file)
$worksheet = $workbook.Worksheets.Item(1)
$worksheet.Rows("3:" + $worksheet.Rows.Count).EntireRow.Delete
$worksheet.Range($extendrange).FillDown()
$columns = 1, 2, 3, 4, 5, 6
$worksheet.UsedRange.Removeduplicates($columns)
$workbook.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\MintexFeed\mintex.txt", -4158)

$workbook.close()
$stockfile.close()
$excel.quit()
