$filedecco =  'Z:\Stock File Fetcher\StockFeed\DeccoFeed\Scripts\decco.xml'
$excldecco = New-Object -ComObject "Excel.Application"
$wrkbdecco = $excldecco.Workbooks.Open($filedecco)
$excldecco.DisplayAlerts = $FALSE

$wrkbdecco.SaveAs("Z:\Stock File Fetcher\StockFeed\DeccoFeed\Scripts\decco.csv", 6)
$wrkbdecco = $excldecco.Workbooks.Open('Z:\Stock File Fetcher\StockFeed\DeccoFeed\Scripts\decco.csv')

$wrkbdecco.Save()

Set-Variable -Name "filedecco" -Value 'Z:\Stock File Fetcher\StockFeed\DeccoFeed\Scripts\dcreference2.xlsx'
$wrkbdecco = $excldecco.Workbooks.Open($filedecco)
$wrkbdecco.Save()

Set-Variable -Name "filedecco" -Value 'Z:\Stock File Fetcher\StockFeed\DeccoFeed\Scripts\dcreference.xlsx'
$wrkbdecco = $excldecco.Workbooks.Open($filedecco)
$wrkbdecco.SaveAs("Z:\Stock File Fetcher\StockFeed\DeccoFeed\decco.txt", -4158)

$wrkbdecco.Close()
$excldecco.Quit()
