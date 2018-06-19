$filetoolbank =  'Z:\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\toolbankstock.txt'
$excltoolbank = New-Object -ComObject "Excel.Application"
$wrkbtoolbank = $excltoolbank.Workbooks.Open($filetoolbank)
$excltoolbank.DisplayAlerts = $FALSE

$wrkbtoolbank.SaveAs("Z:\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\toolbank.csv", 6)

Set-Variable -Name "filetoolbank" -Value 'Z:\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\toolbank.csv'
$wrkbtoolbank = $excltoolbank.Workbooks.Open($filetoolbank)
$wrkbtoolbank.Save()

Set-Variable -Name "filetoolbank" -Value 'Z:\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\tbreference.xlsx'
$wrkbtoolbank = $excltoolbank.Workbooks.Open($filetoolbank)
$Range = $wrkbtoolbank.range("A:F")
$Range.Removeduplicates()
$wrkbtoolbank.SaveAs("Z:\Stock File Fetcher\StockFeed\toolbankFeed\toolbank.txt", -4158)

$wrkbtoolbank.Close()
$excltoolbank.Quit()
