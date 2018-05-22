$computer = $osInfo = $compOSInfo = $null
$Host.UI.RawUI.WindowTitle = "StockFeed"
Set-PSDebug -Trace 0

$argCount = $args.length
$argString = $args

Write-Host "Num Args:" $argsCount;

Function String-Search($string, $target) {
	$result = Select-string -pattern $target -InputObject $string
	If ($result) {return $true}
}

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

$argResult = String-Search $argstring "tb"
if ($argResult) {
  "Loading ToolBank"
  & '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Shortcuts\Suppliers\toolbank.lnk'
  $i++
  Write-Progress -Activity 'Loading Scripts' -Status "Scripts Loaded: $i"
}

$argResult = String-Search $argstring "ts"
if ($argResult) {
  "Loading ToolStream"
  & '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Shortcuts\Suppliers\toolstream.lnk'
  $i++
  Write-Progress -Activity 'Loading Scripts' -Status "Scripts Loaded: $i"
}

$argResult = String-Search $argstring "vo"
if ($argResult) {
  "Loading Valeo"
  & '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Shortcuts\Suppliers\valeo.lnk'
  $i++
  Write-Progress -Activity 'Loading Scripts' -Status "Scripts Loaded: $i"
}

$argResult = String-Search $argstring "tl"
if ($argResult) {
  "Loading Tetrosyl"
  & '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Shortcuts\Suppliers\tetrosyl.lnk'
  $i++
  Write-Progress -Activity 'Loading Scripts' -Status "Scripts Loaded: $i"
}

$argResult = String-Search $argstring "sx"
if ($argResult) {
  "Loading Stax"
  & '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Shortcuts\Suppliers\stax.lnk'
  $i++
  Write-Progress -Activity 'Loading Scripts' -Status "Scripts Loaded: $i"
}

$argResult = String-Search $argstring "kb"
if ($argResult) {
  "Loading KYB"
  & '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Shortcuts\Suppliers\kyb.lnk'
  $i++
  Write-Progress -Activity 'Loading Scripts' -Status "Scripts Loaded: $i"
}

$argResult = String-Search $argstring "hh"
if ($argResult) {
  "Loading HomeHardware"
  & '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Shortcuts\Suppliers\homehardware.lnk'
  $i++
  Write-Progress -Activity 'Loading Scripts' -Status "Scripts Loaded: $i"
}

$argResult = String-Search $argstring "dp"
if ($argResult) {
  "Loading Draper"
  & '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Shortcuts\Suppliers\draper.lnk'
  $i++
  Write-Progress -Activity 'Loading Scripts' -Status "Scripts Loaded: $i"
}

$argResult = String-Search $argstring "dc"
if ($argResult) {
  "Loading Decco"
  & '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Shortcuts\Suppliers\decco.lnk'
  $i++
  Write-Progress -Activity 'Loading Scripts' -Status "Scripts Loaded: $i"
}

$argResult = String-Search $argstring "kn"
if ($argResult) {
  "Loading Kilen"
  & '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Shortcuts\Suppliers\kilen.lnk'
  $i++
  Write-Progress -Activity 'Loading Scripts' -Status "Scripts Loaded: $i"
}

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


$argResult = String-Search $argstring "on"
if ($argResult) {
  ii "\\DISKSTATION\Feeds\Stock File Fetcher\Upload\amazon.txt"
}
