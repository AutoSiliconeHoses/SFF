$filetoolstream = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\Scripts\Product Content And Pricing Information ENGLISH.xls'
$excltoolstream = New-Object -ComObject "Excel.Application"
$wrkbtoolstream = $excltoolstream.Workbooks.Open($filetoolstream)
$excltoolstream.DisplayAlerts = $FALSE

$wrkbtoolstream.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\Product Content And Pricing Information ENGLISH.xlsx")

Set-Variable -Name "filetoolstream" -Value '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\Scripts\tsreference.xlsx'
$wrkbtoolstream = $excltoolstream.Workbooks.Open($filetoolstream)
$Range = $wrkbtoolstream.range("A:F")
$Range.Removeduplicates()
$wrkbtoolstream.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt", -4158)

$wrkbtoolstream.Close()
$excltoolstream.Quit()
