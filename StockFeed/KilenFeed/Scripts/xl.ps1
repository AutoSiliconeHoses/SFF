$file, $xlCellTypeLastCell = 'Z:\Stock File Fetcher\StockFeed\KilenFeed\Scripts\knreference.xlsx', 11

$xl = New-Object -ComObject Excel.Application -Property @{Visible = $true}

$wb = $xl.Workbooks.Open($file)

$sh = $wb.Sheets.Item(1)

$lstRwInt = $sh.UsedRange.SpecialCells($xlCellTypeLastCell).Address() -replace '^.+\D'

$sh.Range("A2:A$lstRwInt").Formula = $sh.Range('A2').Formula

Start-Sleep 13               # this is just for inspection, you should remove it after

$wb.Close($false)               # change this to $true to save changes to the workbook

$xl.Quit()

Remove-ComObject
