$filekyb =  'Z:\Stock File Fetcher\StockFeed\KYBFeed\Scripts\KYBSTOCK.CSV'
$exclkyb = New-Object -ComObject "Excel.Application"
$wrkbkyb = $exclkyb.Workbooks.Open($filekyb)
$exclkyb.DisplayAlerts = $FALSE

$wrkbkyb.Save()

Set-Variable -Name "filekyb" -Value 'Z:\Stock File Fetcher\StockFeed\KYBFeed\Scripts\kbreference.xlsx'
$wrkbkyb = $exclkyb.Workbooks.Open($filekyb)
$wrkbkyb.SaveAs("Z:\Stock File Fetcher\StockFeed\KYBFeed\kyb.txt", -4158)

$wrkbkyb.Close()
$exclkyb.Quit()
