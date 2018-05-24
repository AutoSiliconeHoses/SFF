$filetetrosyl =  'Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\combine.csv'
$excltetrosyl = New-Object -ComObject "Excel.Application"
$wrkbtetrosyl = $excltetrosyl.Workbooks.Open($filetetrosyl)
$excltetrosyl.DisplayAlerts = $FALSE

$wrkbtetrosyl.Save()

Set-Variable -Name "filetetrosyl" -Value 'Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\reference2.xlsx'
$wrkbtetrosyl = $excltetrosyl.Workbooks.Open($filetetrosyl)
$wrkbtetrosyl.Save()

Set-Variable -Name "filetetrosyl" -Value 'Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\reference3.xlsx'
$wrkbtetrosyl = $excltetrosyl.Workbooks.Open($filetetrosyl)
$wrkbtetrosyl.Save()

Set-Variable -Name "filetetrosyl" -Value 'Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\macro2.xlsm'
$wrkbtetrosyl = $excltetrosyl.Workbooks.Open($filetetrosyl)
$excltetrosyl.Run("CombineRows")
$wrkbtetrosyl.Save()

Set-Variable -Name "filetetrosyl" -Value 'Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\reference.xlsx'
$wrkbtetrosyl = $excltetrosyl.Workbooks.Open($filetetrosyl)
$wrkbtetrosyl.SaveAs("Z:\Stock File Fetcher\StockFeed\TetrosylFeed\tetrosyl.txt", -4158)

$wrkbtetrosyl.Close()
$excltetrosyl.Quit()
