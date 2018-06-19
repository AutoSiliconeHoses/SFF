$fileworkshopwarehouse =  'Z:\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed\Scripts\workshopwarehouse.xls'
$exclworkshopwarehouse = New-Object -ComObject "Excel.Application"
$wrkbworkshopwarehouse = $exclworkshopwarehouse.Workbooks.Open($fileworkshopwarehouse)
$exclworkshopwarehouse.DisplayAlerts = $FALSE

$wrkbworkshopwarehouse.SaveAs("Z:\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed\Scripts\workshopwarehouse.xlsx", 51)

Set-Variable -Name "fileworkshopwarehouse" -Value 'Z:\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed\Scripts\workshopwarehouse.xlsx'
$wrkbworkshopwarehouse = $exclworkshopwarehouse.Workbooks.Open($fileworkshopwarehouse)
$wrkbworkshopwarehouse.Save()

Set-Variable -Name "fileworkshopwarehouse" -Value 'Z:\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed\Scripts\wwreference.xlsx'
$wrkbworkshopwarehouse = $exclworkshopwarehouse.Workbooks.Open($fileworkshopwarehouse)
$Range = $wrkbworkshopwarehouse.range("A:F")
$Range.Removeduplicates()
$wrkbworkshopwarehouse.SaveAs("Z:\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed\workshopwarehouse.txt", -4158)

$wrkbworkshopwarehouse.Close()
$exclworkshopwarehouse.Quit()
