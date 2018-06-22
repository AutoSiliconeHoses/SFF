$excel = New-Object -ComObject "Excel.Application"
$excel.DisplayAlerts = $FALSE

$file =  '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\Scripts\toolbankprimestock.txt'
$workbook = $excel.Workbooks.Open($file)
$workbook.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\Scripts\toolbankprime.csv", 6)

$file = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\Scripts\toolbankprime.csv'
$workbook = $excel.Workbooks.Open($file)
$workbook.Save()

$file = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\Scripts\tbpzero.xlsx'
$workbook = $excel.Workbooks.Open($file)
$worksheet = $workbook.Worksheets.Item(1)
$columns = 1, 2, 3, 4, 5, 6
$worksheet.UsedRange.Removeduplicates($columns)
$workbook.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\toolbankprime.txt", -4158)

$workbook.Close()
$excel.Quit()
