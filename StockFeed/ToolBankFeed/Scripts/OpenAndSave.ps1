$excltoolbank = New-Object -ComObject "Excel.Application"
$excltoolbank.DisplayAlerts = $FALSE

$filetoolbank =  '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\toolbankstock.csv'
$wrkbtoolbank = $excltoolbank.Workbooks.Open($filetoolbank)
$wrkbtoolbank.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\toolbank.csv", 6)

$filetoolbank = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\toolbank.csv'
$wrkbtoolbank = $excltoolbank.Workbooks.Open($filetoolbank)
$wrkbtoolbank.Save()

$filetoolbank = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\tbreference.xlsx'
$wrkbtoolbank = $excltoolbank.Workbooks.Open($filetoolbank)
$worksheet = $wrkbtoolbank.Worksheets.Item(1)
$columns = 1, 2, 3, 4, 5, 6
$worksheet.UsedRange.Removeduplicates($columns)
$wrkbtoolbank.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\toolbankFeed\toolbank.txt", -4158)

$wrkbtoolbank.Close()
$excltoolbank.Quit()
