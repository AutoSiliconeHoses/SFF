Set ExcelObject = CreateObject("Excel.Application")
 ExcelObject.Visible = false
 Set wb = ExcelObject.Workbooks.Open("Z:\Stock File Fetcher\StockFeed\DeccoFeed\Scripts\stock.xml")
 wb.Save
 wb.Close False