$filestax =  'Z:\Stock File Fetcher\StockFeed\StaxFeed\Scripts\stax.csv'
$exclstax = New-Object -ComObject "Excel.Application"
$wrkbstax = $exclstax.Workbooks.Open($filestax)
$exclstax.DisplayAlerts = $FALSE

$wrkbstax.Save()

Set-Variable -Name "filestax" -Value 'Z:\Stock File Fetcher\StockFeed\StaxFeed\Scripts\sxreference.xlsx'
$wrkbstax = $exclstax.Workbooks.Open($filestax)
$wrkbstax.SaveAs("Z:\Stock File Fetcher\StockFeed\StaxFeed\stax.txt", -4158)

$wrkbstax.Close()
$exclstax.Quit()
