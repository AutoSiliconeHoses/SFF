$filetetrosyl =  'Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\tetrosyl.csv'
$excltetrosyl = New-Object -ComObject "Excel.Application"
$wrkbtetrosyl = $excltetrosyl.Workbooks.Open($filetetrosyl)
$excltetrosyl.DisplayAlerts = $FALSE

$wrkbtetrosyl.Save()

"`ttlreference.xlsx"
Set-Variable -Name "filetetrosyl" -Value 'Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\tlreference.xlsx'
$wrkbtetrosyl = $excltetrosyl.Workbooks.Open($filetetrosyl)
$wrkbtetrosyl.Save()

"`ttlreference3.xlsx"
Set-Variable -Name "filetetrosyl" -Value 'Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\tlreference3.xlsx'
$wrkbtetrosyl = $excltetrosyl.Workbooks.Open($filetetrosyl)
$wrkbtetrosyl.Save()

"`ttlmacro2.xlsm"
Set-Variable -Name "filetetrosyl" -Value 'Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\tlmacro2.xlsm'
$wrkbtetrosyl = $excltetrosyl.Workbooks.Open($filetetrosyl)
$excltetrosyl.run("CombineRows")
$wrkbtetrosyl.Save()

"`ttlreference2.xlsx"
Set-Variable -Name "filetetrosyl" -Value 'Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\tlreference2.xlsx'
$wrkbtetrosyl = $excltetrosyl.Workbooks.Open($filetetrosyl)
$Range = $wrkbtetrosyl.range("A:F")
$Range.Removeduplicates()
$wrkbtetrosyl.SaveAs("Z:\Stock File Fetcher\StockFeed\TetrosylFeed\tetrosyl.txt", -4158)

$wrkbtetrosyl.Close()
$excltetrosyl.Quit()
