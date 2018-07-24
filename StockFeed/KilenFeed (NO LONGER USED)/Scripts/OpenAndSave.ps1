$exclkilen = New-Object -ComObject "Excel.Application"
$exclkilen.DisplayAlerts = $FALSE

$filekilen = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KilenFeed\Scripts\kilen.csv'
$wrkbkilen = $exclkilen.Workbooks.Open($filekilen)
$wrkbkilen.Save()

$filekilen = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KilenFeed\Scripts\knreference.xlsx'
$wrkbkilen = $exclkilen.Workbooks.Open($filekilen)
$worksheet = $wrkbkilen.Worksheets.Item(1)
$columns = 1..6
$worksheet.UsedRange.Removeduplicates($columns)
$wrkbkilen.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KilenFeed\kilen.txt", -4158)

$wrkbkilen.Close()
$exclkilen.Quit()
