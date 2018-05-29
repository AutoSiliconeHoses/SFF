$filetoolbank =  'Z:\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\toolbank.csv'
$excltoolbank = New-Object -ComObject "Excel.Application"
$wrkbtoolbank = $excltoolbank.Workbooks.Open($filetoolbank)
$excltoolbank.DisplayAlerts = $FALSE

$wrkbtoolbank.Save()

Set-Variable -Name "filetoolbank" -Value 'Z:\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\tbreference2.xlsx'
$wrkbtoolbank = $excltoolbank.Workbooks.Open($filetoolbank)
$wrkbtoolbank.Save()


Set-Variable -Name "filetoolbank" -Value 'Z:\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\tbreference.xlsx'
$wrkbtoolbank = $excltoolbank.Workbooks.Open($filetoolbank)
$wrkbtoolbank.SaveAs("Z:\Stock File Fetcher\StockFeed\ToolBankFeed\toolbank.txt", -4158)

$wrkbtoolbank.Close()
$excltoolbank.Quit()
