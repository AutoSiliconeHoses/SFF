$excel = new-object -ComObject Excel.Application
$excel.DisplayAlerts = $false

$file = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxPrimeFeed\Scripts\staxprime.csv"
$workbook = $excel.Workbooks.Open($file)
$worksheet = $workbook.sheets.item("staxprime")
$range = $worksheet.UsedRange
$rows = $range.Rows.Count - 3
$extendrange = "A2:F$rows"
$workbook.Save()

$file = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxPrimeFeed\Scripts\sxpreference.xlsx"
$workbook = $excel.Workbooks.Open($file)
$worksheet = $workbook.Worksheets.Item(1)
$worksheet.Rows("3:" + $worksheet.Rows.Count).ClearContents
$worksheet.Range($extendrange).FillDown()
$columns = 1, 2, 3, 4, 5, 6
$worksheet.UsedRange.Removeduplicates($columns)
$workbook.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\StaxPrimeFeed\staxprime.txt", -4158)

$workbook.Close()
$excel.Quit()
