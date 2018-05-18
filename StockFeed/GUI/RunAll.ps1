$computer = $osInfo = $compOSInfo = $null
$Host.UI.RawUI.WindowTitle = "StockFeed"
Set-PSDebug -Trace 0
"Pushing Drive"
Write-Progress -Activity 'Pushing Drive' -Status "Pushing..."
& '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\push.bat' -WindowStyle Hidden /C
Write-Progress -Activity 'Pushing Drive' -Status "Pushed"

"Scrapping Old Files"
Write-Progress -Activity 'Scrapping Files' -Status "Scrapping..."
& '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\scrap.bat' -WindowStyle Hidden /C
Write-Progress -Activity 'Scrapping Files' -Status "Scrapped"

Write-Progress -Activity 'Loading Scripts' -Status "Scripts Loaded: $i"
$i = 0
"Loading ToolBank"
& '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Shortcuts\Suppliers\toolbank.lnk'
$i++
Write-Progress -Activity 'Loading Scripts' -Status "Scripts Loaded: $i"

"Loading ToolStream"
& '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Shortcuts\Suppliers\toolstream.lnk'
$i++
Write-Progress -Activity 'Loading Scripts' -Status "Scripts Loaded: $i"

"Loading Valeo"
& '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Shortcuts\Suppliers\valeo.lnk'
$i++
Write-Progress -Activity 'Loading Scripts' -Status "Scripts Loaded: $i"

"Loading Tetrosyl"
& '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Shortcuts\Suppliers\tetrosyl.lnk'
$i++
Write-Progress -Activity 'Loading Scripts' -Status "Scripts Loaded: $i"

"Loading Stax"
& '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Shortcuts\Suppliers\stax.lnk'
$i++
Write-Progress -Activity 'Loading Scripts' -Status "Scripts Loaded: $i"

"Loading KYB"
& '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Shortcuts\Suppliers\kyb.lnk'
$i++
Write-Progress -Activity 'Loading Scripts' -Status "Scripts Loaded: $i"

"Loading HomeHardware"
& '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Shortcuts\Suppliers\homehardware.lnk'
$i++
Write-Progress -Activity 'Loading Scripts' -Status "Scripts Loaded: $i"

"Loading Draper"
& '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Shortcuts\Suppliers\draper.lnk'
$i++
Write-Progress -Activity 'Loading Scripts' -Status "Scripts Loaded: $i"

"Loading Decco"
& '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Shortcuts\Suppliers\decco.lnk'
$i++
Write-Progress -Activity 'Loading Scripts' -Status "Scripts Loaded: $i"

"Loading Kilen"
& '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Shortcuts\Suppliers\kilen.lnk'
$i++
Write-Progress -Activity 'Loading Scripts' -Status "Scripts Loaded: $i"

Write-Progress -Activity 'Loading Scripts' -Status "Loaded"

"Waiting for Scripts to finish"
while (@(Get-Process | where-object {$_.ProcessName -like 'powershell'}).count -ne 1) {
  Write-Progress -Activity 'Running Scripts' -Status "Number of Scripts running: $i"
  sleep 1
  If ((@(Get-Process | where-object {$_.ProcessName -like 'powershell'}).count - 1) -ne $i){
    $i = @(Get-Process | where-object {$_.ProcessName -like 'powershell'}).count -1
  }
}

"Scrapping Old Files"
Write-Progress -Activity 'Scrapping Files' -Status "Scrapping..."
& '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\scrap.ps1' /C
Write-Progress -Activity 'Scrapping Files' -Status "Scrapped"

"Compiling Output Files"
Write-Progress -Activity 'Compiling' -Status "Compiling..."
& '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\compile.ps1' /C
Write-Progress -Activity 'Compiling' -Status "Compiled"

"Popping Drive"
Write-Progress -Activity 'Popping Drive' -Status "Popping..."
& '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Shortcuts\Drives\pop.lnk' /C
Write-Progress -Activity 'Popping Drive' -Status "Popped"

$userInput = Read-host -Prompt 'Would you like to open the Output Folder & Upload Page? [Y - Upload folder]/[A - Open All]/[N - Open Neither]'
switch  ($userInput) {
  'Y' {
    ii '\\DISKSTATION\Feeds\Stock File Fetcher\Upload'
  }
  'A' {
    ii '\\DISKSTATION\Feeds\Stock File Fetcher\Upload'
    start 'https://sellercentral.amazon.co.uk/listing/upload?ref=xx_download_apvu_xx'
  }
  'N' {
    "End of Script"
  }
  default {
    "No need to be rude."
  }
}
