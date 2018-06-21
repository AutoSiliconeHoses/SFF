$file = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\homehardware.csv'
$excel = New-Object -ComObject "Excel.Application"
$workbook = $excel.Workbooks.Open($file)
$excel.DisplayAlerts = $FALSE

$workbook.Save()

$file = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\hhmacro2.xlsm'
$workbook = $excel.Workbooks.Open($file)
$excel.Run("CombineRows")
$workbook.Save()

$file = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\hhreference.xlsx'
$workbook = $excel.Workbooks.Open($file)
$worksheet = $workbook.worksheets.item(1)
$columns = 1, 2, 3, 4, 5, 6
$worksheet.UsedRange.Removeduplicates($columns)
$workbook.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\HomeHardwareFeed\homehardware.txt", -4158)
$workbook.Save()

$workbook.Close()
$excel.Quit()
