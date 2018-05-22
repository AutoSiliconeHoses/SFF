$filedraper =  'Z:\Stock File Fetcher\StockFeed\DraperFeed\Scripts\stock.csv'
$excldraper = New-Object -ComObject "Excel.Application"
$wrkbdraper = $excldraper.Workbooks.Open($filedraper)
$excldraper.DisplayAlerts = $FALSE

$wrkbdraper.Save()

Set-Variable -Name "filedraper" -Value 'Z:\Stock File Fetcher\StockFeed\DraperFeed\Scripts\reference2.xlsx'
$wrkbdraper = $excldraper.Workbooks.Open($filedraper)
$wrkbdraper.Save()

Set-Variable -Name "filedraper" -Value 'Z:\Stock File Fetcher\StockFeed\DraperFeed\Scripts\reference.xlsx'
$wrkbdraper = $excldraper.Workbooks.Open($filedraper)
$wrkbdraper.SaveAs("Z:\Stock File Fetcher\StockFeed\DraperFeed\draper.txt", -4158)

$wrkbdraper.Close()
$excldraper.Quit()
