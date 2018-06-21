$excel = New-Object -ComObject "Excel.Application"
$file = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoFeed\Scripts\decco.xml"
$workbook = $excel.Workbooks.Open($file)
$excel.DisplayAlerts = $FALSE
$excel.Visible = $false

$workbook.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoFeed\Scripts\decco.csv", 6)
$stockfile = $excel.Workbooks.Open("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoFeed\Scripts\decco.csv")
$stocksheet = $stockfile.sheets.item("decco")
$stockrange = $stocksheet.UsedRange
$stockrows = $stockrange.Rows.Count - 7
$extendrange = "A1:B$stockrows"

"`tdcmacro.xlsm"
$file = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoFeed\Scripts\dcmacro.xlsm'
$workbook = $excel.Workbooks.Open($file)
$worksheet = $workbook.Worksheets.Item(1)
$worksheet.Rows("2:" + $worksheet.Rows.Count).EntireRow.Delete
$workbook.Save()

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoFeed\Scripts"
copy dcmacro.xlsm dcmacro2.xlsm

"`tdcmacro2.xlsm"
$file = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoFeed\Scripts\dcmacro2.xlsm'
$workbook = $excel.Workbooks.Open($file)
$worksheet = $workbook.Worksheets.Item(1)
$sheetrange = $worksheet.UsedRange
$sheetrows = $sheetrange.Rows.Count
$excel.run("CombineRows")
$workbook.Save()

"`tdcreference.xlsx"
$extendrange = "A2:F$sheetrows"
$file = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoFeed\Scripts\dcreference.xlsx'
$workbook = $excel.Workbooks.Open($file)
$worksheet = $workbook.worksheets.item(1)
$worksheet.Rows("3:" + $worksheet.Rows.Count).EntireRow.Delete
$worksheet.Range($extendrange).FillDown()
$columns = 1, 2, 3, 4, 5, 6
$worksheet.UsedRange.Removeduplicates($columns)
$workbook.SaveAs("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DeccoFeed\decco.txt", -4158)
$workbook.Save()
$workbook.Close()
$excel.Quit()
