$file =  '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\Scripts\draper.csv'
$excel = New-Object -ComObject "Excel.Application"
$workbook = $excel.Workbooks.Open($file)
$excel.DisplayAlerts = $FALSE

$workbook.Save()

$file =  '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\Scripts\dpreference.xlsx'
$workbook = $excel.Workbooks.Open($file)
$worksheet = $workbook.Worksheets.Item(1)
$columns = 1, 2, 3, 4, 5, 6
$worksheet.UsedRange.Removeduplicates($columns)
$workbook.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\draper.txt", -4158)

$workbook.Close()
$excel.Quit()
