$filestaxprime =  'Z:\Stock File Fetcher\StockFeed\StaxPrimeFeed\Scripts\staxprime.csv'
$exclstaxprime = New-Object -ComObject "Excel.Application"
$wrkbstaxprime= $exclstaxprime.Workbooks.Open($filestaxprime)
$exclstaxprime.DisplayAlerts = $FALSE

$wrkbstaxprime.Save()

Set-Variable -Name "filestaxprime" -Value 'Z:\Stock File Fetcher\StockFeed\StaxPrimeFeed\Scripts\sxpzero.xlsx'
$wrkbstaxprime= $exclstaxprime.Workbooks.Open($filestaxprime)
$wrkbstaxprime.SaveAs("Z:\Stock File Fetcher\StockFeed\StaxPrimeFeed\staxprime.txt", -4158)

$wrkbstaxprime.Close()
$exclstaxprime.Quit()
