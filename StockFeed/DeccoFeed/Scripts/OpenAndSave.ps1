$filedecco =  'Z:\Stock File Fetcher\StockFeed\DeccoFeed\Scripts\stock.xml'
$excldecco = New-Object -ComObject "Excel.Application"
$wrkbdecco = $excldecco.Workbooks.Open($filedecco)
$excldecco.DisplayAlerts = $FALSE

$wrkbdecco.Save()

Set-Variable -Name "filedecco" -Value 'Z:\Stock File Fetcher\StockFeed\DeccoFeed\Scripts\reference2.xlsx'
$wrkbdecco = $excldecco.Workbooks.Open($filedecco)
$wrkbdecco.Save()

Set-Variable -Name "filedecco" -Value 'Z:\Stock File Fetcher\StockFeed\DeccoFeed\Scripts\reference.xlsx'
$wrkbdecco = $excldecco.Workbooks.Open($filedecco)
$wrkbdecco.SaveAs("Z:\Stock File Fetcher\StockFeed\DeccoFeed\decco.txt", -4158)

$wrkbdecco.Close()
$excldecco.Quit()
