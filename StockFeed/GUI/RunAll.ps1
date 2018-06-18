$Host.UI.RawUI.WindowTitle = "StockFeed"

$process = get-process -Name 'powershell' | where {$_.mainWindowTitle -ne "StockFeed"}
If($process) {
	"PowerShell Already Running. Aborting"
	Start-Sleep 3
	Exit
}

$running = (Test-Path -Path '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\RUNNING.tmp')
If ($running) {
	"Someone else is running the system, please try again later"
	Start-Sleep 3
	Exit
}

If (Test-Path -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSRunAll.txt") {del "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSRunAll.txt" -ErrorAction SilentlyContinue}
Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSRunAll.txt" -Force -NoClobber -ErrorAction SilentlyContinue
New-Item -Path '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\RUNNING.tmp'
$computer = $osInfo = $compOSInfo = $null

"Welcome to the Stock File Fetcher Script (SFF). Don't click me.`n`n`n`n`n"
Set-PSDebug -Trace 0
$argString = $args
$thistime = (Get-Date).Hour
$day = (Get-Date).DayOfWeek.Value__
$timecheck = (8 -le $thistime) -and ($thistime -lt 13)
$daycheck = (1 -le $day) -and ($day -le 5)
$result = $timecheck -and $daycheck

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

"Moving 'Constant' Files'"
Get-ChildItem "\\DISKSTATION\Feeds\Stock File Fetcher\Upload\Warehouse" |
Foreach-Object {
	$supplier = $_.name
	$folderpath = $_.fullname
	cd "\\DISKSTATION\Feeds\Stock File Fetcher\Upload\Warehouse\$_"
	If ($result) {$file = $supplier + "-prime-zero.txt"}
	If (!$result) {$file = $supplier + "-prime.txt"}
	copy $file "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
	copy "\\DISKSTATION\Feeds\Stock File Fetcher\Upload\Warehouse\$_\$_.txt" "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
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
	Get-ChildItem "\\DISKSTATION\Feeds\Stock File Fetcher\Upload" -Filter *.txt |
  Foreach-Object {
		Start-Process excel $_ -Windowstyle maximized
  }
}

$argResult = String-Search $argstring "up-"
if ($argResult) {
	"Moving to Upload Folder"
	# Maps network drive with username and password (In a seperate file for Security Reasons)
	cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI"
	$lines = Get-Content STOCKMACHINE.txt
	$lines | ForEach-Object{Invoke-Expression $_}
	cd "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
  copy *.txt "Y:\production\outgoing"
	net use Y: /delete /y
}
del '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\RUNNING.tmp'
Stop-Transcript
