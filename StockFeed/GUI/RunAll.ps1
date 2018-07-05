$Host.UI.RawUI.WindowTitle = "StockFeed"

# Time check conditions
$time = (Get-Date).Hour
$day = (Get-Date).DayOfWeek.Value__
$timecheck = (8 -le $time) -and ($time -lt 18)
$daycheck = (1 -le $day) -and ($day -le 5)
$working = $timecheck -and $daycheck
$process = Get-Process -Name 'powershell' | where {$_.mainWindowTitle -ne "StockFeed"}
# KILL TOGGLE
#$working = $false

If (!$working) {
	"WARNING: POWERSHELL SET TO KILL MODE OUTSIDE OF OFFICE HOURS"

	#Kill other PowerShell instances
	If($process) {
		"PowerShell Already Running. "
		"Killing other instances and logging."
		Start-Sleep 3
		Get-Process Powershell  | Where-Object { $_.ID -ne $pid } | Stop-Process
		get-process |? {$_.processname -eq 'excel'}|%{stop-process $_.id}
		Add-Content "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\KillList.txt" (Get-Date)
	}
}

If ($working) {
	#Check to see if other systems are running the script or if the script has failed on last run
	$running = (Test-Path -Path '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\RUNNING.tmp')
	If ($running) {
		"Someone else is running the system, please try again later"
		Start-Sleep 3
		Exit
	}

	If($process) {
		"PowerShell Already Running. "
		Start-Sleep 3
		EXIT
	}
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
	If ($argResult) {
		"Loading $supplier"
		$loadString = "& '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\$supplier`Feed\$supplier.ps1'"
		Start PowerShell $loadstring #-WindowStyle Hidden
	}
}

#Runs supplier when given name and ID
Function Run-All($supplier, $id) {
	"Loading $supplier"
	$loadString = "& '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\$supplier`Feed\$supplier.ps1'"
	Start PowerShell $loadstring -WindowStyle Hidden
}

#Changes arguement into a string that can be searched
$argString = $args

"Welcome to the Stock File Fetcher Script (SFF). Don't click me.`n`n`n`n`n"

"Scrapping old files"
cd '\\DISKSTATION\Feeds\Stock File Fetcher\Upload'
If (Test-Path -Path *.txt) {del *.txt}

"Loading Supplier Scripts"
$RunAll = String-Search $argString all-
If ($RunAll) {
	Run-All BizTools 'bz-'
	Run-All Draper 'dp-'
	Run-All HomeHardware 'hh-'
	Run-All Sealey 'sy-'
	Run-All Stax 'sx-'
	Run-All StaxPrime 'sxp-'
	Run-All ToolBank 'tb-'
	Run-All ToolStream 'ts-'
}
If (!$RunAll) {
	Run-All BizTools 'bz-'
	Run-Supplier Decco 'dc-'
	Run-Supplier Draper 'dp-'
	Run-Supplier Febi 'fi-'
	Run-Supplier FPS 'fps-'
	Run-Supplier HomeHardware 'hh-'
	Run-Supplier KYB 'kb-'
	Run-Supplier Mintex 'mx-'
	Run-Supplier Sealey 'sy-'.
	Run-Supplier Stax 'sx-'.
	Run-Supplier StaxPrime 'sxp-'
	Run-Supplier Tetrosyl 'tl-'
	Run-Supplier ToolBank 'tb-'
	Run-Supplier ToolBankPrime 'tbp-'
	Run-Supplier ToolStream 'ts-'
	Run-Supplier WorkshopWarehouse 'ww-'
}

"Finished loading supplier scripts"

"Waiting for Scripts to finish"
#Counts instances of PowerShell currently running apart from this one and updates user on the number
$i = 0
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
