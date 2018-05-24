$filevaleo =  'Z:\Stock File Fetcher\StockFeed\ValeoFeed\Scripts\VALEO_stock.csv'
$exclvaleo = New-Object -ComObject "Excel.Application"
$wrkbvaleo = $exclvaleo.Workbooks.Open($filevaleo)
$exclvaleo.DisplayAlerts = $FALSE

$wrkbvaleo.Save()

Set-Variable -Name "filevaleo" -Value 'Z:\Stock File Fetcher\StockFeed\ValeoFeed\Scripts\reference2.xlsx'
$wrkbvaleo = $exclvaleo.Workbooks.Open($filevaleo)
$wrkbvaleo.Save()


Set-Variable -Name "filevaleo" -Value 'Z:\Stock File Fetcher\StockFeed\ValeoFeed\Scripts\reference.xlsx'
$wrkbvaleo = $exclvaleo.Workbooks.Open($filevaleo)
$wrkbvaleo.SaveAs("Z:\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt", -4158)

$wrkbvaleo.Close()
$exclvaleo.Quit()
