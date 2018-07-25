$folderpath = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Error Reports"
cd $folderpath

#Filters reports of common errors and moves to seperate file
If (Test-Path "$folderpath\Input\PROCESSING*.txt") {
  gc "$folderpath\Input\PROCESSING*.txt" | ? {$_ -notmatch "13013`t"} | ? {$_.trim() -ne "" } | sc "$folderpath\Output\Out.txt"
}

#Tests for missing file
If (!(Test-Path "$folderpath\Input\PROCESSING*.txt")) {
  "No File Found"
	sleep 3
  EXIT
}

#Cleans up files
If (Test-Path "$folderpath\Input\PROCESSING*.txt") {del "$folderpath\Input\PROCESSING*.txt"}
If (Test-Path "$folderpath\Output\Warnings.txt") {del "$folderpath\Output\Warnings.txt"}
If (Test-Path "$folderpath\Output\Errors.txt") {del "$folderpath\Output\Errors.txt"}

#Splits the messages like Moses, Errors and Warnings
If ((gc "$folderpath\Output\Out.txt" | % {$_ -match "Error`t" -or "Warning`t"}) -contains $true) {
    gc "$folderpath\Output\Out.txt" | ? {$_ -match "Error`t"} | ? {$_.trim() -ne ""} | sc "$folderpath\Output\Errors.txt"
    gc "$folderpath\Output\Out.txt" | ? {$_ -match "Warning`t"} | ? {$_.trim() -ne ""} | sc "$folderpath\Output\Warnings.txt"
    If (Test-Path "$folderpath\Output\Out.txt") {del "$folderpath\Output\Out.txt"}
}
