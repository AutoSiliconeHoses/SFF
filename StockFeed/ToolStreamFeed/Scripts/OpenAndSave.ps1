$excel = New-Object -ComObject "Excel.Application"
$excel.DisplayAlerts = $FALSE

$file = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\Scripts\toolstream.xlsx'
$workbook = $excel.Workbooks.Open($file)
$stockfile.Save()

$file =  '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\Scripts\tsreference.xlsx'
$workbook = $excel.Workbooks.Open($file)
$worksheet = $workbook.Worksheets.Item(1)
$columns = 1, 2, 3, 4, 5, 6
$worksheet.UsedRange.Removeduplicates($columns)
$workbook.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt", -4158)

$workbook.Close()
$stockfile.Close()
$excel.Quit()
