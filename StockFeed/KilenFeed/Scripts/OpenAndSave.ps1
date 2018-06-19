$filekilen =  'Z:\Stock File Fetcher\StockFeed\KilenFeed\Scripts\kilen.csv'
$exclkilen = New-Object -ComObject "Excel.Application"
$wrkbkilen = $exclkilen.Workbooks.Open($filekilen)
$exclkilen.DisplayAlerts = $FALSE

$wrkbkilen.Save()

Set-Variable -Name "filekilen" -Value 'Z:\Stock File Fetcher\StockFeed\KilenFeed\Scripts\knreference.xlsx'
$wrkbkilen = $exclkilen.Workbooks.Open($filekilen)
$Range = $wrkbkilen.range("A:F")
$Range.Removeduplicates()
$wrkbkilen.SaveAs("Z:\Stock File Fetcher\StockFeed\KilenFeed\kilen.txt", -4158)

$wrkbkilen.Close()
$exclkilen.Quit()
