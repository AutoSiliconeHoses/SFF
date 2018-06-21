$Host.UI.RawUI.WindowTitle = "StockFeed"

#Check if other instances of PowerShell are open
$process = get-process -Name 'powershell' | where {$_.mainWindowTitle -ne "StockFeed"}
If($process) {
	"PowerShell Already Running. Aborting"
	Start-Sleep 3
	Exit
}

#Check to see if other systems are running the script or if the script has failed on last run
$running = (Test-Path -Path '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\RUNNING.tmp')
If ($running) {
	"Someone else is running the system, please try again later"
	Start-Sleep 3
	Exit
}

#Start Transcript
If (Test-Path -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSRunAll.txt") {del "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSRunAll.txt" -ErrorAction SilentlyContinue}
Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSRunAll.txt" -Force  -ErrorAction SilentlyContinue

#Create RUNNING.tmp to stop other systems from running script
New-Item -Path '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\RUNNING.tmp'

#Clear system variables and start timer
Remove-Variable * -ErrorAction SilentlyContinue
$timer = [system.diagnostics.stopwatch]::StartNew()

#Checks a string for target
Function String-Search($string, $target) {
	$result = Select-string -pattern $target -InputObject $string
	If ($result) {return $true}
}

#Runs supplier when given name and ID
Function Run-Supplier($supplier, $id) {
	$argResult = String-Search $argString $id
	If ($argResult -or $RunAll) {
		"Loading $supplier"
		$loadString = "& '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\$supplier`Feed\$supplier.ps1'"
		Start PowerShell $loadstring -WindowStyle Hidden
		$i++
		Write-Progress -Activity 'Loading Scripts' -Status "Scripts Loaded: $i"
	}
}

#Changes arguement into a string that can be searched
$argString = $args

"Welcome to the Stock File Fetcher Script (SFF). Don't click me.`n`n`n`n`n"

"Scrapping old files"
cd '\\DISKSTATION\Feeds\Stock File Fetcher\Upload'
If (Test-Path -Path *.txt) {del *.txt}

#Runs suppliers using Run-Supplier
Write-Progress -Activity 'Loading Scripts' -Status "Scripts Loaded: $i"
$i = 0
$RunAll = String-Search $argString all-
.{
	Run-Supplier Decco 'dc-'
	Run-Supplier Draper 'dp-'
	Run-Supplier Febi 'fi-'
	Run-Supplier FPS 'fps-'
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
#Counts instances of PowerShell currently running apart from this one and updates user on the number
while (@(Get-Process | where-object {$_.ProcessName -like 'powershell'}).count -ne 1) {
  Write-Progress -Activity 'Running Scripts' -Status "Number of Scripts running: $i"
  sleep 1
  If ((@(Get-Process | where-object {$_.ProcessName -like 'powershell'}).count - 1) -ne $i){
    $i = @(Get-Process | where-object {$_.ProcessName -like 'powershell'}).count -1
  }
}

#Adds the warehouse stock file to the upload folder
$argResult = (String-Search $argstring "rp-") -or (String-Search $argstring "all-")
if ($argResult) {
	"Moving 'Constant' Files'"
	cd "\\DISKSTATION\Feeds\Stock File Fetcher\Upload\replenish"
	copy "replenish.txt" "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
}

"Modifying and cleaning files"
Write-Progress -Activity 'Modification' -Status "Cleaning..."
& '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\compile.ps1' $args[0] /C
Write-Progress -Activity 'Compiling' -Status "Compiled"

"Done"
#Opens the files in excel if told to by the user
$argResult = String-Search $argstring "op-"
if ($argResult) {
	cd "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
	Get-ChildItem "\\DISKSTATION\Feeds\Stock File Fetcher\Upload" -Filter *.txt | Where-Object {$_.name -NotMatch "replenish"} |
  Foreach-Object {
		Start-Process excel $_ -Windowstyle maximized
  }
}

#Maps STOCKMACHINE drive and moves files to Outgoing folder for AMTU (Uses txt as a script for security)
$argResult = String-Search $argstring "up-"
if ($argResult) {
	"Moving to Upload Folder"
	cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI"
	$lines = gc STOCKMACHINE.txt
	$lines | ForEach-Object{Invoke-Expression $_}
	cd "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
  copy *.txt "Y:\production\outgoing"
	net use Y: /delete /y
}

#Removes RUNNING.tmp so other users can run the script
del '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\RUNNING.tmp'

#Stops timer, shows the user how long it took and closes after 2 seconds
$timer.Stop()
$timer.Elapsed.Minutes.ToString() + "m " + $timer.Elapsed.Seconds.ToString() + "s"
Start-Sleep 2
Stop-Transcript
