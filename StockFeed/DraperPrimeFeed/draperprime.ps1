Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSdraperprime.txt" -Force
$Host.UI.RawUI.WindowTitle = $title = 'DraperPrimeFeed'

# Time check conditions
$thistime = (Get-Date).Hour
$day = (Get-Date).DayOfWeek.Value__
$timecheck = (8 -le $thistime) -and ($thistime -lt 14)
$daycheck = (1 -le $day) -and ($day -le 5)
$result = $timecheck -and $daycheck

#$result = $TRUE

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperPrimeFeed\Scripts"
If (Test-Path -Path "draperprime.csv"){del draperprime.csv}

"Acquiring File"
. "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\ftp.ps1"
gc login.txt | % {iex $_}
$LocalFile = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperPrimeFeed\Scripts\draperprime.csv"
Try {FTP-Download $RemoteFile $Username $Password $LocalFile}
Catch {
	"FTP Issue 1/2, trying again"
	Try {FTP-Download $RemoteFile $Username $Password $LocalFile}
	Catch {
		. "\\Diskstation\Feeds\SDK\Scripts\PowerBullet.ps1"
		gc "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\subscribed.txt" |
			% {Send-PushMessage -Type Email -Recipient $_ -Title "FTP Issue" -msg "2nd Attempt at running $title FTP failed."}
		sleep 3
		EXIT
	}
}

If (!$result) {
  "SaveZero.ps1"
  & "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperPrimeFeed\Scripts\SaveZero.ps1" /C
}
If ($result) {
  "OpenAndSave.ps1"
  & "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperPrimeFeed\Scripts\OpenAndSave.ps1" /C
}

"Cleaning File"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperPrimeFeed"
# (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperPrimeFeed\draperprime.txt').replace("FALSE`t`t`t`t0", "") | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperPrimeFeed\draperprime.txt'
# (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperPrimeFeed\draperprime.txt')|?{$_.Trim(" `t")} | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperPrimeFeed\draperprime.txt'

"Moving File to Upload folder"
move draperprime.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
Stop-Transcript