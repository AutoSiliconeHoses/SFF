$excel = new-object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false
$stockfile = $excel.Workbooks.Open("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed\Scripts\workshopwarehouse.xls")
$stocksheet = $stockfile.sheets.item(1)
$stockrange = $stocksheet.UsedRange
$stockrows = $stockrange.Rows.Count - 1
$extendrange = "A2:F$stockrows"
$stockfile.Save()
$stockfile.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed\Scripts\workshopwarehouse.xlsx", 51)

$fileworkshopwarehouse =  '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed\Scripts\workshopwarehouse.xlsx'
$wrkbworkshopwarehouse = $excel.Workbooks.Open($fileworkshopwarehouse)
$wrkbworkshopwarehouse.Save()

$workbook = $excel.Workbooks.Open('\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed\Scripts\wwreference.xlsx')
$worksheet = $workbook.Worksheets.Item(1)
$worksheet.Rows("3:" + $worksheet.Rows.Count).EntireRow.Delete
$worksheet.Range($extendrange).FillDown()
$worksheet = $workbook.Worksheets.Item(1)
$columns = 1, 2, 3, 4, 5, 6
$worksheet.UsedRange.Removeduplicates($columns)
$workbook.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\WorkshopWarehouseFeed\workshopwarehouse.txt", -4158)

$workbook.Close()
$excel.Quit()
