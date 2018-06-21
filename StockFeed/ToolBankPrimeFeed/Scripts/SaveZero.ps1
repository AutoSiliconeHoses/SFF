$filetoolbankprime =  '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\Scripts\toolbankprimestock.txt'
$excltoolbankprime = New-Object -ComObject "Excel.Application"
$wrkbtoolbankprime = $excltoolbankprime.Workbooks.Open($filetoolbankprime)
$excltoolbankprime.DisplayAlerts = $FALSE

$wrkbtoolbankprime.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\Scripts\toolbankprime.csv", 6)

$filetoolbankprime = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\Scripts\toolbankprime.csv'
$wrkbtoolbankprime = $excltoolbankprime.Workbooks.Open($filetoolbankprime)
$wrkbtoolbankprime.Save()

$filetoolbankprime = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\Scripts\tbpzero.xlsx'
$wrkbtoolbankprime = $excltoolbankprime.Workbooks.Open($filetoolbankprime)
$worksheet = $wrkbtoolbankprime.Worksheets.Item(1)
$columns = 1, 2, 3, 4, 5, 6
$worksheet.UsedRange.Removeduplicates($columns)
$wrkbtoolbankprime.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\toolbankprime.txt", -4158)

$wrkbtoolbankprime.Close()
$excltoolbankprime.Quit()
