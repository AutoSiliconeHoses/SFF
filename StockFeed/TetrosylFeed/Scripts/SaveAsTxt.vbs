Set ExcelObject = CreateObject("Excel.Application")
 ExcelObject.Visible = false
 Set wb = ExcelObject.Workbooks.Open("Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\reference2.xlsx")
 wb.SaveAs "Z:\Stock File Fetcher\StockFeed\TetrosylFeed\upload.txt", -4158
 wb.Close False
