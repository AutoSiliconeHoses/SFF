Set ExcelObject = CreateObject("Excel.Application")
ExcelObject.DisplayAlerts = False
ExcelObject.Visible = false
Set wb = ExcelObject.Workbooks.Open("Z:\Stock File Fetcher\StockFeed\TetrosylFeed\Scripts\macro2.xlsm")
ExcelObject.Application.Run "macro2.xlsm!CombineRows"
wb.Close True
