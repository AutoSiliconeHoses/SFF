Set ExcelObject = CreateObject("Excel.Application")
 ExcelObject.Visible = false
 Set wb = ExcelObject.Workbooks.Open("Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\reference3.xlsx")
 wb.SaveAs "Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\homehardware.txt", -4158
 wb.Close False