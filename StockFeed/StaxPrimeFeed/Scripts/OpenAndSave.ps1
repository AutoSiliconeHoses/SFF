$filestax =  'Z:\Stock File Fetcher\StockFeed\StaxPrimeFeed\Scripts\staxprime.csv'
$exclstax = New-Object -ComObject "Excel.Application"
$wrkbstax = $exclstax.Workbooks.Open($filestax)
$exclstax.DisplayAlerts = $FALSE

$wrkbstax.Save()

Set-Variable -Name "filestax" -Value 'Z:\Stock File Fetcher\StockFeed\StaxPrimeFeed\Scripts\sxpreference2.xlsx'
$wrkbstax = $exclstax.Workbooks.Open($filestax)
$wrkbstax.Save()

Set-Variable -Name "filestax" -Value 'Z:\Stock File Fetcher\StockFeed\StaxPrimeFeed\Scripts\sxpreference.xlsx'
$wrkbstax = $exclstax.Workbooks.Open($filestax)
$wrkbstax.SaveAs("Z:\Stock File Fetcher\StockFeed\StaxPrimeFeed\staxprime.txt", -4158)

$wrkbstax.Close()
$exclstax.Quit()
