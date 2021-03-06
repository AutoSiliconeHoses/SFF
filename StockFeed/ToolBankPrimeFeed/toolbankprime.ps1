Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANStoolbankprime.txt" -Force
$Host.UI.RawUI.WindowTitle = 'ToolBankPrimeFeed'


Function alter($sku,$edit) {
  (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\toolbankprime.txt') -replace "$sku`t`t`t`t.+", "$sku`t`t`t`t$edit`targreplace" | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\toolbankprime.txt'
}

# Time check conditions
$thistime = (Get-Date).Hour
$day = (Get-Date).DayOfWeek.Value__
$timecheck = (7 -le $thistime) -and ($thistime -lt 12)
$daycheck = (1 -le $day) -and ($day -le 5)
$result = $timecheck -and $daycheck

#$result = $TRUE

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\Scripts"
If (Test-Path -Path "Availability20D.csv"){del Availability20D.csv}
If (Test-Path -Path "toolbankprimestock.csv"){del toolbankprimestock.csv}
If (Test-Path -Path "toolbankprime.csv"){del toolbankprime.csv}
If (Test-Path -Path "toolbankprime.txt"){del toolbankprime.csv}

"Acquiring File"
. "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\ftp.ps1"
gc login.txt | % {iex $_}
$LocalFile = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\Scripts\toolbankprime.csv"
Try {FTP-Download $RemoteFile $Username $Password $LocalFile}
Catch {
	"FTP Issue 1/2, trying again"
	Try {FTP-Download $RemoteFile $Username $Password $LocalFile}
	Catch {
		. "\\Diskstation\Feeds\SDK\Scripts\PowerBullet.ps1"
		gc "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\subscribed.txt" |
			% {Send-PushMessage -Type Email -Recipient $_ -Title "FTP Issue" -msg "2nd Attempt at running ToolBankPrime FTP failed."}
		sleep 3
		EXIT
	}
}

If ($result) {
  "SaveZero.ps1"
  & "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\Scripts\SaveZero.ps1" /C
}
If (!$result) {
  "OpenAndSave.ps1"
  & "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\Scripts\OpenAndSave.ps1" /C
}

"Cleaning File"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed"
Import-CSV "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\alterations.csv" | select sku,qty | ? {$_.sku.endswith("-TB-PRIME")} | % {alter $_.sku $_.qty}
# (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\toolbankprime.txt').replace("FALSE`t`t`t`t0", "") | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\toolbankprime.txt'
# (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\toolbankprime.txt')|?{$_.Trim(" `t")} | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\toolbankprime.txt'

"Moving File to Upload folder"
move toolbankprime.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
Stop-Transcript
