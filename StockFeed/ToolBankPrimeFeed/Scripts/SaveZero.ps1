$filetoolbankprime =  'Z:\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\Scripts\toolbankprimestock.txt'
$excltoolbankprime = New-Object -ComObject "Excel.Application"
$wrkbtoolbankprime = $excltoolbankprime.Workbooks.Open($filetoolbankprime)
$excltoolbankprime.DisplayAlerts = $FALSE

$wrkbtoolbankprime.SaveAs("Z:\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\Scripts\toolbankprime.csv", 6)

Set-Variable -Name "filetoolbankprime" -Value 'Z:\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\Scripts\toolbankprime.csv'
$wrkbtoolbankprime = $excltoolbankprime.Workbooks.Open($filetoolbankprime)
$wrkbtoolbankprime.Save()

Set-Variable -Name "filetoolbankprime" -Value 'Z:\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\Scripts\tbpzero.xlsx'
$wrkbtoolbankprime = $excltoolbankprime.Workbooks.Open($filetoolbankprime)
$Range = $wrkbtoolbankprime.range("A:F")
$Range.Removeduplicates()
$wrkbtoolbankprime.SaveAs("Z:\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\toolbankprime.txt", -4158)

$wrkbtoolbankprime.Close()
$excltoolbankprime.Quit()
