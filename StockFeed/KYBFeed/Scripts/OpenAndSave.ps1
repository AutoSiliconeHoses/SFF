$filekyb =  '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KYBFeed\Scripts\kyb.csv'
$exclkyb = New-Object -ComObject "Excel.Application"
$wrkbkyb = $exclkyb.Workbooks.Open($filekyb)
$exclkyb.DisplayAlerts = $FALSE

$wrkbkyb.Save()

$filekyb =  '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KYBFeed\Scripts\kbreference.xlsx'
$wrkbkyb = $exclkyb.Workbooks.Open($filekyb)
$worksheet = $wrkbkyb.Worksheets.Item(1)
$columns = 1, 2, 3, 4, 5, 6
$worksheet.UsedRange.Removeduplicates($columns)
$wrkbkyb.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\KYBFeed\kyb.txt", -4158)

$wrkbkyb.Close()
$exclkyb.Quit()
