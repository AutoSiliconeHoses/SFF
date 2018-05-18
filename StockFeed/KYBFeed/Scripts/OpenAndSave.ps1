$file = Dir 'Z:\Stock File Fetcher\StockFeed\KYBFeed\Scripts\' -Recurse | ? {$_.Name -eq "KYBSTOCK.csv"} | Select -ExpandProperty FullName
$excl = New-Object -ComObject "Excel.Application"
$wrkb = $excl.Workbooks.Open($file)

$excl.DisplayAlerts = $FALSE
$wrkb.Save()

$wrkb.Close()
$excl.Quit()
