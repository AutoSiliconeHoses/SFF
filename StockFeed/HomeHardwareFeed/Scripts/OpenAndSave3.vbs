Set ExcelObject = CreateObject("Excel.Application")
 ExcelObject.Visible = false
 ExcelObject.DisplayAlerts = False
 Set wb = ExcelObject.Workbooks.Open("Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\macro.xlsm") 
 wb.Save
 wb.Close False