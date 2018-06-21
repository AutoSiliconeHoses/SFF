$excel = new-object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false
$stockfile = $excel.Workbooks.Open("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxPrimeFeed\Scripts\staxprime.csv")
$stocksheet = $stockfile.sheets.item("staxprime")
$stockrange = $stocksheet.UsedRange
$stockrows = $stockrange.Rows.Count - 3
$extendrange = "A2:F$stockrows"
$workbook.Save()

$file = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxPrimeFeed\Scripts\sxpzero.xlsx"
$workbook = $excel.Workbooks.Open($file)
$worksheet = $workbook.Worksheets.Item(1)
$worksheet.Rows("3:" + $worksheet.Rows.Count).ClearContents
$worksheet.Range($extendrange).FillDown()
$columns = 1, 2, 3, 4, 5, 6
$worksheet.UsedRange.Removeduplicates($columns)
$workbook.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxPrimeFeed\staxprime.txt", -4158)

$workbook.Close()
$excel.Quit()
