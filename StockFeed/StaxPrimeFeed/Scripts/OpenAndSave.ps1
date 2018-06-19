$filestaxprime =  'Z:\Stock File Fetcher\StockFeed\StaxPrimeFeed\Scripts\staxprime.csv'
$exclstaxprime = New-Object -ComObject "Excel.Application"
$wrkbstaxprime= $exclstaxprime.Workbooks.Open($filestaxprime)
$exclstaxprime.DisplayAlerts = $FALSE

$wrkbstaxprime.Save()

Set-Variable -Name "filestaxprime" -Value 'Z:\Stock File Fetcher\StockFeed\StaxPrimeFeed\Scripts\sxpreference.xlsx'
$wrkbstaxprime= $exclstaxprime.Workbooks.Open($filestaxprime)
$Range = $wrkbstaxprime.range("A:F")
$Range.Removeduplicates()
$wrkbstaxprime.SaveAs("Z:\Stock File Fetcher\StockFeed\StaxPrimeFeed\staxprime.txt", -4158)

$wrkbstaxprime.Close()
$exclstaxprime.Quit()
