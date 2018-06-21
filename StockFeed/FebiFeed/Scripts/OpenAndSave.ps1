$filefebi =  '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FebiFeed\Scripts\febi.csv'
$exclfebi = New-Object -ComObject "Excel.Application"
$wrkbfebi = $exclfebi.Workbooks.Open($filefebi)
$exclfebi.DisplayAlerts = $FALSE

$wrkbfebi.Save()

$filefebi =  '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FebiFeed\Scripts\fireference.xlsx'
$wrkbfebi = $exclfebi.Workbooks.Open($filefebi)
$worksheet = $wrkbfebi.Worksheets.Item(1)
$columns = 1, 2, 3, 4, 5, 6
$worksheet.UsedRange.Removeduplicates($columns)
$wrkbfebi.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FebiFeed\febi.txt", -4158)

$wrkbfebi.Close()
$exclfebi.Quit()
