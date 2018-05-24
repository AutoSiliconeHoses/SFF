$filetoolstream = 'Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\Scripts\Product Content And Pricing Information ENGLISH.xls'
$excltoolstream = New-Object -ComObject "Excel.Application"
$wrkbtoolstream = $excltoolstream.Workbooks.Open($filetoolstream)
$excltoolstream.DisplayAlerts = $FALSE

$wrkbtoolstream.SaveAs("Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\Product Content And Pricing Information ENGLISH.xlsx")

Set-Variable -Name "filetoolstream" -Value 'Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\Scripts\reference.xlsx'
$wrkbtoolstream = $excltoolstream.Workbooks.Open($filetoolstream)
$wrkbtoolstream.SaveAs("Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt", -4158)

$wrkbtoolstream.Close()
$excltoolstream.Quit()
