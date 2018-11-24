$Host.UI.RawUI.WindowTitle = $title = "StockFeed"
# Time check conditions
$time = (Get-Date).Hour
$day = (Get-Date).DayOfWeek.Value__
$timecheck = (8 -le $time) -and ($time -lt 18)
$daycheck = (1 -le $day) -and ($day -le 5)
$working = $timecheck -and $daycheck
#$PSprocess = ps -Name 'powershell' | ? {$_.mainWindowTitle -ne "StockFeed"}
$XLprocess = ps |? {$_.processname -eq 'excel'}

. "\\Diskstation\Feeds\SDK\Scripts\PowerBullet.ps1"

# KILL TOGGLE
#$working = $false

If (!$working) {
	"WARNING: POWERSHELL SET TO KILL MODE OUTSIDE OF OFFICE HOURS"

	If($PSprocess) {
		"PowerShell Already Running. "
		"Killing other instances and logging."
		sleep 3
		ps Powershell  | ? { $_.ID -ne $pid }  | ForEach {
			$BadArgs += ($_.mainWindowTitle + ", ")
			spps $_.id
		}
		#PushBullet & Log Files
		gc "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\subscribed.txt" |
			% {Send-PushMessage -Type Email -Recipient $_ -Title "Error" -msg "PowerShell did not finish while running $BadArgs"}
		ac "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\PSKillList.txt" ($BadArgs)
		ac "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\PSKillList.txt" (Get-Date)
	}

	If($XLprocess) {
		"Excel Already Running. "
		"Killing other instances and logging."
		sleep 3
		ps | ? {$_.processname -eq 'excel'}| % {spps $_.id}
		ac "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\XLKillList.txt" (Get-Date)
	}
}

If ($working) {
	$running = (Test-Path -Path '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\RUNNING.tmp')
	If ($running) {
		"Someone else is running the system, please try again later"
		sleep 3
		Exit
	}
}


#Start Transcript
If (Test-Path -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSRunAll.txt") {del "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSRunAll.txt" -ErrorAction SilentlyContinue}
Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSRunAll.txt" -Force  -ErrorAction SilentlyContinue

#Create RUNNING.tmp to stop other systems from running script
New-Item -Path '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\RUNNING.tmp'

#Clear system variables and start timer
rv * -ErrorAction SilentlyContinue
$timer = [system.diagnostics.stopwatch]::StartNew()

#Checks a string for target
Function String-Search($string, $target) {
	$result = sls -pattern $target -InputObject $string
	If ($result) {return $true}
}

#Runs supplier when given name and ID
Function Run-Supplier($supplier, $id) {
	$argResult = String-Search $argString $id
	If ($argResult) {
		"Loading $supplier"
		# $loadString = "& '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\$supplier`Feed\$supplier.ps1'"
		$loadString = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\$supplier`Feed\$supplier.ps1"
		$global:predicted++
		#Start PowerShell $loadstring -WindowStyle Hidden
		Start-Job -Name ($supplier) -FilePath ($loadString) | Out-Null
	}
}

#Runs supplier when given name and ID
Function Run-All($supplier, $id) {
	"Loading $supplier"
	# $loadString = "& '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\$supplier`Feed\$supplier.ps1'"
	$loadString = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\$supplier`Feed\$supplier.ps1"
	$global:predicted++
	# Start PowerShell $loadstring -WindowStyle Hidden
	Start-Job -Name ($supplier) -FilePath ($loadString) | Out-Null
}

#Changes arguement into a string that can be searched
$argString = $args
$actual = 0
$predicted = 0

"Welcome to the Stock File Fetcher Script (SFF). Don't click me.`n`n`n`n`n"

"Scrapping old files"
cd '\\DISKSTATION\Feeds\Stock File Fetcher\Upload'
If (Test-Path -Path *.txt) {del *.txt}

"Loading Supplier Scripts"
$jobs = @()
$RunAll = String-Search $argString all-
If ($RunAll) {
	Run-All BizTools 'bz-'
	Run-All Draper 'dp-'
	Run-All HomeHardware 'hh-'
	Run-All ToolBank 'tb-'
	Run-All ToolBankPrime 'tbp-'
	Run-All ToolStream 'ts-'
}
If (!$RunAll) {
	Run-Supplier BizTools 'bz-'
	Run-Supplier Decco 'dc-'
	Run-Supplier DeccoPrime 'dcp-'
	Run-Supplier Draper 'dp-'
	Run-Supplier DraperPrime 'dpp-'
	Run-Supplier Febi 'fi-'
	Run-Supplier FPS 'fps-'
	Run-Supplier FPSPrime 'fpsp-'
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
Wait-Job * -timeout 300 | Out-Null

#Adds the warehouse stock file to the upload folder
$argResult = (String-Search $argstring "rp-") -or ($RunAll)
if ($argResult) {
	"Moving 'Constant' Files'"
	cd "\\DISKSTATION\Feeds\Stock File Fetcher\Upload\replenish"
	$global:predicted++
	cp "replenish.txt" "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
}

"Modifying and cleaning files"
Write-Progress -Activity 'Modification' -Status "Cleaning..."
	cd "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
	$lead = $args[0]
	"Replacing argreplace with $lead"
	gci "\\DISKSTATION\Feeds\Stock File Fetcher\Upload" -Filter *.txt | % {
	  $_
	  (gc $_).replace("argreplace", $lead) | sc $_
		$actual++
	}

	"Cleaning file"
	gci "\\DISKSTATION\Feeds\Stock File Fetcher\Upload" -Filter *.txt |	% {
		$_
	  (gc $_)| ?{$_.Trim(" `t")} | sc $_
	}
Write-Progress -Activity 'Compiling' -Status "Compiled"

"Done"
#Opens the files in excel if told to by the user
$argResult = String-Search $argstring "op-"
if ($argResult) {
	cd "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
	gci "\\DISKSTATION\Feeds\Stock File Fetcher\Upload" -Filter *.txt | ? {$_.name -NotMatch "replenish"} | % {
		saps excel $_ -Windowstyle maximized
  }
}

#Maps STOCKMACHINE drive and moves files to Outgoing folder for AMTU (Uses txt as a script for security)
$argResult = String-Search $argstring "up-"
if ($argResult) {
	"Moving to Upload Folder"
	# cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI"
	# $drive = gc STOCKMACHINE.txt
	# $drive | % {iex $_}
	cd "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
  cp *.txt "\\STOCKMACHINE\AmazonTransport\production\outgoing"
	# net use Y: /delete /y
}

#Checking if files are missing
If ($actual -ne $global:predicted) {
	"A file is missing, please check the log"
	sleep 3
	gc "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\subscribed.txt" |
		% {Send-PushMessage -Type Email -Recipient $_ -Title "Missing File" -msg "File/s missing while running $argString"}
}

#Removes RUNNING.tmp so other users can run the script
del '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\RUNNING.tmp'

#Stops timer, shows the user how long it took and closes after 2 seconds
$timer.Stop()
$timer.Elapsed.Minutes.ToString() + "m " + $timer.Elapsed.Seconds.ToString() + "s"
sleep 2
Stop-Transcript
