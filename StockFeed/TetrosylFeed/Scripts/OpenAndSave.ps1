$filetetrosyl =  '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\tetrosyl.csv'
$excltetrosyl = New-Object -ComObject "Excel.Application"
$wrkbtetrosyl = $excltetrosyl.Workbooks.Open($filetetrosyl)
$excltetrosyl.DisplayAlerts = $FALSE

$wrkbtetrosyl.Save()

"`ttlreference.xlsx"
$filetetrosyl =  '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\tlreference.xlsx'
$wrkbtetrosyl = $excltetrosyl.Workbooks.Open($filetetrosyl)
$wrkbtetrosyl.Save()

"`ttlreference3.xlsx"
$filetetrosyl =  '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\tlreference3.xlsx'
$wrkbtetrosyl = $excltetrosyl.Workbooks.Open($filetetrosyl)
$wrkbtetrosyl.Save()

"`ttlmacro2.xlsm"
$filetetrosyl =  '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\tlmacro2.xlsm'
$wrkbtetrosyl = $excltetrosyl.Workbooks.Open($filetetrosyl)
$excltetrosyl.run("CombineRows")
$wrkbtetrosyl.Save()

"`ttlreference2.xlsx"
$filetetrosyl =  '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\tlreference2.xlsx'
$wrkbtetrosyl = $excltetrosyl.Workbooks.Open($filetetrosyl)
$worksheet = $wrkbtetrosyl.Worksheets.Item(1)
$columns = 1, 2, 3, 4, 5, 6
$worksheet.UsedRange.Removeduplicates($columns)
$wrkbtetrosyl.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\TetrosylFeed\tetrosyl.txt", -4158)

$wrkbtetrosyl.Close()
$excltetrosyl.Quit()
