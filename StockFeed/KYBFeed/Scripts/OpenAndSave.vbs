Set ExcelObject = CreateObject("Excel.Application")
 ExcelObject.Visible = false
 Set wb = ExcelObject.Workbooks.Open("Z:\Stock File Fetcher\StockFeed\KYBFeed\Scripts\reference.xlsx") 
 wb.Save
 wb.Close False