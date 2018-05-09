$file = Dir 'Z:\Stock File Fetcher\StockFeed\ValeoFeed\Scripts\' -Recurse | ? {$_.Name -eq "reference2.xlsx"} | Select -ExpandProperty FullName
$excl = New-Object -ComObject "Excel.Application"
$wrkb = $excl.Workbooks.Open($file)

$excl.DisplayAlerts = $FALSE
$wrkb.Save()

$wrkb.Close()
$excl.Quit()