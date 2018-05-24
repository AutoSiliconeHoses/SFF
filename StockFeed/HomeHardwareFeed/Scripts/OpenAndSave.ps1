$filehomehardware =  'Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\homehardware.csv'
$exclhomehardware = New-Object -ComObject "Excel.Application"
$wrkbhomehardware = $exclhomehardware.Workbooks.Open($filehomehardware)
$exclhomehardware.DisplayAlerts = $FALSE

$wrkbhomehardware.Save()

Set-Variable -Name "filehomehardware" -Value 'Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\hhreference.xlsx'
$wrkbhomehardware = $exclhomehardware.Workbooks.Open($filehomehardware)
$wrkbhomehardware.Save()

Set-Variable -Name "filehomehardware" -Value 'Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\hhreference2.xlsx'
$wrkbhomehardware = $exclhomehardware.Workbooks.Open($filehomehardware)
$wrkbhomehardware.Save()

Set-Variable -Name "filehomehardware" -Value 'Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\hhmacro2.xlsm'
$wrkbhomehardware = $exclhomehardware.Workbooks.Open($filehomehardware)
$exclhomehardware.Run("CombineRows")
$wrkbhomehardware.Save()

Set-Variable -Name "filehomehardware" -Value 'Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\hhreference3.xlsx'
$wrkbhomehardware = $exclhomehardware.Workbooks.Open($filehomehardware)
$wrkbhomehardware.SaveAs("Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\homehardware.txt", -4158)

$wrkbhomehardware.Close()
$exclhomehardware.Quit()
