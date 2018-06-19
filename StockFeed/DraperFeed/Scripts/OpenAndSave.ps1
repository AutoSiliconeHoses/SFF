$filedraper =  '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\Scripts\draper.csv'
$excldraper = New-Object -ComObject "Excel.Application"
$wrkbdraper = $excldraper.Workbooks.Open($filedraper)
$excldraper.DisplayAlerts = $FALSE

$wrkbdraper.Save()

Set-Variable -Name "filedraper" -Value '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\Scripts\dpreference.xlsx'
$wrkbdraper = $excldraper.Workbooks.Open($filedraper)
$Range = $wrkbdraper.range("A:F")
$Range.Removeduplicates()
$wrkbdraper.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\draper.txt", -4158)

$wrkbdraper.Close()
$excldraper.Quit()
