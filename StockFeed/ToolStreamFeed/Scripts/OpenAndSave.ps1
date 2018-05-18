$file = Dir 'Z:\Stock File Fetcher\StockFeed\ToolStreamFeed\Scripts\' -Recurse | ? {$_.Name -eq "Product Content And Pricing Information ENGLISH.xls"} | Select -ExpandProperty FullName
$excl = New-Object -ComObject "Excel.Application"
$wrkb = $excl.Workbooks.Open($file)

$excl.DisplayAlerts = $FALSE
$wrkb.Save()

$wrkb.Close()
$excl.Quit()
