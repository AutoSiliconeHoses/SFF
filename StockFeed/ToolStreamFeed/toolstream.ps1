Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANStoolstream.txt" -Force
$Host.UI.RawUI.WindowTitle = "ToolStreamFeed"

Function alter($sku,$edit) {
  (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt') -replace "$sku`t`t`t`t.+", "$sku`t`t`t`t$edit`targreplace" | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt'
}


"Acquiring File"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\Scripts"
If (Test-Path -Path "toolstream.xls") {del "toolstream.xls"}

. "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\ftp.ps1"
gc login.txt | % {iex $_}
$LocalFile = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\Scripts\toolstream.xls"
Try {FTP-Download $RemoteFile $Username $Password $LocalFile}
Catch {
	"FTP Issue 1/2, trying again"
	Try {FTP-Download $RemoteFile $Username $Password $LocalFile}
	Catch {
		. "\\Diskstation\Feeds\SDK\Scripts\PowerBullet.ps1"
		gc "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\subscribed.txt" |
			% {Send-PushMessage -Type Email -Recipient $_ -Title "FTP Issue" -msg "2nd Attempt at running ToolStream FTP failed."}
		sleep 3
		EXIT
	}
}

"OpenAndSave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning File"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed"
Import-CSV "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\alterations.csv" | select sku,qty | ? {$_.sku.endswith("-TS")} | % {alter $_.sku $_.qty}
# (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt').replace("#REF!`t`t`t`t#REF!`targreplace", "") | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt'

"Moving File to Upload folder"
If (Test-Path -Path "\\DISKSTATION\Feeds\Dropship\Scripts\TS\TS.txt") {del "\\DISKSTATION\Feeds\Dropship\Scripts\TS\TS.txt"}
copy "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt" "\\DISKSTATION\Feeds\Dropship\Scripts\TS\TS.txt"
move "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolStreamFeed\toolstream.txt" "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
Stop-Transcript
