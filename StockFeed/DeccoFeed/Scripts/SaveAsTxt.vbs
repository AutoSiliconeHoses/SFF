Set ExcelObject = CreateObject("Excel.Application")
 ExcelObject.Visible = false
 Set wb = ExcelObject.Workbooks.Open("Z:\Stock File Fetcher\StockFeed\DeccoFeed\Scripts\reference.xlsx")
 wb.SaveAs "Z:\Stock File Fetcher\StockFeed\DeccoFeed\decco.txt", -4158
 wb.Close False
