$filehomehardware =  'Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\homehardware.csv'
$exclhomehardware = New-Object -ComObject "Excel.Application"
$wrkbhomehardware = $exclhomehardware.Workbooks.Open($filehomehardware)
$exclhomehardware.DisplayAlerts = $FALSE

$wrkbhomehardware.Save()

Set-Variable -Name "filehomehardware" -Value 'Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\hhmacro2.xlsm'
$wrkbhomehardware = $exclhomehardware.Workbooks.Open($filehomehardware)
$exclhomehardware.Run("CombineRows")
$wrkbhomehardware.Save()

Set-Variable -Name "filehomehardware" -Value 'Z:\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\hhreference.xlsx'
$wrkbhomehardware = $exclhomehardware.Workbooks.Open($filehomehardware)
$Range = $wrkbhomehardware.range("A:F")
$Range.Removeduplicates()
$wrkbhomehardware.Save()

$wrkbhomehardware.Close()
$exclhomehardware.Quit()
