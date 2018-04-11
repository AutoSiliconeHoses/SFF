Set ExcelObject = CreateObject("Excel.Application")
 ExcelObject.Visible = false
 Set wb = ExcelObject.Workbooks.Open("Z:\Stock File Fetcher\StockFeed\ValeoFeed\Scripts\reference2.xlsx") 
 wb.Save
 wb.Close False