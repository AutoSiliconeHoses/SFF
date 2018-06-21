$filevaleo =  '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ValeoFeed\Scripts\VALEO_stock.csv'
$exclvaleo = New-Object -ComObject "Excel.Application"
$wrkbvaleo = $exclvaleo.Workbooks.Open($filevaleo)
$exclvaleo.DisplayAlerts = $FALSE

$wrkbvaleo.Save()

$filevaleo =  '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ValeoFeed\Scripts\voreference2.xlsx'
$wrkbvaleo = $exclvaleo.Workbooks.Open($filevaleo)
$wrkbvaleo.Save()


$filevaleo =  '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ValeoFeed\Scripts\voreference.xlsx'
$wrkbvaleo = $exclvaleo.Workbooks.Open($filevaleo)
$worksheet = $wrkbvaleo.Worksheets.Item(1)
$columns = 1, 2, 3, 4, 5, 6
$worksheet.UsedRange.Removeduplicates($columns)
$wrkbvaleo.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ValeoFeed\valeo.txt", -4158)

$wrkbvaleo.Close()
$exclvaleo.Quit()
