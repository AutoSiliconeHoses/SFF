$excltoolstream = New-Object -ComObject "Excel.Application"
$excltoolstream.DisplayAlerts = $FALSE

$filetoolstream = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\Scripts\Product Content And Pricing Information ENGLISH.xls'
$wrkbtoolstream = $excltoolstream.Workbooks.Open($filetoolstream)
$wrkbtoolstream.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\Product Content And Pricing Information ENGLISH.xlsx")

$filetoolstream =  '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\Scripts\tsreference.xlsx'
$wrkbtoolstream = $excltoolstream.Workbooks.Open($filetoolstream)
$worksheet = $wrkbtoolstream.Worksheets.Item(1)
$columns = 1, 2, 3, 4, 5, 6
$worksheet.UsedRange.Removeduplicates($columns)
$wrkbtoolstream.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt", -4158)

$wrkbtoolstream.Close()
$excltoolstream.Quit()
