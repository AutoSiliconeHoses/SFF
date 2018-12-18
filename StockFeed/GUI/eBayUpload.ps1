#Load Files into RAM
$FileA = Import-CSV "C:\Users\sales-20\Desktop\PS Lookup\HH-FULLSTOCK.csv"
$FileB = Import-CSV "C:\Users\sales-20\Desktop\PS Lookup\homehardware.txt" -delimiter "`t"

#Setup Output file location
$FileName = "C:\Users\sales-20\Desktop\PS Lookup\FileC.txt"
If (Test-Path $FileName) {del $FileName}

# TODO: Merge join each supplier with upload file


# TODO: Upload each file to eBay File Exchange
