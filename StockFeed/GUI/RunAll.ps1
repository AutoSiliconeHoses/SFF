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
net use z: "\\DISKSTATION\Feeds"

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

"Compiling Output Files"
Write-Progress -Activity 'Compiling' -Status "Compiling..."
& '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\compile.ps1' /C
Write-Progress -Activity 'Compiling' -Status "Compiled"

"Popping Drive"
net use z: /delete /y

$argResult = String-Search $argstring "op"
if ($argResult) {
	cd "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
  Start-Process excel amazon.txt -Windowstyle maximized
}

$wshell = New-Object -ComObject Wscript.Shell
$wshell.Popup("Operation Completed",0,"Done",0x0)
