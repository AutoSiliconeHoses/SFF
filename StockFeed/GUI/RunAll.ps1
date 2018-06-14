cd '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts'
If (Test-Path -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSRunAll.txt") {del "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSRunAll.txt"}
Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSRunAll.txt" -Force -NoClobber
$computer = $osInfo = $compOSInfo = $null
$Host.UI.RawUI.WindowTitle = "StockFeed"
"Welcome to the Stock File Fetcher Script (SFF). Don't click me.`n`n`n`n`n"
Set-PSDebug -Trace 0
$argString = $args

Function String-Search($string, $target) {
	$result = Select-string -pattern $target -InputObject $string
	If ($result) {return $true}
}

Function Run-Supplier($supplier, $id) {
	$argResult = String-Search $argString $id
	if ($argResult -or $RunAll) {
	  "Loading $supplier"
		$loadString = "& '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\$supplier`Feed\$supplier.ps1'"
		Start PowerShell $loadstring -WindowStyle Hidden
	  $i++
	  Write-Progress -Activity 'Loading Scripts' -Status "Scripts Loaded: $i"
	}
}

"Pushing Drive"
net use z: "\\DISKSTATION\Feeds"
cd '\\DISKSTATION\Feeds\Stock File Fetcher\Upload'
If (Test-Path -Path *.txt) {del *.txt}

Write-Progress -Activity 'Loading Scripts' -Status "Scripts Loaded: $i"
$i = 0
$RunAll = String-Search $argString all-
.{
	Run-Supplier Decco 'dc-'
	Run-Supplier Draper 'dp-'
	Run-Supplier Febi 'fi-'
	Run-Supplier HomeHardware 'hh-'
	Run-Supplier Kilen 'kn-'
	Run-Supplier KYB 'kb-'
	Run-Supplier Stax 'sx-'
	Run-Supplier StaxPrime 'sxp-'
	Run-Supplier Tetrosyl 'tl-'
	Run-Supplier ToolBank 'tb-'
	Run-Supplier ToolBankPrime 'tbp-'
	Run-Supplier ToolStream 'ts-'
	Run-Supplier Valeo 'vo-'
	Run-Supplier WorkshopWarehouse 'ww-'

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
& '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\compile.ps1' $args[0] /C
Write-Progress -Activity 'Compiling' -Status "Compiled"

"Popping Drive"
net use z: /delete /y

"Done"
$argResult = String-Search $argstring "op-"
if ($argResult) {
	cd "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
  Start-Process excel amazon.txt -Windowstyle maximized
}

$argResult = String-Search $argstring "up-"
if ($argResult) {
	"Moving to Upload Folder"
	cd "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
  copy amazon.txt "\\STOCKMACHINE\AmazonTransport\production\outgoing"
}

Stop-Transcript
