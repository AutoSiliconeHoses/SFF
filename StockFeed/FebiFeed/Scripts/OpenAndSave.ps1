$filefebi =  '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FebiFeed\Scripts\febi.csv'
$exclfebi = New-Object -ComObject "Excel.Application"
$wrkbfebi = $exclfebi.Workbooks.Open($filefebi)
$exclfebi.DisplayAlerts = $FALSE

$wrkbfebi.Save()

Set-Variable -Name "filefebi" -Value '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FebiFeed\Scripts\fireference.xlsx'
$wrkbfebi = $exclfebi.Workbooks.Open($filefebi)
$Range = $wrkbfebi.range("A:F")
$Range.Removeduplicates()
$wrkbfebi.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FebiFeed\febi.txt", -4158)

$wrkbfebi.Close()
$exclfebi.Quit()
