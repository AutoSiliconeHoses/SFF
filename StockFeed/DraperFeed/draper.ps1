Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSdraper.txt" -Force
$Host.UI.RawUI.WindowTitle = "DraperFeed"

Function alter($sku,$edit) {
  (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\draper.txt') -replace "$sku`t`t`t`t.+", "$sku`t`t`t`t$edit`targreplace" | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\draper.txt'
}

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\Scripts"
If (Test-Path -Path draper.csv) {del draper.csv}

"Acquiring File"
. "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\ftp.ps1"
gc login.txt | % {iex $_}
$LocalFile = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\Scripts\draper.csv"
Try {FTP-Download $RemoteFile $Username $Password $LocalFile}
Catch {
	"FTP Issue 1/2, trying again"
	Try {FTP-Download $RemoteFile $Username $Password $LocalFile}
	Catch {
		. "\\Diskstation\Feeds\SDK\Scripts\PowerBullet.ps1"
		gc "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\subscribed.txt" |
			% {Send-PushMessage -Type Email -Recipient $_ -Title "FTP Issue" -msg "2nd Attempt at running Draper FTP failed."}
		sleep 3
		EXIT
	}
}

"Processing File"
"OpenAndSave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning File"
Import-CSV "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\alterations.csv" | select sku,qty | ? {$_.sku.endswith("-DP")} | % {alter $_.sku $_.qty}

"Moving File to Upload folder"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed"
If (Test-Path -Path "\\DISKSTATION\Feeds\Dropship\Scripts\DP\DP.txt") {del "\\DISKSTATION\Feeds\Dropship\Scripts\DP\DP.txt"}
copy "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\draper.txt" "\\DISKSTATION\Feeds\Dropship\Scripts\DP\DP.txt"
move "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\draper.txt" "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
Stop-Transcript
