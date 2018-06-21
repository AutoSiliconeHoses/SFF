$filetoolbankprime =  '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\Scripts\toolbankprimestock.txt'
$excltoolbankprime = New-Object -ComObject "Excel.Application"
$wrkbtoolbankprime = $excltoolbankprime.Workbooks.Open($filetoolbankprime)
$excltoolbankprime.DisplayAlerts = $FALSE

$wrkbtoolbankprime.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\Scripts\toolbankprime.csv", 6)

$filetoolbankprime = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\Scripts\toolbankprime.csv'
$wrkbtoolbankprime = $excltoolbankprime.Workbooks.Open($filetoolbankprime)
$wrkbtoolbankprime.Save()

$filetoolbankprime = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\Scripts\tbpreference2.xlsx'
$wrkbtoolbankprime = $excltoolbankprime.Workbooks.Open($filetoolbankprime)
$wrkbtoolbankprime.Save()


$filetoolbankprime = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\Scripts\tbpreference.xlsx'
$wrkbtoolbankprime = $excltoolbankprime.Workbooks.Open($filetoolbankprime)
$Range = $wrkbtoolbankprime.range("A:F")
$Range.Removeduplicates()
$wrkbtoolbankprime.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\toolbankprimeFeed\toolbankprime.txt", -4158)

$wrkbtoolbankprime.Close()
$excltoolbankprime.Quit()
